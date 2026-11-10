#!/usr/bin/env python3
"""Regression test for scripts/figcraft/figcraft_client.py.

Runs a headless figcraft-cli session (no live app, no file writes) and checks
the client transport, top-level frame placement, page reuse, and the raw
create_node error path.

    python3 -I scripts/figcraft/test_figcraft_client.py
"""

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from figcraft_client import (  # noqa: E402
    FigcraftError,
    box,
    get,
    init_client,
    new_document,
    txt,
    use_page,
)

FAILED = []


def check(label, condition, detail=""):
    if condition:
        print(f"ok   {label}")
    else:
        FAILED.append(label)
        print(f"FAIL {label} {detail}")


def main():
    client = init_client(headless=True)
    try:
        new_document("figcraft_client selftest")
        page_id = use_page("UI", "#FFFFFF")

        mobile = box(None, "Mobile", w=390, h=844,
                     sizingH="fixed", sizingV="fixed", fill="#FFFFFF")
        desktop = box(None, "Desktop", w=1440, h=900,
                      sizingH="fixed", sizingV="fixed", fill="#FFFFFF")

        m = get(mobile, 0)
        d = get(desktop, 0)
        check("mobile x is 0", m["absoluteBounds"]["x"] == 0, m["absoluteBounds"])
        check("desktop x clears mobile", d["absoluteBounds"]["x"] >= 490,
              d["absoluteBounds"])
        check("mobile size", (m["width"], m["height"]) == (390, 844),
              (m["width"], m["height"]))
        check("desktop size", (d["width"], d["height"]) == (1440, 900),
              (d["width"], d["height"]))

        pages = client.cmd("page.list") or []
        ui_pages = [p for p in pages if p.get("name") == "UI"]
        check("one UI page", len(pages) == 1 and len(ui_pages) == 1, pages)

        free = box(None, "Free", layout=None, w=200, h=100)
        fr = get(free, 0)
        check("layout=None sticks", fr.get("layout") is None, fr.get("layout"))
        check("free width", fr["width"] == 200, fr["width"])

        card = box(mobile, "Card", padding=16, gap=8, fill="#FFFFFF")
        txt(card, "Title", 14, "Bold", "#111111")
        txt(card, "Body", 13, "Regular", "#555555")
        c = get(card, 0)
        check("nested card hugs its text", c["height"] > 0, c["height"])

        try:
            client.tool("create_node", {"type": "text", "fill": "#000000"})
            check("bad create_node raises", False, "no exception")
        except FigcraftError as exc:
            check("bad create_node raises", "unknown argument" in str(exc), exc)

        check("page id matches", client.tool("inspect_document", {})["currentPage"] == page_id)
    finally:
        client.close()

    if FAILED:
        print(f"figcraft selftest: FAILED ({len(FAILED)}): {', '.join(FAILED)}")
        return 1
    print("figcraft selftest: ok")
    return 0


if __name__ == "__main__":
    sys.exit(main())
