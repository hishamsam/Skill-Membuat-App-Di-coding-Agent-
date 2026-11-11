# UI/UX TECHNICAL DICTIONARY — Essential Reference for Visual Analysis & Design Systems

> **Purpose:** A technical vocabulary, visual reference standard, and UI/UX engineering rulebook for an LLM analyzing UI screenshots or mockups, extracting a Design System Blueprint, and generating production-grade interface code. It keeps output consistent, precise, and at the standard of tier-1 SaaS products (Linear, Stripe, Apple HIG), free of "AI slop" defects, and executable without ambiguity.
>
> **How to use:** Apply this document together with `ui-ux/ui-designer.md`, `TEMPLATE_PRD_MS.md` (Chapter 12), and `templates/DESIGN-BLUEPRINT.md`. The LLM must use the vocabulary, formulas, and standards defined here during visual audits and UI planning.
>
> **Format:** `term` : definition + technical parameters

---

## COLOR & THEME

- **Primary color** : The core brand identity color, allocated to primary CTAs, the active navigation item, and the main brand anchor.
- **Accent / Secondary** : A supporting color for second-level emphasis (badge highlights, interactive links, progress indicators).
- **Surface & Canvas Tiers** :
  - **Level 0 (Canvas/Background)** : The lowest page layer (`#F8FAFC` in light mode, `#09090B` in dark mode).
  - **Level 1 (Card/Container)** : The main component surface (`#FFFFFF` in light mode, `#121215` / `#18181B` in dark mode).
  - **Level 2 (Popover/Dropdown/Modal)** : A floating surface (`#FFFFFF` with a clear border and shadow in light mode, `#1E1E24` in dark mode).
  - **Level 3 (Tooltip/Toast)** : A high-contrast overlay element (`#0F172A` in light mode, `#27272A` in dark mode).
