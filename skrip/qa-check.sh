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

FRAMEWORK=0
if [ -z "$FRONT" ]; then
  for f in "$PROJ/app/package.json" "$PROJ/app/composer.json" "$PROJ/app/manage.py" "$PROJ/app/pyproject.toml"; do
    [ -f "$f" ] && FRAMEWORK=1 && break
  done
fi

FAIL=0
WARN=0

fail() { echo "  GAGAL  $1"; FAIL=$((FAIL+1)); }
warn() { echo "  AMARAN $1"; WARN=$((WARN+1)); }
ok()   { echo "  OK     $1"; }

echo "QA — projek/$SLUG"

if [ -z "$FRONT" ] && [ "$FRAMEWORK" -eq 0 ]; then
  fail "index.html atau projek framework tidak dijumpai dalam app/"
  echo
  echo "Keputusan: $FAIL gagal, $WARN amaran"
  exit 1
fi

if [ -n "$FRONT" ]; then
  SCAN="$FRONT"
  GREP=(-r)
  echo "Frontend: ${FRONT#$ROOT/}"
else
  SCAN="$PROJ/app"
  GREP=(-r --binary-files=without-match --exclude-dir=node_modules
        --exclude-dir=vendor --exclude-dir=.next --exclude-dir=dist
        --exclude-dir=build --exclude-dir=.git)
  echo "Frontend: ${SCAN#$ROOT/} (projek framework)"
fi

# 1. Meta viewport
if grep -qi "${GREP[@]}" 'name="viewport"\|viewport' "$SCAN"; then
  ok "meta viewport"
elif [ "$FRAMEWORK" -eq 1 ]; then
  warn "corak viewport tidak dijumpai — semak konfigurasi framework"
else
  fail "meta viewport tiada"
fi

# 2. Dark mode
if grep -qE "${GREP[@]}" 'dark:|prefers-color-scheme|darkMode' "$SCAN"; then
  fail "kesan dark mode dijumpai (light mode sahaja)"
else
  ok "tiada dark mode"
fi

# 3. Placeholder / kod tidak siap
if grep -nE "${GREP[@]}" '\{\{|TODO|FIXME|lorem ipsum|Lorem ipsum' "$SCAN" >/dev/null; then
  fail "placeholder/TODO/lorem dijumpai"
else
  ok "tiada placeholder"
fi

# 4. Butang mati (kira kasar)
BUTTONS=$(grep -rho "${GREP[@]}" '<button' "$SCAN" | wc -l | tr -d ' ')
ACTIONS=$(grep -rho "${GREP[@]}" 'data-action=\|onClick=\|@click=' "$SCAN" | wc -l | tr -d ' ')
if [ "$BUTTONS" -gt 0 ] && [ "$ACTIONS" -lt "$BUTTONS" ]; then
  warn "$BUTTONS butang, $ACTIONS handler — semak butang tanpa handler"
else
  ok "butang ada handler ($ACTIONS/$BUTTONS)"
fi

# 5. Responsif
if grep -qE "${GREP[@]}" '(sm:|md:|lg:|xl:|@media)' "$SCAN"; then
  ok "kelas/media responsif dijumpai"
elif [ "$FRAMEWORK" -eq 1 ]; then
  warn "corak responsif tidak dijumpai — semak CSS framework"
else
  fail "tiada kelas responsif (sm:/md:/lg: atau @media)"
fi

# 6. Rahsia dalam frontend
if grep -nE "${GREP[@]}" 'service_role|SUPABASE_SERVICE|DATABASE_URL["'"'"' ]*[:=]["'"'"' ]*postgres|BEGIN (RSA |EC )?PRIVATE KEY|sk_live_|AKIA[0-9A-Z]{16}' "$SCAN" >/dev/null; then
  fail "kemungkinan rahsia dalam frontend"
else
  ok "tiada corak rahsia"
fi

# 7. URL backend masih placeholder
if grep -qE "${GREP[@]}" 'URL_PELANCARAN_GAS_ANDA_DISINI|GANTI_|YOUR_API_URL|example\.com' "$SCAN"; then
  warn "URL/placeholder contoh masih ada — pastikan ini disengajakan"
fi

# 8. Scroll mendatar (heuristik)
if grep -qE "${GREP[@]}" 'overflow-x:\s*(scroll|auto)' "$SCAN"; then
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
