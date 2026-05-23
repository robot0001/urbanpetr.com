<script setup lang="ts">
const route = useRoute()
const router = useRouter()
const { exchangeCode } = useAuth()

const error = ref<string | null>(null)

onMounted(async () => {
  const code = route.query.code as string | undefined
  const state = route.query.state as string | undefined
  const errorParam = route.query.error as string | undefined

  if (errorParam) {
    error.value = `Sign-in failed: ${route.query.error_description ?? errorParam}`
    return
  }

  if (!code) {
    error.value = 'No authorisation code received.'
    return
  }

  try {
    await exchangeCode(code)
    const redirect = state && state.startsWith('/') && !state.startsWith('//') ? state : '/'
    await router.replace(redirect)
  } catch (e: any) {
    const msg = e?.message ?? 'Token exchange failed — please try again.'
    console.error('[auth-callback] token exchange failed:', e)
    error.value = msg
  }
})
</script>

<template lang="pug">
div(class="min-h-screen flex items-center justify-center p-4")
  div(class="text-center space-y-4")
    template(v-if="error")
      Message(severity="error" :closable="false") {{ error }}
      Button(label="Back to home" text severity="secondary" @click="$router.push('/')")
    template(v-else)
      ProgressSpinner(strokeWidth="4" style="width: 2.5rem; height: 2.5rem")
      p(class="text-sm mt-2") Signing in…
</template>
