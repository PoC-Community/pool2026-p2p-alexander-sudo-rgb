// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16;

import "forge-std/Test.sol";
import "../src/Vault.sol"; // Vérifie que le chemin est correct
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Un simple jeton pour tester
contract MockERC20 is ERC20 {
    constructor() ERC20("Mock Token", "MTK") {
        _mint(msg.sender, 1000000e18);
    }
}

contract VaultTest is Test {
    VaultContract public vault;
    MockERC20 public token;
    
    address public owner = address(1);
    address public alice = address(2);

    function setUp() public {
        vm.startPrank(owner);
        token = new MockERC20();
        vault = new VaultContract(token);
        
        // On donne des jetons à Alice
        token.transfer(alice, 1000e18);
        vm.stopPrank();
    }

    function testRewardMechanism() public {
        // 1. Alice dépose 1000 tokens
        vm.startPrank(alice);
        token.approve(address(vault), 1000e18);
        vault.deposit(1000e18);
        
        assertEq(vault.sharesOf(alice), 1000e18);
        assertEq(vault.totalAssets(), 1000e18);
        vm.stopPrank();

        // 2. L'Owner ajoute 100 tokens de reward
        vm.startPrank(owner);
        token.approve(address(vault), 100e18);
        vault.addReward(100e18);
        
        // Vérification du nouveau ratio (1.1)
        assertEq(vault.currentRatio(), 1.1e18);
        vm.stopPrank();

        // 3. Alice retire tout
        vm.startPrank(alice);
        uint256 balanceBefore = token.balanceOf(alice);
        vault.withdrawAll();
        uint256 balanceAfter = token.balanceOf(alice);

        // 4. Vérification finale : Alice a reçu 1100 tokens
        uint256 gained = balanceAfter - balanceBefore;
        assertEq(gained, 1100e18);
        vm.stopPrank();
    }
}