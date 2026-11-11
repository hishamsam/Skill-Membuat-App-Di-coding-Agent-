# WebApp Builder — PRD → UI Design (Lampiran Images) → Code → Test → Handoff

One workflow for building an application from a rough idea:

```text
Idea + reference images
   ↓  Phase 1  TEMPLATE_PRD_MS.md
PRD (Single Source of Truth)
   ↓  Phase 2  UI Designer (Lampiran Images)
Design System Blueprint (DESIGN-BLUEPRINT.md)
   ↓  Phase 3  responsive code
Application
   ↓  Phase 4  local test
   ↓  Phase 5  HANDOFF + deploy
Done
```

The backend can be Supabase, Cloudflare Workers, Firebase, Next.js, Node/Express,
Laravel, Django/FastAPI, or Flutter (web + Android/iOS). The workflow recommends
only these industry-standard stacks; the older options (Google Apps Script,
Neon, Hybrid) exist only for projects that already own them.
The frontend stays one responsive app from 360px to 1920px.

**Full usage guide: [`GUIDE.md`](GUIDE.md).**

---

## How to use — 3 steps

### 1. Download the repo

```bash
git clone https://github.com/hishamsam/idea2app.git
cd idea2app
```

No git? Use the GitHub CLI or the ZIP:

```bash
gh repo clone hishamsam/idea2app

curl -L -o skill.zip https://github.com/hishamsam/idea2app/archive/refs/heads/main.zip
unzip skill.zip
cd idea2app-main
```

Windows PowerShell, no unzip needed:

```powershell
Invoke-WebRequest -Uri https://github.com/hishamsam/idea2app/archive/refs/heads/main.zip -OutFile skill.zip
Expand-Archive -Path skill.zip -DestinationPath .
Set-Location idea2app-main
```

### 2. Open an AI agent in that folder

Any agent: opencode, Claude Code, Codex, Cursor, Gemini CLI.
The agent reads `AGENTS.md` automatically when it opens this folder.

If the agent does not read it automatically, type this once:

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
| 1 | Scans the machine (`bash scripts/preflight.sh --install --json`, or `scripts/preflight.ps1` on Windows) |
| 2 | Installs the missing tools it can install unattended; never prompts for a password |
| 3 | Reports every tool with status, version, action, and hint |
| 4 | Continues to the PRD interview — no tooling is needed for Phase 1 |
| 5 | After the A6 stack answer, reruns with `--stack <CODE>` for the stack tools |
| 6 | Asks for one agent-session restart when a tool was installed but `PATH` is stale |

Installable automatically: git, curl, unzip, node, npm, python3, java, psql,
php, composer (apt, dnf, pacman, zypper, apk, Homebrew, or winget).
Reported but manual: Docker, Flutter.
Details: [`workflow/00-start.md`](workflow/00-start.md).

---

## How to answer questions

| You type | The agent does |
| --- | --- |
| `A` / `B` / `C` | Takes that option, asks the next question |
| `B, reason is Google Workspace` | Option plus a note that goes into the PRD |
| `D: students, teachers, admins` | Uses your list |
| `A1:A, A2:C, A4:B` | Answers several questions at once |
| `Other, <one sentence>` | Your own answer when none of the options fit |
| `follow your recommendation` | Picks reasonable values, marks `[ASSUMPTION]` |
| A detailed answer (e.g. "Bookings need supervisor approval; keep 5 years") | More precise PRD, fewer assumptions |
| `PRD OK` | Approves the PRD, continues to design and code |

Answer one question per message. The agent never merges questions, writes each
one in everyday words, offers an **Other** option, and gives one recommendation
with a reason. A recommendation is not an answer. If a question is unanswered,
the agent re-asks it and does not move on.

`auto` mode does not skip the interview. It only removes the approval gates
between phases after the PRD is complete:

```text
auto build a vehicle booking system, reference projects/booking/refs/dashboard.png
```

Full prompt: [`templates/PROMPT-AUTO.md`](templates/PROMPT-AUTO.md).

---

## Manual commands (optional)

The agent does all of this itself. Use these only if you want to control a step.

| Command | Purpose |
| --- | --- |
| `bash scripts/preflight.sh [--install] [--json] [--stack A-K]` | Scan (and install) tools, MCP |
| `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/preflight.ps1 -Install -Json` | Same, for native Windows |
| `bash scripts/new-project.sh <slug> B` | Create the project folder (Tier 1: B, C, D, G–K) |
| `bash scripts/qa-check.sh <slug>` | Check code quality |
| `bash scripts/security-audit.sh <slug> [--deps]` | Static security gate before handoff |
| `bash scripts/test-local.sh <slug> --check [--path /route]` | Test the app, per module route |
| `bash scripts/git-save.sh <slug> "<message>"` | Commit the project's local git repository |
| `bash scripts/setup-dokploy.sh` | Optional: install Dokploy for local testing (asks permission) |
| `bash scripts/run-all.sh <slug> A` | Everything at once |

