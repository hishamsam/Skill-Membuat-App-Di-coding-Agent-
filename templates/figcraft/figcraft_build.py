#!/usr/bin/env python3
"""
FigCraft script template for the __SLUG__ project.

Usage:
    python3 -I projects/__SLUG__/design/build.py --check
    python3 -I projects/__SLUG__/design/build.py --rehearsal
    python3 -I projects/__SLUG__/design/build.py --save
    python3 -I projects/__SLUG__/design/build.py

Prerequisite: FigCraft live on port 7979.
Replace the contents of build_mobile() and build_desktop() with the real
screens from PRD Chapter 12.4. Keep the pattern: one script, one run.
Every run starts a clean document, so rerunning never duplicates screens.
"""

import sys
import os
import argparse

HERE = os.path.dirname(os.path.abspath(__file__))


def _find_root(start):
    """First parent that holds scripts/figcraft/figcraft_client.py."""
    current = start
    while True:
        if os.path.exists(os.path.join(current, "scripts", "figcraft", "figcraft_client.py")):
            return current
        parent = os.path.dirname(current)
        if parent == current:
            return os.path.abspath(os.path.join(start, "..", "..", ".."))
        current = parent


ROOT = _find_root(HERE)
LIB = os.path.join(ROOT, "scripts", "figcraft")
SLUG = os.path.basename(os.path.dirname(HERE)) or "app"

if LIB not in sys.path:
    sys.path.insert(0, LIB)

from figcraft_client import (  # noqa: E402
    FigcraftError,
    box,
    export_node,
    get_client,
    new_document,
    txt,
    use_page,
)

OUT = os.path.join(HERE, "exports")
FILE = os.path.join(HERE, "design.figcraft")

INK = "#1A1A1A"
MUTED = "#5C5C5C"
LINE = "#E4E4E0"
SURFACE = "#FFFFFF"
CANVAS = "#F6F6F2"
ACCENT = "#0F6B4F"


def frame(name, w, h, fill=CANVAS, layout="vertical", pad=24, gap=16):
    return box(
        None, name, layout=layout, gap=gap, padding=pad,
        fill=fill, w=w, h=h, sizingH="fixed", sizingV="fixed",
    )


def header(parent, title, meta=None):
    row = box(parent, "Header", layout="horizontal", gap=12,
              sizingH="fill", mainAlign="spaceBetween", crossAlign="center")
    txt(row, title, 18, "Bold", INK)
    if meta:
        txt(row, meta, 12, "Medium", MUTED)
    return row


def card(parent, title, body):
    c = box(parent, "Card", layout="vertical", gap=8, padding=16,
            fill=SURFACE, stroke=LINE, radius=12, sizingH="fill")
    txt(c, title, 14, "Semi Bold", INK)
    txt(c, body, 13, "Regular", MUTED, width=280, textAutoResize="height")
    return c


def button(parent, label):
    b = box(parent, "Button", layout="horizontal", gap=8, padding=12,
            fill=ACCENT, radius=10, sizingH="hug", mainAlign="center",
            crossAlign="center")
    txt(b, label, 13, "Semi Bold", "#FFFFFF")
    return b


def build_mobile():
    fr = frame("S-01 / Mobile 390", 390, 844)
    header(fr, "Overview", "Today")
    txt(fr, "Sample screen", 26, "Bold", INK)
    card(fr, "First card", "Replace this text with the real content from PRD Chapter 12.4.")
    card(fr, "Second card", "Every screen needs default, loading, empty, and error states.")
    button(fr, "Primary action")
    return fr


def build_desktop():
    fr = frame("S-01 / Desktop 1440", 1440, 900, layout="horizontal", pad=0, gap=0)

    side = box(fr, "Sidebar", layout="vertical", gap=12, padding=24,
               fill=SURFACE, stroke=LINE, w=260, sizingV="fill")
    txt(side, "App", 16, "Bold", INK)
    for item in ["Overview", "Records", "Reports", "Settings"]:
        txt(side, item, 13, "Medium", MUTED)

    main = box(fr, "Main", layout="vertical", gap=16, padding=32,
               fill=CANVAS, sizingH="fill", sizingV="fill")
    header(main, "Overview", "Desktop 1440")
    txt(main, "Sample screen", 32, "Bold", INK)
    row = box(main, "Cards", layout="horizontal", gap=16, sizingH="fill")
    card(row, "First card", "The desktop layout differs from mobile.")
    card(row, "Second card", "Use a 2–3 column grid at this width.")
    button(main, "Primary action")
    return fr


def check(client):
    doc = client.tool("inspect_document", {})
    print("cli    :", client.cli)
    print("port   :", client.port)
    print("doc    :", doc.get("name"))
    print("dirty  :", doc.get("dirty"))
    print("pages  :", len(doc.get("pages") or []))
    print("ok")


def main():
    ap = argparse.ArgumentParser()
    mode = ap.add_mutually_exclusive_group()
    mode.add_argument("--rehearsal", action="store_true",
                      help="Build into a clean throwaway document, export to exports/rehearsal/")
    mode.add_argument("--save", action="store_true",
                      help="Save to design.figcraft when finished")
    ap.add_argument("--check", action="store_true",
                    help="Only verify the live connection; changes nothing")
    args = ap.parse_args()

    try:
        client = get_client()
    except FigcraftError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2

    try:
        if args.check:
            check(client)
            return 0

        new_document("Rehearsal" if args.rehearsal else f"{SLUG} design")
        use_page("UI", "#FFFFFF")

        mobile = build_mobile()
        desktop = build_desktop()

        out = os.path.join(OUT, "rehearsal") if args.rehearsal else OUT
        os.makedirs(out, exist_ok=True)
        export_node(mobile, os.path.join(out, "S-01-mobile.png"), 2)
        export_node(desktop, os.path.join(out, "S-01-desktop.png"), 2)

        saved = "(not saved)"
        if args.save and not args.rehearsal:
            os.makedirs(os.path.dirname(FILE), exist_ok=True)
            client.cmd("file.save", path=FILE)
            saved = FILE

        print("mode   :", "rehearsal" if args.rehearsal else "build")
        print("mobile :", mobile)
        print("desktop:", desktop)
        print("export :", out)
        print("file   :", saved)
        return 0
    except FigcraftError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
