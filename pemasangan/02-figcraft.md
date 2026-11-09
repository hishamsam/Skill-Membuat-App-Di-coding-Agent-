# 02 — FigCraft MCP

FigCraft digunakan untuk Fasa 2 (reka bentuk) dan menghasilkan rujukan visual
untuk Fasa 3 (kod).

## Dua mod

| Mod | Server | Perlu app? | Kegunaan |
| --- | --- | --- | --- |
| Live | `figcraft-app` → `figcraft-cli mcp --attach 7979` | Ya | **WAJIB untuk aliran kerja repo ini** |
| Headless | `figcraft` → `figcraft-cli mcp` | Tidak | Rujukan teknikal sahaja |

Kedua-duanya sudah didaftar dalam `opencode.json` mesin ini, tetapi agent
mesti guna **live** untuk Fasa 2.

## Buka mod live

```bash
figcraft --control 7979 &
ss -ltnp | grep 7979
```

Atau guna menu aplikasi **FigCraft (Live)**.

Jika `figcraft-app` gagal `can't reach 127.0.0.1:7979`, app tidak dibuka
dengan `--control 7979`. Jangan ubah config; buka semula app.

## Semak pemasangan

```bash
/usr/bin/figcraft-cli --version
/usr/bin/figcraft-cli info <fail.figcraft>
/usr/bin/figcraft-cli commands | head
```

## Skrip pantas (banyak layer)

Untuk lebih daripada 10 layer, tulis satu skrip Python dan jalankan sekali.
Pustaka pembantu disertakan dalam repo:

```text
skrip/figcraft/fclib.py
templat/figcraft/build.py
```

Contoh:

```bash
python3 -I projek/<slug>/design/build.py
```

Skrip menyambung sendiri ke `figcraft-cli mcp --attach 7979`. Tiada MCP
server perlu didaftar dalam sesi untuk skrip ini.

## Simpan & eksport

```python
from fclib import *

# ... bina layer ...

export_page('<abs path>/projek/<slug>/design/exports/page.png')

f.cmd('file.save', path='<abs path>/projek/<slug>/design/design.figcraft')
```

Gunakan path MUTLAK untuk `export` dan `file.save`.

## Semakan hasil

- `inspect_document` — senarai layer page semasa.
- `screenshot` — PNG pantas.
- `export` — PNG skala 2 untuk semakan terperinci.

## Masalah biasa

| Gejala | Punca | Penyelesaian |
| --- | --- | --- |
| `can't reach 127.0.0.1:7979` | App bukan mod live | Buka `figcraft --control 7979` |
| Tool FigCraft tiada | Sesi OpenCode lama | Tutup & buka OpenCode |
| Frame jadi auto-layout walaupun `layout=None` | Had API | Guna `box()` dari `fclib`, ia set semula `layout=None` |
| Teks dalam group berskala tidak ikut skala | Had FigCraft | Bina pada saiz akhir |
| Font hilang | Font tidak dipasang | `f.cmd('text.missingFonts')` |

Panduan penuh: `figcraft-fast-SKILL.md`.
