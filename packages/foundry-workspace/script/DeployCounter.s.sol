// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {Counter} from "@contracts/Counter.sol";

contract DeployCounter is Script {
    function run() public returns (Counter) {
        vm.startBroadcast();

        Counter counter = new Counter();
        console.log("Counter deployed at:", address(counter));

        vm.stopBroadcast();
        return counter;
    }
}
