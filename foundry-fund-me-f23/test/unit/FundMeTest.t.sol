// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {Script} from "forge-std/Script.sol";

contract FundMeTest is Test, Script {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.01 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 5;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    modifier prankFunded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testMinFiveUSD() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwner() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersion() public {
        assertEq(fundMe.getVersion(), 4);
    }

    function testRevertOnLowETH() public {
        vm.expectRevert(); // expectRevert will succeed only if the below statement fails
        fundMe.fund(); // MINIMUM_USD is not sent, so this will fail
        // fundMe.fund{value: 6e18}(); // Way to send value for FUND function
    }

    function testForUpdateInFunders() public {
        // prank - next transaction will be sent by USER (address)`
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        // here the funder is FundMeTest contract, hence address(this)
        // uint256 amountFunded = fundMe.getFunderAddressToAmountMapping(address(this));
        uint256 amountFunded = fundMe.getFunderAddressToAmountMapping(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testArrayOfFunders() public prankFunded {
        // first address in FUNDERs array should be USER
        assertEq(fundMe.getFunders(0), USER);
    }

    function testOnlyOwnerCanWithdraw() public prankFunded {
        vm.expectRevert();
        // expectRevert will succeed only if the below statement fails - OWNER not calling WITHDRAW
        fundMe.withdraw();
    }

    function testWithdrawWithSampleFunder() public {
        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        console.log("startingOwnerBalance:", startingOwnerBalance);

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        /*    
            uint256 gasAtStart = gasleft();
            vm.txGasPrice(GAS_PRICE);
            vm.prank(fundMe.getOwner());
            fundMe.withdraw();
            uint256 gasAtEnd = gasleft();
            uint256 gasUsed = (gasAtStart - gasAtEnd) * tx.gasprice;
            console.log(gasUsed);   
        */

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        console.log("endingOwnerBalance:", endingOwnerBalance);
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            endingOwnerBalance
        );
    }

    function testWithdrawFromMultipleFunders() public {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1; // address(0) is usually the default address & hence not feasible

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), STARTING_BALANCE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // Assert
        assert(address(fundMe).balance == 0);
        assert(
            fundMe.getOwner().balance ==
                startingOwnerBalance + startingFundMeBalance
        );
    }

    function testCheaperWithdrawFromMultipleFunders() public {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1; // address(0) is usually the default address & hence not feasible

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), STARTING_BALANCE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        // Assert
        assert(address(fundMe).balance == 0);
        assert(
            fundMe.getOwner().balance ==
                startingOwnerBalance + startingFundMeBalance
        );
    }
}
