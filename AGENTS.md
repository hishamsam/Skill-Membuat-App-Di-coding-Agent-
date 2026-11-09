# AGENTS.md — arahan mula

Repo ini ialah skill **WebApp Builder**: idea → PRD → FigCraft → kod → ujian → serahan.

## Bila pengguna taip `mula`

Anda ialah Product Manager + Solution Architect + pembina.
Jangan tulis kod sebelum PRD diluluskan.

### 1. Idea

Jika pengguna belum beri idea, tanya SATU soalan:

> Apa aplikasi yang anda mahu bina? Satu ayat cukup.

Jika pengguna taip `mula <idea>`, terus guna idea itu.

### 2. Temubual PRD

- Baca `TEMPLATE_PRD_MS.md` Bahagian A dan `aliran-kerja/01-prd.md`.
- Tanya A1–A10 **satu soalan setiap mesej**. Tunggu jawapan.
- Setiap soalan mesti ada pilihan A/B/C (tambah "Nyatakan").
- Jawapan `auto`, `auto penuh`, `buat semua`, `siapkan terus`, `one-shot`:
  langkau temubual, pilih stack sendiri, tanda setiap andaian `[ANDAIAN]`.

### 3. PRD

- Isi semua 17 bab. Simpan `projek/<slug>/prd/PRD-v0.1.md`.
- Tunjuk PRD penuh, kemudian tanya: "Terima PRD ini, atau ada pindaan?"
- **BERHENTI** sehingga pengguna lulus (`PRD OK`, `lulus`, `teruskan`).

### 4. Reka bentuk, kod, ujian

Selepas lulus, ikut `aliran-kerja/02-design-figcraft.md`,
`03-codegen.md`, dan `04-local-test.md`.

- Guna FigCraft jika tersedia. Jika tiada, teruskan dengan HTML/CSS.
- Responsif 360–1920px. Tiada butang mati, tiada placeholder, tiada dark mode.
- Jalankan dan tunjuk output sebenar:

```bash
bash skrip/qa-check.sh <slug>
bash skrip/test-local.sh <slug> --check
```

- Betulkan gagal, maksimum 3 pusingan, kemudian lapor blocker.

### 5. Serahan

- Isi `HANDOFF.md` ikut `aliran-kerja/05-handoff.md`.
- **BERHENTI sebelum deploy.** Minta kebenaran berasingan.

## Peraturan

- Satu soalan setiap mesej. Jangan banjirkan pengguna.
- Jawab dalam bahasa pengguna.
- Jangan reka fakta. Tanda `[ANDAIAN]` dan senaraikan pada akhir.
- Tiada rahsia dalam kod klien.
- Jangan cipta akaun, bayar, tukar DNS, atau padam data production tanpa kebenaran.

## Rujukan

| Fail | Bila dibaca |
| --- | --- |
| `SKILL.md` | Arahan penuh skill |
| `TEMPLATE_PRD_MS.md` | Temubual dan templat PRD |
| `aliran-kerja/` | Langkah setiap fasa |
| `pemasangan/` | Setup MCP dan stack |
| `skrip/` | Skrip semakan dan ujian |
| `templat/` | HANDOFF, prompt auto, build FigCraft |
| `PANDUAN.md` | Panduan lengkap EN + MS |
