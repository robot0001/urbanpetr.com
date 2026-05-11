<script setup lang="ts">
import type { HistoryItem } from '~/composables/useYoutubeHistory'

const props = defineProps<{ item: HistoryItem }>()
const emit = defineEmits<{ (e: 'toggled', uuid: string, newActive: boolean): void }>()

const { public: { apiBase } } = useRuntimeConfig()
const toggling = ref(false)

async function toggle() {
  toggling.value = true
  try {
    const action = props.item.active ? 'deactivate' : 'activate'
    await $fetch(`${apiBase}/v1/history/youtube/${props.item.uuid}/${action}`, { method: 'POST' })
    emit('toggled', props.item.uuid, !props.item.active)
  } finally {
    toggling.value = false
  }
}

function formatCount(n: number | null): string | null {
  if (n === null || n === undefined) return null
  if (n >= 1_000_000) return `${(n / 1_000_000).toFixed(1)}M`
  if (n >= 1_000) return `${(n / 1_000).toFixed(1)}K`
  return String(n)
}
</script>

<template lang="pug">
div(:class="['flex gap-4 p-4 rounded-lg border bg-gray-900 border-gray-800 transition-opacity', { 'opacity-40': !item.active }]")
  a(:href="item.video.url" target="_blank" rel="noopener" class="shrink-0")
    div(class="w-32 aspect-video rounded overflow-hidden bg-gray-800 flex items-center justify-center")
      img(
        v-if="item.video.thumbnail_url"
        :src="item.video.thumbnail_url"
        :alt="item.video.title"
        class="w-full h-full object-cover"
      )
      i(v-else class="pi pi-youtube text-2xl text-gray-600")

  div(class="flex flex-col flex-1 min-w-0 gap-1")
    div(class="flex items-start justify-between gap-4")
      div(class="flex-1 min-w-0")
        a(
          :href="item.video.url"
          target="_blank"
          rel="noopener"
          class="font-medium text-gray-100 hover:text-orange-400 line-clamp-2 leading-snug block"
        ) {{ item.video.title }}
        p(class="text-sm text-gray-400 mt-1 truncate")
          span(v-if="item.video.channel") {{ item.video.channel }}
          span(v-if="item.video.channel") &nbsp;·&nbsp;
          span Watched {{ item.watched_at.formatted }}
      Button(
        :label="item.active ? 'Deactivate' : 'Activate'"
        :severity="item.active ? 'secondary' : 'success'"
        size="small"
        :loading="toggling"
        class="shrink-0 self-start"
        @click="toggle"
      )

    div(class="flex items-center gap-2 mt-auto pt-1 text-xs text-gray-500 flex-wrap")
      span(v-if="item.video.duration") {{ item.video.duration.formatted }}
      span(
        :class="item.video.type === 'short' ? 'bg-purple-900/60 text-purple-300' : 'bg-blue-900/60 text-blue-300'"
        class="px-1.5 py-0.5 rounded"
      ) {{ item.video.type }}
      template(v-if="formatCount(item.video.view_count)")
        span · {{ formatCount(item.video.view_count) }} views
      template(v-if="formatCount(item.video.like_count)")
        span · {{ formatCount(item.video.like_count) }} likes
      template(v-if="item.video.published_at")
        span · Published {{ item.video.published_at.formatted }}
</template>
