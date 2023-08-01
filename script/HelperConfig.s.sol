// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "@chainlink/contracts/src/v0.8/tests/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;
    struct NetworkConfig {
        address priceFeed;
    }

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilConfig();
        }
    }

    function getMainnetConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory networkConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return networkConfig;
    }

    function getOrCreateAnvilConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();
        NetworkConfig memory networkConfig = NetworkConfig({
            priceFeed: address(mockV3Aggregator)
        });
        return networkConfig;
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory networkConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return networkConfig;
    }
}
