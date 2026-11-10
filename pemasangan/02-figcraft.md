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
/usr/bin/figcraft-cli --version
/usr/bin/figcraft-cli info <file.figcraft>
/usr/bin/figcraft-cli commands | head
```

## Quick script (many layers)

For more than 10 layers, write a Python script and run it once. The helper
library is included in the repo:

```text
skrip/figcraft/fclib.py
templat/figcraft/build.py
```

Example:

```bash
python3 -I projek/<slug>/design/build.py
```

The script connects to `figcraft-cli mcp --attach 7979` by itself. No MCP
server needs to be registered in the session for this script.

## Saving & export

```python
from fclib import export_node, get_client

f = get_client()

# ... build layers ...

export_node('<node-id>', '<abs path>/projek/<slug>/design/exports/page.png', 2)
f.cmd('file.save', path='<abs path>/projek/<slug>/design/design.figcraft')
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
| FigCraft tool missing | Old OpenCode session | Close & reopen OpenCode |
| Frame becomes auto-layout despite `layout=None` | API limitation | Use `box()` from `fclib`; it resets `layout=None` |
| Text in a scaled group does not scale | FigCraft limitation | Build at the final size |
| Font missing | Font not installed | `f.cmd('text.missingFonts')` |

Full guide: `figcraft-fast-SKILL.md`.
