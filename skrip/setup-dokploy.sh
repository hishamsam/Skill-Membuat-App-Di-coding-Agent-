#!/usr/bin/env bash
# Pasang Dokploy untuk ujian local/dev — HANYA dengan kebenaran pengguna.
# Guna: bash skrip/setup-dokploy.sh [--check] [--yes]
#
# Tanpa --yes, skrip berhenti dan menunggu jawapan y/n. Jawapan selain y
# bermaksud langkau: ujian diteruskan secara manual.
set -uo pipefail

CHECK=0
ASSUME_YES=0

while [ $# -gt 0 ]; do
  case "$1" in
    --check) CHECK=1 ;;
    --yes) ASSUME_YES=1 ;;
    *) echo "Guna: bash skrip/setup-dokploy.sh [--check] [--yes]"; exit 1 ;;
  esac
  shift
done

installed() {
  curl -fsS -o /dev/null --max-time 3 http://localhost:3000/ 2>/dev/null \
    || docker service ls 2>/dev/null | grep -q dokploy
}

if [ "$CHECK" -eq 1 ]; then
  if installed; then
    echo "Dokploy: aktif di http://localhost:3000"
  else
    echo "Dokploy: tidak dikesan"
  fi
  exit 0
fi

if installed; then
  echo "Dokploy sudah aktif: http://localhost:3000"
  echo "Langkah seterusnya: buka URL itu, cipta admin, kemudian simpan"
  echo "DOKPLOY_URL dan DOKPLOY_API_KEY dalam environment (jangan commit)."
  exit 0
fi

cat <<'EOF'
Dokploy akan memasang:
  - Docker (jika belum ada)
  - Dokploy + Traefik, guna port 80, 443, dan 3000
  - Perlu Linux, akses root, dan mesin dev/VPS (bukan mesin produksi)

Ia mengubah sistem dan memuat turun skrip rasmi:
  https://dokploy.com/install.sh

Jika tidak mahu, skrip ini akan langkau dan ujian tempatan dibuat manual.
EOF

if [ "$ASSUME_YES" -ne 1 ]; then
  printf 'Teruskan pasang Dokploy? [y/N] '
  read -r answer || answer=""
  case "$answer" in
    y|Y|ya|YA|Ya) ;;
    *) echo "Dilangkau. Ujian manual: bash skrip/test-local.sh <slug> --check"
       exit 0 ;;
  esac
fi

if [ "$(uname -s)" != "Linux" ]; then
  echo "GAGAL: Dokploy hanya untuk Linux. Ujian manual sahaja."
  exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "GAGAL: pasang sebagai root. Jalankan:"
  echo "  sudo bash skrip/setup-dokploy.sh"
  exit 1
fi

for port in 80 443 3000; do
  if ss -ltn 2>/dev/null | grep -q ":$port "; then
    echo "GAGAL: port $port sedang digunakan. Hentikan servis itu dahulu."
    exit 1
  fi
done

echo "Memasang Dokploy..."
if curl -sSL https://dokploy.com/install.sh | sh; then
  echo
  echo "Dokploy dipasang. Buka http://localhost:3000 dan cipta akaun admin."
  echo "Selepas itu tetapkan DOKPLOY_URL dan DOKPLOY_API_KEY dalam environment."
  echo "Jangan simpan kunci dalam repo."
else
  echo "GAGAL: pemasangan Dokploy tidak selesai. Ujian manual sahaja."
  exit 1
fi
