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

## Outils d'analyse

| Outil | Version | Méthode d'installation | Date |
|---|---|---|---|
| Slither | | | |
| solc-select | | | |
| Mythril | | | |
| Echidna | | | |
