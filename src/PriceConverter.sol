// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice() internal view returns (uint256) {
        // 0x694AA1769357215DE4FAC081bf1f309aDC325306
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (, int256 price, , , ) = priceFeed.latestRoundData();
        // Price of ETH in USD
        return uint256(price * 1e10);
    }

    function getConversionRate(
        uint256 ethAmount
    ) internal view returns (uint256) {
        // 1 ETH???
        // 2000_000000000000000000
        // 2000, 18 zeros
        uint256 ethPrice = getPrice();
        // (2000_000000000000000000 * 1_000000000000000000) /1e18 -> dividing because we dont want 36 zeros
        // THERE ARE NO DECIMAL NUMBERS IN SOLIDITY
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion() internal view returns (uint256) {
        return
            AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
                .version();
    }
}
