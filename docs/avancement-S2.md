# Note d'avancement : séance S2 (mardi 10 novembre 2026)

**Groupe 4 · A11 « Outils d'analyse de contrats Solidity »** · Mohamed LO, Ahmadoul Khadim TOURE, Amadou Tidiane KANE
Dépôt : https://github.com/Mohamedlo10/Groupe4-A11-Solidity-Audit (privé jusqu'à S5, pour que le corrigé du TP3 ne circule pas avant le TP ; accès sur invitation).

## 1. Réalisé pendant la séance

| Étape | Résultat | Preuve |
|---|---|---|
| Diagnostic du Mac | macOS 26.3.1 arm64, Node v24.10.0 (≥ 22.13 requis), npm 11.6.0, Git 2.50.1 | `docs/tool_versions.md`, `results/environment.json` |
| Projet Hardhat 3 | Hardhat 3.21.2, TypeScript + Viem, node:test, solc figé à 0.8.28, réseau local uniquement | `hardhat.config.ts`, `package-lock.json` |
| Contrats de démonstration | `VulnerableVault` (le coffre du cours Ch08), `Attacker`, `SecureVault` (vérifications–effets–interactions + `nonReentrant`) | `contracts/` |
| Tests d'acceptation | **7 tests réussis sur 7** via `npx hardhat test` (critères 1 à 7 du cahier des charges §6.3) | `test/reentrancy.test.ts` |
| Contrôle du test | Une fois la faille corrigée dans le coffre vulnérable, le test d'attaque **échoue** : il détecte donc bien l'absence de réentrance | contrôle fait en séance, fichier restauré |
| Slither | Slither 0.11.6 installé (Homebrew) et lancé sur le projet et sur les 2 coffres | `results/raw/slither/20261110T172915Z/` |

## 2. Résultats observés

**Attaque sur le réseau Hardhat local.** Alice dépose 10 ETH, l'attaquant mise 1 ETH.

| Coffre | Coffre avant → après | Attaquant après | Réentrées |
|---|---|---|---|
| VulnerableVault | 11 → **0 ETH** | **11 ETH** (dont les 10 ETH d'Alice) | 10 réussies |
| SecureVault | 11 → **10 ETH** | 1 ETH (sa mise seulement) | 1 tentative, bloquée (`ReentrancyGuardReentrantCall`) |

**Slither 0.11.6** (solc 0.8.28, sortie brute conservée) :
- **VulnerableVault** : `reentrancy-eth` (impact High, confiance Medium). L'alerte désigne l'appel externe ligne 19 et l'écriture `soldes[msg.sender] = 0` ligne 22, faite après l'appel. S'y ajoutent 2 alertes informatives : `solc-version` et `low-level-calls`.
- **SecureVault** : aucune alerte de réentrance, mais 11 alertes informatives :
  - 9 `assembly`, toutes dans `StorageSlot.sol` d'OpenZeppelin ;
  - `solc-version` ;
  - `low-level-calls`.
  Le coffre corrigé n'est donc pas « sans alerte ».

Ces deux contrats donnent une première observation sur la catégorie réentrance : la faille réelle est signalée sur le coffre vulnérable, et aucune alerte de réentrance n'apparaît sur le coffre corrigé. Ce n'est **pas** un résultat statistique : la matrice de confusion portera sur au moins 20 contrats annotés.

## 3. Décisions et changements par rapport au cadrage v1

- **Hardhat 3 + Viem** au lieu de Foundry/Anvil : la démonstration et le TP3 sont imposés sur Hardhat. Le détail est dans `docs/cadrage-v2.docx`.
- Question de recherche officielle reprise mot pour mot ; corpus d'au moins 20 contrats annotés, en priorité Solidity 0.8 ; article IEEE de 6 pages maximum.
- Cahier des charges technique du groupe versionné à la racine (`CLAUDE.md`).

## 4. Blocages et points d'attention

- `npx hardhat --init` est interactif : le projet a été créé à partir du template officiel `node-test-runner-viem` livré avec Hardhat 3.21.2. Le résultat est le même, sans la dépendance git `forge-std`, pénible sous Windows.
- Le template d'exemple exige solc ≥ 0.8.34. Nous figeons **0.8.28**, mieux pris en charge par les outils d'analyse.
- Homebrew a installé Python 3.15 avec Slither, et `python3` pointe désormais vers 3.15.2 : c'est noté.
- Validation sur un **2e système (Windows)** : **pas encore faite**. Elle est prévue avec un coéquipier.

## 5. Prochaines actions (avant l'exposé du vendredi 13/11)

1. Validation Windows (`npm ci` + `npx hardhat test`), notée dans `docs/tool_versions.md`.
2. Echidna (Homebrew) avec un invariant sur le coffre ; Mythril (Docker, vérifier l'arm64) sur les 2 coffres.
3. TP3 : énoncé, corrigé et 3 indices gradués (`docs/TP3_instructions.md`).
4. Diapositives au gabarit, résumé d'une page, vidéo de secours de 2 min : à envoyer au prof et au G6 le **jeudi 12/11 à 18 h**.
5. Ensuite : inventaire SmartBugs Curated (versions de solc, licences) et `dataset/manifest.csv`.

## 6. Questions pour l'enseignant

- Le TP3 se fait-il sur **Remix** (planning de l'Excel) ou sur **Hardhat** (fiche A11) ? Nous préparons Hardhat, et les contrats sont compatibles Remix.
- Article : **6 pages** (fiche A11) ou **8 à 12 pages** (présentation du module) ?
- Si le corpus SmartBugs n'offre pas 20 contrats en Solidity 0.8, un corpus mixte (historique + 0.8, clairement séparés) est-il acceptable ?
