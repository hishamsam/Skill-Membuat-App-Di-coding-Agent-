# WebApp Builder — PRD → FigCraft → Code → Test → Handoff

One workflow for building an application from a rough idea:

```text
Idea + reference images
   ↓  Phase 1  TEMPLATE_PRD_MS.md
PRD (Single Source of Truth)
   ↓  Phase 2  FigCraft live MCP
Design + PNG export
   ↓  Phase 3  responsive code
Application
   ↓  Phase 4  local test
   ↓  Phase 5  HANDOFF + deploy
Done
```

The backend can be GAS, Supabase, Cloudflare Worker, Firebase, Neon, Next.js,
Node/Express, Laravel, FastAPI/Django, or Flutter (Web + Android/iOS).
The frontend stays one responsive app from 360px to 1920px.

**Full usage guide: [`PANDUAN.html`](PANDUAN.html) (HTML) · [`PANDUAN.md`](PANDUAN.md) (Markdown).**

---

## How to use — 3 steps

### 1. Download the repo

```bash
git clone https://github.com/hishamsam/idea-to-app-skill.git
cd idea-to-app-skill
```

No git? Use the GitHub CLI or the ZIP:

```bash
gh repo clone hishamsam/idea-to-app-skill

curl -L -o skill.zip https://github.com/hishamsam/idea-to-app-skill/archive/refs/heads/main.zip
unzip skill.zip
cd idea-to-app-skill-main
```

Windows PowerShell, no unzip needed:

```powershell
Invoke-WebRequest -Uri https://github.com/hishamsam/idea-to-app-skill/archive/refs/heads/main.zip -OutFile skill.zip
Expand-Archive -Path skill.zip -DestinationPath .
Set-Location idea-to-app-skill-main
```

### 2. Open an AI agent in that folder

Any agent: opencode, Claude Code, Codex, Cursor, Gemini CLI.
The agent reads the repo instruction files automatically (`AGENTS.md`,
`CLAUDE.md`, `GEMINI.md`, `.cursor/rules/mula.mdc`).

If the agent does not read them automatically, type this once:

```text
Read AGENTS.md and follow it completely.
```

### 3. Type `mula` or `start`

```text
mula
```

Or go straight to the idea:

```text
mula build an office vehicle booking system
```

The agent then asks one question at a time until the project is finished:

```text
Question → PRD → approval → design → code → test → handoff
```

The agent stops before deploy and asks for permission.

---

## What `mula` does

| Step | Action |
| --- | --- |
| 1 | Scans the machine (`bash skrip/preflight.sh --install --json`, or `skrip/preflight.ps1` on Windows) |
| 2 | Installs the missing tools it can install unattended; never prompts for a password |
| 3 | Reports every tool with status, version, action, and hint |
| 4 | Continues to the PRD interview — no tooling is needed for Phase 1 |
| 5 | After the A6 stack answer, reruns with `--stack <CODE>` for the stack tools |
| 6 | Asks for one agent-session restart when a tool was installed but `PATH` is stale |

Installable automatically: git, curl, unzip, node, npm, python3, java, psql,
php, composer (apt, dnf, pacman, zypper, apk, Homebrew, or winget).
Reported but manual: FigCraft + `figcraft-cli`, Docker, Flutter.
Details: [`aliran-kerja/00-mula.md`](aliran-kerja/00-mula.md).

---

## How to answer questions

| You type | The agent does |
| --- | --- |
| `A` / `B` / `C` | Takes that option, asks the next question |
| `B, reason is Google Workspace` | Option plus a note that goes into the PRD |
| `D: students, teachers, admins` | Uses your list |
| `A1:A, A2:C, A4:B` | Answers several questions at once |
| `follow your recommendation` | Picks reasonable values, marks `[ASSUMPTION]` |
| A detailed answer (e.g. "Bookings need supervisor approval; keep 5 years") | More precise PRD, fewer assumptions |
| `PRD OK` | Approves the PRD, continues to design and code |

Answer one question per message. The agent never merges questions, and it asks
follow-ups when an answer is vague. A full interview produces a better system.

`auto` mode does not skip the interview. It only removes the approval gates
between phases after the PRD is complete:

```text
auto build a vehicle booking system, reference projek/booking/refs/dashboard.png
```

Full prompt: [`templat/PROMPT-AUTO.md`](templat/PROMPT-AUTO.md).

---

## Manual commands (optional)

The agent does all of this itself. Use these only if you want to control a step.

