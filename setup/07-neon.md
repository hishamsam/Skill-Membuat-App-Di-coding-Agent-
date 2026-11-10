# 07 — Neon (Serverless Postgres)

## MCP

Two ways:

```bash
# 1. Wizard (writes the config for detected agents)
npx neon@latest mcp

# 2. Remote MCP
opencode mcp add neon --global --url "https://mcp.neon.tech/mcp"
opencode mcp auth neon
```

With an API token:

```bash
opencode mcp add neon --global \
  --url "https://mcp.neon.tech/mcp" \
  --header "Authorization=Bearer {file:~/.secrets/neon-token}"
```

If `{file:...}` is not parsed by the client, use OAuth (`opencode mcp auth`) or
put the token directly in a private config (do not commit).

## Project

```bash
npx neonctl@latest auth
npx neonctl@latest projects list
npx neonctl@latest connection-string <project-id>
```

Keep the connection string in `.dev.vars` / server env. Do NOT put it in the
frontend.

## Architecture

The browser cannot talk to Postgres directly. Choose one:

| Path | When |
| --- | --- |
| Cloudflare Worker + `@neondatabase/serverless` | Edge API, Worker project |
| Vercel Function / Node API | Vercel frontend |
| Neon Data API (PostgREST + JWT) | Simple CRUD without your own API |

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

## Migrations

```text
projects/<slug>/app/db/migrations/0001_init.sql
```

A simple Node script (this machine has no `psql`):

```js
// db/migrate.mjs
import { neon } from "@neondatabase/serverless";
import { readFileSync } from "node:fs";

const sql = neon(process.env.DATABASE_URL);
const text = readFileSync(new URL("./migrations/0001_init.sql", import.meta.url), "utf8");
await sql.query(text);
console.log("migration complete");
```

```bash
cd projects/<slug>/app
npm i @neondatabase/serverless
DATABASE_URL="postgres://..." node db/migrate.mjs
```

## Local testing

```bash
cd projects/<slug>/app/api
npx wrangler dev            # API + Neon dev branch DB
```

Use Neon branches for `dev`, `staging`, `main`. Do not test on the production
branch.

## Deploy

- Deploy the API (Worker/Vercel), set `DATABASE_URL` as a secret.
- Run migrations on the production branch once only.
- Keep a copy of the schema in the repo.

## Limits

- Cold start if scale-to-zero is active.
- Connection pooling is needed for many connections.
- Auth is not part of Neon; choose Supabase Auth / Firebase Auth / your own.
