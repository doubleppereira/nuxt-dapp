<template>
  <div class="mt-6 p-4 border rounded-lg">
    <h2 class="text-xl font-bold mb-2">Lyx Balance</h2>

    <div v-if="isLoading">
      <p>Loading balance...</p>
    </div>

    <div v-else-if="isError">
      <p class="text-red-500">
        Error fetching balance: {{ error?.message || 'Unknown error' }}
      </p>
    </div>

    <div v-else-if="data">
      <div class="flex items-center">
        <div class="mr-2 font-medium">Balance:</div>
        <div class="text-lg font-bold">{{ formatEther(data.value) }} Lyx</div>
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

const { address: accountAddress } = useAccount();

const address = computed(() => accountAddress.value);
const { data, isError, isLoading, error, refetch } = useBalance({
  address,
});
</script>
