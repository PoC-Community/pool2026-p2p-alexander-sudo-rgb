// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SmartContract.sol";

// ---------------------------------------------------------
// 1. LE HELPER 
// ---------------------------------------------------------
contract SmartContractHelper is SmartContract {
    
    function getAreYouABadPerson() public view returns (bool) {
        return _areYouABadPerson; // L'enfant a le droit de lire ça !
    }
}

// ---------------------------------------------------------
// 2. LE TEST
// ---------------------------------------------------------
contract SmartContractTest is Test {
    SmartContractHelper public helper;

    function setUp() public {
        helper = new SmartContractHelper();
    }

    function testHalfAnswerOfLife() public {
        assertEq(helper.getHalfAnswerOfLife(), 21);
    }

    function testInternalVar() public {
        bool isBad = helper.getAreYouABadPerson();
        assertEq(isBad, false);
    }


    function testStructData() public {
        (
            string memory firstName, 
            string memory lastName, 
            uint8 age, 
            string memory city, 
            SmartContract.roleEnum role
        ) = helper.myInformations();

   
        assertEq(firstName, "Alexander");
        assertEq(lastName, "Salazar");
        assertEq(age, 18);
        assertEq(city, "Puteaux");
        assertEq(uint(role), uint(SmartContract.roleEnum.STUDENT));
    }
}