| Command | Purpose |
| --- | --- |
| `bash skrip/preflight.sh [--install] [--json] [--stack A-K]` | Scan (and install) tools, FigCraft, port 7979, MCP |
| `powershell -NoProfile -ExecutionPolicy Bypass -File skrip/preflight.ps1 -Install -Json` | Same, for native Windows |
| `bash skrip/new-project.sh <slug> A` | Create the project folder (A–K) |
| `bash skrip/qa-check.sh <slug>` | Check code quality |
| `bash skrip/security-audit.sh <slug> [--deps]` | Static security gate before handoff |
| `bash skrip/test-local.sh <slug> --check [--path /route]` | Test the app, per module route |
| `bash skrip/git-save.sh <slug> "<message>"` | Commit the project's local git repository |
| `bash skrip/setup-dokploy.sh` | Optional: install Dokploy for local testing (asks permission) |
| `bash skrip/jalankan-semua.sh <slug> A` | Everything at once |

Full reference: [`PANDUAN.html`](PANDUAN.html).

---

## Module loop: test and commit every module

Build one module at a time — one screen plus its handler, endpoint, and data.
For each module, in this order:

```bash
# 2. test it (repeat --path per module route)
bash skrip/test-local.sh <slug> --check --path / --path /orders

# 3. commit it to the project's own repository
bash skrip/git-save.sh <slug> "feat(module-3): orders list + tests"
```

A module is finished only when its test passes and the commit exists. The real
output and the commit id go into the `STATUS.md` Modules table.

Each project gets its own git repository at `projek/<slug>/.git`, created by
`new-project.sh`. The skill repo ignores `projek/*`, so project history never
mixes with skill history, and every change is traceable to a module, a fix, or an
audit finding.

## Security gate (Phase 4.5)

Before handoff, the project must pass the gate in
[`aliran-kerja/06-security-audit.md`](aliran-kerja/06-security-audit.md):

```bash
bash skrip/security-audit.sh <slug>    # static rules: secrets, injection, RLS, CORS, cookies, authz, CSRF, uploads
```

- `FAIL` blocks handoff: fix it and rerun.
- `WARN` is a candidate: confirm or reject it with a source trace.
- Then write `security/THREAT-MODEL.md`, hunt by attack class (OWASP WSTG/ASVS),
  record `confirmed` / `needs_validation` / `rejected` findings with CVSS severity,
  and write `security/REPORT.md`.
- Never test production, third parties, or real personal data.

## Repository layout

```text
GAS Skill/
├── AGENTS.md                 # start instructions for the AI agent
├── CLAUDE.md                 # alias for Claude Code
├── GEMINI.md                 # alias for Gemini CLI
├── .cursor/rules/mula.mdc    # alias for Cursor
├── SKILL.md                  # main skill (agent instructions)
├── TEMPLATE_PRD_MS.md        # PRD generator: interview + template
├── figcraft-fast-SKILL.md    # how to script FigCraft fast
├── README.md                 # this file
├── LICENSE                   # MIT
├── PANDUAN.md                # complete usage guide
├── PANDUAN.html              # HTML version with search
├── aliran-kerja/
│   ├── 00-mula.md            # Phase 0 bootstrap (mula / start)
│   ├── 00-auto.md
│   ├── 01-prd.md
│   ├── 02-design-figcraft.md
│   ├── 03-codegen.md
│   ├── 04-local-test.md
│   ├── 05-handoff.md
│   └── 06-security-audit.md
├── pemasangan/                    # MCP setup (separate folder)
│   ├── 01-opencode-mcp.md
│   ├── 02-figcraft.md
│   ├── 03-gas.md
│   ├── 04-supabase.md
│   ├── 05-cloudflare-worker.md
│   ├── 06-firebase.md
│   ├── 07-neon.md
│   ├── 08-dokploy.md
│   ├── 09-nextjs.md
│   ├── 10-node-express.md
│   ├── 11-laravel.md
│   ├── 12-python.md
│   ├── 13-flutter.md
│   └── mcp.opencode.example.json
├── skrip/
│   ├── tools.tsv              # one catalog for every tool
│   ├── preflight.sh           # scan and install (Linux/macOS/Git Bash)
│   ├── preflight.ps1          # scan and install (native Windows)
│   ├── jalankan-semua.sh
│   ├── new-project.sh
│   ├── test-local.sh
│   ├── qa-check.sh
│   ├── security-audit.sh
│   ├── git-save.sh
│   ├── setup-dokploy.sh
│   ├── build-panduan-html.py
│   └── figcraft/fclib.py
├── templat/
│   ├── HANDOFF.md
│   ├── PROMPT-AUTO.md
│   └── figcraft/build.py
└── projek/                 # output of each project
```

