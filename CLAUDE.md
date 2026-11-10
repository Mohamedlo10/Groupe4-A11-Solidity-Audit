> Transcription Markdown de Cahier_des_charges_Groupe4_A11_ClaudeCode.pdf (v1.0, 10/11/2026). Le PDF fait foi.

# GROUPE 4 - SUJET A11

## Cahier des charges technique et scientifique

**Outils d’analyse de contrats Solidity : que détectent-ils vraiment ?**

- **Équipe :** Mohamed LO, Ahmadoul Khadim TOURE, Amadou Tidiane KANE
- **Module :** Cryptographie & Technologies Blockchain - DIC3 INFO + TR
- **Enseignant :** Pr Gervais MENDY - ESP-UCAD / LITA
- **Présentation A11 :** vendredi 13 novembre 2026, séance S5, bloc 3
- **Document de passation :** consignes pour Claude Code et référence commune du groupe
- **Version :** 1.0 - 10 novembre 2026

## Sommaire

1. Utilisation de ce document et résumé du projet
2. Attentes officielles du professeur pour A11
3. Question de recherche, objectifs et hypothèse
4. Périmètre technique et notions de cours
5. Outils d’analyse et méthodes
6. Cas pratique obligatoire : coffre Ethereum et réentrance
7. Corpus d’au moins 20 contrats annotés
8. Protocole expérimental et matrice de confusion
9. Architecture du dépôt Git
10. Environnement Mac et initialisation Hardhat
11. Installation et exécution des outils
12. Automatisation et reproductibilité
13. Résultats et livrables
14. Plan de l’exposé A11
15. Répartition du travail
16. Ordre de réalisation
17. Règles de conduite pour Claude Code
18. Prompt de démarrage pour Claude Code
19. Références de départ
20. Définition de « projet terminé »

---

## 0. Comment utiliser ce document avec Claude Code

Placer ce fichier à la racine du dépôt sous le nom `CLAUDE.md`, ou le donner comme document de référence à Claude Code. Claude Code doit le lire avant toute modification du projet.

**Règle de travail :** Claude Code doit avancer par petites étapes, inspecter l’environnement et le dépôt avant d’agir, exécuter les tests après chaque modification importante et fournir les preuves des résultats. Il ne doit jamais inventer un résultat expérimental, une référence, une capture d’écran ou une détection d’outil.

Le groupe reste responsable des choix scientifiques, de la validation manuelle des annotations, de la vérification des résultats et de la présentation au professeur.

## 1. Résumé exécutif du projet

Le Groupe 4 doit évaluer expérimentalement trois outils d’analyse de contrats intelligents Solidity :

- **Slither** : analyse statique ;
- **Mythril** : exécution symbolique ;
- **Echidna** : fuzzing fondé sur des propriétés/invariants.

Le projet ne consiste pas à faire un catalogue des outils. Il doit mesurer ce que ces outils détectent, ce qu’ils ratent, les faux positifs qu’ils produisent et le temps nécessaire à leur analyse, sur un corpus d’au moins 20 contrats annotés.

Le travail comprend deux volets complémentaires :

1. **Démonstration de cours :** reproduire une attaque par réentrance contre un coffre Solidity sur un réseau local Hardhat, puis lancer Slither sur le contrat vulnérable.
2. **Projet de recherche :** lancer Slither, Mythril et Echidna sur au moins 20 contrats annotés, construire une première matrice de confusion, puis calculer précision, rappel et temps d’analyse par outil et par catégorie de faille.

Le résultat final doit être reproductible à partir de scripts, données, versions et instructions fournis. L’article final est au format IEEE, six pages maximum.

## 2. Consignes officielles de l’enseignant — à respecter en priorité

Cette section reprend les attentes du document **« DIC3 INFO + TR — Attentes par sujet d’animation »**, daté du 10 novembre 2026.

### 2.1 Sujet et question officielle

**A11 — Outils d’analyse de contrats Solidity**
Question de recherche officielle :

> Les outils automatiques (Slither, Mythril, Echidna) détectent-ils les vulnérabilités réellement exploitées, et avec quel taux de faux positifs sur des contrats récents (Solidity 0.8) ?

Conserver cette formulation comme question principale. Toute reformulation plus détaillée doit rester fidèle à cette question.

### 2.2 Contenu obligatoire de l’exposé

L’exposé doit couvrir :

1. **EVM et gaz**, uniquement les notions nécessaires pour comprendre une faille ;
2. **Réentrance**, illustrée par The DAO (2016), et schéma de correction *Checks-Effects-Interactions* (vérifier-modifier-interagir) ;
3. **Taxonomie des attaques** selon Atzei et al. : dépassement arithmétique, contrôle d’accès, dépendance à l’horodatage, exécution anticipée (*front-running*) ;
4. **Trois familles d’outils** : analyse statique, exécution symbolique et test par données aléatoires (*fuzzing*), avec les capacités et limites de chacune.

### 2.3 Démonstration obligatoire

Le professeur attend :

- un contrat vulnérable ;
- un contrat attaquant qui vide le coffre ;
- une exécution sur un réseau local **Hardhat** ;
- Slither lancé sur le même contrat vulnérable.

La démonstration doit être préparée et testée avant la séance. Prévoir une vidéo de secours de deux minutes et conserver les logs/captures.

### 2.4 Tutorat TP3 obligatoire

Le Groupe 4 anime le TP3 sur la réentrance pour toute la classe.

Le groupe doit avoir :

