# Lux Faucet - AI Assistant Knowledge Base

**Last Updated**: 2025-11-05
**Project**: Lux Testnet Faucet
**Stack**: Node.js, TypeScript, React → Next.js, Solidity, Foundry

## Project Overview

Modern faucet for distributing test tokens on Lux testnets. Supports multiple EVM chains with rate limiting, captcha verification, and configurable drip amounts.

## Essential Commands

### Development
```bash
pnpm dev              # Start backend with tsx watch (port 8000)
pnpm dev:ui           # Start frontend (port 3000)
pnpm build            # Build everything
pnpm generate         # Generate new wallet key
```

### Contracts
```bash
cd contracts
forge build           # Compile
forge test            # Run tests
forge test --gas-report  # Gas usage
```

## Architecture

- **Backend**: Express + TypeScript (`/server.ts`)
- **Frontend**: React (CRA) → migrating to Next.js 15
- **Smart Contracts**: Solidity + Foundry (`/contracts/`)
- **Package Manager**: pnpm (workspace)
- **Dev Tools**: tsx (not nodemon ✅)

## Key Technologies

### Current
- Node.js 17+, Express, TypeScript
- React 18, web3.js v1, ethers v5
- Solidity 0.8.28, Foundry
- pnpm workspace

### Planned
- Next.js 15, viem v2, wagmi v2
- TailwindCSS + shadcn/ui

## Development Workflow

1. Generate wallet: `pnpm generate`
2. Update `.env` with keys and ReCaptcha secret
3. Start backend: `pnpm dev`
4. Start frontend: `pnpm dev:ui`
5. Deploy contracts: `cd contracts && forge script ...`

## Context for All AI Assistants

This file (`LLM.md`) is symlinked as:
- `.AGENTS.md`
- `CLAUDE.md`
- `QWEN.md`
- `GEMINI.md`

All files reference the same knowledge base. Updates here propagate to all AI systems.

## Rules for AI Assistants

1. **ALWAYS** update LLM.md with significant discoveries
2. **NEVER** commit symlinked files (.AGENTS.md, CLAUDE.md, etc.) - they're in .gitignore
3. **NEVER** create random summary files - update THIS file

---

**Note**: This file serves as the single source of truth for all AI assistants working on this project.
