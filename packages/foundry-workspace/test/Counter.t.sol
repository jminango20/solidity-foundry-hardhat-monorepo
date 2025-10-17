// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Counter} from "@contracts/Counter.sol";
import {Test} from "forge-std/Test.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }

    function test_Decrement() public {
        counter.setNumber(10);
        counter.decrement();
        assertEq(counter.number(), 9);
    }
}