- exécuté `npm install` ;
- exécuté `npx hardhat test` ;
- validé l’installation sur **au moins deux systèmes différents** ;
- préparé le TP et son corrigé ;
- préparé trois indices gradués ;
- savoir aider les autres groupes en cas de problème d’installation.

Ne pas remplacer Hardhat par Anvil ou un autre environnement pour la démonstration officielle. Les outils complémentaires peuvent être utilisés en plus, mais la démonstration demandée est sur Hardhat.

### 2.5 Projet de recherche et jalons

**Jalon 1 — État de l’art :**

- Atzei et al. (POST 2017) ;
- publication sur Slither (WETSEB 2019) ;
- Durieux et al. (ICSE 2020) ;
- jeu de contrats annotés retenu : SmartBugs ou contrats issus d’incidents.

**Jalon 2 — Premiers résultats :**

- les trois outils doivent être exécutés sur **au moins 20 contrats annotés** ;
- produire une première matrice de confusion.

**Jalon 3 — Article :**

- format IEEE ;
- six pages maximum ;
- précision, rappel et temps d’analyse par outil et par classe de faille ;
- comparaison avec l’étude de 2020 ;
- remise cinq jours après S6.

### 2.6 Reproductibilité et sécurité

Les résultats doivent pouvoir être reproduits à partir d’un script fourni avec les données et les instructions.

**Limite absolue :** les attaques doivent être exécutées uniquement sur un réseau local ou un réseau de test autorisé. **Jamais sur un contrat déployé sur Ethereum mainnet.** Aucun fonds réels, aucune clé privée réelle, aucun portefeuille de tiers.

### 2.7 Échéances connues pour A11

- **Jeudi 12 novembre 2026, 18 h :** diapositives et résumé d’une page (bibliographie d’au moins cinq sources primaires) à envoyer à l’enseignant et au Groupe 6.
- **Jeudi 12 novembre, soir :** répétition chronométrée ; TP fait avec le corrigé par le groupe tuteur.
- **Vendredi 13 novembre, 12 h :** le Groupe 6, discutant de A11, envoie ses deux questions critiques. Le Groupe 4 n’a pas à produire ces questions pour son propre exposé.
- **Vendredi 13 novembre, après-midi :** exposé A11 et tutorat TP3.
- **Dimanche 15 novembre (J+2) :** diapositives corrigées et trois questions de quiz à remettre. Le Groupe 7 est rapporteur de A11.
- **Après S6 :** article IEEE dans les cinq jours suivant S6, selon la date de S6 fixée par l’enseignant.

## 3. Question, objectifs et hypothèse de recherche

### 3.1 Question de recherche

Reprendre la question officielle :

> Les outils automatiques (Slither, Mythril, Echidna) détectent-ils les vulnérabilités réellement exploitées, et avec quel taux de faux positifs sur des contrats récents (Solidity 0.8) ?

### 3.2 Objectif général

Évaluer, sur un corpus contrôlé et annoté de contrats Solidity, les capacités et limites de Slither, Mythril et Echidna pour détecter plusieurs catégories de vulnérabilités, en accordant une attention particulière aux contrats Solidity 0.8.

### 3.3 Objectifs spécifiques

1. Comprendre et expliquer les trois méthodes d’analyse.
2. Reproduire une attaque par réentrance dans Hardhat.
3. Construire ou sélectionner un corpus d’au moins 20 contrats annoté avec une vérité terrain documentée.
4. Exécuter les trois outils dans des conditions tracées et comparables.
5. Évaluer vrais positifs, faux positifs, faux négatifs, précision, rappel et temps d’analyse.
6. Identifier les catégories de vulnérabilités détectées ou manquées par chaque outil.
7. Proposer une stratégie d’audit combinant analyse automatisée, tests et revue humaine.

### 3.4 Hypothèse de travail à tester

Les outils ont des capacités complémentaires : leur couverture dépend de la famille de méthode, de la catégorie de vulnérabilité, des propriétés fournies et de la compatibilité du contrat avec l’environnement d’analyse. La combinaison des outils peut améliorer la couverture, sans garantir l’absence de vulnérabilité.

Cette hypothèse doit être testée. Ne pas la présenter comme un résultat acquis.

## 4. Périmètre technique et notions de cours

### 4.1 Ce qu’il faut expliquer de l’EVM

Limiter la théorie aux notions utiles à l’audit :

- un contrat est du code et un état stocké sur la blockchain ;
- les transactions sont signées et exécutées par l’EVM ;
- les appels externes peuvent donner le contrôle au contrat appelé ;
- le gaz limite le coût et la consommation de ressources ;
- les fonctions `public` et `external` peuvent être appelées selon leurs conditions ;
- les interactions avec d’autres contrats et les données d’entrée influencent le comportement.

Ne pas consacrer trop de temps à une présentation générale d’Ethereum.

### 4.2 Réentrance

Une fonction vulnérable effectue un appel externe avant d’avoir mis à jour son état. Le destinataire peut rappeler la fonction avant la mise à jour, et réexécuter une logique de retrait avec un ancien solde.

Correction principale : *Checks-Effects-Interactions* :

1. Checks : vérifier les préconditions ;
2. Effects : mettre à jour l’état interne ;
3. Interactions : effectuer l’appel externe ensuite.

Une protection anti-réentrance (`nonReentrant`) peut être ajoutée comme défense complémentaire. Les tests doivent montrer le comportement avant et après correction.

### 4.3 Taxonomie à présenter

Présenter les catégories indiquées par l’enseignant :

