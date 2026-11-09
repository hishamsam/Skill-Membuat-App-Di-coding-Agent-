# Stack G — Next.js + Postgres

Sesuai: SSR, SEO, UI dan API dalam satu projek. Deploy Vercel + Neon/Supabase.

## Cipta projek

```bash
cd projek/<slug>/app
npx create-next-app@latest . --ts --tailwind --eslint --app --src-dir=false
```

Atau jika folder tidak kosong, cipta dalam folder sementara kemudian salin.

## Postgres

Pilih satu:

- Neon: cipta projek di `neon.tech`, salin `DATABASE_URL`.
- Supabase: cipta projek, salin connection string.

```bash
# .env.local
DATABASE_URL="postgres://..."
NEXTAUTH_SECRET="..."
```

Jangan commit `.env.local`.

## Ujian tempatan

```bash
cd projek/<slug>/app
npm install
npm run dev -- -p 4173
```

Atau melalui repo:

```bash
bash skrip/test-local.sh <slug> --check
```

## Deploy

1. Push ke GitHub.
2. Import repo di Vercel.
3. Tetapkan env var di Vercel.
4. Jalankan migrasi DB (Prisma/Drizzle) sebelum deploy production.

## Semakan

- [ ] `npm run build` lulus.
- [ ] Auth berfungsi di server, bukan hanya klien.
- [ ] Tiada `DATABASE_URL` dalam bundle klien.
- [ ] Responsif 360–1920px.
- [ ] `qa-check.sh` lulus.
