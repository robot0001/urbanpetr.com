<script setup lang="ts">
import type { HistoryItem, Pagination } from '~/types/youtube'

const props = withDefaults(defineProps<{ itemsPerPage?: number; layout?: 'list' | 'grid'; queryKey?: string }>(), { itemsPerPage: 10, layout: 'list', queryKey: 'now_watching' })

const { public: { apiBase } } = useRuntimeConfig()
const route = useRoute()
const router = useRouter()

type YoutubeHistoryResponse = { items: HistoryItem[]; pagination: Pagination }

const { resource: itemResource, load } = useResource<YoutubeHistoryResponse>()

function pageFromUrl(): number {
  const raw = route.query[props.queryKey]
  if (!raw || typeof raw !== 'string') return 1
  try {
    const parsed = JSON.parse(decodeURIComponent(raw))
    return typeof parsed.page === 'number' ? parsed.page : 1
  } catch {
    return 1
  }
}

const page = ref(pageFromUrl())
const isMobile = ref(false)
const effectiveItemsPerPage = computed(() => isMobile.value ? 20 : props.itemsPerPage)

function fetchItems() {
  return load(`${apiBase}/v1/history/youtube?page=${page.value}&items_per_page=${effectiveItemsPerPage.value}&sort=desc`)
}

function pushPage(p: number) {
  const query = { ...route.query }
  if (p <= 1) {
    delete query[props.queryKey]
  } else {
    query[props.queryKey] = encodeURIComponent(JSON.stringify({ page: p }))
  }
  router.push({ query })
}

onMounted(() => {
  const check = () => { isMobile.value = window.innerWidth < 640 }
  check()
  window.addEventListener('resize', check)
  onUnmounted(() => window.removeEventListener('resize', check))
  fetchItems()
})

watch(isMobile, () => {
  page.value = 1
  fetchItems()
})

watch(() => route.query[props.queryKey], () => {
  page.value = pageFromUrl()
  fetchItems()
})

const items = computed(() => (itemResource.data?.items ?? []).filter((item: HistoryItem) => item.video != null))
const totalPages = computed(() => itemResource.data?.pagination?.pages_total ?? 1)

function prev() { if (page.value > 1) pushPage(page.value - 1) }
function next() { if (page.value < totalPages.value) pushPage(page.value + 1) }
</script>

<template lang="pug">
div(class="bg-white border-[2px] border-flat-dark shadow-[6px_6px_0px_rgba(17,26,46,1)]")
  div(class="flex items-center justify-between px-6 py-4 border-b-[2px] border-flat-dark")
    h3(class="font-display font-black text-base tracking-tight text-flat-dark") Now Watching
    div(v-if="totalPages > 1" class="flex items-center gap-3")
      button(
        @click="prev"
        :disabled="page === 1"
        class="transition-opacity font-mono text-xs font-bold"
        :class="page === 1 ? 'opacity-25 cursor-default' : 'opacity-70 hover:opacity-100'"
      )
        i(class="pi pi-chevron-left text-xs")
      span(class="text-xs font-mono tabular-nums text-zinc-500") {{ page }} / {{ totalPages }}
      button(
        @click="next"
        :disabled="page === totalPages"
        class="transition-opacity font-mono text-xs font-bold"
        :class="page === totalPages ? 'opacity-25 cursor-default' : 'opacity-70 hover:opacity-100'"
      )
        i(class="pi pi-chevron-right text-xs")

  div(class="px-6 py-5")
    div(v-if="itemResource.loading && layout === 'grid'" class="videos-grid")
      div(v-for="n in 3" :key="n" class="video-card")
        div
        div(class="w-full aspect-video rounded-none animate-pulse bg-flat-sand/60")
        div(class="flex flex-col gap-2")
          div(class="h-3 w-3/4 animate-pulse bg-flat-sand/60")
          div(class="h-3 w-1/2 animate-pulse bg-flat-sand/60")

    div(v-else-if="!itemResource.loading && !items.length" class="text-sm font-mono text-zinc-500") Nothing active right now.

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
            class="text-xs px-2 py-0.5 border-[2px] border-flat-dark font-mono font-bold text-flat-dark bg-flat-yellow/60 flex-shrink-0"
          ) {{ tag }}
          span(
            v-if="item.comment"
            class="text-sm leading-relaxed italic text-flat-spruce"
          ) "{{ item.comment }}"
        img(
          v-if="item.video.thumbnail_url"
          :src="item.video.thumbnail_url"
          :alt="item.video.title"
          class="w-full aspect-video object-cover"
        )
        div(class="flex flex-col gap-1")
          p(class="text-xs font-semibold leading-snug line-clamp-2 group-hover:text-flat-terracotta transition-colors text-flat-dark") {{ item.video.title }}
          p(class="text-xs text-zinc-500 font-mono")
            span(v-if="item.video.channel") {{ item.video.channel }}
            span(v-if="item.video.channel")  ·&nbsp;
            span {{ item.watched_at.formatted }}
            template(v-if="item.video.duration")
              span  · {{ item.video.duration.formatted }}

    div(v-else)
      div(
        v-for="item in items"
        :key="item.uuid"
        class="mb-6 last:mb-0 pb-6 last:pb-0 border-b-[2px] last:border-b-0 border-flat-dark/10"
      )
        a(:href="item.video.url" target="_blank" rel="noopener" class="block group")
          div(
            v-if="item.comment || item.custom_tags.length"
            class="flex flex-wrap items-baseline gap-x-1.5 gap-y-1 mb-3"
          )
            span(
              v-for="tag in item.custom_tags"
              :key="tag"
              class="text-xs px-2 py-0.5 border-[2px] border-flat-dark font-mono font-bold text-flat-dark bg-flat-yellow/60 flex-shrink-0"
            ) {{ tag }}
            span(
              v-if="item.comment"
              class="text-sm leading-relaxed italic text-flat-spruce"
            ) "{{ item.comment }}"

          div(class="flex gap-3 items-start")
            img(
              v-if="item.video.thumbnail_url"
              :src="item.video.thumbnail_url"
              :alt="item.video.title"
              class="w-24 aspect-video object-cover flex-shrink-0 border border-flat-dark/20"
            )
            div(class="min-w-0 flex-1 flex flex-col gap-1")
              p(class="text-xs font-semibold leading-snug line-clamp-2 group-hover:text-flat-terracotta transition-colors text-flat-dark") {{ item.video.title }}
              p(class="text-xs text-zinc-500 font-mono")
                span(v-if="item.video.channel") {{ item.video.channel }}
                span(v-if="item.video.channel")  ·&nbsp;
                span {{ item.watched_at.formatted }}
                template(v-if="item.video.duration")
                  span  · {{ item.video.duration.formatted }}

    div(
      v-if="totalPages > 1"
      class="flex items-center justify-end gap-4 mt-5 pt-4 border-t-[2px] border-flat-dark/10"
    )
      button(
        @click="prev"
        :disabled="page === 1"
        class="transition-opacity"
        :class="page === 1 ? 'opacity-25 cursor-default' : 'opacity-70 hover:opacity-100'"
      )
        i(class="pi pi-chevron-left text-xs")
      span(class="text-xs font-mono tabular-nums text-zinc-500") {{ page }} / {{ totalPages }}
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
