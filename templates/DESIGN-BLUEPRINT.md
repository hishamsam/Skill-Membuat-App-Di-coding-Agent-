# Design System Blueprint — {{SLUG}}

A detailed UI/UX design specification extracted from reference images (screenshots, mockups, or application designs) in `projects/{{SLUG}}/refs/`. It serves as the visual contract and direct implementation guide for Phase 3 Codegen.

**Mandatory standard:** every value below must comply with `UIUX_TECHNICAL_DICTIONARY.md` (20 rules and formulas). Any deviation must be recorded and justified.

---

## 1. Design Character & Style (UI Style)

- **Primary Style:** <!-- Example: Modern Minimalist, Glassmorphism, Neumorphism, Bento Grid, Clean Corporate, Playful/Gamified, Dark Mode Futuristic -->
- **Visual Impression (Aura/Mood):** <!-- Example: Professional, calm, concise, premium, utilitarian -->
- **Target Users & Context:** <!-- Example: B2B dashboard, mobile field workers, e-commerce consumers -->
- **Anti-AI-Slop Guidelines:** Light mode by default; no cheap purple-blue gradients; no gradient text; no emoji icons; clean, measured borders.

---

## 2. Color Palette & Tokens (HEX & Tailwind)

### 2.1 Background Colors
| Role | HEX | Tailwind Class | Notes |
| --- | --- | --- | --- |
| Primary BG (Main Canvas) | `#F8FAFC` | `bg-slate-50` | Page background |
| Surface / Card BG | `#FFFFFF` | `bg-white` | Card, modal, and dropdown containers |
| Secondary / Subtle BG | `#F1F5F9` | `bg-slate-100` | Input background, neutral chips |

### 2.2 Brand & Accent Colors
| Role | HEX | Tailwind Class | Notes |
| --- | --- | --- | --- |
| Primary Accent | `#0F172A` | `bg-slate-900 text-white` | Primary CTA button, active state |
| Primary Accent Hover | `#1E293B` | `hover:bg-slate-800` | Hover state for the primary CTA |
| Secondary Accent | `#3B82F6` | `text-blue-500` | Links, active badges, subtle highlights |

### 2.3 Typography Colors
| Role | HEX | Tailwind Class | Notes |
| --- | --- | --- | --- |
| Heading / Title | `#0F172A` | `text-slate-900` | Screen titles, card titles |
| Body Text | `#334155` | `text-slate-700` | Paragraph text, form labels |
| Muted / Placeholder | `#64748B` | `text-slate-500` | Subtitles, input placeholders |

### 2.4 Status & Border Colors
| Role | HEX | Tailwind Class | Notes |
| --- | --- | --- | --- |
| Border / Divider | `#E2E8F0` | `border-slate-200` | Card and input borders |
| Success | `#10B981` | `text-emerald-500 bg-emerald-50` | Completed, paid, successful status |
| Warning | `#F59E0B` | `text-amber-500 bg-amber-50` | Warning status, pending |
| Danger / Error | `#EF4444` | `text-red-500 bg-red-50` | Errors, destructive actions, cancellation |

---

## 3. Typography & Text Hierarchy

- **Font Family:** Inter / Plus Jakarta Sans / system-ui (`font-sans`)
- **Type Scale:**
  - **Display / H1:** `text-2xl font-bold tracking-tight text-slate-900` (24px / 32px)
  - **Heading / H2:** `text-lg font-semibold text-slate-900` (18px / 28px)
  - **Subheading / H3:** `text-base font-medium text-slate-800` (16px / 24px)
  - **Body (Regular):** `text-sm font-normal text-slate-700 leading-relaxed` (14px / 20px)
  - **Caption / Label:** `text-xs font-medium text-slate-500` (12px / 16px). Sentence case; no uppercase or letter-spacing.
- **Density & Alignment:** Comfortable line spacing (`leading-relaxed`), tight headings (`tracking-tight`), left-aligned labels.

---

## 4. Layout & Navigation Structure

