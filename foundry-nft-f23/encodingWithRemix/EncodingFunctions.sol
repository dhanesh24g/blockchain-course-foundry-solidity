// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/** 
    1. Both functions generate the same output -
    getEncodedWithSelector & getEncodedWithSignature
*/

contract EncodingFunctions {
    address public s_myAddress;
    uint256 public s_amount;
    uint256 public s_testToken;

    function assignValues(
        address _myAddress,
        uint256 _amount,
        uint256 _testToken
    ) public {
        s_myAddress = _myAddress;
        s_amount = _amount;
        s_testToken = _testToken;
    }

    function getFunctionSelector() public pure returns (bytes4 selector) {
        selector = bytes4(keccak256(bytes(getFunctionSignature())));
    }

    function getFunctionSignature() public pure returns (string memory) {
        return "assignValues(address,uint256,uint256)";
    }

    // Using encodeWithSelector to get the encoded arguments
    function getEncodedWithSelector(
        address _myAddress,
        uint256 _amount,
        uint256 _testToken
    ) public pure returns (bytes memory) {
        return (
            abi.encodeWithSelector(
                getFunctionSelector(),
                _myAddress,
                _amount,
                _testToken
            )
        );
    }

    // Assign actual values using encodeWithSelector function
    function assignActualValuesWithSelector(
        address _myAddress,
        uint256 _amount,
        uint256 _testToken
    ) public returns (bool, bytes4) {
        (bool isSuccess, bytes memory data) = address(this).call(
            getEncodedWithSelector(_myAddress, _amount, _testToken)
        );
        return (isSuccess, bytes4(data));
    }

    // Using encodeWithSignature to get the encoded arguments
    function getEncodedWithSignature(
        address _myAddress,
        uint256 _amount,
        uint256 _testToken
    ) public pure returns (bytes memory) {
        return (
            abi.encodeWithSignature(
                getFunctionSignature(),
                _myAddress,
                _amount,
                _testToken
            )
        );
    }

    // Assign actual values using encodeWithSignature function
    function assignActualValuesWithSignature(
        address _myAddress,
        uint256 _amount,
        uint256 _testToken
    ) public returns (bool, bytes4) {
        (bool isSuccess, bytes memory returnData) = address(this).call(
            getEncodedWithSignature(_myAddress, _amount, _testToken)
        );
        return (isSuccess, bytes4(returnData));
    }
}
