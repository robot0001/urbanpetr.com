import Aura from '@primeuix/themes/aura'
import { definePreset } from '@primeuix/themes'

const Theme = definePreset(Aura, {
  components: {
    panel: {
      header: {
        color: 'var(--primary-200)'
      }
    },
    fieldset: {
      legend: {
        color: 'var(--primary-200)'
      }
    }
  }
})

export default defineNuxtConfig({
  modules: ['@nuxtjs/tailwindcss', '@primevue/nuxt-module'],
  css: ['~/assets/css/global.css', '~/assets/css/background.css', 'primeicons/primeicons.css'],
  primevue: {
    components: {
      include: ['Panel', 'Card']
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
      title: 'UrbanPetr.com',
      meta: [
        { name: 'description', content: "Petr Urban's personal website. Portfolio, experience, and contact information." }
      ]
    }
  }
})
