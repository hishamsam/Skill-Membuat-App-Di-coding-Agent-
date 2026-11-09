# Fasa 1 — Penjanaan PRD (TEMPLATE_PRD_MS.md)

Tujuan: tukar idea kasar + imej rujukan menjadi satu PRD yang mengunci
keperluan, teknologi, skrin, dan ujian. PRD ialah Single Source of Truth
untuk semua fasa selepas ini.

## Input

- Idea / nota mesyuarat / transkrip.
- Gambar rujukan (jika ada) — letak dalam `projek/<slug>/refs/`.
- Jawapan temubual 10 soalan dalam `TEMPLATE_PRD_MS.md`.

## Langkah

1. Cipta folder projek:

   ```bash
   bash skrip/new-project.sh <slug>
   ```

   Hasil:

   ```text
   projek/<slug>/
   ├── STATUS.md
   ├── prd/
   ├── refs/
   ├── design/exports/
   └── app/
   ```

2. Salin idea dan senarai imej ke dalam perbualan. Jika imej ada, buka dan
   baca imej itu dahulu (agent mesti nampak gambar, bukan teka).

3. Jalankan temubual mengikut `TEMPLATE_PRD_MS.md` Bahagian A:
   - SATU soalan per mesej. Jangan gabung soalan.
   - Setiap soalan ada pilihan A/B/C.
   - Gali jawapan kabur dengan soalan susulan sebelum pindah.
   - Soalan A6 (teknologi) WAJIB sebelum PRD ditulis.
   - Tanya semua soalan susulan A8 yang berkaitan.

4. Jana PRD penuh (Bahagian B) dan simpan:

   ```text
   projek/<slug>/prd/PRD-v0.1.md
   ```

5. Kemas kini `projek/<slug>/STATUS.md`:

   ```text
   - [x] Fasa 1 PRD
   - [ ] Fasa 2 FigCraft
   ```

   Jika PRD Bab 6 memilih stack berbeza daripada argumen `new-project.sh`,
   selaraskan fail `projek/<slug>/STACK` dengan stack akhir.

6. Tunjuk ringkasan PRD + soalan kelulusan. Berhenti.

## Pilihan teknologi (A6)

| Kod | Stack | Bila dipilih | Fasa 4 (ujian tempatan) |
| --- | --- | --- | --- |
| A | GAS + Google Sheets | Dalaman, data kecil, ekosistem Google | Mod pratonton + `python3 -m http.server` |
| B | Supabase | Postgres + Auth + RLS + Storage | Projek dev Supabase (Docker tiada di mesin ini) |
| C | Cloudflare Worker | API edge, D1/KV/R2, static assets | `npx wrangler dev` |
| D | Firebase | Firestore + Auth + Hosting, realtime | `firebase emulators:start` |
| E | Neon | Postgres serverless + API berasingan | Worker/Vercel function + `wrangler dev` |
| F | Hibrid | Gabungan dua servis atau lebih | Ikut servis yang dipilih |

Peraturan: pilih SATU stack utama. Hibrid hanya jika pengguna nyatakan
dengan jelas lapisan mana buat apa.

## Kualiti PRD

- Setiap keperluan fungsian ada ID dan keutamaan.
- Setiap skrin Bab 12.4 ada 4 keadaan (default/loading/empty/error).
- Bab 12 cukup terperinci untuk menjana skrip FigCraft tanpa tanya semula.
- Bab 13 ada perintah ujian dan kriteria terima yang boleh disemak.
- Tiada andaian tersembunyi: semua andaian ditanda `[ANDAIAN]` dalam Bab 5.
- Tiada placeholder `{{...}}` tertinggal dalam fail akhir.

## Semakan pantas sebelum kelulusan

```bash
grep -n "{{" projek/<slug>/prd/PRD-v0.1.md
```

Keluaran kosong = tiada placeholder tertinggal.

## Gerbang kelulusan

Selepas PRD ditunjuk:

> "Terima PRD ini, atau ada pindaan? Jika terima, balas 'lulus' dan saya
> teruskan ke Fasa 2 (reka bentuk FigCraft)."

Jangan mula Fasa 2 tanpa kelulusan jelas.
