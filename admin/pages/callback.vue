<script setup lang="ts">
const route = useRoute()
const router = useRouter()
const { exchangeCode } = useAuth()

const error = ref<string | null>(null)

onMounted(async () => {
  const code = route.query.code as string | undefined
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
    await router.replace('/')
  } catch (e: any) {
    error.value = e?.message ?? 'Token exchange failed — please try again.'
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