### 4.1 Navigation System
- **Mobile (< 768px):** Fixed bottom navigation bar (`fixed bottom-0 left-0 right-0 z-40 bg-white border-t border-slate-200 py-2`), 3–5 icon + label items, always apply `pb-24` to `<main>`.
- **Desktop (≥ 1024px):** Left sidebar (`w-64 border-r border-slate-200 bg-white`) or a clean top navigation bar (`border-b border-slate-200 bg-white`). The bottom nav is REMOVED (`hidden md:flex` / `md:hidden`).

### 4.2 Grid & Spacing
- **Container:** `max-w-7xl mx-auto px-4 sm:px-6 lg:px-8`
- **Gap System:** Spacing on a 4/8/12/16/24/32px scale (`gap-3`, `gap-4`, `gap-6`).
- **Content Arrangement:**
  - Mobile: Single-column stack (`flex flex-col gap-4`).
  - Tablet: Two-column asymmetric (`grid grid-cols-1 md:grid-cols-2 gap-4`).
  - Desktop: Bento Grid / multi-column dashboard (`grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-6`).

---

## 5. Detailed Component Breakdown

### 5.1 Header / Hero Section
- Friendly greeting, avatar profile (`w-10 h-10 rounded-full`), status pill, notification bell icon with an unread dot.
- Quick search bar or a compact action trigger.

### 5.2 Cards & Containers
- **Border Radius:** `rounded-2xl` (16px) for main cards, `rounded-xl` (12px) for sub-elements.
- **Border & Shadow:** Subtle border `border border-slate-200`, minimal shadow `shadow-sm hover:shadow-md transition-shadow`.
- **Surface Effect:** Solid white `bg-white`; no excessive card-in-card nesting.

### 5.3 Buttons, Badges & Inputs
- **Primary Button:** `h-11 px-5 bg-slate-900 hover:bg-slate-800 text-white text-sm font-medium rounded-xl transition-colors active:scale-95 inline-flex items-center justify-center gap-2`.
- **Secondary / Ghost Button:** `h-11 px-5 border border-slate-200 hover:bg-slate-50 text-slate-700 text-sm font-medium rounded-xl transition-colors`.
- **Inputs & Selects:** `h-11 px-3.5 bg-white border border-slate-300 focus:border-slate-900 focus:ring-1 focus:ring-slate-900 text-sm rounded-xl outline-none transition-all placeholder:text-slate-400`.
- **Status Badges:** `inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium` (follow scheme 2.4).

### 5.4 Data Visualization & List View
- A clean record list with category icons, two-line text (primary title + secondary timestamp/meta), and a metric value or status at the far right.
- Desktop tables wrapped in `overflow-x-auto` or converted to stacked cards on mobile.

---

## 6. Visual Detail & Interaction

- **Icons:** Lucide Icons (`<i data-lucide="icon-name"></i>`), consistent sizes 16px/18px/20px, stroke-width 2px.
- **Interaction & Hover:** Micro-transitions `transition duration-150 ease-in-out`, buttons compress slightly on click (`active:scale-98`).
- **State Handling:**
  - **Loading:** Animated skeleton placeholder (`animate-pulse bg-slate-200 rounded-lg`).
  - **Empty State:** Muted icon inside a soft circle, clear title, one-line description, immediate action button.
  - **Error State:** Soft red banner (`bg-red-50 border border-red-200 text-red-700 text-sm p-4 rounded-xl`) with a retry button.

---

## 7. Design System Blueprint (Ready for WebApp Builder)

```html
<!-- DESIGN SYSTEM CONTRACT & PRIMARY TOKENS -->
<!-- Use these Tailwind classes directly in Phase 3 interface development -->
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

### Implementation Instructions:
1. Use the HEX palette and tokens above as `:root` CSS variables or Tailwind CDN configuration.
2. No dark mode unless explicitly requested.
3. Follow the responsive principle: 360px (mobile) through 1920px (wide desktop).
4. Ensure every button has `data-action` and a real logic handler.
