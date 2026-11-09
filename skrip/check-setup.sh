#!/usr/bin/env bash
# Semak persekitaran sebelum mula projek.
# Guna: bash skrip/check-setup.sh
set -uo pipefail

ok()   { echo "  OK      $1"; }
warn() { echo "  AMARAN  $1"; }

echo "Persekitaran mesin"

if command -v node >/dev/null 2>&1; then ok "node $(node -v)"; else warn "node tiada"; fi
if command -v npm >/dev/null 2>&1; then ok "npm $(npm -v)"; else warn "npm tiada"; fi
if command -v python3 >/dev/null 2>&1; then ok "python3 $(python3 -V 2>&1 | cut -d' ' -f2)"; else warn "python3 tiada"; fi
if command -v java >/dev/null 2>&1; then ok "java $(java -version 2>&1 | head -1)"; else warn "java tiada (emulator Firebase perlu)"; fi

echo
echo "FigCraft"

if command -v figcraft-cli >/dev/null 2>&1; then
  ok "figcraft-cli $(figcraft-cli --version 2>&1 | head -1)"
else
  warn "figcraft-cli tiada dalam PATH"
fi

if ss -ltnp 2>/dev/null | grep -q ':7979'; then
  ok "port 7979 aktif (live mode)"
else
  warn "port 7979 tidak aktif. Jalankan: figcraft --control 7979 &"
fi

echo
echo "MCP"

if command -v opencode >/dev/null 2>&1; then
  if opencode mcp list 2>/dev/null | grep -qi figcraft; then
    ok "server figcraft didaftar"
  else
    warn "server figcraft tidak dijumpai dalam 'opencode mcp list'"
  fi
else
  warn "opencode CLI tiada"
fi

echo
echo "Pilihan stack"

command -v docker >/dev/null 2>&1 && ok "docker ada" || warn "docker tiada (Supabase local stack tidak boleh guna)"
command -v psql >/dev/null 2>&1 && ok "psql ada" || warn "psql tiada (Neon guna klien Node)"

echo
echo "Selesai. Amaran bukan penghalang; ikut pemasangan/ untuk penyelesaian."
