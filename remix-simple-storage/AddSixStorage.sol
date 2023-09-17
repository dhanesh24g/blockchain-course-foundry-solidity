//  SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

contract AddSixStorage is SimpleStorage {

    function store(uint256 _newFavNumber) public override {
        myFavoriteNum = _newFavNumber + 6;
    }
}