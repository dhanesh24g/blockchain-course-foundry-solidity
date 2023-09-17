// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "../lib/forge-std/src/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    function run() external returns (SimpleStorage) {
        vm.startBroadcast(); // vm is a cheatcode, specific to FOUNDRY
        SimpleStorage simpleStorage = new SimpleStorage();
        // everything btwn startBroadcast & stopBroadcast will be sent to the RPC URL (transaction)
        vm.stopBroadcast();
        return simpleStorage;
    }
}
