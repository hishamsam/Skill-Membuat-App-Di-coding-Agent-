# Fasa 2 — Reka Bentuk UI di FigCraft (Live MCP)

Tujuan: tukar PRD Bab 12 + imej rujukan menjadi skrin FigCraft yang boleh
dilihat, dieksport, dan dijadikan rujukan kod. Semua fail disimpan dalam
folder projek.

## Prasyarat

```bash
figcraft-cli --version                 # mesti ada
ss -ltnp | grep 7979                   # live mode aktif?
```

Jika port 7979 tiada, buka FigCraft live:

```bash
figcraft --control 7979 &
```

Dua laluan:

| Laluan | Bila guna |
| --- | --- |
| MCP `figcraft-app` | Sedikit perubahan, mahu nampak live dalam app |
| Skrip `figcraft-cli mcp --attach 7979` | Banyak layer — SATU skrip, satu larian |
| MCP `figcraft` (headless) | Rehearsal / eksport tanpa app |

Peraturan: lebih daripada 10 layer → tulis skrip, jangan panggil tool satu-satu.

## Langkah

1. Baca input:
   - `projek/<slug>/prd/PRD-v0.1.md` Bab 12.
   - Imej dalam `projek/<slug>/refs/` (buka imej, jangan teka).
2. Tulis `projek/<slug>/design/DESIGN-DNA.md`:
   - grid, tipografi, palette, spacing, radius, density, signature.
   - apa diambil / diganti / sengaja berbeza.
3. Tulis `projek/<slug>/design/build.py` menggunakan
   `skrip/figcraft/fclib.py` (lihat `templat/figcraft/build.py`).
4. Rehearsal dalam dokumen buangan:

   ```bash
   python3 -I projek/<slug>/design/build.py --rehearsal
   ```

5. Larian sebenar + eksport:

   ```bash
   python3 -I projek/<slug>/design/build.py
   ```

6. Semak PNG dalam `projek/<slug>/design/exports/`.
   Betulkan skrip, ulang. Jangan tampal layer satu-satu.
7. Simpan fail FigCraft:

   ```text
   projek/<slug>/design/design.figcraft
   ```

8. Kemas kini `STATUS.md`: tandakan Fasa 2 siap.

## Konvensyen dalam fail FigCraft

- Satu page: `UI`.
- Frame dinamakan ikut ID PRD: `S-01 Login / Mobile 390`, `S-01 Login / Desktop 1440`.
- Setiap skrin ada 4 keadaan jika PRD minta: `default`, `loading`, `empty`, `error`.
- Token warna guna hex yang sama seperti PRD Bab 12.3.
- Teks sebenar, bukan lorem ipsum.
- Tiada chrome palsu (bingkai telefon/browser) — frame FigCraft sudah jadi frame.

## Saiz frame

| Peranti | Saiz |
| --- | --- |
| Mobile | 390 × 844 |
| Tablet | 768 × 1024 |
| Desktop | 1440 × 900 |

Jika rujukan hanya mobile, tetap hasilkan frame desktop. Kod nanti wajib
responsif; reka bentuk mesti tunjuk tingkah laku desktop, bukan regangan
mobile.

## Semakan hasil

- [ ] Semua skrin PRD Bab 12.4 ada.
- [ ] 4 keadaan lengkap jika diminta.
- [ ] Teks tidak terpotong / bertindih.
- [ ] Kontras teks lulus (≥ 4.5:1 untuk teks biasa).
- [ ] Tiada dark mode.
- [ ] Eksport PNG dinamakan ikut ID skrin.
- [ ] Fail `.figcraft` disimpan dalam folder projek.

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

Fasa 3 hanya bermula selepas eksport disemak dan pengguna setuju dengan UI.
