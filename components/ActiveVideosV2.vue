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
    class="mb-4 last:mb-0"
  )
    a(:href="item.video.url" target="_blank" rel="noopener" class="block group rounded-xl overflow-hidden border border-white/10 hover:border-orange-500/40 transition-colors")
      div(class="relative aspect-video bg-white/5 overflow-hidden")
        img(
          v-if="item.video.thumbnail_url"
          :src="item.video.thumbnail_url"
          :alt="item.video.title"
          class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
        )
        div(v-else class="w-full h-full flex items-center justify-center")
          i(class="pi pi-youtube text-3xl text-white/20")
      div(class="p-3 flex flex-col gap-1.5")
        div(
          v-if="item.comment"
          class="text-xs leading-snug italic px-2 py-1.5 rounded"
          style="background: color-mix(in srgb, var(--p-primary-color) 12%, transparent); color: var(--p-primary-300); border-left: 2px solid var(--p-primary-color)"
        ) "{{ item.comment }}"
        p(class="text-xs font-medium leading-snug line-clamp-2 group-hover:text-orange-400 transition-colors") {{ item.video.title }}
        p(class="text-xs truncate" style="color: var(--p-text-muted-color)")
          span(v-if="item.video.channel") {{ item.video.channel }}
          span(v-if="item.video.channel")  ·
          span {{ item.watched_at.formatted }}
</template>
