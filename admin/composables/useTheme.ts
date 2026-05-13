const STORAGE_KEY = 'theme'

export function useTheme() {
  const isDark = useState('theme:isDark', () => {
    if (process.client) {
      return localStorage.getItem(STORAGE_KEY) !== 'light'
    }
    return true
  })

  function toggleTheme() {
    isDark.value = !isDark.value
    document.documentElement.classList.toggle('dark', isDark.value)
    localStorage.setItem(STORAGE_KEY, isDark.value ? 'dark' : 'light')
  }

  return { isDark, toggleTheme }
}
