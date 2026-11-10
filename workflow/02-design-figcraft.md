# Phase 2 — UI Design in FigCraft (Live MCP)

Purpose: turn PRD Chapter 12 + reference images into FigCraft screens that can be
seen, exported, and used as a code reference. All files are stored in the project
folder.

## Prerequisites

```bash
figcraft-cli --version                 # must exist
ss -ltnp | grep 7979                   # live mode active?
python3 -I projects/<slug>/design/build.py --check   # connects, changes nothing
```

Run `--check` first and fix any error it reports before building. A healthy
run prints the CLI path, the port, the document name, and `ok`.

If port 7979 is not there, open FigCraft live:

```bash
figcraft --control 7979 &
```

**FigCraft live edit is MANDATORY.** Do not use the headless `figcraft` MCP to
replace the app. If the app is not open yet, stop and ask the user to open
`figcraft --control 7979`.

| Approach | When to use |
| --- | --- |
| `figcraft-app` MCP | Small changes, visible live in the app |
| `figcraft-cli mcp --attach 7979` script | Many layers — ONE script, one run |

Rule: more than 10 layers → write a script, do not call tools one by one.

## Steps

1. Read the input:
   - `projects/<slug>/prd/PRD-v0.1.md` Chapter 12.
   - Images in `projects/<slug>/refs/` (open the images, do not guess).
2. Write `projects/<slug>/design/DESIGN-DNA.md`:
   - grid, typography, palette, spacing, radius, density, signature.
   - what is taken / replaced / deliberately different.
3. Write `projects/<slug>/design/build.py` using
   `scripts/figcraft/figcraft_client.py` (see `templates/figcraft/figcraft_build.py`).
4. Check the connection (changes nothing):

   ```bash
   python3 -I projects/<slug>/design/build.py --check
   ```

5. Rehearsal — clean throwaway document, PNGs into `exports/rehearsal/`:

   ```bash
   python3 -I projects/<slug>/design/build.py --rehearsal
   ```

6. Real run + export + save:

   ```bash
   python3 -I projects/<slug>/design/build.py --save
   ```

   Without `--save` the document stays unsaved and the script says so.
7. Check the PNG files in `projects/<slug>/design/exports/`.
   Fix the script, repeat. Do not paste layers one by one.
8. Update `STATUS.md`: mark Phase 2 done.

## What a run does

- Every run starts a clean document (`file.new`) and reuses the single empty
  page, renaming it to `UI`. A rerun never duplicates screens, and the default
  `Page 1` does not linger.
- Top-level frames are placed left to right automatically: the first at `x=0`,
  each next one 100 px after the previous frame's right edge. Pass `x` only
  when you want a specific position; passing any `x` or `y` turns autoplace off
  for that frame.
- `--rehearsal` and `--save` are mutually exclusive. Use `--save` only for the
  real document.

## Errors

| Message | Cause | Fix |
| --- | --- | --- |
| `error: FigCraft live mode is not listening on 127.0.0.1:7979...` | App not in live mode | `figcraft --control 7979 &`, then rerun |
| `error: figcraft-cli not found...` | CLI not on `PATH` | Install FigCraft or set `FIGCRAFT_CLI=/full/path/to/figcraft-cli` |
| `error: <tool> did not answer within 120s` | App busy or frozen | Check the app window, then rerun; raise `FIGCRAFT_TIMEOUT` if a screenshot is slow |
| `error: create_node failed: unknown argument \`fill\`` | Paint/layout passed as a top-level argument | Pass them inside `props`; `box()`/`txt()` already do this |
| Frames overlapping at `(0,0)` | Old `figcraft_client.py` | Update `scripts/figcraft/figcraft_client.py`; `box()` places top-level frames itself |
| Duplicate screens after rerun | Old `build.py` added a page each run | Update the template; it calls `new_document()` and `use_page()` |

## Conventions inside the FigCraft file

- One page: `UI`.
- Frames named by PRD ID: `S-01 Login / Mobile 390`, `S-01 Login / Desktop 1440`.
- Every screen has 4 states if the PRD asks: `default`, `loading`, `empty`, `error`.
- Colour tokens use the same hex as PRD Chapter 12.3.
- Real text, not lorem ipsum.
- No fake chrome (phone/browser frame) — the FigCraft frame is already the frame.

## Frame size

| Device | Size |
| --- | --- |
| Mobile | 390 × 844 |
| Tablet | 768 × 1024 |
| Desktop | 1440 × 900 |

If the reference is mobile only, still produce a desktop frame. The code later must be
responsive; the design must show desktop behaviour, not a stretched
mobile.

## Result check

- [ ] All screens in PRD Chapter 12.4 are present.
- [ ] 4 states complete if requested.
- [ ] Text is not cut off / overlapping.
- [ ] Text contrast passes (≥ 4.5:1 for body text).
- [ ] No dark mode.
- [ ] PNG exports are named by screen ID.
- [ ] The `.figcraft` file is saved in the project folder.

## Output

```text
projects/<slug>/design/
├── DESIGN-DNA.md
├── build.py
├── design.figcraft
└── exports/
    ├── rehearsal/          # from --rehearsal, safe to delete
    ├── S-01-login-mobile.png
    ├── S-01-login-desktop.png
    └── ...
```

Phase 3 starts only after the export is reviewed and the user agrees with the UI.
