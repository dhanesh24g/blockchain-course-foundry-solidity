// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

// always mention the contract name/s that are to be imported from the file, using { , }
import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {

    // dataType visibility varName;
    SimpleStorage[] public listOfSimpleStorageContracts;

    function createSimpleStorageContract()  public {

        // NEW keyword tells solidity to deploy a contract
        SimpleStorage newSimpleStorageContract = new SimpleStorage();
        listOfSimpleStorageContracts.push(newSimpleStorageContract);
    }

    function sfStore(uint256 _contractIndex, uint256 _newSimpleStorageNumber) public {

        // we need the Contract ADDRESS & the ABI (Application Binary Interface) to interact with it
        SimpleStorage mySimpleStorage = listOfSimpleStorageContracts[_contractIndex];
        mySimpleStorage.store(_newSimpleStorageNumber);
    }

    function sfRetrieve(uint256 _contractIndex) public view returns(uint256) {
        // a better way to call RETRIEVE function without creating a new variable
        return listOfSimpleStorageContracts[_contractIndex].retrieve();
    } 
}