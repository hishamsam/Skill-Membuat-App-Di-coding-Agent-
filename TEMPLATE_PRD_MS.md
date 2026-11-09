<!--
=====================================================================
TEMPLATE PRD + PENJANA PRD (PRD GENERATOR) — BAHASA MELAYU
=====================================================================
Fail ini ialah DUA perkara sekali gus:
1. PROTOKOL TEMUBUAL untuk mengumpul maklumat projek.
2. TEMPLAT PRD yang diisi selepas temubual.

ARAHAN UNTUK AI — BACA SEMUA SEBELUM MULA
---------------------------------------------------------------------
Anda ialah Product Manager + Solution Architect yang menyusun PRD.

INPUT:
- Idea kasar pengguna, nota mesyuarat, transkrip, atau dokumen sedia ada.
- Gambar rujukan UI (pilihan): screenshot, mockup Figma, imej Dribbble/Mobbin.

TUGAS:
1. Jalankan MODE TEMUBUAL (Bahagian A) sehingga cukup maklumat.
2. Isi SEMUA pemegang tempat {{...}} dalam Bahagian B.
3. Simpan hasil ke: projek/<slug>/prd/PRD-v0.1.md
   (rujuk aliran-kerja/01-prd.md untuk langkah folder).
4. Tunjuk PRD penuh, kemudian BERHENTI dan tunggu kelulusan pengguna.

PERATURAN KERAS:
- JANGAN reka fakta. Yang tidak diputuskan masuk Bab 16 (Soalan Terbuka).
- Andaian teknikal yang wajar: letak di Bab 5, tandakan "ANDAIAN".
- Satu soalan sahaja setiap mesej. Jangan banjirkan pengguna.
- Setiap soalan mesti ada pilihan A/B/C (+ "Nyatakan" ditambah automatik).
- Jika pengguna jawab beberapa soalan sekali gus, terima dan langkau yang sudah dijawab.
- JANGAN gabungkan soalan. Jangan tunjuk senarai A1–A10 sekali gus.
- Jawapan kabur: tanya soalan susulan dahulu sebelum pindah.
- Jika pengguna berkata "jana terus" / "auto", jelaskan bahawa temubual
  ringkas tetap perlu, kemudian teruskan satu soalan setiap mesej.

MOD AUTO (ONE-SHOT):
- Jika pengguna menulis "auto", "auto penuh", "buat semua", "siapkan terus",
  atau "one-shot", temubual Bahagian A TETAP WAJIB.
- Tanya satu soalan setiap mesej sehingga semua jawapan lengkap.
- Mod auto hanya membuang gerbang kelulusan selepas PRD: selepas soalan
  terakhir, jana PRD dan teruskan Fasa 2-4, kemudian lapor.
- Pilih stack daripada jawapan A6. Jika A6 tidak dijawab, syorkan satu dan
  minta pengesahan sebelum meneruskan.
- Isi semua 17 bab. Tanda [ANDAIAN] hanya untuk perkara yang pengguna
  sengaja serahkan kepada agent.
- Tetap papar ringkasan PRD dan senarai andaian dalam laporan akhir.
- Bahasa Melayu formal, ringkas, tanpa ayat pemasaran.
- Keperluan fungsian guna ID unik PREFIX-N (contoh: AUTH-1, TRX-2).
- Keutamaan hanya: **Wajib** / **Penting** / **Fasa 2**.
- Versi pertama sentiasa v0.1 (Draf Sementara).
- Komen arahan <!-- --> TIDAK boleh muncul dalam dokumen akhir.

KELULUSAN:
- Mod manual: selepas menunjuk PRD, tanya: "Terima PRD ini, atau ada pindaan?"
  Jangan tulis kod sehingga pengguna beri kelulusan jelas.
- Mod auto: PRD ditunjukkan dalam laporan akhir; teruskan Fasa 2-4.
=====================================================================
-->

# BAHAGIAN A — PROTOKOL TEMUBUAL (10 SOALAN)

Tanya mengikut urutan. Berhenti selepas SATU soalan. Tunggu jawapan.

## A1. Masalah & pengguna
"Siapa guna sistem ini, dan masalah apa yang hendak diselesaikan?"
- A. Staf dalaman syarikat (operasi harian)
- B. Pelanggan luar / awam
- C. Dua-dua: staf mengurus, pelanggan mengakses
- D. Pengguna khusus: pelajar / guru / ahli / pesakit (nyatakan)

