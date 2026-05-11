<template lang="pug">
div(class="min-h-screen bg-gray-950 text-gray-100")
  nav(class="border-b border-white/10 px-6 py-4 flex items-center gap-6")
    span(class="font-semibold text-orange-400") Admin
    NuxtLink(to="/" class="text-sm text-gray-400 hover:text-gray-100") Active
    NuxtLink(to="/all" class="text-sm text-gray-400 hover:text-gray-100") All
  main(class="px-6 py-8 max-w-5xl mx-auto")
    NuxtPage
</template>
