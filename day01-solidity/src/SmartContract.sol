// Step 0.04 - Advanced Types


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SmartContract {
    // Public
    uint256 public halfAnswerOfLife = 21;
    address public myEthereumContractAddress = address(this);
    address public myEthereumAddress = msg.sender;
    bytes32 public whoIsTheBest = "It's Sunless"; 
    string public PoCIsWhat = "PoC is good, PoC is life.";
    mapping(string => uint256) public myGrades;
    string[5] public myPhoneNumber;
    enum roleEnum { STUDENT, TEACHER }
    // Internal
    bool internal _areYouABadPerson = false;
    // Private
    int256 private _youAreACheater = -42;
    // Define the struct
    struct Person {
        string name;
        uint8 age;
    }
    // Create a structure
    struct informations{
        string firstName;
        string lastName;
        uint8 age;
        string city;
        roleEnum role;
    }

    // Create an instance
    informations public myInformations = informations({
        firstName : "Alexander",
        lastName : "Salazar",
        age : 18,
        city :"Puteaux",
        role : roleEnum.STUDENT
    });

    Person public alice = Person({
        name: "Alice",
        age: 25
    });



    // View function - reads but doesn't write
    function getNumber() public view returns (uint256) {
        return halfAnswerOfLife;
    }

    // Pure function - just calculates
    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }

    //task


    function getHalfAnswerOfLife() public view returns (uint256) {
        return halfAnswerOfLife;
    }

    function _getMyEthereumContractAddress() internal view returns (address) {
        return myEthereumContractAddress;
    }

    function getPoCIsWhat() external view returns (string memory) {
        return PoCIsWhat;
    }

    function _setAreYouABadPerson(bool _value) internal {
        _areYouABadPerson = _value;
    }


}


