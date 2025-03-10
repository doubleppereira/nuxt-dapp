#!/bin/bash
# Migration script to update Nuxt.js project to use @wagmi/vue, viem@2.x, and @tanstack/vue-query

# Exit on error
set -e

echo "Starting migration to @wagmi/vue with viem@2.x and @tanstack/vue-query..."

# Check if this is a Nuxt.js project
if [ ! -f "nuxt.config.js" ] && [ ! -f "nuxt.config.ts" ]; then
  echo "Error: This doesn't appear to be a Nuxt.js project. Make sure to run this in your Nuxt.js project root directory."
  exit 1
fi

# Backup the current project
echo "Creating backup of current project..."
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="../${PWD##*/}_backup_$TIMESTAMP"
mkdir -p "$BACKUP_DIR"
cp -r . "$BACKUP_DIR"
echo "Backup created at $BACKUP_DIR"

# Remove old dependencies
echo "Removing old dependencies..."
npm uninstall @wagmi/core ethers || true

# Install new dependencies
echo "Installing new dependencies..."
npm install @wagmi/vue @tanstack/vue-query wagmi viem@2 buffer stream-browserify

# Check if tailwindcss is already installed, if not, install it
if ! grep -q "@nuxtjs/tailwindcss" package.json; then
  echo "Installing TailwindCSS..."
  npm install -D @nuxtjs/tailwindcss autoprefixer postcss
fi

# Create directories if they don't exist
mkdir -p components plugins

# Create wagmi plugin
echo "Creating wagmi plugin..."
cat > plugins/wagmi.js << 'EOF'
import { createConfig, http } from 'wagmi';
import { mainnet } from 'wagmi/chains';
import { injected, metaMask, walletConnect } from 'wagmi/connectors';
import { defineNuxtPlugin } from '#app';
import { createVueQueryPlugin } from '@tanstack/vue-query';
import { createWagmiPlugin } from '@wagmi/vue';

export default defineNuxtPlugin((nuxtApp) => {
  // Create wagmi config
  const config = createConfig({
    chains: [mainnet],
    transports: {
      [mainnet.id]: http(),
    },
    connectors: [
      injected(),
      metaMask(),
      walletConnect({
        projectId: 'YOUR_WALLET_CONNECT_PROJECT_ID', 
      }),
    ],
  });

  // Create Vue Query plugin
  const vueQueryPlugin = createVueQueryPlugin({
    queryClientConfig: {
      defaultOptions: {
        queries: {
          retry: 3,
          staleTime: 10 * 1000, // 10 seconds
        },
      },
    },
  });

  // Create Wagmi plugin
  const wagmiPlugin = createWagmiPlugin({ config });

  // Install plugins
  nuxtApp.vueApp.use(vueQueryPlugin);
  nuxtApp.vueApp.use(wagmiPlugin);
});
EOF

# Create WalletConnect component
echo "Creating WalletConnect component..."
cat > components/WalletConnect.vue << 'EOF'
<template>
  <div class="mb-6">
    <div v-if="!isConnected">
      <button 
        @click="connectMetaMask"
        class="bg-yellow-500 hover:bg-yellow-600 text-white font-bold py-2 px-4 rounded mr-2"
        :disabled="isPending"
      >
        {{ isPending ? 'Connecting...' : 'Connect with MetaMask' }}
      </button>
      
      <button 
        @click="connectWalletConnect"
        class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded"
        :disabled="isPending"
      >
        Connect with WalletConnect
      </button>
    </div>
    
    <div v-else class="flex items-center justify-between">
      <div>
        <span class="font-medium">Connected:</span> 
        <span class="text-green-600">{{ shortAddress }}</span>
      </div>
      <button 
        @click="disconnect"
        class="bg-red-500 hover:bg-red-600 text-white font-bold py-1 px-3 rounded text-sm"
      >
        Disconnect
      </button>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { useAccount, useConnect, useDisconnect } from '@wagmi/vue';

const { address, isConnected } = useAccount();
const { connect, isPending, connectors } = useConnect();
const { disconnect } = useDisconnect();

const shortAddress = computed(() => {
  if (!address.value) return '';
  return `${address.value.substring(0, 6)}...${address.value.substring(address.value.length - 4)}`;
});

