#!/usr/bin/env bash
# Cipta struktur folder projek baharu.
# Guna: bash skrip/new-project.sh <slug> [A-J]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RAW_SLUG="${1:-}"
STACK="${2:-A}"

if [ -z "$RAW_SLUG" ]; then
  echo "Guna: bash skrip/new-project.sh <slug> [A-J]"
  echo "  A=GAS  B=Supabase  C=Cloudflare Worker  D=Firebase  E=Neon"
  echo "  F=Hibrid  G=Next.js  H=Node/Express  I=Laravel  J=FastAPI/Django"
  exit 1
fi

SLUG="$(printf '%s' "$RAW_SLUG" \
  | tr '[:upper:]' '[:lower:]' \
  | tr ' ' '-' \
  | tr -cd 'a-z0-9._-')"

if [ -z "$SLUG" ]; then
  echo "Slug tidak sah: $RAW_SLUG"
  exit 1
fi

case "$STACK" in
  A|B|C|D|E|F|G|H|I|J) ;;
  *) echo "Stack mesti A, B, C, D, E, F, G, H, I, atau J."; exit 1 ;;
esac

DEST="$ROOT/projek/$SLUG"

if [ -e "$DEST" ]; then
  echo "Folder sudah wujud: projek/$SLUG"
  echo "Guna slug lain, atau teruskan kerja dalam folder itu."
  exit 1
fi

mkdir -p "$DEST"/{prd,refs,design/exports,app,tests}

printf '%s\n' "$STACK" > "$DEST/STACK"
touch "$DEST/refs/.gitkeep"

cat > "$DEST/STATUS.md" <<EOF
# STATUS — $SLUG

Stack: \`$STACK\`
Cipta: $(date '+%Y-%m-%d %H:%M')

## Fasa

- [ ] Fasa 1 — PRD (\`prd/PRD-v0.1.md\`)
- [ ] Fasa 2 — Reka bentuk FigCraft (\`design/design.figcraft\`)
- [ ] Fasa 3 — Kod (\`app/\`)
- [ ] Fasa 4 — Ujian tempatan
- [ ] Fasa 5 — Serahan (\`HANDOFF.md\`)

## Nota

- Rujukan imej: \`refs/\`
- Eksport design: \`design/exports/\`
EOF

cat > "$DEST/app/.gitignore" <<'EOF'
.env
.env.*
!.env.example
.dev.vars
.wrangler/
node_modules/
dist/
EOF

# Salin templat skrip FigCraft
if [ -f "$ROOT/templat/figcraft/build.py" ]; then
  cp "$ROOT/templat/figcraft/build.py" "$DEST/design/build.py"
  sed -i "s/__SLUG__/$SLUG/g" "$DEST/design/build.py" 2>/dev/null || true
fi

echo "Projek dicipta: projek/$SLUG (stack $STACK)"
echo
echo "Langkah seterusnya:"
echo "  1. Letak imej rujukan dalam projek/$SLUG/refs/"
echo "  2. Jana PRD ikut TEMPLATE_PRD_MS.md -> projek/$SLUG/prd/PRD-v0.1.md"
echo "  3. bash skrip/test-local.sh $SLUG"
