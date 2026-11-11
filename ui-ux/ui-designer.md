---
name: webappbuilder-ui-designer
description: "Extract a detailed UI/UX design specification from reference images (screenshots, mockups, or application designs) into a structured text document and a Design System Blueprint ready to combine with the WebApp Builder skill. Use when the user attaches a UI image and requests design analysis, a visual breakdown, a style reference, or a UI specification for building a web application."
---
# UI Designer

This skill analyzes user-supplied interface reference images and translates them into a comprehensive, structured, text-based design specification that the WebApp Builder skill can execute directly.

## When to Use

- The user attaches an image (application screenshot, mockup, Dribbble shot, or wireframe) and requests a UI analysis or specification.
- The user wants to extract the visual style, colors, typography, and layout from an image as a reference before building an application.
- The user asks for a "UI breakdown", "use this image as a reference", or "write a design specification from this image" to combine with the WebApp Builder skill.

## Steps

1. **Identify the Primary Design Character & Style**
   Determine the visual style category of the attached image (for example: Modern Minimalist, Glassmorphism, Neumorphism, Bento Grid, Clean Corporate, Playful/Gamified, or Dark Mode Futuristic) together with its overall impression and intended audience.

2. **Extract the Color Palette & Visual Tokens**
   Identify the main colors in the image and convert them to HEX codes with the nearest Tailwind CSS class equivalents:
   - **Background Colors**: Primary background (Primary BG), secondary/surface background (Card/Modal BG).
   - **Brand/Accent Colors**: Main button color, active elements, and highlights (Primary & Secondary Accent).
   - **Text/Typography Colors**: Heading text, body text, and muted text (Muted/Placeholder).
   - **Status & Border Colors**: Border/divider color plus status indicators where present (Success, Warning, Danger).

3. **Analyze Typography & Text Hierarchy**
   Describe the text characteristics visible in the reference:
   - Recommended font family (for example: Inter, Plus Jakarta Sans, Poppins, or Roboto).
   - Size and weight hierarchy (Heading, Subheading, Body, Caption/Label).
   - Text density (line-height, letter-spacing) and alignment.

4. **Break Down Layout & Navigation**
   Describe the page structure in full:
   - **Navigation System**: Position and form of navigation (for example: mobile-app-style bottom navigation bar, sidebar, top navbar, or floating action button).
   - **Grid Structure & Spacing**: Content arrangement pattern (single-column mobile-first, Bento Grid, two-column asymmetric, etc.), estimated container padding, and element gaps.
   - **Responsiveness**: How the layout must adapt on smartphone (mobile-first) and desktop screens.

5. **Detail the UI Components (Component Breakdown)**
   List every specific component visible in the image, top to bottom, with its shape details:
   - **Header / Hero Section**: Avatar, greeting, notification icon, search bar, or banner.
   - **Cards & Containers**: Corner radius (`rounded-xl`, `rounded-2xl`, `rounded-3xl`), shadow style (`shadow-sm`, `shadow-lg`, or flat with a thin border), and background effect (solid, gradient, or blur/glass).
   - **Buttons, Badges & Inputs**: Button shape (pill/rounded-full or rounded-lg), form input style, filter chips, or navigation tabs.
   - **Data Visualization / Lists**: Charts, progress bars, tables, or item lists.

6. **Recommend Interaction & Micro-interactions**
   Give brief guidance on transitions, hover/active effects, loading states (skeletons), and the most suitable icon library (for example Lucide Icons, Heroicons, or Phosphor Icons) so the final WebApp Builder result feels alive.

7. **Assemble the Blueprint Prompt for WebApp Builder**
   At the very end, summarize the entire analysis into one compact, instructional **"Design System Blueprint (Ready for WebApp Builder)"** block. This section is designed to be read directly by the agent executing the WebApp Builder skill in the next stage.

## Output Format

Present the response in clear, structured English using the following section order:

- **1. Design Character & Style (UI Style)**
- **2. Color Palette & Tokens (HEX & Tailwind)**
- **3. Typography & Hierarchy**
- **4. Layout & Navigation Structure**
- **5. Detailed Component Breakdown**
- **6. Visual Detail & Interaction (Shadows, Radius, Icons)**
- **7. Design System Blueprint (for WebApp Builder)**

## Gotchas

- **Do not write full application code**: This skill focuses on providing text descriptions, categories, and detailed UI design specifications. Do not generate complete application HTML/JS code unless the user explicitly requests it outside the analysis.
- **Provide concrete, measurable values**: Avoid vague descriptions such as "slightly curved corners" or "light blue". Use measurable terms such as "heavily rounded corners (`rounded-2xl` / 16px)" and specific HEX codes (for example `#3B82F6` / `bg-blue-500`).
- **Ready to combine**: Ensure section 7 (Design System Blueprint) states the UI rules firmly enough that when the user invokes the WebApp Builder skill (Supabase, Firebase, or GAS), the visual style from the image is applied accurately.