- dépassement arithmétique ;
- contrôle d’accès ;
- dépendance à l’horodatage ;
- front-running / exécution anticipée.

Ajouter la réentrance comme cas principal. Bien préciser que les risques ne sont pas tous détectables par une analyse statique d’un seul fichier : MEV, oracles, ponts et compromission de clés peuvent relever de l’environnement, du protocole ou de la logique applicative.

**Solidity 0.8 :** les opérations arithmétiques sont vérifiées par défaut, mais les blocs `unchecked`, les conversions, les erreurs de logique et d’autres catégories restent à examiner. Ne pas annoncer un overflow classique comme s’il était automatiquement présent dans tout contrat 0.8.

### 4.4 Cryptographie symétrique et asymétrique

Ces primitives font partie du contexte blockchain, mais ne sont pas le cœur de l’expérience de réentrance :

- ECDSA sert notamment à signer les transactions Ethereum ;
- le hachage sert à l’intégrité et aux structures de données ;
- AES peut protéger des données hors chaîne ou des communications applicatives ; il ne corrige pas une réentrance.

Ne pas introduire artificiellement AES dans le cas pratique.

## 5. Outils à utiliser et ce qu’ils mesurent

| Outil | Famille | Rôle dans le projet | Limite à examiner |
|---|---|---|---|
| Slither | Analyse statique | Analyse le code/IR et signale des motifs ou propriétés suspectes sans exécuter le contrat | Peut signaler un motif sans prouver son exploitabilité ; peut manquer la logique métier |
| Mythril | Exécution symbolique | Explore des chemins d’exécution avec des entrées symboliques et recherche des conditions de vulnérabilité | Exploration bornée par le temps, la profondeur et l’explosion combinatoire des chemins |
| Echidna | Fuzzing à propriétés | Génère des séquences d’appels et cherche à violer des invariants définis par le groupe | Dépend des propriétés/invariants écrits, du harnais, des paramètres et de la durée de campagne |

### 5.1 Règles de comparaison

- Ne pas comparer les outils uniquement au nombre brut d’alertes.
- Normaliser les catégories de vulnérabilités dans une taxonomie commune.
- Conserver les sorties brutes de chaque outil.
- Associer chaque alerte à un contrat, une catégorie, un emplacement et un statut de validation.
- Faire une revue manuelle de chaque détection et de chaque contrat de contrôle.
- Echidna nécessite des propriétés explicites : le groupe doit écrire et documenter les invariants testés.
- Une absence d’alerte ne constitue jamais une preuve de sécurité.

## 6. Cas pratique obligatoire : coffre Ethereum et réentrance

### 6.1 Scénario pédagogique

Un coffre conserve les soldes des utilisateurs. Un utilisateur légitime dépose des ETH. Un contrat attaquant dépose aussi un montant, puis appelle `withdraw`. Le coffre envoie les ETH avant de remettre le solde à zéro. Le contrat attaquant utilise sa fonction `receive` pour rappeler `withdraw` pendant l’appel externe.

Tout se passe sur un réseau Hardhat local avec des comptes et des ethers de test.

### 6.2 Contrats à créer

- `VulnerableVault.sol` : coffre volontairement vulnérable ;
- `Attacker.sol` : contrat attaquant de laboratoire ;
- `SecureVault.sol` : version corrigée utilisant Checks-Effects-Interactions et, si approprié, un verrou anti-réentrance.

Le scénario doit être borné et déterministe pour la présentation : déposants, montants, nombre de réentrées, soldes avant/après et résultat attendu doivent être explicites.

### 6.3 Tests d’acceptation du cas pratique

Le test Hardhat doit vérifier au minimum :

1. Le coffre vulnérable accepte les dépôts.
2. Le déposant légitime et l’attaquant ont des soldes enregistrés.
3. L’attaque provoque plusieurs appels imbriqués et retire plus que le dépôt propre de l’attaquant, dans la limite des fonds disponibles.
4. Les soldes et soldes ETH avant/après sont affichés ou vérifiés par assertions.
5. Le même scénario sur `SecureVault` ne permet pas de voler les fonds du déposant légitime.
6. Le test échoue si le comportement attendu n’est pas reproduit.
7. Le cas de test est relancé par `npx hardhat test` sans interaction manuelle.

Attention : le contrat attaquant doit gérer proprement l’échec d’une tentative de réentrée contre la version corrigée, afin de ne pas faire échouer artificiellement le retrait légitime.

### 6.4 Démonstration live

Ordre recommandé :

1. Montrer le code vulnérable et la ligne d’appel externe avant la mise à jour du solde.
2. Montrer les soldes initiaux.
3. Lancer le test d’attaque Hardhat.
4. Montrer que le coffre vulnérable est vide ou que les fonds du déposant ont été retirés abusivement selon le scénario borné.
5. Lancer Slither sur le contrat vulnérable et lire l’alerte pertinente, si elle est effectivement produite.
6. Montrer le code corrigé et relancer le test.
7. Montrer le résultat de l’analyse statique après correction, sans supposer qu’il sera totalement sans alertes.

La sortie réelle de Slither doit être capturée. Ne jamais écrire dans les diapositives « Slither détecte » avant de l’avoir constaté sur la version et la configuration utilisées.

## 7. Corpus de recherche : au moins 20 contrats annotés

### 7.1 Exigence

Le professeur demande les trois outils sur au moins 20 contrats annotés et une première matrice de confusion. Le sujet vise des contrats récents en Solidity 0.8.

### 7.2 Source candidate : SmartBugs

