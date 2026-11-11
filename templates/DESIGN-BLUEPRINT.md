# Design System Blueprint — {{SLUG}}

Dokumen spesifikasi desain UI/UX mendalam diekstrak dari gambar referensi (screenshot, mockup, atau desain aplikasi) di `projects/{{SLUG}}/refs/`. Digunakan sebagai kontrak visual dan panduan implementasi langsung untuk Phase 3 Codegen.

---

## 1. Karakter & Gaya Desain (UI Style)

- **Gaya Utama:** <!-- Misal: Modern Minimalist, Glassmorphism, Neumorphism, Bento Grid, Clean Corporate, Playful/Gamified, Dark Mode Futuristic -->
- **Kesan Visual (Aura/Mood):** <!-- Misal: Profesional, tenang, ringkas, premium, utilitarian -->
- **Target Pengguna & Konteks:** <!-- Misal: B2B dashboard, mobile field workers, e-commerce consumers -->
- **Pedoman Anti-AI-Slop:** Light mode default, tiada gradien ungu-kebiruan murahan, tiada teks gradien, tiada ikon emoji, border kemas dan terukur.

---

## 2. Palet Warna & Token (HEX & Tailwind)

### 2.1 Background Colors
| Peranan | HEX | Tailwind Class | Catatan |
| --- | --- | --- | --- |
| Primary BG (Kanvas Utama) | `#F8FAFC` | `bg-slate-50` | Latar belakang halaman |
| Surface / Card BG | `#FFFFFF` | `bg-white` | Kontainer kad, modal, dropdown |
| Secondary / Subtle BG | `#F1F5F9` | `bg-slate-100` | Input background, chip neutral |

### 2.2 Brand & Accent Colors
| Peranan | HEX | Tailwind Class | Catatan |
| --- | --- | --- | --- |
| Primary Accent | `#0F172A` | `bg-slate-900 text-white` | Butang CTA utama, state aktif |
| Primary Accent Hover | `#1E293B` | `hover:bg-slate-800` | Hover state CTA utama |
| Secondary Accent | `#3B82F6` | `text-blue-500` | Link, badge aktif, sorotan halus |

### 2.3 Typography Colors
| Peranan | HEX | Tailwind Class | Catatan |
| --- | --- | --- | --- |
| Heading / Title | `#0F172A` | `text-slate-900` | Tajuk skrin, tajuk kad |
| Body Text | `#334155` | `text-slate-700` | Teks perenggan, label form |
| Muted / Placeholder | `#64748B` | `text-slate-500` | Subtitle, placeholder input |

### 2.4 Status & Border Colors
| Peranan | HEX | Tailwind Class | Catatan |
| --- | --- | --- | --- |
| Border / Divider | `#E2E8F0` | `border-slate-200` | Garis sempadan kad dan input |
| Success | `#10B981` | `text-emerald-500 bg-emerald-50` | Status berjaya, paid, selesai |
| Warning | `#F59E0B` | `text-amber-500 bg-amber-50` | Status amaran, pending |
| Danger / Error | `#EF4444` | `text-red-500 bg-red-50` | Ralat, destructive action, batal |

---

## 3. Tipografi & Hierarki Teks

- **Font Family:** Inter / Plus Jakarta Sans / system-ui (`font-sans`)
- **Skala Tipografi:**
  - **Display / H1:** `text-2xl font-bold tracking-tight text-slate-900` (24px / 32px)
  - **Heading / H2:** `text-lg font-semibold text-slate-900` (18px / 28px)
  - **Subheading / H3:** `text-base font-medium text-slate-800` (16px / 24px)
  - **Body (Regular):** `text-sm font-normal text-slate-700 leading-relaxed` (14px / 20px)
  - **Caption / Label:** `text-xs font-medium text-slate-500 uppercase tracking-wider` (12px / 16px)
- **Kerapatan & Penjajaran:** Jarak baris selesa (`leading-relaxed`), tajuk padat (`tracking-tight`), label rata kiri.

---

## 4. Struktur Layout & Navigasi

### 4.1 Sistem Navigasi
- **Mobile (< 768px):** Bottom Navigation Bar tetap (`fixed bottom-0 left-0 right-0 z-40 bg-white border-t border-slate-200 py-2`), 3–5 menu ikon + label, sentiasa letak `pb-24` pada `<main>`.
- **Desktop (≥ 1024px):** Sidebar kiri (`w-64 border-r border-slate-200 bg-white`) atau Top Navigation Bar kemas (`border-b border-slate-200 bg-white`). Bottom nav DIHILANGKAN (`hidden md:flex` / `md:hidden`).

