# 02 — FigCraft MCP

FigCraft is used for Phase 2 (design) and produces the visual reference for
Phase 3 (code).

## Two modes

| Mode | Server | Needs the app? | Purpose |
| --- | --- | --- | --- |
| Live | `figcraft-app` → `figcraft-cli mcp --attach 7979` | Yes | **REQUIRED for this repo's workflow** |
| Headless | `figcraft` → `figcraft-cli mcp` | No | Technical reference only |

Register both in `opencode.json` (see `01-opencode-mcp.md`), but the agent must
use **live** for Phase 2.

## Opening live mode

```bash
figcraft --control 7979 &
ss -ltnp | grep 7979
```

Or use the **FigCraft (Live)** application menu.

If `figcraft-app` fails with `can't reach 127.0.0.1:7979`, the app was not
opened with `--control 7979`. Do not change the config; reopen the app.

## Checking the installation

```bash
/usr/bin/figcraft-cli --version         # verified here with 0.17.0
/usr/bin/figcraft-cli info <file.figcraft>
/usr/bin/figcraft-cli commands | head
```

The helper scripts in this repo run against `figcraft-cli` 0.10 and newer; the
commands below were verified on 0.17.0.

## Quick script (many layers)

For more than 10 layers, write a Python script and run it once. The helper
library is included in the repo:

```text
scripts/figcraft/figcraft_client.py
templates/figcraft/figcraft_build.py
scripts/figcraft/test_figcraft_client.py
```

Example:

```bash
python3 -I projects/<slug>/design/build.py --check       # connect only
python3 -I projects/<slug>/design/build.py --rehearsal   # clean doc, exports/rehearsal/
python3 -I projects/<slug>/design/build.py --save        # build + save design.figcraft
```

The script connects to `figcraft-cli mcp --attach 7979` by itself. No MCP
server needs to be registered in the session for this script.

Each run starts a clean document (`file.new`) and reuses the single empty page,
renamed to `UI`, so reruns never duplicate screens or leave `Page 1` behind.
Top-level frames are placed left to right automatically; pass `x` only when a
specific position is wanted. `--rehearsal` and `--save` are mutually exclusive.

The regression test for the helper library needs no app and writes no files:

```bash
python3 -I scripts/figcraft/test_figcraft_client.py     # figcraft selftest: ok
```

### Environment overrides

| Variable | Default | Use |
| --- | --- | --- |
| `FIGCRAFT_CLI` | `figcraft-cli` on `PATH` | Full path to the CLI |
| `FIGCRAFT_PORT` | `7979` | Live control port |
| `FIGCRAFT_TIMEOUT` | `120` | Seconds to wait for one request |

## Saving & export

```python
from figcraft_client import export_node, get_client

f = get_client()

# ... build layers ...

export_node('<node-id>', '<abs path>/projects/<slug>/design/exports/page.png', 2)
f.cmd('file.save', path='<abs path>/projects/<slug>/design/design.figcraft')
```

Use ABSOLUTE paths for `export` and `file.save`.

## Checking the result

- `inspect_document` — list of layers on the current page.
- `screenshot` — quick PNG.
- `export` — 2x scaled PNG for detailed checking.

## Common problems

| Symptom | Cause | Solution |
| --- | --- | --- |
| `can't reach 127.0.0.1:7979` | App is not in live mode | Open `figcraft --control 7979` |
| `error: FigCraft live mode is not listening on 127.0.0.1:7979...` | App is not in live mode | Open the app, rerun |
| `error: figcraft-cli not found...` | CLI not on `PATH` | Install FigCraft or set `FIGCRAFT_CLI` |
| `error: <tool> did not answer within 120s` | App busy or frozen | Check the window, rerun, raise `FIGCRAFT_TIMEOUT` |
| `unknown argument \`fill\`` | Paint/layout passed top-level | Pass them in `props`; `box()`/`txt()` do this |
| Frames overlapping at `(0,0)` | Old `figcraft_client.py` | Update `figcraft_client.py`; `box()` places top-level frames |
| Duplicate screens after rerun | Old `build.py` added a page per run | Update the template; it calls `new_document()`/`use_page()` |
| FigCraft tool missing | Old OpenCode session | Close & reopen OpenCode |
| Frame becomes auto-layout despite `layout=None` | API limitation | Use `box()` from `figcraft_client`; it resets `layout=None` |
| Text in a scaled group does not scale | FigCraft limitation | Build at the final size |
| Font missing | Font not installed | `f.cmd('text.missingFonts')` |

Full guide: `FIGCRAFT-SCRIPTING.md`.
