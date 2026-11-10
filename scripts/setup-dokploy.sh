#!/usr/bin/env bash
# Install Dokploy for local/dev testing — ONLY with the user's permission.
# Usage: bash scripts/setup-dokploy.sh [--check] [--yes]
#
# Without --yes, the script stops and waits for a y/n answer. Any answer other
# than y means skip: continue with manual testing.
set -uo pipefail

CHECK=0
ASSUME_YES=0

while [ $# -gt 0 ]; do
  case "$1" in
    --check) CHECK=1 ;;
    --yes) ASSUME_YES=1 ;;
    *) echo "Usage: bash scripts/setup-dokploy.sh [--check] [--yes]"; exit 1 ;;
  esac
  shift
done

installed() {
  curl -fsS -o /dev/null --max-time 3 http://localhost:3000/ 2>/dev/null \
    || docker service ls 2>/dev/null | grep -q dokploy
}

if [ "$CHECK" -eq 1 ]; then
  if installed; then
    echo "Dokploy: active at http://localhost:3000"
  else
    echo "Dokploy: not detected"
  fi
  exit 0
fi

if installed; then
  echo "Dokploy is already active: http://localhost:3000"
  echo "Next step: open that URL, create the admin account, then store"
  echo "DOKPLOY_URL and DOKPLOY_API_KEY in the environment (never commit them)."
  exit 0
fi

cat <<'EOF'
Dokploy installs:
  - Docker (if not present already)
  - Dokploy + Traefik, using ports 80, 443, and 3000
  - Requires Linux, root access, and a dev machine/VPS (not a production machine)

It modifies the system and downloads the official script:
  https://dokploy.com/install.sh

If you decline, this script skips it and local testing is done manually.
EOF

if [ "$ASSUME_YES" -ne 1 ]; then
  printf 'Install Dokploy now? [y/N] '
  read -r answer || answer=""
  case "$answer" in
    y|Y|ya|YA|Ya) ;;
    *) echo "Skipped. Manual testing: bash scripts/test-local.sh <slug> --check"
       exit 0 ;;
  esac
fi

if [ "$(uname -s)" != "Linux" ]; then
  echo "FAIL: Dokploy is Linux only. Manual testing only."
  exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "FAIL: install as root. Run:"
  echo "  sudo bash scripts/setup-dokploy.sh"
  exit 1
fi

for port in 80 443 3000; do
  if ss -ltn 2>/dev/null | grep -q ":$port "; then
    echo "FAIL: port $port is in use. Stop that service first."
    exit 1
  fi
done

echo "Installing Dokploy..."
if curl -sSL https://dokploy.com/install.sh | sh; then
  echo
  echo "Dokploy installed. Open http://localhost:3000 and create the admin account."
  echo "Then set DOKPLOY_URL and DOKPLOY_API_KEY in the environment."
  echo "Do not store keys in the repo."
else
  echo "FAIL: Dokploy installation did not finish. Manual testing only."
  exit 1
fi
