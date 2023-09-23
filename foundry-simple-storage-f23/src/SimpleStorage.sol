// SPDX-License-Identifier: MIT
/* pragma solidity version meaning -
    >= 0.7.18 < 0.9.0  -> GTE 0.7.18 & LT 0.9.0
    ^0.8.18            -> GTE 0.8.18 & LT 0.9.0
*/
pragma solidity ^0.8.18; // solidity version declaration

contract SimpleStorage {
    uint256 myFavoriteNum; // by-default initializes to 0 with INTERNAL visibility

    struct Person {
        uint256 favoriteNum;
        string name;
    }

    // dynamic array (without size mentioned)
    Person[] public listOfPeople; // defaulted to empty list - []

    // Person newPerson = Person(24, "Dhanesh");
    // Above struct variable is a STORAGE variable by-default & hence MEMORY is not mentioned

    // a mapping of name to favoriteNumber
    mapping(string => uint256) public nameToFavNumber;

    function store(uint256 _favoriteNum) public {
        myFavoriteNum = _favoriteNum;
    }

    // pure function disallows state change & returns only non-variables
    // view function is only for reading values (with state change)
    function retrieve() public view returns (uint256) {
        return myFavoriteNum;
    }

    function addPerson(uint256 _favNumber, string memory _name) public {
        // Person memory _newPerson = Person({favoriteNum: _favNumber, name: _name});
        listOfPeople.push(Person(_favNumber, _name));
        nameToFavNumber[_name] = _favNumber;
    }
}
