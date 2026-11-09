# WebApp Builder — PRD → FigCraft → Kod → Ujian → Serahan

Satu aliran kerja untuk membina aplikasi daripada idea kasar:

```text
Idea + imej rujukan
   ↓  Fasa 1  TEMPLATE_PRD_MS.md
PRD (Single Source of Truth)
   ↓  Fasa 2  FigCraft live MCP
Reka bentuk + eksport PNG
   ↓  Fasa 3  kod responsif
Aplikasi
   ↓  Fasa 4  ujian tempatan
   ↓  Fasa 5  HANDOFF + deploy
Siap
```

Backend boleh GAS, Supabase, Cloudflare Worker, Firebase, atau Neon.
Frontend kekal satu aplikasi responsif 360px–1920px.

**Panduan penggunaan penuh: [`PANDUAN.html`](PANDUAN.html) (HTML) · [`PANDUAN.md`](PANDUAN.md) (Markdown). English + Bahasa Melayu.**

---

## Cara guna — 3 langkah

### 1. Clone repo

```bash
git clone https://github.com/hishamsam/Skill-Membuat-App-Di-coding-Agent-.git
cd Skill-Membuat-App-Di-coding-Agent-
```

Tiada git? Muat turun ZIP:

```bash
curl -L -o skill.zip https://github.com/hishamsam/Skill-Membuat-App-Di-coding-Agent-/archive/refs/heads/main.zip
unzip skill.zip
cd Skill-Membuat-App-Di-coding-Agent--main
```

### 2. Buka AI agent dalam folder itu

Mana-mana agent: opencode, Claude Code, Codex, Cursor, Gemini CLI.
Agent baca fail arahan repo secara automatik (`AGENTS.md`, `CLAUDE.md`).

Jika agent tidak baca automatik, taip sekali:

```text
Baca AGENTS.md dan ikut sepenuhnya.
```

### 3. Taip `mula`

```text
mula
```

Atau terus dengan idea:

```text
mula bina sistem tempahan kenderaan pejabat
```

Agent akan tanya soalan satu-satu sehingga projek siap:

```text
Soalan → PRD → kelulusan → reka bentuk → kod → ujian → serahan
```

Agent berhenti sebelum deploy dan minta kebenaran.

---

## Cara jawab soalan

| Anda taip | Agent buat |
| --- | --- |
| `A` / `B` / `C` | Ambil pilihan itu, tanya soalan seterusnya |
| `B, sebab dalam Google Workspace` | Pilihan + nota masuk PRD |
| `D: pelajar, guru, pentadbir` | Guna senarai anda |
| `A1:A, A2:C, A4:B` | Jawab banyak soalan sekali gus |
| `ikut cadangan` | Pilih nilai munasabah, tanda `[ANDAIAN]` |
| Jawapan terperinci | `Tempahan perlu kelulusan penyelia; simpan 5 tahun` | PRD lebih tepat, kurang andaian |
| `PRD OK` | Lulus PRD, terus ke reka bentuk dan kod |

Jawab satu soalan satu mesej. Agent tidak akan gabung soalan, dan akan tanya
susulan jika jawapan kabur. Temubual penuh menghasilkan sistem yang lebih baik.

Mod `auto` tidak melangkau temubual. Ia hanya membuang gerbang kelulusan
antara fasa selepas PRD siap:

```text
auto bina sistem tempahan kenderaan, rujukan projek/booking/refs/dashboard.png
```

Prompt penuh: [`templat/PROMPT-AUTO.md`](templat/PROMPT-AUTO.md).

---

## Perintah manual (pilihan)

Agent buat semua ini sendiri. Guna hanya jika mahu kawal langkah.

| Perintah | Fungsi |
| --- | --- |
| `bash skrip/check-setup.sh` | Semak alat dan MCP |
| `bash skrip/new-project.sh <slug> A` | Cipta folder projek (A–F) |
| `bash skrip/qa-check.sh <slug>` | Semak kualiti kod |
| `bash skrip/test-local.sh <slug> --check` | Uji app tempatan |
| `bash skrip/jalankan-semua.sh <slug> A` | Semua sekali gus |

Rujukan penuh: [`PANDUAN.html`](PANDUAN.html).

---

## Struktur repo

