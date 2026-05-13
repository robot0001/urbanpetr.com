const STORAGE_KEY = 'theme'
const PALETTE_KEY = 'theme_palette'

export const palettes = {
  orange: { 50: '#fff7ed', 100: '#ffedd5', 200: '#fed7aa', 300: '#fdba74', 400: '#fb923c', 500: '#f97316', 600: '#ea580c', 700: '#c2410c', 800: '#9a3412', 900: '#7c2d12', 950: '#431407' },
  blue:   { 50: '#eff6ff', 100: '#dbeafe', 200: '#bfdbfe', 300: '#93c5fd', 400: '#60a5fa', 500: '#3b82f6', 600: '#2563eb', 700: '#1d4ed8', 800: '#1e40af', 900: '#1e3a8a', 950: '#172554' },
  green:  { 50: '#ecfdf5', 100: '#d1fae5', 200: '#a7f3d0', 300: '#6ee7b7', 400: '#34d399', 500: '#10b981', 600: '#059669', 700: '#047857', 800: '#065f46', 900: '#064e3b', 950: '#022c22' },
  purple: { 50: '#f5f3ff', 100: '#ede9fe', 200: '#ddd6fe', 300: '#c4b5fd', 400: '#a78bfa', 500: '#8b5cf6', 600: '#7c3aed', 700: '#6d28d9', 800: '#5b21b6', 900: '#4c1d95', 950: '#2e1065' },
  rose:   { 50: '#fff1f2', 100: '#ffe4e6', 200: '#fecdd3', 300: '#fda4af', 400: '#fb7185', 500: '#f43f5e', 600: '#e11d48', 700: '#be123c', 800: '#9f1239', 900: '#881337', 950: '#4c0519' },
} as const

export type PaletteName = keyof typeof palettes

export function applyPalette(name: PaletteName) {
  const root = document.documentElement
  for (const [shade, value] of Object.entries(palettes[name])) {
    root.style.setProperty(`--p-primary-${shade}`, value)
  }
}

export function useTheme() {
  const isDark = useState('theme:isDark', () =>
    process.client ? localStorage.getItem(STORAGE_KEY) !== 'light' : true
  )

  const palette = useState<PaletteName>('theme:palette', () =>
    process.client ? (localStorage.getItem(PALETTE_KEY) as PaletteName | null) ?? 'orange' : 'orange'
  )

  function toggleTheme() {
    isDark.value = !isDark.value
    document.documentElement.classList.toggle('dark', isDark.value)
    localStorage.setItem(STORAGE_KEY, isDark.value ? 'dark' : 'light')
  }

  function setPalette(name: PaletteName) {
    palette.value = name
    applyPalette(name)
    localStorage.setItem(PALETTE_KEY, name)
  }

  return { isDark, palette, toggleTheme, setPalette }
}
