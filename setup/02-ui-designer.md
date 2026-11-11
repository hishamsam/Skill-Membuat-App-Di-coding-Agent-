# 02 — UI Designer (Image Attachments)

Phase 2 extracts a detailed UI/UX design specification from interface reference images (screenshots, application mockups, or wireframes) supplied by the user in `projects/<slug>/refs/`.

This approach removes the need for external design software or a live MCP server: direct image analysis produces a structured text document and a **Design System Blueprint** (`projects/<slug>/design/DESIGN-BLUEPRINT.md`).

---

## 1. Input Sources (Image Attachments)

Reference images are stored in the project folder:

```text
projects/<slug>/refs/
├── dashboard.png
├── mobile-screen.jpg
└── wireframe.png
```

The agent reads these image files directly, without an external intermediary.

---

## 2. Seven Design Analysis Steps

Based on the UI Designer reference module:

1. **Identify the Primary Design Character & Style (UI Style)**: Assess whether the style is Modern Minimalist, Glassmorphism, Bento Grid, Clean Corporate, Playful, etc.
2. **Extract the Color Palette & Tokens (HEX & Tailwind)**: Determine exact color values for Background, Surface, Primary Accent, Text, Border, and Status Alerts.
3. **Analyze Typography & Hierarchy**: Select a suitable font (Inter, Plus Jakarta Sans, Poppins) and map the scale from heading through caption.
4. **Break Down Layout & Navigation**: Define the navigation arrangement (mobile bottom nav vs desktop sidebar/top nav), container padding, and responsive grid.
5. **Detailed Component Breakdown**: Analyze the header, card/container shapes, border radius, shadows, buttons, form inputs, and record lists.
6. **Visual Detail & Interaction**: Define icons (Lucide Icons), hover transitions, and key states (loading skeleton, empty state, error state).
7. **Design System Blueprint**: Produce an instructional summary block ready for Phase 3 Codegen.

---

## 3. Output Format

The analysis is saved to:

```text
projects/<slug>/design/DESIGN-BLUEPRINT.md
```

This file becomes the primary visual reference throughout application code development in Phase 3.

---

## 4. Advantages of Using No Third-Party Software

- **No port or connection issues**: No live port such as 7979 and no additional desktop application.
- **Cross-platform compatible**: Works identically on Linux, macOS, and Windows without extra subsystems.
- **Accurate Tailwind tokens**: HEX codes and Tailwind classes map directly into ready-to-use frontend code.
