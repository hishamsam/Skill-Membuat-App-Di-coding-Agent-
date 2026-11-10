# Phase 1 — PRD Generation (TEMPLATE_PRD_MS.md)

Purpose: turn a rough idea + reference images into one PRD that locks down
requirements, technology, screens, and tests. The PRD is the Single Source of Truth
for all later phases.

## Input

- Idea / meeting notes / transcript.
- Reference images (if any) — put them in `projects/<slug>/refs/`.
- Answers to the 10 interview questions in `TEMPLATE_PRD_MS.md`.

## Steps

1. Create the project folder:

   ```bash
   bash scripts/new-project.sh <slug>
   ```

   Result:

   ```text
   projects/<slug>/
   ├── STATUS.md
   ├── STACK
   ├── prd/
   ├── refs/
   ├── design/exports/
   ├── app/
   └── tests/
   ```

2. Copy the idea and the image list into the conversation. If images exist, open and
   read them first (the agent must see the image, not guess).

3. Run the interview according to Part A of `TEMPLATE_PRD_MS.md`:
   - ONE question per message. Do not merge questions.
   - Every question has options A/B/C.
   - Dig into vague answers with follow-up questions before moving on.
   - Question A6 (technology) is MANDATORY before the PRD is written.
   - Ask all relevant A8 follow-up questions.

4. Generate the full PRD (Part B) and save it:

   ```text
   projects/<slug>/prd/PRD-v0.1.md
   ```

5. Update `projects/<slug>/STATUS.md`:

   ```text
   - [x] Phase 1 PRD
   - [ ] Phase 2 FigCraft
   ```

   If PRD Chapter 6 chooses a different stack from the argument to `new-project.sh`,
   align the file `projects/<slug>/STACK` with the final stack.

6. Show the PRD summary + the approval question. Stop.

## Technology options (A6)

| Code | Stack | When chosen | Phase 4 (local test) |
| --- | --- | --- | --- |
| A | GAS + Google Sheets | Internal, small data, Google ecosystem | Preview mode + `python3 -m http.server` |
| B | Supabase | Postgres + Auth + RLS + Storage | Supabase dev project (no Docker on this machine) |
| C | Cloudflare Worker | Edge API, D1/KV/R2, static assets | `npx wrangler dev` |
| D | Firebase | Firestore + Auth + Hosting, realtime | `firebase emulators:start` |
| E | Neon | Serverless Postgres + separate API | Worker/Vercel function + `wrangler dev` |
| F | Hybrid | A combination of two or more services | Follow the chosen services |
| G | Next.js + Postgres | SSR, SEO, UI + API in one project | `npm run dev` |
| H | Node/Express + Postgres | Custom API, full control | `npm run dev` / `npm start` |
| I | Laravel + MySQL | PHP, admin panel, ordinary hosting | `php artisan serve` |
| J | FastAPI/Django + Postgres | Python API, Django admin | `uvicorn` / `manage.py runserver` |

Rule: choose ONE main stack. Hybrid only if the user states
clearly which layer does what.

## PRD quality

- Every functional requirement has an ID and a priority.
- Every screen in Chapter 12.4 has 4 states (default/loading/empty/error).
- Chapter 12 is detailed enough to generate the FigCraft script without asking again.
- Chapter 13 has test commands and acceptance criteria that can be checked.
- No hidden assumptions: every assumption is marked `[ASSUMPTION]` in Chapter 5.
- No `{{...}}` placeholder left in the final file.

## Quick check before approval

```bash
grep -n "{{" projects/<slug>/prd/PRD-v0.1.md
```

Empty output = no placeholder left.

## Approval gate

After the PRD is shown:

> "Do you accept this PRD, or are there amendments? If you accept, reply 'pass' and I
> will continue to Phase 2 (FigCraft design)."

Do not start Phase 2 without clear approval.
