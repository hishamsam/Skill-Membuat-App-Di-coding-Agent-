# Phase 2 — UI Design from Attached Images (UI Designer)

Purpose: menganalisis gambar referensi antarmuka (screenshot aplikasi, mockup, dribbble shot, atau wireframe) yang dilampirkan oleh pengguna di `projects/<slug>/refs/`, mengekstrak spesifikasi desain secara mendalam, dan menghasilkan dokumen teks terstruktur serta **Design System Blueprint** (`projects/<slug>/design/DESIGN-BLUEPRINT.md`) yang siap dieksekusi terus oleh Phase 3 (Codegen).

Rujukan utama modul: `ui-ux/ui-designer.md`.

---

## 1. Input

- `projects/<slug>/prd/PRD-v0.1.md` (terutamanya Bab 12 — UI Contract).
- Gambar-gambar referensi yang dilampirkan di `projects/<slug>/refs/`.

> **Nota:** Agent membuka dan membaca fail gambar di dalam `refs/` secara langsung. Jangan sesekali meneka atau mengabaikan butiran visual dalam tangkapan skrin yang dibekalkan.

---

## 2. 7 Langkah Analisis Desain (UI Designer Protocol)

### Langkah 1: Identifikasi Karakter & Gaya Desain Utama (UI Style)
Tentukan jenis dan kategori gaya visual daripada gambar rujukan:
- Gaya: Modern Minimalist, Glassmorphism, Bento Grid, Clean Corporate, Playful/Gamified, atau Dark Mode Futuristic (lalai: Light Mode melainkan pengguna meminta mod gelap).
- Nyatakan kesan umum (mood/tone) serta target penggunaannya.

### Langkah 2: Ekstraksi Palet Warna & Token Visual (HEX & Tailwind)
Kenal pasti warna-warna utama daripada gambar dan tukarkan ke kod HEX tepat beserta padanan class Tailwind CSS:
- **Background Colors**: Canvas utama (Primary BG), Surface/Card BG, Secondary/Subtle BG.
- **Brand/Accent Colors**: Butang utama (CTA), elemen aktif, dan sorotan (Primary & Secondary Accent).
- **Text/Typography Colors**: Teks tajuk (Heading), teks kandungan (Body), dan teks redup (Muted/Placeholder).
- **Status & Border Colors**: Garis sempadan (Border/Divider), serta status Success, Warning, dan Danger.

### Langkah 3: Analisis Tipografi & Hierarki Teks
Jelaskan karakteristik teks pada gambar rujukan:
- Fon yang dicadangkan (misal: Inter, Plus Jakarta Sans, Poppins, atau Roboto).
- Hierarki saiz dan ketebalan (H1/Display, H2/Heading, H3/Subheading, Body Regular, Caption/Label).
- Kerapatan baris (`line-height`), jarak huruf (`letter-spacing`), dan perataan teks (`text-left`, `text-center`).

### Langkah 4: Bedah Tata Letak (Layout) & Navigasi
Uraikan kerangka halaman secara menyeluruh:
- **Sistem Navigasi**:
  - *Mobile (< 768px)*: Dedicated Bottom Navigation Bar (3–5 item ikon + label, `fixed bottom-0`, `pb-24` pada kontainer utama).
  - *Desktop (≥ 1024px)*: Sidebar kiri atau Top Navbar kemas. Sembunyikan bottom nav pada desktop.
- **Struktur Grid & Spacing**: Pola penyusunan kandungan (Single Column Mobile-First, Bento Grid, 2-Column Asymmetric), padding kontainer, dan skala gap (4/8/12/16/24/32px).
- **Responsivitas**: Petakan bagaimana layout beradaptasi daripada skrin kecil (360px) hingga skrin monitor luas (1920px).

### Langkah 5: Rincian Komponen UI (Component Breakdown)
Daftarkan setiap komponen spesifik yang kelihatan pada gambar dari atas ke bawah:
- **Header / Hero Section**: Avatar pengguna, teks sapaan, ikon loceng notifikasi, search bar, status chips.
- **Cards & Containers**: Tingkat kelengkungan sudut (`rounded-xl`, `rounded-2xl`, 16px), jenis bayangan (`shadow-sm`, `shadow-md`), sempadan (`border border-slate-200`), dan latar surface.
- **Buttons, Badges & Inputs**: Bentuk butang (tinggi minimum 44px / `h-11`, `rounded-xl`), medan input dengan placeholder jelas dan fokus ringkas, badge status pill.
- **Data Visualization & Lists**: Gaya senarai rekod (2-row title + meta), graf ringkas, progress bar, atau jadual dengan scroll melintang pada paparan sempit.

### Langkah 6: Rekomendasi Interaksi & Micro-interactions
- Transisi: `transition duration-150 ease-in-out`, butang aktif berskala lembut (`active:scale-95`).
- Pustaka ikon: Lucide Icons (`data-lucide="..."`), konsisten saiz 16px/18px/20px.
- Pengendalian 4 States:
  1. *Default*: paparan normal dengan data sampel realistik.
  2. *Loading*: rangka skeleton beranimasi (`animate-pulse`).
  3. *Empty*: ilustrasi/ikon pudar, mesej jelas 1 baris, butang tindakan tambah.
  4. *Error*: banner amaran dengan butang cuba semula.

### Langkah 7: Susun Design System Blueprint (Siap Pakai untuk Codegen)
Rangkumkan keseluruhan hasil analisis ke dalam blok instruktif yang padat dan boleh terus disalin/dirujuk oleh Phase 3 Codegen.

---

## 3. Format Output Dokumen

Simpan hasil analisis di:

```text
projects/<slug>/design/DESIGN-BLUEPRINT.md
```

Gunakan format 7 bahagian yang kemas dan teratur:

1. **Karakter & Gaya Desain (UI Style)**
2. **Palet Warna & Token (HEX & Tailwind)**
3. **Tipografi & Hierarki**
4. **Struktur Layout & Navigasi**
5. **Bedah Komponen Detail**
6. **Detail Visual & Interaksi (Shadows, Radius, Icons)**
7. **Design System Blueprint (Untuk Webapp Builder)**

---

## 4. Gotchas & Peraturan Ketat

1. **Jangan menulis kod aplikasi penuh pada tahap ini:** Fokus utama Phase 2 adalah menghasilkan spesifikasi teks mendalam dan blueprint token desain. Jangan jana fail `index.html` atau kod penuh sebelum Phase 3.
2. **Berikan nilai yang konkret dan terukur:** Elakkan huraian samar seperti "warna agak biru" atau "sudut sedikit melengkung". Gunakan `#3B82F6 / bg-blue-500` dan `rounded-2xl (16px)`.
3. **Gambar rujukan mudah alih bukan had lebar:** Tangkapan skrin telefon hanyalah rujukan gubahan. Kod akhir di Phase 3 WAJIB responsif dari 360px hingga 1920px.
4. **Sentiasa semak sebelum mula kod:** Tunjukkan rumusan blueprint kepada pengguna dan minta pengesahan sebelum memasuki Phase 3 (kecuali dalam auto mode di mana proses diteruskan secara automatik).

---

## 5. Struktur Fail Hasil Phase 2

```text
projects/<slug>/
├── refs/
│   ├── screen-1.png
│   └── screen-2.png
└── design/
    └── DESIGN-BLUEPRINT.md
```
