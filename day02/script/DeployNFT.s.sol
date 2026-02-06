// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/PoolNFT.sol";

contract DeployNFT is Script {
    function run() external {
        // Ta clé privée (ne partage pas ce fichier !)
        uint256 deployerPrivateKey = 0x7ed512cbe62447d30e37045163b4bf527e87be1cd94aeb43bd31cb9d020031dc;
        
        vm.startBroadcast(deployerPrivateKey);

        // Déploiement avec ton lien IPFS
        new PoolNFT("ipfs://bafybeie42lryso23tfep72bizl7fo3ye67wx3xdd5qlff77dqjjfdjohlm/");

        vm.stopBroadcast();
    }
}