Each project is stored in its own folder:

```text
projek/<slug>/
├── STATUS.md
├── STACK                     # A–K
├── prd/PRD-v0.1.md
├── refs/                     # reference images
├── design/
│   ├── DESIGN-DNA.md
│   ├── build.py
│   ├── design.figcraft
│   └── exports/*.png
├── app/                      # application code
├── security/                 # THREAT-MODEL.md, REPORT.md, findings.json, evidence/
├── tests/                    # test scripts/lists
├── .git/                     # local history: one commit per module
└── HANDOFF.md
```

---

## Auto mode (one-shot)

Give the idea once, and the agent runs Phases 1–4 without approval gates
between phases. The PRD interview stays full and detailed.

Trigger phrases: `auto`, `full auto`, `do everything`, `finish it right away`,
`one-shot`. The equivalent Malay phrases work too.

```text
Build an office vehicle booking system in full auto mode.
Reference: projek/booking/refs/dashboard.png
Responsive code 360-1920px. Run qa-check and test-local --check.
Stop before deploy.
```

Full prompt: [`templat/PROMPT-AUTO.md`](templat/PROMPT-AUTO.md).
Protocol: [`aliran-kerja/00-auto.md`](aliran-kerja/00-auto.md).

What the agent does by itself:

| Phase | Auto |
| --- | --- |
| 1 PRD | Full one-by-one interview, choose the stack, mark `[ASSUMPTION]` |
| 2 FigCraft | Live edit only; ask the user to open port 7979 if needed |
| 3 Code | Generate responsive code, no dead buttons |
| 4 Test | Run, fix up to 3 rounds |
| 5 Deploy | STOP, wait for permission |

Still requires separate permission: production deploy, new accounts,
payments, DNS changes, production data deletion.

---

## The 5 phases

| Phase | Guide | Output | Gate |
| --- | --- | --- | --- |
| 1 PRD | `aliran-kerja/01-prd.md` | `prd/PRD-v0.1.md` | PRD approved |
| 2 Design | `aliran-kerja/02-design-figcraft.md` | `design/design.figcraft` + PNG | UI reviewed |
| 3 Code | `aliran-kerja/03-codegen.md` | `app/` | `qa-check` passes |
| 4 Test | `aliran-kerja/04-local-test.md` | test evidence | all cases pass |
| 4.5 Security | `aliran-kerja/06-security-audit.md` | `security/REPORT.md` | 0 `FAIL`, no open high/critical |
| 5 Handoff | `aliran-kerja/05-handoff.md` | `HANDOFF.md` + deploy | smoke test |

### Phase 1 — PRD

`TEMPLATE_PRD_MS.md` has two parts:

- **Part A:** 10 interview questions, one question per message.
- **Part B:** a 17-chapter PRD template.

The technology question (A6) is mandatory before the PRD is written:

| Code | Option | Best for |
| --- | --- | --- |
| A | GAS + Google Sheets | Internal, small data |
| B | Supabase | Postgres + Auth + RLS |
| C | Cloudflare Worker | Edge API + D1/KV/R2 |
| D | Firebase | Firestore + Auth + realtime |
| E | Neon | Serverless Postgres |
| F | Hybrid | Combination, state the layers |
| G | Next.js + Postgres | SSR + API routes, Vercel |
| H | Node/Express + Postgres | VPS/Dokploy, full control |
| I | Laravel + MySQL | PHP, admin panel, VPS/Dokploy |
| J | FastAPI/Django + Postgres | Python API, VPS/Dokploy |
| K | Flutter Web + Android/iOS | One Dart codebase; responsive web + mobile |

PRD Chapter 12 locks the screens, tokens, and references for FigCraft.
Chapter 13 locks the test commands and acceptance criteria.

### Phase 2 — FigCraft

- **Live edit is MANDATORY** (`figcraft-app`, port 7979). Never use headless.
  If the app is not open, ask the user to run `figcraft --control 7979`.
- For many layers: one `design/build.py` script, not one tool call per layer.
- Export PNGs and save `design.figcraft` in the project folder.
- A mobile reference does not mean mobile-only code. Desktop frames are built too.

### Phase 3 — Code

- Tokens from `DESIGN-DNA.md` go into one configuration.
- Responsive: 360–639 / 640–1023 / 1024–1439 / ≥1440.
- Mobile: bottom nav + 1 column + `pb-24`.
- Desktop: sidebar/top nav + 2–3 columns.
- Zero dead buttons, zero placeholders, zero secrets in the client.

