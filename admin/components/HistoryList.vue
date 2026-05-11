<script setup lang="ts">
const props = defineProps<{
  endpoint: string
  title: string
}>()

const { items, pagination, page, sort, loading, error, fetchPage, onToggled, toggleSort } = useYoutubeHistory(props.endpoint)
</script>

<template lang="pug">
div
  div(class="flex items-center justify-between mb-6")
    h1(class="text-xl font-semibold")
      | {{ title }}
      span(v-if="pagination" class="ml-2 text-sm font-normal text-gray-400") {{ pagination.items_total.toLocaleString() }} items
    Button(
      :label="sort === 'desc' ? 'Newest first' : 'Oldest first'"
      severity="secondary"
      size="small"
      icon="pi pi-sort-alt"
      @click="toggleSort"
    )

  div(v-if="error" class="text-red-400 mb-4") {{ error }}

  div(v-if="loading" class="flex flex-col gap-3")
    div(v-for="n in 5" :key="n" class="flex gap-4 p-4 rounded-lg border bg-gray-900 border-gray-800")
      Skeleton(width="8rem" height="4.5rem" borderRadius="0.375rem")
      div(class="flex flex-col flex-1 gap-2 pt-1")
        Skeleton(height="1rem" width="75%")
        Skeleton(height="0.75rem" width="50%")

  div(v-else-if="items.length" class="flex flex-col gap-3")
    VideoCard(
      v-for="item in items"
      :key="item.uuid"
      :item="item"
      @toggled="onToggled"
    )

  div(v-else class="text-gray-500 py-12 text-center") No items.

  div(v-if="pagination && pagination.pages_total > 1" class="flex items-center justify-center gap-4 mt-8")
    Button(
      label="Prev"
      icon="pi pi-chevron-left"
      severity="secondary"
      size="small"
      :disabled="page <= 1"
      @click="fetchPage(page - 1)"
    )
    span(class="text-sm text-gray-400") Page {{ page }} of {{ pagination.pages_total }}
    Button(
      label="Next"
      icon="pi pi-chevron-right"
      iconPos="right"
      severity="secondary"
      size="small"
      :disabled="page >= pagination.pages_total"
      @click="fetchPage(page + 1)"
    )
</template>
