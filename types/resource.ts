export interface ItemResource<T> {
  loading: boolean
  data: T | null
  response: Response | null
  error: unknown
}
