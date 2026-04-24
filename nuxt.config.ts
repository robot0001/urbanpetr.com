export default defineNuxtConfig({
  modules: ['@nuxtjs/tailwindcss'],
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
