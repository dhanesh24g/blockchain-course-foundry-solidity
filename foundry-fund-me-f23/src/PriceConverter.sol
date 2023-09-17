// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        // ETH to USD price feed address - 0x694AA1769357215DE4FAC081bf1f309aDC325306
        (, int256 price, , , ) = priceFeed.latestRoundData(); // will return 163200000000 - data with 8 decimal places

        // msg.value has 18 decimals & hence PRICE needs to have extra 10
        return uint256(price * 1e10);
    }

    function getConversionRate(
        uint256 fundAmountInETH,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPriceInUSD = getPrice(priceFeed);
        // Convert msg.value to USD price
        // we will get 36 decimals & hence need to devide by 1e18
        uint256 fundAmountInUSD = (fundAmountInETH * ethPriceInUSD) / 1e18;
        return fundAmountInUSD;
    }
}
