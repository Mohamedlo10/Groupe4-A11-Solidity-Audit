// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Coffre volontairement vulnérable à la réentrance
/// @notice Reprise du contrat « Coffre » du cours (Ch08, diapo 6), seul le nom change.
///         Usage pédagogique, réseau Hardhat local uniquement. NE PAS DÉPLOYER.
contract VulnerableVault {
    mapping(address => uint) public soldes;

    function deposer() external payable {
        soldes[msg.sender] += msg.value;
    }

    function retirer() external {
        uint montant = soldes[msg.sender];
        require(montant > 0, "rien a retirer");
        // (1) Appel externe AVANT la mise à jour du solde : « call » envoie les fonds
        //     et donne la main au destinataire, qui peut rappeler retirer().
        (bool ok, ) = msg.sender.call{value: montant}("");
        require(ok);
        // (2) Remise à zéro trop tard.
        soldes[msg.sender] = 0;
    }
}