- **Chromatic / Tinted Neutrals** : A neutral palette (slate, zinc, gray) carrying 2%–5% of the brand hue (for example, cool slate with a blue hint, warm zinc with an amber hint). This avoids the dull, dirty grey produced by 100% desaturation.
- **Hex code** : A 6-digit hex value (#RRGGBB) or an 8-digit value with an alpha channel (#RRGGBBAA). Values must be precise, not subjective labels ("light blue").
- **OKLCH / HSL** : A perceptually uniform color space (the Tailwind v4 default) that keeps luminance consistent across hues.
- **Contrast ratio** : The text-to-background contrast ratio under WCAG 2.1:
  - Normal text (<18pt / 24px) : At least 4.5:1 (AA) or 7:1 (AAA).
  - Large text (≥18pt / 24px, or ≥14pt / 18.66px bold) : At least 3:1 (AA) or 4.5:1 (AAA).
  - Interactive UI components and borders : At least 3:1 against the surrounding background.
- **Semantic colors** : A functional color system with complete contrast pairings:
  - **Success** : Emerald/Green (`#10B981` / text `#065F46` / subtle background `#ECFDF5`).
  - **Warning** : Amber (`#F59E0B` / text `#92400E` / subtle background `#FFFBEB`).
  - **Danger / Error** : Rose/Red (`#EF4444` / text `#991B1B` / subtle background `#FEF2F2`).
  - **Info** : Sky/Blue (`#0EA5E9` / text `#075985` / subtle background `#F0F9FF`).
- **Semantic Badge Anatomy** : A standard status pill: 10%–15% tinted background, 1px border at 20%–30% opacity, saturated text (contrast ≥4.5:1), and a 6px round leading dot (`w-1.5 h-1.5 rounded-full`).

---

## TYPOGRAPHY

- **Geometric sans** : A sans-serif with clean geometric proportions (Inter, Geist Sans, Plus Jakarta Sans, SF Pro) — the industry standard for modern SaaS and B2B applications.
- **Humanist sans** : A sans-serif with organic calligraphic rhythm (Open Sans, Fira Sans) — friendly and instructional in tone.
- **Grotesque** : A solid Swiss-modern sans-serif (Helvetica Neue, Neue Haas Grotesk) — editorial and utilitarian.
- **Editorial serif** : A high-contrast serif (Playfair Display, Fraunces, Newsreader) — luxury goods, magazines, or authoritative landing pages.
- **Mono** : A monospaced font with uniform width (Geist Mono, JetBrains Mono, SF Mono) — code blocks, audit logs, hash IDs, and technical data.
- **Tabular figures (`tabular-nums`)** : Numerals with identical advance width inside a proportional font — **required** for financial tables, timers, KPI metrics, and counters so digits do not jitter when values change.
- **Type scale** : A proportional text-size scale:
  - Display / Hero : 48px–64px (line-height 1.05–1.15, tracking -0.03em)
  - H1 : 32px–40px (line-height 1.2, tracking -0.025em)
  - H2 : 24px–28px (line-height 1.25, tracking -0.02em)
  - H3 : 18px–20px (line-height 1.3, tracking -0.015em)
  - Body Regular : 14px–16px (line-height 1.5–1.6, tracking 0)
  - Caption / Helper : 12px–13px (line-height 1.4–1.5, tracking 0)
  - Eyebrow / Overline : 11px–12px, uppercase, tracking +0.05em to +0.1em. Discouraged in this workflow: do not place a small uppercase label above every heading. Use sentence case for labels, badges, and table heads.
- **Measure (Line Length)** : The ideal reading width is 45–75 characters per line (about 65ch / `max-w-prose`). Text beyond 85 characters tires the eye and makes it hard to find the next line.
- **Truncation with Affordance** : Long text is truncated with `truncate` (one line) or `line-clamp-2` (multiple lines) and **must** be paired with a native `title="..."` or a popover tooltip so the full text remains available.
- **Optical Centering** : Visual alignment of text inside buttons or badges, compensating for the font's bounding box (for example, offsetting the bottom padding of a capitalized font so it looks centered).

---

## LAYOUT, GRID & INFORMATION DENSITY

- **12-column grid** : A responsive desktop grid that divides cleanly into 2 (6+6), 3 (4+4+4), 4 (3+3+3+3), or asymmetric splits (8+4 / 9+3).
- **Responsive Breakpoint Matrix** :
  - **Desktop (≥ 1024px)** : 12 columns, 32px–64px outer margin, 24px–32px gap.
  - **Tablet (768px–1023px)** : 8 columns, 24px–32px margin, 16px–24px gap.
  - **Mobile (< 768px)** : 4 columns or a single-column stack, 16px margin, 12px–16px gap.
- **Information Density Archetypes** :
  - **Compact / High Density** : 32px–36px row height, 12px–13px font, 6px–8px padding. Used for developer tools, trading terminals, spreadsheets, and audit logs.
  - **Standard / Balanced** : 44px–48px row height, 14px font, 12px–16px padding. The standard for SaaS management applications, admin portals, and CRM systems.
  - **Relaxed / Marketing** : 56px–64px row height, 15px–16px font, 20px–32px padding. Used for landing pages, consumer onboarding, and checkout flows.
- **Bento grid** : A modern modular layout built from asymmetric card blocks that group features, charts, and metrics into one visual rhythm.
- **Sticky Header & Frosted Navbar** : A header that remains pinned while the page scrolls, using `backdrop-blur-md bg-white/80 border-b border-slate-200/80` (preventing text from colliding visually beneath it).
- **Mobile Safe Area & Bottom Nav** : Mobile bottom navigation must account for the iPhone and Android gesture bar: `padding-bottom: max(16px, env(safe-area-inset-bottom))`, plus `pb-24` on the `<main>` container so bottom action buttons are not covered.

---

## SPACING & RHYTHM

- **8px Grid System** : A spacing scale in multiples of 8 (4, 8, 16, 24, 32, 48, 64, 96px) that divides evenly into 1x, 2x, and 3x pixel densities without sub-pixel blur.
- **4px Half-Unit** : Micro-spacing (4px / 12px) for internal gaps inside dense components (icon to label, badge horizontal padding, input to helper text).
- **Whitespace / Breathing Room** : Measured empty space that separates logical contexts without extra dividers. Empty-space ratio: 35%–50% for SaaS, above 50% for editorial landing pages.
- **Asymmetric Vertical Rhythm** : The space above a heading **is always 2x–4x larger** than the space below it. This creates a clear visual affiliation between the heading and the content beneath it (Gestalt law of proximity).

---

## SHAPE & RADIUS

- **Concentric / Nested Radius Formula** : When a rounded element sits inside another rounded container, the inner radius **must be calculated**:
  $$r_{inner} = \max(0, r_{outer} - \text{padding})$$
  Without this formula, the curves look stiff, misaligned, and amateur.
- **Border Radius Tiers** :
  - **Sharp / Technical** : 0px–4px (`rounded-sm`). Developer tools and institutional financial platforms.
  - **Modern SaaS Balanced** : 8px–12px (`rounded-lg` / `rounded-xl`). The enterprise B2B gold standard.
  - **Soft / Consumer** : 16px–24px (`rounded-2xl` / `rounded-3xl`). Consumer mobile products, social apps, and education technology.
  - **Pill Shape** : 9999px (`rounded-full`). Reserved for badges, filter tags, avatars, and circular floating buttons.
- **Hairline Border** : A 1px semi-transparent boundary (`border border-slate-200/80` or `border-white/10`) that separates surfaces without adding visual weight.

---

## ELEVATION & DEPTH

- **Dual-Layer Shadow System (Ambient + Directional)** :
  A realistic shadow that mimics real-world lighting always has two layers:
  1. *Ambient Light* : A diffuse, low-offset spread (`0 1px 3px rgba(0,0,0,0.05)`).
  2. *Key Light* : A firmer shadow cast from above (`0 4px 6px -1px rgba(0,0,0,0.08)`).
  Combined: `box-shadow: 0 1px 2px 0 rgba(0,0,0,0.05), 0 4px 6px -1px rgba(0,0,0,0.08)`.
  *Absolute prohibition:* Never use a single heavy black shadow (`rgba(0,0,0,0.4)`).
- **Tonal Elevation (Dark Mode Principle)** :
  In dark mode, physical shadows do not register against a dark background. Elevation is created by **brightening the surface**:
  - Base: `#09090B`
  - Layer 1 (Card): `#18181B` + `border border-white/10`
  - Layer 2 (Modal): `#27272A` + `border border-white/15`
- **Glassmorphism Production Recipe** :
  - Background: `rgba(255, 255, 255, 0.75)` (light) or `rgba(24, 24, 27, 0.70)` (dark)
  - Filter: `backdrop-filter: blur(12px) saturate(160%)`
  - Border: `1px solid rgba(255, 255, 255, 0.3)` (light) or `1px solid rgba(255, 255, 255, 0.1)` (dark)
- **Glow & Border Beam** : A thin animated gradient accent on a card's border, marking featured or active state in modern AI products.

---

## COMPONENTS & DATA PRESENTATION

- **6 Interactive States** : Every interactive component (button, input, table row, link) **must define six states**:
  1. `Default` : The component's idle appearance.
  2. `Hover` : The pointer rests over it (5%–10% color shift, one elevation step).
  3. `Active / Pressed` : Tactile compression on click (`active:scale-[0.98]` or `active:brightness-95`).
  4. `Focus-Visible` : Keyboard accessibility through a separate ring (`focus-visible:ring-2 focus-visible:ring-offset-2`).
  5. `Disabled` : Inactive (`opacity-50 cursor-not-allowed pointer-events-none`).
  6. `Loading / Pending` : A processing indicator (integrated spinner, label changed to "Saving...").
- **Single Primary CTA Rule** : A viewport or page may contain **only one prominent primary CTA**. Alternative actions use the secondary style (outline or tinted), and supporting actions use the tertiary/ghost style.
- **Form Field Anatomy** :
  - A clear text label above the input (`text-xs font-semibold text-slate-700`).
  - A required/optional indicator (a red `*` or grey `(optional)` text).
  - An input container with a standard height (`h-10` / 40px or `h-11` / 44px) and balanced horizontal padding.
  - Leading/trailing icon slots for context (search, password eye, currency).
  - A helper/error message area whose **space is reserved in advance** to prevent layout shift when validation appears.
- **Data Table Layout Matrix** :
  - Text / name / description columns : **Left-aligned**.
  - Numeric / quantity / currency columns : **Right-aligned** + `font-mono tabular-nums`.
  - Date / short ID / status pill columns : **Center-aligned** or a structured left alignment.
  - Action columns (Edit/Delete/Menu) : **Pinned to the far right** with a fixed width (`w-16` / `w-20`).
- **Zero-State UX (Empty, Loading, Error)** :
  - **Empty State** : A measured illustration or icon (48px–64px maximum, never a giant banner), a descriptive title ("No invoices yet"), a short explanation of the cause, and one creating action ("Create invoice").
  - **Skeleton Screen** : A placeholder silhouette with dimensions identical to the final element (`animate-pulse bg-slate-200/80 rounded`), preventing sudden layout shift (Cumulative Layout Shift = 0).
  - **Error Recovery** : A human-readable error message with a direct recovery action ("Try again" / "Reload data").

---

## MOTION & TRANSITION ENGINEERING

- **GPU-Only Animation Rule** : Transition animations **may only manipulate GPU-accelerated properties**:
  - `transform` (`scale`, `translate`, `rotate`)
  - `opacity`
  *Absolute prohibition:* Never animate `width`, `height`, `top`, `left`, `margin`, or `padding`, because each forces the browser to recalculate the whole page layout (reflow) and drops the frame rate (jank).
- **Duration Scale** :
  - Micro-interactions (hover, toggle, click ripple) : **100ms–150ms** (responsive and snappy).
  - Component transitions (dropdown, accordion, modal pop) : **200ms–250ms**.
  - Page / sheet transitions (sidebar drawer, screen sliding) : **300ms–350ms**.
- **Easing Curves** :
  - Standard Ease-Out : `cubic-bezier(0.16, 1, 0.3, 1)` or `ease-out` — starts fast and decelerates smoothly on arrival.
  - Snappy Spring : `cubic-bezier(0.34, 1.56, 0.64, 1)` — a light organic bounce.
  - *Prohibition:* Avoid `linear` for interface motion except for continuous loading bars and progress counters.

---

## ACCESSIBILITY (A11Y) STANDARDS

- **WCAG 2.1 Level AA (Mandatory Baseline)** :
  - Regular text: minimum contrast 4.5:1.
  - Large text (≥24px or ≥18.66px bold): minimum contrast 3:1.
  - Form input borders and essential graphic elements: minimum contrast 3:1 against the background.
- **Minimum Touch Target** : The touch area of an interactive element on a touch screen is **at least 44×44 CSS pixels** (Apple HIG) or 48×48 pixels (Material Design). If an icon is 16×16px, add transparent padding or hit area until it reaches the 44px minimum.
- **Focus-Visible Ring Protocol** : Never remove the keyboard focus outline (`outline: none` with no replacement). Always provide an explicit focus ring:
  `focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-900 focus-visible:ring-offset-2`.
- **Semantic HTML & Screen Reader Labels** :
  - Use native elements: `<button>` for actions, `<a>` for page navigation, `<nav>`, `<main>`, `<aside>`.
  - Icon-only buttons must include `aria-label="Close dialog"` or a `<span class="sr-only">Close</span>`.

---

## ANTI-AI-SLOP RULES (Prohibited in Production Design)

1. **No cheap purple-blue gradients** : Do not use the AI-cliché gradient (`bg-gradient-to-r from-purple-600 to-blue-500`) on cards, buttons, or headings without a clear brand reason. Use weighted solid colors or a monochrome palette with a sharp accent.
2. **No emoji as system icons** : Do not place emoji (such as 🚀, 📊, ⚙️) as dashboard interface icons. Use a professional vector SVG library (Lucide Icons, Heroicons, Phosphor Icons).
3. **No native browser dialogs** : Never use `window.alert()`, `window.confirm()`, or `window.prompt()`. All confirmations and warnings must use styled modals or integrated toast notifications.
4. **No placeholder as a form label** : A placeholder disappears as soon as the user types, weakening recall. Always provide a permanent `<label>` outside the input box.
5. **No layout jitter on hover/focus** : Increasing border width from `border-1` to `border-2` on focus shifts the element by 1 pixel. Use `ring` or an inset `box-shadow` so the box model stays stable.
6. **No runaway horizontal scrollbar** : The main page must not have a horizontal scrollbar (`overflow-x-hidden` on the root; handle table wrappers specifically with `overflow-x-auto`).
7. **No dead buttons** : Every element that looks like a button must have a real interactive handler, visual feedback, or a disabled/loading status.

---

## DESIGN LANGUAGES & VISUAL STYLES

- **Modern Minimalist SaaS (Stripe / Vercel style)** :
  - Off-white canvas (`#FAFAFA`), solid white cards (`#FFFFFF`) with a hairline border (`#E4E4E7`).
  - High-contrast monochrome typography (Inter/Geist), a single deep-black accent (`#09090B`) or navy blue (`#0F172A`).
  - Tight spacing, very soft shadows, no extra ornament.
- **Linear / Raycast Dark Aesthetic** :
  - Premium dark background (`#09090B` / `#0C0C0E`), tiered surfaces (`#121215`, `#18181B`).
  - Precise hairline borders (`#27272A`), a subtle metallic gradient accent, inset-style keyboard shortcut badges (`<kbd>`).
  - High density (compact), snappy feedback, a keyboard-first power-user feel.
- **Apple Human Interface (Liquid Glass / HIG)** :
  - SF Pro / System Sans typography with bold titles and negative tracking.
  - Frosted translucent elements (`backdrop-blur-xl bg-white/70`), wide squircle corners (16px–24px radius).
  - Electric system blue accent (`#007AFF`) with a tiered button hierarchy (bordered-prominent, tinted, plain).
- **Bento Grid Architecture** :
  - Modular cards of varying size (span-2, span-1) inside a structured grid.
  - Wide corner radius (`rounded-2xl` / 16px–20px), split graphic content, large numeric metrics, and micro-illustrations.
- **Neubrutalism** :
  - Measured thick black borders (2px–3px solid `#000000`), hard shadow without blur (`box-shadow: 4px 4px 0px #000000`).
  - High-contrast background colors (yellow, cream, mint green), assertive bold typography.

---

## 20 RULES & RATIONALE — Reference Standard (Audit & Generation)

Standard format: **Rule** → **Formula** → **Why** → **Audit cue** → **Generation default**.

### 1. Spacing System (8px / 4px Grid)
- **Rule:** Every padding, margin, and gap is a multiple of the base unit.
- **Formula:** Token scale: 4, 8, 12, 16, 24, 32, 48, 64, 96px.
- **Why:** 8 divides evenly into Retina/high-DPI densities (1x, 2x, 3x) without sub-pixel blur; rem conversion stays clean (8px = 0.5rem); the modular progression sustains rhythm.
- **Audit cue:** Measure element spacing in the screenshot — is it consistent on multiples of 8 or 4? Flag odd values (13px, 19px, 27px) as inconsistency defects.
- **Generation default:** Base 8px for standard business and web applications; micro base 4px for developer tools and dense dashboards.

### 2. Column Grid per Breakpoint
- **Rule:** The column count changes with viewport width; gap width stays locked to the spacing token scale.
- **Formula:** Desktop ≥ 1024px: 12 columns; tablet 768px–1023px: 8 columns; mobile < 768px: 4 columns or a single stacked column.
- **Why:** 12 divides evenly by 2, 3, 4, and 6; a mobile viewport (360px–414px) has insufficient physical width for complex multi-column layouts without clipping text.
- **Audit cue:** Identify the container split at each breakpoint; verify that mobile does not force 3+ columns that clip text.
- **Generation default:** Responsive convention 12 / 8 / 4 with outer container padding `px-4 sm:px-6 lg:px-8`.

### 3. Typography Scale Ratio
- **Rule:** The heading scale follows an ordered geometric progression with a constant ratio ($Size_{n} = Size_{base} \times Ratio^{n}$).
- **Formula:** Dense SaaS UI: ratio 1.20–1.25 (Minor Third / Major Second); editorial and marketing: ratio 1.333–1.5 (Perfect Fourth / Augmented Fourth).
- **Why:** A large ratio (Golden Ratio 1.618) creates extreme jumps that waste vertical space in management applications; a 1.2–1.25 ratio provides enough hierarchy levels (H1 through caption) harmoniously.
- **Audit cue:** Calculate the ratio between H1, H2, H3, and body; verify a measured hierarchy that is not overly dramatic.
- **Generation default:** Ratio 1.25 for SaaS products; body 14px–16px as the base anchor.

### 4. Concentric Corner Radius Scale
- **Rule:** Component corner radius is proportional to its container, and nested corners must be concentric.
- **Formula:** $r_{inner} = \max(0, r_{outer} - \text{padding})$; pill: `border-radius: 9999px` or `h / 2`.
- **Why:** Nested curves with identical radius values look misaligned, overly thick at the corners, and break the illusion of physical depth.
- **Audit cue:** Compare the outer card radius with the radius of cards or buttons inside it; verify that the radius decreases as the container shrinks.
- **Generation default:** An outer card `rounded-2xl` (16px) with 16px padding contains buttons and inputs at `rounded-lg` (8px).

### 5. Element-First vs Content-First Sizing
- **Rule:** Interactive atomic components (button, input, avatar, badge) use a **fixed height**; variable-content containers (table rows, content cards, chat bubbles) use **height auto + consistent padding**.
- **Formula:** Dynamic containers: `min-height` as a floor plus fixed padding. Atomic elements: fixed height tokens (sm: 32px, md: 40px, lg: 48px).
- **Why:** Applying a fixed height to long-text containers causes clipping or overflow; consistent padding preserves visual rhythm without cutting content.
- **Audit cue:** Check for data rows or cards with clipped text caused by a fixed height; verify that buttons keep a consistent height.
- **Generation default:** Inputs and buttons always carry an explicit height class (`h-10` / `h-11`); cards and table rows use `h-auto py-3 px-4`.

### 6. Color Token Architecture
- **Rule:** A three-tier token architecture: primitive (raw hex) → semantic (functional role) → component (element-specific). Naming follows FUNCTION, not APPEARANCE.
- **Formula:** `--color-primary`, `--color-on-primary`, `--color-primary-hover`, `--color-surface-1`, `--color-border-subtle`.
- **Why:** Theme switching (light/dark) or rebranding only remaps the second-tier semantic tokens without touching hundreds of components.
- **Audit cue:** Confirm an `on-color` pairing that guarantees contrast (for example, a dark blue button always uses light text).
- **Generation default:** Always use semantic Tailwind tokens (`bg-primary text-primary-foreground`) rather than hard-coded hex values.

### 7. Soft Black & White (Neutral Avoidance)
- **Rule:** Avoid absolute `#000000` on dark backgrounds or large text areas; avoid raw `#FFFFFF` on large full-screen backgrounds.
- **Formula:** Soft dark: `#09090B`–`#18181B`; off-white canvas: `#F8FAFC`–`#FAFAFA`; card surface: `#FFFFFF`.
- **Why:** Absolute black over a wide screen creates a halation effect (letter edges appear to vibrate); pure white across an entire screen causes glare and eye fatigue. A pure white card on an off-white canvas naturally creates depth without heavy shadows.
- **Audit cue:** Check the main background hex; flag `#000000` or raw `#FFFFFF` across large areas.
- **Generation default:** Canvas `#F8FAFC` (Slate 50), card `#FFFFFF`, primary text `#0F172A` (Slate 900).

### 8. WCAG Contrast Compliance
- **Rule:** Regular text requires a contrast ratio of at least 4.5:1 against its background; large or bold text at least 3:1; interactive input borders at least 3:1.
- **Formula:** $L = 0.2126R + 0.7152G + 0.0722B$ (linearized sRGB); $\text{Contrast} = \frac{L_1 + 0.05}{L_2 + 0.05}$.
- **Why:** Guarantees legibility for users with impaired vision, in direct sunlight, or on low-quality displays.
- **Audit cue:** Test text contrast against its background, especially secondary text (muted text) and input placeholders.
- **Generation default:** Body text always uses Slate 700 (`#334155`) or darker on white (ratio > 7:1); placeholders at least Slate 400 (`#94A3B8`).

### 9. Line-Height & Vertical Grid Alignment
- **Rule:** `line-height = font-size × ratio`, aligned to a 4px multiple to preserve vertical rhythm.
- **Formula:** Display: 1.1–1.15; heading: 1.2–1.3; body: 1.5–1.6; caption: 1.4.
- **Why:** Line-height contributes directly to total row height; the correct ratio prevents ascender/descender collisions and helps the eye move between lines.
- **Audit cue:** Check paragraph text density; flag body text with a line-height that is too tight (<1.4) or too loose (>1.8).
- **Generation default:** Body text uses `leading-relaxed` (1.625) or `leading-normal` (1.5); headings use `leading-tight` (1.25) or `leading-none` (1.1).

### 10. Vertical Rhythm & Gestalt Proximity
- **Rule:** The space above a heading **is always 2x to 4x larger** than the space below it.
- **Formula:** `margin-top: 32px` vs `margin-bottom: 8px` (ratio 4:1). Spacing hierarchy: `section-gap > card-gap > heading-to-content > paragraph-to-paragraph`.
- **Why:** The Gestalt law of proximity shows that spatial closeness determines perceived relationships without explicit dividers.
- **Audit cue:** Check whether the heading's distance from the previous section equals its distance from the text below (a symmetry error).
- **Generation default:** Apply asymmetric margins to every section heading (`mt-8 mb-2` or `mt-6 mb-1.5`).

---

### 11. Single Primary Action Rule (CTA Dominance)
- **Rule:** Each screen or dialog may contain **only one primary action button**. Other actions must step down to secondary or ghost level.
- **Formula:** 1 primary (solid background, contrasting text) + N secondary (bordered or subtle background) + N tertiary (ghost/link).
- **Why:** Reduces cognitive load (Hick's law). Multiple buttons with equal visual weight cause hesitation and analysis paralysis.
- **Audit cue:** Check for two solid, saturated buttons side by side in one form or screen; flag it as a visual hierarchy violation.
- **Generation default:** Main submit button: solid and deep (`bg-slate-900 text-white`); cancel/back button: neutral outline (`border border-slate-200 text-slate-700 hover:bg-slate-50`).

### 12. Dual-Layer Ambient Shadow System
- **Rule:** Realistic shadows use two layers (diffuse ambient + vertical key light); a single heavy shadow is prohibited.
- **Formula:** `box-shadow: 0 1px 3px 0 rgba(0,0,0,0.04), 0 4px 6px -1px rgba(0,0,0,0.06);` (mid level: `0 4px 6px -2px rgba(0,0,0,0.05), 0 10px 15px -3px rgba(0,0,0,0.08);`).
- **Why:** In the real world, light reflects from the surrounding environment (ambient fill) while also arriving from a main source above (key light).
- **Audit cue:** Examine card shadows: do they look dirty or heavy and single-layered (`shadow-[0_10px_20px_rgba(0,0,0,0.4)]`), or soft and layered?
- **Generation default:** Use modern Tailwind utilities (`shadow-sm`, `shadow`, `shadow-md`), which already implement multi-layer box shadows.

### 13. Tabular Data Alignment & Tabular-Nums
- **Rule:** Data alignment in tables must follow the data type: text left-aligned, numbers and financial values right-aligned with `tabular-nums`.
- **Formula:** Metric and currency columns: `text-right font-mono tabular-nums`.
- **Why:** Right-aligning numbers allows instant visual comparison (hundreds, thousands, and millions line up vertically). `tabular-nums` prevents column-width shifting as values change.
- **Audit cue:** Check data tables: are numbers left-aligned? Do decimal digits look ragged vertically?
- **Generation default:** Table headers and numeric cells always carry `text-right tabular-nums`; primary text columns use `text-left`.

### 14. Jitter-Free Input Focus & Layout Stability
- **Rule:** The focus state must not change an element's box-model dimensions (never raise `border-width` from 1px to 2px).
- **Formula:** Keep `border-1px`; use `ring-2 ring-slate-900 ring-offset-2` or `outline: 2px solid`.
- **Why:** Abruptly changing border width enlarges the element by 1–2 pixels, pushes neighboring elements, and creates layout jitter (CLS).
- **Audit cue:** Click a text input; watch whether adjacent buttons or inputs vibrate or shift when focus activates.
- **Generation default:** Every form input uses: `border border-slate-300 focus:outline-none focus:ring-2 focus:ring-slate-900 focus:ring-offset-1 transition-shadow`.

### 15. Touch Target & Mobile Safe Area Compliance
- **Rule:** Touch-interactive areas are at least 44×44px; bottom elements must respect `env(safe-area-inset-bottom)`.
- **Formula:** `min-h-[44px] min-w-[44px]`; bottom bar container: `pb-[max(16px,env(safe-area-inset-bottom))]`.
- **Why:** A human fingertip contact patch is roughly 9–10mm; a 44–48 CSS px target provides sufficient error margin on typical phones. Elements at the bottom edge without a safe-area inset collide with the system gesture bar.
- **Audit cue:** Measure action-icon hit boxes at 390px mobile width; check whether the bottom navbar overlaps the system home bar.
- **Generation default:** Every mobile button has a wrapper with at least 44×44px padding; `<main>` always includes `pb-24` when bottom navigation is present.

### 16. Zero-State & Skeleton Layout Match (CLS = 0)
- **Rule:** A loading skeleton must have geometric dimensions identical to the final component it replaces.
- **Formula:** Skeleton card height and margin = loaded card height and margin.
- **Why:** Prevents Cumulative Layout Shift (CLS) spikes when data arrives, protecting Core Web Vitals scores and reading comfort.
- **Audit cue:** Compare the skeleton shape during loading with the populated view; verify that page height does not jump.
- **Generation default:** Provide a dedicated `<CardSkeleton />` with an exact height (`h-48`) that mirrors the final card layout.

### 17. Reading Measure Constraint (45–75 Characters)
- **Rule:** Paragraph and article text blocks are limited to 75 characters per line (~65ch).
- **Formula:** Paragraph text container: `max-w-prose` or `max-w-[65ch]`.
- **Why:** A line running from the far left to the far right of a 1920px monitor forces the user's head to turn, causing neck strain and making it hard to locate the next line.
- **Audit cue:** Check whether description or article text spans the full 100% width on a wide desktop monitor.
- **Generation default:** Wrap narrative text and long descriptions in `max-w-prose text-slate-700 leading-relaxed`.

### 18. GPU-Accelerated Micro-interactions
- **Rule:** Transition animations may only manipulate GPU properties (`transform`, `opacity`). Micro-interaction duration is 100ms–150ms.
- **Formula:** `transition-transform duration-150 ease-out active:scale-95 hover:-translate-y-0.5`.
- **Why:** Sustains 60/120 FPS without dropped frames; manipulating layout properties (`height`, `top`) triggers the slower CPU layout engine.
- **Audit cue:** Inspect CSS transition declarations: is there `transition: all` or a transition on `height`/`width`?
- **Generation default:** Specify transitions precisely: `transition-[transform,opacity] duration-150` or `transition-colors duration-150`.

### 19. Chromatic / Tinted Neutrals System (2%–5% Chroma)
- **Rule:** Neutral greys must carry a hint of the brand hue (2%–5% saturation) instead of raw monochrome grey.
- **Formula:** Use a themed scale: Slate (blue hint), Zinc (cool neutral hint), or Stone (friendly warm hint).
- **Why:** The human eye perceives fully desaturated grey as dull, cold, or concrete-like. A small amount of chroma gives the interface life.
- **Audit cue:** Check grey components: do they feel harmonious with the brand accent, or detached and dull?
- **Generation default:** Pair cool brand colors (blue/indigo/violet) with `slate-*`; pair warm brand colors (orange/brown/red) with `stone-*`.

### 20. Status Badge Anatomy & Semantic Pill Standards
- **Rule:** A functional status badge must combine a soft background (10%–15% opacity), saturated contrasting text (≥4.5:1), and a 6px leading indicator dot.
- **Formula:** `<span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-xs font-medium bg-{color}-50 text-{color}-700 border border-{color}-200/60"><span class="w-1.5 h-1.5 rounded-full bg-{color}-500"></span>Label</span>`.
- **Why:** The combination of a color dot and explicit text lets color-blind users understand status without relying on background color alone.
- **Audit cue:** Inspect status badges: is it just colored text with insufficient contrast and no standardized wrapper structure?
- **Generation default:** Standard badge: `rounded-full px-2.5 py-0.5 text-xs font-medium` with a round indicator dot before the text.

---

## VISUAL ANALYSIS GUIDELINES (For LLM Screenshot Audits)

During a visual audit of a screenshot, **use the technical terms from this dictionary**, not subjective or invented descriptions:

- **Good:** "The header uses `sticky top-0 z-30` with `backdrop-blur-md bg-white/80 border-b border-slate-200/80`. Heading typography uses the **geometric sans** Inter (H1 32px, line-height 1.2, tracking -0.025em) and meets **WCAG AA** with a 12:1 contrast ratio against the off-white canvas `#F8FAFC`."
- **Bad:** "The top part is somewhat transparent and the font looks nice and clear."
- **Good:** "The data table implements **Rule 13 (Tabular Data Alignment)**: numeric and currency columns are right-aligned with `tabular-nums`, status uses **Semantic Badge Anatomy** (bg-emerald-50 text-emerald-700 with a 6px leading dot), and rows have a soft hover state `hover:bg-slate-50/80`."
- **Bad:** "The table is neat and the status has some color."
- **Good:** "Nested card corners follow the concentric formula ($r_{inner} = r_{outer} - \text{padding}$): the outer card has a 16px radius (`rounded-2xl`) with 16px padding and contains a child button with an 8px radius (`rounded-lg`)."
- **Bad:** "The corners are rounded and match nicely."

**Core principle:** Every design claim must include technical vocabulary plus a measured numeric value (px, rem, hex, ratio, ms).

---

**END OF DICTIONARY.** Total: 50+ essential terms (vocabulary), anti-AI-slop guidance, and 20 reference rules with rationale (the audit and generation standard for production-grade interfaces).



