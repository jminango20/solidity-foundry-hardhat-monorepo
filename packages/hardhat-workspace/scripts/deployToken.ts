import { ethers } from "hardhat";

async function main() {
  console.log("Deploying Token...");

  const Token = await ethers.getContractFactory("Token");
  const token = await Token.deploy();

  await token.waitForDeployment();

  const address = await token.getAddress();
  const totalSupply = await token.totalSupply();
  const [deployer] = await ethers.getSigners();
  const deployerBalance = await token.balanceOf(deployer.address);

  console.log(`Token deployed to: ${address}`);
  console.log(`Total supply: ${ethers.formatEther(totalSupply)} MTK`);
  console.log(`Deployer balance: ${ethers.formatEther(deployerBalance)} MTK`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
