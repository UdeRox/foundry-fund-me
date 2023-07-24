// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        console.log("Initialized the test setup");
        fundMe = new FundMe();
    }

    function testMinimumTransferAmount() public {
        assertEq(fundMe.MINIUMUM_USD(), 50 * 1e18);
    }

    function testOwnerIsMessageSender() public {
        console.log("Owner : ", fundMe.i_owner());
        console.log("Msg Sender : ", msg.sender);
        assertEq(fundMe.i_owner(), address(this));
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version,4);
    }
}
