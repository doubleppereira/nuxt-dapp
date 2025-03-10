<template>
  <div class="mb-6">
    <div v-if="!isConnected">
      <button
        @click="connectLukso"
        class="bg-yellow-500 hover:bg-yellow-600 text-white font-bold py-2 px-4 rounded mr-2"
        :disabled="isPending"
      >
        {{ isPending ? 'Connecting...' : 'Connect with Lukso' }}
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
        @click="handleDisconnect"
        class="bg-red-500 hover:bg-red-600 text-white font-bold py-1 px-3 rounded text-sm"
      >
        Disconnect
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useAccount, useConnect, useDisconnect } from '@wagmi/vue';
import { computed } from 'vue';

const { address, isConnected } = useAccount();
const { connect, isPending, connectors } = useConnect();
const { disconnect } = useDisconnect();

const shortAddress = computed(() => {
  if (!address.value) return '';
  return `${address.value.substring(0, 6)}...${address.value.substring(
    address.value.length - 4
  )}`;
});

function connectLukso() {
  const connector = connectors.find(
    (c) => c.id.toLowerCase() === 'cloud.universalprofile'
  );
  if (connector) {
    connect({ connector });
  }
}

function connectWalletConnect() {
  const connector = connectors.find(
    (c) => c.id.toLowerCase() === 'walletconnect'
  );
  if (connector) {
    connect({ connector });
  }
}
function handleDisconnect(event: MouseEvent) {
  disconnect();
}
</script>
