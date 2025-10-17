import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  // Deploy Counter
  console.log("\n=== Deploying Counter ===");
  const Counter = await ethers.getContractFactory("Counter");
  const counter = await Counter.deploy();
  await counter.waitForDeployment();
  const counterAddress = await counter.getAddress();
  console.log(`Counter deployed to: ${counterAddress}`);

  // Deploy Token
  console.log("\n=== Deploying Token ===");
  const Token = await ethers.getContractFactory("Token");
  const token = await Token.deploy();
  await token.waitForDeployment();
  const tokenAddress = await token.getAddress();
  const totalSupply = await token.totalSupply();
  
  console.log(`Token deployed to: ${tokenAddress}`);
  console.log(`Total supply: ${ethers.formatEther(totalSupply)} MTK`);
  
  console.log("\n=== Deployment Summary ===");
  console.log(`Counter: ${counterAddress}`);
  console.log(`Token: ${tokenAddress}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