## A2. Peranan & kebenaran
"Peranan apa yang perlu ada?"
- A. Admin sahaja
- B. Admin + pengguna biasa
- C. Admin + pengurus + pengguna
- D. Lebih daripada tiga (nyatakan)

## A3. Aliran kerja teras
"Apakah satu aliran utama dari mula hingga selesai?"
- A. Rekod dibuat → disemak → diluluskan → laporan
- B. Tempahan / pesanan → bayar → selesai
- C. Aduan / permohonan → tindakan → tutup
- D. Pendaftaran → pengesahan → akses kandungan
- E. Lain (nyatakan dalam satu ayat)

## A4. Data utama
"Apakah 3–5 entiti utama yang disimpan?"
- A. Pengguna, rekod transaksi, status, laporan
- B. Pengguna, produk/stok, pesanan, pembayaran
- C. Pengguna, permohonan, lampiran, komen
- D. Nyatakan senarai entiti sendiri

## A5. Skop MVP
"Apa yang wajib ada pada versi pertama?"
- A. Auth + CRUD + carian + laporan asas
- B. Auth + CRUD + kelulusan + notifikasi
- C. Auth + CRUD + pembayaran + resit
- D. Nyatakan senarai ciri MVP

## A6. TEKNOLOGI — SOALAN WAJIB
"Pilih teknologi backend/data. Pilih satu, atau lebih jika hibrid."

| Pilihan | Teknologi | Sesuai bila | Kos / had |
| --- | --- | --- | --- |
| **A** | **Google Apps Script (GAS) + Google Sheets** | Aplikasi dalaman, pengguna < 100, baris < ~10,000, sedia ada dalam Google Workspace | Percuma; kuota harian GAS; bukan DB sebenar |
| **B** | **Supabase** | Perlu Postgres, Auth, RLS, Storage, Realtime; SaaS sebenar | Free tier terhad; projek idle boleh pause |
| **C** | **Cloudflare Worker** (+ D1 / KV / R2) | API global, trafik tinggi, latensi rendah, static assets | Free tier harian; D1 had saiz; bukan Postgres penuh |
| **D** | **Firebase** (Firestore + Auth + Hosting) | Realtime sync, aplikasi mudah alih/web, auth pantas | Free tier; kos baca/tulis boleh naik; vendor lock-in |
| **E** | **Neon** (serverless Postgres) | Perlu Postgres sebenar, branching, scale-to-zero | Perlu lapisan API (Worker/Vercel); cold start |
| **F** | **Hibrid** | Contoh: frontend static + Neon + Worker API | Dua servis untuk dijaga |

Tanya juga: "Kenapa pilihan itu?" Jawapan masuk Bab 6.1.
Jika pengguna tiada pilihan, syorkan satu dan beri sebab dalam satu ayat.

## A7. Deployment & domain
"Di mana aplikasi akan dihosting?"
- A. Vercel (frontend static) + backend pilihan di A6
- B. Cloudflare Pages/Workers
- C. Firebase Hosting
- D. Google Apps Script Web App
- E. Belum pasti — cadangkan yang paling murah

## A8. Soalan susulan teknologi (bertanya mengikut pilihan A6 — MAKSIMUM 4)

### Jika A — GAS
1. Guna akaun Google Workspace atau akaun peribadi?
2. Anggaran baris data setahun? (< 1k / 1k–10k / > 10k)
3. Pengguna serentak pada waktu puncak?
4. Perlu muat naik fail (Google Drive) atau hantar e-mel (MailApp)?

### Jika B — Supabase
1. Kaedah log masuk: e-mel+kata laluan / magic link / Google OAuth?
2. Perlu Storage (gambar/dokumen) dan Realtime?
3. Peranan RLS: siapa boleh baca/tulis baris mana?
4. Ada Edge Function, atau logik di frontend + RLS sahaja?

### Jika C — Cloudflare Worker
1. Data di D1, KV, R2, atau Durable Object?
2. Perlu cron trigger / queue / webhook?
3. Static assets di Worker yang sama atau Cloudflare Pages?
4. Ada domain sendiri?

### Jika D — Firebase
1. Firestore atau Realtime Database?
2. Penyedia auth: e-mel, Google, telefon, atau anonymous?
3. Perlu Cloud Functions? (rantau?)
4. Perlu Storage untuk fail?

### Jika E — Neon
1. Neon jadi DB sahaja; API melalui Worker, Vercel Function, atau Neon Data API?
2. Auth diurus oleh siapa? (Supabase Auth / Firebase Auth / sendiri / tiada)
3. Perlu branching untuk dev/staging/prod?
4. Anggaran saiz DB dan trafik bulanan?

