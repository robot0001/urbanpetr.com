export interface TimestampField {
  timestamp: number
  formatted: string
}

export interface Duration {
  total_seconds: number
  formatted: string
}

export interface Video {
  uuid: string
  id: string
  type: 'video' | 'short'
  url: string
  title: string
  channel: string | null
  channel_url: string | null
  thumbnail_url: string | null
  description: string | null
  duration: Duration | null
  published_at: TimestampField | null
  view_count: number | null
  like_count: number | null
  tags: string[] | null
}

export interface HistoryItem {
  uuid: string
  active: boolean
  watched_at: TimestampField
  comment: string | null
  custom_tags: string[]
  video: Video
}

export interface Pagination {
  pages_total: number
  items_total: number
  page: number
  items_per_page: number
}

export function useYoutubeHistory(endpoint: string) {
  const { public: { apiBase } } = useRuntimeConfig()
  const { token, login } = useAuth()

  const items = ref<HistoryItem[]>([])
  const pagination = ref<Pagination | null>(null)
  const page = ref(1)
  const itemsPerPage = ref(25)
  const sort = ref<'asc' | 'desc'>('desc')
  const loading = ref(false)
  const error = ref<string | null>(null)

  const isActiveOnly = !endpoint.endsWith('/all')

  async function fetchPage(p: number = page.value, showLoading: boolean = true) {
    if (showLoading) loading.value = true
    error.value = null
    try {
      const url = `${apiBase}${endpoint}?page=${p}&items_per_page=${itemsPerPage.value}&sort=${sort.value}`
      const headers: Record<string, string> = token.value ? { Authorization: `Bearer ${token.value}` } : {}
      const data = await $fetch<{ items: HistoryItem[], pagination: Pagination }>(url, { headers })
      items.value = data.items ?? []
      pagination.value = data.pagination
      page.value = p
    } catch (e: any) {
      if (e?.response?.status === 401) { login(); return }
      error.value = e?.message ?? 'Failed to load'
    } finally {
      loading.value = false
    }
  }

  function onToggled(uuid: string, newActive: boolean) {
    if (isActiveOnly && !newActive) {
      items.value = items.value.filter(i => i.uuid !== uuid)
    } else {
      const item = items.value.find(i => i.uuid === uuid)
      if (item) item.active = newActive
    }
  }

  function toggleSort() {
    sort.value = sort.value === 'desc' ? 'asc' : 'desc'
    fetchPage(1)
  }

  onMounted(() => fetchPage(1))

  function setItemsPerPage(n: number) {
    itemsPerPage.value = n
    fetchPage(1)
  }

  return { items, pagination, page, itemsPerPage, sort, loading, error, fetchPage, onToggled, toggleSort, setItemsPerPage }
}
