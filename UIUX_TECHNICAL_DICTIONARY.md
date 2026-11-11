# UI/UX TECHNICAL DICTIONARY — Essential Reference for Visual Analysis & Design System

> **Purpose:** Kamus istilah teknikal, piawaian acuan visual, dan peraturan kejuruteraan UI/UX untuk LLM saat menganalisis screenshot/mockup UI, mengekstrak Design System Blueprint, dan menghasilkan kode antarmuka produksi. Menjamin hasil desain konsisten, presisi, berkelas SaaS tier-1 (Linear, Stripe, Apple HIG), bebas dari cacat "AI slop", dan siap eksekusi tanpa ambiguitas.
>
> **Cara pakai:** Dipakai bersamaan dengan `ui-ux/ui-designer.md`, `TEMPLATE_PRD_MS.md` (Bab 12), dan `templates/DESIGN-BLUEPRINT.md`. LLM wajib memakai vocabulary, formula, dan piawaian acuan dari dokumen ini saat audit visual maupun saat perancangan UI.
>
> **Format:** `term` : definition + technical parameters

---

## COLOR & THEME

- **Primary color** : Warna identitas utama brand, dialokasikan untuk primary CTA, active navigation item, dan brand anchor utama.
- **Accent / Secondary** : Warna pendukung untuk penegasan hierarki kedua (badge highlight, link interaktif, progress indicator).
- **Surface & Canvas Tiers** :
  - **Level 0 (Canvas/Background)** : Latar halaman paling bawah (`#F8FAFC` di light mode, `#09090B` di dark mode).
  - **Level 1 (Card/Container)** : Permukaan komponen utama (`#FFFFFF` di light, `#121215` / `#18181B` di dark).
  - **Level 2 (Popover/Dropdown/Modal)** : Permukaan mengambang (`#FFFFFF` dengan border/shadow jelas di light, `#1E1E24` di dark).
  - **Level 3 (Tooltip/Toast)** : Elemen overlay kontras tinggi (`#0F172A` di light, `#27272A` di dark).
