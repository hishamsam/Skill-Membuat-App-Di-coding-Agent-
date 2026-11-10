# Setup — MCP & Environment Installation

This folder collects all installation instructions. It is separate from
`workflow/` so the workflow stays clean.

## Layout

| File | Content |
| --- | --- |
| `01-opencode-mcp.md` | `opencode.json` format, register MCP, check status |
| `02-figcraft.md` | FigCraft live (required), port 7979, export |
| `03-gas.md` | Google Apps Script, clasp, preview mode |
| `04-supabase.md` | Supabase MCP, dev project, RLS |
| `05-cloudflare-worker.md` | Cloudflare MCP, wrangler, D1 |
| `06-firebase.md` | Firebase MCP, emulator, rules |
| `07-neon.md` | Neon MCP, serverless Postgres, API |
| `08-dokploy.md` | Dokploy for local testing (optional, requires permission) |
| `09-nextjs.md` | Next.js + Postgres, Vercel |
| `10-node-express.md` | Node/Express + Postgres, VPS/Dokploy |
| `11-laravel.md` | Laravel + MySQL, VPS/Dokploy |
| `12-python.md` | FastAPI/Django + Postgres, VPS/Dokploy |
| `13-flutter.md` | Flutter Web + Android/iOS, web testing |
| `mcp.opencode.example.json` | Copy to paste into `~/.config/opencode/opencode.json` |

## Recommended installation order

1. `bash scripts/preflight.sh --install` — check machine status.
2. `01-opencode-mcp.md` — basics.
3. `02-figcraft.md` — required for Phase 2.
4. Pick one stack: `03-gas.md`, `04-supabase.md`, `05-cloudflare-worker.md`,
   `06-firebase.md`, `07-neon.md`, `09-nextjs.md`, `10-node-express.md`,
   `11-laravel.md`, `12-python.md`, `13-flutter.md`.
5. Optional local testing: `08-dokploy.md` (ask for permission first).
6. Test with `bash scripts/test-local.sh <slug> --check`.

## Secret rules

- Do not commit tokens, service role keys, connection strings, or `.dev.vars`.
- Use `{file:~/.secrets/<name>}` in `opencode.json`, not raw tokens.
- `.gitignore` excludes `.env`, `.env.*` (except `.env.example`) and
  `.dev.vars` across the whole repo, including `projects/`.

## This machine — status summary

Tool versions and status are maintained in `GUIDE.md` §2 (Requirements) so
that there is no second, conflicting source.
