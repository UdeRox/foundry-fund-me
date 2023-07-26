// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        vm.startBroadcast();
        FundMe newFundMe = new FundMe(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        vm.stopBroadcast();
        return newFundMe;
    }
}
