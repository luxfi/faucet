"use client";

import { useState } from "react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { WagmiProvider } from "wagmi";
import { RainbowKitProvider, darkTheme } from "@rainbow-me/rainbowkit";
import { GoogleReCaptchaProvider } from "react-google-recaptcha-v3";
import "@rainbow-me/rainbowkit/styles.css";
import { config } from "@/lib/wagmi";
import { Toaster } from "sonner";

export function Providers({ children }: { children: React.ReactNode }) {
  const [queryClient] = useState(() => new QueryClient());

  const recaptchaSiteKey = process.env.NEXT_PUBLIC_RECAPTCHA_SITE_KEY || "";

  return (
    <GoogleReCaptchaProvider reCaptchaKey={recaptchaSiteKey}>
      <WagmiProvider config={config}>
        <QueryClientProvider client={queryClient}>
          <RainbowKitProvider theme={darkTheme()}>
            {children}
            <Toaster richColors position="top-right" />
          </RainbowKitProvider>
        </QueryClientProvider>
      </WagmiProvider>
    </GoogleReCaptchaProvider>
  );
}
