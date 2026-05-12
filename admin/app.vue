<script setup lang="ts">
const route = useRoute()
const youtubeOpen = ref(false)
const { userEmail, logout } = useAuth()

const showNav = computed(() => route.path !== '/login' && route.path !== '/callback')
</script>

<template lang="pug">
div(class="min-h-screen bg-gray-950 text-gray-100")
  nav(v-if="showNav" class="border-b border-white/10 px-6 py-4 flex items-center gap-6")
    span(class="font-semibold text-orange-400") Admin
    div(class="relative")
      div(
        v-if="youtubeOpen"
        class="fixed inset-0 z-40"
        @click="youtubeOpen = false"
      )
      button(
        class="relative z-50 flex items-center gap-1 text-sm text-gray-400 hover:text-gray-100"
        :class="{ '!text-white font-medium': youtubeOpen }"
        @click="youtubeOpen = !youtubeOpen"
      )
        | YouTube
        span(class="text-xs opacity-60") ▾
      div(
        v-if="youtubeOpen"
        class="absolute top-full left-0 mt-2 bg-gray-900 border border-white/10 rounded shadow-lg py-1 min-w-[120px] z-50"
        @click="youtubeOpen = false"
      )
        NuxtLink(
          to="/"
          class="block px-4 py-2 text-sm text-gray-400 hover:text-gray-100 hover:bg-white/5"
          active-class="!text-white font-medium"
        ) Active
        NuxtLink(
          to="/all"
          class="block px-4 py-2 text-sm text-gray-400 hover:text-gray-100 hover:bg-white/5"
          active-class="!text-white font-medium"
        ) All
    div(class="ml-auto flex items-center gap-4")
      span(class="text-sm text-gray-500") {{ userEmail }}
      button(
        class="text-sm text-gray-400 hover:text-gray-100"
        @click="logout"
      ) Sign out
  main(class="px-6 py-8 max-w-5xl mx-auto")
    NuxtPage
</template>
