#!/usr/bin/env bash
# Create the folder structure for a new project.
# Usage: bash scripts/new-project.sh <slug> [A-K]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RAW_SLUG="${1:-}"
STACK="${2:-A}"

if [ -z "$RAW_SLUG" ]; then
  echo "Usage: bash scripts/new-project.sh <slug> [A-K]"
  echo "  A=GAS  B=Supabase  C=Cloudflare Worker  D=Firebase  E=Neon"
  echo "  F=Hybrid  G=Next.js  H=Node/Express  I=Laravel  J=FastAPI/Django  K=Flutter"
  exit 1
fi

SLUG="$(printf '%s' "$RAW_SLUG" \
  | tr '[:upper:]' '[:lower:]' \
  | tr ' ' '-' \
  | tr -cd 'a-z0-9._-')"

if [ -z "$SLUG" ]; then
  echo "Invalid slug: $RAW_SLUG"
  exit 1
fi

case "$STACK" in
  A|B|C|D|E|F|G|H|I|J|K) ;;
  *) echo "Stack must be A through K."; exit 1 ;;
esac

DEST="$ROOT/projects/$SLUG"

if [ -e "$DEST" ]; then
  echo "Folder already exists: projects/$SLUG"
  echo "Use another slug, or continue working in that folder."
  exit 1
fi

mkdir -p "$DEST"/{prd,refs,design/exports,app,tests}

printf '%s\n' "$STACK" > "$DEST/STACK"
touch "$DEST/refs/.gitkeep"
touch "$DEST/tests/.gitkeep"

cat > "$DEST/.gitignore" <<'EOF'
.env
.env.*
!.env.example
.dev.vars
node_modules/
dist/
build/
.dart_tool/
.wrangler/
.DS_Store
Thumbs.db
EOF

# Each project gets its own local repository so every change is traceable.
if command -v git >/dev/null 2>&1 && git init -q "$DEST" 2>/dev/null; then
  GIT_STATE="Local git repository initialized: projects/$SLUG/.git"
else
  GIT_STATE="git unavailable — run: bash scripts/preflight.sh --install"
fi

cat > "$DEST/STATUS.md" <<EOF
# STATUS — $SLUG

Stack: \`$STACK\`
Created: $(date '+%Y-%m-%d %H:%M')

## Phases

- [ ] Phase 1 — PRD (\`prd/PRD-v0.1.md\`)
- [ ] Phase 2 — FigCraft design (\`design/design.figcraft\`)
- [ ] Phase 3 — Code (\`app/\`)
- [ ] Phase 4 — Local test
- [ ] Phase 4.5 — Security audit (\`security/REPORT.md\`)
- [ ] Phase 5 — Handoff (\`HANDOFF.md\`)

## Modules

Build one module, test it, commit it, then start the next one.
Test: \`bash scripts/test-local.sh $SLUG --check --path <route>\`
Commit: \`bash scripts/git-save.sh $SLUG "<message>"\`

| # | Module | Screen / route | Test evidence | Commit | Done |
| --- | --- | --- | --- | --- | --- |
| 1 | | | | | [ ] |

## Notes

- Reference images: \`refs/\`
- Design exports: \`design/exports/\`
- Security artifacts: \`security/\`
EOF

cat > "$DEST/app/.gitignore" <<'EOF'
.env
.env.*
!.env.example
.dev.vars
.wrangler/
node_modules/
dist/
.dart_tool/
build/
EOF

# Copy the FigCraft script template
if [ -f "$ROOT/templates/figcraft/figcraft_build.py" ]; then
  cp "$ROOT/templates/figcraft/figcraft_build.py" "$DEST/design/build.py"
  sed -i "s/__SLUG__/$SLUG/g" "$DEST/design/build.py" 2>/dev/null || true
fi

echo "Project created: projects/$SLUG (stack $STACK)"
echo "$GIT_STATE"
echo
echo "Next steps:"
echo "  1. Put reference images in projects/$SLUG/refs/"
echo "  2. Generate the PRD per TEMPLATE_PRD_MS.md -> projects/$SLUG/prd/PRD-v0.1.md"
echo "  3. bash scripts/git-save.sh $SLUG \"chore: scaffold projects/$SLUG (stack $STACK)\""
echo "  4. bash scripts/test-local.sh $SLUG"
