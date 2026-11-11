# 02 — UI Designer (Lampiran Imej)

Phase 2 mengekstrak spesifikasi desain UI/UX mendalam daripada gambar rujukan antarmuka (screenshot, mockup aplikasi, atau wireframe) yang dilampirkan oleh pengguna ke dalam `projects/<slug>/refs/`.

Pendekatan ini menggantikan keperluan perisian luaran atau server live MCP: analisis imej terus menghasilkan dokumen teks terstruktur dan **Design System Blueprint** (`projects/<slug>/design/DESIGN-BLUEPRINT.md`).

---

## 1. Sumber Input (Lampiran Gambar)

Gambar rujukan disimpan dalam folder projek:

```text
projects/<slug>/refs/
├── dashboard.png
├── mobile-screen.jpg
└── wireframe.png
```

Agent membaca fail imej ini secara langsung tanpa perantara luaran.

---

## 2. 7 Langkah Analisis Desain

Berdasarkan modul rujukan UI Designer:

1. **Identifikasi Karakter & Gaya Desain Utama (UI Style)**: Menilai sama ada gaya bercorak Modern Minimalist, Glassmorphism, Bento Grid, Clean Corporate, Playful, dsb.
2. **Pengekstrakan Palet Warna & Token (HEX & Tailwind)**: Menentukan kod warna tepat bagi Background, Surface, Primary Accent, Text, Border, dan Status Alerts.
3. **Analisis Tipografi & Hierarki**: Memilih fon yang sesuai (Inter, Plus Jakarta Sans, Poppins) dan memetakan saiz heading hingga caption.
4. **Bedah Tata Letak (Layout) & Navigasi**: Menetapkan susunan navigasi (Bottom Nav mobile vs Sidebar/Top Nav desktop), padding kontainer, dan grid responsif.
5. **Rincian Komponen Detail**: Menganalisis header, bentuk card/container, border radius, bayangan (shadow), butang, input borang, dan senarai rekod.
6. **Detail Visual & Interaksi**: Menetapkan ikon (Lucide Icons), transisi hover, dan state penting (loading skeleton, empty state, error state).
7. **Design System Blueprint**: Menghasilkan blok ringkasan instruktif yang siap dibaca oleh Phase 3 Codegen.

---

## 3. Format Output

Hasil analisis disimpan di:

```text
projects/<slug>/design/DESIGN-BLUEPRINT.md
```

Fail ini menjadi rujukan visual utama sepanjang pembangunan kod aplikasi di Phase 3.

---

## 4. Kelebihan Tanpa Perisian Pihak Ketiga

- **Tiada isu port / sambungan**: Tidak memerlukan port live seperti 7979 atau aplikasi desktop tambahan.
- **Serasi merentas platform**: Berfungsi sama di Linux, macOS, dan Windows tanpa perlu subsistem tambahan.
- **Ketepatan token Tailwind**: Kod HEX dan class Tailwind dipetakan terus sedia guna dalam kod frontend.
