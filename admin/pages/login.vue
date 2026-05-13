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
div(class="min-h-screen flex items-center justify-center p-4")
  Card(class="w-full max-w-sm text-center")
    template(#content)
      div(class="space-y-6 py-2")
        h1(class="text-2xl font-semibold") Admin
        template(v-if="isConfigured")
          p(class="text-sm") Sign in to continue.
          Message(v-if="error" severity="error" :closable="false") {{ error }}
          Button(
            label="Sign in with Google"
            icon="pi pi-google"
            class="w-full"
            @click="handleLogin"
          )
        template(v-else)
          Message(severity="error" :closable="false") Auth is not configured (missing Cognito env vars).
</template>
