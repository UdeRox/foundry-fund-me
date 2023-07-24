// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

//790710
//771015

//771015 with constant
//669449

//748398 with immutable
//647136

//748398
//647136
contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIUMUM_USD = 50 * 1e18;
    address public immutable i_owner;
    // uint256 public minimumUsd = 5;

    address[] public founders;
    mapping(address => uint256) public founderToAmountFounded;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= MINIUMUM_USD,
            "Didn't send enoguh ETH"
        );
        founders.push(msg.sender);
        founderToAmountFounded[msg.sender] += msg.value;
    }

    function withdraw() public {
        for (
            uint256 founderIndex = 0;
            founderIndex < founders.length;
            founderIndex++
        ) {
            address founderAddress = founders[founderIndex];
            founderToAmountFounded[founderAddress] = 0;
        }
        founders = new address[](0);

        //transfer
        // payable(msg.sender).transfer(address(this).balance);

        //send
        // bool withdrawSuccess =  payable(msg.sender).send(address(this).balance);
        // require(withdrawSuccess, "Withdraw failed!");

        //call
        (bool withdrawSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(withdrawSuccess, "Withdraw failed!");
    }

    function getVersion() public view returns (uint256) {
        return
            AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
                .version();
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Sender is should be owner!");
        _;
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}
