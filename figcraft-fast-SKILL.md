---
name: figcraft-fast
description: Write to FigCraft fast by scripting the live app over figcraft-cli in one run, instead of one MCP tool call per layer. Use whenever a FigCraft task means creating or changing more than a handful of layers (any design, component set, page, or bulk edit), or when the user wants to watch it being built live.
---

# FigCraft fast write

FigCraft is slow when every layer is its own agent tool call: each call costs a full model round trip. Instead, write **one Python script** that sends every operation over JSON-RPC to `figcraft-cli mcp --attach 7979`, and run it once. Hundreds of layers then land in seconds instead of minutes.

The rule: **plan in your head, write it all in one script, run once, look at the result, fix the script, rerun.** Don't build layer by layer with tool calls.

## 1. Preconditions

```bash
lsof -nP -iTCP:7979 -sTCP:LISTEN        # FigCraft must be running in live mode
figcraft-cli --version                  # this repo: /usr/bin/figcraft-cli
```

If nothing listens on 7979, open a new live window. Never close a window that may hold unsaved work.

```bash
open -n -a /Applications/FigCraft.app --args --control 7979   # macOS
figcraft --control 7979 &                                     # Linux
```

The script attaches on its own, so no MCP server is needed in the session.

## Project workflow

1. Read `projek/<slug>/prd/PRD-v0.1.md` Chapter 12 and open the images in
   `projek/<slug>/refs/`.
2. Write `projek/<slug>/design/DESIGN-DNA.md`.
3. Copy `templat/figcraft/build.py` to `projek/<slug>/design/build.py` and
   replace its sample screens.
4. `python3 -I projek/<slug>/design/build.py --check` — connection only.
5. `python3 -I projek/<slug>/design/build.py --rehearsal` — clean throwaway
   document, PNGs in `exports/rehearsal/`.
6. `python3 -I projek/<slug>/design/build.py --save` — real document, PNGs in
   `exports/`, saved to `design/design.figcraft`.
7. Inspect the PNGs, fix the script, rerun. `python3 -I skrip/figcraft/selftest.py`
   checks the helper library itself (headless, no app needed).

## 2. Write the script

In this repo the helper library lives at `skrip/figcraft/fclib.py`. `build.py`
already adds that folder to `sys.path`, so a project script only imports the
helpers it uses:

```python
import os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.abspath(os.path.join(HERE, "..", "..", "..", "skrip", "figcraft")))

from fclib import box, txt, export_node, get_client, new_document, use_page

client = get_client()
new_document("Card")
use_page("UI", "#FFFFFF")
root = box(None, "Card", padding=24, gap=12, fill="#FFFFFF", radius=16, w=360, sizingH="fixed")
txt(root, "Title", 20, "Bold", "#111111")
txt(root, "Body text goes here", 14, "Regular", "#555555")
export_node(root, "shots/card.png", 1)
```

Run it with `python3 -I build.py`. The `-I` flag drops the script's folder from
`sys.path`, which is why the snippet adds the helpers folder explicitly. Copy
`templat/figcraft/build.py` instead of writing the path logic by hand: it walks
up to the repo root and adds `--check`, `--rehearsal`, and `--save`.

### Low-level client (`f`)

Everything goes through three calls. Use these directly for anything the helpers don't cover.

| Call | Does |
| --- | --- |
| `f.tool(name, {args})` | Any MCP tool: `create_node`, `set_properties`, `get_node`, `inspect_document`, `export`, `screenshot`... Raises `FigcraftError` on an RPC or tool error, including the CLI's stderr tail. |
| `f.cmd(id, **params)` | Any command (`run_command`). Find ids with `f.tool('list_commands', {'filter': '...'})`. |
| `f.raw(name, {args})` | Same as `tool`, but returns the raw response without unwrapping. |

`get_client()` fails fast with `FigcraftError` when the live app is not
listening, the CLI is missing, or a request times out (`FIGCRAFT_CLI`,
`FIGCRAFT_PORT`, `FIGCRAFT_TIMEOUT` override the defaults). Catch it and print
`error: <message>` instead of a traceback.

### Helpers (`skrip/figcraft/fclib.py`)

