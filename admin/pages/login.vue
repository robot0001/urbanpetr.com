<script setup lang="ts">
const { isAuthenticated, login } = useAuth()
const router = useRouter()

onMounted(() => {
  if (isAuthenticated.value) router.replace('/')
})
</script>

<template lang="pug">
div(class="min-h-screen bg-gray-950 text-gray-100 flex items-center justify-center")
  div(class="text-center space-y-6")
    h1(class="text-2xl font-semibold text-orange-400") Admin
    p(class="text-gray-400 text-sm") Sign in to continue.
    button(
      class="px-6 py-3 bg-orange-600 hover:bg-orange-500 text-white rounded-lg font-medium transition-colors"
      @click="login"
    ) Sign in with Google
</template>
