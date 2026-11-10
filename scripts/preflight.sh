#!/usr/bin/env bash
# Environment preflight for the WebApp Builder skill.
# Usage: bash scripts/preflight.sh [--install] [--json] [--stack A-K]
#
# Reads scripts/tools.tsv, reports every tool it selects, and with --install
# installs the missing ones that can be installed unattended. It never prompts
# for a sudo password, never upgrades an existing runtime, and never installs
# Docker, Flutter, or FigCraft by itself.
#
# Package column mapping: apt uses the apt column, dnf and zypper the dnf
# column, pacman and apk the pacman column, brew the brew column.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TSV="$ROOT/scripts/tools.tsv"

INSTALL=0
JSON=0
STACK=""

usage() {
  cat >&2 <<'EOF'
Usage: bash scripts/preflight.sh [--install] [--json] [--stack A-K]

  --install     Install missing tools that can be installed unattended.
  --json        Print only the JSON report on stdout.
  --stack CODE  Also check the tools of stack CODE (A-K).
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --install) INSTALL=1 ;;
    --json) JSON=1 ;;
    --stack) shift; [ "$#" -gt 0 ] || { usage; exit 1; }; STACK="$1" ;;
    --stack=*) STACK="${1#*=}" ;;
    --help|-h) usage; exit 0 ;;
    *) usage; exit 1 ;;
  esac
  shift
done

case "$STACK" in
  ""|A|B|C|D|E|F|G|H|I|J|K) ;;
  *) usage; exit 1 ;;
esac

UNAME_S="$(uname -s 2>/dev/null || echo unknown)"

# Git Bash, MSYS, and Cygwin delegate to the native Windows scanner.
case "$UNAME_S" in
  MINGW*|MSYS*|CYGWIN*)
    PS1="$ROOT/scripts/preflight.ps1"
    if command -v cygpath >/dev/null 2>&1; then
      PS1="$(cygpath -w "$PS1")"
    else
      PS1="${PS1//\//\\}"
    fi
    WINARGS=()
    [ "$INSTALL" -eq 1 ] && WINARGS+=("-Install")
    [ "$JSON" -eq 1 ] && WINARGS+=("-Json")
    [ -n "$STACK" ] && WINARGS+=("-Stack" "$STACK")
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PS1" ${WINARGS[@]+"${WINARGS[@]}"}
    exit $?
    ;;
esac

OS="unknown"
case "$UNAME_S" in
  Linux) OS="linux" ;;
  Darwin) OS="macos" ;;
esac

MANAGER="none"
MANAGER_BIN=""
for pair in "apt-get:apt" "dnf:dnf" "pacman:pacman" "zypper:zypper" "apk:apk" "brew:brew"; do
  bin="${pair%%:*}"
  if command -v "$bin" >/dev/null 2>&1; then
    MANAGER="${pair#*:}"
    MANAGER_BIN="$bin"
    break
  fi
done

DEBIAN_LIKE=0
if [ -r /etc/os-release ]; then
  case "$(cat /etc/os-release 2>/dev/null)" in
    *debian*) DEBIAN_LIKE=1 ;;
  esac
fi

json_escape() {
  printf '%s' "$1" | tr -d '\r' | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/	/\\t/g'
}

jstr() {
  if [ -z "${1:-}" ]; then
    printf 'null'
  else
    printf '"%s"' "$(json_escape "$1")"
  fi
}

trim() {
  local s="${1:-}"
  s="${s%$'\r'}"
  printf '%s' "$s" | sed -e 's/[[:space:]]*$//'
}

# Package list for the active manager, taken from the four package columns.
packages_for_manager() {
  case "$MANAGER" in
    apt) printf '%s' "$1" ;;
    dnf|zypper) printf '%s' "$2" ;;
    pacman|apk) printf '%s' "$3" ;;
    brew) printf '%s' "$4" ;;
    *) printf '' ;;
  esac
}

run_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
    return $?
  fi
  if command -v sudo >/dev/null 2>&1 && sudo -n true >/dev/null 2>&1; then
    sudo -n "$@"
    return $?
  fi
  return 75
}

sudo_prefix() {
  if [ "$(id -u)" -eq 0 ]; then
    printf ''
  else
    printf 'sudo '
  fi
}

install_command() { # packages
  local pkgs="$1"
  case "$MANAGER" in
    apt) printf '%sapt-get install -y --no-install-recommends %s' "$(sudo_prefix)" "$pkgs" ;;
    dnf) printf '%sdnf install -y %s' "$(sudo_prefix)" "$pkgs" ;;
    pacman) printf '%spacman -S --noconfirm --needed %s' "$(sudo_prefix)" "$pkgs" ;;
    zypper) printf '%szypper --non-interactive install %s' "$(sudo_prefix)" "$pkgs" ;;
    apk) printf '%sapk add --no-cache %s' "$(sudo_prefix)" "$pkgs" ;;
    brew) printf 'brew install %s' "$pkgs" ;;
    *) printf '' ;;
  esac
}

