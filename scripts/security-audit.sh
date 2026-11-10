#!/usr/bin/env bash
# Static security audit for one project, before handoff.
# Usage: bash scripts/security-audit.sh <slug> [--json] [--deps]
#
# This is the automated half of Phase 4.5 (see workflow/06-security-audit.md).
# It reports source-grounded candidates: FAIL means the pattern is a real control
# gap in the code, WARN means a human must confirm the trace before calling it a
# finding. It never contacts a deployed endpoint.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SLUG="${1:-}"
JSON=0
DEPS=0

shift || true
while [ "$#" -gt 0 ]; do
  case "$1" in
    --json) JSON=1 ;;
    --deps) DEPS=1 ;;
    --help|-h)
      echo "Usage: bash scripts/security-audit.sh <slug> [--json] [--deps]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
  shift
done

if [ -z "$SLUG" ]; then
  echo "Usage: bash scripts/security-audit.sh <slug> [--json] [--deps]" >&2
  exit 1
fi

PROJ="$ROOT/projects/$SLUG"
APP="$PROJ/app"
OUTDIR="$PROJ/security"

if [ ! -d "$PROJ" ]; then
  echo "Project folder missing: projects/$SLUG" >&2
  exit 1
fi
if [ ! -d "$APP" ]; then
  echo "FAIL: app/ missing in projects/$SLUG — nothing to audit." >&2
  exit 1
fi

STACK="$(cat "$PROJ/STACK" 2>/dev/null || echo A)"

CLIENT=()
for f in "$APP/index.html" "$APP/public/index.html" "$APP/public/app.js" "$APP/dist/index.html"; do
  [ -f "$f" ] && CLIENT+=("$f")
done

FAIL=0
WARN=0
PASS=0
ROWS=()

json_escape() {
  printf '%s' "$1" | tr -d '\r' | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/	/\\t/g'
}

# hits <pattern> — matching file:line lines, first three, app source only
hits() {
  grep -rInE --binary-files=without-match \
    --exclude-dir=node_modules --exclude-dir=vendor --exclude-dir=.git \
    --exclude-dir=dist --exclude-dir=build --exclude-dir=.next \
    --exclude-dir=.dart_tool --exclude-dir=exports \
    "$1" "$APP" 2>/dev/null | head -3
}

# hits_client <pattern> — same, limited to the frontend entry files
hits_client() {
  [ "${#CLIENT[@]}" -eq 0 ] && return 0
  grep -nHE --binary-files=without-match "$1" "${CLIENT[@]}" 2>/dev/null | head -3
}

# rule <id> <level> <detail> <evidence>
rule() {
  local id="$1" level="$2" detail="$3" evidence="${4:-}"
  evidence="${evidence//$ROOT\//}"
  case "$level" in
    FAIL) FAIL=$((FAIL + 1)) ;;
    WARN) WARN=$((WARN + 1)) ;;
    *) PASS=$((PASS + 1)) ;;
  esac
  ROWS+=("$level|$id|$detail|$evidence")
  if [ "$JSON" -eq 0 ]; then
    printf '  %-5s %-22s %s\n' "$level" "$id" "$detail"
    if [ -n "$evidence" ]; then
      while IFS= read -r line; do
        [ -n "$line" ] && printf '        %s\n' "${line#"$ROOT"/}"
      done <<< "$evidence"
    fi
  fi
}

[ "$JSON" -eq 0 ] && echo "Security audit — projects/$SLUG (stack $STACK)"

# 1. Secrets visible to the client
ev="$(hits_client 'service_role|SUPABASE_SERVICE|sk_live_|AKIA[0-9A-Z]{16}|BEGIN (RSA |EC )?PRIVATE KEY')"
if [ -n "$ev" ]; then
  rule "secret-in-client" FAIL "privileged key or private key referenced from client code" "$ev"
else
  rule "secret-in-client" PASS "no privileged key pattern in client code"
fi

# 2. Secrets anywhere in app source
ev="$(hits '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY|sk_live_[0-9A-Za-z]+|AKIA[0-9A-Z]{16}|ghp_[0-9A-Za-z]{20,}')"
if [ -n "$ev" ]; then
  rule "secret-in-source" FAIL "credential material committed in app source" "$ev"
else
  rule "secret-in-source" PASS "no credential material in app source"
