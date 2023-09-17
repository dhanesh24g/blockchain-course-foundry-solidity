// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

// Get funds from users into this contract
// Withdraw funds to the owner of the contract
// Minimum funding value in USD (Should be more than 5 USD)

import {PriceConverter} from "./PriceConverter.sol";

// customer error
error notOwner();

contract FundMe {
    using PriceConverter for uint256;
    // minimum 5 USD, converted in WEI for computation  
    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public funderAddressToAmount;

    address public immutable i_owner;

    constructor()   {
        i_owner = msg.sender;
    }

    function fund() public payable {
        //  Allow users to send $
        //  Have a restriction of minimum $

        // 1e18 wei = 1 * (10 ** 18) = 1 ETH (msg.value is always presented in wei)
        require(msg.value.getConversionRate() > MINIMUM_USD, "Did not send enough ETH !");   // Message will be sent while reverting the transaction
        funders.push(msg.sender);
        funderAddressToAmount[msg.sender] += msg.value;  // total amount sent by funder
    }

    function withdraw() public onlyOwner {
        
        for (uint8 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            funderAddressToAmount[funder] = 0;
        }
        funders = new address[](0);

        /* Ways to send ETH / blockchain tokens - 
            can only be sent to PAYABLE addresses 
            1) transfer  (Max Gas - 2300 wei)   
            2) send  (Max Gas - 2300 wei)
            3) call     */
        
        (bool callSucess, /* bytes memory dataReturned */) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSucess, "Call failed");

        //  payable(msg.sender).transfer(address(this).balance);    // will be auto-reverted if failed or gas is above 2300 wei

        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
    }

    modifier onlyOwner()    {
        // require(msg.sender == i_owner, "Only owner can invoke this !");
        if (msg.sender != i_owner)  { revert notOwner();  }
        _;
    }

    // if fund() is not called, we should be able to handle it using -
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}