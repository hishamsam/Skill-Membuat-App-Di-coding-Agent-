# 05 — Cloudflare Worker

## MCP

Cloudflare menyediakan beberapa server remote. Yang berguna di sini:

| Server | URL | Fungsi |
| --- | --- | --- |
| Docs | `https://docs.mcp.cloudflare.com/mcp` | Cari dokumentasi Workers |
| Observability | `https://observability.mcp.cloudflare.com/mcp` | Log, exception, debug production |

```bash
opencode mcp add cloudflare-docs --global \
  --url "https://docs.mcp.cloudflare.com/mcp"

opencode mcp add cloudflare-observability --global \
  --url "https://observability.mcp.cloudflare.com/mcp"
```

Jika server meminta auth, jalankan `opencode mcp auth <nama>` atau daftar
semula dengan header token Cloudflare.

## Pemasangan

```bash
npx wrangler login
npx wrangler --version
```

Tiada pemasangan global diperlukan; `npx wrangler` mencukupi.

## Struktur projek

```text
projek/<slug>/app/
├── public/            # static assets
├── src/index.js       # fetch handler / API
├── migrations/0001_init.sql
├── wrangler.jsonc
└── .dev.vars          # rahsia tempatan, jangan commit
```

`wrangler.jsonc` asas:

```jsonc
{
  "name": "{{SLUG}}",
  "main": "src/index.js",
  "compatibility_date": "2026-01-01",
  "assets": {
    "directory": "./public",
    "binding": "ASSETS",
    "html_handling": "auto-trailing-slash",
    "not_found_handling": "single-page-application"
  },
  "d1_databases": [
    {
      "binding": "DB",
      "database_name": "{{SLUG}}-db",
      "database_id": "<id>"
    }
  ]
}
```

## Ujian tempatan

```bash
cd projek/<slug>/app
npx wrangler dev          # http://localhost:8787
```

- D1 tempatan disimpan dalam `.wrangler/state`.
- Rahsia tempatan dalam `.dev.vars`.
- Jalankan migrasi:
  ```bash
  npx wrangler d1 execute {{SLUG}}-db --local --file=migrations/0001_init.sql
  ```

## Deploy

```bash
npx wrangler d1 execute {{SLUG}}-db --remote --file=migrations/0001_init.sql
npx wrangler secret put <NAMA_RAHSIA>
npx wrangler deploy
```

## Rahsia

- `.dev.vars` untuk tempatan; `wrangler secret put` untuk production.
- Jangan letak token dalam `wrangler.jsonc`.
- Tambah `.dev.vars` ke `.gitignore`.

## Had

- D1 bukan Postgres penuh; had saiz dan query.
- Worker ada had CPU masa dan saiz bundle.
- KV bersifat eventually consistent.