fi

# 3. Hardcoded password literal
ev="$(hits '(password|passwd|passphrase)[[:space:]]*[:=][[:space:]]*["'"'"'][^"'"'"']{6,}["'"'"']' | grep -viE 'env\.|process\.env|example|change_?me|your_|\{\{|<|xxx')"
if [ -n "$ev" ]; then
  rule "hardcoded-password" FAIL "literal password assigned in source" "$ev"
else
  rule "hardcoded-password" PASS "no literal password assignment"
fi

# 4. Sensitive files tracked by version control
ev=""
if command -v git >/dev/null 2>&1 && [ -d "$PROJ/.git" ]; then
  tracked="$(git -C "$PROJ" ls-files -- 'app/.env' 'app/.dev.vars' '*.pem' '*.key' 2>/dev/null)"
  if [ -n "$tracked" ]; then
    while IFS= read -r f; do
      [ -n "$f" ] && ev+="$PROJ/$f"$'\n'
    done <<< "$tracked"
  fi
fi
if [ -n "$ev" ]; then
  rule "secrets-committed" FAIL "secret file is committed to the local git history" "$ev"
else
  rule "secrets-committed" PASS "no secret file tracked by git"
fi

# 5. .gitignore covers secrets
if [ -f "$APP/.gitignore" ] && grep -qE '^\.env($|\*|\.)|^\.dev\.vars' "$APP/.gitignore"; then
  rule "gitignore-secrets" PASS ".gitignore excludes secret files"
else
  rule "gitignore-secrets" WARN "app/.gitignore does not exclude .env/.dev.vars"
fi

# 6. Injection sinks
ev="$(hits '(execute|query|raw|prepare)[[:space:]]*\([^)]*(\+|\$\{|\|\|)')"
if [ -n "$ev" ]; then
  rule "sql-injection" FAIL "SQL built by string concatenation/interpolation" "$ev"
else
  rule "sql-injection" PASS "no concatenated query call"
fi

# 7. Code execution sinks
ev="$(hits '\beval\(|\bnew Function\(|child_process|\bexecSync\(|\bos\.system\(|subprocess\.[A-Za-z]+\(.*shell[[:space:]]*=[[:space:]]*True')"
if [ -n "$ev" ]; then
  rule "code-execution-sink" FAIL "dynamic code execution or shell with untrusted input" "$ev"
else
  rule "code-execution-sink" PASS "no eval/exec sink"
fi

# 8. DOM XSS sinks
ev="$(hits 'innerHTML[[:space:]]*=[^;]*(\+|\$\{)|dangerouslySetInnerHTML|document\.write\(|insertAdjacentHTML\(')"
if [ -n "$ev" ]; then
  rule "dom-xss-sink" WARN "HTML sink present — confirm the value is escaped or constant" "$ev"
else
  rule "dom-xss-sink" PASS "no raw HTML sink"
fi

# 9. CORS
ev="$(hits 'Access-Control-Allow-Origin[^;]*["'"'"']\*["'"'"']|origin[[:space:]]*:[[:space:]]*["'"'"']\*["'"'"']')"
if [ -n "$ev" ]; then
  if hits 'credentials[[:space:]]*:[[:space:]]*true' >/dev/null 2>&1; then
    rule "cors-wildcard" FAIL "wildcard CORS origin combined with credentials" "$ev"
  else
    rule "cors-wildcard" WARN "wildcard CORS origin — confirm it is intentional" "$ev"
  fi
else
  rule "cors-wildcard" PASS "no wildcard CORS origin"
fi

# 10. Cookie flags
ev="$(hits 'Set-Cookie')"
if [ -n "$ev" ]; then
  if ! hits 'HttpOnly' >/dev/null 2>&1; then
    rule "cookie-flags" FAIL "session cookie without HttpOnly" "$ev"
  elif ! hits 'SameSite' >/dev/null 2>&1 || ! hits 'Secure' >/dev/null 2>&1; then
    rule "cookie-flags" WARN "cookie missing SameSite or Secure" "$ev"
  else
    rule "cookie-flags" PASS "cookies set HttpOnly, Secure, SameSite"
  fi
else
  rule "cookie-flags" PASS "no server-set cookie found"
fi

