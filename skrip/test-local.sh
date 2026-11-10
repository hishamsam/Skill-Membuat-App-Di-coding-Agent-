#!/usr/bin/env bash
# Run the app locally according to the project stack.
# Usage: bash skrip/test-local.sh <slug> [--check] [--port N] [--path /route ...]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SLUG="${1:-}"
CHECK=0
PORT="${PORT:-4173}"
PATHS=()

shift || true
while [ $# -gt 0 ]; do
  case "$1" in
    --check) CHECK=1 ;;
    --port) PORT="${2:-4173}"; shift ;;
    --path) PATHS+=("${2:-/}"); shift ;;
    *) echo "Unknown argument: $1"; exit 1 ;;
  esac
  shift
done

if [ -z "$SLUG" ]; then
  echo "Usage: bash skrip/test-local.sh <slug> [--check] [--port N] [--path /route ...]"
  exit 1
fi

PROJ="$ROOT/projek/$SLUG"
if [ ! -d "$PROJ" ]; then
  echo "Project folder missing: projek/$SLUG"
  exit 1
fi

STACK="$(cat "$PROJ/STACK" 2>/dev/null || echo A)"
APP="$PROJ/app"
FRONT="$APP"
[ -f "$APP/public/index.html" ] && FRONT="$APP/public"

# check_extra <base-url> — verify every --path module route answers 200
check_extra() {
  local base="$1" p code
  [ "${#PATHS[@]}" -eq 0 ] && return 0
  for p in "${PATHS[@]}"; do
    code="$(curl -s -o /dev/null -w '%{http_code}' "$base$p" || true)"
    if [ "$code" = "200" ]; then
      echo "PASS: $p 200"
    else
      echo "FAIL: $p returned $code"
      exit 1
    fi
  done
}

run_static() {
  if [ ! -f "$FRONT/index.html" ]; then
    echo "FAIL: index.html missing in ${FRONT#$ROOT/}. Generate the Phase 3 code first."
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
    [ "$code" = "200" ] || { echo "FAIL: server did not return 200"; exit 1; }
    check_extra "http://localhost:$PORT"
    echo "PASS: frontend loads."
  else
    cd "$FRONT" && exec python3 -m http.server "$PORT"
  fi
}

run_dev() {
  local label="$1" dir="$2"
  shift 2
  if [ ! -d "$dir" ]; then
    echo "FAIL: folder missing: ${dir#$ROOT/}"
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
    [ "$code" != "000" ] || { echo "FAIL: server did not start. See $log"; exit 1; }
    check_extra "http://localhost:$PORT"
    echo "PASS: $label responded."
  else
    cd "$dir" && exec "$@"
  fi
}

run_wrangler() {
  local dir="${1:-$APP}"
  echo "Wrangler dev (Ctrl+C to stop)"
  cd "$dir"
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
    [ "$code" != "000" ] || { echo "FAIL: Worker did not start. See /tmp/opencode-wrangler-$SLUG.log"; exit 1; }
    check_extra "http://localhost:$PORT"
    echo "PASS: Worker responded."
  else
    exec npx wrangler dev --port "$PORT"
  fi
}

run_firebase() {
  local cfg="$APP/firebase.json" log="/tmp/opencode-firebase-$SLUG.log"
  if [ ! -f "$cfg" ]; then
    echo "FAIL: firebase.json missing in ${APP#$ROOT/}."
    exit 1
  fi
  if [ ! -f "$APP/public/index.html" ]; then
    echo "FAIL: public/index.html missing in ${APP#$ROOT/}."
    exit 1
  fi
  echo "Firebase Emulator Suite (Ctrl+C to stop)"
  cd "$APP"
  if [ "$CHECK" -eq 1 ]; then
    local hp
    hp="$(python3 -c 'import json,sys; c=json.load(open(sys.argv[1])); print(c.get("emulators",{}).get("hosting",{}).get("port",5000))' "$cfg" 2>/dev/null || echo 5000)"
    npx firebase-tools emulators:start --only hosting \
      --project "${FIREBASE_PROJECT:-demo-webapp}" >"$log" 2>&1 &
    PID=$!
    trap 'kill $PID 2>/dev/null || true; pkill -P $PID 2>/dev/null || true' EXIT
    code="000"
    for _ in $(seq 1 60); do
      code="$(curl -s -o /dev/null -w '%{http_code}' "http://localhost:$hp/" || true)"
      [ "$code" != "000" ] && break
      sleep 1
    done
    echo "HTTP $code"
    [ "$code" = "200" ] || { echo "FAIL: hosting emulator did not return 200. See $log"; exit 1; }
    check_extra "http://localhost:$hp"
    echo "PASS: hosting emulator responded."
  else
    exec npx firebase-tools emulators:start
  fi
}

