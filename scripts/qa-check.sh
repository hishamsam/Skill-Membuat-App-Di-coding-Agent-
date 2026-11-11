#!/usr/bin/env bash
# Static code quality check before handoff.
# Usage: bash scripts/qa-check.sh <slug>
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SLUG="${1:-}"
if [ -z "$SLUG" ]; then
  echo "Usage: bash scripts/qa-check.sh <slug>"
  exit 1
fi

PROJ="$ROOT/projects/$SLUG"
[ -d "$PROJ" ] || { echo "Folder missing: projects/$SLUG"; exit 1; }

FRONT=""
for f in "$PROJ/app/index.html" "$PROJ/app/public/index.html" "$PROJ/app/dist/index.html"; do
  [ -f "$f" ] && FRONT="$f" && break
done

FLUTTER=0
[ -f "$PROJ/app/pubspec.yaml" ] && FLUTTER=1

FRAMEWORK=0
if [ -z "$FRONT" ] && [ "$FLUTTER" -eq 0 ]; then
  for f in "$PROJ/app/package.json" "$PROJ/app/composer.json" "$PROJ/app/manage.py" "$PROJ/app/pyproject.toml"; do
    [ -f "$f" ] && FRAMEWORK=1 && break
  done
fi

FAIL=0
WARN=0

fail() { echo "  FAIL   $1"; FAIL=$((FAIL+1)); }
warn() { echo "  WARN   $1"; WARN=$((WARN+1)); }
ok()   { echo "  OK     $1"; }

echo "QA — projects/$SLUG"

if [ "$FLUTTER" -eq 1 ] && [ ! -d "$PROJ/app/lib" ]; then
  fail "lib/ missing in app/ (Flutter project)"
  echo
  echo "Result: $FAIL failed, $WARN warnings"
  exit 1
fi

if [ -z "$FRONT" ] && [ "$FRAMEWORK" -eq 0 ] && [ "$FLUTTER" -eq 0 ]; then
  fail "no index.html, pubspec.yaml, or framework project found in app/"
  echo
  echo "Result: $FAIL failed, $WARN warnings"
  exit 1
fi

if [ "$FLUTTER" -eq 1 ]; then
  SCAN="$PROJ/app/lib"
  GREP=(-r --binary-files=without-match)
  echo "Frontend: ${SCAN#$ROOT/} (Flutter)"
elif [ -n "$FRONT" ]; then
  SCAN="$FRONT"
  GREP=(-r)
  echo "Frontend: ${FRONT#$ROOT/}"
else
  SCAN="$PROJ/app"
  GREP=(-r --binary-files=without-match --exclude-dir=node_modules
        --exclude-dir=vendor --exclude-dir=.next --exclude-dir=dist
        --exclude-dir=build --exclude-dir=.git)
  echo "Frontend: ${SCAN#$ROOT/} (framework project)"
fi

if [ "$FLUTTER" -eq 1 ]; then
  # F1. Entry point
  [ -f "$PROJ/app/lib/main.dart" ] && ok "lib/main.dart present" || fail "lib/main.dart missing"

  # F2. Responsive
  if grep -qE "${GREP[@]}" 'LayoutBuilder|MediaQuery|constraints\.maxWidth|OrientationBuilder' "$SCAN"; then
    ok "Flutter responsive patterns found"
  else
    fail "no LayoutBuilder/MediaQuery — check responsiveness at 360–1920"
  fi

  # F3. Light mode only
  if grep -qE "${GREP[@]}" 'ThemeMode\.dark|darkTheme|Brightness\.dark' "$SCAN"; then
    fail "dark theme found (light mode only)"
  else
    ok "no dark mode"
  fi

  # F4. Buttons without a handler
  BUTTONS=$(grep -rhoE "${GREP[@]}" 'ElevatedButton|FilledButton|TextButton|OutlinedButton|IconButton' "$SCAN" | wc -l | tr -d ' ')
  ACTIONS=$(grep -rhoE "${GREP[@]}" 'onPressed:|onTap:' "$SCAN" | wc -l | tr -d ' ')
  if [ "$BUTTONS" -gt 0 ] && [ "$ACTIONS" -lt "$BUTTONS" ]; then
    warn "$BUTTONS buttons, $ACTIONS handlers — check for buttons without a handler"
  else
    ok "buttons have handlers ($ACTIONS/$BUTTONS)"
  fi

  # F5. Placeholders
  if grep -nE "${GREP[@]}" '\{\{|TODO|FIXME|lorem ipsum|Lorem ipsum' "$SCAN" >/dev/null; then
    fail "placeholder/TODO/lorem found"
  else
    ok "no placeholders"
  fi
