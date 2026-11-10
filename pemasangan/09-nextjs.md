# 09 — Stack G: Next.js + Postgres

Suitable for: SSR, SEO, UI and API in a single project. Deploy with Vercel +
Neon/Supabase.

## Create a project

```bash
cd projek/<slug>/app
npx create-next-app@latest . --ts --tailwind --eslint --app --no-src-dir
```

Or if the folder is not empty, create it in a temporary folder then copy.

## Postgres

Choose one:

- Neon: create a project at `neon.tech`, copy `DATABASE_URL`.
- Supabase: create a project, copy the connection string.

```bash
# .env.local
DATABASE_URL="postgres://..."
NEXTAUTH_SECRET="..."
```

Do not commit `.env.local`.

## Local testing

```bash
cd projek/<slug>/app
npm install
npm run dev -- -p 4173
```

Or through the repo:

```bash
bash skrip/test-local.sh <slug> --check
```

## Deploy

1. Push to GitHub.
2. Import the repo in Vercel.
3. Set the env vars in Vercel.
4. Run the DB migration (Prisma/Drizzle) before the production deploy.

## Checks

- [ ] `npm run build` passes.
- [ ] Auth works on the server, not only on the client.
- [ ] No `DATABASE_URL` in the client bundle.
- [ ] Responsive 360–1920px.
- [ ] `qa-check.sh` passes.