function connectMetaMask() {
  const connector = connectors.value.find(c => c.id === 'metaMask');
  if (connector) {
    connect({ connector });
  }
}

function connectWalletConnect() {
  const connector = connectors.value.find(c => c.id === 'walletConnect');
  if (connector) {
    connect({ connector });
  }
}
</script>
EOF

# Create EthBalance component
echo "Creating EthBalance component..."
cat > components/EthBalance.vue << 'EOF'
<template>
  <div class="mt-6 p-4 border rounded-lg">
    <h2 class="text-xl font-bold mb-2">ETH Balance</h2>
    
    <div v-if="isLoading">
      <p>Loading balance...</p>
    </div>
    
    <div v-else-if="isError">
      <p class="text-red-500">Error fetching balance: {{ error?.message || 'Unknown error' }}</p>
    </div>
    
    <div v-else-if="data">
      <div class="flex items-center">
        <div class="mr-2 font-medium">Balance:</div>
        <div class="text-lg font-bold">
          {{ formatEther(data.value) }} ETH
        </div>
      </div>
      
      <div class="mt-4">
        <button 
          @click="refetch" 
          class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-1 px-3 rounded text-sm"
        >
          Refresh Balance
        </button>
      </div>
    </div>
    
    <div v-else>
      <p>No balance data available</p>
    </div>
  </div>
</template>

<script setup>
import { useAccount, useBalance } from '@wagmi/vue';
import { formatEther } from 'viem';

const { address } = useAccount();
const { data, isError, isLoading, error, refetch } = useBalance({
  address,
});
</script>
EOF

# Create or update app.vue
echo "Creating app.vue..."
cat > app.vue << 'EOF'
<template>
  <div class="container mx-auto p-4">
    <h1 class="text-2xl font-bold mb-6">Ethereum Balance Checker</h1>
    <WalletConnect />
    <EthBalance v-if="isConnected" />
  </div>
</template>

<script setup>
import { useAccount } from '@wagmi/vue';

const { isConnected } = useAccount();
</script>
EOF

# Update nuxt.config.js
echo "Updating nuxt.config.js..."

# Determine if the project uses .js or .ts for nuxt.config
CONFIG_FILE="nuxt.config.js"
if [ ! -f "$CONFIG_FILE" ]; then
  CONFIG_FILE="nuxt.config.ts"
fi

cat > $CONFIG_FILE << 'EOF'
export default defineNuxtConfig({
  ssr: false, // Disable server-side rendering for web3 app
  app: {
    head: {
      title: 'ETH Balance Checker',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        { name: 'description', content: 'Simple Ethereum balance checker' }
      ]
    }
  },
  css: ['~/assets/css/main.css'],
  postcss: {
    plugins: {
      tailwindcss: {},
      autoprefixer: {},
    },
  },
  modules: [
    '@nuxtjs/tailwindcss'
  ],
  build: {
    transpile: ['@wagmi/vue', '@tanstack/vue-query', 'wagmi', 'viem']
  },
  // Polyfills and compatibility fixes
  vite: {
    define: {
      'process.env.NODE_DEBUG': false,
    },
    resolve: {
      alias: {
        'stream': 'stream-browserify',
        'buffer': 'buffer'
      }
    },
    optimizeDeps: {
      esbuildOptions: {
        define: {
          global: 'globalThis',
        },
      },
    },
  }
})
EOF

# Create CSS directory and file if they don't exist
mkdir -p assets/css
touch assets/css/main.css

# Create tailwind.config.js if it doesn't exist
if [ ! -f "tailwind.config.js" ]; then
  echo "Creating tailwind.config.js..."
  cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./components/**/*.{js,vue,ts}",
    "./layouts/**/*.vue",
    "./pages/**/*.vue",
    "./plugins/**/*.{js,ts}",
    "./app.vue",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF
fi

echo "Migration complete!"
echo ""
echo "IMPORTANT NEXT STEPS:"
echo "1. Update YOUR_WALLET_CONNECT_PROJECT_ID in plugins/wagmi.js with your actual WalletConnect project ID"
echo "2. Run 'npm run dev' to start your updated application"
echo ""
echo "A backup of your original project was created at: $BACKUP_DIR"