# Phase 0 — Auto Mode (One-Shot)

Auto mode lets the user give the idea once, then the agent runs
Phases 1–4 without approval gates between phases. The workflow does not change.
The PRD interview stays MANDATORY and must be detailed; auto mode only removes
the approval gates after the PRD.

## Trigger

`mula` / `start` starts the workflow. The phrases that enable auto mode:

```text
auto
full auto
do everything
finish it right away
one-shot
```

Phase 0 preflight runs once before the interview; auto mode never skips it.

The agent also accepts the equivalent Malay phrases for these triggers.

If the first message contains these phrases, the agent confirms in ONE line:

> "Auto mode: full interview, Phases 1–4, stop before deploy. Assumptions will be recorded."

Then start the PRD interview: one question per message. After the answers are
complete, keep working without approval gates between phases.

## Principles

1. **Idea = interview starting point.** The agent must ask detailed questions
   one by one before writing the PRD.
2. **Interview is mandatory.** No skipping even if the user writes `auto`.
   Exact details produce a better system.
3. **Same workflow.** PRD → FigCraft → code → test. No phase is skipped.
4. **Assumptions must be visible.** Every gap is marked `[ASSUMPTION]` in PRD
   Chapter 5 and listed in the final summary.
5. **Stop before irreversible actions.** Production deploy,
   payments, DNS, data deletion, and production credentials need
   separate permission.
6. **Evidence, not claims.** Never report done without `qa-check` and
   `test-local` output.
7. **Blockers are capped.** If something fails, try to fix it at most 3 times,
   then stop and report the real blocker.

## Auto steps

### 1. Create the project

```bash
bash skrip/new-project.sh <slug> [A-K]
```

The slug is generated from the idea. If the stack is not stated, choose using
the table below and record the reason.

### 2. Choose the stack

| Signal from the idea | Stack |
| --- | --- |
| Internal tool, Google Workspace, small data, no complex auth | A GAS |
| Needs auth + Postgres + RLS + Storage + realtime | B Supabase |
| Edge API, global traffic, D1/KV/R2, static assets | C Worker |
| Realtime sync, fast auth, simple hosting | D Firebase |
| Serverless Postgres, branching, separate API | E Neon |
| Two clear requirements from the list above | F Hybrid |
| SSR, SEO, UI + API in one Next.js project | G Next.js |
| Custom Node API, VPS/Dokploy deploy | H Node/Express |
| PHP, admin panel, MySQL, VPS/Dokploy | I Laravel |
| Python API, Django or FastAPI admin | J FastAPI/Django |
| One Flutter codebase for responsive web and Android/iOS | K Flutter |

If two choices are nearly equal, pick the one with the fewest services to
maintain. Record the choice and the rejected alternatives in PRD Chapter 6.

### 3. Auto PRD

- Run Part A of `TEMPLATE_PRD_MS.md`: one question per message,
  including the A8 follow-up questions. Do not merge or skip questions.
- Dig into vague answers with follow-up questions before moving on.
- Answer A1–A10 based on the user's real answers, not default values.
- Mark `[ASSUMPTION]` only for things the user deliberately leaves to you.
- Things that truly cannot be decided go into Chapter 16 (TBD).
- Save `prd/PRD-v0.1.md`.
- After the answers are complete, generate the PRD and continue Phases 2–4 without stopping.
- Still show the PRD summary and the assumption list in the final report.

### 4. Auto FigCraft

- FigCraft MUST use **live edit** mode: `figcraft-app` / `figcraft-cli mcp
  --attach 7979`.
- If port 7979 is not active, stop and ask the user to open
  `figcraft --control 7979`. Do not use headless as a substitute.
- Read PRD Chapter 12 and the images in `refs/` yourself.
- Build all screens with one script.
- Export PNG and check the images. Fix until no text overlaps or
  is cut off.
- Save `design/design.figcraft`.

### 5. Auto code

- Follow `aliran-kerja/03-codegen.md`.
- Responsive 360–1920px, even if the reference is mobile.
- No dead buttons, no placeholders, no secrets in the frontend.
- Every screen has loading, empty, error.
- One module at a time: build it, test it, commit it, record it in the
  `STATUS.md` Modules table.

```bash
bash skrip/test-local.sh <slug> --check --path /<module-route>
bash skrip/git-save.sh <slug> "feat(module-<n>): <name> + tests"
```

- A module is finished only when its test passes and the commit exists.
- `projek/<slug>/.git` is the project's own repository; never commit `.env`,
  `.dev.vars`, keys, or personal data.

### 6. Auto test

```bash
bash skrip/qa-check.sh <slug>
bash skrip/security-audit.sh <slug>
bash skrip/test-local.sh <slug> --check
```

- `qa-check` must show 0 failures.
- `security-audit` must show 0 `FAIL`; every `WARN` needs a recorded decision.
- `test-local --check` must return HTTP 200 for every module route.
- Check responsiveness at 390 / 768 / 1024 / 1440 if a browser is available.
- If it fails: fix the cause, repeat. At most 3 rounds.
- If it still fails: save the work, write the blocker, stop.

### 6b. Auto security gate

Follow `aliran-kerja/06-security-audit.md` — Phase 4.5 never runs in the
background:

- Write `security/THREAT-MODEL.md`, then hunt the attack classes that apply.
- Record `confirmed` / `needs_validation` / `rejected` findings in
  `security/findings.json` with CVSS severity, and write `security/REPORT.md`.
- Fix at the last trusted decision point, add a regression test, and commit with
  `bash skrip/git-save.sh <slug> "fix(security): ..."`.
- Never test production, shared services, third parties, or real personal data.
- Auto mode does not lower this bar; it only removes per-phase approval gates.

### 7. Final report

Before stopping, report:

| Item | Content |
| --- | --- |
| Slug & stack | `projek/<slug>`, stack code |
| PRD | file link + 3 main assumptions |
| Design | `.figcraft` link + PNG count |
| Code | list of main files |
| Modules | module, route, test evidence, commit id |
| Test | brief `qa-check` + `security-audit` + `test-local` output |
| Security | findings fixed, remaining `WARN` decisions, `security/REPORT.md` |
| Blocker | what is blocking, next step |
| Not done | deploy, accounts, domain |

## Limits of auto mode

What CANNOT be done without user input:

- Create Google / Supabase / Cloudflare / Firebase / Neon accounts.
- Log in to CLIs that require a browser.
- Enter payment cards or upgrade plans.
- Deploy production to the user's account.
- Change DNS or the domain.
- Delete production data.
- Guess real credentials or URLs.
- Run fully human-interaction tests without a browser tool.

If one of these is needed, stop and ask ONE question that
combines all the requirements, not one repeated question.

## `auto deploy` mode

Only if the user writes `auto deploy` AND the credentials already exist:

1. Run Phase 5.
2. Deploy staging first if one exists.
3. Smoke test production.
4. Do not create new paid resources without permission.
5. If login is needed, stop and ask the user to log in.

## Gate summary

| Phase | Manual mode | Auto mode |
| --- | --- | --- |
| PRD | Full interview, show, wait for pass | Full interview, generate, continue after complete answers |
| FigCraft | Show, wait for review | Build, check PNG yourself, continue |
| Code | Wait for instructions | Continue |
| Test | Run, report | Run, fix, report |
| Deploy | Wait for instructions | Stop before deploy |
