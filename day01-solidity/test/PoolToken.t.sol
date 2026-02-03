// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/PoolToken.sol";

contract PoolTokenTest is Test {    
    PoolToken public token;
    address public owner = address(1); //celui qui a le droit de créer de l'argent
    address public user = address(2); //celui qui n'a pas le droit (gros singe)
    uint256 public constant INITIAL_SUPPLY = 1000 ether; //constant ça veut dire qui change pas (loguique)

    function setUp() public {
    vm.prank(owner); //on fait un PRANK pour faire zerma on est l'owner quand on fait les test
    token = new PoolToken(INITIAL_SUPPLY); 
}

    function testInitialSupply() public view {
        assertEq(token.totalSupply(), INITIAL_SUPPLY);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY);
    }

    function testOnlyOwnerCanMint() public {
        vm.prank(user);
        vm.expectRevert(); 
        token.mint(user, 1000 ether);
    }
}