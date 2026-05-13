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
const enriching = ref(false)
const activating = ref(false)
const showActivateDialog = ref(false)
const editing = ref(false)
const activateComment = ref('')
const activateCustomTags = ref<string[]>([])
const confirming = ref(false)

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

async function toggle() {
  if (props.item.active) {
    if (!window.confirm(`Are you sure you want to deactivate "${props.item.video.title}"?`)) return
    toggling.value = true
    try {
      await $fetch(`${apiBase}/v1/history/youtube/${props.item.uuid}/deactivate`, {
        method: 'POST',
        headers: token.value ? { Authorization: `Bearer ${token.value}` } : {},
      })
      emit('toggled', props.item.uuid, false)
    } catch (e: any) {
      if (e?.response?.status === 401) login()
    } finally {
      toggling.value = false
    }
  } else {
    await startActivate()
  }
}

async function startActivate() {
  activating.value = true
  try {
    if (!props.item.video.thumbnail_url) {
      await $fetch(`${apiBase}/v1/history/youtube/${props.item.uuid}/enrich`, {
        method: 'POST',
        headers: token.value ? { Authorization: `Bearer ${token.value}` } : {},
      })
    }
  } catch (e: any) {
    if (e?.response?.status === 401) { activating.value = false; login(); return }
    // enrich failure — open dialog anyway without thumbnail
  } finally {
    activating.value = false
  }
  editing.value = false
  activateComment.value = ''
  activateCustomTags.value = []
  showActivateDialog.value = true
}

function startEdit() {
  editing.value = true
  activateComment.value = props.item.comment ?? ''
  activateCustomTags.value = [...props.item.custom_tags]
  showActivateDialog.value = true
}

async function confirmActivate() {
  confirming.value = true
  const body = {
    comment: activateComment.value.trim() || null,
    custom_tags: activateCustomTags.value,
  }
  const headers = { 'Content-Type': 'application/json', ...(token.value ? { Authorization: `Bearer ${token.value}` } : {}) }
  try {
    if (editing.value) {
      await $fetch(`${apiBase}/v1/history/youtube/${props.item.uuid}`, {
        method: 'PATCH',
        headers,
        body,
      })
    } else {
      await $fetch(`${apiBase}/v1/history/youtube/${props.item.uuid}/activate`, {
        method: 'POST',
        headers,
        body,
      })
    }
    showActivateDialog.value = false
    if (!editing.value) emit('toggled', props.item.uuid, true)
  } catch (e: any) {
    if (e?.response?.status === 401) login()
  } finally {
    confirming.value = false
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
              :loading="item.active ? toggling : activating"
              @click="toggle"
            )
            Button(
              label="Edit"
              severity="secondary"
              size="small"
              @click="startEdit"
            )
            Button(
              v-if="!item.video.thumbnail_url"
              label="Fetch details"
              severity="secondary"
              size="small"
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

        div(v-if="item.comment || item.custom_tags.length" class="flex flex-col gap-1 pt-1")
          p(v-if="item.comment" class="text-xs italic" :style="{ color: 'var(--p-text-muted-color)' }") {{ item.comment }}
          div(v-if="item.custom_tags.length" class="flex gap-1 flex-wrap")
            Tag(
              v-for="tag in item.custom_tags"
              :key="tag"
              :value="tag"
              severity="secondary"
              class="!text-xs !py-0.5 !px-1.5"
            )

Dialog(
  v-model:visible="showActivateDialog"
  :header="editing ? 'Edit details' : 'Activate video'"
  :modal="true"
  :closable="true"
  :style="{ width: '32rem' }"
)
  div(class="flex flex-col gap-4")
    div(class="flex gap-3 items-start")
      img(
        v-if="item.video.thumbnail_url"
        :src="item.video.thumbnail_url"
        :alt="item.video.title"
        class="w-24 aspect-video object-cover rounded shrink-0"
      )
      div(class="flex flex-col gap-1 min-w-0")
        p(class="font-medium line-clamp-2 leading-snug text-sm") {{ item.video.title }}
        p(v-if="item.video.channel" class="text-xs truncate" :style="{ color: 'var(--p-text-muted-color)' }") {{ item.video.channel }}
    div(class="flex flex-col gap-1")
      label(class="text-sm font-medium") Comment
      Textarea(v-model="activateComment" :autoResize="true" rows="3" placeholder="Optional note..." class="w-full")
    div(class="flex flex-col gap-1")
      label(class="text-sm font-medium") Tags
      InputChips(v-model="activateCustomTags" placeholder="Add tag + Enter" class="w-full")
  template(#footer)
    div(class="flex justify-end gap-2")
      Button(label="Cancel" severity="secondary" :disabled="confirming" @click="showActivateDialog = false")
      Button(:label="editing ? 'Save' : 'Activate'" severity="success" :loading="confirming" @click="confirmActivate")
</template>