run_install() { # packages, stdout/stderr appended
  local pkgs="$1"
  case "$MANAGER" in
    apt)
      if [ "${APT_UPDATED:-0}" -eq 0 ]; then
        run_root apt-get update -qq
        APT_UPDATED=1
      fi
      run_root apt-get install -y --no-install-recommends $pkgs
      ;;
    dnf) run_root dnf install -y $pkgs ;;
    pacman) run_root pacman -S --noconfirm --needed $pkgs ;;
    zypper) run_root zypper --non-interactive install $pkgs ;;
    apk) run_root apk add --no-cache $pkgs ;;
    brew) brew install $pkgs ;;
    *) return 1 ;;
  esac
}

NODESOURCE_HINT="Node 20 or newer is required. On Debian/Ubuntu run: curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - ; sudo apt-get install -y nodejs"

# Row storage.
R_ID=(); R_TIER=(); R_CHECK=(); R_VARGS=(); R_HINT=()
R_PKGS=(); R_STATUS=(); R_VERSION=(); R_ACTION=(); R_RC=(); R_INSTALL_HINT=()
COUNT=0

if [ ! -r "$TSV" ]; then
  echo "preflight: cannot read scripts/tools.tsv" >&2
  exit 3
fi

while IFS='|' read -r id tier check vargs p_apt p_dnf p_pacman p_brew _p_winget hint; do
  [ -n "${id:-}" ] || continue
  case "$id" in \#*) continue ;; esac
  [ "$id" = "id" ] && continue
  case "$tier" in
    core|optional) ;;
    stack:*) [ "${tier#stack:}" = "$STACK" ] || continue ;;
    *) continue ;;
  esac
  R_ID[COUNT]="$id"
  R_TIER[COUNT]="$tier"
  R_CHECK[COUNT]="$check"
  R_VARGS[COUNT]="${vargs:-}"
  R_HINT[COUNT]="${hint:-}"
  R_PKGS[COUNT]="$(packages_for_manager "${p_apt:-}" "${p_dnf:-}" "${p_pacman:-}" "${p_brew:-}")"
  R_STATUS[COUNT]=""
  R_VERSION[COUNT]=""
  R_ACTION[COUNT]=""
  R_RC[COUNT]=""
  R_INSTALL_HINT[COUNT]=""
  COUNT=$((COUNT + 1))
done < "$TSV"

# determine <index> sets D_FOUND, D_VERSION, D_OUTDATED.
determine() {
  local i="$1" check="${R_CHECK[$1]}" vargs="${R_VARGS[$1]}"
  D_FOUND=0
  D_VERSION=""
  D_OUTDATED=0
  if [ "$check" = "__python_markdown__" ]; then
    if command -v python3 >/dev/null 2>&1 && python3 -c 'import markdown' >/dev/null 2>&1; then
      D_FOUND=1
      D_VERSION="importable"
    fi
    return 0
  fi
  command -v "$check" >/dev/null 2>&1 || return 0
  D_FOUND=1
  if [ -n "$vargs" ]; then
    D_VERSION="$(trim "$("$check" $vargs 2>&1 | head -1)")"
  fi
  if [ "$check" = "node" ]; then
    local major="${D_VERSION#v}"
    major="${major%%.*}"
    case "$major" in
      ''|*[!0-9]*) ;;
      *) [ "$major" -lt 20 ] && D_OUTDATED=1 ;;
    esac
  fi
  return 0
}

i=0
while [ "$i" -lt "$COUNT" ]; do
  determine "$i"
  R_VERSION[i]="$D_VERSION"
  if [ "$D_FOUND" -eq 1 ]; then
    if [ "$D_OUTDATED" -eq 1 ]; then
      R_STATUS[i]="outdated"
      R_HINT[i]="$NODESOURCE_HINT"
    else
      R_STATUS[i]="ok"
    fi
  else
    R_STATUS[i]="missing"
  fi
  i=$((i + 1))
done

INSTALL_ATTEMPTED=0
RESTART_REQUIRED=0
FAILED_INSTALL=0