SmartBugs Curated est une source candidate connue : le dépôt public décrit 143 contrats Solidity vulnérables annotés par catégories, dont réentrance, contrôle d’accès, arithmétique, appels bas niveau non vérifiés, DoS, hasard faible, front-running et manipulation du temps.

Mais il faut vérifier la version du compilateur de chaque contrat. Certains exemples historiques utilisent une version de Solidity antérieure à 0.8. **Ne jamais modifier automatiquement un ancien contrat pour le faire compiler en 0.8 et prétendre que l’expérience reste identique.** Une migration de version peut changer le comportement ou supprimer/introduire des conditions de vulnérabilité.

### 7.3 Stratégie de sélection obligatoire

Claude Code doit commencer par produire un inventaire du jeu de données :

- identifiant du contrat ;
- URL/source ;
- licence ;
- version `pragma` et version réelle du compilateur si connue ;
- catégorie(s) annotée(s) ;
- lignes vulnérables ;
- statut de compilation ;
- disponibilité des dépendances ;
- présence d’une vérité terrain vérifiable.

Sélectionner au moins 20 contrats annotés en priorité compatibles avec Solidity 0.8 pour répondre au sujet. Si le jeu de données choisi ne fournit pas 20 exemples valides en 0.8 :

1. ne pas maquiller les versions anciennes ;
2. proposer une sélection mixte clairement séparée entre corpus historique et corpus 0.8 ;
3. compléter, si possible, par des contrats d’incidents ou des cas construits et vérifiés manuellement ;
4. signaler explicitement la composition et la limite du corpus ;
5. faire valider cette stratégie par l’enseignant si elle affecte la question officielle.

Le corpus doit comporter des exemples positifs et des contrôles négatifs pour les catégories mesurées. Si un contrat n’a pas été examiné pour une catégorie, son étiquette est `unknown`, jamais `negative` par défaut.

### 7.4 Recommandation de corpus minimal

Cible de travail proposée (à ajuster après inventaire) :

- au moins 20 contrats au total ;
- plusieurs catégories de vulnérabilités ;
- des contrats vulnérable(s) et des contrôles sains ou des étiquettes négatives vérifiées ;
- une représentation claire des contrats Solidity 0.8 ;
- aucun contrat dont l’étiquette est incertaine utilisé comme vérité terrain.

Ne pas promettre un nombre de positifs par classe avant d’avoir audité le dataset.

### 7.5 Fichier d’annotation

Créer `dataset/manifest.csv` avec au minimum les champs :

```
contract_id,source_url,license,compiler_version,solidity_pragma,source_path,category,ground_truth,label_confidence,vulnerable_lines,manual_reviewer,notes
```

Le schéma peut être normalisé en plusieurs fichiers si un contrat a plusieurs catégories. Le README doit expliquer le sens de chaque champ.

## 8. Protocole expérimental

### 8.1 Unité d’analyse

Utiliser comme unité principale le couple **(contrat, catégorie de vulnérabilité)**. Un contrat peut être vulnérable pour une catégorie et non vulnérable pour une autre, mais seulement si les catégories non vulnérables ont été vérifiées manuellement.

### 8.2 Conditions contrôlées

Pour chaque exécution, enregistrer :

- commit Git du corpus ;
- version du contrat et hash du fichier ;
- version exacte de Solidity ;
- version exacte de Slither/Mythril/Echidna ;
- version Node/npm/Hardhat ;
- OS et architecture ;
- options de compilation et d’analyse ;
- timeout et limites de profondeur/fuzzing ;
- date, durée et code de sortie.

Utiliser les mêmes sources, compilateurs et conditions autant que possible. Toute limite propre à un outil doit être documentée. Pour les outils qui ont besoin d’un format ou d’un harnais particulier, conserver la transformation et la justifier.

### 8.3 Matrice de confusion

Pour chaque outil et catégorie :

- **TP (vrai positif)** : le contrat est annoté vulnérable pour cette catégorie et l’outil produit une détection pertinente validée ;
- **FP (faux positif)** : le contrat est annoté non vulnérable pour cette catégorie mais l’outil signale cette catégorie ;
- **FN (faux négatif)** : le contrat est annoté vulnérable mais l’outil ne la détecte pas ;
- **TN (vrai négatif)** : le contrat est annoté non vulnérable et l’outil ne signale pas cette catégorie.

Une alerte doit être revue manuellement avant d’être classée TP ou FP. Si l’étiquette de référence est inconnue, exclure le couple de la matrice et l’indiquer.

### 8.4 Métriques

- Précision = TP / (TP + FP)
- Rappel = TP / (TP + FN)
- F1 = 2 × précision × Rappel / (précision + Rappel)
- Spécificité = TN / (TN + FP), facultative mais utile si les étiquettes négatives sont fiables.
- Temps d’analyse : durée par contrat et par outil ; rapporter médiane et dispersion si plusieurs exécutions sont possibles.

Si un dénominateur est nul, afficher `N/A` plutôt qu’une valeur inventée. Rapporter les métriques par outil et par catégorie, puis globalement. Expliquer les limites dues à la taille du corpus.

### 8.5 Echidna : propriétés à définir

Pour chaque contrat cible, créer un harnais ou une suite de propriétés. Exemple pour un coffre : le montant total des dettes comptabilisées ne doit pas dépasser les fonds conservés, sous les hypothèses du modèle. La propriété doit être précise, testable et cohérente avec les fonctions du contrat.

