export interface TimestampField {
  timestamp: number
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
  duration: { total_seconds: number; formatted: string } | null
  published_at: TimestampField | null
  view_count: number | null
  like_count: number | null
}

export interface HistoryItem {
  uuid: string
  active: boolean
  watched_at: TimestampField
  comment: string | null
  custom_tags: string[]
  video: Video
}
