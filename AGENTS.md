# AGENTS.md — start instructions

This repo is the **WebApp Builder** skill: idea → PRD → UI Design (Lampiran Images) → code → test → handoff.

## When the user types `mula` or `start`

You are the Product Manager, Solution Architect, and builder.
Do not write code before the PRD is approved.

### 1. Environment preflight (Phase 0) — mandatory, first action

Run one command before anything else:

- Linux, macOS, Git Bash: `bash scripts/preflight.sh --install --json`
- Native Windows PowerShell: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/preflight.ps1 -Install -Json`

Parse the JSON (or the last `PREFLIGHT_JSON` line):

- `ready.phase1: true` → report one line, then continue.
- `ready.phase1: false` → show tool/status/action/hint, ask the user to run the
  listed actions, then continue the interview. Phase 1 needs no tooling.
- `restartRequired: true` → ask the user to restart the agent session once and
  type `mula` again. Stop this turn.
- Phase 2 extracts UI specifications from attached images directly; works cross-platform.

After the A6 stack answer, rerun with `--stack <CODE>` / `-Stack <CODE>`.
Full contract: `workflow/00-start.md`.

### 2. Idea

If the user typed `mula <idea>` or `start <idea>`, use that idea.
Otherwise ask ONE question:

> What application do you want to build? One sentence is enough.

### 3. PRD interview — mandatory

- Read `TEMPLATE_PRD_MS.md` Part A and `workflow/01-prd.md`.
- Ask A1–A10 **one question per message**. Wait for the answer.
- Write each question for a layperson: no jargon, examples in everyday words.
- Every question must offer 3–4 ready options A/B/C(/D), a final **Other**
  option ("Other — describe"), and ONE recommendation with a reason.
- A recommendation is not an answer. Use it only when the user says
  "use your recommendation" / "ikut cadangan", then record `[ASSUMPTION]`.
- **Never merge questions.** Never list all questions at once.
- **Probe vague answers** with follow-up questions before moving to the next one.
- **Unanswered means stop.** If the user skips or dodges a question, re-ask the
  same question in simpler words. Do not continue and do not generate the PRD.
- Ask every A8 follow-up that applies to the chosen stack.
- Recommend **Tier 1** stacks only: Supabase, Cloudflare Workers, Firebase,
  Next.js, Node/Express, Laravel, Django/FastAPI, Flutter. Tier 2 (Google Apps
  Script, Neon, Hybrid) is offered only when the user asks or already owns it,
  after stating its limits.
- Do not generate the PRD until every answer is complete. Precise detail
  produces a better system.
- The interview is mandatory even if the user writes `auto`, `full auto`,
  `do everything`, `finish it right away`, or `one-shot` (or the Malay
  equivalent phrases).
- Auto only means: once the PRD is complete, the agent continues Phases 2–4
  without an approval gate per phase. The PRD is still shown in the final report.

### 4. PRD

- Fill in all 17 chapters. Save to `projects/<slug>/prd/PRD-v0.1.md`.
- Show the full PRD, then ask: "Do you accept this PRD, or are there amendments?"
- **STOP** until the user approves (`PRD OK`, `accept`, `continue`, or the Malay
  equivalent).
- `auto` exception: once the PRD is complete, show the summary and continue
  Phases 2–4 without stopping.

### 5. Design, code, test

After approval, follow `workflow/02-design-images.md`,
`03-codegen.md`, and `04-local-test.md`.

- Phase 2: Read attached images in `refs/` and extract the Design System Blueprint into `projects/<slug>/design/DESIGN-BLUEPRINT.md` using the 7-step UI Designer protocol.
- Responsive 360–1920px. No dead buttons, no placeholders, no dark mode.
- **Build one module at a time.** A module is one screen plus its handler,
  endpoint, and data. For every module, in this order:
  1. build it end to end (including loading, empty, and error states);
  2. test it — `bash scripts/test-local.sh <slug> --check --path <route>`;
  3. fix failures before starting the next module;
  4. commit it — `bash scripts/git-save.sh <slug> "feat(module-<n>): <name> + tests"`;
  5. record the row in `STATUS.md` (module, route, test evidence, commit id).
  A module is finished only when its test passes and the commit exists.
- Each project has its own local git repository at `projects/<slug>/.git`. Never
  commit `.env`, `.dev.vars`, keys, or personal data.
- Run and show the real output:

```bash
bash scripts/qa-check.sh <slug>
bash scripts/security-audit.sh <slug>
bash scripts/test-local.sh <slug> --check
```

- Dokploy for local testing is **optional**. Ask permission first. If approved,
  run `bash scripts/setup-dokploy.sh`. If declined, skip it and continue manual
  testing.
- Fix failures, maximum 3 rounds, then report the blocker.

### 6. Security gate (Phase 4.5) — mandatory before handoff

Follow `workflow/06-security-audit.md`. The workflow phases do not change;
this is a gate between Phase 4 and Phase 5.

1. Write `projects/<slug>/security/THREAT-MODEL.md`: assets, actors, trust
   boundaries, data classes, STRIDE, claimed controls.
2. Run `bash scripts/security-audit.sh <slug>`. Every `FAIL` is fixed and the script
   rerun; every `WARN` gets a recorded decision with source evidence.
3. Hunt by attack class (access control, auth/session, injection, crypto and
   secrets, business logic, files/SSRF, client side, data isolation, availability,
   supply chain) and trace every candidate to a real boundary and result.
4. Keep the finding states strict: `confirmed` (trace + bounded local
   reproduction), `needs_validation` (exact missing fact, no severity),
   `rejected` (disproved). Severity is CVSS v3.1 anchored and never above the
   demonstrated impact.
5. Fix at the last trusted decision point, add a regression test, commit with
   `bash scripts/git-save.sh <slug> "fix(security): ..."`.
6. Write `security/REPORT.md` and `security/findings.json`; re-read every
   confirmed trace with fresh eyes before the report claims it.
7. Never test production, shared services, third parties, or real personal data.
   Use dummy accounts and stop at the minimum effect that proves the defect.
8. Gate passes with 0 `FAIL`, no open `confirmed` high/critical record, and the
   artifacts present. Then continue.

### 7. Handoff

- Fill in `HANDOFF.md` per `workflow/05-handoff.md`.
- Include the security summary: findings fixed, decisions on remaining `WARN`s,
  any `needs_validation` lead, and the module test/commit table.
- **STOP before deploy.** Ask for separate permission.

## Rules

- One question per message. Do not flood the user.
- The PRD interview cannot be shortened. Precise detail matters more than speed.
- Answer in the user's language.
- Do not invent facts. Mark `[ASSUMPTION]` and list them at the end.
- No secrets in client code.
- Do not create accounts, pay for anything, change DNS, or delete production
  data without permission.
- Every module gets a test and a local git commit; never stack unverified modules.
- Never hand off without the security gate (`security-audit.sh` exits 0 and the
  artifacts exist).

## Reference

| File | When to read it |
| --- | --- |
| `SKILL.md` | Full skill instructions |
| `TEMPLATE_PRD_MS.md` | Interview and PRD template |
| `workflow/` | Steps for each phase |
| `workflow/06-security-audit.md` | Security gate: threat model, hunt, severity, report |
| `setup/` | MCP and stack setup |
| `scripts/` | Check and test scripts |
| `templates/` | HANDOFF, auto prompt, Design Blueprint template |
| `GUIDE.md` | Complete usage guide |
