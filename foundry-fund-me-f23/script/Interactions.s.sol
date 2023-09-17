// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundTheFundMe is Script {
    uint256 private constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address recentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(recentlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded contract with ", SEND_VALUE, " ethers");
    }

    function run(address fundMeAddress) external {
        /* 
            We can use DevOps script to fetch the address of latest deployed contract
            Instead I chose to refer the address from broadcast folder directly  
        */
        fundFundMe(fundMeAddress);
    }
}

contract WithdrawFromFundMe is Script {
    function withdrawFromFundMe(address recentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(recentlyDeployed)).withdraw();
        vm.stopBroadcast();
    }

    function run(address fundMeAddress) external {
        /* 
            We can use DevOps script to fetch the address of latest deployed contract
            Instead I chose to refer the address from broadcast folder directly  
        */
        withdrawFromFundMe(fundMeAddress);
    }
}
