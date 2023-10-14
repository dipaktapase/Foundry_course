// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Needed in Contract

// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD, 1e18 => 1 ETH

import {PriceConverter} from "PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    // By adding constant keyword we saved 20,000 gas
    uint256 public constant MINIMUN_USD = 5e18; // 5 * (10 ** 18) === 5 * 1e18 //303 2402
    address[] public funders;
    mapping(address funder => uint256 amountFunded)
        public addressToAmountFunded;
    address public immutable i_owner; //439 2574

    // immutable and constant keywords save gas because
    // instead of storing variables at storage we store at bycode of the contract
    // use it when declared or updated once

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= MINIMUN_USD,
            "Minimun deposit is 5 USD"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);
        // Withdraw the funds

        // transfer
        // payable(msg.sender).transfer(address(this).balance);

        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed"); // It only reverts if this line is here

        // call (Recommended way)
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Sender is not owner!");
        if (msg.sender != i_owner) {
            revert NotOwner();
        } // Custom error handleling for gas optimization
        _;
    }

    // receive and fallback when someone sends this contract ETH without calling the fund function
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