else

# 1. Meta viewport
if grep -qi "${GREP[@]}" 'name="viewport"\|viewport' "$SCAN"; then
  ok "meta viewport"
elif [ "$FRAMEWORK" -eq 1 ]; then
  warn "no viewport pattern found — check the framework configuration"
else
  fail "meta viewport missing"
fi

# 2. Dark mode
if grep -qE "${GREP[@]}" 'dark:|prefers-color-scheme|darkMode' "$SCAN"; then
  fail "dark mode traces found (light mode only)"
else
  ok "no dark mode"
fi

# 3. Placeholder / unfinished code
if grep -nE "${GREP[@]}" '\{\{|TODO|FIXME|lorem ipsum|Lorem ipsum' "$SCAN" >/dev/null; then
  fail "placeholder/TODO/lorem found"
else
  ok "no placeholders"
fi

# 4. Dead buttons (rough count)
BUTTONS=$(grep -rho "${GREP[@]}" '<button' "$SCAN" | wc -l | tr -d ' ')
ACTIONS=$(grep -rho "${GREP[@]}" 'data-action=\|onClick=\|@click=' "$SCAN" | wc -l | tr -d ' ')
if [ "$BUTTONS" -gt 0 ] && [ "$ACTIONS" -lt "$BUTTONS" ]; then
  warn "$BUTTONS buttons, $ACTIONS handlers — check for buttons without a handler"
else
  ok "buttons have handlers ($ACTIONS/$BUTTONS)"
fi

# 5. Responsive
if grep -qE "${GREP[@]}" '(sm:|md:|lg:|xl:|@media)' "$SCAN"; then
  ok "responsive classes/media found"
elif [ "$FRAMEWORK" -eq 1 ]; then
  warn "no responsive pattern found — check the CSS framework"
else
  fail "no responsive classes (sm:/md:/lg: or @media)"
fi
fi

# 6. Secrets in the frontend
if grep -nE "${GREP[@]}" 'service_role|SUPABASE_SERVICE|DATABASE_URL["'"'"' ]*[:=]["'"'"' ]*postgres|BEGIN (RSA |EC )?PRIVATE KEY|sk_live_|AKIA[0-9A-Z]{16}' "$SCAN" >/dev/null; then
  fail "possible secret in the frontend"
else
  ok "no secret patterns"
fi

# 7. Backend URL still a placeholder
if grep -qE "${GREP[@]}" 'URL_PELANCARAN_GAS_ANDA_DISINI|GANTI_|YOUR_API_URL|example\.com' "$SCAN"; then
  warn "sample URL/placeholder still present — make sure this is intentional"
fi

# 8. Horizontal scroll (heuristic)
if grep -qE "${GREP[@]}" 'overflow-x:\s*(scroll|auto)' "$SCAN"; then
  ok "overflow-x allowed on specific elements (visual check required)"
fi

# 9. PRD and design
[ -f "$PROJ/prd/PRD-v0.1.md" ] && ok "PRD present" || fail "PRD missing"
if [ -f "$PROJ/prd/PRD-v0.1.md" ] && grep -q '{{' "$PROJ/prd/PRD-v0.1.md"; then
  fail "PRD still has {{...}} placeholders"
fi

if [ -f "$PROJ/design/DESIGN-BLUEPRINT.md" ]; then
  if grep -q '{{' "$PROJ/design/DESIGN-BLUEPRINT.md"; then
    warn "DESIGN-BLUEPRINT.md still has {{...}} placeholders"
  else
    ok "Design System Blueprint present"
  fi
else
  warn "DESIGN-BLUEPRINT.md missing in design/"
fi

REFS=$(find "$PROJ/refs" -maxdepth 1 \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' -o -name '*.webp' \) 2>/dev/null | wc -l | tr -d ' ')
if [ "$REFS" -gt 0 ]; then
  ok "reference images: $REFS"
fi

# 10. Sensitive files not committed
if [ -f "$PROJ/app/.env" ]; then warn ".env present in app/ — make sure .gitignore covers it"; fi
if [ -f "$PROJ/app/.dev.vars" ]; then warn ".dev.vars present — make sure it is not committed"; fi

echo
echo "Result: $FAIL failed, $WARN warnings"
[ "$FAIL" -eq 0 ] || exit 1
