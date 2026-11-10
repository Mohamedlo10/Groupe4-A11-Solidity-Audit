#!/usr/bin/env bash
# Lance Slither et conserve les sorties brutes (cahier des charges §11.1 et §12).
# Usage : bash scripts/run_slither.sh [cible ...]
#   sans argument : le projet entier (mode Hardhat) puis chaque contrat de démonstration (mode fichier).
# Chaque exécution crée un nouveau dossier results/raw/slither/<RUN_ID>/ : rien n'est écrasé.
# Code de sortie de Slither : 0 = aucune alerte ; 255 = des alertes ont été trouvées (ce n'est pas un plantage).
# Le champ "success" du JSON indique si l'analyse elle-même a réussi.
set -u
cd "$(dirname "$0")/.."

REMAPS="@openzeppelin/=node_modules/@openzeppelin/"
if [ "$#" -gt 0 ]; then
  CIBLES=("$@")
else
  CIBLES=(. contracts/vulnerable/VulnerableVault.sol contracts/secure/SecureVault.sol)
fi

RUN_ID="$(date -u '+%Y%m%dT%H%M%SZ')"
OUT="results/raw/slither/$RUN_ID"
mkdir -p "$OUT"

SLITHER_V="$(slither --version 2>&1 | head -n 1)"
SOLC_V="$(solc --version 2>&1 | tail -n 1)"
COMMIT="$(git rev-parse --short HEAD 2>/dev/null || echo aucun)"
DIRTY="$(git status --porcelain -- contracts 2>/dev/null | wc -l | tr -d ' ')"

echo "Slither $SLITHER_V | $SOLC_V | commit $COMMIT | sortie $OUT"
META="$OUT/meta.jsonl"

for CIBLE in "${CIBLES[@]}"; do
  if [ "$CIBLE" = "." ]; then NOM="projet"; else NOM="$(basename "$CIBLE" .sol)"; fi
  CMD=(slither "$CIBLE" --json "$OUT/$NOM.json")
  [ "$CIBLE" != "." ] && CMD+=(--solc-remaps "$REMAPS")

  DEBUT=$(date +%s)
  "${CMD[@]}" > "$OUT/$NOM.txt" 2>&1
  CODE=$?
  DUREE=$(( $(date +%s) - DEBUT ))

  printf '{"run_id":"%s","cible":"%s","commande":"%s","slither":"%s","solc":"%s","commit":"%s","contrats_modifies_non_commites":%s,"code_sortie":%s,"duree_s":%s,"date_utc":"%s"}\n' \
    "$RUN_ID" "$CIBLE" "${CMD[*]}" "$SLITHER_V" "$SOLC_V" "$COMMIT" "$DIRTY" "$CODE" "$DUREE" "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" >> "$META"
  echo "  - $CIBLE -> $NOM.{json,txt} (code $CODE, ${DUREE}s)"
done
