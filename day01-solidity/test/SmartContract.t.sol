// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SmartContract.sol";

// ---------------------------------------------------------
// 1. LE HELPER 
// ---------------------------------------------------------
contract SmartContractHelper is SmartContract {

    function getAreYouABadPerson() public view returns (bool) {
        return _areYouABadPerson;
    }
}

// ---------------------------------------------------------
// 2. LE TEST
// ---------------------------------------------------------
contract SmartContractTest is Test {
    SmartContractHelper public helper; //on instensie une sorte de boite vide pour pouvoir mettre nos contrat dedans
    
    //le setup pour pouvoir faire tout nos test. Tâches 1 : on met une function dans la boite, on la test, puis on la sort de la boite. Tâches 2 on répète le processus.
    function setUp() public {
        helper = new SmartContractHelper();
    }

    function testHalfAnswerOfLife() public {
        assertEq(helper.getHalfAnswerOfLife(), 21);// assertEq (assert equal) pour vérifier si la variable HalfAnswerOfLife vaut 21
    }

    function testInternalVar() public {
        bool isBad = helper.getAreYouABadPerson();// on crée une nouvelle variable booléene 
        assertEq(isBad, false);//on regarde si dcp la variable qui est dans AreYouABad... est false ou non
    }

    function testStructData() public {//Pour utiliser une structure on est obligé de les réecrire à la mains
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

    // --- Tests pour le Step 0.07 (Data Location) ---

    function testFullName() public {
        // On vérifie que la concaténation firstName + " " + lastName fonctionne
        assertEq(helper.getMyFullName(), "Alexander Salazar");
    }

    function testEditCity() public {
        // On demande au helper d'exécuter la fonction de modification
        helper.editMyCity("Paris");
        
        // On vérifie si la modification a bien eu lieu dans le storage du contrat
        (,,, string memory city, ) = helper.myInformations();
        assertEq(city, "Paris");
    }

    function testHash() public {
    string memory message = "Hello PoC";
    // On calcule le hash attendu manuellement dans le test
    bytes32 expectedHash = keccak256(abi.encodePacked(message));
    
    // On vérifie que notre fonction renvoie la même chose
    assertEq(helper.hashMyMessage(message), expectedHash);
}


}