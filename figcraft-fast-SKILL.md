---
name: figcraft-fast
description: Write to FigCraft fast by scripting the live app over figcraft-cli in one run, instead of one MCP tool call per layer. Use when a FigCraft task means creating or changing more than a handful of layers, and save results to projek/<slug>/design/.
---

# FigCraft fast write

FigCraft is slow when every layer is one agent tool call: each call costs a
model round trip. Instead, write **one Python script** that sends every
operation over JSON-RPC to `figcraft-cli mcp --attach 7979`, and run it once.
Hundreds of layers land in seconds.

The rule: **plan, write it all in one script, run once, look at the PNG, fix
the script, rerun.** Do not build layer by layer with tool calls.

## 1. Preconditions (Linux)

```bash
figcraft-cli --version
ss -ltnp | grep 7979        # live app must be running
```

If nothing listens on 7979:

```bash
figcraft --control 7979 &
```

Never close a FigCraft window that holds unsaved work.

Headless alternative (no app window):

```bash
figcraft-cli mcp            # MCP over stdio, headless
```

The script attaches on its own, so no MCP server is needed in the session.

## 2. Write the script

For a project, the script already exists:

```text
projek/<slug>/design/build.py
```

It imports the helpers shipped with this skill:

```python
import sys, os
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "skrip", "figcraft"))
from fclib import box, txt, export_node, get_client

f = get_client()
res = f.cmd("page.add", name="UI")
if isinstance(res, dict) and res.get("id"):
    f.cmd("page.select", id=res["id"])
root = box(None, "Card", padding=24, gap=12, fill="#FFFFFF", radius=16, w=360)
txt(root, "Title", 20, "Bold", "#111111")
txt(root, "Body text", 14, "Regular", "#555555")
export_node(root, os.path.join(ROOT, "projek", "<slug>", "design", "exports", "card.png"), 2)
```

Run with `python3 -I build.py`. The `-I` flag drops the script's folder from
`sys.path`, which is why the snippet adds the helpers folder explicitly.

### Low-level client (`f`)

| Call | Does |
| --- | --- |
| `f.tool(name, {args})` | Any MCP tool: `create_node`, `set_properties`, `get_node`, `inspect_document`, `export`, `screenshot`... |
| `f.cmd(id, **params)` | Any command (`run_command`). Find ids with `f.tool('list_commands', {'filter': '...'})`. |
| `f.raw(name, {args})` | Same as `tool`, returns raw response |

### Helpers (`skrip/figcraft/fclib.py`)

| Helper | Use |
| --- | --- |
| `node(type, parent, **props)` / `setp(id, **props)` / `get(id)` | Create, update, read |
| `box(parent, name, layout, gap, padding, fill, stroke, radius, w, h, ...)` | Auto-layout frame/component |
| `txt(parent, text, size, weight, color, family)` | Text (`Regular`, `Medium`, `Semi Bold`, `Bold`) |
| `rect(parent, w, h, fill, radius)` / `circle(parent, size, fill)` / `vector(parent, path, ...)` | Shapes |
| `export_node(ids, path, scale)` | PNG export |
| `screenshot(ids=None)` | PNG of the page or selection |

Page commands: `f.cmd('page.add', name='UI')`, `f.cmd('page.select', id=...)`,
`f.cmd('view.zoomFit')`.

## 3. Project workflow (PRD → design)

1. Read `prd/PRD-v0.1.md` Bab 12 (skrin, token, rujukan).
2. Open reference images in `refs/` yourself; FigCraft MCP cannot see images.
3. Write `design/DESIGN-DNA.md` (grid, type, palette, spacing, signature).
4. Edit `design/build.py` for the real screens.
5. Rehearse: `python3 -I build.py --rehearsal`.
6. Real run, then inspect `design/exports/*.png`.
7. Save: `python3 -I build.py --save` (writes `design/design.figcraft`).
8. Report which screens exist and where the files are.

Frame naming: `S-01 / Mobile 390`, `S-01 / Desktop 1440`.
If the reference is mobile, still build the desktop frame. Code must be
responsive from 360px to 1920px; the mobile frame is composition reference,
not a width lock.

## 4. Verify, fix, rerun

1. Export and LOOK at the PNG before reporting.
2. Rehearse in a throwaway document (`f.cmd('file.new', name='Rehearsal')`).
3. Final run in a clean document; save to the project folder.
4. To edit an existing document, read it once (`inspect_document` /
   `get_node`), then make every change in one script.

## 5. Live / recording mode

`PACE=0.1 python3 -I build.py` waits after each step. `focus()` glides the
camera. Use only when the user wants to watch or record.

## Gotchas

- **`layout=None` at creation is ignored.** `box()` re-applies `layout: null`.
  Always create frames through `box()`.
- **A `fill`-height child inside a `hug` parent collapses to 0.** Use hug
  height, then equalise heights.
- **Floating elements inside auto layout:** create as children, then
  `setp(id, absolute=True, x=..., y=...)`. Set `clip=False` on ancestors.
- **SVG circles drawn as one arc vanish** after scaling. Use two half-arcs.
- `vector.create` keeps the path's own coordinates. Scale path data instead
  of resizing the vector.
- Gradient fills:
  `fills=[{'type': 'linearGradient', 'stops': ['#0A6847', '#04432B'], 'from': [0, 0], 'to': [1, 1]}]`.
- `export` and `file.save` paths must be absolute.
- Text inside a *scaled* group or instance does not scale. Build at final size.
- `inspect_document` only lists children of the current page; `page.select` first.
- **Fonts:** check with `f.cmd('text.missingFonts')`. Load with
  `f.cmd('text.loadFont', path=...)`. Ask before downloading fonts.
- **SVG import** (`file.import` with base64 `data`, name ending `.svg`) brings
  artwork in as editable layers. Often the fastest way to get illustrations.
- Useful commands: `view.zoomFit`, `view.set {zoom,cx,cy}`,
  `page.setBackground`, `text.style`, `edit.delete`. Discover with
  `list_commands`.
