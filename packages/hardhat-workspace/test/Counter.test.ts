import { expect } from "chai";
import { ethers } from "hardhat";

describe("Counter", function () {
  async function deployCounterFixture() {
    const Counter = await ethers.getContractFactory("Counter");
    const counter = await Counter.deploy();
    return { counter };
  }

  describe("Deployment", function () {
    it("Should start with number 0", async function () {
      const { counter } = await deployCounterFixture();
      expect(await counter.number()).to.equal(0);
    });
  });

  describe("Operations", function () {
    it("Should increment", async function () {
      const { counter } = await deployCounterFixture();
      await counter.increment();
      expect(await counter.number()).to.equal(1);
    });

    it("Should set number", async function () {
      const { counter } = await deployCounterFixture();
      await counter.setNumber(42);
      expect(await counter.number()).to.equal(42);
    });

    it("Should decrement", async function () {
      const { counter } = await deployCounterFixture();
      await counter.setNumber(10);
      await counter.decrement();
      expect(await counter.number()).to.equal(9);
    });
  });
});