Documenter : nombre de transactions/séquences, longueur des séquences, timeout, seed, couverture disponible, propriétés testées et contre-exemple s’il existe.

Un fuzzing qui ne trouve pas de contre-exemple dans une campagne bornée ne prouve pas l’absence de faille.

## 9. Architecture du dépôt Git

Nom proposé : `Groupe4-A11-Solidity-Audit`
Visibilité GitHub par défaut : **privée**, sauf décision contraire explicite du groupe.

Structure cible :

```
Groupe4-A11-Solidity-Audit/
├── CLAUDE.md
├── README.md
├── package.json
├── package-lock.json
├── hardhat.config.ts
├── contracts/
│   ├── vulnerable/VulnerableVault.sol
│   ├── attacker/Attacker.sol
│   ├── secure/SecureVault.sol
│   └── dataset/              # copies/fixtures autorisées et tracées
├── test/
│   ├── reentrancy.test.ts
│   ├── access-control.test.ts
│   └── regression.test.ts
├── echidna/
│   ├── harnesses/
│   └── echidna.yaml
├── scripts/
│   ├── inventory_dataset.py
│   ├── run_slither.sh
│   ├── run_mythril.sh
│   ├── run_echidna.sh
│   ├── run_benchmark.py
│   └── generate_metrics.py
├── dataset/
│   ├── manifest.csv
│   ├── README.md
│   ├── raw/                  # références ou copies autorisées seulement
│   └── ground_truth/
├── results/
│   ├── raw/slither/
│   ├── raw/mythril/
│   ├── raw/echidna/
│   ├── normalized/
│   ├── metrics/
│   └── figures/
├── reports/
│   ├── demo/
│   ├── one_page_summary/
│   └── IEEE/
├── docs/
│   ├── methodology.md
│   ├── tool_versions.md
│   ├── experiment_protocol.md
│   └── TP3_instructions.md
└── .github/workflows/        # tests CI reproductibles si possible
```

Adapter la structure si nécessaire, sans perdre la séparation entre code, corpus, données brutes, données traitées et rapports.

## 10. Environnement Mac et initialisation Hardhat

### 10.1 Diagnostic obligatoire avant installation

Exécuter et consigner :

```
node -v
npm -v
git --version
uname -m
sw_vers -productVersion
```

Node.js **22.13.0 ou ultérieur** est requis par la documentation actuelle de Hardhat 3. Si la version est trop ancienne, utiliser un gestionnaire de versions Node (nvm ou Volta) et noter la version retenue. Ne pas installer une version au hasard.

### 10.2 Initialisation conseillée

Dans le dossier du projet :

```
mkdir Groupe4-A11-Solidity-Audit
cd Groupe4-A11-Solidity-Audit
npx hardhat --init --template node-test-runner-viem
```

La commande peut être interactive si le template n’est pas disponible ; dans ce cas utiliser `npx hardhat --init` et choisir un modèle TypeScript avec Viem. Suivre la documentation officielle Hardhat 3.

Vérifier ensuite :

```
npm install
npx hardhat --help
npx hardhat test
```

Conserver `package-lock.json` et utiliser `npm ci` pour les installations reproductibles après génération du lockfile. Ne pas committer `node_modules/`.

### 10.3 Réseau

Utiliser le réseau local de test Hardhat pour les tests et la démonstration officielle. Les tests doivent être relançables avec `npx hardhat test`. Ne configurer aucune clé mainnet et ne déployer aucun contrat sur le réseau principal.

### 10.4 Vérification sur deux systèmes

Faire tourner `npm install` et `npx hardhat test` sur :

- le Mac du membre qui coordonne ;
- le système d’un autre membre (ou un second système convenu avec l’enseignant).

Noter OS, architecture, Node, npm, Hardhat et résultat. Une CI Ubuntu peut compléter la preuve, mais ne pas la substituer silencieusement à la vérification demandée sur deux systèmes.

## 11. Installation et exécution des outils

### 11.1 Slither

Installer Slither via une méthode officielle adaptée à macOS (Homebrew ou environnement Python isolé/pipx). Vérifier `slither --version` et `slither --help`. Installer/sélectionner la version de `solc` compatible avec le projet. Depuis la racine Hardhat, la documentation Slither indique l’usage `slither .` ; pour un fichier seul, `slither path/to/Contract.sol`.

Conserver la commande exacte, la version et le rapport brut. Utiliser les options de sortie machine-readable disponibles dans la version installée si possible.

### 11.2 Mythril

Mythril est un outil d’exécution symbolique sur bytecode EVM. La documentation du projet propose une image Docker (`mythril/myth`) et l’installation Python. Sur Mac, vérifier l’architecture et la compatibilité de l’image avant de l’utiliser. Ne pas forcer une émulation x86 sans l’indiquer.

Lancer `myth analyze --help` et retenir une commande compatible avec le contrat et le compilateur. Enregistrer toutes les options, timeouts et logs. Les analyses doivent être faites sur des sources/bytecodes locaux et non sur des adresses mainnet.

### 11.3 Echidna

Echidna est un fuzzer fondé sur des propriétés. Il génère des séquences d’appels et cherche à violer les fonctions de propriété fournies par le projet.

Sur macOS, privilégier l’installation native/Homebrew ou la release officielle compatible avec l’architecture du Mac. Le dépôt Echidna indique que ses images Docker précompilées sont actuellement construites pour x86 ; vérifier ce point avant de les utiliser sur Apple Silicon.

Créer un harnais Solidity, des fonctions `echidna_...` ou une configuration de campagne, puis enregistrer les seeds, la durée et les séquences de contre-exemple.