if [ "$INSTALL" -eq 1 ]; then
  i=0
  while [ "$i" -lt "$COUNT" ]; do
    if [ "${R_STATUS[$i]}" = "missing" ]; then
      id="${R_ID[$i]}"
      pkgs="${R_PKGS[$i]}"
      cmd=""

      if [ "${R_TIER[$i]}" = "optional" ]; then
        if [ -n "$pkgs" ]; then
          R_ACTION[i]="$(install_command "$pkgs")"
        fi
        i=$((i + 1))
        continue
      fi

      if [ "$id" = "node" ] && [ "$MANAGER" = "apt" ] && [ "$DEBIAN_LIKE" -eq 1 ]; then
        if command -v curl >/dev/null 2>&1; then
          INSTALL_ATTEMPTED=1
          tmpfile="$(mktemp)"
          curl -fsSL https://deb.nodesource.com/setup_22.x -o "$tmpfile" || true
          out="$(run_root bash "$tmpfile" 2>&1)" && out="$(run_root apt-get install -y nodejs 2>&1)"
          rc=$?
          rm -f "$tmpfile"
          R_RC[i]="$rc"
          R_ACTION[i]="$(sudo_prefix)apt-get install -y nodejs"
          [ "$rc" -eq 0 ] || R_INSTALL_HINT[i]="$(printf '%s\n' "$out" | tail -1)"
        else
          R_STATUS[i]="manual"
          R_ACTION[i]="$(sudo_prefix)apt-get install -y curl"
          R_HINT[i]="curl is required for the NodeSource installer. Install curl first, then rerun preflight."
        fi
        i=$((i + 1))
        continue
      fi

      if [ -z "$pkgs" ] || [ "$MANAGER" = "none" ]; then
        R_STATUS[i]="manual"
        i=$((i + 1))
        continue
      fi

      INSTALL_ATTEMPTED=1
      R_ACTION[i]="$(install_command "$pkgs")"
      out="$(run_install "$pkgs" 2>&1)"
      rc=$?
      R_RC[i]="$rc"
      [ "$rc" -eq 0 ] || R_INSTALL_HINT[i]="$(printf '%s\n' "$out" | tail -1)"
    fi
    i=$((i + 1))
  done

  # Re-check every row that was attempted.
  i=0
  while [ "$i" -lt "$COUNT" ]; do
    rc="${R_RC[$i]:-}"
    if [ -n "$rc" ]; then
      determine "$i"
      R_VERSION[i]="$D_VERSION"
      case "$rc" in
        0)
          R_STATUS[i]="installed"
          if [ "$D_FOUND" -eq 0 ]; then
            RESTART_REQUIRED=1
            R_HINT[i]="Restart the agent session to pick up PATH changes."
          fi
          ;;
        75)
          R_STATUS[i]="manual"
          R_HINT[i]="Run this command in your own terminal, then rerun preflight."
          ;;
        *)
          FAILED_INSTALL=1
          R_STATUS[i]="failed"
          if [ -n "${R_INSTALL_HINT[$i]}" ]; then
            R_HINT[i]="${R_INSTALL_HINT[$i]}"
          fi
          ;;
      esac
    fi
    i=$((i + 1))
  done
fi

# Non-install checks, appended as tier "info".
INFO_JSON=""
add_info() { # id status hint action
  local obj
  obj="$(printf '{"id":"%s","tier":"info","check":%s,"status":"%s","version":null,"action":%s,"hint":%s}' \
    "$(json_escape "$1")" "$(jstr "$1")" "$2" "$(jstr "${4:-}")" "$(jstr "${3:-}")")"
  if [ -z "$INFO_JSON" ]; then INFO_JSON="$obj"; else INFO_JSON="$INFO_JSON,$obj"; fi
}

if ss -ltn 2>/dev/null | grep -q ':7979' || lsof -nP -iTCP:7979 -sTCP:LISTEN >/dev/null 2>&1; then
  add_info "figcraft-live" "ok" "" ""
else
  add_info "figcraft-live" "info" "Phase 2 needs live mode: figcraft --control 7979" ""
fi

if command -v opencode >/dev/null 2>&1; then
  if opencode mcp list 2>/dev/null | grep -qi figcraft; then
    add_info "mcp-figcraft" "ok" "" ""
  else
    add_info "mcp-figcraft" "info" "Register the FigCraft MCP servers (see setup/01-opencode-mcp.md)." ""
  fi
fi

if command -v curl >/dev/null 2>&1; then
  if curl -fsS -o /dev/null --max-time 2 http://localhost:3000/ >/dev/null 2>&1; then
    add_info "dokploy" "ok" "" ""
  else
    add_info "dokploy" "info" "" ""
  fi
fi