# 11. State-changing routes without a CSRF token (framework stacks only)
case "$STACK" in
  G|H|I|J)
    if hits '(app|router)\.(post|put|patch|delete)\(' >/dev/null 2>&1 \
      && ! hits 'csrf|CSRF|xsrf|XSRF' >/dev/null 2>&1; then
      rule "csrf" WARN "state-changing route without CSRF token or SameSite-only session" "$(hits '(app|router)\.(post|put|patch|delete)\(')"
    else
      rule "csrf" PASS "CSRF token or no state-changing route"
    fi
    ;;
  *)
    rule "csrf" PASS "not applicable to stack $STACK"
    ;;
esac

# 12. Server-side authorization for authenticated flows
if hits 'login|signin|sign-in|session|jwt|Bearer' >/dev/null 2>&1; then
  if hits 'requireAuth|authorize|isAuthenticated|getActiveUser|getScriptProperties|authMiddleware|can\(|policy|gate\.' >/dev/null 2>&1; then
    rule "authz-server-side" PASS "server-side identity/authorization check present"
  else
    rule "authz-server-side" WARN "authentication referenced with no server-side check found" "$(hits 'login|signin|sign-in|session|jwt|Bearer')"
  fi
else
  rule "authz-server-side" PASS "no authentication surface in app code"
fi

# 13. Row level security (Supabase) / rules (Firebase)
case "$STACK" in
  B)
    ddl="$(hits 'create table')"
    if [ -z "$ddl" ]; then
      rule "rls" PASS "no table DDL in the repo — RLS is enforced in the Supabase project"
    elif ! hits 'enable row level security' >/dev/null 2>&1; then
      rule "rls" FAIL "tables created without ENABLE ROW LEVEL SECURITY" "$ddl"
    elif ! hits 'policy ' >/dev/null 2>&1; then
      rule "rls" WARN "RLS enabled but no policy found — confirm the deny-by-default path" "$ddl"
    else
      rule "rls" PASS "RLS and policies present"
    fi
    ;;
  D)
    if [ ! -f "$APP/firestore.rules" ]; then
      rule "rls" FAIL "firestore.rules missing — Firestore defaults to deny, confirm and commit it"
    elif grep -qE 'allow[^:]*:[^;]*if[[:space:]]+true' "$APP/firestore.rules"; then
      rule "rls" FAIL "firestore.rules allows an open rule" "$(grep -nE 'allow[^:]*:[^;]*if[[:space:]]+true' "$APP/firestore.rules" | head -3)"
    else
      rule "rls" PASS "firestore.rules present without open rules"
    fi
    ;;
  *)
    rule "rls" PASS "not applicable to stack $STACK"
    ;;
esac

ev=""
if [ "${#CLIENT[@]}" -gt 0 ]; then
  ev="$(grep -nE 'http://' "${CLIENT[@]}" 2>/dev/null | grep -vE 'localhost|127\.0\.0\.1|w3\.org' | head -3)"
fi
if [ -n "$ev" ]; then
  rule "plaintext-transport" WARN "plain http:// endpoint in client code" "$ev"
else
  rule "plaintext-transport" PASS "no plaintext endpoint in client code"
fi

# 15. Error and debug leakage
ev="$(hits '(res\.(send|json)|Response\.json)\(\s*(err|error|e)\b|traceback\.format_exc|DEBUG[[:space:]]*=[[:space:]]*True|app\.run\([^)]*debug[[:space:]]*=[[:space:]]*True')"
if [ -n "$ev" ]; then
  rule "error-leak" WARN "error object or debug mode may reach the client" "$ev"
else
  rule "error-leak" PASS "no error/debug leak pattern"
fi

# 16. Secrets in logs
ev="$(hits '(console\.log|logger\.|print\(|log\.)[^)]*(password|passwd|token|secret|api_?key)')"
if [ -n "$ev" ]; then
  rule "secret-in-logs" WARN "secret-named value written to a log" "$ev"
else
  rule "secret-in-logs" PASS "no secret-named value logged"
fi

# 17. Open redirect
ev="$(hits '(redirect|next|return_url|returnUrl|goto|continue)[[:space:]]*\(?[^;]*(req\.|request\.|params|query|searchParams)')"
if [ -n "$ev" ]; then
  rule "open-redirect" WARN "request value flows into a redirect — confirm the allowlist" "$ev"
