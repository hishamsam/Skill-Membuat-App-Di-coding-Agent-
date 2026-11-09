# Dokploy untuk Ujian Local (Pilihan)

Dokploy ialah platform deploy sendiri (self-hosted) yang guna Docker + Traefik.
Dalam repo ini, Dokploy digunakan sebagai persekitaran ujian local/dev
**hanya jika pengguna membenarkan**.

## Peraturan

1. Agent mesti minta kebenaran pengguna sebelum memasang Dokploy.
2. Jika pengguna menolak, **langkau** dan jalankan ujian manual:
   `bash skrip/test-local.sh <slug> --check`.
3. Jangan pasang Dokploy pada mesin produksi.
4. Jangan simpan `DOKPLOY_API_KEY` dalam repo.

## Semak status

```bash
bash skrip/setup-dokploy.sh --check
```

## Pasang dengan kebenaran

```bash
bash skrip/setup-dokploy.sh           # tanya y/N dahulu
sudo bash skrip/setup-dokploy.sh --yes  # lulus tanpa prompt, root diperlukan
```

Skrip memasang Docker jika tiada, kemudian menjalankan skrip rasmi:

```bash
curl -sSL https://dokploy.com/install.sh | sh
```

Keperluan:

- Linux (bukan container).
- Akses root.
- Port 80, 443, dan 3000 bebas.
- Mesin dev/VPS, bukan produksi.

Selepas pasang:

1. Buka `http://localhost:3000`.
2. Cipta akaun admin pertama.
3. Tetapkan environment (jangan commit):

```bash
export DOKPLOY_URL="http://localhost:3000"
export DOKPLOY_API_KEY="<kunci-dari-settings>"
```

4. Pilihan: daftar MCP Dokploy dalam `opencode.json`:

```json
{
  "mcp": {
    "dokploy": {
      "type": "local",
      "command": ["npx", "-y", "@dokploy/mcp"],
      "environment": {
        "DOKPLOY_URL": "http://localhost:3000",
        "DOKPLOY_API_KEY": "<kunci>"
      }
    }
  }
}
```

## Jika ditolak atau gagal

Tiada masalah. Ujian local berjalan tanpa Dokploy:

```bash
bash skrip/test-local.sh <slug> --check
bash skrip/qa-check.sh <slug>
```

Deploy production tetap berasingan dan memerlukan kebenaran.