### Jika F — Hibrid
1. Lapisan mana buat apa? (frontend / API / DB / auth)
2. Servis mana yang memegang data utama?
3. Servis mana yang boleh gagal tanpa mematikan app?

## A9. Rujukan visual & peranti
"Ada gambar rujukan? Di mana failnya?"
- A. Tiada — pilih arah visual yang sesuai dengan domain
- B. Ada screenshot / mockup (letak dalam projek/<slug>/refs/)
- C. Ada URL aplikasi langsung
- D. Ada beberapa rujukan bercampur

Jika ada imej, tanya SATU soalan lanjut:
"Mod kesetiaan? A. Structural (lalai) B. Pixel-faithful C. Mood"
Dan: "Peranti utama? mobile / desktop / dua-dua"

## A10. Definisi siap & ujian
"Apakah yang mesti lulus sebelum app dianggap siap?"
- A. Semua skrin utama boleh dibuka, CRUD berfungsi, tiada ralat konsol
- B. A + auth berfungsi + data sebenar dari backend
- C. A + B + ujian responsif 390/768/1440 + deploy staging
- D. Nyatakan senarai semak sendiri

Selepas A10: jana PRD penuh (Bahagian B), simpan fail, tunjuk, tunggu kelulusan.

---

# BAHAGIAN B — TEMPLAT PRD

# PRODUCT REQUIREMENTS DOCUMENT (PRD)

## {{NAMA_PRODUK}}

**STATUS: {{STATUS_DOKUMEN}}**

| | |
| --- | --- |
| **Nama Produk** | {{NAMA_PRODUK_LENGKAP}} |
| **Versi Dokumen** | v0.1 |
| **Disediakan oleh** | {{NAMA_PENGEMBANG}} |
| **Untuk** | {{NAMA_KLIEN}} |
| **Tarikh** | {{TANGGAL_DOKUMEN}} |
| **Folder Projek** | `projek/{{SLUG}}/` |
| **Teknologi** | {{TEKNOLOGI_TERPILIH}} |
| **Dokumen Berkaitan** | {{DOKUMEN_TERKAIT}} |

---

# 1. Ringkasan Produk

<!-- 2 perenggan. P1: masalah semasa. P2: penyelesaian + modul utama + matlamat. -->

{{RINGKASAN_PRODUK}}

# 2. Tujuan & Sasaran

<!-- 4–6 bulet. Hasil perniagaan, bukan senarai ciri. -->

- {{TUJUAN_1}}
- {{TUJUAN_2}}
- {{TUJUAN_3}}

# 3. Pengguna & Peranan

<!-- Satu bulet setiap peranan: **Peranan :** hak dan aktiviti utama. -->

- **{{PERAN_1}} :** {{DESKRIPSI_PERAN_1}}
- **{{PERAN_2}} :** {{DESKRIPSI_PERAN_2}}

# 4. Skop

## 4.1 Termasuk (MVP)

- {{LINGKUP_MVP_1}}
- {{LINGKUP_MVP_2}}

## 4.2 Di Luar Skop Awal / Fasa Lanjutan

{{LINGKUP_DILUAR_MVP}}

# 5. Andaian & Kekangan

<!-- Sertakan: bajet, masa, bahasa, peranti, akaun/perkhidmatan sedia ada,
dan setiap ANDAIAN yang dibuat AI. Tandakan [ANDAIAN] dengan jelas. -->

- {{ASUMSI_1}}
- {{ASUMSI_2}}

# 6. Keputusan Teknologi (Tech Stack Decision)

<!-- WAJIB. Bahagian ini mengunci stack sebelum reka bentuk dan kod. -->

## 6.1 Pilihan & Justifikasi

| Lapisan | Teknologi | Sebab | Alternatif ditolak |
| --- | --- | --- | --- |
| Frontend | {{FE_TECH}} | {{FE_SEBAB}} | {{FE_ALT}} |
| Backend / API | {{BE_TECH}} | {{BE_SEBAB}} | {{BE_ALT}} |
| Pangkalan data | {{DB_TECH}} | {{DB_SEBAB}} | {{DB_ALT}} |
| Auth | {{AUTH_TECH}} | {{AUTH_SEBAB}} | {{AUTH_ALT}} |
| Hosting | {{HOST_TECH}} | {{HOST_SEBAB}} | {{HOST_ALT}} |

## 6.2 Perkhidmatan & Konfigurasi

