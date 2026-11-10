# Versions des outils et validation sur deux systèmes

Cahier des charges §10.1, §10.4 et §11.4. Fichier lisible par machine : `results/environment.json`, généré par `bash scripts/check_env.sh`.
Toute mise à jour d'un outil doit être notée ici, et les expériences concernées doivent être relancées.

## Système 1 : Mac du coordinateur (Mohamed LO), diagnostic du 10/11/2026

| Élément | Version relevée | Exigence |
|---|---|---|
| OS / architecture | macOS 26.3.1 / arm64 (Apple M2) | — |
| Node.js | v24.10.0 | ≥ 22.13.0 (Hardhat 3) ✅ |
| npm | 11.6.0 | — |
| Git | 2.50.1 (Apple Git-155) | — |
| Hardhat | 3.21.2 | — |
| @nomicfoundation/hardhat-toolbox-viem | 5.0.7 | — |
| viem | 2.57.17 | — |
| TypeScript | 6.0.3 | — |
| @openzeppelin/contracts | 5.6.1 | — |
| solc (configuré dans Hardhat) | 0.8.28 | compatible avec `^0.8.20` (Ch08) |
| Python | 3.14.6 (Homebrew) | — |
| Homebrew | 7.0.12 | — |
| Docker | 28.5.1 | pour Mythril (à venir) |
| Slither | non installé au moment du diagnostic | voir plus bas |
| Mythril / Echidna | non installés | prévus après le sprint initial |

Résultat sur ce système :
- `npm install` : ✅
- `npx hardhat test` : ✅ (template d'exemple, 2 tests réussis)

## Système 2 : coéquipier sous Windows (à compléter)

Commandes à lancer dans PowerShell, depuis le dossier cloné :

```powershell
node -v; npm -v; git --version
npm ci
npx hardhat test
```

| Élément | Valeur |
|---|---|
| Membre | |
| OS / architecture | |
| Node.js / npm | |
| Hardhat (`npx hardhat --version`) | |
| Résultat de `npm ci` | |
| Résultat de `npx hardhat test` | |
| Date | |

## Complément : intégration continue GitHub Actions

Elle complète la validation manuelle ci-dessus, sans la remplacer (cahier §10.4).

| Run | Système | Node | `npm ci` + `npx hardhat test` | Date |
|---|---|---|---|---|
| [42866015967](https://github.com/Mohamedlo10/Groupe4-A11-Solidity-Audit/actions/runs/42866015967) | windows-latest | v22.23.4 | ✅ 7 passing | 10/11/2026 |
| [42866015967](https://github.com/Mohamedlo10/Groupe4-A11-Solidity-Audit/actions/runs/42866015967) | ubuntu-latest | v22.23.4 | ✅ 7 passing | 10/11/2026 |

## Historique Git : correspondance des identifiants

Le 10/11/2026, les messages de commit ont été réécrits. Le contenu des fichiers n'a pas changé : l'arbre Git est identique. Les sorties brutes, qui ne sont jamais modifiées, citent encore les anciens identifiants. Voici la correspondance :

| Ancien | Nouveau | Cité dans |
|---|---|---|
| a22c453 | 10ff7cc | — |
| 17cbc94 | 81c181a | `results/raw/slither/20261110T172915Z/meta.jsonl` |
| d18a746 | d8e3de3 | — |
| 4df9032 | 597d508 | — |
| 995d25b | 4e8be92 | run CI 42866015967 |
| 32dccde | cd142a3 | run CI 42866363545 |
| 867539f | 50b7dbd | run CI 42866610032 |

## Outils d'analyse

| Outil | Version | Méthode d'installation | Date |
|---|---|---|---|
| Slither | 0.11.6 | Homebrew (`brew install slither-analyzer`, bouteille arm64) | 10/11/2026 |
| solc-select | 1.2.0 | Homebrew (`brew install solc-select`) ; `solc-select install 0.8.28 && solc-select use 0.8.28` | 10/11/2026 |
| solc (pour Slither) | 0.8.28+commit.7893614a.Darwin.appleclang | solc-select | 10/11/2026 |
| Mythril | — | prévu : image Docker (compatibilité arm64 à vérifier) | — |
| Echidna | — | prévu : Homebrew 2.4.0 | — |

Remarques :
- `brew install slither-analyzer` a aussi installé **Python 3.15.2** (dépendance Homebrew) : depuis, `python3` pointe vers 3.15.2 (avant : 3.14.6, voir le premier diagnostic). Slither tourne dans son propre environnement Homebrew.
- Slither 0.11.6 analyse le projet Hardhat 3 directement (`slither .`), sans configuration supplémentaire.
- Le dépôt a été déplacé le 10/11/2026 dans `Cryptographie et technologies blockchain/Groupe4-A11-Solidity-Audit` (le chemin contient des espaces). Les tests et Slither ont été relancés depuis ce nouveau chemin avec succès.
