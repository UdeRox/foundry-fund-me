// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint constant SEND_VALUE = 0.1 ether;
    uint constant INITIAL_FUNDS = 10 ether;

    modifier funded() {
        vm.prank(USER);
        vm.deal(USER, INITIAL_FUNDS);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

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
        console.log("Owner : ", fundMe.getOwner());
        console.log("Msg Sender : ", msg.sender);
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testSendWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testSendEnoughEth() public funded {
        assertEq(fundMe.getAddressToAmount(USER), SEND_VALUE);
    }

    function testWithdrawUser() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawFundsOnlyOwner() public funded {
        //arrage
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        //asset
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            endingOwnerBalance,
            startingOwnerBalance + startingFundMeBalance
        );
    }

function testCheapWithDrawOwnerWithMultipleFunders() public funded {
        //arrange
        uint160 startingIndex = 1;
        uint160 fundersArray = 10;
        for (uint160 i = startingIndex; i < fundersArray; i++) {
            vm.prank(address(i));
            vm.deal(address(i), INITIAL_FUNDS);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        //act
        vm.startPrank(fundMe.getOwner());
        fundMe.cheapWithdraw();
        vm.stopPrank();
        //assert
        assert(address(fundMe).balance == 0);
        assert(
            startingOwnerBalance + startingFundMeBalance ==
                fundMe.getOwner().balance
        );
    }
    function testWithDrawOwnerWithMultipleFunders() public funded {
        //arrange
        uint160 startingIndex = 1;
        uint160 fundersArray = 10;
        for (uint160 i = startingIndex; i < fundersArray; i++) {
            vm.prank(address(i));
            vm.deal(address(i), INITIAL_FUNDS);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        //act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();
        //assert
        assert(address(fundMe).balance == 0);
        assert(
            startingOwnerBalance + startingFundMeBalance ==
                fundMe.getOwner().balance
        );
    }

    function testAddFunderToArrayOfFunders() public funded {
        // fundMe.getFunder()
        address funder = fundMe.getFunder(0);
        assertEq(USER, funder);
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
}