<script setup lang="ts">
const { public: { apiBase } } = useRuntimeConfig()

const { data: health, status: fetchStatus } = useFetch<{ status: string }>(`${apiBase}/health`, {
  server: false
})
</script>

<template lang="pug">
div(class="space-y-8")
  //- Intro card
  div(class="bg-white border-[2px] border-flat-dark shadow-[6px_6px_0px_rgba(17,26,46,1)]")
    div(class="px-6 py-4 border-b-[2px] border-flat-dark bg-flat-yellow")
      h2(class="font-display font-black text-base tracking-widest uppercase text-flat-dark") Hey there
    div(class="px-6 py-5")
      p(class="font-sans text-base text-zinc-700 leading-relaxed") Computer enthusiast who's deeply into software development, team leadership, and currently obsessed with AI tools and what they can do.

  div(class="flex flex-col lg:flex-row gap-6")
    //- Main content
    div(class="flex flex-col gap-6 lg:w-2/3")
      div(class="bg-white border-[2px] border-flat-dark shadow-[6px_6px_0px_rgba(17,26,46,1)]")
        div(class="px-6 py-4 border-b-[2px] border-flat-dark")
          h3(class="font-display font-black text-base tracking-tight text-flat-dark") What I'm Into Right Now
        div(class="px-6 py-5 space-y-3 font-sans text-base text-zinc-700 leading-relaxed")
          p Deeply into AI — not just using it, but understanding it. What can you actually run locally? How do agents work in practice? What does it mean to build with them? These are the questions keeping me busy.
          p
            strong(class="text-flat-dark") Claude Code
            |  has become a core part of how I work. Less about shortcuts, more about thinking differently about the whole development loop.
          p
            strong(class="text-flat-dark") Open Claw
            |  and
            strong(class="text-flat-dark")  hermes-agent
            |  are the kind of things you can't stop thinking about.

    //- Sidebar
    div(class="flex flex-col gap-6 lg:w-1/3")
      div(class="bg-white border-[2px] border-flat-dark shadow-[6px_6px_0px_rgba(17,26,46,1)]")
        div(class="px-6 py-4 border-b-[2px] border-flat-dark")
          h3(class="font-display font-black text-base tracking-tight text-flat-dark") Links
        div(class="px-6 py-5")
          ul(class="space-y-2 list-none m-0 p-0")
            li
              a(href="https://json.city" target="_blank" class="font-mono text-sm font-bold text-flat-terracotta hover:underline") json.city
          div(class="mt-4 pt-4 border-t-[2px] border-flat-dark/10 flex items-center gap-2 text-sm font-mono")
            span(class="text-zinc-500 font-bold") API
            span(
              :class="health?.status === 'ok' ? 'text-green-600 font-bold' : fetchStatus === 'error' ? 'text-red-500 font-bold' : 'text-zinc-400'"
            ) {{ health?.status === 'ok' ? '● ok' : fetchStatus === 'error' ? '● unavailable' : '○ …' }}

      ActiveVideos(:items-per-page="5")
</template>