| Perkara | Nilai |
| --- | --- |
| Projek / Region | {{PROJEK_REGION}} |
| Pemboleh ubah env | {{ENV_VARS}} |
| Rahsia server-side | {{SECRETS}} |
| Domain | {{DOMAIN}} |
| Mod tempatan | {{LOCAL_MODE}} |

**Peraturan rahsia:** kunci `service_role` / admin / DB URL TIDAK BOLEH masuk
ke fail frontend. Hanya kunci awam (anon/publishable) dibenarkan di klien.

## 6.3 Seni Bina Ringkas

```text
{{ALIRAN_ARKITEKTUR}}
```

# 7. Keperluan Fungsian

<!-- Kelompokkan ikut modul: 7.1, 7.2, ... Pola nama: "Aktor — Modul".
Jadual TEPAT seperti di bawah. Ayat keupayaan: "Admin boleh...", "Sistem memaparkan..." -->

## 7.1 {{NAMA_MODUL_1}}

| **ID** | **Keperluan Fungsian** | **Keutamaan** |
| --- | --- | --- |
| **{{PREFIX}}-1** | {{DESKRIPSI_KEBUTUHAN}} | **Wajib** |
| **{{PREFIX}}-2** | {{DESKRIPSI_KEBUTUHAN}} | **Penting** |

# 8. Aliran Pengguna Utama

<!-- 3–5 aliran. Langkah bernombor. Sertakan status sistem dalam petik. -->

## 8.1 {{NAMA_ALUR_1}}

1. {{LANGKAH_1}}
2. {{LANGKAH_2}}

# 9. Model Data

## 9.1 Entiti & Medan

| Entiti | Medan Utama | Keterangan |
| --- | --- | --- |
| **{{ENTITAS_1}}** | {{FIELD_UTAMA}} | {{KETERANGAN}} |

**Nota:** medan dalam [kurungan siku] ialah ciri Fasa Lanjutan (Bab 14).

## 9.2 Implementasi Fizikal

<!-- Pilih SATU blok mengikut Bab 6. Padam blok yang tidak digunakan. -->

**Jika GAS:**
- Sheet: `Users`, `{{SHEET_UTAMA}}`, `Pengaturan`
- Lajur tepat, jenis data, PK/FK, enum status.
- ID rekod = `timestamp + random`, bukan nombor baris.

**Jika Supabase / Neon (Postgres):**
- Skema SQL: `public.{{TABLE}}`
- Kunci utama, FK, `created_at`, `updated_at`.
- Polisi RLS per peranan (Supabase) atau peranan DB (Neon).
- Index untuk carian dan senarai.

**Jika Cloudflare Worker (D1):**
- Skema D1 (`migrations/0001_init.sql`), jenis SQLite.
- Binding: `DB`, `KV`, `BUCKET` (nyatakan yang digunakan).

**Jika Firebase:**
- Koleksi Firestore: `{{COLLECTION}}`
- Struktur dokumen, subkoleksi, index komposit.
- Peraturan keselamatan (`firestore.rules`) per peranan.

# 10. Keperluan Bukan Fungsian

<!-- Sertakan responsif, keselamatan, prestasi, privasi, dan had stack. -->

- **Responsif :** {{NFR_RESPONSIF}}
- **Keselamatan :** {{NFR_KESELAMATAN}}
- **Prestasi :** {{NFR_PRESTASI}}
- **Privasi :** {{NFR_PRIVASI}}
- **Had teknologi :** {{NFR_HAD}}

# 11. Integrasi Pihak Ketiga

| Perkhidmatan | Fungsi | Catatan |
| --- | --- | --- |
| **{{LAYANAN_1}}** | {{FUNGSI_1}} | {{CATATAN_1}} |

# 12. Kontrak UI & Handoff FigCraft

<!-- WAJIB. Bab ini ialah input terus untuk fasa reka bentuk FigCraft.
MCP FigCraft tidak boleh membaca teks PRD; manusia/AI yang akan membina.
Tulis cukup tepat supaya skrip design boleh dijana tanpa tanya semula. -->

## 12.1 Rujukan Imej

| Perkara | Nilai |
| --- | --- |
| Mod kesetiaan | `Tiada` / `Structural` / `Pixel-faithful` / `Mood` |
| Fail rujukan | `projek/{{SLUG}}/refs/{{NAMA_FAIL}}` |
| URL rujukan | {{URL_RUJUKAN}} |
| Peranti rujukan | Mobile / Desktop / Dua-dua |
| Apa diambil | {{APA_DIAMBIL}} |
| Apa diganti | {{APA_DIGANTI}} |
| Had undang-undang | Tiada logo/ilustrasi/foto berhak cipta disalin |

