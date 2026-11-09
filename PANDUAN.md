# Complete Usage Guide / Panduan Penggunaan Lengkap

**HTML version (recommended): [`PANDUAN.html`](PANDUAN.html)**

- [Part 1 — English](#part-1--english)
- [Bahagian 2 — Bahasa Melayu](#bahagian-2--bahasa-melayu)

---

# Part 1 — English

## 1. What this tool is

This repository is a complete workflow for turning a rough idea into a
working web application:

```text
Idea + reference images
        ↓  Phase 1  PRD
Approved PRD (single source of truth)
        ↓  Phase 2  FigCraft
Design file + exported screens
        ↓  Phase 3  Code
Responsive app
        ↓  Phase 4  Local test
        ↓  Phase 5  Handoff + deploy
Finished app
```

It supports five backends:

| Code | Stack | Best for |
| --- | --- | --- |
| A | Google Apps Script + Google Sheets | Internal tools, small data, Google Workspace |
| B | Supabase | Postgres, Auth, RLS, Storage, SaaS apps |
| C | Cloudflare Worker | Edge APIs, D1/KV/R2, static assets |
| D | Firebase | Firestore, Auth, realtime, Hosting |
| E | Neon | Serverless Postgres with a separate API |
| F | Hybrid | Explicit combination of the above |

The frontend is always one responsive app, from 360px to 1920px.

## 2. Requirements

Tested on this machine:

| Component | Status |
| --- | --- |
| Node.js | v24.22.1 |
| npm | 11.19.1 |
| Python | 3.12.3 |
| Java | OpenJDK 17 (Firebase emulators) |
| FigCraft CLI | `/usr/bin/figcraft-cli` 0.16.0 |
| Docker | Not installed — Supabase local stack unavailable |
| `psql` | Not installed — use a Node client for Neon |
| Supabase / Neon / Firebase / Wrangler / clasp | Run through `npx` |

Required for all projects:

- FigCraft installed and able to run in live mode.
- OpenCode with the FigCraft MCP servers registered.
- A terminal, Node.js, and Python 3.

## 3. Installation

### 3.1 Check the machine

```bash
bash skrip/check-setup.sh
```

This reports Node, npm, Python, Java, FigCraft CLI, port 7979, MCP
registration, Docker, and `psql`.

### 3.2 Register the MCP servers

Config file: `~/.config/opencode/opencode.json`

```bash
opencode mcp add figcraft --global -- /usr/bin/figcraft-cli mcp
opencode mcp add figcraft-app --global -- /usr/bin/figcraft-cli mcp --attach 7979
opencode mcp list
```

Or copy the matching blocks from `pemasangan/mcp.opencode.example.json`.
Restart OpenCode after changing the config.

Optional cloud services:

```bash
# Supabase — OAuth or personal access token
opencode mcp add supabase --global \
  --url "https://mcp.supabase.com/mcp?project_ref=<ref>"
opencode mcp auth supabase

# Cloudflare
opencode mcp add cloudflare-docs --global \
  --url "https://docs.mcp.cloudflare.com/mcp"
opencode mcp add cloudflare-observability --global \
  --url "https://observability.mcp.cloudflare.com/mcp"

# Firebase
opencode mcp add firebase --global -- npx -y firebase-tools@latest mcp

# Neon
opencode mcp add neon --global --url "https://mcp.neon.tech/mcp"
opencode mcp auth neon
```

Never commit tokens. Use `{file:~/.secrets/<name>}` in the config or OAuth.

### 3.3 Start FigCraft in live mode

```bash
figcraft --control 7979 &
ss -ltnp | grep 7979
```

If the port is not listening, the `figcraft-app` MCP server cannot attach.
Do not edit the OpenCode config to work around this; open the app in live mode.

## 4. Repository layout

```text
GAS Skill/
├── SKILL.md                  # main agent instructions
├── TEMPLATE_PRD_MS.md        # PRD generator (interview + template)
├── figcraft-fast-SKILL.md    # fast FigCraft scripting rules
├── PANDUAN.md                # this guide
├── README.md                 # short quick start
├── aliran-kerja/             # phase-by-phase workflows
├── pemasangan/               # MCP and stack setup
├── skrip/                    # automation scripts
├── templat/                  # HANDOFF + FigCraft build template
└── projek/                   # one folder per project
```

Each project:

```text
projek/<slug>/
├── STATUS.md                 # phase checkboxes
├── STACK                     # A–F
├── prd/PRD-v0.1.md
├── refs/                     # reference images
├── design/
│   ├── DESIGN-DNA.md
│   ├── build.py
│   ├── design.figcraft
│   └── exports/*.png
├── app/                      # code
├── tests/
└── HANDOFF.md
```

## 5. Quick start

```bash
# 1. Check the environment
bash skrip/check-setup.sh

# 2. Create a project (A=GAS, B=Supabase, C=Worker, D=Firebase, E=Neon, F=Hybrid)
bash skrip/new-project.sh sistem-tempahan A

# 3. Put reference images here
cp ~/Downloads/ref.png projek/sistem-tempahan/refs/

# 4. Ask the agent to run Phase 1
#    "Read the idea and refs/. Use TEMPLATE_PRD_MS.md. Generate the PRD."

# 5. After PRD approval, start FigCraft
figcraft --control 7979 &
python3 -I projek/sistem-tempahan/design/build.py --rehearsal

# 6. After UI approval, generate code and test
bash skrip/qa-check.sh sistem-tempahan
bash skrip/test-local.sh sistem-tempahan
```

### Auto mode (one-shot)

Give the idea once and let the agent run Phases 1–4 without stopping. The
workflow does not change; only the interview and the approval gates are
shortened.

Trigger phrases: `auto`, `auto penuh`, `buat semua`, `siapkan terus`,
`one-shot`.

```text
Build an office vehicle booking system in full auto mode.
Reference: projek/booking/refs/dashboard.png
Code must be responsive 360-1920px. Run qa-check and test-local --check.
Stop before deploy.
```

| Phase | Auto behaviour |
| --- | --- |
| 1 PRD | Skip the interview, choose the stack, mark every gap `[ASSUMPTION]` |
| 2 FigCraft | Build, inspect the PNGs, use headless mode if port 7979 is down |
| 3 Code | Generate the responsive app, no dead buttons |
| 4 Test | Run, fix up to three rounds, report real output |
| 5 Deploy | Stop and wait for explicit approval |

Still requires separate approval: production deploy, new accounts, payments,
DNS changes, production data deletion, production credentials.

Files: `aliran-kerja/00-auto.md` and `templat/PROMPT-AUTO.md`.

## 6. Phase 1 — PRD

Files: `TEMPLATE_PRD_MS.md`, `aliran-kerja/01-prd.md`.

### What happens

1. The agent creates the project folder and reads any reference images.
2. It runs a structured interview, one question per message: ten main
   questions plus up to four stack follow-ups.
3. Question A6 locks the technology stack.
4. It writes the full PRD to `projek/<slug>/prd/PRD-v0.1.md`.
5. It stops and waits for approval.

If you want speed, reply "generate directly". The agent will generate the PRD
and mark every assumption in Chapter 5.

In auto mode the interview is skipped entirely. The agent picks the stack
itself, marks every gap `[ASSUMPTION]`, and continues to Phase 2 without
waiting for approval.

### Interview questions

| ID | Topic |
| --- | --- |
| A1 | Problem and users |
| A2 | Roles and permissions |
| A3 | Core flow |
| A4 | Main data entities |
| A5 | MVP scope |
| A6 | Technology stack (mandatory) |
| A7 | Hosting and domain |
| A8 | Stack-specific follow-ups (max 4) |
| A9 | Visual references and target device |
| A10 | Definition of done and tests |

### Technology choices

| Code | Stack | Choose when |
| --- | --- | --- |
| A | GAS + Sheets | Internal, under ~10k rows, Google ecosystem |
| B | Supabase | Postgres, Auth, RLS, Storage, realtime |
| C | Cloudflare Worker | Global API, D1/KV/R2, low latency |
| D | Firebase | Realtime sync, fast auth, mobile/web |
| E | Neon | Postgres serverless, branching, separate API |
| F | Hybrid | Two or more services with clear boundaries |

The PRD records the choice and the rejected alternatives in Chapter 6.

### PRD chapters

| Chapter | Content |
| --- | --- |
| 1–5 | Problem, goals, users, scope, assumptions |
| 6 | Technology decision, environment variables, architecture |
| 7 | Functional requirements with IDs and priority |
| 8 | User flows |
| 9 | Data model + physical implementation per stack |
| 10 | Non-functional requirements, including responsive rules |
| 11 | Third-party integrations |
| 12 | UI contract and FigCraft handoff (mandatory) |
| 13 | Local test plan and acceptance criteria (mandatory) |
| 14–17 | Future features, out of scope, open questions, glossary |

Chapter 12 must list every screen with four states: default, loading, empty,
error. Chapter 13 must list runnable test commands and acceptance checks.

### Approval gate

Do not write code before the PRD is approved. Reply "lulus", "ok proceed",
or "build" to continue.

## 7. Phase 2 — FigCraft design

Files: `aliran-kerja/02-design-figcraft.md`, `figcraft-fast-SKILL.md`.

### Rules

- Read PRD Chapter 12 and the actual images in `refs/`. The FigCraft MCP
  cannot see images; the agent must open them.
- Write `design/DESIGN-DNA.md`: grid, type, palette, spacing, radius,
  density, signature element.
- Build with one Python script, not one MCP call per layer.
- Export PNGs and look at them. Fix the script and rerun.
- Save the native file as `design/design.figcraft`.

### Commands

```bash
# Rehearse in a throwaway document
python3 -I projek/<slug>/design/build.py --rehearsal

# Build for real
python3 -I projek/<slug>/design/build.py

# Build and save design.figcraft
python3 -I projek/<slug>/design/build.py --save
```

### Frame sizes

| Device | Size |
| --- | --- |
| Mobile | 390 × 844 |
| Tablet | 768 × 1024 |
| Desktop | 1440 × 900 |

Build desktop frames even when the reference is mobile. A mobile reference is
a composition guide, not a width lock for the code.

### Screen naming

```text
S-01 / Mobile 390
S-01 / Desktop 1440
```

Use the screen IDs from PRD Chapter 12.

### Output

```text
design/design.figcraft
design/exports/S-01-mobile.png
design/exports/S-01-desktop.png
```

## 8. Phase 3 — Responsive code

Files: `aliran-kerja/03-codegen.md`.

### Responsive contract

| Range | Target | Navigation | Content grid |
| --- | --- | --- | --- |
| 360–639px | Phone | Bottom nav, 3–5 items | 1 column |
| 640–1023px | Tablet | Top bar or rail | 1–2 columns |
| 1024–1439px | Laptop | Sidebar or full top nav | 2–3 columns |
| ≥ 1440px | Desktop | Same, capped container | 3–4 columns |

Hard rules:

- `viewport` meta present.
- No horizontal scroll on the root.
- Tables use `overflow-x-auto` or become card lists on mobile.
- Modals: `w-[calc(100%-2rem)] max-w-lg max-h-[85vh] overflow-y-auto`.
- Buttons and inputs are at least 44px high.
- Mobile content has `pb-24` clearance for the bottom nav.
- No dark mode.
- No dead buttons: every button has a real handler.
- Every screen has loading, empty, and error states.
- No secrets in frontend files.

### Files per stack

| Stack | Main files |
| --- | --- |
| A GAS | `app/index.html`, `app/Code.gs`, `app/appsscript.json` |
| B Supabase | `app/public/index.html`, `app/supabase/migrations/*.sql`, `.env.example` |
| C Worker | `app/public/`, `app/src/index.js`, `app/wrangler.jsonc` |
| D Firebase | `app/public/index.html`, `firestore.rules`, `firebase.json` |
| E Neon | `app/public/index.html`, `app/api/`, `app/db/migrations/*.sql` |
| F Hybrid | Combination; do not duplicate logic |

### Quality gate

```bash
bash skrip/qa-check.sh <slug>
```

The script checks viewport, dark mode, placeholders, buttons vs `data-action`,
responsive classes, secret patterns, PRD presence, and design exports. It
exits non-zero on failures.

## 9. Phase 4 — Local test

Files: `aliran-kerja/04-local-test.md`.

### Commands

```bash
bash skrip/test-local.sh <slug>
bash skrip/test-local.sh <slug> --check
```

### Per stack

| Stack | Local test |
| --- | --- |
| A GAS | `IS_PREVIEW=true`, then `python3 -m http.server`; test the deployed backend with `curl` |
| B Supabase | Use a free dev project; Docker is not installed here |
| C Worker | `npx wrangler dev` |
| D Firebase | `npx firebase-tools emulators:start` |
| E Neon | `npx wrangler dev` in `app/api` with a dev branch |
| F Hybrid | Start each service in its own terminal |

### Browser checks

Test at 360×800, 390×844, 768×1024, 1024×768, and 1440×900.

Check:

- No console errors.
- Every button does something real.
- CRUD works with seed data.
- Loading, empty, and error states can be triggered.
- Refreshing does not force logout.
- No horizontal scroll at 360px.
- No secret strings in the built frontend.

### GAS backend check

```bash
curl -L -X POST "<GAS_URL>" \
  -H "Content-Type: text/plain;charset=utf-8" \
  -d '{"action":"ping","data":{}}'
```

## 10. Phase 5 — Handoff and deploy

Files: `aliran-kerja/05-handoff.md`, `templat/HANDOFF.md`.

### Deploy commands

| Stack | Deploy |
| --- | --- |
| GAS | Deploy `Code.gs` as a Web App; upload `index.html` to Vercel |
| Supabase | `npx supabase link --project-ref <ref>` then `npx supabase db push` |
| Worker | `npx wrangler d1 execute ... --remote`, `npx wrangler secret put`, `npx wrangler deploy` |
| Firebase | `npx firebase-tools deploy --only hosting,firestore:rules,firestore:indexes` |
| Neon | Deploy the API, run migrations on the production branch |
| Hybrid | Deploy each layer separately |

### Handoff contents

- Production and staging URLs.
- Admin account and password-change procedure.
- Environment variable names, never values.
- Local run and deploy commands.
- Backup and rollback steps.
- Known limits and future work.
- Links to PRD, design file, and exports.

### Production smoke test

1. Open the production URL.
2. Log in with the real account.
3. Perform one create, read, update, and delete.
4. Submit one invalid input and confirm a clear error.

## 11. Script reference

| Script | Purpose |
| --- | --- |
| `skrip/check-setup.sh` | Check tools, FigCraft, port, MCP, Docker, `psql` |
| `skrip/new-project.sh <slug> [A–F]` | Create the project folder and starter files |
| `skrip/qa-check.sh <slug>` | Static quality gate |
| `skrip/test-local.sh <slug> [--check]` | Run the local server, optionally smoke-test and stop |
| `skrip/figcraft/fclib.py` | FigCraft Python helpers |
| `templat/figcraft/build.py` | Starter FigCraft build script |
| `skrip/build-panduan-html.py` | Regenerate `PANDUAN.html` from this file |

Useful flags:

```bash
bash skrip/test-local.sh <slug> --port 8080
python3 -I projek/<slug>/design/build.py --rehearsal --save
```

## 12. Documentation map

| Document | Read it when |
| --- | --- |
| `README.md` | First overview |
| `SKILL.md` | Agent behaviour and engineering standards |
| `TEMPLATE_PRD_MS.md` | Phase 1 interview and PRD format |
| `aliran-kerja/00-auto.md` | Auto mode: trigger, limits, report |
| `aliran-kerja/01-prd.md` | Step-by-step Phase 1 |
| `aliran-kerja/02-design-figcraft.md` | Step-by-step Phase 2 |
| `aliran-kerja/03-codegen.md` | Phase 3 rules and file layouts |
| `aliran-kerja/04-local-test.md` | Phase 4 test matrix |
| `aliran-kerja/05-handoff.md` | Phase 5 deploy and handoff |
| `templat/PROMPT-AUTO.md` | Copy-paste auto mode prompt (EN + MS) |
| `pemasangan/01-opencode-mcp.md` | OpenCode MCP config |
| `pemasangan/02-figcraft.md` | FigCraft headless and live |
| `pemasangan/03-gas.md` | GAS setup |
| `pemasangan/04-supabase.md` | Supabase setup |
| `pemasangan/05-cloudflare-worker.md` | Cloudflare setup |
| `pemasangan/06-firebase.md` | Firebase setup |
| `pemasangan/07-neon.md` | Neon setup |

## 13. Troubleshooting

| Symptom | Cause | Fix |
| --- | --- | --- |
| `can't reach 127.0.0.1:7979` | App not in live mode | `figcraft --control 7979 &` |
| FigCraft tools missing in OpenCode | Session started before MCP was ready | Restart OpenCode |
| Port 4173 already in use | Old test server still running | `bash skrip/test-local.sh <slug> --port 4174` |
| `qa-check` fails on placeholder | PRD or code still has `{{...}}` / `TODO` | Replace them with real content |
| `qa-check` fails on dead buttons | More `<button>` than `data-action` | Add handlers |
| Supabase local fails | Docker not installed | Use a free cloud dev project |
| Neon connection fails locally | `psql` not installed | Use the Node migration script |
| Firebase emulator will not start | Java missing or wrong version | Install Java 17+ |
| Wrangler deploy asks for login | No Cloudflare session | `npx wrangler login` |
| FigCraft text looks wrong | Missing font | `f.cmd('text.missingFonts')` |
| Renamed folder breaks a path | Scripts resolve from repo root | Run commands from the repo, or use full paths |

## 14. Example prompts

**Start a project**

> Build an office vehicle booking system. Use `TEMPLATE_PRD_MS.md` and stack
> Supabase. Reference `projek/booking/refs/dashboard.png`. Generate the PRD
> first.

**Amend the PRD**

> Add a "Supervisor" role and a `plate_no` field. Regenerate the PRD.

**Approve**

> PRD approved. Continue to Phase 2 in FigCraft.

**Review the UI**

> Screen S-02 desktop is too dense. Remove two cards, keep the table. Export
> again.

**Build the code**

> UI approved. Continue to Phase 3. Must be responsive 360–1920 and have no
> dead buttons.

**Test**

> Run `qa-check.sh` and `test-local.sh --check`. Show the results.

## 15. Definition of done

- [ ] PRD approved and saved.
- [ ] Design file and PNG exports saved.
- [ ] Code passes `qa-check.sh`.
- [ ] Local smoke test passes.
- [ ] All mandatory PRD requirements work.
- [ ] Responsive verified at 390 / 768 / 1024 / 1440.
- [ ] Production smoke test passes.
- [ ] `HANDOFF.md` complete.
- [ ] No secrets in the repository.

---

# Bahagian 2 — Bahasa Melayu

## 1. Apa alat ini

Repositori ini ialah satu aliran kerja lengkap untuk menukar idea kasar
menjadi aplikasi web yang berfungsi:

```text
Idea + imej rujukan
        ↓  Fasa 1  PRD
PRD diluluskan (satu sumber kebenaran)
        ↓  Fasa 2  FigCraft
Fail reka bentuk + skrin dieksport
        ↓  Fasa 3  Kod
Aplikasi responsif
        ↓  Fasa 4  Ujian tempatan
        ↓  Fasa 5  Serahan + deploy
Aplikasi siap
```

Lima pilihan backend:

| Kod | Stack | Sesuai untuk |
| --- | --- | --- |
| A | Google Apps Script + Google Sheets | Alat dalaman, data kecil, Google Workspace |
| B | Supabase | Postgres, Auth, RLS, Storage, aplikasi SaaS |
| C | Cloudflare Worker | API edge, D1/KV/R2, static assets |
| D | Firebase | Firestore, Auth, realtime, Hosting |
| E | Neon | Postgres serverless dengan API berasingan |
| F | Hibrid | Gabungan di atas dengan sempadan jelas |

Frontend sentiasa satu aplikasi responsif, dari 360px hingga 1920px.

## 2. Keperluan

Diuji pada mesin ini:

| Komponen | Status |
| --- | --- |
| Node.js | v24.22.1 |
| npm | 11.19.1 |
| Python | 3.12.3 |
| Java | OpenJDK 17 (emulator Firebase) |
| FigCraft CLI | `/usr/bin/figcraft-cli` 0.16.0 |
| Docker | Tiada — Supabase local stack tidak boleh guna |
| `psql` | Tiada — guna klien Node untuk Neon |
| Supabase / Neon / Firebase / Wrangler / clasp | Jalankan melalui `npx` |

Keperluan untuk semua projek:

- FigCraft dipasang dan boleh berjalan dalam mod live.
- OpenCode dengan server MCP FigCraft didaftar.
- Terminal, Node.js, dan Python 3.

## 3. Pemasangan

### 3.1 Semak mesin

```bash
bash skrip/check-setup.sh
```

Skrip melaporkan Node, npm, Python, Java, FigCraft CLI, port 7979,
pendaftaran MCP, Docker, dan `psql`.

### 3.2 Daftar server MCP

Fail config: `~/.config/opencode/opencode.json`

```bash
opencode mcp add figcraft --global -- /usr/bin/figcraft-cli mcp
opencode mcp add figcraft-app --global -- /usr/bin/figcraft-cli mcp --attach 7979
opencode mcp list
```

Atau salin blok berkenaan daripada `pemasangan/mcp.opencode.example.json`.
Buka semula OpenCode selepas mengubah config.

Servis awan pilihan:

```bash
# Supabase — OAuth atau token akses peribadi
opencode mcp add supabase --global \
  --url "https://mcp.supabase.com/mcp?project_ref=<ref>"
opencode mcp auth supabase

# Cloudflare
opencode mcp add cloudflare-docs --global \
  --url "https://docs.mcp.cloudflare.com/mcp"
opencode mcp add cloudflare-observability --global \
  --url "https://observability.mcp.cloudflare.com/mcp"

# Firebase
opencode mcp add firebase --global -- npx -y firebase-tools@latest mcp

# Neon
opencode mcp add neon --global --url "https://mcp.neon.tech/mcp"
opencode mcp auth neon
```

Jangan commit token. Guna `{file:~/.secrets/<nama>}` dalam config atau OAuth.

### 3.3 Buka FigCraft mod live

```bash
figcraft --control 7979 &
ss -ltnp | grep 7979
```

Jika port tidak aktif, server MCP `figcraft-app` tidak boleh menyambung.
Jangan ubah config OpenCode untuk mengelak masalah ini; buka app dalam mod live.

## 4. Susunan repositori

```text
GAS Skill/
├── SKILL.md                  # arahan utama agent
├── TEMPLATE_PRD_MS.md        # penjana PRD (temubual + templat)
├── figcraft-fast-SKILL.md    # peraturan skrip FigCraft pantas
├── PANDUAN.md                # panduan ini
├── README.md                 # mula pantas
├── aliran-kerja/             # panduan setiap fasa
├── pemasangan/               # pemasangan MCP dan stack
├── skrip/                    # skrip automasi
├── templat/                  # HANDOFF + templat bina FigCraft
└── projek/                   # satu folder setiap projek
```

Setiap projek:

```text
projek/<slug>/
├── STATUS.md                 # senarai semak fasa
├── STACK                     # A–F
├── prd/PRD-v0.1.md
├── refs/                     # imej rujukan
├── design/
│   ├── DESIGN-DNA.md
│   ├── build.py
│   ├── design.figcraft
│   └── exports/*.png
├── app/                      # kod
├── tests/
└── HANDOFF.md
```

## 5. Mula pantas

```bash
# 1. Semak persekitaran
bash skrip/check-setup.sh

# 2. Cipta projek (A=GAS, B=Supabase, C=Worker, D=Firebase, E=Neon, F=Hibrid)
bash skrip/new-project.sh sistem-tempahan A

# 3. Letak imej rujukan di sini
cp ~/Downloads/ref.png projek/sistem-tempahan/refs/

# 4. Minta agent jalankan Fasa 1
#    "Baca idea dan refs/. Guna TEMPLATE_PRD_MS.md. Jana PRD."

# 5. Selepas PRD diluluskan, buka FigCraft
figcraft --control 7979 &
python3 -I projek/sistem-tempahan/design/build.py --rehearsal

# 6. Selepas UI disemak, jana kod dan uji
bash skrip/qa-check.sh sistem-tempahan
bash skrip/test-local.sh sistem-tempahan
```

### Mod auto (one-shot)

Beri idea sekali, agent jalankan Fasa 1–4 tanpa berhenti. Workflow tidak
berubah; hanya temubual dan gerbang kelulusan dipendekkan.

Frasa cetus: `auto`, `auto penuh`, `buat semua`, `siapkan terus`, `one-shot`.

```text
Bina sistem tempahan kenderaan pejabat dalam mod auto penuh.
Rujukan: projek/booking/refs/dashboard.png
Kod mesti responsif 360-1920px. Jalankan qa-check dan test-local --check.
Berhenti sebelum deploy.
```

| Fasa | Tingkah laku auto |
| --- | --- |
| 1 PRD | Langkau temubual, pilih stack, tanda setiap lompang `[ANDAIAN]` |
| 2 FigCraft | Bina, semak PNG, guna headless jika port 7979 tiada |
| 3 Kod | Jana aplikasi responsif, tiada butang mati |
| 4 Ujian | Jalankan, betulkan maksimum 3 pusingan, lapor output sebenar |
| 5 Deploy | Berhenti dan tunggu kebenaran jelas |

Masih perlukan kebenaran berasingan: deploy production, akaun baharu,
pembayaran, tukar DNS, padam data production, kredensial production.

Fail: `aliran-kerja/00-auto.md` dan `templat/PROMPT-AUTO.md`.

## 6. Fasa 1 — PRD

Fail: `TEMPLATE_PRD_MS.md`, `aliran-kerja/01-prd.md`.

### Apa yang berlaku

1. Agent mencipta folder projek dan membaca imej rujukan.
2. Ia menjalankan temubual berstruktur, satu soalan per mesej: sepuluh soalan
   utama serta maksimum empat soalan susulan khusus stack.
3. Soalan A6 mengunci teknologi.
4. PRD penuh ditulis ke `projek/<slug>/prd/PRD-v0.1.md`.
5. Agent berhenti dan menunggu kelulusan.

Jika mahu laju, balas "jana terus". Agent akan menjana PRD dan menandakan
setiap andaian dalam Bab 5.

Dalam mod auto, temubual dilangkau sepenuhnya. Agent memilih stack sendiri,
menanda setiap lompang `[ANDAIAN]`, dan terus ke Fasa 2 tanpa menunggu
kelulusan.

### Soalan temubual

| ID | Topik |
| --- | --- |
| A1 | Masalah dan pengguna |
| A2 | Peranan dan kebenaran |
| A3 | Aliran teras |
| A4 | Entiti data utama |
| A5 | Skop MVP |
| A6 | Teknologi (wajib) |
| A7 | Hosting dan domain |
| A8 | Soalan susulan khusus stack (maksimum 4) |
| A9 | Rujukan visual dan peranti sasaran |
| A10 | Definisi siap dan ujian |

### Pilihan teknologi

| Kod | Stack | Pilih bila |
| --- | --- | --- |
| A | GAS + Sheets | Dalaman, bawah ~10k baris, ekosistem Google |
| B | Supabase | Postgres, Auth, RLS, Storage, realtime |
| C | Cloudflare Worker | API global, D1/KV/R2, latensi rendah |
| D | Firebase | Realtime sync, auth pantas, web/mobile |
| E | Neon | Postgres serverless, branching, API berasingan |
| F | Hibrid | Dua servis atau lebih dengan sempadan jelas |

PRD merekod pilihan dan alternatif yang ditolak dalam Bab 6.

### Bab PRD

| Bab | Kandungan |
| --- | --- |
| 1–5 | Masalah, tujuan, pengguna, skop, andaian |
| 6 | Keputusan teknologi, env, seni bina |
| 7 | Keperluan fungsian ber-ID dan keutamaan |
| 8 | Aliran pengguna |
| 9 | Model data + implementasi fizikal ikut stack |
| 10 | Keperluan bukan fungsian termasuk responsif |
| 11 | Integrasi pihak ketiga |
| 12 | Kontrak UI dan handoff FigCraft (wajib) |
| 13 | Pelan ujian tempatan dan kriteria terima (wajib) |
| 14–17 | Ciri masa depan, luar skop, soalan terbuka, glosarium |

Bab 12 mesti menyenaraikan setiap skrin dengan empat keadaan: default,
loading, empty, error. Bab 13 mesti menyenaraikan perintah ujian dan
semakan penerimaan.

### Gerbang kelulusan

Jangan tulis kod sebelum PRD diluluskan. Balas "lulus", "ok proceed", atau
"buat kod" untuk teruskan.

## 7. Fasa 2 — Reka bentuk FigCraft

Fail: `aliran-kerja/02-design-figcraft.md`, `figcraft-fast-SKILL.md`.

### Peraturan

- Baca PRD Bab 12 dan imej sebenar dalam `refs/`. MCP FigCraft tidak boleh
  melihat imej; agent mesti membuka fail itu.
- Tulis `design/DESIGN-DNA.md`: grid, tipografi, palette, spacing, radius,
  density, elemen signature.
- Bina dengan SATU skrip Python, bukan satu panggilan MCP setiap layer.
- Eksport PNG dan lihat. Betulkan skrip, ulang.
- Simpan fail asal sebagai `design/design.figcraft`.

### Perintah

```bash
# Rehearsal dalam dokumen buangan
python3 -I projek/<slug>/design/build.py --rehearsal

# Bina sebenar
python3 -I projek/<slug>/design/build.py

# Bina dan simpan design.figcraft
python3 -I projek/<slug>/design/build.py --save
```

### Saiz frame

| Peranti | Saiz |
| --- | --- |
| Mobile | 390 × 844 |
| Tablet | 768 × 1024 |
| Desktop | 1440 × 900 |

Bina frame desktop walaupun rujukan hanya mobile. Rujukan mobile ialah
panduan komposisi, bukan kunci lebar kod.

### Penamaan skrin

```text
S-01 / Mobile 390
S-01 / Desktop 1440
```

Guna ID skrin daripada PRD Bab 12.

### Output

```text
design/design.figcraft
design/exports/S-01-mobile.png
design/exports/S-01-desktop.png
```

## 8. Fasa 3 — Kod responsif

Fail: `aliran-kerja/03-codegen.md`.

### Kontrak responsif

| Julat | Sasaran | Navigasi | Grid kandungan |
| --- | --- | --- | --- |
| 360–639px | Telefon | Bottom nav, 3–5 item | 1 kolum |
| 640–1023px | Tablet | Top bar atau rail | 1–2 kolum |
| 1024–1439px | Laptop | Sidebar atau top nav penuh | 2–3 kolum |
| ≥ 1440px | Desktop | Sama, container terhad | 3–4 kolum |

Peraturan keras:

- Meta `viewport` ada.
- Tiada scroll mendatar pada root.
- Jadual guna `overflow-x-auto` atau jadi senarai kad di mobile.
- Modal: `w-[calc(100%-2rem)] max-w-lg max-h-[85vh] overflow-y-auto`.
- Butang dan input sekurang-kurangnya 44px tinggi.
- Kandungan mobile ada `pb-24` untuk ruang bottom nav.
- Tiada dark mode.
- Tiada butang mati: setiap butang ada handler sebenar.
- Setiap skrin ada keadaan loading, empty, error.
- Tiada rahsia dalam fail frontend.

### Fail mengikut stack

| Stack | Fail utama |
| --- | --- |
| A GAS | `app/index.html`, `app/Code.gs`, `app/appsscript.json` |
| B Supabase | `app/public/index.html`, `app/supabase/migrations/*.sql`, `.env.example` |
| C Worker | `app/public/`, `app/src/index.js`, `app/wrangler.jsonc` |
| D Firebase | `app/public/index.html`, `firestore.rules`, `firebase.json` |
| E Neon | `app/public/index.html`, `app/api/`, `app/db/migrations/*.sql` |
| F Hibrid | Gabungan; jangan ulang logik |

### Gerbang kualiti

```bash
bash skrip/qa-check.sh <slug>
```

Skrip menyemak viewport, dark mode, placeholder, nisbah butang vs
`data-action`, kelas responsif, corak rahsia, kewujudan PRD, dan eksport
reka bentuk. Ia keluar dengan kod bukan sifar jika gagal.

## 9. Fasa 4 — Ujian tempatan

Fail: `aliran-kerja/04-local-test.md`.

### Perintah

```bash
bash skrip/test-local.sh <slug>
bash skrip/test-local.sh <slug> --check
```

### Mengikut stack

| Stack | Ujian tempatan |
| --- | --- |
| A GAS | `IS_PREVIEW=true`, kemudian `python3 -m http.server`; uji backend selepas deploy dengan `curl` |
| B Supabase | Guna projek dev percuma; Docker tiada di mesin ini |
| C Worker | `npx wrangler dev` |
| D Firebase | `npx firebase-tools emulators:start` |
| E Neon | `npx wrangler dev` dalam `app/api` dengan branch dev |
| F Hibrid | Jalankan setiap servis dalam terminal sendiri |

### Semakan pelayar

Uji pada 360×800, 390×844, 768×1024, 1024×768, dan 1440×900.

Semak:

- Tiada ralat konsol.
- Setiap butang melakukan tindakan nyata.
- CRUD berfungsi dengan data seed.
- Keadaan loading, empty, error boleh dicetuskan.
- Refresh tidak memaksa logout.
- Tiada scroll mendatar pada 360px.
- Tiada string rahsia dalam frontend yang dibina.

### Semakan backend GAS

```bash
curl -L -X POST "<GAS_URL>" \
  -H "Content-Type: text/plain;charset=utf-8" \
  -d '{"action":"ping","data":{}}'
```

## 10. Fasa 5 — Serahan dan deploy

Fail: `aliran-kerja/05-handoff.md`, `templat/HANDOFF.md`.

### Perintah deploy

| Stack | Deploy |
| --- | --- |
| GAS | Deploy `Code.gs` sebagai Web App; muat naik `index.html` ke Vercel |
| Supabase | `npx supabase link --project-ref <ref>` kemudian `npx supabase db push` |
| Worker | `npx wrangler d1 execute ... --remote`, `npx wrangler secret put`, `npx wrangler deploy` |
| Firebase | `npx firebase-tools deploy --only hosting,firestore:rules,firestore:indexes` |
| Neon | Deploy API, jalankan migrasi pada branch production |
| Hibrid | Deploy setiap lapisan secara berasingan |

### Kandungan serahan

- URL production dan staging.
- Akaun admin dan cara tukar kata laluan.
- Nama pemboleh ubah persekitaran, bukan nilai.
- Perintah jalan tempatan dan deploy.
- Langkah backup dan rollback.
- Had diketahui dan kerja masa depan.
- Pautan ke PRD, fail reka bentuk, dan eksport.

### Smoke test production

1. Buka URL production.
2. Log masuk dengan akaun sebenar.
3. Lakukan satu create, read, update, dan delete.
4. Hantar satu input tidak sah dan pastikan ralat jelas.

## 11. Rujukan skrip

| Skrip | Tujuan |
| --- | --- |
| `skrip/check-setup.sh` | Semak alat, FigCraft, port, MCP, Docker, `psql` |
| `skrip/new-project.sh <slug> [A–F]` | Cipta folder projek dan fail permulaan |
| `skrip/qa-check.sh <slug>` | Gerbang kualiti statik |
| `skrip/test-local.sh <slug> [--check]` | Jalankan server tempatan, uji dan henti jika `--check` |
| `skrip/figcraft/fclib.py` | Pembantu Python FigCraft |
| `templat/figcraft/build.py` | Skrip permulaan bina FigCraft |
| `skrip/build-panduan-html.py` | Jana semula `PANDUAN.html` daripada fail ini |

Flag berguna:

```bash
bash skrip/test-local.sh <slug> --port 8080
python3 -I projek/<slug>/design/build.py --rehearsal --save
```

## 12. Peta dokumentasi

| Dokumen | Baca bila |
| --- | --- |
| `README.md` | Gambaran pertama |
| `SKILL.md` | Tingkah laku agent dan standard kejuruteraan |
| `TEMPLATE_PRD_MS.md` | Temubual Fasa 1 dan format PRD |
| `aliran-kerja/00-auto.md` | Mod auto: cetusan, had, laporan |
| `aliran-kerja/01-prd.md` | Langkah Fasa 1 |
| `aliran-kerja/02-design-figcraft.md` | Langkah Fasa 2 |
| `aliran-kerja/03-codegen.md` | Peraturan dan susunan fail Fasa 3 |
| `aliran-kerja/04-local-test.md` | Matriks ujian Fasa 4 |
| `aliran-kerja/05-handoff.md` | Deploy dan serahan Fasa 5 |
| `templat/PROMPT-AUTO.md` | Prompt mod auto sedia salin (EN + MS) |
| `pemasangan/01-opencode-mcp.md` | Config MCP OpenCode |
| `pemasangan/02-figcraft.md` | FigCraft headless dan live |
| `pemasangan/03-gas.md` | Pemasangan GAS |
| `pemasangan/04-supabase.md` | Pemasangan Supabase |
| `pemasangan/05-cloudflare-worker.md` | Pemasangan Cloudflare |
| `pemasangan/06-firebase.md` | Pemasangan Firebase |
| `pemasangan/07-neon.md` | Pemasangan Neon |

## 13. Penyelesaian masalah

| Gejala | Punca | Penyelesaian |
| --- | --- | --- |
| `can't reach 127.0.0.1:7979` | App bukan mod live | `figcraft --control 7979 &` |
| Tool FigCraft tiada dalam OpenCode | Sesi bermula sebelum MCP sedia | Buka semula OpenCode |
| Port 4173 sedang digunakan | Server ujian lama masih hidup | `bash skrip/test-local.sh <slug> --port 4174` |
| `qa-check` gagal pada placeholder | PRD atau kod masih ada `{{...}}` / `TODO` | Ganti dengan kandungan sebenar |
| `qa-check` gagal pada butang mati | Bilangan `<button>` lebih daripada `data-action` | Tambah handler |
| Supabase local gagal | Docker tiada | Guna projek dev awan percuma |
| Sambungan Neon gagal | `psql` tiada | Guna skrip migrasi Node |
| Emulator Firebase tidak mula | Java tiada atau versi salah | Pasang Java 17+ |
| Wrangler minta login | Tiada sesi Cloudflare | `npx wrangler login` |
| Teks FigCraft kelihatan salah | Font tiada | `f.cmd('text.missingFonts')` |
| Folder dinamakan semula memecahkan path | Skrip mengira root repo | Jalankan dari root repo atau guna path penuh |

## 14. Contoh prompt

**Mula projek**

> Bina sistem tempahan kenderaan pejabat. Guna `TEMPLATE_PRD_MS.md` dan
> stack Supabase. Rujuk `projek/booking/refs/dashboard.png`. Jana PRD dahulu.

**Pinda PRD**

> Tambah peranan "Penyelia" dan medan `plate_no`. Jana semula PRD.

**Lulus**

> PRD diluluskan. Teruskan Fasa 2 di FigCraft.

**Semak UI**

> Skrin S-02 desktop terlalu padat. Buang dua kad, kekalkan jadual. Eksport
> semula.

**Bina kod**

> UI diluluskan. Teruskan Fasa 3. Wajib responsif 360–1920 dan tiada butang
> mati.

**Ujian**

> Jalankan `qa-check.sh` dan `test-local.sh --check`. Tunjuk keputusan.

## 15. Definisi siap

- [ ] PRD diluluskan dan disimpan.
- [ ] Fail reka bentuk dan eksport PNG disimpan.
- [ ] Kod lulus `qa-check.sh`.
- [ ] Ujian tempatan lulus.
- [ ] Semua keperluan wajib PRD berfungsi.
- [ ] Responsif disahkan pada 390 / 768 / 1024 / 1440.
- [ ] Smoke test production lulus.
- [ ] `HANDOFF.md` lengkap.
- [ ] Tiada rahsia dalam repositori.
