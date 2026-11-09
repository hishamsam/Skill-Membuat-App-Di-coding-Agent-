#!/usr/bin/env bash
# Semakan statik kualiti kod sebelum serahan.
# Guna: bash skrip/qa-check.sh <slug>
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SLUG="${1:-}"
if [ -z "$SLUG" ]; then
  echo "Guna: bash skrip/qa-check.sh <slug>"
  exit 1
fi

PROJ="$ROOT/projek/$SLUG"
[ -d "$PROJ" ] || { echo "Folder tiada: projek/$SLUG"; exit 1; }

FRONT=""
for f in "$PROJ/app/index.html" "$PROJ/app/public/index.html" "$PROJ/app/dist/index.html"; do
  [ -f "$f" ] && FRONT="$f" && break
done

FAIL=0
WARN=0

fail() { echo "  GAGAL  $1"; FAIL=$((FAIL+1)); }
warn() { echo "  AMARAN $1"; WARN=$((WARN+1)); }
ok()   { echo "  OK     $1"; }

echo "QA — projek/$SLUG"

if [ -z "$FRONT" ]; then
  fail "index.html tidak dijumpai dalam app/"
  echo
  echo "Keputusan: $FAIL gagal, $WARN amaran"
  exit 1
fi

echo "Frontend: ${FRONT#$ROOT/}"

# 1. Meta viewport
if grep -qi 'name="viewport"' "$FRONT"; then ok "meta viewport"; else fail "meta viewport tiada"; fi

# 2. Dark mode
if grep -qE 'dark:|prefers-color-scheme|darkMode' "$FRONT"; then
  fail "kesan dark mode dijumpai (light mode sahaja)"
else
  ok "tiada dark mode"
fi

# 3. Placeholder / kod tidak siap
if grep -nE '\{\{|TODO|FIXME|lorem ipsum|Lorem ipsum' "$FRONT" >/dev/null; then
  fail "placeholder/TODO/lorem dijumpai"
else
  ok "tiada placeholder"
fi

# 4. Butang mati (kira kasar)
BUTTONS=$(grep -o '<button' "$FRONT" | wc -l | tr -d ' ')
ACTIONS=$(grep -o 'data-action=' "$FRONT" | wc -l | tr -d ' ')
if [ "$BUTTONS" -gt 0 ] && [ "$ACTIONS" -lt "$BUTTONS" ]; then
  warn "$BUTTONS butang, $ACTIONS data-action — semak butang tanpa handler"
else
  ok "butang ada data-action ($ACTIONS/$BUTTONS)"
fi

# 5. Responsif
if grep -qE '(sm:|md:|lg:|xl:|@media)' "$FRONT"; then
  ok "kelas/media responsif dijumpai"
else
  fail "tiada kelas responsif (sm:/md:/lg: atau @media)"
fi

# 6. Rahsia dalam frontend
if grep -nE 'service_role|SUPABASE_SERVICE|DATABASE_URL["'"'"' ]*[:=]["'"'"' ]*postgres|BEGIN (RSA |EC )?PRIVATE KEY|sk_live_|AKIA[0-9A-Z]{16}' "$FRONT" >/dev/null; then
  fail "kemungkinan rahsia dalam frontend"
else
  ok "tiada corak rahsia"
fi

# 7. URL backend masih placeholder
if grep -qE 'URL_PELANCARAN_GAS_ANDA_DISINI|GANTI_|YOUR_API_URL|example\.com' "$FRONT"; then
  warn "URL/placeholder contoh masih ada — pastikan ini disengajakan"
fi

# 8. Scroll mendatar (heuristik)
if grep -qE 'overflow-x:\s*(scroll|auto)' "$FRONT"; then
  ok "overflow-x dibenarkan pada elemen tertentu (semak visual)"
fi

# 9. PRD & design
[ -f "$PROJ/prd/PRD-v0.1.md" ] && ok "PRD ada" || fail "PRD tiada"
if [ -f "$PROJ/prd/PRD-v0.1.md" ] && grep -q '{{' "$PROJ/prd/PRD-v0.1.md"; then
  fail "PRD masih ada placeholder {{...}}"
fi

EXPORTS=$(find "$PROJ/design/exports" -maxdepth 1 -name '*.png' 2>/dev/null | wc -l | tr -d ' ')
if [ "$EXPORTS" -gt 0 ]; then ok "eksport design: $EXPORTS PNG"; else warn "tiada eksport design PNG"; fi

# 10. Fail sensitif tidak di-commit
if [ -f "$PROJ/app/.env" ]; then warn ".env wujud dalam app/ — pastikan .gitignore"; fi
if [ -f "$PROJ/app/.dev.vars" ]; then warn ".dev.vars wujud — pastikan tidak di-commit"; fi

echo
echo "Keputusan: $FAIL gagal, $WARN amaran"
[ "$FAIL" -eq 0 ] || exit 1