Full reference: [`GUIDE.md`](GUIDE.md).

---

## Module loop: test and commit every module

Build one module at a time — one screen plus its handler, endpoint, and data.
For each module, in this order:

```bash
# 2. test it (repeat --path per module route)
bash scripts/test-local.sh <slug> --check --path / --path /orders

# 3. commit it to the project's own repository
bash scripts/git-save.sh <slug> "feat(module-3): orders list + tests"
```

A module is finished only when its test passes and the commit exists. The real
output and the commit id go into the `STATUS.md` Modules table.

Each project gets its own git repository at `projects/<slug>/.git`, created by
`new-project.sh`. The skill repo ignores `projects/*`, so project history never
mixes with skill history, and every change is traceable to a module, a fix, or an
audit finding.

## Security gate (Phase 4.5)

Before handoff, the project must pass the gate in
[`workflow/06-security-audit.md`](workflow/06-security-audit.md):

```bash
bash scripts/security-audit.sh <slug>    # static rules: secrets, injection, RLS, CORS, cookies, authz, CSRF, uploads
```

- `FAIL` blocks handoff: fix it and rerun.
- `WARN` is a candidate: confirm or reject it with a source trace.
- Then write `security/THREAT-MODEL.md`, hunt by attack class (OWASP WSTG/ASVS),
  record `confirmed` / `needs_validation` / `rejected` findings with CVSS severity,
  and write `security/REPORT.md`.
- Never test production, third parties, or real personal data.

## Repository layout

```text
WebApp Builder/
├── AGENTS.md                   # start instructions for the AI agent
├── SKILL.md                    # main skill (agent instructions)
├── GUIDE.md                    # complete usage guide
├── README.md                   # this file
├── LICENSE                     # MIT
├── workflow/
│   ├── 00-start.md             # Phase 0 bootstrap (mula / start)
│   ├── 00-auto.md
│   ├── 01-prd.md
│   ├── 02-design-images.md
│   ├── 03-codegen.md
│   ├── 04-local-test.md
│   ├── 05-handoff.md
│   └── 06-security-audit.md
├── setup/                      # MCP and stack setup
│   ├── 01-opencode-mcp.md
│   ├── 02-ui-designer.md
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
├── scripts/
│   ├── tools.tsv               # one catalog for every tool
│   ├── preflight.sh            # scan and install (Linux/macOS/Git Bash)
│   ├── preflight.ps1           # scan and install (native Windows)
│   ├── run-all.sh
│   ├── new-project.sh
│   ├── test-local.sh
│   ├── qa-check.sh
│   ├── security-audit.sh
│   ├── git-save.sh
│   ├── setup-dokploy.sh
│   └── build-guide-html.py     # optional: regenerate GUIDE.html
├── templates/
│   ├── HANDOFF.md
│   ├── PROMPT-AUTO.md
│   └── DESIGN-BLUEPRINT.md
└── projects/                   # output of each project
```


Each project is stored in its own folder:

```text
projects/<slug>/
├── STATUS.md
├── STACK                     # A–K
├── prd/PRD-v0.1.md
├── refs/                     # reference images
├── design/
│   └── DESIGN-BLUEPRINT.md
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
Reference: projects/booking/refs/dashboard.png
Responsive code 360-1920px. Run qa-check and test-local --check.
Stop before deploy.
```

Full prompt: [`templates/PROMPT-AUTO.md`](templates/PROMPT-AUTO.md).
Protocol: [`workflow/00-auto.md`](workflow/00-auto.md).

What the agent does by itself:

| Phase | Auto |
| --- | --- |
| 1 PRD | Full one-by-one interview, choose the stack, mark `[ASSUMPTION]` |
| 2 UI Design | Extract Design System Blueprint from `refs/` |
| 3 Code | Generate responsive code, no dead buttons |
| 4 Test | Run, fix up to 3 rounds |
| 5 Deploy | STOP, wait for permission |

Still requires separate permission: production deploy, new accounts,
payments, DNS changes, production data deletion.

---

## The 5 phases

