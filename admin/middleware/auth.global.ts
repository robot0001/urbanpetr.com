export default defineNuxtRouteMiddleware((to) => {
  if (to.path === '/login' || to.path === '/auth-callback') return
  const { isAuthenticated } = useAuth()
  if (!isAuthenticated.value) {
    return navigateTo(`/login?redirect=${encodeURIComponent(to.fullPath)}`)
  }
})
