export default defineNuxtConfig({
  modules: ['@nuxtjs/tailwindcss', '@primevue/nuxt-module'],
  css: ['~/assets/css/global.css', 'primeicons/primeicons.css'],
  primevue: {
    options: {
      ripple: true,
      inputStyle: 'outlined',
      unstyled: false,
      theme: 'aura-dark-blue'
    }
  },
  app: {
    head: {
      charset: 'utf-8',
      viewport: 'width=device-width, initial-scale=1.0',
      title: 'UrbanPetr.com',
      meta: [
        { name: 'description', content: "Petr Urban's personal website. Portfolio, experience, and contact information." }
      ]
    }
  }
})
