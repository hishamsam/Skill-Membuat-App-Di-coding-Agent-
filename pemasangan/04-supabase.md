# 04 — Supabase

## MCP

Official URL: `https://mcp.supabase.com/mcp`

Scope the server with parameters:

| Parameter | Function |
| --- | --- |
| `project_ref=<id>` | Limit to a single project |
| `read_only=true` | Read queries only |
| `features=database,docs` | Limit the tool set |

### Register (OAuth)

```bash
opencode mcp add supabase --global \
  --url "https://mcp.supabase.com/mcp?project_ref=<ref>"
opencode mcp auth supabase
```

### Register (personal token)

```bash
# ~/.secrets/supabase-token — do not commit
opencode mcp add supabase --global \
  --url "https://mcp.supabase.com/mcp?project_ref=<ref>" \
  --header "Authorization=Bearer {file:~/.secrets/supabase-token}"
```

Give the token a project scope and minimum permissions.

Note: if the client does not parse `{file:...}` in headers, use OAuth
(`opencode mcp auth supabase`) or put the token directly in a private config
that is not committed.

## Project

1. Create a project at [supabase.com/dashboard](https://supabase.com/dashboard).
2. Copy:
   - `Project URL` (example `https://xxxx.supabase.co`)
   - `anon` / publishable key (safe for the client + RLS)
3. The `service_role` key is for the server **only**. Do not put it in the
   frontend.

## Schema & RLS

```text
projek/<slug>/app/supabase/migrations/0001_init.sql
projek/<slug>/app/supabase/migrations/0002_rls.sql
```

- Every table: `id`, `created_at`, `updated_at`, foreign keys.
- Enable RLS on ALL tables.
- Write policies per role; test negative cases.

```sql
alter table public.items enable row level security;

create policy "items_select_own"
on public.items for select
using (auth.uid() = owner_id);
```

## Local testing

This machine has NO Docker, so `supabase start` does not work.

**Path A (recommended):** Supabase dev project + anon key.
```bash
cd projek/<slug>/app && python3 -m http.server 4173
```

**Path B:** if Docker is installed later.
```bash
npx supabase@latest start
npx supabase@latest db reset
```

## Deploy

```bash
npx supabase@latest link --project-ref <ref>
npx supabase@latest db push
```

Frontend: Vercel / Cloudflare Pages. Set `SUPABASE_URL` and
`SUPABASE_ANON_KEY` in the build environment.

## Check

- Auth works (sign up, login, logout, session refresh).
- RLS: user A cannot see user B's data.
- No `service_role` in the frontend bundle.
