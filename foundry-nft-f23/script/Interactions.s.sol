// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract MintBasicNft is Script {
    string public constant PUG_URI =
        "ipfs://QmQajwEnYL73JHyudjFCQ3bJ2B9Ydw75SCs3kXeacNweWj?filename=myPug-dg.json";

    function run() external {
        address recentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "BasicNft",
            block.chainid
        );

        mintNftOnContract(recentlyDeployed);
    }

    function mintNftOnContract(address _contractAddress) public {
        vm.startBroadcast();
        BasicNft(_contractAddress).mintNft(PUG_URI);
    }
}
