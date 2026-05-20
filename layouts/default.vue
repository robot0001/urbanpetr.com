<script setup lang="ts">
const route = useRoute()
const myStuffOpen = ref(false)

const isMyStuff = computed(() => route.path.startsWith('/my-stuff'))
watch(() => route.path, () => { myStuffOpen.value = false })
</script>

<template lang="pug">
nav(class="sticky top-0 z-50 border-b backdrop-blur-sm bg-white/80 dark:bg-black/80")
  ul(class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-3 flex gap-6 list-none m-0")
    li
      NuxtLink(to="/") Home
    li
      NuxtLink(to="/about") About
    li(class="relative")
      button(
        @click="myStuffOpen = !myStuffOpen"
        class="flex items-center gap-1.5 cursor-pointer"
        :class="isMyStuff ? 'text-orange-500' : ''"
      )
        span My Stuff
        i(
          class="pi pi-chevron-down text-xs transition-transform duration-200"
          :class="myStuffOpen ? 'rotate-180' : ''"
        )
      div(v-if="myStuffOpen" class="fixed inset-0 z-40" @click="myStuffOpen = false")
      div(
        v-if="myStuffOpen"
        class="absolute top-full left-0 mt-2 z-50 min-w-max rounded-lg border border-white/10 py-1 backdrop-blur-sm dark:bg-black/90"
      )
        NuxtLink(
          to="/my-stuff/now-watching"
          class="block px-4 py-2 text-sm transition-colors hover:text-orange-400"
          @click="myStuffOpen = false"
        ) Now Watching

main(class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-12")
  slot
</template>

<style scoped>
a {
  color: inherit;
}
a.router-link-exact-active {
  color: theme('colors.orange.500');
}
</style>
