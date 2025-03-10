import { VueQueryPlugin } from '@tanstack/vue-query';
import { WagmiPlugin } from '@wagmi/vue';
import { defineNuxtPlugin } from 'nuxt/app';

import { WagmiAdapter } from '@reown/appkit-adapter-wagmi';
import {
  lukso,
  luksoTestnet,
  type AppKitNetwork,
} from '@reown/appkit/networks';
import { createAppKit } from '@reown/appkit/vue';
import { injected } from '@wagmi/vue/connectors';

const luksoWallet = injected({
  target() {
    if (typeof window === 'undefined') return;
    return {
      id: 'cloud.universalprofile',
      name: 'Universal Profile',
      // @ts-ignore
      provider: window?.lukso,
    };
  },
});

// 1. Get projectId from https://cloud.reown.com
const projectId = 'da4f9211fd38cb634679098b9551947a';

// 3. Set the networks
export const networks: [AppKitNetwork, ...AppKitNetwork[]] = [
  lukso,
  luksoTestnet,
];

// 4. Create Wagmi Adapter
export const wagmiAdapter = new WagmiAdapter({
  networks,
  projectId,
});

// TODO: Move to @wagmi/vue/nuxt nitro plugin
export default defineNuxtPlugin((nuxtApp) => {
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

  nuxtApp.vueApp
    // @ts-ignore
    .use(WagmiPlugin, {
      config: wagmiAdapter.wagmiConfig,
      reconnectOnMount: true,
    })
    .use(VueQueryPlugin, {});
});