TOOLS_JSON=""
BLOCKING=""
PHASE1=1
i=0
while [ "$i" -lt "$COUNT" ]; do
  obj="$(printf '{"id":"%s","tier":"%s","check":"%s","status":"%s","version":%s,"action":%s,"hint":%s}' \
    "$(json_escape "${R_ID[$i]}")" "$(json_escape "${R_TIER[$i]}")" \
    "$(json_escape "${R_CHECK[$i]}")" "${R_STATUS[$i]}" \
    "$(jstr "${R_VERSION[$i]}")" "$(jstr "${R_ACTION[$i]}")" "$(jstr "${R_HINT[$i]}")")"
  if [ -z "$TOOLS_JSON" ]; then TOOLS_JSON="$obj"; else TOOLS_JSON="$TOOLS_JSON,$obj"; fi

  if [ "${R_TIER[$i]}" = "core" ]; then
    case "${R_STATUS[$i]}" in
      missing|manual|failed)
        case "${R_ID[$i]}" in
          figcraft|figcraft-cli) ;;
          *)
            PHASE1=0
            if [ -z "$BLOCKING" ]; then BLOCKING="${R_ID[$i]}"; else BLOCKING="$BLOCKING,${R_ID[$i]}"; fi
            ;;
        esac
        ;;
    esac
  fi
  i=$((i + 1))
done

if [ -n "$INFO_JSON" ]; then
  if [ -z "$TOOLS_JSON" ]; then TOOLS_JSON="$INFO_JSON"; else TOOLS_JSON="$TOOLS_JSON,$INFO_JSON"; fi
fi

figcraft_status() { # id -> prints status
  local i=0
  while [ "$i" -lt "$COUNT" ]; do
    if [ "${R_ID[$i]}" = "$1" ]; then
      printf '%s' "${R_STATUS[$i]}"
      return 0
    fi
    i=$((i + 1))
  done
  printf 'missing'
}

PHASE2=0
if [ "$PHASE1" -eq 1 ]; then
  PHASE2=1
  for id in figcraft figcraft-cli; do
    case "$(figcraft_status "$id")" in
      ok|installed) ;;
      *) PHASE2=0 ;;
    esac
  done
fi

bool() { if [ "$1" -eq 1 ]; then printf 'true'; else printf 'false'; fi; }

BLOCKING_JSON=""
if [ -n "$BLOCKING" ]; then
  saved_ifs="$IFS"
  IFS=','
  for b in $BLOCKING; do
    if [ -z "$BLOCKING_JSON" ]; then BLOCKING_JSON="\"$b\""; else BLOCKING_JSON="$BLOCKING_JSON,\"$b\""; fi
  done
  IFS="$saved_ifs"
fi

REPORT="$(printf '{"os":"%s","packageManager":"%s","installAttempted":%s,"ready":{"phase1":%s,"phase2":%s},"restartRequired":%s,"blocking":[%s],"tools":[%s]}' \
  "$OS" "$MANAGER" "$(bool "$INSTALL_ATTEMPTED")" "$(bool "$PHASE1")" "$(bool "$PHASE2")" \
  "$(bool "$RESTART_REQUIRED")" "$BLOCKING_JSON" "$TOOLS_JSON")"

if [ "$JSON" -eq 0 ]; then
  echo "Environment check — $OS ($MANAGER)"
  i=0
  while [ "$i" -lt "$COUNT" ]; do
    case "${R_STATUS[$i]}" in
      ok) label="OK" ;;
      missing) label="MISSING" ;;
      installed) label="INSTALLED" ;;
      manual) label="MANUAL" ;;
      outdated) label="OUTDATED" ;;
      failed) label="FAILED" ;;
      *) label="INFO" ;;
    esac
    if [ -n "${R_VERSION[$i]}" ]; then
      shown="${R_VERSION[$i]}"
      [ "${#shown}" -gt 72 ] && shown="${shown:0:69}..."
      printf '  %-9s %s %s\n' "$label" "${R_ID[$i]}" "$shown"
    else
      printf '  %-9s %s\n' "$label" "${R_ID[$i]}"
    fi
    if [ -n "${R_ACTION[$i]}" ] && [ "${R_STATUS[$i]}" != "ok" ]; then
      printf '            → %s\n' "${R_ACTION[$i]}"
    fi
    if [ -n "${R_HINT[$i]}" ] && [ "${R_STATUS[$i]}" != "ok" ]; then
      printf '            hint: %s\n' "${R_HINT[$i]}"
    fi
    i=$((i + 1))
  done

  if [ "$PHASE1" -eq 1 ] && [ "$PHASE2" -eq 1 ]; then
    echo "Result: Phase 1 ready, Phase 2 ready."
  elif [ "$PHASE1" -eq 1 ]; then
    echo "Result: Phase 1 ready, Phase 2 not ready (FigCraft)."
  else
    echo "Result: Phase 1 not ready (blocked: $BLOCKING)."
  fi
  echo "PREFLIGHT_JSON $REPORT"
else
  echo "$REPORT"
fi

if [ "$PHASE1" -eq 1 ]; then
  exit 0
elif [ "$FAILED_INSTALL" -eq 1 ]; then
  exit 2
fi
exit 3
