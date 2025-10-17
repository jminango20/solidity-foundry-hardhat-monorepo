#!/bin/bash

echo "Setting up Solidity Foundry + Hardhat Monorepo..."
echo ""

# Install contracts dependencies
echo "📦 Installing contracts dependencies..."
cd packages/contracts
npm install
cd ../..

# Setup Foundry
echo "⚒️  Setting up Foundry workspace..."
cd packages/foundry-workspace

# Install forge-std if not exists
if [ ! -d "lib/forge-std" ]; then
    echo "Installing forge-std..."
    forge install foundry-rs/forge-std --no-commit
else
    echo "✓ forge-std already installed"
fi

# Create symlink for node_modules if not exists
if [ -L "lib/node_modules" ]; then
    echo "✓ Symlink lib/node_modules already exists"
elif [ -e "lib/node_modules" ]; then
    echo "⚠️  lib/node_modules exists but is not a symlink, removing..."
    rm -rf lib/node_modules
    cd lib
    ln -s ../../contracts/node_modules node_modules
    echo "✓ Created symlink: lib/node_modules -> ../../contracts/node_modules"
    cd ..
else
    echo "Creating symlink: lib/node_modules -> ../../contracts/node_modules"
    cd lib
    ln -s ../../contracts/node_modules node_modules
    cd ..
fi

cd ../..

# Setup Hardhat
echo "🔨 Setting up Hardhat workspace..."
cd packages/hardhat-workspace

# Install Hardhat dependencies
echo "Installing Hardhat dependencies..."
npm install

# Create symlink for contracts if not exists
if [ -L "contracts" ]; then
    echo "✓ Symlink contracts already exists"
elif [ -e "contracts" ]; then
    echo "⚠️  contracts exists but is not a symlink, removing..."
    rm -rf contracts
    ln -s ../contracts/src contracts
    echo "✓ Created symlink: contracts -> ../contracts/src"
else
    echo "Creating symlink: contracts -> ../contracts/src"
    ln -s ../contracts/src contracts
fi

# Create symlink for @openzeppelin if not exists
if [ -L "node_modules/@openzeppelin" ]; then
    echo "✓ Symlink @openzeppelin already exists"
elif [ -e "node_modules/@openzeppelin" ]; then
    echo "⚠️  @openzeppelin exists but is not a symlink, removing..."
    rm -rf node_modules/@openzeppelin
    cd node_modules
    ln -s ../../contracts/node_modules/@openzeppelin @openzeppelin
    echo "✓ Created symlink: node_modules/@openzeppelin -> ../../contracts/node_modules/@openzeppelin"
    cd ..
else
    echo "Creating symlink: node_modules/@openzeppelin -> ../../contracts/node_modules/@openzeppelin"
    cd node_modules
    ln -s ../../contracts/node_modules/@openzeppelin @openzeppelin
    cd ..
fi

cd ../..

echo ""
echo "✅ Setup complete!"
echo ""
echo "🧪 Testing installation..."
cd packages/foundry-workspace
forge build
if [ $? -eq 0 ]; then
    echo "✅ Foundry: Build successful!"
else
    echo "❌ Foundry: Build failed"
    exit 1
fi

cd ../hardhat-workspace
npm run compile > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Hardhat: Compilation successful!"
else
    echo "❌ Hardhat: Compilation failed"
    exit 1
fi

cd ../..

echo ""
echo "📋 Next steps:"
echo "  • Test Foundry: cd packages/foundry-workspace && forge test"
echo "  • Test Hardhat: cd packages/hardhat-workspace && npm test"
echo "  • Run all tests: npm run test:all"
echo ""
