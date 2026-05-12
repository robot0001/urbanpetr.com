export default defineEventHandler(async (event) => {
  const { code, code_verifier, redirect_uri } = await readBody(event)
  const config = useRuntimeConfig()
  const domain = config.public.cognitoDomain as string
  const clientId = config.public.cognitoClientId as string

  const body = new URLSearchParams({
    grant_type: 'authorization_code',
    client_id: clientId,
    code,
    redirect_uri,
    code_verifier,
  })

  console.log('[token] request', { domain, clientId, code, redirect_uri, code_verifier: code_verifier?.slice(0, 16) })

  const res = await fetch(`https://${domain}/oauth2/token`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: body.toString(),
  })

  const data = await res.json()
  console.log('[token] cognito response', res.status, JSON.stringify(data))

  if (!res.ok) {
    throw createError({ statusCode: res.status, statusMessage: data.error_description ?? data.error })
  }

  return data
})
