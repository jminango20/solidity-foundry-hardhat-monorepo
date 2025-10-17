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
├── setup.sh                   # Setup scripts
├── package.json               # Root package with npm scripts
├── .gitignore
└── README.md
```

## Quick Start

### Prerequisites

- Node.js v20 (LTS)
- Foundry ([installation guide](https://book.getfoundry.sh/getting-started/installation))
- **WSL** (for Windows users) - Foundry requires Linux/Mac/WSL

### Installation
```bash
# Clone the repository
# SSH (recommended):
git clone git@github.com:jminango20/solidity-foundry-hardhat-monorepo.git

# OR HTTPS:
git clone https://github.com/jminango20/solidity-foundry-hardhat-monorepo.git

cd solidity-foundry-hardhat-monorepo

# Run automated setup (Linux/Mac/WSL only)
./setup.sh

# Verify installation
npm run test:all
```

### What `setup.sh` does:
- Installs contracts dependencies (OpenZeppelin)  
- Installs `forge-std` for Foundry  
- Creates symlinks for shared contracts and dependencies  
- Installs Hardhat dependencies  
- Tests that both Foundry and Hardhat compile successfully

### Important: Windows Users
**Foundry requires WSL (Windows Subsystem for Linux).**

Run all commands in WSL, not in Git Bash or PowerShell:
```bash
# Open WSL
wsl

# Navigate to project
cd /mnt/c/your-path/solidity-foundry-hardhat-monorepo

# Run setup
./setup.sh
```

For Hardhat-only development on Windows without Foundry, you can skip the Foundry setup.


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

# Deploy to local network
# Terminal 1: anvil
# Terminal 2:
forge script script/DeployCounter.s.sol \
  --rpc-url http://127.0.0.1:8545 \
  --private-key  \
  --broadcast
```

### Hardhat Workspace
```bash
cd packages/hardhat-workspace

npm run compile                          # Compile contracts
npm test                                 # Run tests
npx hardhat test --grep "Counter"        # Run specific test

# Deploy scripts (simulation)
npx hardhat run scripts/deployCounter.ts
npx hardhat run scripts/deployToken.ts
npx hardhat run scripts/deploy.ts        # Deploy all

# Deploy to local network
# Terminal 1: npx hardhat node
# Terminal 2:
npx hardhat run scripts/deploy.ts --network localhost
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

## Deployment

### Local Development with Anvil (Foundry)
```bash
# Terminal 1: Start Anvil
anvil

# Terminal 2: Deploy with Foundry
cd packages/foundry-workspace
forge script script/DeployCounter.s.sol \
  --rpc-url http://127.0.0.1:8545 \
  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
  --broadcast
```

### Local Development with Hardhat Node
```bash
# Terminal 1: Start Hardhat node
cd packages/hardhat-workspace
npx hardhat node

# Terminal 2: Deploy
cd packages/hardhat-workspace
npx hardhat run scripts/deploy.ts --network localhost

### Testnet/Mainnet

Configure networks in `packages/hardhat-workspace/hardhat.config.ts` or `packages/foundry-workspace/foundry.toml` and deploy:

**Hardhat:**
```bash
npx hardhat run scripts/deploy.ts --network sepolia
```

**Foundry:**
```bash
forge script script/DeployCounter.s.sol \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --verify
```

## Contributing

1. Edit contracts in `packages/contracts/src/`
2. Write tests in both Foundry and Hardhat
3. Run `npm run test:all` before committing
4. Keep dependencies updated in `packages/contracts/package.json`

## Troubleshooting

### `./setup.sh: cannot execute: required file not found`

This happens on Windows when line endings are wrong. Fix:
```bash
sed -i 's/\r$//' setup.sh
chmod +x setup.sh
./setup.sh
```

### Symlinks not working?

Run `./setup.sh` again or manually create them:
```bash
# Foundry symlink
cd packages/foundry-workspace/lib
ln -s ../../contracts/node_modules node_modules

# Hardhat symlinks
cd packages/hardhat-workspace
ln -s ../contracts/src contracts
cd node_modules
ln -s ../../contracts/node_modules/@openzeppelin @openzeppelin
```

### Compilation errors?

1. Ensure all dependencies are installed: `cd packages/contracts && npm install`
2. Check that symlinks exist: `ls -la packages/hardhat-workspace/contracts`
3. Re-run setup: `./setup.sh`