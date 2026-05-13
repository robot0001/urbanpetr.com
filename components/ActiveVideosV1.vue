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
    class="mb-5 last:mb-0 pb-5 last:pb-0 border-b last:border-b-0 border-white/10"
  )
    a(:href="item.video.url" target="_blank" rel="noopener" class="block group")
      p(
        v-if="item.comment"
        class="text-sm leading-snug mb-2 italic"
        style="color: var(--p-primary-300)"
      ) "{{ item.comment }}"
      div(class="flex gap-2.5 items-start")
        img(
          v-if="item.video.thumbnail_url"
          :src="item.video.thumbnail_url"
          :alt="item.video.title"
          class="w-16 aspect-video object-cover rounded flex-shrink-0 mt-0.5"
        )
        div(class="min-w-0 flex-1")
          p(
            class="text-xs font-medium leading-snug line-clamp-2 group-hover:text-orange-400 transition-colors"
            :class="{ 'mb-0.5': !item.comment }"
          ) {{ item.video.title }}
          p(class="text-xs truncate mt-0.5" style="color: var(--p-text-muted-color)")
            span(v-if="item.video.channel") {{ item.video.channel }}
            span(v-if="item.video.channel")  ·
            span {{ item.watched_at.formatted }}
</template>
