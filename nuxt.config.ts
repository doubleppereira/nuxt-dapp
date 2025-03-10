export default defineNuxtConfig({
  // Disable server-side rendering for web3 app
  ssr: false,

  app: {
    head: {
      title: 'ETH Balance Checker',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        { name: 'description', content: 'Simple Ethereum balance checker' },
      ],
    },
  },

  modules: ['@nuxtjs/tailwindcss', '@wagmi/vue/nuxt'],

  compatibilityDate: '2025-03-10',
});