- **Chromatic / Tinted Neutrals** : Palet netral (slate/zinc/gray) yang diinjeksi 2%–5% saturasi warna brand (misal: cool slate dengan hint blue, warm zinc dengan hint amber). Menghindari abu-abu "mati/kotor" hasil desaturasi 100%.
- **Hex code** : Representasi 6-digit hex (#RRGGBB) atau 8-digit dengan kanal alpha (#RRGGBBAA) — wajib presisi, bukan sebutan subjektif ("biru muda").
- **OKLCH / HSL** : Color space modern berbasis persepsi mata manusia (Tailwind v4 default). Memastikan nilai luminance konsisten di berbagai rona warna (hue).
- **Contrast ratio** : Rasio kontras teks terhadap latar belakang menurut piawaian WCAG 2.1:
  - Teks normal (<18pt / 24px) : Wajib ≥4.5:1 (AA) atau ≥7:1 (AAA).
  - Teks besar (≥18pt / 24px atau ≥14pt / 18.66px bold) : Wajib ≥3:1 (AA) atau ≥4.5:1 (AAA).
  - Komponen antarmuka & border interaktif : Wajib ≥3:1 terhadap latar belakang sekitarnya.
- **Semantic colors** : Sistem warna berbasis makna fungsional dengan pairing kontras lengkap:
  - **Success** : Emerald/Green (`#10B981` / text `#065F46` / bg subtle `#ECFDF5`).
  - **Warning** : Amber (`#F59E0B` / text `#92400E` / bg subtle `#FFFBEB`).
  - **Danger / Error** : Rose/Red (`#EF4444` / text `#991B1B` / bg subtle `#FEF2F2`).
  - **Info** : Sky/Blue (`#0EA5E9` / text `#075985` / bg subtle `#F0F9FF`).
- **Semantic Badge Anatomy** : Format pill status biasa: background tint 10%–15%, border 1px dengan opasitas 20%–30%, teks warna pekat (contrast ≥4.5:1), serta leading dot indicator bulat 6px (`w-1.5 h-1.5 rounded-full`).

---

## TYPOGRAPHY

- **Geometric sans** : Sans-serif proporsi geometris bersih (Inter, Geist Sans, Plus Jakarta Sans, SF Pro) — piawaian industri SaaS modern dan aplikasi B2B.
- **Humanist sans** : Sans-serif dengan ritme kaligrafi organik (Open Sans, Fira Sans) — bernada ramah dan edukatif.
- **Grotesque** : Sans-serif solid khas Swiss modern (Helvetica Neue, Neue Haas Grotesk) — nuansa editorial dan utilitarian.
- **Editorial serif** : Huruf berkait kontras tinggi (Playfair Display, Fraunces, Newsreader) — segmen barang mewah, majalah, atau landing page berwibawa.
- **Mono** : Font monospace dengan lebar seragam (Geist Mono, JetBrains Mono, SF Mono) — blok kode, log audit, hash ID, dan representasi data teknikal.
- **Tabular figures (`tabular-nums`)** : Glif angka dengan lebar karakter monospaced yang sama pada font proporsional — **wajib** untuk tabel keuangan, jam/timer, metrik KPI, dan counter agar angka tidak melompat (jitter) saat berganti.
- **Type scale** : Skala ukuran teks proporsional:
  - Display / Hero : 48px–64px (line-height 1.05–1.15, tracking -0.03em)
  - H1 : 32px–40px (line-height 1.2, tracking -0.025em)
  - H2 : 24px–28px (line-height 1.25, tracking -0.02em)
  - H3 : 18px–20px (line-height 1.3, tracking -0.015em)
  - Body Regular : 14px–16px (line-height 1.5–1.6, tracking 0)
  - Caption / Helper : 12px–13px (line-height 1.4–1.5, tracking 0)
  - Eyebrow / Overline : 11px–12px, uppercase, tracking +0.05em to +0.1em. Discouraged in this workflow: do not place a small uppercase label above every heading. Use sentence case for labels, badges, and table heads.
- **Measure (Line Length)** : Panjang baris baca ideal: 45–75 karakter per baris (optimal ~65ch / `max-w-prose`). Teks melebihi 85 karakter menyebabkan mata cepat lelah dan kehilangan orientasi baris berikutnya.
- **Truncation with Affordance** : Pemotongan teks panjang menggunakan `truncate` (1 baris) atau `line-clamp-2` (multi-baris) yang **wajib dipadukan** dengan native `title="..."` atau popover tooltip agar teks utuh tetap dapat dibaca pengguna.
- **Optical Centering** : Penyelarasan visual teks pada tombol atau badge dengan kompensasi visual bounding box font (contoh: kompensasi padding bawah font kapital agar tepat di tengah secara optik).

---

## LAYOUT, GRID & INFORMATION DENSITY

- **12-column grid** : Grid responsif desktop yang mudah dibagi menjadi 2 (6+6), 3 (4+4+4), 4 (3+3+3+3), atau asimetris (8+4 / 9+3).
- **Responsive Breakpoint Matrix** :
  - **Desktop (≥ 1024px)** : 12 kolom, margin 32px–64px, gap 24px–32px.
  - **Tablet (768px–1023px)** : 8 kolom, margin 24px–32px, gap 16px–24px.
  - **Mobile (< 768px)** : 4 kolom / single column stack, margin 16px, gap 12px–16px.
- **Information Density Archetypes** :
  - **Compact / High Density** : Tinggi row 32px–36px, font 12px–13px, padding 6px–8px. Diterapkan untuk developer tools, trading terminal, spreadsheet, dan log audit.
  - **Standard / Balanced** : Tinggi row 44px–48px, font 14px, padding 12px–16px. Standar untuk aplikasi manajemen SaaS, admin portal, CRM.
  - **Relaxed / Marketing** : Tinggi row 56px–64px, font 15px–16px, padding 20px–32px. Diterapkan untuk landing page, consumer onboarding, checkout checkout flow.
- **Bento grid** : Komposisi layout modern modular berbasis kotak-kotak kartu asimetris yang mengelompokkan fitur, grafik, dan metrik dalam satu ritme visual terpadu.
- **Sticky Header & Frosted Navbar** : Header yang tetap menempel saat halaman di-scroll dengan efek `backdrop-blur-md bg-white/80 border-b border-slate-200/80` (mencegah tabrakan visual teks di bawah header).
- **Mobile Safe Area & Bottom Nav** : Navigasi bawah pada mobile wajib memperhitungkan gesture home bar iPhone/Android: `padding-bottom: max(16px, env(safe-area-inset-bottom))`, serta menambahkan `pb-24` pada kontainer `<main>` agar tombol aksi bawah tidak tertutup navigasi.

---

## SPACING & RHYTHM

- **8px Grid System** : Skala jarak berbasis kelipatan 8 (4, 8, 16, 24, 32, 48, 64, 96px) yang membagi habis kerapatan piksel layar 1x, 2x, 3x tanpa menghasilkan pecahan sub-pixel blur.
- **4px Half-Unit** : Spacing mikro (4px / 12px) khusus untuk jarak internal komponen padat (jarak ikon ke label, padding horizontal badge, jarak input ke helper text).
- **Whitespace / Breathing Room** : Area kosong terukur untuk memisahkan konteks logis tanpa perlu garis pembatas berlebihan. Rasio ruang kosong: 35%–50% untuk SaaS, >50% untuk editorial landing page.
- **Asymmetric Vertical Rhythm** : Jarak sebelum judul (space above) **selalu 2x–4x lebih besar** daripada jarak setelah judul ke kontennya (space below). Memberikan afiliasi visual yang jelas bahwa judul tersebut milik konten di bawahnya (Prinsip Proximity Gestalt).

---

## SHAPE & RADIUS

- **Concentric / Nested Radius Formula** : Saat ada elemen melengkung di dalam kontainer yang juga melengkung, radius sudut elemen dalam **wajib dihitung**:
  $$r_{inner} = \max(0, r_{outer} - \text{padding})$$
  Jika tidak dihitung dengan rumus ini, lengkungan akan terlihat kaku, tidak sejajar, dan amatir.
- **Border Radius Tiers** :
  - **Sharp / Technical** : 0px–4px (`rounded-sm`). Developer tools, platform finansial institutional.
  - **Modern SaaS Balanced** : 8px–12px (`rounded-lg` / `rounded-xl`). Standar emas enterprise B2B.
  - **Soft / Consumer** : 16px–24px (`rounded-2xl` / `rounded-3xl`). Produk mobile consumer, social, edutech.
  - **Pill Shape** : 9999px (`rounded-full`). Khusus badge, tag filter, avatar, dan floating button bulat.
- **Hairline Border** : Garis batas 1px semi-transparan (`border border-slate-200/80` atau `border-white/10`) sebagai pemisah struktur bidang tanpa membebani berat visual antarmuka.

---

## ELEVATION & DEPTH

- **Dual-Layer Shadow System (Ambient + Directional)** :
  Bayangan realistis yang meniru pencahayaan dunia nyata selalu terdiri dari 2 lapisan:
  1. *Ambient Light* : Sebaran cahaya difus tanpa offset vertikal besar (`0 1px 3px rgba(0,0,0,0.05)`).
  2. *Key Light* : Bayangan tegas dari arah atas ke bawah (`0 4px 6px -1px rgba(0,0,0,0.08)`).
  Gabungan: `box-shadow: 0 1px 2px 0 rgba(0,0,0,0.05), 0 4px 6px -1px rgba(0,0,0,0.08)`.
  *Pantangan mutlak:* Jangan gunakan bayangan tunggal hitam pekat (`rgba(0,0,0,0.4)`).
- **Tonal Elevation (Dark Mode Principle)** :
  Dalam dark mode, bayangan fisik tidak terlihat di atas latar belakang gelap. Elevasi dicapai dengan **menaikkan kecerahan permukaan** (surface brightening):
  - Base: `#09090B`
  - Layer 1 (Card): `#18181B` + `border border-white/10`
  - Layer 2 (Modal): `#27272A` + `border border-white/15`
- **Glassmorphism Production Recipe** :
  - Background: `rgba(255, 255, 255, 0.75)` (light) atau `rgba(24, 24, 27, 0.70)` (dark)
  - Filter: `backdrop-filter: blur(12px) saturate(160%)`
  - Border: `1px solid rgba(255, 255, 255, 0.3)` (light) atau `1px solid rgba(255, 255, 255, 0.1)` (dark)
- **Glow & Border Beam** : Aksen gradien tipis bergerak di tepi border kartu untuk menandai state featured/active pada produk AI modern.

---

## COMPONENTS & DATA PRESENTATION

- **6 Interactive States** : Setiap komponen interaktif (tombol, input, baris tabel, link) **wajib mendefinisikan 6 kondisi**:
  1. `Default` : Penampilan asal komponen saat idle.
  2. `Hover` : Kursor melayang di atas (perubahan warna 5%–10%, bayangan naik 1 tingkat).
  3. `Active / Pressed` : Kompresi fisik tactile saat diklik (`active:scale-[0.98]` atau `active:brightness-95`).
  4. `Focus-Visible` : Aksesibilitas keyboard via ring terpisah (`focus-visible:ring-2 focus-visible:ring-offset-2`).
  5. `Disabled` : Non-aktif (`opacity-50 cursor-not-allowed pointer-events-none`).
  6. `Loading / Pending` : Indikator pemrosesan (spinner terintegrasi, label berubah "Menyimpan...").
- **Single Primary CTA Rule** : Dalam satu viewport/halaman, hanya boleh ada **SATU tombol aksi utama (Primary CTA)** yang mencolok. Aksi alternatif menggunakan gaya Secondary (outline/tinted), dan aksi pelengkap menggunakan gaya Tertiary/Ghost.
- **Form Field Anatomy** :
  - Label teks jelas di atas input (`text-xs font-semibold text-slate-700`).
  - Indikator wajib/opsional (tanda `*` merah atau teks `(opsional)` abu-abu).
  - Kontainer input dengan tinggi baku (`h-10` / 40px atau `h-11` / 44px) dan padding horizontal seimbang.
  - Slot leading/trailing icon untuk konteks (search, mata password, currency).
  - Wadah pesan helper/error yang **sudah disediakan tempatnya secara stabil** untuk mencegah layout bergeser (layout jitter) saat validasi muncul.
- **Data Table Layout Matrix** :
  - Kolom teks / nama / deskripsi : **Rata Kiri (Left-aligned)**.
  - Kolom angka / jumlah / harga mata uang : **Rata Kanan (Right-aligned)** + `font-mono tabular-nums`.
  - Kolom tanggal / ID singkat / status pill : **Rata Tengah (Center-aligned)** atau Rata Kiri terstruktur.
  - Kolom aksi (Edit/Hapus/Menu) : **Pinned di sisi paling kanan** dengan lebar tetap (`w-16` / `w-20`).
- **Zero-State UX (Empty, Loading, Error)** :
  - **Empty State** : Ilustrasi/ikon terukur (maks 48px–64px, jangan banner raksasa), judul deskriptif ("Belum ada invoice"), penjelasan singkat penyebab, dan satu tombol aksi pembuat ("Buat Invoice Baru").
  - **Skeleton Screen** : Siluet placeholder dengan dimensi identik terhadap elemen akhir (`animate-pulse bg-slate-200/80 rounded`), mencegah pergeseran layout mendadak (Cumulative Layout Shift = 0).
  - **Error Recovery** : Pesan ralat yang manusiawi disertai tombol aksi pemulihan langsung ("Coba Lagi" / "Muat Ulang Data").

---

## MOTION & TRANSITION ENGINEERING

- **GPU-Only Animation Rule** : Animasi transisi **hanya boleh memanipulasi properti yang diakselerasi kartu grafis (GPU)**, iaitu:
  - `transform` (`scale`, `translate`, `rotate`)
  - `opacity`
  *Pantangan mutlak:* Jangan menganimasikan `width`, `height`, `top`, `left`, `margin`, `padding` karena memaksa browser menghitung ulang layout seluruh halaman (reflow) dan menyebabkan penurunan framerate (jank).
- **Duration Scale** :
  - Micro-interactions (hover, toggle, click ripple) : **100ms–150ms** (responsif, lincah).
  - Component transitions (dropdown, accordion, modal pop) : **200ms–250ms**.
  - Page / Sheet transitions (sidebar drawer, screen sliding) : **300ms–350ms**.
- **Easing Curves** :
  - Standard Ease-Out : `cubic-bezier(0.16, 1, 0.3, 1)` atau `ease-out` — mulai cepat, melambat halus saat tiba di target.
  - Snappy Spring : `cubic-bezier(0.34, 1.56, 0.64, 1)` — memberikan efek pantulan organik ringan.
  - *Pantangan:* Hindari `linear` untuk gerakan antarmuka pengguna kecuali untuk loading bar/progress counter tak terputus.

---

## ACCESSIBILITY (A11Y) STANDARDS

- **WCAG 2.1 Level AA (Mandatory Baseline)** :
  - Teks reguler kontras minimal 4.5:1.
  - Teks besar (≥24px atau ≥18.66px bold) kontras minimal 3:1.
  - Border input form & elemen grafis esensial kontras minimal 3:1 terhadap latar.
- **Minimum Touch Target** : Area sentuh elemen interaktif pada layar sentuh **minimal 44×44 CSS pixel** (Apple HIG) atau 48×48 pixel (Material Design). Jika ikon berukuran 16×16px, tambahkan padding/hit-area transparan hingga mencapai batas minimal 44px.
- **Focus-Visible Ring Protocol** : Jangan pernah menghapus outline keyboard focus (`outline: none` tanpa pengganti). Wajib sertakan cincin fokus eksplisit:
  `focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-900 focus-visible:ring-offset-2`.
- **Semantic HTML & Screen Reader Labels** :
  - Gunakan elemen asli: `<button>` untuk aksi, `<a>` untuk navigasi halaman, `<nav>`, `<main>`, `<aside>`.
  - Tombol yang hanya memuat ikon wajib menyertakan atribut `aria-label="Tutup dialog"` atau `<span class="sr-only">Tutup</span>`.

---

## ANTI-AI-SLOP RULES (Prohibited in Production Design)

1. **Dilarang Gradien Ungu-Kebiruan Murahan** : Jangan gunakan gradien klise AI (`bg-gradient-to-r from-purple-600 to-blue-500`) pada kartu, tombol, atau teks judul tanpa alasan brand yang jelas. Gunakan warna solid berbobot atau palet monokrom dengan aksen tajam.
2. **Dilarang Ikon Emoji Sebagai Pengganti Ikon Sistem** : Dilarang menempatkan emoji (seperti 🚀, 📊, ⚙️) sebagai ikon antarmuka dashboard. Wajib gunakan library SVG profesional berbasis vektor (Lucide Icons, Heroicons, Phosphor Icons).
3. **Dilarang Dialog Browser Bawaan** : Dilarang keras memakai `window.alert()`, `window.confirm()`, atau `window.prompt()`. Seluruh konfirmasi dan peringatan wajib menggunakan modal styled atau toast notification terintegrasi.
4. **Dilarang Placeholder Sebagai Pengganti Label Form** : Placeholder di dalam input akan hilang saat pengguna mulai mengetik, merusak daya ingat pengguna. Selalu sediakan `<label>` permanen di luar kotak input.
5. **Dilarang Layout Jitter Saat Hover/Focus** : Menambah ketebalan border dari `border-1` menjadi `border-2` saat focus menyebabkan elemen bergeser 1 piksel. Gunakan `ring` atau inset `box-shadow` agar ukuran box model tetap stabil.
6. **Dilarang Horizontal Scrollbar Liar** : Halaman utama tidak boleh memiliki scrollbar horizontal (`overflow-x-hidden` pada root, kelola pembungkus tabel secara spesifik dengan `overflow-x-auto`).
7. **Dilarang Tombol Mati (Dead Buttons)** : Setiap elemen yang tampak seperti tombol wajib memiliki handler interaktif nyata, feedback visual, atau feedback status disable/loading.

---

## DESIGN LANGUAGES & VISUAL STYLES

- **Modern Minimalist SaaS (Stripe / Vercel style)** :
  - Kanvas off-white (`#FAFAFA`), kartu solid white (`#FFFFFF`) dengan hairline border (`#E4E4E7`).
  - Tipografi monokrom berkontras tinggi (Inter/Geist), aksen tunggal hitam pekat (`#09090B`) atau biru navy (`#0F172A`).
  - Spacing rapi, bayangan sangat halus, tanpa ornamen berlebih.
- **Linear / Raycast Dark Aesthetic** :
  - Latar belakang dark premium (`#09090B` / `#0C0C0E`), permukaan bertingkat (`#121215`, `#18181B`).
  - Hairline border presisi (`#27272A`), aksen metallic gradient halus, keyboard shortcut badges (`<kbd>` bergaya inset).
  - Kerapatan tinggi (compact density), feedback lincah, nuansa power-user keyboard-first.
- **Apple Human Interface (Liquid Glass / HIG)** :
  - Tipografi SF Pro / System Sans dengan judul tebal dan pelacakan negatif.
  - Elemen tembus pandang bertekstur kaca (`backdrop-blur-xl bg-white/70`), sudut squircle membulat lebar (radius 16px–24px).
  - Warna aksen sistem biru elektrik (`#007AFF`) dengan hierarki tombol bertingkat (bordered-prominent, tinted, plain).
- **Bento Grid Architecture** :
  - Kartu modular dengan ukuran bervariasi (span-2, span-1) dalam grid terstruktur.
  - Radius sudut lebar (`rounded-2xl` / 16px–20px), pembagian konten grafis, metrik angka besar, dan ilustrasi mikro.
- **Neubrutalism** :
  - Garis tepi hitam tebal terukur (2px–3px solid `#000000`), bayangan keras tanpa blur (`box-shadow: 4px 4px 0px #000000`).
  - Warna latar belakang kontras tinggi (kuning, krem, hijau mint), tipografi bold tegas.

---

## 20 RULES & RATIONALE — Reference Standard (Audit & Generation)

Format piawaian: **Rule** (apa) → **Formula** (angka pasti) → **Why** (alasan teknikal) → **Audit cue** (yang dicek di visual) → **Generation default** (nilai baku implementasi).

### 1. Spacing System (8px / 4px Grid)
- **Rule:** Semua padding, margin, dan gap wajib kelipatan base unit.
- **Formula:** Skala token: 4, 8, 12, 16, 24, 32, 48, 64, 96px.
- **Why:** Angka 8 membagi habis densitas layar Retina/High-DPI (1x, 2x, 3x) tanpa sub-pixel blur; konversi rem bersih (8px = 0.5rem); menjaga ritme modular.
- **Audit cue:** Periksa jarak elemen di screenshot — apakah konsisten pada kelipatan 8 atau 4? Flag angka janggal (misal 13px, 19px, 27px) sebagai cacat inkonsistensi.
- **Generation default:** Base 8px untuk aplikasi perniagaan/web biasa; base 4px mikro untuk developer tool/dashboard padat.

### 2. Column Grid per Breakpoint
- **Rule:** Jumlah kolom berubah mengikuti lebar layar; lebar gap tetap terkunci pada skala spacing token.
- **Formula:** Desktop ≥ 1024px: 12 kolom; Tablet 768px–1023px: 8 kolom; Mobile < 768px: 4 kolom / 1 kolom bertumpuk.
- **Why:** 12 kolom membagi habis pembagian 2, 3, 4, dan 6; layar mobile (360px–414px) tidak memiliki ruang fisik cukup untuk multi-kolom kompleks tanpa memotong teks.
- **Audit cue:** Identifikasi pembagian kontainer per breakpoint; pastikan pada mobile tidak terjadi pemaksaan 3+ kolom yang menyebabkan teks terpotong.
- **Generation default:** Konvensi responsif 12 / 8 / 4 dengan padding kontainer luar `px-4 sm:px-6 lg:px-8`.

### 3. Typography Scale Ratio
- **Rule:** Skala heading mengikuti progresi geometris teratur berbasis rasio konstan ($Size_{n} = Size_{base} \times Ratio^{n}$).
- **Formula:** Dense SaaS UI: rasio 1.20–1.25 (Minor Third / Major Second); Editorial/Marketing: rasio 1.333–1.5 (Perfect Fourth / Augmented Fourth).
- **Why:** Rasio besar (Golden Ratio 1.618) menyebabkan lonjakan ekstrem yang memboroskan ruang vertikal pada aplikasi manajemen; rasio 1.2–1.25 menyediakan cukup variasi tingkat hierarki (H1 hingga caption) secara harmonis.
- **Audit cue:** Hitung rasio antara H1, H2, H3, dan body; pastikan ada hierarki terukur yang tidak terlalu drastis.
- **Generation default:** Rasio 1.25 untuk produk SaaS; body 14px–16px sebagai jangkar dasar.

### 4. Concentric Corner Radius Scale
- **Rule:** Radius sudut komponen proporsional terhadap dimensi wadahnya dan sudut bersarang (nested corners) wajib konsentris.
- **Formula:** $r_{inner} = \max(0, r_{outer} - \text{padding})$; Pill: `border-radius: 9999px` atau `h / 2`.
- **Why:** Kurva bersarang yang memiliki nilai radius identik akan terlihat tidak sejajar, tebal di sudut, dan merusak ilusi kedalaman fisik.
- **Audit cue:** Bandingkan radius kartu luar dengan kartu/elemen tombol di dalamnya; verifikasi apakah radius mengecil seiring mengecilnya wadah.
- **Generation default:** Kartu luar `rounded-2xl` (16px) dengan padding 16px memuat tombol/input ber-radius `rounded-lg` (8px).

### 5. Element-First vs Content-First Sizing
- **Rule:** Komponen atomik interaktif (button, input, avatar, badge) menggunakan **ukuran tinggi pasti (fixed height)**; kontainer data variatif (row tabel, card konten, chat bubble) menggunakan **height auto + padding konsisten**.
- **Formula:** Kontainer dinamis: `min-height` sebagai lantai + padding tetap. Elemen atomik: token tinggi pasti (sm: 32px, md: 40px, lg: 48px).
- **Why:** Memasang fixed height pada wadah teks panjang memicu text-clipping atau overflow; padding konsisten menjaga ritme visual tanpa memotong konten.
- **Audit cue:** Cek apakah ada baris data atau kartu dengan teks terpotong karena tinggi fixed; pastikan tombol memiliki tinggi konsisten.
- **Generation default:** Input & Button selalu memiliki class tinggi eksplisit (`h-10` / `h-11`); kartu dan baris tabel menggunakan `h-auto py-3 px-4`.

### 6. Color Token Architecture
- **Rule:** Arsitektur token 3 lapis: Primitive (Hex mentah) → Semantic (Peranan fungsional) → Component (Spesifik elemen). Penamaan berbasis FUNGSI, bukan PENAMPAKAN.
- **Formula:** `--color-primary`, `--color-on-primary`, `--color-primary-hover`, `--color-surface-1`, `--color-border-subtle`.
- **Why:** Pergantian tema (Light/Dark mode) atau rebranding hanya perlu memetakan ulang token semantic tingkat kedua tanpa menyentuh ratusan komponen.
- **Audit cue:** Pastikan ada pasangan `on-color` yang menjamin kontras (misal: tombol biru tua selalu memakai teks putih terang).
- **Generation default:** Selalu gunakan token semantik Tailwind (`bg-primary text-primary-foreground`) daripada hardcoded hex.

### 7. Soft Black & White (Neutral Avoidance)
- **Rule:** Hindari `#000000` absolut pada latar belakang gelap atau teks luas; hindari `#FFFFFF` mentah pada kanvas latar belakang layar luas.
- **Formula:** Soft dark: `#09090B`–`#18181B`; Off-white canvas: `#F8FAFC`–`#FAFAFA`; Card surface: `#FFFFFF`.
- **Why:** Hitam pekat absolut di layar lebar menimbulkan efek halasi visual (edge huruf bergetar di mata); putih murni di seluruh layar memicu silau mata (eye fatigue). Permukaan kartu putih murni di atas kanvas off-white secara alami menciptakan kedalaman visual tanpa shadow tebal.
- **Audit cue:** Cek hex background utama; flag jika kanvas memakai `#000000` atau `#FFFFFF` secara mentah pada area luas.
- **Generation default:** Kanvas `#F8FAFC` (Slate 50), kartu `#FFFFFF`, teks utama `#0F172A` (Slate 900).

### 8. WCAG Contrast Compliance
- **Rule:** Teks reguler wajib rasio kontras ≥ 4.5:1 terhadap background; teks besar / bold wajib ≥ 3:1; garis sempadan elemen input interaktif wajib ≥ 3:1.
- **Formula:** $L = 0.2126R + 0.7152G + 0.0722B$ (linearized sRGB); $\text{Contrast} = \frac{L_1 + 0.05}{L_2 + 0.05}$.
- **Why:** Menjamin keterbacaan untuk pengguna dengan gangguan penglihatan, di bawah sinar matahari langsung, atau pada layar berkualitas rendah.
- **Audit cue:** Uji kontras warna teks terhadap latarnya, khususnya warna teks sekunder (muted text) dan placeholder input.
- **Generation default:** Teks body selalu menggunakan Slate 700 (`#334155`) ke atas pada latar putih (rasio > 7:1); placeholder minimal Slate 400 (`#94A3B8`).

### 9. Line-Height & Vertical Grid Alignment
- **Rule:** `line-height = font-size × ratio`, diselaraskan dengan kelipatan 4px agar menjaga ritme vertikal.
- **Formula:** Display: 1.1–1.15; Heading: 1.2–1.3; Body: 1.5–1.6; Caption: 1.4.
- **Why:** Line-height berkontribusi langsung pada tinggi total baris; rasio yang tepat mencegah tumpang tindih ascender/descender dan memudahkan mata berpindah baris.
- **Audit cue:** Cek kerapatan teks perenggan; flag teks body dengan line-height terlalu sempit (<1.4) atau terlalu longgar (>1.8).
- **Generation default:** Body teks menggunakan `leading-relaxed` (1.625) atau `leading-normal` (1.5); Heading menggunakan `leading-tight` (1.25) atau `leading-none` (1.1).

### 10. Vertical Rhythm & Gestalt Proximity
- **Rule:** Jarak di atas heading **selalu 2x hingga 4x lebih besar** daripada jarak di bawah heading ke kontennya.
- **Formula:** `margin-top: 32px` vs `margin-bottom: 8px` (rasio 4:1). Hirarki jarak: `section-gap > card-gap > heading-to-content > paragraph-to-paragraph`.
- **Why:** Hukum Kedekatan Gestalt (Law of Proximity) membuktikan bahwa kedekatan spasial menentukan hubungan makna di otak manusia tanpa memerlukan garis pembatas eksplisit.
- **Audit cue:** Cek apakah jarak heading ke bagian sebelumnya sama besar dengan jarak ke teks di bawahnya (kesalahan simetris).
- **Generation default:** Terapkan margin asimetris pada setiap judul bab/seksyen (`mt-8 mb-2` atau `mt-6 mb-1.5`).

### 11. Single Primary Action Rule (CTA Dominance)
- **Rule:** Setiap tampilan layar atau dialog hanya boleh memiliki **satu Primary Action Button**. Aksi lain harus diturunkan ke level Secondary atau Ghost.
- **Formula:** 1 Primary (Solid bg, teks kontras) + N Secondary (Bordered/Subtle bg) + N Tertiary (Ghost/Link).
- **Why:** Mengurangi beban kognitif pengguna (Hick's Law). Beberapa tombol dengan visual weight yang sama memicu keraguan ("analysis paralysis").
- **Audit cue:** Periksa apakah ada dua tombol solid pekat berdampingan di satu form/layar; flag sebagai pelanggaran hierarki visual.
- **Generation default:** Tombol submit utama: solid pekat (`bg-slate-900 text-white`); tombol batal/kembali: outline netral (`border border-slate-200 text-slate-700 hover:bg-slate-50`).

### 12. Dual-Layer Ambient Shadow System
- **Rule:** Bayangan realistis terdiri dari dua lapis (difus ambient + terarah vertikal); bayangan satu lapis pekat dilarang.
- **Formula:** `box-shadow: 0 1px 3px 0 rgba(0,0,0,0.04), 0 4px 6px -1px rgba(0,0,0,0.06);` (tingkat menengah: `0 4px 6px -2px rgba(0,0,0,0.05), 0 10px 15px -3px rgba(0,0,0,0.08);`).
- **Why:** Di alam nyata, cahaya dipantulkan oleh lingkungan sekitar (ambient fill) sekaligus datang dari sumber utama di atas (key light).
- **Audit cue:** Periksa bayangan kartu: apakah terlihat kotor/pekat satu lapis (`shadow-[0_10px_20px_rgba(0,0,0,0.4)]`), atau halus berlapis?
- **Generation default:** Gunakan utility modern Tailwind (`shadow-sm`, `shadow`, `shadow-md`) yang sudah mengimplementasikan multi-layering box-shadow.

### 13. Tabular Data Alignment & Tabular-Nums
- **Rule:** Penjajaran data dalam tabel wajib mengikuti tipe datanya: teks rata kiri, angka/finansial rata kanan dengan fitur `tabular-nums`.
- **Formula:** Kolom metrik & mata uang: `text-right font-mono tabular-nums`.
- **Why:** Penjajaran angka ke kanan memungkinkan pembandingan nilai visual secara instan (digit ratusan, ribuan, jutaan sejajar lurus vertikal). `tabular-nums` mencegah pergeseran lebar kolom saat angka berubah.
- **Audit cue:** Cek tabel data: apakah angka rata kiri? Apakah desimal/digit berantakan secara vertikal?
- **Generation default:** Tabel header dan sel angka selalu memiliki class `text-right tabular-nums`; kolom teks utama `text-left`.

### 14. Jitter-Free Input Focus & Layout Stability
- **Rule:** State fokus tidak boleh mengubah dimensi box model elemen (dilarang menaikkan `border-width` dari 1px ke 2px).
- **Formula:** Pertahankan `border-1px`, gunakan `ring-2 ring-slate-900 ring-offset-2` atau `outline: 2px solid`.
- **Why:** Mengubah border-width mendadak membesarkan ukuran fisik elemen sebanyak 1–2 piksel, mendorong elemen tetangga dan menciptakan getaran layout (layout jitter / CLS).
- **Audit cue:** Klik pada input teks; amati apakah tombol atau input di sebelahnya bergetar/bergeser saat fokus aktif.
- **Generation default:** Seluruh input form menggunakan: `border border-slate-300 focus:outline-none focus:ring-2 focus:ring-slate-900 focus:ring-offset-1 transition-shadow`.

### 15. Touch Target & Mobile Safe Area Compliance
- **Rule:** Area interaktif sentuh minimal 44×44px; elemen bawah wajib menghormati `env(safe-area-inset-bottom)`.
- **Formula:** `min-h-[44px] min-w-[44px]`; kontainer bottom bar: `pb-[max(16px,env(safe-area-inset-bottom))]`.
- **Why:** Contact patch jari manusia berukuran kira-kira 9–10mm; sasaran 44–48 CSS px memberi margin ralat yang mencukupi pada telefon biasa. Elemen di bawah skrin tanpa safe-area inset akan bertembung dengan gesture bar sistem operasi.
- **Audit cue:** Ukur hit-box ikon aksi pada resolusi mobile 390px; periksa apakah bottom navbar bertabrakan dengan home bar sistem.
- **Generation default:** Setiap tombol mobile memiliki wrapper padding minimal 44×44px; `<main>` selalu menyertakan `pb-24` jika ada bottom navigation.

### 16. Zero-State & Skeleton Layout Match (CLS = 0)
- **Rule:** Skeleton loading harus memiliki dimensi geometris yang identik dengan komponen final yang sedang dimuat.
- **Formula:** Tinggi dan margin skeleton card = tinggi dan margin loaded card.
- **Why:** Mencegah lonjakan Cumulative Layout Shift (CLS) saat data selesai diambil dari server, menjaga skor Core Web Vitals dan kenyamanan membaca pengguna.
- **Audit cue:** Bandingkan bentuk skeleton saat loading dengan tampilan setelah data muncul; pastikan tidak terjadi lonjakan tinggi halaman.
- **Generation default:** Sediakan komponen `<CardSkeleton />` khusus dengan tinggi persis (`h-48`) yang merefleksikan layout kartu akhir.

### 17. Reading Measure Constraint (45–75 Characters)
- **Rule:** Lebar blok teks perenggan/artikel dibatasi maksimal 75 karakter per baris (~65ch).
- **Formula:** Kontainer teks perenggan: `max-w-prose` atau `max-w-[65ch]`.
- **Why:** Baris teks yang membentang dari ujung kiri layar ke ujung kanan monitor 1920px memaksa kepala pengguna menoleh, memicu keletihan otot leher dan kesulitan mencari baris selanjutnya.
- **Audit cue:** Cek apakah teks deskripsi atau artikel membentang penuh 100% pada layar monitor desktop lebar.
- **Generation default:** Bungkus blok teks narasi dan deskripsi panjang dengan class `max-w-prose text-slate-700 leading-relaxed`.

### 18. GPU-Accelerated Micro-interactions
- **Rule:** Animasi transisi hanya boleh memanipulasi properti GPU (`transform`, `opacity`). Durasi interaksi mikro 100ms–150ms.
- **Formula:** `transition-transform duration-150 ease-out active:scale-95 hover:-translate-y-0.5`.
- **Why:** Mempertahankan 60/120 FPS tanpa frame drop; manipulasi layout (`height`, `top`) memicu layout engine CPU yang lambat.
- **Audit cue:** Periksa deklarasi CSS transition: apakah ada `transition: all` atau transisi pada `height`/`width`?
- **Generation default:** Spesifikasikan transisi secara ketat: `transition-[transform,opacity] duration-150` atau `transition-colors duration-150`.

### 19. Chromatic / Tinted Neutrals System (2%–5% Chroma)
- **Rule:** Warna abu-abu netral (neutral grays) wajib diberi hint rona warna brand (2%–5% saturasi) daripada abu-abu monokrom mentah.
- **Formula:** Gunakan skala warna bertema: Slate (hint biru), Zinc (hint dingin netral), atau Stone (hint hangat bersahabat).
- **Why:** Layar mata manusia mempersepsikan abu-abu murni desaturasi 100% sebagai kusam, dingin, atau tampak seperti semen mati. Sentuhan sedikit kroma memberi nyawa pada antarmuka.
- **Audit cue:** Cek komponen abu-abu: apakah terasa harmonis dengan warna aksen brand atau terasa terpisah dan kusam?
- **Generation default:** Pasangkan brand warna dingin (biru/indigo/violet) dengan `slate-*`; pasangkan brand hangat (oranye/cokelat/merah) dengan `stone-*`.

### 20. Status Badge Anatomy & Semantic Pill Standards
- **Rule:** Badge status fungsional wajib terdiri dari background lembut (10%–15% opacity), teks warna pekat yang kontras (≥4.5:1), dan leading indicator dot 6px.
- **Formula:** `<span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-xs font-medium bg-{color}-50 text-{color}-700 border border-{color}-200/60"><span class="w-1.5 h-1.5 rounded-full bg-{color}-500"></span>Label</span>`.
- **Why:** Kombinasi dot warna + teks eksplisit memastikan pengguna yang mengalami buta warna (color-blindness) tetap dapat memahami status tanpa bergantung semata pada warna latar.
- **Audit cue:** Periksa status badge: apakah hanya berupa teks berwarna tanpa kontras yang cukup atau tanpa struktur visual pembungkus yang terstandarisasi?
- **Generation default:** Standar badge: `rounded-full px-2.5 py-0.5 text-xs font-medium` dengan dot indikator bulat di depan teks.

---

## PEDOMAN ANALISIS VISUAL (Untuk Audit Screenshot LLM)

Saat melakukan visual audit dari screenshot, **wajib gunakan istilah teknikal dari kamus ini**, bukan istilah subjektif atau karangan:

- **Good:** "Header menggunakan `sticky top-0 z-30` dengan efek `backdrop-blur-md bg-white/80 border-b border-slate-200/80`. Tipografi judul menggunakan **geometric sans** Inter (H1 32px line-height 1.2 tracking -0.025em), memenuhi **WCAG AA** dengan rasio kontras 12:1 terhadap kanvas off-white `#F8FAFC`."
- **Bad:** "Bagian atasnya agak transparan dan font-nya bagus dan jelas."
- **Good:** "Tabel data mengimplementasikan **Rule 13 (Tabular Data Alignment)**: kolom numerik dan mata uang rata kanan dengan `tabular-nums`, status menggunakan **Semantic Badge Anatomy** (bg-emerald-50 text-emerald-700 dengan 6px leading dot), dan baris memiliki hover state halus `hover:bg-slate-50/80`."
- **Bad:** "Tabelnya rapi, ada warnanya di status."
- **Good:** "Nested corner radius pada kartu mematuhi formula konsentris ($r_{inner} = r_{outer} - \text{padding}$): kartu luar ber-radius 16px (`rounded-2xl`) dengan padding 16px, memuat child button ber-radius 8px (`rounded-lg`)."
- **Bad:** "Sudut-sudutnya membulat serasi."

**Prinsip Utama:** Setiap klaim desain wajib menyertakan vocabulary teknikal + nilai numerik terukur (px, rem, hex, ratio, ms).

---

**END OF DICTIONARY.** Total: 50+ istilah esensial (vocabulary), panduan anti-AI-slop, dan 20 peraturan acuan & rationale (piawaian acuan audit & generation kelas produksi).
