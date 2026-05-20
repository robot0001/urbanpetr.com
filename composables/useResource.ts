import type { ItemResource } from '~/types/resource'

export function useResource<T>() {
  const resource = shallowReactive<ItemResource<T>>({
    loading: true,
    data: null,
    response: null,
    error: null,
  })

  async function load(url: string): Promise<void> {
    resource.loading = true
    resource.error = null
    try {
      const res = await fetch(url)
      resource.response = res
      if (res.ok) {
        resource.data = (await res.json()) as T
      } else {
        resource.data = null
        resource.error = await res.json().catch(() => null)
      }
    } catch (e) {
      resource.response = null
      resource.data = null
      resource.error = e
    } finally {
      resource.loading = false
    }
  }

  return { resource, load }
}
