declare global {
  interface Window {
    ethereum?: any;
  }
}

export interface NetworkConfig {
  CHAINID: number;
  NAME: string;
  TOKEN: string;
  RPC: string;
  EXPLORER?: string;
}

export interface TokenConfig {
  CONTRACTADDRESS: string;
  TOKEN: string;
  DECIMALS?: number;
  IMAGE?: string;
}

/**
 * Add a custom network to MetaMask
 */
export const addNetwork = async (config: NetworkConfig): Promise<void> => {
  if (!config) {
    return;
  }

  if (typeof window.ethereum === "undefined") {
    window.open("https://metamask.io/download", "_blank");
    return;
  }

  try {
    await window.ethereum.request({
      method: "wallet_addEthereumChain",
      params: [
        {
          chainId: `0x${config.CHAINID.toString(16)}`,
          chainName: config.NAME,
          nativeCurrency: {
            name: config.NAME,
            symbol: config.TOKEN,
            decimals: 18,
          },
          rpcUrls: [config.RPC],
          blockExplorerUrls: config.EXPLORER ? [config.EXPLORER] : undefined,
        },
      ],
    });
  } catch (error) {
    console.error("Failed to add network:", error);
    throw error;
  }
};

/**
 * Add an ERC20 token to MetaMask
 */
export const addToken = async (config: TokenConfig): Promise<void> => {
  if (!config) {
    return;
  }

  if (typeof window.ethereum === "undefined") {
    window.open("https://metamask.io/download", "_blank");
    return;
  }

  try {
    await window.ethereum.request({
      method: "wallet_watchAsset",
      params: {
        type: "ERC20",
        options: {
          address: config.CONTRACTADDRESS,
          symbol: config.TOKEN,
          decimals: config.DECIMALS || 18,
          image: config.IMAGE,
        },
      },
    });
  } catch (error) {
    console.error("Failed to add token:", error);
    throw error;
  }
};

/**
 * Connect to MetaMask and request account access
 */
export const connectMetaMask = async (): Promise<string | null> => {
  if (typeof window.ethereum === "undefined") {
    window.open("https://metamask.io/download", "_blank");
    return null;
  }

  try {
    const accounts = await window.ethereum.request({
      method: "eth_requestAccounts",
    });
    return accounts[0] || null;
  } catch (error) {
    console.error("Failed to connect to MetaMask:", error);
    return null;
  }
};

/**
 * Get current MetaMask accounts without triggering connection prompt
 */
export const getMetaMaskAccounts = async (): Promise<string[]> => {
  if (typeof window.ethereum === "undefined") {
    return [];
  }

  try {
    const accounts = await window.ethereum.request({
      method: "eth_accounts",
    });
    return accounts || [];
  } catch (error) {
    console.error("Failed to get MetaMask accounts:", error);
    return [];
  }
};

/**
 * Switch to a specific network in MetaMask
 */
export const switchNetwork = async (chainId: number): Promise<void> => {
  if (typeof window.ethereum === "undefined") {
    window.open("https://metamask.io/download", "_blank");
    return;
  }

  try {
    await window.ethereum.request({
      method: "wallet_switchEthereumChain",
      params: [{ chainId: `0x${chainId.toString(16)}` }],
    });
  } catch (error: any) {
    // This error code indicates that the chain has not been added to MetaMask
    if (error.code === 4902) {
      throw new Error("Network not added to MetaMask");
    }
    throw error;
  }
};
