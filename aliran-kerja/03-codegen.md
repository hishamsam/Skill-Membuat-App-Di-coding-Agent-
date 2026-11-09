# Fasa 3 — Penjanaan Kod Responsif

Tujuan: tukar PRD + skrin FigCraft menjadi aplikasi yang berfungsi, responsif,
dan selamat. Reka bentuk FigCraft ialah rujukan komposisi, bukan kunci lebar.

## Input

- `projek/<slug>/prd/PRD-v0.1.md` (Bab 6, 7, 9, 12, 13)
- `projek/<slug>/design/exports/*.png`
- `projek/<slug>/design/DESIGN-DNA.md`
- Stack dalam PRD Bab 6.

## Kontrak responsif (WAJIB)

Reka bentuk mobile dalam FigCraft TIDAK bermaksud kod mobile-only.
Kod mesti berfungsi dari 360px hingga 1920px.

| Julat | Sasaran | Navigasi | Grid kandungan |
| --- | --- | --- | --- |
| 360–639px | Telefon | Bottom nav 3–5 item | 1 kolum |
| 640–1023px | Tablet | Top bar ringkas / rail | 1–2 kolum |
| 1024–1439px | Laptop | Sidebar / top nav penuh | 2–3 kolum |
| ≥ 1440px | Desktop | Sama, container terhad | 3–4 kolum |

Peraturan keras:

- `viewport` meta ada.
- Tiada scroll mendatar pada `body` / root.
- Jadual: `overflow-x-auto` ATAU tukar jadi senarai kad di bawah `md`.
- Modal: `w-[calc(100%-2rem)] max-w-lg max-h-[85vh] overflow-y-auto`.
- Butang/input: tinggi minimum 44px, teks butang `whitespace-nowrap`.
- Navigasi mobile: bottom nav dengan padding selamat + `pb-24` pada `<main>`.
- Navigasi desktop: sidebar/top bar biasa; JANGAN papar bottom nav di desktop.
- Teks: `clamp()` atau kelas `text-sm md:text-base`; tiada teks terpotong.
- Reka bentuk mesti tunjuk desktop, bukan mobile yang diregang.

## Langkah

1. Jana jadual pelaksanaan daripada PRD:

   ```text
   | # | Keperluan PRD | Skrin | Fail | Status |
   |---|---------------|-------|------|--------|
   | 1 | AUTH-1        | S-01  | app  | [ ]    |
   ```

2. Ekstrak token dari `DESIGN-DNA.md` ke satu tempat:
   - Tailwind `tailwind.config` atau blok `:root` CSS variables.
   - Nama peranan (`ink`, `surface`, `line`, `accent`), bukan hex bertaburan.

3. Bina fail mengikut stack (lihat bawah).

4. Semak setiap butang ada `data-action` dan cabang logik sebenar.

5. Jalankan `bash skrip/qa-check.sh <slug>` sehingga lulus.

6. Kemas kini `STATUS.md`: Fasa 3 siap.

## Susunan fail mengikut stack

### A — GAS

```text
projek/<slug>/app/
├── index.html          # satu fail utuh: HTML + Tailwind CDN + JS
├── Code.gs             # router doPost, auth, LockService, batch sheet
└── appsscript.json     # timezone, webapp access
```

Ikut standard GAS dalam `SKILL.md` (batch `getValues`, `LockService`,
SHA-256 + salt, token HMAC, `setupDatabase()`).

### B — Supabase

```text
projek/<slug>/app/
├── public/index.html   # atau index.html satu fail
├── supabase/migrations/0001_init.sql
├── supabase/migrations/0002_rls.sql
└── .env.example        # SUPABASE_URL, SUPABASE_ANON_KEY
```

- Klien guna `@supabase/supabase-js` (CDN atau bundler).
- RLS WAJIB aktif untuk setiap jadual.
- `service_role` hanya dalam Edge Function / server; tidak pernah di klien.
- Auth: guna Supabase Auth, jangan bina semula hash password sendiri.

### C — Cloudflare Worker

```text
projek/<slug>/app/
├── public/             # static assets
├── src/index.js        # fetch handler / API
├── migrations/0001_init.sql
├── wrangler.jsonc
└── .dev.vars           # rahsia tempatan (jangan commit)
```

- Binding D1/KV/R2 ikut PRD Bab 9.2.
- `wrangler.jsonc` ada `assets.directory` untuk frontend static.
- Input disahkan di server; jangan percaya body mentah.

### D — Firebase

```text
projek/<slug>/app/
├── public/index.html
├── firebase.json
├── firestore.rules
└── firestore.indexes.json
```

- `firestore.rules` mengunci baca/tulis per peranan.
- Guna Firebase Auth; jangan simpan password sendiri.
- Emulator hanya untuk ujian; konfigurasi production dalam fail berasingan.

### E — Neon

```text
projek/<slug>/app/
├── public/index.html
├── api/src/index.js    # Worker / Vercel function
├── api/wrangler.jsonc
├── db/migrations/0001_init.sql
└── .dev.vars
```

- Browser TIDAK boleh sambung terus ke Neon dengan connection string.
- Semua query melalui API; sahkan sesi di API.
- Guna connection pooling / serverless driver.

### F — Hibrid

Gabung susunan di atas. Tulis dalam PRD Bab 6.3 lapisan mana buat apa.
Jangan ulang logik yang sama dalam dua servis.

### G — Next.js

```text
projek/<slug>/app/
├── app/
│   ├── layout.tsx
│   ├── page.tsx
│   └── api/...
├── components/
├── lib/
├── package.json
└── .env.example
```

- Server component untuk data; client component hanya untuk interaksi.
- Auth dan query DB di server, bukan dalam bundle klien.
- Jangan letak `DATABASE_URL` dalam `NEXT_PUBLIC_*`.

### H — Node/Express

```text
projek/<slug>/app/
├── src/index.js
├── src/routes/
├── src/db.js
├── public/             # frontend static jika ada
├── package.json
└── .env.example
```

- Validation dan auth di middleware server.
- Frontend static boleh dihidang oleh Express atau servis berasingan.

### I — Laravel

```text
projek/<slug>/app/
├── app/Http/Controllers/
├── app/Models/
├── routes/web.php
├── resources/views/
├── public/
├── composer.json
└── .env.example
```

- Guna Form Request untuk validation.
- Blade + Tailwind untuk UI; elak logik dalam view.
- Document root production mesti `public/`.

### J — FastAPI/Django

```text
projek/<slug>/app/
├── main.py / manage.py
├── app/                # FastAPI routers atau Django apps
├── templates/          # jika ada UI
├── requirements.txt
└── .env.example
```

- FastAPI: Pydantic untuk validation, dependency untuk auth.
- Django: form/model validation, template + Tailwind.
- Debug mesti mati di production.

## Peraturan kod (semua stack)

- Satu fail frontend yang boleh terus dijalankan; jangan pecah kepada
  "Bahagian 1/2".
- Tiada `TODO`, fungsi kosong, atau `console.log` sebagai pengganti logik.
- Tiada butang mati: setiap butang ada tindakan nyata.
- Setiap skrin ada keadaan loading / empty / error.
- Light mode sahaja. Tiada kelas `dark:`.
- Ikon satu pustaka (Lucide). Tiada emoji sebagai ikon.
- Borang: label, mesej ralat, dan fokus jelas.
- Jangan letak rahsia dalam fail frontend.
- Jangan reka endpoint atau URL deploy yang tidak wujud.

## Output

- Fail aplikasi dalam `projek/<slug>/app/`.
- Jadual pelaksanaan dikemas kini.
- Senarai fail + bilangan baris dilaporkan.
