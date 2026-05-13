import { applyPalette, palettes, type PaletteName } from '~/composables/useTheme'

export default defineNuxtPlugin(() => {
  if (localStorage.getItem('theme') === 'light') {
    document.documentElement.classList.remove('dark')
  }
  const saved = localStorage.getItem('theme_palette') as PaletteName | null
  applyPalette((saved && palettes[saved]) ? saved : 'orange')
})
