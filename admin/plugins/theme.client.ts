export default defineNuxtPlugin(() => {
  if (localStorage.getItem('theme') === 'light') {
    document.documentElement.classList.remove('dark')
  }
})
