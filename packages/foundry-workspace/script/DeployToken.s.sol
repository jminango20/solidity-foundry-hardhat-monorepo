// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {Token} from "@contracts/Token.sol";

contract DeployToken is Script {
    function run() public returns (Token) {
        vm.startBroadcast();

        Token token = new Token();
        console.log("Token deployed at:", address(token));
        console.log("Total supply:", token.totalSupply());
        console.log("Deployer balance:", token.balanceOf(msg.sender));

        vm.stopBroadcast();
        return token;
    }
}
