# 04 — Supabase

## MCP

URL rasmi: `https://mcp.supabase.com/mcp`

Skop server dengan parameter:

| Parameter | Fungsi |
| --- | --- |
| `project_ref=<id>` | Hadkan kepada satu projek |
| `read_only=true` | Hanya query baca |
| `features=database,docs` | Hadkan kumpulan tool |

### Daftar (OAuth)

```bash
opencode mcp add supabase --global \
  --url "https://mcp.supabase.com/mcp?project_ref=<ref>"
opencode mcp auth supabase
```

### Daftar (token peribadi)

```bash
# ~/.secrets/supabase-token — jangan commit
opencode mcp add supabase --global \
  --url "https://mcp.supabase.com/mcp?project_ref=<ref>" \
  --header "Authorization=Bearer {file:~/.secrets/supabase-token}"
```

Beri token skop projek dan kebenaran minimum.

Nota: jika klien tidak menghurai `{file:...}` dalam header, guna OAuth
(`opencode mcp auth supabase`) atau letak token terus dalam config peribadi
yang tidak di-commit.

## Projek

1. Cipta projek di [supabase.com/dashboard](https://supabase.com/dashboard).
2. Salin:
   - `Project URL` (contoh `https://xxxx.supabase.co`)
   - `anon` / publishable key (selamat untuk klien + RLS)
3. `service_role` key **hanya** untuk server. Jangan letak dalam frontend.

## Schema & RLS

```text
projek/<slug>/app/supabase/migrations/0001_init.sql
projek/<slug>/app/supabase/migrations/0002_rls.sql
```

- Setiap jadual: `id`, `created_at`, `updated_at`, kunci asing.
- Aktifkan RLS pada SEMUA jadual.
- Tulis polisi per peranan; uji kes negatif.

```sql
alter table public.items enable row level security;

create policy "items_select_own"
on public.items for select
using (auth.uid() = owner_id);
```

## Ujian tempatan

Mesin ini TIADA Docker, jadi `supabase start` tidak berfungsi.

**Laluan A (disyorkan):** projek dev Supabase + kunci anon.
```bash
cd projek/<slug>/app && python3 -m http.server 4173
```

**Laluan B:** jika Docker dipasang kemudian.
```bash
npx supabase@latest start
npx supabase@latest db reset
```

## Deploy

```bash
npx supabase@latest link --project-ref <ref>
npx supabase@latest db push
```

Frontend: Vercel / Cloudflare Pages. Tetapkan `SUPABASE_URL` dan
`SUPABASE_ANON_KEY` pada persekitaran binaan.

## Semak

- Auth berfungsi (daftar, login, logout, refresh sesi).
- RLS: pengguna A tidak nampak data pengguna B.
- Tiada `service_role` dalam bundle frontend.