### 4.2 Grid & Spacing
- **Kontainer:** `max-w-7xl mx-auto px-4 sm:px-6 lg:px-8`
- **Sistem Gap:** Spacing berskala 4/8/12/16/24/32px (`gap-3`, `gap-4`, `gap-6`).
- **Penyusunan Konten:**
  - Mobile: Single column stack (`flex flex-col gap-4`).
  - Tablet: 2-column asymmetric (`grid grid-cols-1 md:grid-cols-2 gap-4`).
  - Desktop: Bento Grid / Multi-column dashboard (`grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-6`).

---

## 5. Bedah Komponen Detail (Component Breakdown)

### 5.1 Header / Hero Section
- Sapaan mesra, profil avatar (`w-10 h-10 rounded-full`), status pill, ikon notifikasi loceng dengan unread dot.
- Quick search bar atau action trigger padat.

### 5.2 Cards & Containers
- **Border Radius:** `rounded-2xl` (16px) untuk kad utama, `rounded-xl` (12px) untuk sub-elemen.
- **Border & Shadow:** Border halus `border border-slate-200`, bayangan minima `shadow-sm hover:shadow-md transition-shadow`.
- **Surface Effect:** Solid white `bg-white`, tiada card-in-card berlebihan.

### 5.3 Buttons, Badges & Inputs
- **Primary Button:** `h-11 px-5 bg-slate-900 hover:bg-slate-800 text-white text-sm font-medium rounded-xl transition-colors active:scale-95 inline-flex items-center justify-center gap-2`.
- **Secondary / Ghost Button:** `h-11 px-5 border border-slate-200 hover:bg-slate-50 text-slate-700 text-sm font-medium rounded-xl transition-colors`.
- **Inputs & Selects:** `h-11 px-3.5 bg-white border border-slate-300 focus:border-slate-900 focus:ring-1 focus:ring-slate-900 text-sm rounded-xl outline-none transition-all placeholder:text-slate-400`.
- **Status Badges:** `inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium` (ikut skema 2.4).

### 5.4 Data Visualization & List View
- Senarai rekod kemas dengan ikon kategori, teks dua baris (primary title + secondary timestamp/meta), serta nilai metrik atau status di hujung kanan.
- Jadual desktop dibalut `overflow-x-auto` atau ditukar kepada kad stack pada paparan mobile.

---

## 6. Detail Visual & Interaksi

- **Ikon:** Lucide Icons (`<i data-lucide="icon-name"></i>`), saiz seragam 16px/18px/20px, stroke-width 2px.
- **Interaksi & Hover:** Sentuhan mikro `transition duration-150 ease-in-out`, butang mengecut sedikit semasa klik (`active:scale-98`).
- **State Pengendalian:**
  - **Loading:** Skeleton placeholder beranimasi (`animate-pulse bg-slate-200 rounded-lg`).
  - **Empty State:** Ikon pudar dalam bulatan lembut, tajuk jelas, teks penerangan 1 baris, butang aksi segera.
  - **Error State:** Banner lembut merah (`bg-red-50 border border-red-200 text-red-700 text-sm p-4 rounded-xl`) dengan butang cuba semula.

---

## 7. Design System Blueprint (Siap Pakai untuk Webapp Builder)

```html
<!-- KONTRAK DESIGN SYSTEM & TOKEN UTAMA -->
<!-- Gunakan class Tailwind ini terus dalam pembangunan antaramuka Phase 3 -->
<div class="theme-tokens hidden"
     data-font="Inter, sans-serif"
     data-bg-canvas="bg-slate-50"
     data-bg-surface="bg-white"
     data-text-main="text-slate-900"
     data-text-muted="text-slate-500"
     data-border="border-slate-200"
     data-accent="bg-slate-900 text-white"
     data-accent-subtle="bg-slate-100 text-slate-800"
     data-radius-card="rounded-2xl"
     data-radius-btn="rounded-xl"
     data-touch-target="h-11 min-h-[44px]">
</div>
```

### Arahan Pelaksanaan:
1. Guna palet HEX & token di atas sebagai `:root` CSS variables atau konfigurasi Tailwind CDN.
2. Tiada mod gelap melainkan diminta secara nyata.
3. Patuhi prinsip responsif: 360px (mobile) hingga 1920px (desktop luas).
4. Pastikan setiap butang mempunyai `data-action` dan pengendalian logik sebenar.
