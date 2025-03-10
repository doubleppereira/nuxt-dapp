import { VueQueryPlugin } from '@tanstack/vue-query';
import { WagmiPlugin } from '@wagmi/vue';
import { defineNuxtPlugin } from 'nuxt/app';

import { createAppKit } from '@reown/appkit/vue';
import { networks, wagmiAdapter } from '~/wagmiAdapter';

// TODO: Move to @wagmi/vue/nuxt nitro plugin
export default defineNuxtPlugin((nuxtApp) => {
  nuxtApp.vueApp
    // @ts-ignore
    .use(WagmiPlugin, { config: wagmiAdapter.wagmiConfig })
    .use(VueQueryPlugin, {});

  nuxtApp.hook('app:mounted', () => {
    // 1. Get projectId from https://cloud.reown.com
    const projectId = 'da4f9211fd38cb634679098b9551947a';

    // 2. Create a metadata object
    const metadata = {
      name: 'AppKit',
      description: 'AppKit Example',
      url: 'https://example.com', // origin must match your domain & subdomain
      icons: ['https://avatars.githubusercontent.com/u/179229932'],
    };

    // 5. Create the modal
    createAppKit({
      adapters: [wagmiAdapter],
      networks,
      projectId,
      metadata,
      features: {
        analytics: true, // Optional - defaults to your Cloud configuration
      },
    });
  });
});