## 12.2 Design DNA

| Aspek | Nilai |
| --- | --- |
| Grid & container | {{DNA_GRID}} |
| Hierarki layout | {{DNA_LAYOUT}} |
| Tipografi | {{DNA_TIPOGRAFI}} |
| Palette | {{DNA_PALETTE}} |
| Spacing & radius | {{DNA_SPACING}} |
| Komponen | {{DNA_KOMPONEN}} |
| Density | {{DNA_DENSITY}} |
| Motion | {{DNA_MOTION}} |
| Signature app | {{SIGNATURE}} |

## 12.3 Peta Token

| Token | Nilai | Kegunaan |
| --- | --- | --- |
| `ink` | {{TOKEN_INK}} | Teks utama |
| `surface` | {{TOKEN_SURFACE}} | Latar kad |
| `line` | {{TOKEN_LINE}} | Sempadan |
| `accent` | {{TOKEN_ACCENT}} | Tindakan utama |

## 12.4 Senarai Skrin

<!-- Setiap skrin mesti ada 4 keadaan: default, loading, empty, error.
Viewport: Mobile 390×844 / Desktop 1440×900. -->

| ID | Skrin | Peranan | Isi utama | Keadaan | Viewport |
| --- | --- | --- | --- | --- | --- |
| `S-01` | {{NAMA_SKRIN_1}} | {{PERAN_SKRIN_1}} | {{ISI_SKRIN_1}} | default, loading, empty, error | 390 + 1440 |
| `S-02` | {{NAMA_SKRIN_2}} | {{PERAN_SKRIN_2}} | {{ISI_SKRIN_2}} | default, loading, empty, error | 390 + 1440 |

## 12.5 Navigasi & Responsif

- **Desktop (≥ 1024px):** {{NAV_DESKTOP}}
- **Tablet (768–1023px):** {{NAV_TABLET}}
- **Mobile (< 768px):** {{NAV_MOBILE}}
- **Peraturan:** reka bentuk mobile TIDAK bermakna kod mobile-only.
  Kod mesti responsif dari 360px hingga 1920px.
- **Touch target:** minimum 44×44px.
- **Larangan:** tiada dark mode, tiada scroll mendatar pada root.

# 13. Pelan Ujian Tempatan & Kriteria Terima

## 13.1 Perintah Tempatan

```bash
# diisi mengikut stack, contoh:
bash skrip/test-local.sh {{SLUG}}
```

## 13.2 Data Ujian

| Perkara | Nilai |
| --- | --- |
| Akaun demo | {{AKAUN_DEMO}} |
| Seed data | {{SEED_DATA}} |
| Mod pratonton | {{MOD_PRATONTON}} |

## 13.3 Kes Ujian

| ID | Skenario | Langkah | Jangkaan |
| --- | --- | --- | --- |
| `T-01` | {{SKENARIO_1}} | {{LANGKAH_UJIAN_1}} | {{JANGKAAN_1}} |
| `T-02` | {{SKENARIO_2}} | {{LANGKAH_UJIAN_2}} | {{JANGKAAN_2}} |

## 13.4 Kriteria Terima

- [ ] Semua skrin Bab 12.4 boleh dibuka tanpa ralat konsol.
- [ ] Semua keperluan **Wajib** Bab 7 lulus.
- [ ] CRUD berfungsi dengan data sebenar atau seed.
- [ ] Responsif disemak pada 390, 768, 1024, 1440.
- [ ] Tiada butang mati.
- [ ] Tiada rahsia dalam fail frontend.
- [ ] `bash skrip/qa-check.sh {{SLUG}}` lulus.

# 14. Ciri Cadangan / Fasa Lanjutan

- **{{FITUR_USULAN_1}}.** {{PENJELASAN_FITUR_1}}

# 15. Ciri Yang Ditolak (Out of Scope)

<!-- Senarai ciri yang sengaja tidak dibuat, supaya tidak dibangkitkan semula. -->

- {{DITOLAK_1}}

# 16. Soalan Terbuka / TBD

- {{PERTANYAAN_1}}
- {{PERTANYAAN_2}}

# 17. Glosarium

- **{{ISTILAH_1}} :** {{DEFINISI_1}}

---

*Dokumen ini ialah draf sementara dan boleh berubah selaras dengan perbincangan lanjut.*
