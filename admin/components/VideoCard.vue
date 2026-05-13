<script setup lang="ts">
import type { HistoryItem } from '~/composables/useYoutubeHistory'

const props = defineProps<{ item: HistoryItem }>()
const emit = defineEmits<{
  (e: 'toggled', uuid: string, newActive: boolean): void
  (e: 'enriched', uuid: string): void
}>()

const { public: { apiBase } } = useRuntimeConfig()
const { token, login } = useAuth()
const toggling = ref(false)

async function toggle() {
  if (props.item.active && !window.confirm(`Are you sure you want to deactivate "${props.item.video.title}"?`)) return
  toggling.value = true
  try {
    const action = props.item.active ? 'deactivate' : 'activate'
    await $fetch(`${apiBase}/v1/history/youtube/${props.item.uuid}/${action}`, {
      method: 'POST',
      headers: token.value ? { Authorization: `Bearer ${token.value}` } : {},
    })
    emit('toggled', props.item.uuid, !props.item.active)
  } catch (e: any) {
    if (e?.response?.status === 401) login()
  } finally {
    toggling.value = false
  }
}

const enriching = ref(false)

async function enrich() {
  enriching.value = true
  try {
    await $fetch(`${apiBase}/v1/history/youtube/${props.item.uuid}/enrich`, {
      method: 'POST',
      headers: token.value ? { Authorization: `Bearer ${token.value}` } : {},
    })
    emit('enriched', props.item.uuid)
  } catch (e: any) {
    if (e?.response?.status === 401) login()
  } finally {
    enriching.value = false
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
Card(:pt="{ root: { style: { border: '1px solid', borderColor: item.active ? 'var(--p-primary-color)' : 'var(--p-content-border-color)' } }, body: { style: { padding: '1rem' } } }")
  template(#content)
    div(class="flex flex-col sm:flex-row gap-4")
      a(:href="item.video.url" target="_blank" rel="noopener" class="shrink-0")
        div(
          class="w-full sm:w-32 aspect-video rounded overflow-hidden flex items-center justify-center"
          :style="{ background: 'var(--p-surface-100)' }"
        )
          img(
            v-if="item.video.thumbnail_url"
            :src="item.video.thumbnail_url"
            :alt="item.video.title"
            class="w-full h-full object-cover"
          )
          i(v-else class="pi pi-youtube text-2xl")

      div(class="flex flex-col flex-1 min-w-0 gap-1")
        div(class="flex items-start justify-between gap-4")
          div(class="flex-1 min-w-0")
            a(
              :href="item.video.url"
              target="_blank"
              rel="noopener"
              class="font-medium line-clamp-2 leading-snug block"
            ) {{ item.video.title }}
            p(class="text-sm mt-1 truncate" :style="{ color: 'var(--p-text-muted-color)' }")
              a(
                v-if="item.video.channel && item.video.channel_url"
                :href="item.video.channel_url"
                target="_blank"
                rel="noopener"
              ) {{ item.video.channel }}
              span(v-else-if="item.video.channel") {{ item.video.channel }}
              span(v-if="item.video.channel") &nbsp;·&nbsp;
              span Watched {{ item.watched_at.formatted }}
          div(class="flex flex-col gap-2 shrink-0 self-start")
            Button(
              :label="item.active ? 'Deactivate' : 'Activate'"
              :severity="item.active ? 'danger' : 'success'"
              size="small"
              :loading="toggling"
              @click="toggle"
            )
            Button(
              v-if="!item.video.thumbnail_url"
              label="Fetch details"
              severity="secondary"
              size="small"
              icon="pi pi-download"
              :loading="enriching"
              @click="enrich"
            )

        div(class="flex items-center gap-2 mt-auto pt-1 text-xs flex-wrap" :style="{ color: 'var(--p-text-muted-color)' }")
          span(v-if="item.video.duration") {{ item.video.duration.formatted }}
          Tag(
            :value="item.video.type"
            :severity="item.video.type === 'short' ? 'secondary' : 'info'"
            class="!text-xs !py-0.5 !px-1.5"
          )
          template(v-if="formatCount(item.video.view_count)")
            span · {{ formatCount(item.video.view_count) }} views
          template(v-if="formatCount(item.video.like_count)")
            span · {{ formatCount(item.video.like_count) }} likes
          template(v-if="item.video.published_at")
            span · Published {{ item.video.published_at.formatted }}
</template>