```text
GAS Skill/
├── AGENTS.md                 # arahan mula untuk AI agent
├── CLAUDE.md                 # alias untuk Claude Code
├── GEMINI.md                 # alias untuk Gemini CLI
├── SKILL.md                  # skill utama (arahan agent)
├── TEMPLATE_PRD_MS.md        # penjana PRD: temubual + templat
├── figcraft-fast-SKILL.md    # cara tulis FigCraft laju
├── README.md                 # fail ini
├── PANDUAN.md                # panduan lengkap EN + MS
├── PANDUAN.html              # versi HTML, carian + tukar bahasa
├── aliran-kerja/
│   ├── 00-auto.md
│   ├── 01-prd.md
│   ├── 02-design-figcraft.md
│   ├── 03-codegen.md
│   ├── 04-local-test.md
│   └── 05-handoff.md
├── pemasangan/                    # pemasangan MCP (folder berasingan)
│   ├── 01-opencode-mcp.md
│   ├── 02-figcraft.md
│   ├── 03-gas.md
│   ├── 04-supabase.md
│   ├── 05-cloudflare-worker.md
│   ├── 06-firebase.md
│   ├── 07-neon.md
│   └── mcp.opencode.example.json
├── skrip/
│   ├── check-setup.sh
│   ├── jalankan-semua.sh
│   ├── new-project.sh
│   ├── test-local.sh
│   ├── qa-check.sh
│   ├── build-panduan-html.py
│   └── figcraft/fclib.py
├── templat/
│   ├── HANDOFF.md
│   ├── PROMPT-AUTO.md
│   └── figcraft/build.py
└── projek/                 # hasil setiap projek
```

Setiap projek disimpan dalam folder sendiri:

```text
projek/<slug>/
├── STATUS.md
├── prd/PRD-v0.1.md
├── refs/                     # gambar rujukan
├── design/
│   ├── DESIGN-DNA.md
│   ├── build.py
│   ├── design.figcraft
│   └── exports/*.png
├── app/                      # kod aplikasi
└── HANDOFF.md
```

---

## Mod auto (one-shot)

Beri idea sekali, agent jalankan Fasa 1–4 tanpa gerbang kelulusan antara
fasa. Temubual PRD tetap penuh dan terperinci.

Cetus dengan frasa: `auto`, `auto penuh`, `buat semua`, `siapkan terus`,
`one-shot`.

```text
Bina sistem tempahan kenderaan pejabat dalam mod auto penuh.
Rujukan: projek/booking/refs/dashboard.png
Kod responsif 360-1920px. Jalankan qa-check dan test-local --check.
Berhenti sebelum deploy.
```

Prompt penuh: [`templat/PROMPT-AUTO.md`](templat/PROMPT-AUTO.md).
Protokol: [`aliran-kerja/00-auto.md`](aliran-kerja/00-auto.md).

Yang agent buat sendiri:

| Fasa | Auto |
| --- | --- |
| 1 PRD | Temubual penuh satu-satu, pilih stack, tanda `[ANDAIAN]` |
| 2 FigCraft | Bina + semak PNG sendiri, guna headless jika perlu |
| 3 Kod | Jana responsif, tiada butang mati |
| 4 Ujian | Jalankan, betulkan maksimum 3 pusingan |
| 5 Deploy | BERHENTI, tunggu kebenaran |

Yang masih perlukan kebenaran berasingan: deploy production, akaun baharu,
pembayaran, tukar DNS, padam data production.

---

## 5 fasa

| Fasa | Panduan | Output | Gerbang |
| --- | --- | --- | --- |
| 1 PRD | `aliran-kerja/01-prd.md` | `prd/PRD-v0.1.md` | Lulus PRD |
| 2 Reka bentuk | `aliran-kerja/02-design-figcraft.md` | `design/design.figcraft` + PNG | UI disemak |
| 3 Kod | `aliran-kerja/03-codegen.md` | `app/` | `qa-check` lulus |
| 4 Ujian | `aliran-kerja/04-local-test.md` | bukti ujian | semua kes lulus |
| 5 Serahan | `aliran-kerja/05-handoff.md` | `HANDOFF.md` + deploy | smoke test |

### Fasa 1 — PRD

`TEMPLATE_PRD_MS.md` ada dua bahagian:

- **Bahagian A:** 10 soalan temubual, satu soalan per mesej.
- **Bahagian B:** templat PRD 17 bab.

Soalan teknologi (A6) wajib sebelum PRD ditulis:

| Kod | Pilihan | Sesuai |
| --- | --- | --- |
| A | GAS + Google Sheets | Dalaman, data kecil |
| B | Supabase | Postgres + Auth + RLS |
| C | Cloudflare Worker | API edge + D1/KV/R2 |
| D | Firebase | Firestore + Auth + realtime |
| E | Neon | Postgres serverless |
| F | Hibrid | Gabungan, nyatakan lapisan |

