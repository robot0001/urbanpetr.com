<script setup lang="ts">
import type { HistoryItem } from '~/types/youtube'
defineProps<{ items: HistoryItem[] }>()
</script>

<template lang="pug">
Panel(header="Now Watching")
  div(v-if="!items.length" class="text-sm" style="color: var(--p-text-muted-color)") Nothing active right now.
  div(
    v-for="item in items"
    :key="item.uuid"
    class="flex gap-3 items-start py-3 first:pt-0 last:pb-0 border-b last:border-b-0 border-white/10"
  )
    a(:href="item.video.url" target="_blank" rel="noopener" class="block shrink-0")
      div(class="w-12 aspect-video rounded overflow-hidden bg-white/5")
        img(
          v-if="item.video.thumbnail_url"
          :src="item.video.thumbnail_url"
          :alt="item.video.title"
          class="w-full h-full object-cover"
        )
        div(v-else class="w-full h-full flex items-center justify-center")
          i(class="pi pi-youtube text-xs text-white/20")
    a(:href="item.video.url" target="_blank" rel="noopener" class="group min-w-0 flex-1")
      p(
        v-if="item.comment"
        class="text-xs font-semibold leading-snug mb-0.5 group-hover:text-orange-400 transition-colors"
      ) {{ item.comment }}
      p(
        class="text-xs leading-snug line-clamp-2"
        :class="item.comment ? 'text-gray-500' : 'font-medium group-hover:text-orange-400 transition-colors'"
        :style="item.comment ? { color: 'var(--p-text-muted-color)' } : {}"
      ) {{ item.video.title }}
      p(class="text-xs mt-0.5 truncate" style="color: var(--p-text-muted-color); opacity: 0.7")
        span(v-if="item.video.channel") {{ item.video.channel }}
        span(v-if="item.video.channel")  ·
        span {{ item.watched_at.formatted }}
</template>
