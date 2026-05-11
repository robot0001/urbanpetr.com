import Aura from '@primeuix/themes/aura'
import { definePreset } from '@primeuix/themes'

const Theme = definePreset(Aura, {})

export default defineNuxtConfig({
  runtimeConfig: {
    public: {
      apiBase: 'https://api.urbanpetr.com'
    }
  },
  modules: ['@nuxtjs/tailwindcss', '@primevue/nuxt-module'],
  css: ['~/assets/css/global.css', 'primeicons/primeicons.css'],
  primevue: {
    components: {
      include: ['Button', 'Card', 'Tag', 'Skeleton', 'Paginator']
    },
    options: {
      ripple: true,
      theme: {
        preset: Theme,
        options: {
          darkModeSelector: '.dark',
          primary: {
            50: '#fff7ed',
            100: '#ffedd5',
            200: '#fed7aa',
            300: '#fdba74',
            400: '#fb923c',
            500: '#f97316',
            600: '#ea580c',
            700: '#c2410c',
            800: '#9a3412',
            900: '#7c2d12',
            950: '#431407'
          }
        }
      }
    }
  },
  app: {
    head: {
      htmlAttrs: { class: 'dark' },
      charset: 'utf-8',
      viewport: 'width=device-width, initial-scale=1.0',
      title: 'Admin — UrbanPetr'
    }
  }
})
