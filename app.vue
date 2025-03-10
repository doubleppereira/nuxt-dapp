<template>
  <div class="container mx-auto p-4">
    <h1 class="text-2xl font-bold mb-6">Lukso Balance Checker</h1>
    <LuksoWallets />
    <appkit-button />
    <LyxBalance v-if="isConnected" />
  </div>
</template>

<script setup lang="ts">
import { useAccount } from '@wagmi/vue';

const { isConnected } = useAccount();
</script>
