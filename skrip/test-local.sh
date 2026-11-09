#!/usr/bin/env bash
# Jalankan app secara tempatan mengikut stack projek.
# Guna: bash skrip/test-local.sh <slug> [--check] [--port N]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SLUG="${1:-}"
CHECK=0
PORT="${PORT:-4173}"

shift || true
while [ $# -gt 0 ]; do
  case "$1" in
    --check) CHECK=1 ;;
    --port) PORT="${2:-4173}"; shift ;;
    *) echo "Argumen tidak dikenali: $1"; exit 1 ;;
  esac
  shift
done

if [ -z "$SLUG" ]; then
  echo "Guna: bash skrip/test-local.sh <slug> [--check] [--port N]"
  exit 1
fi

PROJ="$ROOT/projek/$SLUG"
if [ ! -d "$PROJ" ]; then
  echo "Folder projek tiada: projek/$SLUG"
  exit 1
fi

STACK="$(cat "$PROJ/STACK" 2>/dev/null || echo A)"
APP="$PROJ/app"
FRONT="$APP"
[ -f "$APP/public/index.html" ] && FRONT="$APP/public"

run_static() {
  echo "Static server: http://localhost:$PORT ($FRONT)"
  if [ "$CHECK" -eq 1 ]; then
    (cd "$FRONT" && exec python3 -m http.server "$PORT" >/tmp/opencode-http-$SLUG.log 2>&1) &
    PID=$!
    trap 'kill $PID 2>/dev/null || true; pkill -P $PID 2>/dev/null || true' EXIT
    sleep 1
    code="$(curl -s -o /dev/null -w '%{http_code}' "http://localhost:$PORT/" || true)"
    echo "HTTP $code"
    [ "$code" = "200" ] || { echo "GAGAL: server tidak memulangkan 200"; exit 1; }
    echo "LULUS: frontend boleh dimuatkan."
  else
    cd "$FRONT" && exec python3 -m http.server "$PORT"
  fi
}

run_wrangler() {
  echo "Wrangler dev (Ctrl+C untuk henti)"
  cd "$APP"
  if [ "$CHECK" -eq 1 ]; then
    npx wrangler dev --port "$PORT" >/tmp/opencode-wrangler-$SLUG.log 2>&1 &
    PID=$!
    trap 'kill $PID 2>/dev/null || true; pkill -P $PID 2>/dev/null || true' EXIT
    for _ in $(seq 1 30); do
      code="$(curl -s -o /dev/null -w '%{http_code}' "http://localhost:$PORT/" || true)"
      [ "$code" != "000" ] && break
      sleep 1
    done
    echo "HTTP $code"
    [ "$code" != "000" ] || { echo "GAGAL: Worker tidak bangkit. Lihat /tmp/opencode-wrangler-$SLUG.log"; exit 1; }
    echo "LULUS: Worker memberi respons."
  else
    exec npx wrangler dev --port "$PORT"
  fi
}

run_firebase() {
  echo "Firebase Emulator Suite (Ctrl+C untuk henti)"
  cd "$APP"
  exec npx firebase-tools emulators:start
}

case "$STACK" in
  A)
    echo "Stack A — GAS. Peringatan: set IS_PREVIEW=true untuk data demo."
    run_static
    ;;
  B)
    echo "Stack B — Supabase. Uji dengan projek dev (Docker tiada di mesin ini)."
    run_static
    ;;
  C)
    run_wrangler
    ;;
  D)
    run_firebase
    ;;
  E)
    echo "Stack E — Neon. Uji API Worker; frontend static dalam terminal kedua."
    if [ -f "$APP/api/wrangler.jsonc" ] || [ -f "$APP/api/wrangler.toml" ]; then
      cd "$APP/api" && exec npx wrangler dev --port "$PORT"
    else
      echo "Tiada app/api. Uji static sahaja."
      run_static
    fi
    ;;
  F)
    echo "Stack F — Hibrid. Jalankan servis API dan frontend dalam dua terminal."
    run_static
    ;;
  *)
    echo "STACK tidak sah: $STACK"
    exit 1
    ;;
esac
