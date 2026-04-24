<template lang="pug">
nav(class="sticky top-0 z-50 border-b backdrop-blur-sm bg-white/80 dark:bg-black/80")
  ul(class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-3 flex gap-6 list-none m-0")
    li
      NuxtLink(to="/") Home
    li
      NuxtLink(to="/about") About
main(class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-12")
  slot
</template>
