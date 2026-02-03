// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ProfileSystem.sol";

contract ProfileTest is Test {
    ProfileSystem public system;
    address user1 = address(0x1);
    address user2 = address(0x2);

    function setUp() public {
        system = new ProfileSystem();
    }

    // 1. Vérifie la création normale
    function testCreateProfile() public {
        vm.prank(user1); 
        system.createProfile("Alexander");

        (string memory name, uint256 level, , ) = system.profiles(user1);
        assertEq(name, "Alexander");
        assertEq(level, 1);
    }

    // 2. Vérifie le rejet d'un nom vide
    function testCannotCreateEmptyProfile() public {
        vm.prank(user1);
        vm.expectRevert(ProfileSystem.EmptyUsername.selector);
        system.createProfile("");
    }

    // 3. Vérifie qu'on ne peut pas créer deux profils
    function testCannotCreateDuplicateProfile() public {
        vm.startPrank(user1);
        system.createProfile("Alice");
        
        vm.expectRevert(ProfileSystem.UserAlreadyExists.selector);
        system.createProfile("Alice_Bis");
        vm.stopPrank();
    }

    // 4. Vérifie la montée de niveau
    function testLevelUp() public {
        vm.startPrank(user1);
        system.createProfile("Gamer");
        
        system.levelUp();
        (, uint256 level, , ) = system.profiles(user1);
        
        assertEq(level, 2);
        vm.stopPrank();
    }

    // 5. Vérifie que seul un inscrit peut levelUp
    function testCannotLevelUpIfNotRegistered() public {
        vm.prank(user2);
        vm.expectRevert(ProfileSystem.UserNotRegistered.selector);
        system.levelUp();
    }
}