| Phase | Guide | Output | Gate |
| --- | --- | --- | --- |
| 1 PRD | `workflow/01-prd.md` | `prd/PRD-v0.1.md` | PRD approved |
| 2 Design | `workflow/02-design-images.md` | `design/DESIGN-BLUEPRINT.md` | UI reviewed |
| 3 Code | `workflow/03-codegen.md` | `app/` | `qa-check` passes |
| 4 Test | `workflow/04-local-test.md` | test evidence | all cases pass |
| 4.5 Security | `workflow/06-security-audit.md` | `security/REPORT.md` | 0 `FAIL`, no open high/critical |
| 5 Handoff | `workflow/05-handoff.md` | `HANDOFF.md` + deploy | smoke test |

### Phase 1 — PRD

`TEMPLATE_PRD_MS.md` has two parts:

- **Part A:** 10 interview questions, one question per message.
- **Part B:** a 17-chapter PRD template.

The technology question (A6) is mandatory before the PRD is written. The agent
recommends only **Tier 1** (industry-leading, widely adopted). Tier 2 is offered
only when a project already depends on it.

| Code | Option | Tier | Best for |
| --- | --- | --- | --- |
| B | Supabase (PostgreSQL) | 1 | Managed database, login, file storage, access rules |
| C | Cloudflare Workers | 1 | Fast global API, small data, static pages |
| D | Firebase | 1 | Live updates, mobile apps, easy Google login |
| G | Next.js + PostgreSQL | 1 | Pages plus data in one project, SEO |
| H | Node/Express + PostgreSQL | 1 | Custom API, full control, VPS |
| I | Laravel + MySQL | 1 | PHP team, ready admin page |
| J | Django or FastAPI + PostgreSQL | 1 | Python team, ready admin page, reports |
| K | Flutter (web + Android/iOS) | 1 | One code base for website and phone apps |
| A | Google Apps Script + Sheets | 2 | Very small internal tool only |
| E | Neon | 2 | Database only, with a separate API |
| F | Hybrid | 2 | A combination of services already in use |

PRD Chapter 12 locks the screens, tokens, and references for UI Design.
Chapter 13 locks the test commands and acceptance criteria.

### Phase 2 — UI Design (Lampiran Images)

- Uses `ui-ux/ui-designer.md` as reference protocol.
- Reads attached images (screenshots, mockups, wireframes) in `projects/<slug>/refs/`.
- Extracts 7 key design areas: UI style, color tokens (HEX & Tailwind), typography, layout, component breakdown, visual details/states, and Design System Blueprint.
- Saves `projects/<slug>/design/DESIGN-BLUEPRINT.md`.
- A mobile reference does not mean mobile-only code. Desktop layout is mapped too.
### Phase 3 — Code

- Tokens from `DESIGN-BLUEPRINT.md` go into one configuration.
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
bash scripts/test-local.sh <slug> --check
bash scripts/qa-check.sh <slug>
bash scripts/security-audit.sh <slug>
```

Optional: `bash scripts/setup-dokploy.sh` for local testing through Dokploy.
Ask permission first; if declined, skip it and test manually.

### Phase 5 — Handoff

- Fill in `HANDOFF.md`.
- Deploy per stack.
- Production smoke test.
- Mark `STATUS.md` as done.

---

## MCP setup

Every setup instruction lives in a separate folder: **`setup/`**.

| Document | Content |
| --- | --- |
| `setup/01-opencode-mcp.md` | `opencode.json` format, registering servers |
| `setup/02-ui-designer.md` | UI Designer (lampiran images), Design System Blueprint |
| `setup/03-gas.md` | GAS, clasp, preview mode |
| `setup/04-supabase.md` | Supabase MCP, dev project, RLS |
| `setup/05-cloudflare-worker.md` | Cloudflare MCP, wrangler, D1 |
| `setup/06-firebase.md` | Firebase MCP, emulators, rules |
| `setup/07-neon.md` | Neon MCP, serverless driver |
| `setup/08-dokploy.md` | Dokploy for local testing (optional) |
| `setup/09-nextjs.md` | Next.js + Postgres, Vercel |
| `setup/10-node-express.md` | Node/Express + Postgres, VPS/Dokploy |
| `setup/11-laravel.md` | Laravel + MySQL, VPS/Dokploy |
| `setup/12-python.md` | FastAPI/Django + Postgres |
| `setup/13-flutter.md` | Flutter Web + Android/iOS, web testing |

Ready-to-paste config: `setup/mcp.opencode.example.json`.

Check:

```bash
opencode mcp list
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

> PRD OK. Continue to Phase 2 (UI Design).

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
