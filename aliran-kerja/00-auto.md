# Fasa 0 — Mod Auto (One-Shot)

Mod auto membenarkan pengguna beri idea sekali, kemudian agent jalankan
Fasa 1–4 tanpa gerbang kelulusan antara fasa. Workflow tidak berubah.
Temubual PRD tetap WAJIB dan mesti terperinci; mod auto hanya membuang
gerbang kelulusan selepas PRD.

## Cetus

Frasa yang membolehkan mod auto:

```text
auto
auto penuh
buat semua
siapkan terus
one-shot
```

Jika mesej pertama mengandungi frasa ini, agent mengesahkan dalam SATU baris:

> "Mod auto: temubual penuh, Fasa 1–4, berhenti sebelum deploy. Andaian akan direkod."

Kemudian mulakan temubual PRD: satu soalan setiap mesej. Selepas jawapan
lengkap, terus bekerja tanpa gerbang kelulusan antara fasa.

## Prinsip

1. **Idea = titik mula temubual.** Agent mesti tanya soalan terperinci satu
   demi satu sebelum menulis PRD.
2. **Temubual wajib.** Tiada langkauan walaupun pengguna menulis `auto`.
   Butiran tepat menghasilkan sistem yang lebih baik.
3. **Workflow sama.** PRD → FigCraft → kod → ujian. Tiada fasa dilangkau.
4. **Andaian mesti kelihatan.** Setiap lompang ditanda `[ANDAIAN]` dalam PRD
   Bab 5 dan disenaraikan dalam ringkasan akhir.
5. **Berhenti sebelum tindakan tidak boleh pulang.** Deploy production,
   pembayaran, DNS, padam data, dan kredensial production perlukan
   kebenaran berasingan.
6. **Bukti, bukan dakwaan.** Jangan lapor siap tanpa output `qa-check` dan
   `test-local`.
7. **Blocker dihadkan.** Jika sesuatu gagal, cuba betulkan maksimum 3 kali,
   kemudian berhenti dan lapor blocker sebenar.

## Langkah auto

### 1. Cipta projek

```bash
bash skrip/new-project.sh <slug> [A-J]
```

Slug dijana daripada idea. Jika stack tidak dinyatakan, pilih menggunakan
jadual di bawah dan rekod sebabnya.

### 2. Pilih stack

| Isyarat daripada idea | Stack |
| --- | --- |
| Alat dalaman, Google Workspace, data kecil, tiada auth kompleks | A GAS |
| Perlu auth + Postgres + RLS + Storage + realtime | B Supabase |
| API edge, trafik global, D1/KV/R2, static assets | C Worker |
| Realtime sync, auth pantas, hosting mudah | D Firebase |
| Postgres serverless, branching, API berasingan | E Neon |
| Dua keperluan jelas daripada senarai di atas | F Hibrid |
| SSR, SEO, UI + API dalam satu projek Next.js | G Next.js |
| API Node tersuai, deploy VPS/Dokploy | H Node/Express |
| PHP, admin panel, MySQL, VPS/Dokploy | I Laravel |
| API Python, admin Django atau FastAPI | J FastAPI/Django |

Jika dua pilihan hampir sama, pilih yang paling sedikit servis untuk dijaga.
Rekod pilihan dan alternatif ditolak dalam PRD Bab 6.

### 3. PRD auto

- Jalankan Bahagian A `TEMPLATE_PRD_MS.md`: satu soalan setiap mesej,
  termasuk soalan susulan A8. Jangan gabung atau langkau soalan.
- Gali jawapan kabur dengan soalan susulan sebelum pindah.
- Jawab A1–A10 berdasarkan jawapan sebenar pengguna, bukan nilai lalai.
- Tanda `[ANDAIAN]` hanya untuk perkara yang pengguna sengaja serahkan.
- Perkara yang benar-benar tidak boleh diputuskan masuk Bab 16 (TBD).
- Simpan `prd/PRD-v0.1.md`.
- Selepas jawapan lengkap, jana PRD dan teruskan Fasa 2–4 tanpa berhenti.
- Tetap papar ringkasan PRD dan senarai andaian dalam laporan akhir.

### 4. FigCraft auto

- FigCraft WAJIB guna mod **live edit**: `figcraft-app` / `figcraft-cli mcp
  --attach 7979`.
- Jika port 7979 tidak aktif, berhenti dan minta pengguna buka
  `figcraft --control 7979`. Jangan guna headless sebagai ganti.
- Baca PRD Bab 12 dan imej dalam `refs/` sendiri.
- Bina semua skrin dengan satu skrip.
- Eksport PNG dan semak imej. Betulkan sehingga tiada teks bertindih atau
  terpotong.
- Simpan `design/design.figcraft`.

### 5. Kod auto

- Ikut `aliran-kerja/03-codegen.md`.
- Responsif 360–1920px, walaupun rujukan mobile.
- Tiada butang mati, tiada placeholder, tiada rahsia dalam frontend.
- Semua skrin ada loading, empty, error.

### 6. Ujian auto

```bash
bash skrip/qa-check.sh <slug>
bash skrip/test-local.sh <slug> --check
```

- `qa-check` mesti 0 gagal.
- `test-local --check` mesti HTTP 200.
- Semak responsif pada 390 / 768 / 1024 / 1440 jika ada pelayar.
- Jika gagal: betulkan punca, ulang. Maksimum 3 pusingan.
- Jika masih gagal: simpan kerja, tulis blocker, berhenti.

### 7. Laporan akhir

Sebelum berhenti, laporkan:

| Perkara | Isi |
| --- | --- |
| Slug & stack | `projek/<slug>`, kod stack |
| PRD | pautan fail + 3 andaian utama |
| Reka bentuk | pautan `.figcraft` + bilangan PNG |
| Kod | senarai fail utama |
| Ujian | output ringkas `qa-check` + `test-local` |
| Blocker | apa yang menghalang, langkah seterusnya |
| Belum dibuat | deploy, akaun, domain |

## Had mod auto

Yang TIDAK boleh dilakukan tanpa input pengguna:

- Cipta akaun Google / Supabase / Cloudflare / Firebase / Neon.
- Log masuk CLI yang memerlukan pelayar.
- Masukkan kad pembayaran atau naik taraf pelan.
- Deploy production ke akaun pengguna.
- Tukar DNS atau domain.
- Padam data production.
- Meneka kredensial atau URL sebenar.
- Menjalankan ujian interaksi manusia sepenuhnya tanpa alat pelayar.

Jika salah satu diperlukan, berhenti dan tanya SATU soalan yang
menggabungkan semua keperluan, bukan satu soalan berulang.

## Mod `auto deploy`

Hanya jika pengguna menulis `auto deploy` DAN kredensial sudah wujud:

1. Jalankan Fasa 5.
2. Deploy staging dahulu jika ada.
3. Smoke test production.
4. Jangan cipta sumber berbayar baru tanpa kebenaran.
5. Jika login diperlukan, berhenti dan minta pengguna log masuk.

## Ringkasan gerbang

| Fasa | Mod manual | Mod auto |
| --- | --- | --- |
| PRD | Temubual penuh, tunjuk, tunggu lulus | Temubual penuh, jana, teruskan selepas jawapan lengkap |
| FigCraft | Tunjuk, tunggu semakan | Bina, semak PNG sendiri, teruskan |
| Kod | Tunggu arahan | Teruskan |
| Ujian | Jalankan, lapor | Jalankan, betulkan, lapor |
| Deploy | Tunggu arahan | Berhenti sebelum deploy |
