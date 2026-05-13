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
    class="mb-6 last:mb-0 pb-6 last:pb-0 border-b last:border-b-0 border-white/10"
  )
    a(:href="item.video.url" target="_blank" rel="noopener" class="block group")
      p(
        v-if="item.comment"
        class="text-base leading-relaxed italic mb-2 group-hover:text-orange-300 transition-colors"
        style="color: var(--p-primary-200)"
      ) "{{ item.comment }}"
      p(
        class="text-xs leading-snug line-clamp-2 mb-1"
        :class="item.comment ? '' : 'font-semibold group-hover:text-orange-400 transition-colors'"
        style="color: var(--p-text-muted-color)"
      ) {{ item.video.title }}
      p(class="text-xs" style="color: var(--p-text-muted-color); opacity: 0.6")
        span(v-if="item.video.channel") {{ item.video.channel }}
        span(v-if="item.video.channel")  ·&nbsp;
        span {{ item.watched_at.formatted }}
        template(v-if="item.video.duration")
          span  · {{ item.video.duration.formatted }}

    div(
      v-if="item.custom_tags.length"
      class="flex flex-wrap gap-1.5 mt-2.5"
    )
      span(
        v-for="tag in item.custom_tags"
        :key="tag"
        class="text-xs px-2 py-0.5 rounded-full border"
        style="border-color: var(--p-primary-color); color: var(--p-primary-300); background: color-mix(in srgb, var(--p-primary-color) 10%, transparent)"
      ) {{ tag }}
</template>
