# Complete Usage Guide

---

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

It supports eleven stacks:

| Code | Stack | Best for |
| --- | --- | --- |
| A | Google Apps Script + Google Sheets | Internal tools, small data, Google Workspace |
| B | Supabase | Postgres, Auth, RLS, Storage, SaaS apps |
| C | Cloudflare Worker | Edge APIs, D1/KV/R2, static assets |
| D | Firebase | Firestore, Auth, realtime, Hosting |
| E | Neon | Serverless Postgres with a separate API |
| F | Hybrid | Explicit combination of the above |
| G | Next.js + Postgres | SSR, SEO, UI and API in one project |
| H | Node/Express + Postgres | Custom Node API, VPS/Dokploy |
| I | Laravel + MySQL | PHP, admin panel, VPS/Dokploy |
| J | FastAPI/Django + Postgres | Python API, Django admin, VPS/Dokploy |
| K | Flutter (Web + Android/iOS) | One Dart codebase: responsive web and mobile apps |

The frontend is always one responsive app, from 360px to 1920px.

## 2. Requirements

Tool versions are not documented here; `scripts/preflight.sh` (or
`scripts/preflight.ps1` on Windows) reports the versions actually installed on
your machine:

```bash
bash scripts/preflight.sh
```

Required for all projects:

- FigCraft installed and able to run in live mode.
- OpenCode with the FigCraft MCP servers registered.
- A terminal, Node.js, and Python 3.

## 3. Installation

### 3.1 Get the repo

```bash
# Git (recommended)
git clone https://github.com/hishamsam/idea-to-app-skill.git
cd "idea-to-app-skill"

# Or GitHub CLI
gh repo clone hishamsam/idea-to-app-skill

# Or ZIP without git
curl -L -o gas-skill.zip \
  https://github.com/hishamsam/idea-to-app-skill/archive/refs/heads/main.zip
unzip gas-skill.zip
cd idea-to-app-skill-main
```

Windows PowerShell, no git needed:

```powershell
Invoke-WebRequest -Uri https://github.com/hishamsam/idea-to-app-skill/archive/refs/heads/main.zip -OutFile gas-skill.zip
Expand-Archive -Path gas-skill.zip -DestinationPath .
Set-Location idea-to-app-skill-main
```

Allow the scripts to run:

```bash
chmod +x scripts/*.sh
```

### 3.2 Install the tools with preflight

```bash
bash scripts/preflight.sh --install
```

