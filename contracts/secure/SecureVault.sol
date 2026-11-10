// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/// @title Coffre corrigé
/// @notice Deux parades du cours (Ch08, diapo 7) :
///         1. vérifications – effets – interactions (Checks-Effects-Interactions) ;
///         2. verrou anti-réentrance `nonReentrant` (OpenZeppelin ReentrancyGuard).
contract SecureVault is ReentrancyGuard {
    mapping(address => uint) public soldes;

    function deposer() external payable {
        soldes[msg.sender] += msg.value;
    }

    function retirer() external nonReentrant {
        // Vérifications
        uint montant = soldes[msg.sender];
        require(montant > 0, "rien a retirer");
        // Effets : le solde est remis à zéro AVANT tout appel externe
        soldes[msg.sender] = 0;
        // Interactions
        (bool ok, ) = msg.sender.call{value: montant}("");
        require(ok, "envoi echoue");
    }
}
