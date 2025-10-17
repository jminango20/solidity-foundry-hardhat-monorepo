import { expect } from "chai";
import { ethers } from "hardhat";

describe("Token", function () {
  async function deployTokenFixture() {
    const [owner, user1] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("Token");
    const token = await Token.deploy();
    return { token, owner, user1 };
  }

  describe("Deployment", function () {
    it("Should have correct name", async function () {
      const { token } = await deployTokenFixture();
      expect(await token.name()).to.equal("MyToken");
    });

    it("Should have correct symbol", async function () {
      const { token } = await deployTokenFixture();
      expect(await token.symbol()).to.equal("MTK");
    });

    it("Should mint initial supply to owner", async function () {
      const { token, owner } = await deployTokenFixture();
      const ownerBalance = await token.balanceOf(owner.address);
      expect(await token.totalSupply()).to.equal(ownerBalance);
    });
  });

  describe("Transactions", function () {
    it("Should transfer tokens between accounts", async function () {
      const { token, owner, user1 } = await deployTokenFixture();
      const amount = ethers.parseEther("50");

      await token.transfer(user1.address, amount);
      expect(await token.balanceOf(user1.address)).to.equal(amount);
    });
  });
});
