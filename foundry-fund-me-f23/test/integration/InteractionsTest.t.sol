// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundMe} from "../../src/FundMe.sol";
import {FundTheFundMe, WithdrawFromFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.01 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 5;

    function setUp() external {
        DeployFundMe deployed = new DeployFundMe();
        fundMe = deployed.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        // Fund the contract
        FundTheFundMe testFunding = new FundTheFundMe();
        testFunding.run(address(fundMe));
        console.log("FundMe current balance: ", address(fundMe).balance);

        // Withdraw from the contract
        WithdrawFromFundMe testWithdrawing = new WithdrawFromFundMe();
        testWithdrawing.run(address(fundMe));

        assert((address(fundMe).balance == 0));
    }
}