case "$STACK" in
  A)
    echo "Stack A — GAS. Reminder: set IS_PREVIEW=true for demo data."
    run_static
    ;;
  B)
    echo "Stack B — Supabase. Test against a dev project (no Docker on this machine)."
    run_static
    ;;
  C)
    run_wrangler
    ;;
  D)
    run_firebase
    ;;
  E)
    echo "Stack E — Neon. Test the Worker API; serve the static frontend in a second terminal."
    if [ -f "$APP/api/wrangler.jsonc" ] || [ -f "$APP/api/wrangler.toml" ]; then
      run_wrangler "$APP/api"
    else
      echo "No app/api. Test the static frontend only."
      run_static
    fi
    ;;
  F)
    echo "Stack F — Hybrid. Run the API service and the frontend in two terminals."
    run_static
    ;;
  G)
    echo "Stack G — Next.js. Make sure dependencies are installed: (cd projek/$SLUG/app && npm install)"
    run_dev "Next.js dev" "$APP" npm run dev -- -p "$PORT"
    ;;
  H)
    echo "Stack H — Node/Express. Make sure dependencies are installed: (cd projek/$SLUG/app && npm install)"
    if grep -q '"dev"' "$APP/package.json" 2>/dev/null; then
      run_dev "Node dev" "$APP" env PORT="$PORT" npm run dev
    else
      run_dev "Node start" "$APP" env PORT="$PORT" npm start
    fi
    ;;
  I)
    echo "Stack I — Laravel. Make sure dependencies are installed: (cd projek/$SLUG/app && composer install)"
    if [ ! -f "$APP/artisan" ]; then
      echo "FAIL: artisan missing in projek/$SLUG/app."
      exit 1
    fi
    run_dev "Laravel" "$APP" php artisan serve --host=127.0.0.1 --port="$PORT"
    ;;
  J)
    echo "Stack J — FastAPI/Django. Make sure dependencies are installed."
    if [ -f "$APP/manage.py" ]; then
      run_dev "Django" "$APP" python3 manage.py runserver "127.0.0.1:$PORT"
    elif [ -f "$APP/app/main.py" ]; then
      run_dev "FastAPI" "$APP" python3 -m uvicorn app.main:app --host 127.0.0.1 --port "$PORT"
    elif [ -f "$APP/main.py" ]; then
      run_dev "FastAPI" "$APP" python3 -m uvicorn main:app --host 127.0.0.1 --port "$PORT"
    else
      echo "FAIL: manage.py or main.py not found in projek/$SLUG/app."
      exit 1
    fi
    ;;
  K)
    echo "Stack K — Flutter Web + Android/iOS. Automated testing uses web."
    if ! command -v flutter >/dev/null 2>&1; then
      echo "FAIL: flutter is not on PATH. Install the SDK: https://docs.flutter.dev/get-started/install"
      exit 1
    fi
    if [ ! -f "$APP/pubspec.yaml" ]; then
      echo "FAIL: pubspec.yaml missing in ${APP#$ROOT/}."
      exit 1
    fi
    if [ "$CHECK" -eq 1 ]; then
      log="/tmp/opencode-flutter-$SLUG.log"
      (cd "$APP" && flutter build web --release) >"$log" 2>&1 \
        || { echo "FAIL: flutter build web failed. See $log"; exit 1; }
      FRONT="$APP/build/web"
      run_static
    else
      cd "$APP" && exec flutter run -d chrome --web-port "$PORT"
    fi
    ;;
  *)
    echo "Invalid STACK: $STACK"
    exit 1
    ;;
esac
