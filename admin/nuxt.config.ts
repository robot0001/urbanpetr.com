import Aura from '@primeuix/themes/aura'
import { definePreset } from '@primeuix/themes'

const Theme = definePreset(Aura, {})
const isDev = process.env.NODE_ENV === 'development'

export default defineNuxtConfig({
  ssr: false,
  // viteEnvironmentApi ensures NUXT_VITE_NODE_OPTIONS.socketPath is set even
  // when ssr:false — without it the server-side Vite instance is never created
  // so the IPC socket path never gets configured and renderRoute crashes.
  experimental: { viteEnvironmentApi: true },
  runtimeConfig: {
    public: {
      apiBase: 'https://api.urbanpetr.com',
      cognitoDomain: '',   // NUXT_PUBLIC_COGNITO_DOMAIN   e.g. urbanpetr-prod.auth.eu-central-1.amazoncognito.com
      cognitoClientId: '', // NUXT_PUBLIC_COGNITO_CLIENT_ID
    }
  },
  modules: ['@nuxtjs/tailwindcss', '@primevue/nuxt-module'],
  css: ['~/assets/css/global.css', 'primeicons/primeicons.css'],
  primevue: {
    components: {
      include: ['Button', 'Card', 'Tag', 'Skeleton', 'Paginator', 'Menu', 'Message', 'ProgressSpinner', 'Dialog', 'Textarea', 'InputChips', 'SelectButton']
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
      allowedHosts: isDev ? ['urbanpetr.home', 'api.urbanpetr.home'] : [],
    }
  },
  app: {
    head: {
      htmlAttrs: { class: 'dark' },
      charset: 'utf-8',
      viewport: 'width=device-width, initial-scale=1.0',
      title: 'Admin — UrbanPetr',
    }
  },
})
