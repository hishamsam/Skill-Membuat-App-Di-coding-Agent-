# Phase 2 — UI Design in FigCraft (Live MCP)

Purpose: turn PRD Chapter 12 + reference images into FigCraft screens that can be
seen, exported, and used as a code reference. All files are stored in the project
folder.

## Prerequisites

```bash
figcraft-cli --version                 # must exist
ss -ltnp | grep 7979                   # live mode active?
```

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
   - `projek/<slug>/prd/PRD-v0.1.md` Chapter 12.
   - Images in `projek/<slug>/refs/` (open the images, do not guess).
2. Write `projek/<slug>/design/DESIGN-DNA.md`:
   - grid, typography, palette, spacing, radius, density, signature.
   - what is taken / replaced / deliberately different.
3. Write `projek/<slug>/design/build.py` using
   `skrip/figcraft/fclib.py` (see `templat/figcraft/build.py`).
4. Rehearsal in a throwaway document (still inside the live app):

   ```bash
   python3 -I projek/<slug>/design/build.py --rehearsal
   ```

5. Real run + export:

   ```bash
   python3 -I projek/<slug>/design/build.py
   ```

6. Check the PNG files in `projek/<slug>/design/exports/`.
   Fix the script, repeat. Do not paste layers one by one.
7. Save the FigCraft file:

   ```text
   projek/<slug>/design/design.figcraft
   ```

8. Update `STATUS.md`: mark Phase 2 done.

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
projek/<slug>/design/
├── DESIGN-DNA.md
├── build.py
├── design.figcraft
└── exports/
    ├── S-01-login-mobile.png
    ├── S-01-login-desktop.png
    └── ...
```

Phase 3 starts only after the export is reviewed and the user agrees with the UI.
