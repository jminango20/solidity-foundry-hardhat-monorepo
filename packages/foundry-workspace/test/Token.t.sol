// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Token} from "@contracts/Token.sol";
import {Test} from "forge-std/Test.sol";

contract TokenTest is Test {
    Token public token;
    address public owner;
    address public user1;

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        token = new Token();
    }

    function test_InitialSupply() public view {
        assertEq(token.totalSupply(), 1000000 * 10 ** 18);
    }

    function test_OwnerBalance() public view {
        assertEq(token.balanceOf(owner), 1000000 * 10 ** 18);
    }

    function test_Transfer() public {
        uint256 amount = 100 * 10 ** 18;
        token.transfer(user1, amount);
        assertEq(token.balanceOf(user1), amount);
    }

    function test_Name() public view {
        assertEq(token.name(), "MyToken");
    }

    function test_Symbol() public view {
        assertEq(token.symbol(), "MTK");
    }
}