### Phase 4 — Test

| Stack | Command |
| --- | --- |
| GAS | `IS_PREVIEW=true` + `python3 -m http.server` |
| Supabase | dev project (no Docker on this machine) |
| Worker | `npx wrangler dev` |
| Firebase | `npx firebase-tools emulators:start` |
| Neon | `npx wrangler dev` + dev branch |
| Next.js | `npm run dev -- -p 4173` |
| Node/Express | `npm run dev` / `npm start` |
| Laravel | `php artisan serve` |
| FastAPI/Django | `uvicorn` / `manage.py runserver` |
| Flutter | `flutter build web` + static server (`test-local` script) |

```bash
bash skrip/test-local.sh <slug> --check
bash skrip/qa-check.sh <slug>
bash skrip/security-audit.sh <slug>
```

Optional: `bash skrip/setup-dokploy.sh` for local testing through Dokploy.
Ask permission first; if declined, skip it and test manually.

### Phase 5 — Handoff

- Fill in `HANDOFF.md`.
- Deploy per stack.
- Production smoke test.
- Mark `STATUS.md` as done.

---

## MCP setup

Every setup instruction lives in a separate folder: **`pemasangan/`**.

| Document | Content |
| --- | --- |
| `pemasangan/01-opencode-mcp.md` | `opencode.json` format, registering servers |
| `pemasangan/02-figcraft.md` | Live mode (required), port 7979 |
| `pemasangan/03-gas.md` | GAS, clasp, preview mode |
| `pemasangan/04-supabase.md` | Supabase MCP, dev project, RLS |
| `pemasangan/05-cloudflare-worker.md` | Cloudflare MCP, wrangler, D1 |
| `pemasangan/06-firebase.md` | Firebase MCP, emulators, rules |
| `pemasangan/07-neon.md` | Neon MCP, serverless driver |
| `pemasangan/08-dokploy.md` | Dokploy for local testing (optional) |
| `pemasangan/09-nextjs.md` | Next.js + Postgres, Vercel |
| `pemasangan/10-node-express.md` | Node/Express + Postgres, VPS/Dokploy |
| `pemasangan/11-laravel.md` | Laravel + MySQL, VPS/Dokploy |
| `pemasangan/12-python.md` | FastAPI/Django + Postgres |
| `pemasangan/13-flutter.md` | Flutter Web + Android/iOS, web testing |

Ready-to-paste config: `pemasangan/mcp.opencode.example.json`.

Check:

```bash
opencode mcp list
ss -ltnp | grep 7979
```

---

## Image reference modes

| Mode | Meaning | When |
| --- | --- | --- |
| Structural (default) | Take structure, density, navigation; colours may change | Own branding |
| Pixel-faithful | Follow grid, scale, radius almost 1:1 | Want it almost identical |
| Mood | Take tone/colour/material only | Vibe only |

What is taken: the visual system. What is not: logos, trademarks, illustrations,
stock photos, avatars, copyrighted text.

---

## Example prompts

**Start a project:**

> `mula` Build a vehicle booking system. Reference `refs/dashboard.png`. Use
> `TEMPLATE_PRD_MS.md`, stack Supabase. Generate the PRD first.

**Start with the short trigger:**

> `start`

**Amend the PRD:**

> Add a "Supervisor" role and a `plate_no` field. Regenerate the PRD.

**Approve:**

> PRD OK. Continue to Phase 2 FigCraft.

**Review the UI:**

> Screen S-02 desktop is too dense. Remove cards, keep the table.
> Export again.

**Code:**

> UI approved. Continue to Phase 3. Make sure it is responsive 360–1920 and has
> no dead buttons.

**Test:**

> Run `qa-check.sh` and `test-local.sh --check`, show the results.

---

## Brief standards

| Item | Standard |
| --- | --- |
| PRD | Single source of truth; no code before approval |
| Responsive | 360px–1920px; no horizontal scroll |
| Navigation | Bottom nav on mobile; sidebar/top nav on desktop |
| Buttons | All live, `data-action` + handler |
| UI states | default, loading, empty, error |
| Theme | Light mode only |
| Icons | One library (Lucide) |
| Security | Auth/permissions on the server; no secrets in the client |
| Test | `qa-check` + `test-local --check` per module before handoff |
| History | One local git commit per module, fix, or audit finding |
| Security | `security-audit.sh` 0 `FAIL`, no open high/critical finding |

---

## License

MIT — see [`LICENSE`](LICENSE).
