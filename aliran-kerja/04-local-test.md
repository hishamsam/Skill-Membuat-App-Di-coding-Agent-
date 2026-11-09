# Fasa 4 — Ujian Tempatan

Tujuan: buktikan app berjalan pada mesin ini sebelum deploy. Jangan lapor
"siap" tanpa bukti.

## Perintah utama

```bash
bash skrip/test-local.sh <slug>          # jalankan server tempatan
bash skrip/test-local.sh <slug> --check  # start, uji HTTP, stop
bash skrip/qa-check.sh <slug>            # semakan statik
```

Skrip membaca `projek/<slug>/STACK` yang ditulis oleh `skrip/new-project.sh`.

## Mengikut stack

### A — GAS

GAS tidak boleh dijalankan sepenuhnya di tempatan. Dua lapisan ujian:

1. **Mod pratonton (wajib):** `IS_PREVIEW = true` dengan data demo lengkap.
   ```bash
   cd projek/<slug>/app && python3 -m http.server 4173
   ```
   Buka `http://localhost:4173` dan uji semua skrin/aliran.
2. **Backend sebenar:** deploy ke Apps Script, kemudian uji endpoint.
   ```bash
   curl -L -X POST "<GAS_URL>" \
     -H "Content-Type: text/plain;charset=utf-8" \
     -d '{"action":"ping","data":{}}'
   ```
   Pilihan CLI: `npx @google/clasp push` (perlu login).

Lulus bila: aliran demo berfungsi, tiada ralat konsol, dan sekurang-kurangnya
satu panggilan backend sebenar berjaya.

### B — Supabase

Mesin ini TIADA Docker, jadi `supabase start` tidak boleh guna.

1. Guna projek dev Supabase (percuma) + kunci anon.
2. `public/index.html` + `python3 -m http.server 4173`.
3. Uji auth, RLS, CRUD melalui klien.
4. Uji RLS negatif: pengguna A tidak boleh baca data pengguna B.

Jika Docker dipasang kemudian:

```bash
npx supabase@latest start
npx supabase@latest db reset
```

### C — Cloudflare Worker

```bash
cd projek/<slug>/app
npx wrangler dev            # lalai http://localhost:8787
```

- Data D1 tempatan disimpan dalam `.wrangler/state`.
- Rahsia tempatan dalam `.dev.vars` (jangan commit).
- Uji `GET /api/health` (jika ada) dan sekurang-kurangnya satu CRUD.

### D — Firebase

Java 17 tersedia pada mesin ini.

```bash
cd projek/<slug>/app
npx firebase-tools emulators:start
```

- Sambung aplikasi ke emulator (`connectAuthEmulator`,
  `connectFirestoreEmulator`) dalam mod ujian sahaja.
- Uji rules: pengguna tanpa kebenaran mesti ditolak.
- Untuk ujian automatik: `npx firebase-tools emulators:exec "./tests/smoke.sh"`.

### E — Neon

Tiada `psql` pada mesin ini.

1. Uji API secara tempatan:
   ```bash
   cd projek/<slug>/app/api
   npx wrangler dev
   ```
   Connection string dalam `.dev.vars`.
2. Uji migrasi dengan skrip Node:
   ```bash
   cd projek/<slug>/app
   npm i @neondatabase/serverless
   node db/migrate.mjs
   ```
3. Jangan sekali-kali letak connection string dalam frontend.

### F — Hibrid

Jalankan setiap servis yang terlibat, kemudian uji aliran hujung ke hujung.
Contoh: `wrangler dev` (API) + `python3 -m http.server` (frontend).

## Senarai semak ujian (semua stack)

- [ ] Skrin login / skrin utama dibuka tanpa ralat konsol.
- [ ] Setiap butang dalam senarai PRD menghasilkan tindakan.
- [ ] CRUD berfungsi dengan data seed.
- [ ] Keadaan loading, empty, error boleh dicetuskan.
- [ ] Refresh halaman tidak log keluar paksa.
- [ ] Responsif disemak: 390, 768, 1024, 1440.
- [ ] Tiada scroll mendatar pada 360px.
- [ ] Tiada rahsia dalam `index.html` / bundle frontend.
- [ ] `qa-check.sh` lulus.
- [ ] Semua kes ujian PRD Bab 13.3 lulus.

## Cara semak responsif

1. Buka DevTools → Toggle device toolbar.
2. Uji 360×800, 390×844, 768×1024, 1024×768, 1440×900.
3. Periksa: tiada elemen terkeluar, teks tidak bertindih, nav tidak bertindih
   kandungan, modal tidak terpotong.

## Bila ujian gagal

1. Catat langkah reproduce + mesej ralat sebenar.
2. Betulkan punca, bukan gejala.
3. Jalankan semula ujian yang sama.
4. Jangan teruskan ke Fasa 5 selagi senarai semak belum lulus.
