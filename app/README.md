# Lux Faucet - Modern Frontend

Next.js 16 + React 19 + Tailwind CSS 4 + viem 2 + wagmi 2

## Tech Stack

- **Framework**: Next.js 16.0.1 (App Router)
- **React**: 19.2.0
- **Styling**: Tailwind CSS 4.0.0 (with OKLCH colors)
- **Web3**:
  - viem 2.38.6
  - wagmi 2.19.2
  - RainbowKit 2.2.9
- **State**: TanStack Query 5.90.7
- **UI**:
  - Lucide React (icons)
  - Sonner (toasts)
  - CVA (component variants)

## Getting Started

### Development

```bash
# From root
pnpm dev:app

# Or from app directory
pnpm dev
```

Visit [http://localhost:3000](http://localhost:3000)

### Environment Variables

Copy `.env.local.example` to `.env.local` and fill in:

```bash
NEXT_PUBLIC_WC_PROJECT_ID=your_walletconnect_project_id
NEXT_PUBLIC_API_URL=http://localhost:8000/api
```

## Features

- ✅ Next.js 16 App Router
- ✅ React 19 with Server Components
- ✅ Tailwind CSS 4 with OKLCH colors
- ✅ Dark mode support
- ✅ viem v2 for type-safe Ethereum interactions
- ✅ wagmi v2 for React hooks
- ✅ RainbowKit for wallet connections
- ✅ TypeScript strict mode
- ✅ ESLint + Prettier

## Project Structure

```
app/
├── src/
│   ├── app/           # Next.js app router pages
│   ├── components/    # React components
│   ├── lib/           # Utilities & configs
│   └── hooks/         # Custom React hooks
├── public/            # Static assets
└── package.json
```

## Build

```bash
pnpm build
```

## Deploy

The app can be deployed to Vercel, Netlify, or any platform supporting Next.js.

```bash
# Build
pnpm build

# Start production server
pnpm start
```
