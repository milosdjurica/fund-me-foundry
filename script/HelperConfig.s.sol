// SPDX-License-Identifier: MIT

// 1. Deploy mocks when we are on local anvil chain
// 2. Keep track of contract address across different chains
// Sepolia ETH/USD !== Mainnet ETH/USD

pragma solidity ^0.8.19;

import {Script} from "../lib/forge-std/src/Script.sol";

contract HelperConfig is Script {
    // if on local anvil chain, deploy mocks
    // Otherwise, grab the existing address from the live network
    NetworkConfig public activeNetworkConfig;

    constructor() {
        // ! this is Sepolia chain ID is 11155111 and for mainnet it is 1
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaETHConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetETHConfig();
        } else {
            activeNetworkConfig = getMainnetETHConfig();
        }
    }

    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed address
    }

    function getSepoliaETHConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        return
            NetworkConfig({
                priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            });
    }

    function getMainnetETHConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        return
            NetworkConfig({
                priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
            });
    }

    function getAnvilETHConfig() public pure returns (NetworkConfig memory) {
        // price feed address
    }
}
