#!/usr/bin/env bash
# Commit everything in one project folder to its own local git repository.
# Usage: bash scripts/git-save.sh <slug> "<message>"
#
# Every finished module gets its own commit, so any change can be traced back to
# the module, screen, test, or audit that introduced it.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SLUG="${1:-}"
MESSAGE="${2:-}"

usage() {
  cat >&2 <<'EOF'
Usage: bash scripts/git-save.sh <slug> "<message>"

  <slug>     project folder under projects/
  <message>  commit message, e.g. "feat(module-3): booking form + tests"
EOF
}

if [ -z "$SLUG" ] || [ -z "$MESSAGE" ]; then
  usage
  exit 1
fi

PROJ="$ROOT/projects/$SLUG"

if [ ! -d "$PROJ" ]; then
  echo "Project folder missing: projects/$SLUG" >&2
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo "FAIL: git is not installed. Run: bash scripts/preflight.sh --install" >&2
  exit 1
fi

if [ ! -d "$PROJ/.git" ]; then
  git init -q "$PROJ" || { echo "FAIL: git init failed for projects/$SLUG" >&2; exit 1; }
  echo "Initialized local repository: projects/$SLUG/.git"
fi

cd "$PROJ" || exit 1

git add -A

if git diff --cached --quiet; then
  echo "No changes to commit in projects/$SLUG."
  exit 0
fi

changed="$(git diff --cached --name-only | wc -l | tr -d ' ')"

if ! git -c user.name="WebApp Builder" -c user.email="webapp-builder@localhost" \
  commit -q -m "$MESSAGE"; then
  echo "FAIL: commit rejected in projects/$SLUG" >&2
  exit 1
fi

echo "Saved projects/$SLUG: $changed file(s) changed"
git --no-pager log -1 --pretty='  %h %s'
