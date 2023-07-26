// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        console.log("Initialized the test setup");
        DeployFundMe deployer = new DeployFundMe();
        fundMe = deployer.run();
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function testMinimumTransferAmount() public {
        assertEq(fundMe.MINIUMUM_USD(), 50 * 1e18);
    }

    function testOwnerIsMessageSender() public {
        console.log("Owner : ", fundMe.i_owner());
        console.log("Msg Sender : ", msg.sender);
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version,4);
    }
}
