# Phase 0 — Bootstrap (`mula` / `start`)

Phase 0 runs before the PRD interview in every mode. It scans the machine,
installs the tools it can install unattended, reports the result, and then the
normal workflow continues unchanged: PRD → FigCraft → code → test → handoff.

`auto`, `full auto`, `do everything`, `finish it right away`, `one-shot`, and
`auto deploy` never skip Phase 0. The Malay trigger phrases are accepted too.

## 1. Trigger

| Input | Meaning |
| --- | --- |
| `mula` | Bootstrap, then ask for the idea |
| `start` | Same as `mula` |
| `mula <idea>` | Bootstrap, then use `<idea>` |
| `start <idea>` | Same as `mula <idea>` |

## 2. Bootstrap commands

| Environment | Command |
| --- | --- |
| Linux / macOS / Git Bash | `bash scripts/preflight.sh --install --json` |
| Native Windows PowerShell | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/preflight.ps1 -Install -Json` |
| Already-configured machine (read-only scan) | Same command without `--install` / `-Install` |

The scanner never prompts for a password. If `sudo -n` is unavailable, the row
is reported as `manual` with the exact command to run by hand.

## 3. Reading the result

The last line of human output is `PREFLIGHT_JSON <json>`; `--json` prints the
JSON object alone. Fields:

| Field | Meaning |
| --- | --- |
| `os` | `linux`, `macos`, or `windows` |
| `packageManager` | `apt`, `dnf`, `pacman`, `zypper`, `apk`, `brew`, `winget`, or `none` |
| `installAttempted` | An install command was executed |
| `ready.phase1` | Phases 1, 3, 4, 5 can run (needs no project tooling beyond the core set) |
| `ready.phase2` | FigCraft is also available |
| `blocking` | Ids of `core` tools that are `missing`, `manual`, or `failed` |
| `restartRequired` | A tool was installed but is not on `PATH` yet |
| `tools[]` | `id`, `tier`, `check`, `status`, `version`, `action`, `hint` |

`status` is one of `ok`, `missing`, `installed`, `outdated`, `manual`,
`failed`, `info`. `action` is a runnable command when one exists; `hint` is the
manual instruction or the failure detail.

Agent rules:

1. `ready.phase1: true` → report one line such as
   `Preflight: ready — node v24.22.1, python3 3.12.3, figcraft ok.` Then continue
   with Phase 1.
2. `ready.phase1: false` → show a table of tool / status / action / hint. Ask
   the user to run the listed `action` lines, then continue the PRD interview:
   Phase 1 needs no project tooling.
3. `restartRequired: true` → stop this turn, ask the user to restart the agent
   session once, then type `mula` again. Do not continue in the same session.
4. `tier: "optional"` rows are reported and never installed, never blocking.
5. `ready.phase2: false` only affects Phase 2. Warn once, then continue.

## 4. Stack pass

After the A6 stack answer, run the same command with the stack code:

```bash
bash scripts/preflight.sh --install --json --stack <CODE>
```

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/preflight.ps1 -Install -Json -Stack <CODE>
```

Report the result and continue Phase 2. `F` (hybrid) matches no stack rows;
rerun once the concrete stacks are fixed in PRD Chapter 6.

## 5. Windows limits

Native Windows reports `ready.phase2: false` because FigCraft has no Windows
build in this repo. Phases 1, 3, 4, and 5 work on Windows. Phase 2 needs WSL2
Ubuntu or a Linux/macOS host. The agent must say this in the bootstrap report.

## 6. Manual actions

Some tools have no unattended installer here:

| Tool | Why |
| --- | --- |
| FigCraft + `figcraft-cli` | Application package, no public installer URL in this repo |
| Docker | Desktop app or system daemon |
| Flutter | SDK archive |
| Anything needing a sudo password | `sudo -n` fails, so the row is `manual` |

Print the exact command or hint from the report. Never guess an installer, never
invent a package name outside `scripts/tools.tsv`, and never download MSI files by
hand on Windows — `winget` is the only Windows installer used.

## 7. Safety limits

Phase 0 never creates accounts, never pays for anything, never changes DNS,
never deletes data, never upgrades an existing runtime (an older Node is
reported as `outdated`), and never installs Docker, Flutter, or FigCraft
unattended.

## 8. Retry policy

Each install is attempted once per run. A failure is reported as `failed` with
the last error line in `hint`; it is not retried in a loop. Phase 1 continues
regardless.
