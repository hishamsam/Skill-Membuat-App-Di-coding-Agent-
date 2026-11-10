#!/usr/bin/env python3
"""
One-pass FigCraft design builder for the __SLUG__ project.

Usage:
    python3 -I projects/__SLUG__/design/build.py --check    # connection only
    python3 -I projects/__SLUG__/design/build.py            # build, export, save
    python3 -I projects/__SLUG__/design/build.py --no-save  # build and export only

Prerequisite: FigCraft live on port 7979.
Every run starts a clean document, so a rerun never duplicates screens.
Replace the sample screens with PRD Chapter 12.4; keep the tokens and primitives.
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

# Utilitarian direction: one accent, one radius system, one type scale.
INK = "#1C1917"
BODY = "#44403C"
MUTED = "#78716C"
LINE = "#E7E5E4"
SURFACE = "#FFFFFF"
CANVAS = "#F5F5F4"
ACCENT = "#0F766E"
ACCENT_SOFT = "#E6F4F1"
WARN = "#9A3412"
WARN_SOFT = "#FDF0EA"

SIZE_CAPTION = 12
SIZE_BODY = 14
SIZE_TITLE = 18
SIZE_HEADING = 28
SIZE_METRIC = 24


def frame(name, w, h, fill=CANVAS, layout="vertical", pad=0, gap=0, main_align=None):
    props = {"mainAlign": main_align} if main_align else {}
    return box(
        None, name, layout=layout, gap=gap, padding=pad, fill=fill,
        w=w, h=h, sizingH="fixed", sizingV="fixed", **props,
    )


def divider(parent):
    return box(parent, "Divider", layout="horizontal", gap=0, padding=0,
               h=1, sizingH="fill", sizingV="fixed", fill=LINE)


def avatar(parent, initials, size=32, bg=ACCENT_SOFT, fg=ACCENT):
    a = box(parent, "Avatar", layout="horizontal", gap=0, padding=0,
            fill=bg, radius=size // 2, w=size, h=size,
            sizingH="fixed", sizingV="fixed",
            mainAlign="center", crossAlign="center")
    txt(a, initials, max(12, size // 3), "Semi Bold", fg)
    return a


def tag(parent, label, fg, bg=ACCENT_SOFT):
    t = box(parent, f"Tag / {label}", layout="horizontal", gap=0, padding=8,
            fill=bg, radius=6, sizingH="hug", sizingV="hug",
            mainAlign="center", crossAlign="center")
    txt(t, label, SIZE_CAPTION, "Medium", fg)
    return t


def primary_button(parent, label):
    b = box(parent, f"Button / {label}", layout="horizontal", gap=8, padding=12,
            fill=ACCENT, radius=8, sizingH="hug", sizingV="hug",
            mainAlign="center", crossAlign="center")
    txt(b, label, SIZE_BODY, "Semi Bold", "#FFFFFF")
    return b


def search_field(parent, placeholder="Search records", w=None):
    sizing = "fill" if w is None else "fixed"
    f = box(parent, "Search", layout="horizontal", gap=8, padding=12,
            fill=CANVAS, radius=8, w=w, h=44,
            sizingH=sizing, sizingV="fixed", crossAlign="center")
    txt(f, placeholder, SIZE_BODY, "Regular", MUTED)
    return f


def logo(parent, name):
    mark = box(parent, "Mark", layout="horizontal", gap=0, padding=0,
               fill=ACCENT, radius=8, w=32, h=32,
               sizingH="fixed", sizingV="fixed",
               mainAlign="center", crossAlign="center")
    txt(mark, "A", SIZE_BODY, "Bold", "#FFFFFF")
    txt(parent, name, SIZE_TITLE, "Bold", INK)


def list_row(parent, title, meta, status, fg, bg):
    r = box(parent, "Record", layout="horizontal", gap=12, padding=16,
            sizingH="fill", crossAlign="center")
    info = box(r, "Record info", layout="vertical", gap=4, sizingH="fill")
    txt(info, title, SIZE_BODY, "Semi Bold", INK)
    txt(info, meta, SIZE_CAPTION, "Regular", MUTED)
    tag(r, status, fg, bg)
    return r


def nav_item(parent, label, active=False):
    item = box(parent, f"Nav / {label}", layout="horizontal", gap=12, padding=12,
               fill=ACCENT_SOFT if active else None, radius=8,
               sizingH="fill", crossAlign="center")
    txt(item, label, SIZE_BODY, "Semi Bold" if active else "Medium",
        ACCENT if active else BODY)
    return item


def build_mobile():
    fr = frame("S-01 / Mobile 390", 390, 844, main_align="spaceBetween")

    top = box(fr, "Top bar", layout="horizontal", gap=12, padding=24,
              fill=SURFACE, sizingH="fill",
              mainAlign="spaceBetween", crossAlign="center")
    brand = box(top, "Brand", layout="horizontal", gap=12, crossAlign="center")
    logo(brand, "Atlas Ops")
    avatar(top, "AS")

    body = box(fr, "Content", layout="vertical", gap=24, padding=24,
               sizingH="fill", sizingV="fill")

    head = box(body, "Page header", layout="horizontal", gap=12,
               sizingH="fill", mainAlign="spaceBetween", crossAlign="center")
    titles = box(head, "Titles", layout="vertical", gap=4)
    txt(titles, "Today", SIZE_HEADING, "Bold", INK)
    txt(titles, "4 records need attention", SIZE_BODY, "Regular", BODY)
    primary_button(head, "New record")

    search_field(body, "Search records")

    summary = box(body, "Summary", layout="horizontal", gap=16, padding=16,
                  fill=SURFACE, stroke=LINE, radius=12, sizingH="fill",
                  mainAlign="spaceBetween", crossAlign="center")
    total = box(summary, "Total", layout="vertical", gap=4)
    txt(total, "Open records", SIZE_CAPTION, "Medium", MUTED)
    txt(total, "12", SIZE_METRIC, "Bold", INK)
    txt(total, "2 overdue", SIZE_CAPTION, "Regular", WARN)
    due = box(summary, "Due", layout="vertical", gap=4)
    txt(due, "Due today", SIZE_CAPTION, "Medium", MUTED)
    txt(due, "4", SIZE_METRIC, "Bold", INK)
    txt(due, "Next at 11:00", SIZE_CAPTION, "Regular", MUTED)

    section = box(body, "Section header", layout="horizontal", gap=12,
                  sizingH="fill", mainAlign="spaceBetween", crossAlign="center")
    txt(section, "Recent activity", SIZE_TITLE, "Semi Bold", INK)
    txt(section, "View all", SIZE_BODY, "Medium", ACCENT)

    records = box(body, "Records", layout="vertical", gap=0,
                  fill=SURFACE, stroke=LINE, radius=12, sizingH="fill")
    list_row(records, "Meridian warehouse", "Rina · 09:40",
             "In progress", ACCENT, ACCENT_SOFT)
    divider(records)
    list_row(records, "Northwind onboarding", "Adi · 08:15",
             "Due today", WARN, WARN_SOFT)
    divider(records)
    list_row(records, "Kestrel renewal", "Sari · yesterday",
             "Done", MUTED, CANVAS)
    divider(records)
    list_row(records, "Harbor inspection", "Bima · 07:30",
             "In review", ACCENT, ACCENT_SOFT)
    divider(records)
    list_row(records, "Talon logistics", "Rina · 06:55",
             "Due today", WARN, WARN_SOFT)

    nav = box(fr, "Bottom nav", layout="vertical", gap=0,
              fill=SURFACE, sizingH="fill")
    divider(nav)
    items = box(nav, "Items", layout="horizontal", gap=0, padding=12,
                sizingH="fill", mainAlign="spaceBetween")
    for label, active in (("Today", True), ("Records", False),
                          ("Reports", False), ("Settings", False)):
        item = box(items, f"Tab / {label}", layout="vertical", gap=4, padding=8,
                   sizingH="fill", mainAlign="center", crossAlign="center")
        txt(item, label, SIZE_CAPTION,
            "Semi Bold" if active else "Medium",
            ACCENT if active else MUTED)

    return fr


def metric_card(parent, label, value, note, note_color=MUTED):
    card = box(parent, f"Metric / {label}", layout="vertical", gap=4, padding=16,
               fill=SURFACE, stroke=LINE, radius=12, sizingH="fill")
    txt(card, label, SIZE_CAPTION, "Medium", MUTED)
    txt(card, value, SIZE_METRIC, "Bold", INK)
    txt(card, note, SIZE_CAPTION, "Regular", note_color)
    return card


def table_cell(parent, value, width=None, header=False, color=None, weight=None):
    cell = box(parent, "Cell", layout="horizontal", gap=0, padding=0,
               w=width, sizingH="fill" if width is None else "fixed",
               crossAlign="center")
    text_props = {"textAutoResize": "height"}
    if width is not None:
        text_props["width"] = width
    txt(cell, value,
        SIZE_CAPTION if header else SIZE_BODY,
        weight or ("Medium" if header else "Regular"),
        color or (MUTED if header else BODY),
        **text_props)
    return cell


def table_row(parent, record, owner, status, status_fg, status_bg, updated):
    row = box(parent, f"Row / {record}", layout="horizontal", gap=0, padding=16,
              sizingH="fill", crossAlign="center")
    table_cell(row, record, None, weight="Semi Bold", color=INK)
    table_cell(row, owner, 150)
    status_cell = box(row, "Cell / Status", layout="horizontal", gap=0, padding=0,
                      w=130, sizingH="fixed", crossAlign="center")
    tag(status_cell, status, status_fg, status_bg)
    table_cell(row, updated, 90, color=MUTED)
    return row


def build_desktop():
    fr = frame("S-01 / Desktop 1440", 1440, 900, layout="horizontal")

    side = box(fr, "Sidebar", layout="vertical", gap=24, padding=24,
               fill=SURFACE, w=252, sizingH="fixed", sizingV="fill",
               mainAlign="spaceBetween")

    side_top = box(side, "Sidebar top", layout="vertical", gap=24, sizingH="fill")
    brand = box(side_top, "Brand", layout="horizontal", gap=12, crossAlign="center")
    logo(brand, "Atlas Ops")
    nav = box(side_top, "Navigation", layout="vertical", gap=4, sizingH="fill")
    for label, active in (("Today", True), ("Records", False),
                          ("Reports", False), ("Settings", False)):
        nav_item(nav, label, active)

    side_bottom = box(side, "Sidebar bottom", layout="vertical", gap=12, sizingH="fill")
    txt(side_bottom, "Help & support", SIZE_BODY, "Medium", MUTED)
    user = box(side_bottom, "User", layout="horizontal", gap=12, padding=8,
               sizingH="fill", crossAlign="center")
    avatar(user, "AS")
    user_info = box(user, "User info", layout="vertical", gap=0, sizingH="fill")
    txt(user_info, "Ayu Sari", SIZE_BODY, "Semi Bold", INK)
    txt(user_info, "Operations", SIZE_CAPTION, "Regular", MUTED)

    main = box(fr, "Main", layout="vertical", gap=0,
               fill=CANVAS, sizingH="fill", sizingV="fill")

    topbar = box(main, "Top bar", layout="horizontal", gap=16, padding=16,
                 fill=SURFACE, sizingH="fill",
                 mainAlign="spaceBetween", crossAlign="center")
    search_field(topbar, "Search records", w=360)
    actions = box(topbar, "Actions", layout="horizontal", gap=16, crossAlign="center")
    txt(actions, "Help", SIZE_BODY, "Medium", MUTED)
    avatar(actions, "AS")
    divider(main)

    content = box(main, "Content", layout="vertical", gap=24, padding=24,
                  sizingH="fill", sizingV="fill")

    head = box(content, "Page header", layout="horizontal", gap=16,
               sizingH="fill", mainAlign="spaceBetween", crossAlign="center")
    titles = box(head, "Titles", layout="vertical", gap=4)
    txt(titles, "Records", SIZE_HEADING, "Bold", INK)
    txt(titles, "12 open · 4 due today · 2 overdue",
        SIZE_BODY, "Regular", BODY)
    primary_button(head, "New record")

    metrics = box(content, "Metrics", layout="horizontal", gap=16, sizingH="fill")
    metric_card(metrics, "Open records", "12", "4 due today")
    metric_card(metrics, "Completed this week", "28", "+6 vs last week", ACCENT)
    metric_card(metrics, "Overdue", "2", "Needs review", WARN)

    table = box(content, "Table", layout="vertical", gap=0,
                fill=SURFACE, stroke=LINE, radius=12, sizingH="fill")
    header = box(table, "Table header", layout="horizontal", gap=0, padding=16,
                 sizingH="fill", crossAlign="center")
    table_cell(header, "Record", None, header=True)
    table_cell(header, "Owner", 150, header=True)
    table_cell(header, "Status", 130, header=True)
    table_cell(header, "Updated", 90, header=True)

    rows = (
        ("Meridian warehouse", "Rina", "In progress", ACCENT, ACCENT_SOFT, "09:40"),
        ("Northwind onboarding", "Adi", "Due today", WARN, WARN_SOFT, "08:15"),
        ("Kestrel renewal", "Sari", "Done", MUTED, CANVAS, "Yesterday"),
        ("Harbor inspection", "Bima", "In review", ACCENT, ACCENT_SOFT, "07:30"),
        ("Talon logistics", "Rina", "Due today", WARN, WARN_SOFT, "06:55"),
        ("Orion migration", "Adi", "In progress", ACCENT, ACCENT_SOFT, "Yesterday"),
        ("Pinefield audit", "Sari", "In review", ACCENT, ACCENT_SOFT, "Yesterday"),
    )
    for record, owner, status, fg, bg, updated in rows:
        divider(table)
        table_row(table, record, owner, status, fg, bg, updated)

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
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--check", action="store_true",
                    help="Only verify the live connection; changes nothing")
    ap.add_argument("--no-save", action="store_true",
                    help="Build and export without writing design.figcraft")
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

        new_document(f"{SLUG} design")
        use_page("UI", "#FFFFFF")

        screens = (
            ("S-01-mobile", build_mobile()),
            ("S-01-desktop", build_desktop()),
        )

        os.makedirs(OUT, exist_ok=True)
        for name, node in screens:
            export_node(node, os.path.join(OUT, f"{name}.png"), 2)

        saved = "(not saved: --no-save)"
        if not args.no_save:
            os.makedirs(os.path.dirname(FILE), exist_ok=True)
            client.cmd("file.save", path=FILE)
            saved = FILE

        for name, node in screens:
            print(f"{name:<13}:", node)
        print("export :", OUT)
        print("file   :", saved)
        return 0
    except FigcraftError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())