Bab 12 PRD mengunci skrin, token, dan rujukan untuk FigCraft.
Bab 13 mengunci perintah ujian dan kriteria terima.

### Fasa 2 — FigCraft

- Guna MCP live (`figcraft-app`) untuk nampak perubahan.
- Untuk banyak layer: satu skrip `design/build.py`, bukan tool call satu-satu.
- Eksport PNG dan simpan `design.figcraft` dalam folder projek.
- Rujukan mobile ≠ kod mobile-only. Frame desktop tetap dibina.

### Fasa 3 — Kod

- Token dari `DESIGN-DNA.md` masuk satu konfigurasi.
- Responsif: 360–639 / 640–1023 / 1024–1439 / ≥1440.
- Mobile: bottom nav + 1 kolum + `pb-24`.
- Desktop: sidebar/top nav + 2–3 kolum.
- Zero dead buttons, zero placeholder, zero rahsia di klien.

### Fasa 4 — Ujian

| Stack | Perintah |
| --- | --- |
| GAS | `IS_PREVIEW=true` + `python3 -m http.server` |
| Supabase | projek dev (Docker tiada di mesin ini) |
| Worker | `npx wrangler dev` |
| Firebase | `npx firebase-tools emulators:start` |
| Neon | `npx wrangler dev` + branch dev |

```bash
bash skrip/test-local.sh <slug> --check
bash skrip/qa-check.sh <slug>
```

### Fasa 5 — Serahan

- Isi `HANDOFF.md`.
- Deploy ikut stack.
- Smoke test production.
- Tanda `STATUS.md` selesai.

---

## Setup MCP

Semua arahan pemasangan dalam folder berasingan: **`pemasangan/`**.

| Dokumen | Isi |
| --- | --- |
| `pemasangan/01-opencode-mcp.md` | Format `opencode.json`, daftar server |
| `pemasangan/02-figcraft.md` | Headless vs live, port 7979 |
| `pemasangan/03-gas.md` | GAS, clasp, mod pratonton |
| `pemasangan/04-supabase.md` | MCP Supabase, projek dev, RLS |
| `pemasangan/05-cloudflare-worker.md` | MCP Cloudflare, wrangler, D1 |
| `pemasangan/06-firebase.md` | MCP Firebase, emulator, rules |
| `pemasangan/07-neon.md` | MCP Neon, serverless driver |

Config siap tampal: `pemasangan/mcp.opencode.example.json`.

Semak:

```bash
opencode mcp list
ss -ltnp | grep 7979
```

---

## Mod rujukan imej

| Mod | Maksud | Bila |
| --- | --- | --- |
| Structural (lalai) | Ambil struktur, density, navigasi; warna boleh ubah | Branding sendiri |
| Pixel-faithful | Ikut grid, skala, radius hampir 1:1 | Mahu hampir sama |
| Mood | Ambil nada/warna/material sahaja | Vibe sahaja |

Apa diambil: sistem visual. Apa tidak: logo, trademark, ilustrasi, foto stok,
avatar, teks berhak cipta.

---

## Contoh prompt

**Mula projek:**

> Bina sistem tempahan kenderaan. Rujuk `refs/dashboard.png`. Guna
> `TEMPLATE_PRD_MS.md`, stack Supabase. Jana PRD dahulu.

**Pindaan PRD:**

> Tambah peranan "Penyelia" dan medan `no_plat`. Jana semula PRD.

**Lulus:**

> PRD OK. Teruskan Fasa 2 FigCraft.

**Semak UI:**

> Skrin S-02 desktop terlalu padat. Kurangkan kad, kekalkan jadual.
> Eksport semula.

**Kod:**

> UI lulus. Teruskan Fasa 3. Pastikan responsif 360–1920 dan tiada butang mati.

**Ujian:**

> Jalankan `qa-check.sh` dan `test-local.sh --check`, tunjuk keputusan.

---

## Standard ringkas

| Perkara | Standard |
| --- | --- |
| PRD | Satu sumber kebenaran; tiada kod sebelum lulus |
| Responsif | 360px–1920px; tiada scroll mendatar |
| Navigasi | Bottom nav mobile; sidebar/top nav desktop |
| Butang | Semua hidup, `data-action` + handler |
| Keadaan UI | default, loading, empty, error |
| Tema | Light mode sahaja |
| Ikon | Satu pustaka (Lucide) |
| Keselamatan | Auth/izin di server; tiada rahsia di klien |
| Ujian | `qa-check` + `test-local` sebelum serah |
