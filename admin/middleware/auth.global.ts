export default defineNuxtRouteMiddleware((to) => {
  if (to.path === '/login' || to.path === '/callback') return
  if (!process.client) return
  const { isAuthenticated } = useAuth()
  if (!isAuthenticated.value) {
    return navigateTo('/login')
  }
})
