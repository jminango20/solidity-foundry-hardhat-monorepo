# Solidity Foundry + Hardhat Monorepo

A monorepo setup where **Foundry** and **Hardhat** share the same Solidity contracts, with a single source of truth for dependencies.

## Structure
```
solidity-foundry-hardhat-monorepo/
├── packages/
│   ├── contracts/              # Single source of truth
│   │   ├── src/               # Smart contracts here
│   │   ├── node_modules/      # OpenZeppelin & dependencies
│   │   └── package.json
│   │
│   ├── foundry-workspace/     # Foundry development environment
│   │   ├── lib/
│   │   │   ├── forge-std/
│   │   │   └── node_modules/  # → Symlink to ../contracts/node_modules
│   │   ├── test/              # Solidity tests
│   │   ├── script/            # Deploy scripts
│   │   └── foundry.toml
│   │
│   └── hardhat-workspace/     # Hardhat development environment
│       ├── contracts/         # → Symlink to ../contracts/src
│       ├── node_modules/
│       │   └── @openzeppelin/ # → Symlink to ../../contracts/node_modules/@openzeppelin
│       ├── test/              # TypeScript tests
│       ├── scripts/           # Deploy scripts
│       ├── hardhat.config.ts
│       └── package.json
│
├── package.json               # Root package with npm scripts
├── .gitignore
└── README.md
```

## Quick Start

### Prerequisites

- Node.js v20 (LTS)
- Foundry ([installation guide](https://book.getfoundry.sh/getting-started/installation))

### Installation
```bash
# Clone the repository
git clone https://github.com/jminango20/solidity-foundry-hardhat-monorepo.git
cd solidity-foundry-hardhat-monorepo

# Install dependencies
cd packages/contracts
npm install

cd ../hardhat-workspace
npm install

# Setup symlinks (should already be in git)
# If needed, create manually:
cd packages/foundry-workspace/lib
ln -s ../../contracts/node_modules node_modules

cd ../../hardhat-workspace
ln -s ../contracts/src contracts
cd node_modules
ln -s ../../contracts/node_modules/@openzeppelin @openzeppelin
```

## Available Commands

### Root Level
```bash
npm run foundry:build      # Build with Foundry
npm run foundry:test       # Test with Foundry
npm run hardhat:compile    # Compile with Hardhat
npm run hardhat:test       # Test with Hardhat
npm run test:all          # Run all tests (Foundry + Hardhat)
```

### Foundry Workspace
```bash
cd packages/foundry-workspace

forge build                              # Compile contracts
forge test                               # Run tests
forge test -vvv                          # Run tests with detailed output
forge test --match-test test_Increment   # Run specific test

# Deploy scripts (simulation)
forge script script/DeployCounter.s.sol
forge script script/DeployToken.s.sol
```

### Hardhat Workspace
```bash
cd packages/hardhat-workspace

npm run compile                          # Compile contracts
npm test                                 # Run tests
npx hardhat test --grep "Counter"        # Run specific test

# Deploy scripts
npx hardhat run scripts/deployCounter.ts
npx hardhat run scripts/deployToken.ts
npx hardhat run scripts/deploy.ts        # Deploy all
```

## How It Works

### Single Source of Truth

All Solidity contracts live in **`packages/contracts/src/`**. Both Foundry and Hardhat read from this same location using:

- **Foundry**: Direct path via `foundry.toml` (`src = "../contracts/src"`)
- **Hardhat**: Symlink (`hardhat-workspace/contracts -> ../contracts/src`)

### Shared Dependencies

OpenZeppelin and other dependencies are installed once in `packages/contracts/node_modules/` and accessed by both frameworks:

- **Foundry**: Via symlink `lib/node_modules -> ../../contracts/node_modules`
- **Hardhat**: Via symlink `node_modules/@openzeppelin -> ../../contracts/node_modules/@openzeppelin`

### Benefits

**Edit once, test everywhere**: Modify contracts in one place, both frameworks see changes instantly  
**No version conflicts**: Single installation of dependencies (OpenZeppelin, etc.)  
**Developer freedom**: Use Foundry for fast testing, Hardhat for TypeScript integration  

## Adding Contracts
```bash
# 1. Create contract
cd packages/contracts/src
touch MyNewContract.sol

# 2. Both frameworks see it immediately
cd ../../foundry-workspace
forge build  # Compiles

cd ../hardhat-workspace
npm run compile  # Compiles
```

## Adding Dependencies
```bash
# Install in contracts package
cd packages/contracts
npm install @openzeppelin/contracts-upgradeable

# Both frameworks have access automatically via symlinks
```

## 🚢 Deployment

### Local Development
```bash
# Terminal 1: Start local node
cd packages/hardhat-workspace
npx hardhat node

# Terminal 2: Deploy
npx hardhat run scripts/deploy.ts --network localhost
```

### Testnet/Mainnet

Configure networks in `packages/hardhat-workspace/hardhat.config.ts` and deploy:
```bash
npx hardhat run scripts/deploy.ts --network sepolia
```

Or use Foundry:
```bash
cd packages/foundry-workspace
forge script script/DeployCounter.s.sol --rpc-url <RPC_URL> --private-key <KEY> --broadcast
```

## Contributing

1. Edit contracts in `packages/contracts/src/`
2. Write tests in both Foundry and Hardhat
3. Run `npm run test:all` before committing
4. Keep dependencies updated in `packages/contracts/package.json`