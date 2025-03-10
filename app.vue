<template>
  <div class="container mx-auto p-4">
    <h1 class="text-2xl font-bold mb-6">Ethereum Balance Checker</h1>
    <appkit-button />
    <EthBalance v-if="isConnected" />
  </div>
</template>

<script setup lang="ts">
import { useAccount } from '@wagmi/vue';

const { isConnected } = useAccount();
</script>
