<script setup lang="ts">
const router = useRouter()
const { exchangeCode } = useAuth()

const error = ref<string | null>(null)

// The inline <head> script in nuxt.config saves location.search to sessionStorage
// before Nuxt's router plugin can strip the query string during prerendered
// page hydration. Read it here and clear it immediately.
const capturedSearch = process.client ? (sessionStorage.getItem('__qs__') ?? '') : ''
if (process.client) sessionStorage.removeItem('__qs__')

onMounted(async () => {
  const params = new URLSearchParams(capturedSearch)
  const code = params.get('code') ?? undefined
  const errorParam = params.get('error') ?? undefined

  if (errorParam) {
    error.value = `Sign-in failed: ${params.get('error_description') ?? errorParam}`
    return
  }

  if (!code) {
    error.value = 'No authorisation code received.'
    return
  }

  try {
    await exchangeCode(code)
    await router.replace('/')
  } catch (e: any) {
    const msg = e?.message ?? 'Token exchange failed — please try again.'
    console.error('[callback] token exchange failed:', e)
    error.value = msg
  }
})
</script>

<template lang="pug">
div(class="min-h-screen bg-gray-950 text-gray-100 flex items-center justify-center")
  div(class="text-center")
    template(v-if="error")
      p(class="text-red-400 mb-4") {{ error }}
      NuxtLink(to="/" class="text-orange-400 hover:underline") Back to home
    template(v-else)
      p(class="text-gray-400") Signing in…
</template>
