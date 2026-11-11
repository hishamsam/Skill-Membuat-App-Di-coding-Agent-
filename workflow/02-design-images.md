# Phase 2 — UI Design from Attached Images (UI Designer)

Purpose: analyze interface reference images (application screenshots, mockups, Dribbble shots, or wireframes) supplied by the user in `projects/<slug>/refs/`, extract a detailed design specification, and produce a structured text document plus a **Design System Blueprint** (`projects/<slug>/design/DESIGN-BLUEPRINT.md`) that Phase 3 (Codegen) can execute directly.

Primary module reference: `ui-ux/ui-designer.md`.

Mandatory standard: `UIUX_TECHNICAL_DICTIONARY.md` — 20 technical rules (three-tier color tokens, spacing scale, concentric radius formula, dual-layer shadow system, information density, component states, and anti-AI-slop prohibitions). Every specification in `DESIGN-BLUEPRINT.md` must comply with those rules.

---

## 1. Input

- `projects/<slug>/prd/PRD-v0.1.md` (especially Chapter 12 — UI Contract).
- Reference images placed in `projects/<slug>/refs/`.

> **Note:** The agent opens and reads the image files in `refs/` directly. Never guess or ignore visual details in the supplied screenshots.

---

## 2. Seven Design Analysis Steps (UI Designer Protocol)

### Step 1: Identify the primary design character and style (UI Style)
Determine the visual style category from the reference image:
- Style: Modern Minimalist, Glassmorphism, Bento Grid, Clean Corporate, Playful/Gamified, or Dark Mode Futuristic (default: Light Mode unless the user requests dark mode).
- State the overall impression (mood/tone) and its intended audience.

### Step 2: Extract the color palette and visual tokens (HEX & Tailwind)
Identify the main colors in the image and convert them to exact HEX codes with matching Tailwind CSS classes:
- **Background Colors**: Primary canvas (Primary BG), surface/card BG, secondary/subtle BG.
- **Brand/Accent Colors**: Primary button (CTA), active elements, and highlights (Primary & Secondary Accent).
- **Text/Typography Colors**: Heading text, body text, and muted text/placeholder.
- **Status & Border Colors**: Border/divider lines plus Success, Warning, and Danger status colors.

### Step 3: Analyze typography and text hierarchy
Describe the text characteristics in the reference image:
- Recommended font (for example: Inter, Plus Jakarta Sans, Poppins, or Roboto).
- Size and weight hierarchy (H1/Display, H2/Heading, H3/Subheading, Body Regular, Caption/Label).
- Line spacing (`line-height`), letter spacing (`letter-spacing`), and text alignment (`text-left`, `text-center`).

### Step 4: Break down layout and navigation
Describe the page structure in full:
- **Navigation system**:
  - *Mobile (< 768px)*: Dedicated bottom navigation bar (3–5 icon + label items, `fixed bottom-0`, `pb-24` on the main container).
  - *Desktop (≥ 1024px)*: Left sidebar or a clean top navbar. Hide the bottom nav on desktop.
- **Grid structure and spacing**: Content arrangement pattern (single-column mobile-first, Bento Grid, two-column asymmetric), container padding, and gap scale (4/8/12/16/24/32px).
- **Responsiveness**: Map how the layout adapts from a small screen (360px) to a wide monitor (1920px).

### Step 5: Detail the UI components (Component Breakdown)
List every specific component visible in the image, top to bottom:
- **Header / Hero Section**: User avatar, greeting text, notification bell icon, search bar, status chips.
- **Cards & Containers**: Corner radius (`rounded-xl`, `rounded-2xl`, 16px), shadow style (`shadow-sm`, `shadow-md`), border (`border border-slate-200`), and surface background.
- **Buttons, Badges & Inputs**: Button shape (minimum height 44px / `h-11`, `rounded-xl`), input fields with clear placeholders and a compact focus ring, status pill badges.
- **Data Visualization & Lists**: Record list style (two-row title + meta), compact charts, progress bars, or tables with horizontal scroll on narrow viewports.

### Step 6: Recommend interaction and micro-interactions
- Transitions: `transition duration-150 ease-in-out`, soft scale on active buttons (`active:scale-95`).
- Icon library: Lucide Icons (`data-lucide="..."`), consistent at 16px/18px/20px.
- Handling the four states:
  1. *Default*: Normal view with realistic sample data.
  2. *Loading*: Animated skeleton frame (`animate-pulse`).
  3. *Empty*: Muted illustration/icon, one clear message line, an add action button.
  4. *Error*: Warning banner with a retry button.

### Step 7: Assemble the Design System Blueprint (ready for Codegen)
Summarize the full analysis into a compact, instructional block that Phase 3 Codegen can copy or reference directly.

---

## 3. Document Output Format

Save the analysis to:

```text
projects/<slug>/design/DESIGN-BLUEPRINT.md
```

Use the seven-part structure:

1. **Design Character & Style (UI Style)**
2. **Color Palette & Tokens (HEX & Tailwind)**
3. **Typography & Hierarchy**
4. **Layout & Navigation Structure**
5. **Detailed Component Breakdown**
6. **Visual Detail & Interaction (Shadows, Radius, Icons)**
7. **Design System Blueprint (for WebApp Builder)**

---

## 4. Gotchas & Strict Rules

1. **Do not write full application code at this stage:** Phase 2 focuses on producing a detailed text specification and design token blueprint. Do not generate `index.html` or full code before Phase 3.
2. **Provide concrete, measurable values:** Avoid vague descriptions such as "a slightly blue color" or "a somewhat curved corner". Use `#3B82F6 / bg-blue-500` and `rounded-2xl (16px)`.
3. **A mobile reference is not a width constraint:** A phone screenshot is a composition reference only. The final Phase 3 code must be responsive from 360px to 1920px.
4. **Always review before coding:** Show the blueprint summary to the user and ask for confirmation before entering Phase 3 (except in auto mode, where the process continues automatically).

---

## 5. Phase 2 Output File Structure

```text
projects/<slug>/
├── refs/
│   ├── screen-1.png
│   └── screen-2.png
└── design/
    └── DESIGN-BLUEPRINT.md
```
