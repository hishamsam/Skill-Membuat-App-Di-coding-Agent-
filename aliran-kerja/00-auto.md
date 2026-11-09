# Fasa 0 — Mod Auto (One-Shot)

Mod auto membenarkan pengguna beri idea sekali, kemudian agent jalankan
Fasa 1–4 tanpa berhenti. Workflow tidak berubah; hanya gerbang kelulusan
dipermudah dan soalan temubual dilangkau.

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

> "Mod auto: Fasa 1–4, berhenti sebelum deploy. Andaian akan direkod."

Kemudian terus bekerja tanpa menunggu balasan.

## Prinsip

1. **Idea = kebenaran untuk Fasa 1–4.** Tiada soalan temubual satu-satu.
2. **Workflow sama.** PRD → FigCraft → kod → ujian. Tiada fasa dilangkau.
3. **Andaian mesti kelihatan.** Setiap lompang ditanda `[ANDAIAN]` dalam PRD
   Bab 5 dan disenaraikan dalam ringkasan akhir.
4. **Berhenti sebelum tindakan tidak boleh pulang.** Deploy production,
   pembayaran, DNS, padam data, dan kredensial production perlukan
   kebenaran berasingan.
5. **Bukti, bukan dakwaan.** Jangan lapor siap tanpa output `qa-check` dan
   `test-local`.
6. **Blocker dihadkan.** Jika sesuatu gagal, cuba betulkan maksimum 3 kali,
   kemudian berhenti dan lapor blocker sebenar.

## Langkah auto

### 1. Cipta projek

```bash
bash skrip/new-project.sh <slug> [A|B|C|D|E|F]
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

Jika dua pilihan hampir sama, pilih yang paling sedikit servis untuk dijaga.
Rekod pilihan dan alternatif ditolak dalam PRD Bab 6.

### 3. PRD auto

- Langkau Bahagian A dalam `TEMPLATE_PRD_MS.md`.
- Jawab A1–A10 dengan nilai lalai yang paling munasabah.
- Isi PRD 17 bab; tanda setiap andaian `[ANDAIAN]`.
- Perkara yang benar-benar tidak boleh diputuskan masuk Bab 16 (TBD).
- Simpan `prd/PRD-v0.1.md`.
- JANGAN berhenti untuk kelulusan; arahan auto dikira sebagai kelulusan
  untuk meneruskan Fasa 2–4.
- Tetap papar ringkasan PRD dalam laporan akhir.

### 4. FigCraft auto

- Jika port 7979 aktif, guna `figcraft-app` / skrip live.
- Jika tiada, guna MCP `figcraft` headless. Jangan gagal hanya kerana app
  tidak dibuka.
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
| PRD | Tunjuk, tunggu lulus | Jana, teruskan, lapor kemudian |
| FigCraft | Tunjuk, tunggu semakan | Bina, semak PNG sendiri, teruskan |
| Kod | Tunggu arahan | Teruskan |
| Ujian | Jalankan, lapor | Jalankan, betulkan, lapor |
| Deploy | Tunggu arahan | Berhenti sebelum deploy |
