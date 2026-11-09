# Setup — Pemasangan MCP & Persekitaran

Folder ini mengumpul semua arahan pemasangan. Ia berasingan daripada
`aliran-kerja/` supaya aliran kerja kekal bersih.

## Susunan

| Fail | Isi |
| --- | --- |
| `01-opencode-mcp.md` | Format `opencode.json`, daftar MCP, semak status |
| `02-figcraft.md` | FigCraft headless + live, port 7979, eksport |
| `03-gas.md` | Google Apps Script, clasp, mod pratonton |
| `04-supabase.md` | MCP Supabase, projek dev, RLS |
| `05-cloudflare-worker.md` | MCP Cloudflare, wrangler, D1 |
| `06-firebase.md` | MCP Firebase, emulator, rules |
| `07-neon.md` | MCP Neon, Postgres serverless, API |
| `mcp.opencode.example.json` | Salinan tampal ke `~/.config/opencode/opencode.json` |

## Urutan pemasangan disyorkan

1. `bash skrip/check-setup.sh` — semak status mesin.
2. `01-opencode-mcp.md` — asas.
2. `02-figcraft.md` — wajib untuk Fasa 2.
3. Pilih satu: `03-gas.md`, `04-supabase.md`, `05-cloudflare-worker.md`,
   `06-firebase.md`, `07-neon.md`.
4. Uji dengan `bash skrip/test-local.sh <slug> --check`.

## Peraturan rahsia

- Jangan commit token, service role key, connection string, atau `.dev.vars`.
- Guna `{file:~/.secrets/<nama>}` dalam `opencode.json`, bukan token mentah.
- `.gitignore` sudah mengecualikan `projek/*/app/.env*` dan `.dev.vars`.

## Mesin ini — status ringkas

| Alat | Status |
| --- | --- |
| Node / npm | v24.22.1 / 11.19.1 |
| Python | 3.12.3 |
| FigCraft CLI | `/usr/bin/figcraft-cli` (0.16.0) |
| Java | OpenJDK 17 (emulator Firebase boleh guna) |
| Docker | TIADA — Supabase local stack tidak boleh guna |
| psql | TIADA — guna klien Node untuk Neon |
| Supabase / Neon / Firebase / Wrangler CLI | Belum dipasang; guna `npx` |