| Helper | Use |
| --- | --- |
| `node(type, parent, **props)` / `create(type, parent, **props)` | Create a layer. `node` returns the id; `create` returns the whole result (`id` + `node`). |
| `setp(id, **props)` / `get(id, depth=1)` | Update, read a node. |
| `box(parent, name, layout, gap, padding, fill, stroke, radius, w, h, sizingH, sizingV, node_type='frame', **props)` | Auto-layout frame or component. `layout=None` gives free positioning. Top-level frames (`parent=None`) are placed left to right automatically; pass `x`/`y` to place one by hand. |
| `txt(parent, text, size, weight, color, family)` | Text. `weight` is a style name such as `Regular`, `Medium`, `Semi Bold`, `Bold`. |
| `vector(parent, path, fill, stroke, strokeWeight, w, h, name)` / `circle(parent, size, ...)` / `rect(parent, w, h, ...)` | Shapes. |
| `export_node(ids, path, scale=2)` / `screenshot(ids=None)` | PNG out (`path` is made absolute and its folder created) and a raw screenshot response. |
| `new_document(name)` / `use_page(name, background)` / `reset_layout()` | Start a clean document, rename or add the `UI` page, and reset the placement cursor. |

Not shipped in this repo: `icon`, `inst`, `make_set`, `text_prop`,
`equalize_heights`, `hairline`, `page`, and `export` (the `fclib import *`
helpers from the standalone skill). Use `node`/`cmd` for those, or add the
helper to `fclib.py` first.

## 3. Verify, fix, rerun

1. Export what you built (`export_node` / `screenshot`) and look at the PNG before reporting.
2. Rehearse in a throwaway document (`--rehearsal`, or `f.cmd('file.new', name='Rehearsal')`). Fixing the script and rerunning into a fresh document is faster than patching layers one by one.
3. Do the final run in a clean `file.new` document. Never save without asking: tell the user the document is unsaved.
4. To edit an existing document instead, read it once (`inspect_document` / `get_node`), then make every change in one script. Use `f.cmd('batch', ...)` when the changes should be one undo step.

## 4. Live / recording mode

`focus()` and `typeon()` also come from the standalone skill and are not in
this repo's `fclib.py`; add them before using them. Use this mode only when the
user wants to watch or record. Have them start recording first, then run the
script in the background.

## Gotchas

- **`layout=None` at creation is ignored.** The frame becomes horizontal auto layout and free-placed children line up side by side. `box()` re-applies `layout: null` after creation, so always create frames through `box()`.
- **A `fill`-height child inside a `hug` parent collapses to 0.** Use hug height, then set a fixed height or equal heights yourself; this repo does not ship `equalize_heights`.
- **Floating elements inside auto layout:** create them as children, then `setp(id, absolute=True, x=..., y=...)`. Set `clip=False` on any ancestor that would cut them off.
- **SVG circles drawn as one arc to an almost-equal endpoint vanish** after scaling. Draw them as two half-arcs.
- `vector.create` keeps the path's own coordinates. Scale the path data (`scale_path`) instead of resizing the vector.
- Gradient fills: `fills=[{'type': 'linearGradient', 'stops': ['#0A6847', '#04432B'], 'from': [0, 0], 'to': [1, 1]}]`. Hex with alpha (`#RRGGBBAA`) works everywhere.
- `export` paths must be absolute (the helper handles this).
- Text inside a *scaled* group or instance does not scale. Build at the final size, or `vector.flatten` the text.
- `inspect_document` only lists children of the current page, so `page.select` first.
- **Fonts:** check with `f.cmd('text.missingFonts')`. Load an extra font for the session with `f.cmd('text.loadFont', path=...)`. Ask before downloading fonts.
- **SVG import** (`file.import` with base64 `data` and a `name` ending in `.svg`) brings complex artwork in as editable layers, text and fonts included. It is often the fastest way to get illustrations in.
- Component properties: `component.addProperty` on one variant's layer, then `component.bindProperty` on the matching layer of every other variant.
- Useful commands: `view.zoomFit`, `view.set {zoom,cx,cy}`, `page.setBackground`, `text.style {id,start,end,fontStyle,textFills}` (mixed styles in one text), `edit.delete`. Discover more with `list_commands`.