On native Windows, in PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/preflight.ps1 -Install
```

The scanner reads `scripts/tools.tsv` and reports every selected tool. With
`--install` (or `-Install`) it installs what can be installed unattended:

| Tool | Linux | macOS | Windows |
| --- | --- | --- | --- |
| git, curl, unzip, node, npm, python3 | apt/dnf/pacman/zypper/apk | Homebrew | winget |
| java | Package manager | Package manager | `Microsoft.OpenJDK.17` |
| psql, php, composer | Package manager | Package manager | none |
| docker, flutter, FigCraft | Manual | Manual | Manual |

Rules it follows:

- It never prompts for a sudo password. When `sudo -n` is unavailable the row
  is reported as `manual` with the exact command to run yourself.
- It never upgrades an existing runtime. An old Node is reported as `outdated`
  with the exact NodeSource commands.
- Docker, Flutter, and FigCraft are never installed unattended.
- Each install is attempted once per run. A failure is reported, not retried.
- `restartRequired: true` means a tool is installed but not on `PATH` yet:
  restart the agent session.

The last line of output is `PREFLIGHT_JSON <json>`; `--json` prints only that
object. Full contract: `workflow/00-start.md`.

### 3.3 Register the MCP servers

Config file: `~/.config/opencode/opencode.json`

```bash
opencode mcp add figcraft --global -- /usr/bin/figcraft-cli mcp
opencode mcp add figcraft-app --global -- /usr/bin/figcraft-cli mcp --attach 7979
opencode mcp list
```

Or copy the matching blocks from `setup/mcp.opencode.example.json`.
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

### 3.4 Start FigCraft in live mode

```bash
figcraft --control 7979 &
ss -ltnp | grep 7979
```

If the port is not listening, the `figcraft-app` MCP server cannot attach.
Do not edit the OpenCode config to work around this; open the app in live mode.

## 4. Repository layout

```text
WebApp Builder/
├── AGENTS.md                   # agent start instructions
├── SKILL.md                    # main agent instructions
├── TEMPLATE_PRD_MS.md          # PRD generator (interview + template)
├── FIGCRAFT-SCRIPTING.md       # fast FigCraft scripting rules
├── GUIDE.md                    # this guide
├── README.md                   # short quick start
├── LICENSE                     # MIT
├── workflow/                   # phase-by-phase workflows
│   ├── 00-start.md             # Phase 0 bootstrap (mula / start)
│   └── 00-auto.md … 06-security-audit.md
├── setup/                      # MCP and stack setup
├── scripts/                    # preflight scanner + automation scripts
│   ├── tools.tsv               # one catalog for every tool
│   ├── preflight.sh            # scan and install (Linux/macOS/Git Bash)
│   ├── preflight.ps1           # scan and install (native Windows)
│   ├── security-audit.sh       # static security gate
│   └── git-save.sh             # commit the project's local repository
├── templates/                  # HANDOFF + FigCraft build template
└── projects/                   # one folder per project
```

Each project:

```text
projects/<slug>/
├── STATUS.md                 # phase checkboxes
├── STACK                     # A–K
├── prd/PRD-v0.1.md
├── refs/                     # reference images
├── design/
│   ├── DESIGN-DNA.md
│   ├── build.py
│   ├── design.figcraft
│   └── exports/*.png
├── app/                      # code
├── security/                 # THREAT-MODEL.md, REPORT.md, findings.json, evidence/
├── tests/
├── .git/                     # local history: one commit per module
└── HANDOFF.md
```

## 5. Quick start

```bash
# 1. Scan the machine and install the missing tools
bash scripts/preflight.sh --install

# 2. Create a project (A=GAS, B=Supabase, C=Worker, D=Firebase, E=Neon,
#    F=Hybrid, G=Next.js, H=Node, I=Laravel, J=Python, K=Flutter)
bash scripts/new-project.sh sistem-tempahan A

# 3. Put reference images here
cp ~/Downloads/ref.png projects/sistem-tempahan/refs/

# 4. Ask the agent to run Phase 1
#    "Read the idea and refs/. Use TEMPLATE_PRD_MS.md. Generate the PRD."

# 5. After PRD approval, start FigCraft
figcraft --control 7979 &
python3 -I projects/sistem-tempahan/design/build.py --check
python3 -I projects/sistem-tempahan/design/build.py --rehearsal

# 6. After UI approval, generate code and test
bash scripts/qa-check.sh sistem-tempahan
bash scripts/test-local.sh sistem-tempahan --check

# 7. Or run steps 1, 2, 6 in one go
bash scripts/run-all.sh sistem-tempahan A
```

Or skip the manual steps: open any coding agent in this folder and type
`mula` (or `start`), then describe the idea. The agent runs preflight itself,
asks the interview questions one at a time, and stops before deploy.

### All script commands

| Step | Command | Purpose |
| --- | --- | --- |
| 0 | `bash scripts/preflight.sh [--install] [--json] [--stack A-K]` | Report (and install) git, curl, unzip, node, npm, python3, java, psql, php, composer, FigCraft, port 7979, MCP |
| 0 | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/preflight.ps1 -Install -Json` | Same, for native Windows through winget |
| 1 | `bash scripts/new-project.sh <slug> [A-K]` | Create `projects/<slug>/` with starter files |
| 2 | `python3 -I projects/<slug>/design/build.py --check` | Verify the live connection; changes nothing |
| 2 | `python3 -I projects/<slug>/design/build.py --rehearsal` | Rehearse in a clean throwaway document, PNGs in `exports/rehearsal/` |
| 2 | `python3 -I projects/<slug>/design/build.py --save` | Build in a clean document and save `design.figcraft` |
| 2 | `python3 -I scripts/figcraft/test_figcraft_client.py` | Test the FigCraft helper library, headless, no files written |
| 3 | `bash scripts/qa-check.sh <slug>` | Static quality gate |
| 4 | `bash scripts/test-local.sh <slug>` | Serve the app locally |
| 3 | `bash scripts/git-save.sh <slug> "<message>"` | Commit the module to the project's local git |
| 4 | `bash scripts/test-local.sh <slug> --check` | Smoke-test HTTP 200 and stop |
| 4 | `bash scripts/test-local.sh <slug> --check --path /orders` | Also require a module route to answer 200 |
| 4 | `bash scripts/test-local.sh <slug> --port 8080` | Use another port |
| 4.5 | `bash scripts/security-audit.sh <slug> [--deps]` | Static security gate, `SECURITY_JSON` last |
| All | `bash scripts/run-all.sh <slug> [A-K]` | preflight, new-project, qa-check, security-audit, test-local --check |
| Docs | `python3 scripts/build-guide-html.py` | Rebuild `GUIDE.html` from `GUIDE.md` |

### Auto mode (one-shot)

Give the idea once and let the agent run Phases 1–4 without approval gates
between phases. The PRD interview stays full and detailed.

Trigger phrases: `auto`, `full auto`, `do everything`, `finish it right away`,
`one-shot`. The equivalent Malay phrases work too.

```text
Build an office vehicle booking system in full auto mode.
Reference: projects/booking/refs/dashboard.png
Code must be responsive 360-1920px. Run qa-check and test-local --check.
Stop before deploy.
```

| Phase | Auto behaviour |
| --- | --- |
| 1 PRD | Full one-by-one interview, choose the stack, mark `[ASSUMPTION]` gaps |
| 2 FigCraft | Live edit only; ask the user to open port 7979 if it is down |
| 3 Code | Generate the responsive app, no dead buttons |
| 4 Test | Run, fix up to three rounds, report real output |
| 5 Deploy | Stop and wait for explicit approval |

Still requires separate approval: production deploy, new accounts, payments,
DNS changes, production data deletion, production credentials.

Files: `workflow/00-auto.md` and `templates/PROMPT-AUTO.md`.

## 6. Phase 1 — PRD

Files: `TEMPLATE_PRD_MS.md`, `workflow/01-prd.md`.

### What happens

1. The agent creates the project folder and reads any reference images.
2. It runs a structured interview, one question per message: ten main
   questions plus up to four stack follow-ups.
3. Question A6 locks the technology stack.
4. It writes the full PRD to `projects/<slug>/prd/PRD-v0.1.md`.
5. It stops and waits for approval.

If you want speed, still answer one question at a time. "generate directly"
does not skip the interview; it only tells the agent to continue without
per-phase approval after the PRD is complete.

In auto mode the interview is not skipped. The agent asks every question,
one per message, then writes the PRD and continues to Phase 2 without
waiting for approval.

### Interview questions

Questions are written for non-technical users: everyday words, an example, and
one recommendation per question. Each question also has an **Other** option.

| ID | Topic, in plain words |
| --- | --- |
| A1 | Who will use it, and what problem does it solve |
| A2 | Who may see and change what |
| A3 | The one main job, start to end |
| A4 | The main "things" the app keeps (customer, order, request) |
| A5 | What must work in the first version, and what can wait |
| A6 | Where the app and its data should live (mandatory) |
| A7 | Where the website lives, and its address |
| A8 | Up to four follow-ups for the chosen option |
| A9 | Pictures of how it should look, and the main device |
| A10 | How we know it is finished and good enough |

Answer format:

- Reply with a letter: `A`, `B`, `C`, or `D` (A–K for the A6 technology table).
- Add a note: `C, needs two roles`.
- Answer several at once: `A1:A, A2:C, A4:B`.
- Accept the suggestion: `follow your recommendation` (recorded as `[ASSUMPTION]`).
- Your own answer: pick **Other** and write one sentence.
- `auto` does not skip the interview; it removes per-phase approval gates.

Rules the agent must follow:

- One question per message. No merged questions, no full list at once.
- No jargon. Technical words are explained in brackets in everyday words.
- A recommendation is advice, not an answer. It is used only when you say so.
- If a question is not answered, the agent re-asks it in simpler words and does
  not move on. The PRD is never written with a missing answer.

### Technology choices

| Code | Stack | Choose when |
| --- | --- | --- |
| A | GAS + Sheets | Internal team, under ~100 users, under ~10k rows, Google account |
| B | Supabase | Customers sign in, files are uploaded, most web apps |
| C | Cloudflare Worker | Public app, high traffic, small data, fast everywhere |
| D | Firebase | Live updates, mobile apps, easy Google login |
| E | Neon | A real database, with a small program in front |
| F | Hybrid | Two or more services, each doing one clear job |
| G | Next.js + Postgres | Pages plus data in one project; pages found on Google |
| H | Node/Express + Postgres | Own server program, custom logic, full control |
| I | Laravel + MySQL | PHP team, ready admin page |
| J | FastAPI/Django + Postgres | Python team, ready admin page, reports |
| K | Flutter | One code base for website, Android and iPhone |

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

Files: `workflow/02-design-figcraft.md`, `FIGCRAFT-SCRIPTING.md`.

### Rules

- Read PRD Chapter 12 and the actual images in `refs/`. The FigCraft MCP
  cannot see images; the agent must open them.
- Use **live edit mode only** (`figcraft-app`, port 7979). If it is down, stop
  and ask the user to run `figcraft --control 7979`. Do not use headless.
- Write `design/DESIGN-DNA.md`: grid, type, palette, spacing, radius,
  density, signature element.
- Build with one Python script, not one MCP call per layer.
- Export PNGs and look at them. Fix the script and rerun.
- Save the native file as `design/design.figcraft`.

### Phase 2 commands

```bash
# Check the live connection (changes nothing)
python3 -I projects/<slug>/design/build.py --check

# Rehearse in a clean throwaway document, PNGs in exports/rehearsal/
python3 -I projects/<slug>/design/build.py --rehearsal

# Build in a clean document, export to exports/ (unsaved)
python3 -I projects/<slug>/design/build.py

# Build and save design.figcraft
python3 -I projects/<slug>/design/build.py --save
```

`--rehearsal` and `--save` are mutually exclusive. Each run starts a clean
document and reuses the single empty page (renamed to `UI`), so rerunning never
duplicates screens and no `Page 1` is left behind. Top-level frames are placed
left to right automatically; pass `x` only for a deliberate position.

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

### Phase 2 output

```text
design/design.figcraft
design/exports/S-01-mobile.png
design/exports/S-01-desktop.png
design/exports/rehearsal/          # from --rehearsal, safe to delete
```

## 8. Phase 3 — Responsive code

Files: `workflow/03-codegen.md`.

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
| G Next.js | `app/`, `app/api/`, `package.json`, `.env.example` |
| H Node/Express | `app/src/`, `app/server.js`, `package.json`, `.env.example` |
| I Laravel | `app/`, `app/routes/`, `app/resources/views/`, `composer.json` |
| J FastAPI/Django | `app/main.py` or `app/manage.py`, `requirements.txt` |
| K Flutter | `app/lib/main.dart`, `app/pubspec.yaml`, `app/build/web/` |

### Quality gate

```bash
bash scripts/qa-check.sh <slug>
```

The script checks viewport, dark mode, placeholders, buttons vs `data-action`,
responsive classes, secret patterns, PRD presence, and design exports. It
exits non-zero on failures.

### Module loop (test and commit per module)

A module is one screen plus its handler, endpoint, and data. Build it, test it,
commit it, then start the next one:

```bash
bash scripts/test-local.sh <slug> --check --path / --path /<module-route>
bash scripts/git-save.sh <slug> "feat(module-<n>): <module name> + tests"
```

`--path` repeats. Each route must answer 200; a non-200 fails the run. The real
output and the commit id go into the `STATUS.md` Modules table. A module without
a passing test and a commit is not finished.

Each project has its own repository at `projects/<slug>/.git`, created by
`new-project.sh`. The skill repo ignores `projects/*`, so project history stays
separate and every change is traceable to a module, a fix, or an audit finding.

## 9. Phase 4 — Local test

Files: `workflow/04-local-test.md`.

### Phase 4 commands

```bash
bash scripts/test-local.sh <slug>
bash scripts/test-local.sh <slug> --check
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
| G Next.js | `npm run dev -- -p 4173` |
| H Node/Express | `npm run dev` or `npm start` |
| I Laravel | `php artisan serve --host=127.0.0.1 --port=4173` |
| J FastAPI/Django | `uvicorn main:app` or `manage.py runserver` |
| K Flutter | `flutter run -d chrome --web-port 4173`; `--check` builds web and serves `build/web` |

### Optional: Dokploy for local testing

Dokploy is optional. Ask the user for permission before installing it. If the
user declines, skip it and continue with the manual commands above.

```bash
bash scripts/setup-dokploy.sh        # asks y/N
```

The script installs Docker (if missing) and Dokploy on a Linux dev/VPS machine.
It needs root and free ports 80, 443, and 3000. Never run it on production.
If installation fails, report it and continue manual testing.

### Exit criteria for Phase 4

- `test-local --check` returns HTTP 200 for every module route.
- `qa-check` reports 0 failed.
- `security-audit` reports 0 `FAIL`; every `WARN` has a recorded decision.
- The browser checks below are done at 360, 768, 1024, and 1440.

### Security gate (Phase 4.5)

Full contract: `workflow/06-security-audit.md`. The five workflow phases do not
change; this gate sits between Phase 4 and Phase 5.

```bash
bash scripts/security-audit.sh <slug>          # static rules
bash scripts/security-audit.sh <slug> --deps   # plus npm audit (needs the network)
```

| Level | Meaning | Action |
| --- | --- | --- |
| `FAIL` | A control gap visible in source: secret in client, concatenated SQL, missing RLS | Fix it and rerun; the gate stays blocked |
| `WARN` | A candidate needing a human trace | Confirm or reject it with source evidence and record the decision |
| `PASS` | Rule evaluated, no pattern found | none |

Then write `security/THREAT-MODEL.md`, hunt by attack class (OWASP WSTG/ASVS),
record `confirmed` / `needs_validation` / `rejected` findings with CVSS v3.1
severity, fix at the last trusted decision point with a regression test, and write
`security/REPORT.md`. Never test production, shared services, third parties, or
real personal data.

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

Files: `workflow/05-handoff.md`, `templates/HANDOFF.md`.

### Deploy commands

| Stack | Deploy |
| --- | --- |
| GAS | Deploy `Code.gs` as a Web App; upload `index.html` to Vercel |
| Supabase | `npx supabase link --project-ref <ref>` then `npx supabase db push` |
| Worker | `npx wrangler d1 execute ... --remote`, `npx wrangler secret put`, `npx wrangler deploy` |
| Firebase | `npx firebase-tools deploy --only hosting,firestore:rules,firestore:indexes` |
| Neon | Deploy the API, run migrations on the production branch |
| Hybrid | Deploy each layer separately |
| Flutter | `flutter build web` → Vercel/Pages; `flutter build appbundle`; `flutter build ipa` (macOS) |

### Handoff contents

- Production and staging URLs.
- Admin account and password-change procedure.
- Environment variable names, never values.
- Local run and deploy commands.
- Backup and rollback steps.
- Known limits and future work.
- Links to PRD, design file, and exports.
- Security summary: findings fixed, decisions on remaining `WARN`s, any
  `needs_validation` lead, and the path to `security/REPORT.md`.
- The module table from `STATUS.md`: module, route, test evidence, commit id.

### Production smoke test

1. Open the production URL.
2. Log in with the real account.
3. Perform one create, read, update, and delete.
4. Submit one invalid input and confirm a clear error.

## 11. Script reference

| Script | Purpose |
| --- | --- |
| `scripts/tools.tsv` | Single tool catalog read by both preflight scanners |
| `scripts/preflight.sh` | Scan and install tools (Linux, macOS, Git Bash) |
| `scripts/preflight.ps1` | Scan and install tools (native Windows, winget) |
| `scripts/run-all.sh <slug> [A–K]` | Run preflight, project creation, QA, and local test in one command |
| `scripts/setup-dokploy.sh` | Optional: install Dokploy for local testing (asks permission first) |
| `scripts/new-project.sh <slug> [A–K]` | Create the project folder and starter files |
| `scripts/qa-check.sh <slug>` | Static quality gate |
| `scripts/security-audit.sh <slug> [--json] [--deps]` | Static security gate before handoff |
| `scripts/git-save.sh <slug> "<message>"` | Commit the project's local git repository |
| `scripts/test-local.sh <slug> [--check] [--path /route]` | Run the local server, optionally smoke-test routes and stop |
| `scripts/figcraft/figcraft_client.py` | FigCraft Python helpers |
| `scripts/figcraft/test_figcraft_client.py` | Headless regression test for the helpers |
| `templates/figcraft/figcraft_build.py` | Starter FigCraft build script |
| `scripts/build-guide-html.py` | Regenerate `GUIDE.html` from this file |

Useful flags:

```bash
bash scripts/test-local.sh <slug> --port 8080
python3 -I projects/<slug>/design/build.py --check
python3 -I projects/<slug>/design/build.py --rehearsal
python3 -I projects/<slug>/design/build.py --save
python3 -I scripts/figcraft/test_figcraft_client.py
```

## 12. Documentation map

| Document | Read it when |
| --- | --- |
| `README.md` | First overview |
| `SKILL.md` | Agent behaviour and engineering standards |
| `FIGCRAFT-SCRIPTING.md` | Fast FigCraft scripting rules |
| `TEMPLATE_PRD_MS.md` | Phase 1 interview and PRD format |
| `workflow/00-start.md` | Phase 0 bootstrap: trigger, preflight, result rules |
| `workflow/00-auto.md` | Auto mode: trigger, limits, report |
| `workflow/01-prd.md` | Step-by-step Phase 1 |
| `workflow/02-design-figcraft.md` | Step-by-step Phase 2 |
| `workflow/03-codegen.md` | Phase 3 rules and file layouts |
| `workflow/04-local-test.md` | Phase 4 test matrix |
| `workflow/05-handoff.md` | Phase 5 deploy and handoff |
| `workflow/06-security-audit.md` | Security gate: threat model, hunt, severity, report |
| `templates/PROMPT-AUTO.md` | Copy-paste auto mode prompt |
| `setup/01-opencode-mcp.md` | OpenCode MCP config |
| `setup/02-figcraft.md` | FigCraft live mode (required) and headless reference |
| `setup/03-gas.md` | GAS setup |
| `setup/04-supabase.md` | Supabase setup |
| `setup/05-cloudflare-worker.md` | Cloudflare setup |
| `setup/06-firebase.md` | Firebase setup |
| `setup/07-neon.md` | Neon setup |
| `setup/08-dokploy.md` | Optional Dokploy for local testing |
| `setup/09-nextjs.md` | Next.js + Postgres |
| `setup/10-node-express.md` | Node/Express + Postgres |
| `setup/11-laravel.md` | Laravel + MySQL |
| `setup/12-python.md` | FastAPI/Django + Postgres |
| `setup/13-flutter.md` | Flutter Web + Android/iOS setup |

## 13. Troubleshooting

| Symptom | Cause | Fix |
| --- | --- | --- |
| `can't reach 127.0.0.1:7979` | App not in live mode | `figcraft --control 7979 &` |
| FigCraft tools missing in OpenCode | Session started before MCP was ready | Restart OpenCode |
| Port 4173 already in use | Old test server still running | `bash scripts/test-local.sh <slug> --port 4174` |
| `qa-check` fails on placeholder | PRD or code still has `{{...}}` / `TODO` | Replace them with real content |
| `qa-check` fails on dead buttons | More `<button>` than `data-action` | Add handlers |
| Supabase local fails | Docker not installed | Use a free cloud dev project |
| Neon connection fails locally | `psql` not installed | Use the Node migration script |
| Firebase emulator will not start | Java missing or wrong version | Install Java 17+ |
| Wrangler deploy asks for login | No Cloudflare session | `npx wrangler login` |
| FigCraft text looks wrong | Missing font | `f.cmd('text.missingFonts')` |
| Renamed folder breaks a path | Scripts resolve from repo root | Run commands from the repo, or use full paths |
| `flutter: command not found` | Flutter SDK missing from PATH | Install the SDK, then `flutter config --enable-web` |
| `preflight` reports `manual` | The tool needs a password, a GUI, or a manual package | Run the printed `action` command yourself, then rerun preflight |
| `preflight` reports `restartRequired: true` | A tool was installed but `PATH` is stale | Restart the agent session, then type `mula` again |
| FigCraft is missing on native Windows | No Windows build of FigCraft here | Run Phase 2 in WSL2 Ubuntu or on a Linux/macOS host |
| `security-audit` reports `FAIL` | A control gap is visible in source | Fix it, then rerun the audit; the gate stays blocked |
| `security-audit` reports `WARN` | Candidate needing a human trace | Confirm or reject it with source evidence and record the decision |
| Module test fails with 404 | Route not implemented or wrong path | Build the route or fix `--path`, then rerun |
| `git-save` says "No changes to commit" | Nothing changed since the last commit | Continue with the next module |
| `preflight` reports `outdated` for node | Node older than 20 is installed | Run the printed NodeSource commands; preflight never upgrades it |

## 14. Example prompts

**Start a project**

> `mula` Build an office vehicle booking system. Use `TEMPLATE_PRD_MS.md` and
> stack Supabase. Reference `projects/booking/refs/dashboard.png`. Generate the
> PRD first.

**Start with the short trigger**

> `start`

The agent runs the Phase 0 preflight, reports what it installed, then asks the
first interview question.

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
- [ ] Every module has a passing test and a local git commit.
- [ ] `security-audit.sh` exits 0 and `security/REPORT.md` is written.
- [ ] No open `confirmed` high or critical finding.
- [ ] Local smoke test passes.
- [ ] All mandatory PRD requirements work.
- [ ] Responsive verified at 390 / 768 / 1024 / 1440.
- [ ] Production smoke test passes.
- [ ] `HANDOFF.md` complete.
- [ ] No secrets in the repository.
