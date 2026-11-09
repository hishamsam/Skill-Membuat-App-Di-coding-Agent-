# 07 — Neon (Serverless Postgres)

## MCP

Dua cara:

```bash
# 1. Wizard (tulis config untuk agent yang dikesan)
npx neon@latest mcp

# 2. Remote MCP
opencode mcp add neon --global --url "https://mcp.neon.tech/mcp"
opencode mcp auth neon
```

Dengan token API:

```bash
opencode mcp add neon --global \
  --url "https://mcp.neon.tech/mcp" \
  --header "Authorization=Bearer {file:~/.secrets/neon-token}"
```

Jika `{file:...}` tidak dihurai oleh klien, guna OAuth (`opencode mcp auth`)
atau letak token terus dalam config peribadi (jangan commit).

## Projek

```bash
npx neonctl@latest auth
npx neonctl@latest projects list
npx neonctl@latest connection-string <project-id>
```

Simpan connection string dalam `.dev.vars` / env server. JANGAN letak dalam
frontend.

## Seni bina

Browser tidak boleh bercakap terus dengan Postgres. Pilih satu:

| Laluan | Bila |
| --- | --- |
| Cloudflare Worker + `@neondatabase/serverless` | API edge, projek Worker |
| Vercel Function / Node API | Frontend Vercel |
| Neon Data API (PostgREST + JWT) | CRUD ringkas tanpa API sendiri |

```js
// api/src/index.js (Worker)
import { neon } from "@neondatabase/serverless";

export default {
  async fetch(request, env) {
    const sql = neon(env.DATABASE_URL);
    const rows = await sql`select id, name from items order by id desc limit 50`;
    return Response.json(rows);
  }
};
```

## Migrasi

```text
projek/<slug>/app/db/migrations/0001_init.sql
```

Skrip Node ringkas (tiada `psql` pada mesin ini):

```js
// db/migrate.mjs
import { neon } from "@neondatabase/serverless";
import { readFileSync } from "node:fs";

const sql = neon(process.env.DATABASE_URL);
const text = readFileSync(new URL("./migrations/0001_init.sql", import.meta.url), "utf8");
await sql.query(text);
console.log("migrasi selesai");
```

```bash
cd projek/<slug>/app
npm i @neondatabase/serverless
DATABASE_URL="postgres://..." node db/migrate.mjs
```

## Ujian tempatan

```bash
cd projek/<slug>/app/api
npx wrangler dev            # API + DB Neon dev branch
```

Guna branch Neon untuk `dev`, `staging`, `main`. Jangan uji pada branch
production.

## Deploy

- Deploy API (Worker/Vercel), tetapkan `DATABASE_URL` sebagai rahsia.
- Jalankan migrasi pada branch production sekali sahaja.
- Simpan salinan skema dalam repo.

## Had

- Cold start jika scale-to-zero aktif.
- Perlu connection pooling untuk sambungan banyak.
- Auth bukan sebahagian Neon; pilih Supabase Auth / Firebase Auth / sendiri.
