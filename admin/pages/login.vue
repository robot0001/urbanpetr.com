<script setup lang="ts">
const { isAuthenticated, login, isConfigured } = useAuth()
const router = useRouter()
const error = ref<string | null>(null)

onMounted(() => {
  if (isAuthenticated.value) router.replace('/')
})

async function handleLogin() {
  error.value = null
  try {
    await login()
  } catch (e: any) {
    error.value = e?.message ?? 'Sign-in failed — please try again.'
  }
}
</script>

<template lang="pug">
div(class="min-h-screen bg-gray-950 text-gray-100 flex items-center justify-center")
  div(class="text-center space-y-6")
    h1(class="text-2xl font-semibold text-orange-400") Admin
    template(v-if="isConfigured")
      p(class="text-gray-400 text-sm") Sign in to continue.
      p(v-if="error" class="text-red-400 text-sm") {{ error }}
      button(
        class="px-6 py-3 bg-orange-600 hover:bg-orange-500 text-white rounded-lg font-medium transition-colors cursor-pointer"
        @click="handleLogin"
      ) Sign in with Google
    template(v-else)
      p(class="text-red-400 text-sm") Auth is not configured (missing Cognito env vars).
</template>
