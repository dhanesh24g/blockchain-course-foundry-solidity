// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
1. Deploy mocks to test on local Anvil chain
2. Keep track of different price feed addresses like - Sepolia, Mainnet, etc.
*/

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // Create a network selector behaviour below
    NetworkConfig public activeNetworkConfig;

    // MAGIC Numbers - These are used to pass some random / constant value
    uint256 public constant SEPOLIA_CHAINID = 11155111;
    uint32 public constant MAINNET_CHAINID = 1;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeedAddress;
    }

    constructor() {
        if (block.chainid == SEPOLIA_CHAINID) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == MAINNET_CHAINID) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    // Get Sepolia priceFeed address from below function
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeedAddress: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    // Get Mainnet ETH priceFeed address from below function
    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetEthConfig = NetworkConfig({
            priceFeedAddress: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return mainnetEthConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // 1. Deploy the mock contracts
        // 2. Return the mock address
        if (activeNetworkConfig.priceFeedAddress != address(0)) {
            return activeNetworkConfig;
        } // address(0) is default address & if is taken, then it means a priceFeed is already deployed

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilEthConfig = NetworkConfig({
            priceFeedAddress: address(mockPriceFeed)
        });
        return anvilEthConfig;
    }
}
