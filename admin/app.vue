<script setup lang="ts">
const route = useRoute()
const router = useRouter()
const { userEmail, logout } = useAuth()
const { isDark, toggleTheme } = useTheme()

const showNav = computed(() => route.path !== '/login' && route.path !== '/auth-callback')

const youtubeMenu = ref()
const youtubeItems = [
  { label: 'Active', icon: 'pi pi-play', command: () => router.push('/') },
  { label: 'All', icon: 'pi pi-list', command: () => router.push('/all') },
]
</script>

<template lang="pug">
div(class="min-h-screen bg-gray-50 dark:bg-gray-950 text-gray-900 dark:text-gray-100")
  nav(v-if="showNav" class="border-b border-gray-200 dark:border-white/10 px-4 md:px-6 py-3 flex items-center gap-2 md:gap-4")
    span(class="font-semibold text-orange-500 dark:text-orange-400 mr-2") Admin
    div(class="relative")
      Button(
        label="YouTube"
        icon="pi pi-chevron-down"
        iconPos="right"
        text
        size="small"
        @click="youtubeMenu.toggle($event)"
      )
      Menu(ref="youtubeMenu" popup :model="youtubeItems")
    div(class="ml-auto flex items-center gap-1 md:gap-3")
      span(class="hidden md:block text-sm text-gray-500 mr-2") {{ userEmail }}
      Button(
        :icon="isDark ? 'pi pi-sun' : 'pi pi-moon'"
        text
        rounded
        severity="secondary"
        size="small"
        :aria-label="isDark ? 'Switch to light mode' : 'Switch to dark mode'"
        @click="toggleTheme"
      )
      Button(
        label="Sign out"
        text
        severity="secondary"
        size="small"
        @click="logout"
      )
  main(class="px-4 md:px-6 py-6 md:py-8 max-w-5xl mx-auto")
    NuxtPage
</template>