### 11.4 Versions et environnement

Créer `docs/tool_versions.md` et un fichier de machine-readable environment (ex. `results/environment.json`) avec :

- macOS version et architecture ;
- Node/npm ;
- Hardhat ;
- Solidity compiler ;
- Slither ;
- Mythril ;
- Echidna ;
- Docker/Homebrew/Python le cas échéant.

Toute mise à jour d’outil doit être tracée et les expériences affectées relancées.

## 12. Automatisation et reproductibilité

Créer des scripts/documentations pour les opérations suivantes :

1. vérifier l’environnement ;
2. installer les dépendances ;
3. compiler les contrats ;
4. lancer les tests Hardhat ;
5. lancer le scénario de réentrance ;
6. lancer Slither ;
7. lancer Mythril ;
8. lancer Echidna avec les propriétés ;
9. inventorier le corpus ;
10. normaliser les sorties ;
11. calculer les matrices et métriques ;
12. générer tableaux et graphiques.

Le README doit inclure une commande ou une séquence courte pour reproduire les principaux résultats depuis un clone propre.

Les résultats bruts ne doivent jamais être remplacés par des résultats normalisés : conserver les deux. Chaque exécution doit avoir un identifiant, date/heure, commit et fichier de configuration.

Ne pas committer des secrets, tokens, clés privées, fichiers `.env`, données personnelles ou dataset soumis à une licence incompatible. Ajouter les licences et citations des corpus tiers.

## 13. Résultats attendus et livrables

### 13.1 Livrables techniques

- dépôt GitHub avec historique de commits ;
- contrats vulnérable, attaquant et corrigé ;
- tests Hardhat ;
- harnais et configuration Echidna ;
- configurations/scripts Slither et Mythril ;
- corpus et manifeste d’annotations ;
- données brutes et sorties d’analyse ;
- données normalisées ;
- matrice de confusion par outil et catégorie ;
- précision, rappel, F1 si pertinent et temps d’analyse ;
- graphiques et tableaux ;
- README et instructions reproductibles ;
- rapport/vidéo de secours de démonstration.

### 13.2 Livrables pédagogiques

- diapositives conformes au gabarit ;
- résumé d’une page ;
- démonstration live ;
- vidéo de secours de deux minutes ;
- trois questions de quiz pour J+2 ;
- matériel et corrigé du TP3 ;
- trois indices gradués pour guider les étudiants.

### 13.3 Article final

Article IEEE de six pages maximum :

1. titre, résumé, mots-clés ;
2. introduction et question de recherche ;
3. travaux connexes/état de l’art ;
4. corpus et méthodologie ;
5. résultats quantitatifs ;
6. discussion et menaces à la validité ;
7. conclusion ;
8. références.

Les résultats doivent être produits par les scripts du dépôt. Ne jamais insérer des valeurs fictives dans le tableau ou les graphiques.

## 14. Plan recommandé de l’exposé A11

Respecter le gabarit officiel d’animation et la contrainte de 20 minutes d’exposé + 5 minutes de questions. La couverture est distincte des onze diapositives de contenu du gabarit.

1. **Contexte — Pourquoi auditer un contrat intelligent ?** EVM/gaz juste nécessaires, incidents et enjeu sécurité.
2. **Question de recherche.** Question officielle, hypothèse, méthode et périmètre.
3. **Mécanismes d’analyse.** Analyse statique, exécution symbolique, fuzzing ; ce que chaque famille peut/ne peut pas faire.
4. **Exemple déroulé.** Coffre vulnérable : appels, stockage, appel externe, réentrance.
5. **Ce qui peut mal tourner.** Réentrance, contrôle d’accès, dépassements, horodatage, front-running ; risques de code vs environnement.
6. **État de l’art.** Atzei, Slither, Durieux, autres sources primaires ; apports et limites.
7. **Positionnement du projet.** Corpus, versions Solidity 0.8, annotations, contribution expérimentale.
8. **Démonstration.** Contrat attaquant, réseau Hardhat local, attaque, analyse Slither, correction et résultat.
9. **Conclusion.** Réponse à la question, résultats réels, limites et recommandations.
10. **Quiz.** Trois QCM pour la banque de questions.
11. **Références.** Au moins cinq sources primaires, dont les trois lectures obligatoires de la fiche A11 une fois identifiées.

Ne pas saturer les diapositives de texte. Prioriser schémas, extraits de code courts, tableaux de résultats et captures réelles.

## 15. Répartition indicative du travail

| Membre | Responsabilité principale | Contributions partagées |
|---|---|---|
| Mohamed LO | Coordination, question de recherche, protocole, bibliographie, rédaction et suivi Git | Validation manuelle, résultats, présentation |
| Ahmadoul Khadim TOURE | Contrats Solidity, scénario attaquant, correction et tests Hardhat | Validation manuelle, démonstration |
| Amadou Tidiane KANE | Installation des outils, scripts d’analyse, corpus, collecte des logs | Validation manuelle, TP3 |

La répartition est indicative. Chaque membre doit comprendre les trois outils, la réentrance, les résultats et les limites.

## 16. Ordre de réalisation recommandé

### Sprint initial de deux heures — première séance de réalisation

Ce sprint est un objectif de travail, pas une garantie de livraison si l’installation ou la compilation rencontre un blocage. Claude Code doit privilégier un socle qui fonctionne plutôt que multiplier les fichiers non testés.

