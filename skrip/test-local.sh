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
  if [ ! -f "$FRONT/index.html" ]; then
    echo "GAGAL: index.html tiada dalam ${FRONT#$ROOT/}. Jana kod Fasa 3 dahulu."
    exit 1
  fi
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

run_dev() {
  local label="$1" dir="$2"
  shift 2
  if [ ! -d "$dir" ]; then
    echo "GAGAL: folder tiada: ${dir#$ROOT/}"
    exit 1
  fi
  echo "$label: http://localhost:$PORT (${dir#$ROOT/})"
  if [ "$CHECK" -eq 1 ]; then
    local log="/tmp/opencode-dev-$SLUG.log"
    (cd "$dir" && "$@" >"$log" 2>&1) &
    PID=$!
    trap 'kill $PID 2>/dev/null || true; pkill -P $PID 2>/dev/null || true' EXIT
    code="000"
    for _ in $(seq 1 45); do
      code="$(curl -s -o /dev/null -w '%{http_code}' "http://localhost:$PORT/" || true)"
      [ "$code" != "000" ] && break
      sleep 1
    done
    echo "HTTP $code"
    [ "$code" != "000" ] || { echo "GAGAL: server tidak bangkit. Lihat $log"; exit 1; }
    echo "LULUS: $label memberi respons."
  else
    cd "$dir" && exec "$@"
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
  G)
    echo "Stack G — Next.js. Pastikan dependencies dipasang: (cd projek/$SLUG/app && npm install)"
    run_dev "Next.js dev" "$APP" npm run dev -- -p "$PORT"
    ;;
  H)
    echo "Stack H — Node/Express. Pastikan dependencies dipasang: (cd projek/$SLUG/app && npm install)"
    if grep -q '"dev"' "$APP/package.json" 2>/dev/null; then
      run_dev "Node dev" "$APP" env PORT="$PORT" npm run dev
    else
      run_dev "Node start" "$APP" env PORT="$PORT" npm start
    fi
    ;;
  I)
    echo "Stack I — Laravel. Pastikan dependencies dipasang: (cd projek/$SLUG/app && composer install)"
    if [ ! -f "$APP/artisan" ]; then
      echo "GAGAL: artisan tiada dalam projek/$SLUG/app."
      exit 1
    fi
    run_dev "Laravel" "$APP" php artisan serve --host=127.0.0.1 --port="$PORT"
    ;;
  J)
    echo "Stack J — FastAPI/Django. Pastikan dependencies dipasang."
    if [ -f "$APP/manage.py" ]; then
      run_dev "Django" "$APP" python3 manage.py runserver "127.0.0.1:$PORT"
    elif [ -f "$APP/app/main.py" ]; then
      run_dev "FastAPI" "$APP" python3 -m uvicorn app.main:app --host 127.0.0.1 --port "$PORT"
    elif [ -f "$APP/main.py" ]; then
      run_dev "FastAPI" "$APP" python3 -m uvicorn main:app --host 127.0.0.1 --port "$PORT"
    else
      echo "GAGAL: manage.py atau main.py tidak dijumpai dalam projek/$SLUG/app."
      exit 1
    fi
    ;;
  *)
    echo "STACK tidak sah: $STACK"
    exit 1
    ;;
esac
