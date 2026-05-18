<script setup lang="ts">
const props = defineProps<{
  endpoint: string
  title: string
}>()

const { items, pagination, page, itemsPerPage, sort, typeFilter, loading, error, fetchPage, onToggled, toggleSort, setItemsPerPage, isAllEndpoint } = useYoutubeHistory(props.endpoint)

const typeOptions = [
  { label: 'All', value: 'all' },
  { label: 'Videos', value: 'video' },
  { label: 'Shorts', value: 'short' },
]

function onPage(e: { page: number; rows: number }) {
  if (e.rows !== itemsPerPage.value) {
    setItemsPerPage(e.rows)
  } else {
    fetchPage(e.page + 1)
  }
}
</script>

<template lang="pug">
div
  div(class="flex items-center justify-between mb-4 gap-4 flex-wrap")
    h1(class="text-xl font-semibold")
      | {{ title }}
      span(v-if="pagination" class="ml-2 text-sm font-normal" :style="{ color: 'var(--p-text-muted-color)' }") {{ pagination.items_total.toLocaleString() }} items
    div(class="flex items-center gap-3")
      SelectButton(
        v-if="isAllEndpoint"
        v-model="typeFilter"
        :options="typeOptions"
        optionLabel="label"
        optionValue="value"
        :allowEmpty="false"
        size="small"
      )
      Button(
        :label="sort === 'desc' ? 'Newest first' : 'Oldest first'"
        severity="secondary"
        size="small"
        :icon="sort === 'desc' ? 'pi pi-sort-amount-down' : 'pi pi-sort-amount-up'"
        @click="toggleSort"
      )

  Paginator(
    v-if="pagination && pagination.pages_total > 1"
    class="mb-4 !bg-transparent"
    :rows="itemsPerPage"
    :totalRecords="pagination.items_total"
    :first="(page - 1) * itemsPerPage"
    :pageLinkSize="3"
    :rowsPerPageOptions="[10, 25, 50, 100]"
    @page="onPage"
  )

  div(v-if="error" class="mb-4")
    Message(severity="error" :closable="false") {{ error }}

  div(v-if="loading" class="flex flex-col gap-3")
    div(
      v-for="n in 5"
      :key="n"
      class="flex gap-4 p-4 rounded-lg border"
      :style="{ borderColor: 'var(--p-content-border-color)' }"
    )
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
      @enriched="fetchPage(page)"
    )

  div(v-else-if="!loading" class="py-12 text-center" :style="{ color: 'var(--p-text-muted-color)' }") No items.

  Paginator(
    v-if="pagination && pagination.pages_total > 1"
    class="mt-4 !bg-transparent"
    :rows="itemsPerPage"
    :totalRecords="pagination.items_total"
    :first="(page - 1) * itemsPerPage"
    :pageLinkSize="3"
    :rowsPerPageOptions="[10, 25, 50, 100]"
    @page="onPage"
  )
</template>
