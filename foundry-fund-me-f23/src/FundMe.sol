// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

// Get funds from users into this contract
// Withdraw funds to the owner of the contract
// Minimum funding value in USD (Should be more than 5 USD)

import {PriceConverter, AggregatorV3Interface} from "./PriceConverter.sol";

// customer error
error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256; // all uint256 can use PriceConverter references

    // minimum 5 USD, converted in WEI for computation (constants are declared in CAPITAL)
    uint256 public constant MINIMUM_USD = 5e18;

    // storage variables should have 's_' as prefix
    AggregatorV3Interface private s_priceFeed;
    address[] private s_funders;
    mapping(address funder => uint256 amountFunded)
        private s_funderAddressToAmount;

    // immutable variable should have 'i_' as prefix
    address private immutable i_owner;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    // if fund() is not called, we should be able to handle it using -
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    // GETTERs -> view or pure functions for private variables
    function getFunderAddressToAmountMapping(
        address funderAddress
    ) external view returns (uint256) {
        return s_funderAddressToAmount[funderAddress];
    }

    function getFunders(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }

    function fund() public payable {
        //  Allow users to send $
        //  Have a restriction of minimum $

        // 1e18 wei = 1 * (10 ** 18) = 1 ETH (msg.value is always presented in wei)
        require(
            msg.value.getConversionRate(s_priceFeed) > MINIMUM_USD,
            "Did not send enough ETH !"
        ); // Message will be sent while reverting the transaction
        s_funders.push(msg.sender);
        s_funderAddressToAmount[msg.sender] += msg.value; // total amount sent by funder
    }

    function cheaperWithdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length;

        for (
            uint256 funderIndex = 0;
            funderIndex < fundersLength;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_funderAddressToAmount[funder] = 0;
        }
        s_funders = new address[](0);

        (bool callSucess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSucess, "Call failed");
    }

    function withdraw() public onlyOwner {
        for (
            uint8 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_funderAddressToAmount[funder] = 0;
        }
        s_funders = new address[](0);

        /* 
            Ways to send ETH / blockchain tokens - 
            can only be sent to PAYABLE addresses 
            1) transfer  (Max Gas - 2300 wei)   
            2) send  (Max Gas - 2300 wei)
            3) call     
        */

        (bool callSucess /* bytes memory dataReturned */, ) = payable(
            msg.sender
        ).call{value: address(this).balance}("");
        require(callSucess, "Call failed");

        //  payable(msg.sender).transfer(address(this).balance);    // will be auto-reverted if failed or gas is above 2300 wei

        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Only owner can invoke this !");
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }
}
