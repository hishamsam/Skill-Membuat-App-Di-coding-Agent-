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
   - Write for a layperson: no jargon, everyday examples.
   - Every question has 3–4 ready options A/B/C(/D) plus **Other**, and ONE
     recommendation with a reason. The recommendation is not an answer.
   - Dig into vague answers with follow-up questions before moving on.
   - An unanswered question stops the interview. Re-ask it in simpler words;
     never continue with a gap.
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

| Code | Stack | In plain words: choose when | Phase 4 (local test) |
| --- | --- | --- | --- |
| A | GAS + Google Sheets | A spreadsheet with an app on top; internal team, under ~100 users, under ~10,000 rows | Preview mode + `python3 -m http.server` |
| B | Supabase | A ready-made online database with login and file storage; most web apps | Supabase dev project (no Docker on this machine) |
| C | Cloudflare Worker | Answers fast worldwide; high traffic, small data, static pages | `npx wrangler dev` |
| D | Firebase | Google's app platform; live updates, mobile apps, easy login | `firebase emulators:start` |
| E | Neon | Database only; a small program still sits in front | Worker/Vercel function + `wrangler dev` |
| F | Hybrid | Two or more services, each doing one job | Follow the chosen services |
| G | Next.js + Postgres | Pages and data in one project; pages can be found on Google | `npm run dev` |
| H | Node/Express + Postgres | Your own server program; full control | `npm run dev` / `npm start` |
| I | Laravel + MySQL | PHP framework with a ready admin page | `php artisan serve` |
| J | FastAPI/Django + Postgres | Python framework with a ready admin page | `uvicorn` / `manage.py runserver` |
| K | Flutter | One code base for website + Android + iPhone | Varies with the backend |

When asking A6, read the third column to the user, not the product names.

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
