# Groupe 4 · A11 : outils d'analyse de contrats Solidity

> **Que détectent-ils vraiment ?** Module Cryptographie & Technologies Blockchain, DIC3 INFO + TR, ESP-UCAD / LITA (Pr Gervais MENDY).
> Équipe : Mohamed LO, Ahmadoul Khadim TOURE, Amadou Tidiane KANE.

**Question de recherche officielle.** Les outils automatiques (Slither, Mythril, Echidna) détectent-ils les vulnérabilités réellement exploitées, et avec quel taux de faux positifs sur des contrats récents (Solidity 0.8) ?

Le dépôt contient :
1. **la démonstration de cours** : un coffre vulnérable à la réentrance, vidé par un contrat attaquant sur un réseau **Hardhat local**, la version corrigée, puis Slither sur les deux ;
2. **le projet de recherche** (en cours) : Slither, Mythril et Echidna sur au moins 20 contrats annotés, avec matrice de confusion, précision, rappel et temps d'analyse.

Référence du projet : [`CLAUDE.md`](CLAUDE.md) (cahier des charges). Avancement : [`docs/avancement-S2.md`](docs/avancement-S2.md).

## Prérequis

| Outil | Version | Remarque |
|---|---|---|
| Node.js | **≥ 22.13.0** | exigé par Hardhat 3 (`node -v`) |
| npm | fourni avec Node | |
| Git | toute version récente | |
| Slither (facultatif pour le TP) | 0.11.6 testé | macOS : `brew install slither-analyzer solc-select` |

Versions exactes utilisées : [`docs/tool_versions.md`](docs/tool_versions.md) et `results/environment.json`.

## Installation et tests

### macOS / Linux

```bash
git clone https://github.com/Mohamedlo10/Groupe4-A11-Solidity-Audit.git
cd Groupe4-A11-Solidity-Audit
npm ci                 # installe exactement les versions du package-lock.json
npx hardhat test       # compile (solc 0.8.28) et lance les tests
```

### Windows (PowerShell)

```powershell
node -v                # doit afficher v22.13.0 ou plus
git clone https://github.com/Mohamedlo10/Groupe4-A11-Solidity-Audit.git
cd Groupe4-A11-Solidity-Audit
npm ci
npx hardhat test
```

Si PowerShell refuse d'exécuter `npx` (« l'exécution de scripts est désactivée »), lancer une fois `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`, ou utiliser l'invite de commandes `cmd`.

Résultat attendu : `7 passing`, avec les tableaux de soldes avant et après l'attaque.

## Démonstration : réentrance

| Contrat | Rôle |
|---|---|
| [`contracts/vulnerable/VulnerableVault.sol`](contracts/vulnerable/VulnerableVault.sol) | Coffre du cours (Ch08) : l'appel externe (1) précède la remise à zéro du solde (2) |
| [`contracts/attacker/Attacker.sol`](contracts/attacker/Attacker.sol) | Contrat attaquant : `deposer()` puis `attaquer()` ; `receive()` rappelle `retirer()` (réentrées bornées, via `try/catch`) |
| [`contracts/secure/SecureVault.sol`](contracts/secure/SecureVault.sol) | Correction : vérifications–effets–interactions + verrou `nonReentrant` (OpenZeppelin) |

Scénario borné ([`test/reentrancy.test.ts`](test/reentrancy.test.ts)) :
- Alice dépose 10 ETH et l'attaquant mise 1 ETH.
- Contre `VulnerableVault`, 10 réentrées vident le coffre : l'attaquant repart avec 11 ETH.
- Contre `SecureVault`, la réentrée est bloquée : l'attaquant ne récupère que sa mise et Alice garde ses 10 ETH.

## Analyse statique : Slither

```bash
bash scripts/run_slither.sh     # projet entier + VulnerableVault + SecureVault
```

Chaque exécution crée `results/raw/slither/<horodatage>/` : JSON, texte et `meta.jsonl` (commande, versions, commit, code de sortie, durée). Les sorties brutes ne sont jamais écrasées.
Le code de sortie 255 signifie que Slither a trouvé des alertes. Il ne s'agit pas d'un plantage.

## Diagnostic de l'environnement

```bash
bash scripts/check_env.sh       # écrit results/environment.json
```

## Arborescence

```
contracts/   vulnerable/ attacker/ secure/        contrats de démonstration
test/        reentrancy.test.ts                    tests d'acceptation (node:test + viem)
scripts/     check_env.sh, run_slither.sh          diagnostic et analyses
results/     environment.json, raw/slither/...     sorties brutes horodatées
docs/        tool_versions.md, avancement-S2.md, cadrage-v2.docx
```

Prévus selon le cahier des charges (§9) : `echidna/`, `dataset/` (manifest.csv), `results/normalized|metrics|figures/`, `reports/`, scripts Mythril, Echidna et métriques.

## Sécurité et éthique

- Les attaques tournent **uniquement sur le réseau Hardhat local**. Aucune clé privée, aucun RPC public et aucun déploiement sur le réseau principal ne sont configurés.
- Les contrats vulnérables et attaquants sont des supports pédagogiques. **Ne pas les déployer.**
- **Usage de l'IA générative.** Le code, les tests et les scripts ont été produits avec l'aide de Claude Code (Anthropic), puis relus et validés par le groupe. Cet usage sera déclaré dans une section dédiée de l'article, conformément aux règles du module.
