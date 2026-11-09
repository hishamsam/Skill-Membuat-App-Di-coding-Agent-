#!/usr/bin/env python3
"""
Templat skrip FigCraft untuk projek __SLUG__.

Guna:
    python3 -I projek/__SLUG__/design/build.py
    python3 -I projek/__SLUG__/design/build.py --rehearsal
    python3 -I projek/__SLUG__/design/build.py --save

Prasyarat: FigCraft live pada port 7979.
Ganti isi build_mobile() dan build_desktop() dengan skrin sebenar
daripada PRD Bab 12.4. Kekalkan pola: satu skrip, satu larian.
"""

import sys
import os
import argparse

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", "..", ".."))
LIB = os.path.join(ROOT, "skrip", "figcraft")

if LIB not in sys.path:
    sys.path.insert(0, LIB)

from fclib import box, txt, export_node, get_client  # noqa: E402

OUT = os.path.join(HERE, "exports")
FILE = os.path.join(HERE, "design.figcraft")

INK = "#1A1A1A"
MUTED = "#5C5C5C"
LINE = "#E4E4E0"
SURFACE = "#FFFFFF"
CANVAS = "#F6F6F2"
ACCENT = "#0F6B4F"

f = get_client()


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
    header(fr, "Ringkasan", "Hari ini")
    txt(fr, "Skrin contoh", 26, "Bold", INK)
    card(fr, "Kad pertama", "Ganti teks ini dengan kandungan sebenar daripada PRD Bab 12.4.")
    card(fr, "Kad kedua", "Setiap skrin perlu keadaan default, loading, empty, dan error.")
    button(fr, "Tindakan utama")
    return fr


def build_desktop():
    fr = frame("S-01 / Desktop 1440", 1440, 900, layout="horizontal", pad=0, gap=0)

    side = box(fr, "Sidebar", layout="vertical", gap=12, padding=24,
               fill=SURFACE, stroke=LINE, w=260, sizingV="fill")
    txt(side, "Aplikasi", 16, "Bold", INK)
    for item in ["Ringkasan", "Rekod", "Laporan", "Tetapan"]:
        txt(side, item, 13, "Medium", MUTED)

    main = box(fr, "Main", layout="vertical", gap=16, padding=32,
               fill=CANVAS, sizingH="fill", sizingV="fill")
    header(main, "Ringkasan", "Desktop 1440")
    txt(main, "Skrin contoh", 32, "Bold", INK)
    row = box(main, "Cards", layout="horizontal", gap=16, sizingH="fill")
    card(row, "Kad pertama", "Susun atur desktop berbeza daripada mobile.")
    card(row, "Kad kedua", "Guna grid 2–3 kolum pada lebar ini.")
    button(main, "Tindakan utama")
    return fr


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--rehearsal", action="store_true",
                    help="Bina dalam dokumen baharu (buangan)")
    ap.add_argument("--save", action="store_true",
                    help="Simpan ke design.figcraft selepas siap")
    args = ap.parse_args()

    if args.rehearsal:
        f.cmd("file.new", name="Rehearsal")

    res = f.cmd("page.add", name="UI")
    if isinstance(res, dict) and res.get("id"):
        f.cmd("page.select", id=res["id"])

    mobile = build_mobile()
    desktop = build_desktop()

    os.makedirs(OUT, exist_ok=True)
    export_node(mobile, os.path.join(OUT, "S-01-mobile.png"), 2)
    export_node(desktop, os.path.join(OUT, "S-01-desktop.png"), 2)

    if args.save:
        f.cmd("file.save", path=FILE)

    print("siap")
    print("mobile :", mobile)
    print("desktop:", desktop)
    print("eksport:", OUT)
    print("fail   :", FILE if args.save else "(belum disimpan)")


if __name__ == "__main__":
    main()
