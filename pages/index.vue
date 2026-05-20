<script setup lang="ts">
const { public: { apiBase } } = useRuntimeConfig()

const { data: health, status: fetchStatus } = useFetch<{ status: string }>(`${apiBase}/health`, {
  server: false
})
</script>

<template lang="pug">
Panel(header="Hey there" class="mb-8")
  p Computer enthusiast who's deeply into software development, team leadership, and currently obsessed with AI tools and what they can do.

div(class="flex flex-col lg:flex-row gap-6")
  div(class="flex flex-col gap-6 lg:w-2/3")
    Card
      template(#title) What I'm Into Right Now
      template(#content)
        p Deeply into AI — not just using it, but understanding it. What can you actually run locally? How do agents work in practice? What does it mean to build with them? These are the questions keeping me busy.
        p
          strong Claude Code
          | &nbsp;has become a core part of how I work. Less about shortcuts, more about thinking differently about the whole development loop.
        p
          strong Open Claw
          |  and
          strong hermes-agent
          | &nbsp;are the kind of things you can't stop thinking about.

  div(class="flex flex-col gap-6 lg:w-1/3")
    Panel(header="Links")
      ul
        li
          a(href="https://json.city" target="_blank") json.city
      div(class="mt-4 pt-4 border-t border-white/10 text-sm flex items-center gap-2")
        span(class="text-gray-400") API
        span(
          :class="health?.status === 'ok' ? 'text-green-400' : fetchStatus === 'error' ? 'text-red-400' : 'text-gray-500'"
        ) {{ health?.status === 'ok' ? '● ok' : fetchStatus === 'error' ? '● unavailable' : '○ …' }}

    ActiveVideos(:items-per-page="5")
</template>