| Temps | Travail | Preuve attendue |
|---|---|---|
| 0-10 min | Diagnostiquer macOS, Node, npm, Git, architecture et outils disponibles | Sortie du diagnostic sauvegardée dans docs/tool_versions.md |
| 10-25 min | Créer le dossier et initialiser le dépôt Git local ; vérifier l’authentification GitHub | Dépôt local propre ; dépôt distant privé si gh auth status le permet |
| 25-40 min | Initialiser Hardhat 3, installer les dépendances et lancer le test d’exemple | npm install puis npx hardhat test passent |
| 40-75 min | Implémenter VulnerableVault, Attacker et les premiers tests | Test démontrant la réentrance sur le réseau local |
| 75-95 min | Implémenter SecureVault et le test de non-exploitation | Le même scénario ne permet plus de voler les fonds du déposant |
| 95-110 min | Installer/vérifier Slither et l’exécuter sur le coffre vulnérable | Version de Slither, commande exacte, log et alerte réelle ou absence documentée |
| 110-120 min | Committer, documenter les commandes et noter les blocages | Commit Git, README.md minimal et liste des prochaines actions |

Si l’installation prend plus de temps, reporter l’analyse Mythril/Echidna et le corpus à la phase suivante. Ne pas sacrifier la preuve de fonctionnement Hardhat pour obtenir un dépôt rempli de fichiers non testés.

### Priorité A — Avant la présentation S5

1. Lire ce cahier des charges et la fiche officielle A11.
2. Diagnostiquer le Mac : Node, npm, Git, architecture.
3. Initialiser Hardhat 3 et vérifier `npm install` / `npx hardhat test`.
4. Créer le dépôt GitHub privé et le premier commit.
5. Écrire les trois contrats de démonstration.
6. Reproduire l’attaque et la correction par tests.
7. Installer et lancer Slither sur le contrat vulnérable.
8. Préparer la vidéo de secours, les captures et les diapositives.
9. Tester le TP sur un deuxième système.
10. Envoyer les diapositives et le résumé d’une page le 12 novembre à 18 h.

### Priorité B — Projet de recherche après la présentation

1. Inventorier SmartBugs et/ou les contrats d’incidents.
2. Vérifier versions Solidity, licences et annotations.
3. Sélectionner au moins 20 contrats annotés.
4. Établir et faire vérifier la vérité terrain.
5. Lancer les trois outils avec configurations tracées.
6. Construire les matrices de confusion.
7. Calculer précision, rappel et runtime par catégorie.
8. Comparer avec Durieux et al. (2020).
9. Rédiger les jalons puis l’article IEEE.

## 17. Règles de conduite pour Claude Code

Claude Code doit respecter les règles suivantes pendant tout le projet :

1. **Inspecter avant d’agir :** lire les fichiers existants, identifier les versions et l’état de Git avant toute modification.
2. **Ne pas écraser :** ne jamais supprimer ou remplacer un fichier sans expliquer pourquoi et sans sauvegarde si le fichier contient du travail utile.
3. **Faire un plan :** proposer un plan par phases et exécuter une phase à la fois.
4. **Tester :** après chaque modification de contrats/configuration/scripts, lancer les tests pertinents.
5. **Montrer les preuves :** rapporter les commandes exécutées, codes de sortie, logs et chemins des fichiers générés.
6. **Ne pas inventer :** aucun résultat, taux, détection, référence ou capture ne doit être inventé.
7. **Respecter le périmètre :** réseau Hardhat local uniquement pour les attaques ; aucun mainnet ; aucune vraie clé ou fonds réels.
8. **Respecter les licences :** tracer les sources et licences des contrats tiers ; ne pas republier un dataset non autorisé.
9. **Conserver les données brutes :** ne jamais écraser les logs et sorties originales.
10. **Documenter les limites :** timeout, erreurs de compilation, outils non compatibles, annotations inconnues ou corpus insuffisant doivent être documentés.
11. **Demander une validation humaine** avant un choix qui change la question de recherche, la composition du corpus, les étiquettes de vérité terrain ou le périmètre de sécurité.
12. **Finaliser avec reproductibilité :** une personne qui clone le dépôt doit pouvoir suivre le README et reproduire les résultats principaux.

## 18. Premier prompt à donner à Claude Code

Copier le prompt ci-dessous après avoir placé ce document à la racine du dépôt sous `CLAUDE.md` :

> Tu es l’ingénieur logiciel principal et l’assistant de recherche du Groupe 4 pour le sujet A11 « Outils d’analyse de contrats Solidity ». Lis intégralement `CLAUDE.md` et respecte toutes les consignes officielles, en particulier la démonstration Hardhat locale, l’exécution de Slither sur le coffre vulnérable, l’analyse de trois outils sur au moins 20 contrats annotés, la matrice de confusion et la reproductibilité.
>
> Commence par inspecter le dossier courant et l’environnement macOS : `node -v`, `npm -v`, `git --version`, `uname -m`, `sw_vers -productVersion`, `docker --version` si disponible, `brew --version` si disponible, et `gh auth status` si GitHub CLI est installé. Ne modifie rien avant d’avoir présenté un diagnostic court et un plan d’exécution.
>
> Ensuite, procède par phases : (1) initialisation Hardhat 3 TypeScript/Viem, (2) tests de base et lockfile, (3) dépôt Git local et dépôt GitHub privé si l’authentification est disponible, (4) contrats VulnerableVault/Attacker/SecureVault, (5) tests Hardhat prouvant l’exploitation et la correction, (6) installation et vérification Slither, Mythril et Echidna, (7) inventaire du corpus SmartBugs/contrats d’incidents et contrôle des versions Solidity, (8) manifeste annoté d’au moins 20 contrats, (9) scripts d’analyse et de collecte, (10) matrice de confusion et indicateurs, (11) documentation et démonstration.
>
> Ne suppose jamais que 20 contrats SmartBugs sont tous compatibles Solidity 0.8 : inventorie les versions et signale les insuffisances. Ne migre pas automatiquement les contrats anciens. Ne déclare pas un résultat positif ou négatif sans validation de la vérité terrain. Pour Echidna, écris des invariants explicites. Pour Mythril, respecte les limites d’exécution symbolique et conserve les timeouts. Les attaques ne doivent tourner que sur un réseau local Hardhat.
>
> Pour chaque phase, donne les fichiers créés/modifiés, les commandes exécutées, les résultats réels, les tests passés/échoués et les prochaines actions. Ne passe pas à une phase qui dépend d’une décision scientifique non validée sans la signaler. À la fin, le dépôt doit être propre, documenté et reproductible.

