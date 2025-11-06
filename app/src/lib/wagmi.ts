import { createConfig, createStorage, http, cookieStorage } from "wagmi";
import { mainnet, lux, luxTestnet } from "wagmi/chains";
import { coinbaseWallet, injected, walletConnect } from "wagmi/connectors";
import { defineChain } from "viem";

const projectId = process.env.NEXT_PUBLIC_WC_PROJECT_ID || "";

// Define custom Avalanche subnet chains
const wagmiTestnet = defineChain({
  id: 11111,
  name: "WAGMI Testnet",
  nativeCurrency: { name: "WAGMI", symbol: "WGM", decimals: 18 },
  rpcUrls: {
    default: { http: ["https://subnets.avax.network/wagmi/wagmi-chain-testnet/rpc"] },
  },
  blockExplorers: {
    default: {
      name: "WAGMI Explorer",
      url: "https://subnets.avax.network/wagmi/wagmi-chain-testnet/explorer",
    },
  },
  testnet: true,
});

export const config = createConfig({
  chains: [mainnet, lux, luxTestnet, wagmiTestnet],
  connectors: [
    injected(),
    coinbaseWallet({ appName: "Lux Faucet" }),
    walletConnect({ projectId }),
  ],
  // Use cookie storage for SSR compatibility
  storage: createStorage({
    storage: cookieStorage,
  }),
  // Disable client-side persistence features during SSR
  ssr: true,
  transports: {
    [mainnet.id]: http(),
    [lux.id]: http(),
    [luxTestnet.id]: http(),
    [wagmiTestnet.id]: http(),
  },
});

declare module "wagmi" {
  interface Register {
    config: typeof config;
  }
}
