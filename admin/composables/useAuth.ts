const TOKEN_KEY = 'cognito_access_token'
const EMAIL_KEY = 'cognito_user_email'
const VERIFIER_KEY = 'cognito_pkce_verifier'

function base64urlEncode(bytes: Uint8Array): string {
  let bin = ''
  for (const b of bytes) bin += String.fromCharCode(b)
  return btoa(bin).replace(/\+/g, '-').replace(/\//g, '_').replace(/=/g, '')
}

async function generateVerifier(): Promise<string> {
  return base64urlEncode(crypto.getRandomValues(new Uint8Array(64)))
}

async function generateChallenge(verifier: string): Promise<string> {
  const hash = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(verifier))
  return base64urlEncode(new Uint8Array(hash))
}

function decodeJwtPayload(token: string): Record<string, unknown> | null {
  try {
    const payload = token.split('.')[1]
    return JSON.parse(atob(payload.replace(/-/g, '+').replace(/_/g, '/')))
  } catch {
    return null
  }
}

export function useAuth() {
  const config = useRuntimeConfig()
  const domain = config.public.cognitoDomain as string
  const clientId = config.public.cognitoClientId as string

  const token = useState<string | null>(TOKEN_KEY, () =>
    process.client ? sessionStorage.getItem(TOKEN_KEY) : null
  )
  const userEmail = useState<string | null>(EMAIL_KEY, () =>
    process.client ? sessionStorage.getItem(EMAIL_KEY) : null
  )

  const isAuthenticated = computed(() => !!token.value)
  const isConfigured = !!(domain && clientId)

  async function login() {
    if (!domain || !clientId) throw new Error('Auth not configured — missing Cognito env vars')
    const verifier = await generateVerifier()
    const challenge = await generateChallenge(verifier)
    sessionStorage.setItem(VERIFIER_KEY, verifier)
    const params = new URLSearchParams({
      response_type: 'code',
      client_id: clientId,
      redirect_uri: `${window.location.origin}/callback`,
      scope: 'email openid',
      code_challenge: challenge,
      code_challenge_method: 'S256',
      identity_provider: 'Google',
    })
    window.location.href = `https://${domain}/oauth2/authorize?${params}`
  }

  async function exchangeCode(code: string): Promise<void> {
    const verifier = sessionStorage.getItem(VERIFIER_KEY)
    if (!verifier) throw new Error('PKCE verifier missing — try signing in again')
    const redirectUri = `${window.location.origin}/callback`

    const res = await fetch(`https://${domain}/oauth2/token`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        grant_type: 'authorization_code',
        client_id: clientId,
        code,
        redirect_uri: redirectUri,
        code_verifier: verifier,
      }).toString(),
    })

    const data = await res.json()
    if (!res.ok) {
      throw new Error(data.error_description ?? data.error ?? 'Token exchange failed')
    }

    sessionStorage.removeItem(VERIFIER_KEY)
    sessionStorage.setItem(TOKEN_KEY, data.access_token)
    token.value = data.access_token
    // email lives in the ID token; store it separately so we don't keep the ID token around
    if (data.id_token) {
      const email = (decodeJwtPayload(data.id_token)?.email as string) ?? null
      if (email) sessionStorage.setItem(EMAIL_KEY, email)
      userEmail.value = email
    }
  }

  function logout() {
    sessionStorage.removeItem(TOKEN_KEY)
    sessionStorage.removeItem(EMAIL_KEY)
    token.value = null
    userEmail.value = null
    if (!domain || !clientId) return
    const params = new URLSearchParams({
      client_id: clientId,
      logout_uri: window.location.origin,
    })
    window.location.href = `https://${domain}/logout?${params}`
  }

  return { token, isAuthenticated, isConfigured, userEmail, login, exchangeCode, logout }
}