## 19. Références de départ

### Publications scientifiques principales

1. Nicola Atzei, Massimo Bartoletti, Tiziana Cimoli. **A Survey of Attacks on Ethereum Smart Contracts (SoK)**. Principles of Security and Trust (POST), 2017. DOI : https://doi.org/10.1007/978-3-662-54455-6_8
2. Josselin Feist, Gustavo Grieco, Alex Groce. **Slither: A Static Analysis Framework for Smart Contracts**. WETSEB, 2019. DOI : https://doi.org/10.1109/WETSEB.2019.00008
3. Thomas Durieux, João F. Ferreira, Rui Abreu, Pedro Cruz. **Empirical Review of Automated Analysis Tools on 47,587 Ethereum Smart Contracts**. ICSE, 2020. Preprint : https://arxiv.org/abs/1910.10601
4. Gustavo Grieco, Will Song, Artur Cygan, Josselin Feist, Alex Groce. **Echidna: Effective, Usable, and Fast Fuzzing for Smart Contracts**. ISSTA, 2020. DOI : https://doi.org/10.1145/3395363.3404366
5. Petar Tsankov et al. **Securify: Practical Security Analysis of Smart Contracts**. ACM CCS, 2018. DOI : https://doi.org/10.1145/3243734.3243780

### Jeux de données et documentation technique

6. SmartBugs Curated — jeu de contrats Solidity vulnérables annotés : https://github.com/smartbugs/smartbugs-curated
7. SmartBugs — données et datasets : https://github.com/smartbugs/smartbugs
8. Hardhat 3 — Getting Started : https://hardhat.org/docs/getting-started
9. Slither — Usage : https://github.com/crytic/slither/blob/master/docs/src/Usage.md
10. Mythril — dépôt et documentation : https://github.com/ConsensysDiligence/mythril
11. Echidna — dépôt et documentation : https://github.com/crytic/echidna

### Supports de cours à conserver comme références de cadrage

- Chapitre 0 — présentation du module.
- Chapitre 1 — Fondements de la cryptographie.
- Chapitre 2 — Outils mathématiques.
- Chapitre 3 — Chiffrement symétrique.
- Chapitre 4 — Hachage, MAC et intégrité.
- Chapitre 5 — Cryptographie asymétrique et signatures.
- Chapitre 6 — Fondements de la blockchain.
- Chapitre 7 — Consensus et types de blockchains.
- Chapitre 8 — Contrats intelligents, confidentialité et applications.
- Gabarit d’animation étudiant.
- Attentes par sujet d’animation, version du 10 novembre 2026.

## 20. Définition de « projet terminé »

Le projet ne peut être déclaré terminé que lorsque :

- la démonstration Hardhat de réentrance fonctionne et est reproductible ;
- le contrat corrigé passe les tests de sécurité prévus ;
- Slither, Mythril et Echidna ont été exécutés sur au moins 20 contrats annotés ;
- la composition du corpus, les versions de compilateur et les étiquettes sont documentées ;
- la vérité terrain a été vérifiée et les inconnus ne sont pas marqués comme négatifs ;
- les matrices de confusion, précision, rappel et temps d’analyse sont produits à partir des sorties brutes ;
- les résultats sont comparables par outil et catégorie de faille ;
- un script, les données permises et le README permettent de reproduire les résultats ;
- les diapositives, le TP3 et l’article IEEE sont remis selon les consignes du professeur.

**Principe final : aucun résultat non mesuré ne doit être présenté comme une conclusion scientifique.**

---

## Décisions de mise en œuvre (10/11/2026)

- Dépôt GitHub privé `Groupe4-A11-Solidity-Audit` ; passage en public prévu après S5 (le corrigé du TP3 reste caché jusque-là).
- `VulnerableVault` reprend le contrat `Coffre` du cours Ch08 (fonctions `deposer` / `retirer`, mapping `soldes`, `pragma solidity ^0.8.20`) ; compilateur figé à solc 0.8.28 dans `hardhat.config.ts`.
- `SecureVault` = vérifications–effets–interactions + verrou `nonReentrant` (OpenZeppelin `ReentrancyGuard`).
- `Attacker` ré-entre via `try/catch` pour ne pas faire échouer son retrait légitime contre la version corrigée.
- Outils macOS via Homebrew (Slither, solc-select, Echidna) ; Mythril via Docker (compatibilité arm64 à vérifier).
- Validation des 2 systèmes : Mac (coordinateur) + Windows (coéquipier).
