# 05 — Cloudflare Worker

## MCP

Cloudflare provides several remote servers. The useful ones here:

| Server | URL | Function |
| --- | --- | --- |
| Docs | `https://docs.mcp.cloudflare.com/mcp` | Search Workers documentation |
| Observability | `https://observability.mcp.cloudflare.com/mcp` | Logs, exceptions, production debugging |

```bash
opencode mcp add cloudflare-docs --global \
  --url "https://docs.mcp.cloudflare.com/mcp"

opencode mcp add cloudflare-observability --global \
  --url "https://observability.mcp.cloudflare.com/mcp"
```

If a server asks for auth, run `opencode mcp auth <name>` or register it again
with a Cloudflare token header.

## Installation

```bash
npx wrangler login
npx wrangler --version
```

No global installation is required; `npx wrangler` is enough.

## Project structure

```text
projek/<slug>/app/
├── public/            # static assets
├── src/index.js       # fetch handler / API
├── migrations/0001_init.sql
├── wrangler.jsonc
└── .dev.vars          # local secrets, do not commit
```

Basic `wrangler.jsonc`:

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

## Local testing

```bash
cd projek/<slug>/app
npx wrangler dev          # http://localhost:8787
```

- The local D1 database is stored in `.wrangler/state`.
- Local secrets are in `.dev.vars`.
- Run migrations:
  ```bash
  npx wrangler d1 execute {{SLUG}}-db --local --file=migrations/0001_init.sql
  ```

## Deploy

```bash
npx wrangler d1 execute {{SLUG}}-db --remote --file=migrations/0001_init.sql
npx wrangler secret put <SECRET_NAME>
npx wrangler deploy
```

## Secrets

- `.dev.vars` for local; `wrangler secret put` for production.
- Do not put tokens in `wrangler.jsonc`.
- Add `.dev.vars` to `.gitignore`.

## Limits

- D1 is not full Postgres; size and query limits.
- Workers have CPU time and bundle size limits.
- KV is eventually consistent.
