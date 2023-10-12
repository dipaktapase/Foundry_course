// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 myFavoriteNumber;

    // Struct ( Custom types )
    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    // Person public pat = Person({favoriteNumber: 5, name: "Pat"});
    Person[] public listOfPeople;

    mapping (string => uint256) public nameToFavoriteNumber;

    function store(uint _favoriteNumber) public virtual {
        myFavoriteNumber = _favoriteNumber;
    }

    // view, pure
    function retrieve() public view returns(uint256) {
        return myFavoriteNumber;
    }

    // calldata, memory => it is temporaray. storage varibles are permentant
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        listOfPeople.push(Person(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}