else
  rule "open-redirect" PASS "no request value in a redirect"
fi

# 18. Brute force protection on the login path
if hits '(login|signin|sign-in)' >/dev/null 2>&1; then
  if hits 'rateLimit|rate_limit|throttle|limiter|slowDown|lockout' >/dev/null 2>&1; then
    rule "brute-force" PASS "login path has a rate limit or lockout"
  else
    rule "brute-force" WARN "login path with no rate limit or lockout"
  fi
else
  rule "brute-force" PASS "no login path in app code"
fi

# 19. File upload validation
if hits 'upload|multipart|multer|FormData' >/dev/null 2>&1; then
  if hits 'mimetype|contentType|accept=|maxFileSize|fileSize|limits' >/dev/null 2>&1; then
    rule "upload-validation" PASS "upload path validates type or size"
  else
    rule "upload-validation" WARN "upload path with no type/size validation"
  fi
else
  rule "upload-validation" PASS "no upload path"
fi

# 20. Dependency audit (opt-in: needs the network)
if [ "$DEPS" -eq 1 ]; then
  if [ -f "$APP/package.json" ] && command -v npm >/dev/null 2>&1; then
    if [ -d "$APP/node_modules" ] || [ -f "$APP/package-lock.json" ]; then
      out="$(cd "$APP" && npm audit --omit=dev --audit-level=high 2>&1 | tail -5)"
      if printf '%s' "$out" | grep -qE 'found 0 vulnerabilities'; then
        rule "dependencies" PASS "npm audit: 0 high/critical vulnerabilities"
      elif printf '%s' "$out" | grep -qiE 'high|critical'; then
        rule "dependencies" FAIL "npm audit reports high/critical vulnerabilities" "$out"
      else
        rule "dependencies" WARN "npm audit did not report a clean tree" "$out"
      fi
    else
      rule "dependencies" WARN "no node_modules or lockfile — run npm install before auditing"
    fi
  else
    rule "dependencies" PASS "no Node dependency tree (or npm missing)"
  fi
fi

# 21. Threat model and previous findings
if [ -f "$PROJ/security/THREAT-MODEL.md" ]; then
  rule "threat-model" PASS "security/THREAT-MODEL.md present"
else
  rule "threat-model" WARN "security/THREAT-MODEL.md missing — write the trust boundaries first"
fi

mkdir -p "$OUTDIR"

RESULT=PASS
[ "$WARN" -gt 0 ] && RESULT=REVIEW
[ "$FAIL" -gt 0 ] && RESULT=FAIL

if [ "$JSON" -eq 0 ]; then
  echo
  echo "Result: $FAIL fail, $WARN warn, $PASS pass — $RESULT"
  case "$RESULT" in
    FAIL) echo "Gate: blocked. Fix every FAIL, then rerun." ;;
    REVIEW) echo "Gate: review required. Confirm or reject every WARN with a trace." ;;
    PASS) echo "Gate: pass. Record the audit in security/REPORT.md." ;;
  esac
fi

JSON_TOOLS=""
for row in "${ROWS[@]+"${ROWS[@]}"}"; do
  level="${row%%|*}"
  rest="${row#*|}"
  id="${rest%%|*}"
  rest="${rest#*|}"
  detail="${rest%%|*}"
  evidence="${rest#*|}"
  obj="$(printf '{"rule":"%s","level":"%s","detail":"%s","evidence":%s}' \
    "$(json_escape "$id")" "$level" "$(json_escape "$detail")" \
    "$(if [ -z "$evidence" ]; then printf 'null'; else printf '"%s"' "$(json_escape "$evidence")"; fi)")"
  if [ -z "$JSON_TOOLS" ]; then JSON_TOOLS="$obj"; else JSON_TOOLS="$JSON_TOOLS,$obj"; fi
done

REPORT="$(printf '{"slug":"%s","stack":"%s","result":"%s","counts":{"fail":%d,"warn":%d,"pass":%d},"rules":[%s]}' \
  "$(json_escape "$SLUG")" "$(json_escape "$STACK")" "$RESULT" "$FAIL" "$WARN" "$PASS" "$JSON_TOOLS")"

if [ "$JSON" -eq 1 ]; then
  printf '%s\n' "$REPORT"
else
  printf '\nSECURITY_JSON %s\n' "$REPORT"
fi

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
