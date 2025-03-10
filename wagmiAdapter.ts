import { WagmiAdapter } from '@reown/appkit-adapter-wagmi';
import { mainnet, type AppKitNetwork } from '@reown/appkit/networks';

// 1. Get projectId from https://cloud.reown.com
const projectId = 'da4f9211fd38cb634679098b9551947a';

// 3. Set the networks
export const networks: [AppKitNetwork, ...AppKitNetwork[]] = [mainnet];

// 4. Create Wagmi Adapter
export const wagmiAdapter = new WagmiAdapter({
  networks,
  projectId,
});
