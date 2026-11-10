# Auto Mode Prompt

Copy, replace the parts inside `[...]`, and send it as your first message.

Start with `mula` or `start` (both mean the same thing), then paste the prompt below.

```text
Build [app idea] in full auto mode (auto / full auto / do everything / finish it right away / one-shot).

Requirements:
- Follow this repo's workflow: Phase 1 PRD -> Phase 2 FigCraft -> Phase 3
  responsive code -> Phase 4 local test.
- Do not skip the PRD interview. Ask one question per message, including
  stack follow-ups, until the answers are detailed enough.
- Choose the stack from the A6 answer; record assumptions only for what
  I explicitly delegate to you.
- Reference images: [projects/<slug>/refs/ or none].
- Code must be responsive 360-1920px, with no dead buttons and no dark mode.
- Run qa-check.sh and test-local.sh --check; do not report success without
  real output.
- Stop before deploy, payments, DNS changes, or production accounts.

Report at the end: PRD, design, code files, test results, blockers.
```
