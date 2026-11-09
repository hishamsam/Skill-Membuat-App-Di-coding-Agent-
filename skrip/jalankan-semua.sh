#!/usr/bin/env bash
# Jalankan semua skrip semakan sekali gus.
# Guna: bash skrip/jalankan-semua.sh [slug] [A-J]
#
# Tanpa slug: hanya semak persekitaran.
# Dengan slug: semak persekitaran, cipta projek jika belum ada, kemudian
# jalankan qa-check dan test-local --check. Kegagalan dilaporkan, bukan
# dihentikan, supaya semua langkah tetap berjalan.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SLUG="${1:-}"
STACK="${2:-A}"
FAIL=0

banner() { echo; echo "=== $1 ==="; }
mark() {
  if [ "$1" -eq 0 ]; then echo "  LULUS  $2"; else echo "  GAGAL  $2"; FAIL=$((FAIL+1)); fi
}

banner "1/4 Semak persekitaran"
bash "$ROOT/skrip/check-setup.sh"
echo "  Nota: AMARAN dalam check-setup bukan penghalang."

if [ -z "$SLUG" ]; then
  echo
  echo "Selesai semakan persekitaran."
  echo "Untuk jalankan semua langkah projek:"
  echo "  bash skrip/jalankan-semua.sh <slug> [A-J]"
  exit 0
fi

PROJ="$ROOT/projek/$SLUG"

banner "2/4 Sediakan projek: $SLUG"
if [ -d "$PROJ" ]; then
  echo "  Projek sudah wujud: projek/$SLUG"
  mark 0 "new-project.sh (dilangkau)"
else
  bash "$ROOT/skrip/new-project.sh" "$SLUG" "$STACK"
  mark $? "new-project.sh"
fi

if [ ! -f "$PROJ/app/index.html" ] && [ ! -f "$PROJ/app/public/index.html" ] && [ ! -f "$PROJ/app/dist/index.html" ]; then
  echo "  Nota: app belum ada index.html. Fasa 1-3 belum siap."
fi

banner "3/4 Semakan kualiti (qa-check)"
bash "$ROOT/skrip/qa-check.sh" "$SLUG"
mark $? "qa-check.sh"

banner "4/4 Ujian tempatan (test-local --check)"
bash "$ROOT/skrip/test-local.sh" "$SLUG" --check
mark $? "test-local.sh --check"

echo
if [ "$FAIL" -eq 0 ]; then
  echo "SEMUA LULUS untuk projek/$SLUG."
else
  echo "SELESAI dengan $FAIL langkah gagal. Betulkan, kemudian ulang:"
  echo "  bash skrip/jalankan-semua.sh $SLUG $STACK"
fi
exit "$FAIL"
