#!/usr/bin/env bash
# Diagnostic de l'environnement (cahier des charges 10.1 et 11.4).
# Usage : bash scripts/check_env.sh [fichier_sortie]   (defaut : results/environment.json)
# Fonctionne sur macOS et Linux ; sous Windows, utiliser Git Bash ou noter les versions a la main.
set -u
OUT="${1:-results/environment.json}"
mkdir -p "$(dirname "$OUT")"

v() { # premiere ligne de "commande --version", ou "absent"
  if command -v "$1" >/dev/null 2>&1; then "$@" 2>&1 | head -n 1 | tr -d '"\r'; else echo "absent"; fi
}

OS_NAME="$(uname -s)"
if [ "$OS_NAME" = "Darwin" ]; then OS_VERSION="macOS $(sw_vers -productVersion)"; else OS_VERSION="$(uname -sr)"; fi

cat > "$OUT" <<EOF
{
  "date_utc": "$(date -u '+%Y-%m-%dT%H:%M:%SZ')",
  "git_commit": "$(git rev-parse --short HEAD 2>/dev/null || echo 'aucun')",
  "os": "$OS_VERSION",
  "arch": "$(uname -m)",
  "node": "$(v node -v)",
  "npm": "$(v npm -v)",
  "git": "$(v git --version)",
  "hardhat": "$(npx --no-install hardhat --version 2>/dev/null | tail -n 1 || echo absent)",
  "solc_hardhat_config": "$(grep -oE 'version: "[0-9.]+"' hardhat.config.ts | head -n 1 | grep -oE '[0-9.]+')",
  "python3": "$(v python3 --version)",
  "brew": "$(v brew --version)",
  "docker": "$(v docker --version)",
  "slither": "$(v slither --version)",
  "solc_select_current": "$(v solc --version | tail -n 1)",
  "myth": "$(v myth version)",
  "echidna": "$(v echidna --version)"
}
EOF
cat "$OUT"
