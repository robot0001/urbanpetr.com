<script setup lang="ts">
import type { HistoryItem, Pagination } from '~/types/youtube'

const props = withDefaults(defineProps<{ itemsPerPage?: number; layout?: 'list' | 'grid' }>(), { itemsPerPage: 10, layout: 'list' })

const { public: { apiBase } } = useRuntimeConfig()

const page = ref(1)

type YoutubeHistoryResponse = { items: HistoryItem[]; pagination: Pagination }

const { resource: itemResource, load } = useResource<YoutubeHistoryResponse>()

function fetchItems() {
  return load(`${apiBase}/v1/history/youtube?page=${page.value}&items_per_page=${props.itemsPerPage}&sort=desc`)
}

onMounted(fetchItems)
watch(page, fetchItems)

const items = computed(() => (itemResource.data?.items ?? []).filter((item: HistoryItem) => item.video != null))
const totalPages = computed(() => itemResource.data?.pagination?.pages_total ?? 1)

function prev() { if (page.value > 1) page.value-- }
function next() { if (page.value < totalPages.value) page.value++ }
</script>

<template lang="pug">
Panel(header="Now Watching")
  div(v-if="itemResource.loading && layout === 'grid'" class="videos-grid")
    div(v-for="n in 3" :key="n" class="video-card")
      div
      div(class="w-full aspect-video rounded animate-pulse" style="background: var(--p-surface-700)")
      div(class="flex flex-col gap-2")
        div(class="h-3 w-3/4 rounded animate-pulse" style="background: var(--p-surface-700)")
        div(class="h-3 w-1/2 rounded animate-pulse" style="background: var(--p-surface-700)")

  div(v-else-if="!itemResource.loading && !items.length" class="text-sm" style="color: var(--p-text-muted-color)") Nothing active right now.

  div(v-else-if="layout === 'grid'" class="videos-grid")
    a(
      v-for="item in items"
      :key="item.uuid"
      :href="item.video.url"
      target="_blank"
      rel="noopener"
      class="video-card group"
    )
      div(class="flex flex-wrap items-baseline gap-x-1.5 gap-y-1")
        span(
          v-for="tag in item.custom_tags"
          :key="tag"
          class="text-xs px-2 py-0.5 rounded-full border flex-shrink-0"
          style="border-color: var(--p-primary-color); color: var(--p-primary-300); background: color-mix(in srgb, var(--p-primary-color) 10%, transparent)"
        ) {{ tag }}
        span(
          v-if="item.comment"
          class="text-sm leading-relaxed italic"
          style="color: var(--p-primary-200)"
        ) "{{ item.comment }}"
      img(
        v-if="item.video.thumbnail_url"
        :src="item.video.thumbnail_url"
        :alt="item.video.title"
        class="w-full aspect-video object-cover rounded"
      )
      div(class="flex flex-col gap-1")
        p(class="text-xs font-semibold leading-snug line-clamp-2 group-hover:text-orange-400 transition-colors") {{ item.video.title }}
        p(class="text-xs" style="color: var(--p-text-muted-color)")
          span(v-if="item.video.channel") {{ item.video.channel }}
          span(v-if="item.video.channel")  ·&nbsp;
          span {{ item.watched_at.formatted }}
          template(v-if="item.video.duration")
            span  · {{ item.video.duration.formatted }}

  div(v-else)
    div(
      v-for="item in items"
      :key="item.uuid"
      class="mb-6 last:mb-0 pb-6 last:pb-0 border-b last:border-b-0 border-white/10"
    )
      a(:href="item.video.url" target="_blank" rel="noopener" class="block group")
        div(
          v-if="item.comment || item.custom_tags.length"
          class="flex flex-wrap items-baseline gap-x-1.5 gap-y-1 mb-3"
        )
          span(
            v-for="tag in item.custom_tags"
            :key="tag"
            class="text-xs px-2 py-0.5 rounded-full border flex-shrink-0"
            style="border-color: var(--p-primary-color); color: var(--p-primary-300); background: color-mix(in srgb, var(--p-primary-color) 10%, transparent)"
          ) {{ tag }}
          span(
            v-if="item.comment"
            class="text-sm leading-relaxed italic"
            style="color: var(--p-primary-200)"
          ) "{{ item.comment }}"

        div(class="flex gap-3 items-start")
          img(
            v-if="item.video.thumbnail_url"
            :src="item.video.thumbnail_url"
            :alt="item.video.title"
            class="w-24 aspect-video object-cover rounded flex-shrink-0"
          )
          div(class="min-w-0 flex-1 flex flex-col gap-1")
            p(class="text-xs font-semibold leading-snug line-clamp-2 group-hover:text-orange-400 transition-colors") {{ item.video.title }}
            p(class="text-xs" style="color: var(--p-text-muted-color)")
              span(v-if="item.video.channel") {{ item.video.channel }}
              span(v-if="item.video.channel")  ·&nbsp;
              span {{ item.watched_at.formatted }}
              template(v-if="item.video.duration")
                span  · {{ item.video.duration.formatted }}

  div(
    v-if="totalPages > 1"
    class="flex items-center justify-center gap-4 mt-5 pt-4 border-t border-white/10"
  )
    button(
      @click="prev"
      :disabled="page === 1"
      class="transition-opacity"
      :class="page === 1 ? 'opacity-25 cursor-default' : 'opacity-70 hover:opacity-100'"
    )
      i(class="pi pi-chevron-left text-xs")
    span(class="text-xs tabular-nums" style="color: var(--p-text-muted-color)") {{ page }} / {{ totalPages }}
    button(
      @click="next"
      :disabled="page === totalPages"
      class="transition-opacity"
      :class="page === totalPages ? 'opacity-25 cursor-default' : 'opacity-70 hover:opacity-100'"
    )
      i(class="pi pi-chevron-right text-xs")
</template>

<style scoped>
.videos-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1rem;
}

@media (min-width: 640px) {
  .videos-grid { grid-template-columns: repeat(2, 1fr); }
}

@media (min-width: 1024px) {
  .videos-grid { grid-template-columns: repeat(3, 1fr); }
}

.video-card {
  display: grid;
  grid-template-rows: subgrid;
  grid-row: span 3;
  gap: 0.5rem;
}
</style>
