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
  experimental: {
    appManifest: false,
  },
  nitro: {
    prerender: {
      routes: ['/my-stuff', '/my-stuff/now-watching'],
    },
  },
  runtimeConfig: {
    public: {
      apiBase: 'https://api.urbanpetr.com'
    }
  },
  modules: ['@nuxtjs/tailwindcss', '@primevue/nuxt-module', 'nuxt-gtag'],
  gtag: {
    id: process.env.NUXT_PUBLIC_GTAG_ID
  },
  css: ['~/assets/css/global.css', '~/assets/css/entry-animation.css', '~/assets/css/primeicons-minimal.css'],
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
  vite: {
    server: {
      allowedHosts: process.env.VITE_ALLOWED_HOSTS?.split(',') ?? [],
    }
  },
  app: {
    head: {
      htmlAttrs: { class: '' },
      charset: 'utf-8',
      viewport: 'width=device-width, initial-scale=1.0',
      title: 'UrbanPetr.com',
      meta: [
        { name: 'description', content: "Petr Urban's personal website. Portfolio, experience, and contact information." }
      ],
      link: [
        { rel: 'preconnect', href: 'https://fonts.googleapis.com' },
        { rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: '' },
        { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Space+Grotesk:wght@500;700&family=JetBrains+Mono:wght@400;600&display=swap', media: 'print', onload: "this.media='all'" },
      ]
    }
  }
})
