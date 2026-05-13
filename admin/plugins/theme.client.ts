import { applyPalette, palettes, type PaletteName } from '~/composables/useTheme'

export default defineNuxtPlugin(() => {
  if (localStorage.getItem('theme') === 'light') {
    document.documentElement.classList.remove('dark')
  }
  const saved = localStorage.getItem('theme_palette') as PaletteName | null
  if (saved && palettes[saved]) {
    applyPalette(saved)
  }
})
