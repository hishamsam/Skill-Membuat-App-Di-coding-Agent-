#!/usr/bin/env bash
# Run every check script in one go.
# Usage: bash scripts/run-all.sh [slug] [A-K]
#
# Without a slug: only the environment preflight runs.
# With a slug: preflight, create the project if it does not exist yet, then run
# qa-check, security-audit, and test-local --check. Failures are reported, not
# fatal, so every step still runs.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SLUG="${1:-}"
STACK="${2:-A}"
FAIL=0

banner() { echo; echo "=== $1 ==="; }
mark() {
  if [ "$1" -eq 0 ]; then echo "  PASS  $2"; else echo "  FAIL  $2"; FAIL=$((FAIL+1)); fi
}

banner "1/5 Environment preflight"
bash "$ROOT/scripts/preflight.sh"
echo "  Note: preflight findings are not blockers."

if [ -z "$SLUG" ]; then
  echo
  echo "Environment check finished."
  echo "To run every project step:"
  echo "  bash scripts/run-all.sh <slug> [A-K]"
  exit 0
fi

PROJ="$ROOT/projects/$SLUG"

banner "2/5 Prepare project: $SLUG"
if [ -d "$PROJ" ]; then
  echo "  Project already exists: projects/$SLUG"
  mark 0 "new-project.sh (skipped)"
else
  bash "$ROOT/scripts/new-project.sh" "$SLUG" "$STACK"
  mark $? "new-project.sh"
fi

if [ ! -f "$PROJ/app/index.html" ] && [ ! -f "$PROJ/app/public/index.html" ] && [ ! -f "$PROJ/app/dist/index.html" ]; then
  echo "  Note: app has no index.html yet. Phases 1-3 are not finished."
fi

banner "3/5 Quality check (qa-check)"
bash "$ROOT/scripts/qa-check.sh" "$SLUG"
mark $? "qa-check.sh"

banner "4/5 Security audit (security-audit)"
bash "$ROOT/scripts/security-audit.sh" "$SLUG"
mark $? "security-audit.sh"

banner "5/5 Local test (test-local --check)"
bash "$ROOT/scripts/test-local.sh" "$SLUG" --check
mark $? "test-local.sh --check"

echo
if [ "$FAIL" -eq 0 ]; then
  echo "ALL PASSED for projects/$SLUG."
else
  echo "FINISHED with $FAIL failed step(s). Fix them, then rerun:"
  echo "  bash scripts/run-all.sh $SLUG $STACK"
fi
exit "$FAIL"
