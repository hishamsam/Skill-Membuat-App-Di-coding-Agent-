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
   - [ ] Phase 2 UI Design (DESIGN-BLUEPRINT.md)
   ```

   If PRD Chapter 6 chooses a different stack from the argument to `new-project.sh`,
   align the file `projects/<slug>/STACK` with the final stack.

6. Show the PRD summary + the approval question. Stop.

## Technology options (A6)

| Code | Tier | Stack | In plain words: choose when | Phase 4 (local test) |
| --- | --- | --- | --- | --- |
| A | 2 | GAS + Google Sheets | A spreadsheet with an app on top; only a tiny internal tool, under ~100 users, under ~10,000 rows | Preview mode + `python3 -m http.server` |
| B | 1 | Supabase (PostgreSQL) | A ready-made online database with login and file storage; most web apps | Supabase dev project (no Docker on this machine) |
| C | 1 | Cloudflare Workers | Answers fast worldwide; high traffic, small data, static pages | `npx wrangler dev` |
| D | 1 | Firebase | Google's app platform; live updates, mobile apps, easy login | `firebase emulators:start` |
| E | 2 | Neon | Database only; a small program still sits in front | Worker/Vercel function + `wrangler dev` |
| F | 2 | Hybrid | Two or more services already in use, each doing one job | Follow the chosen services |
| G | 1 | Next.js + PostgreSQL | Pages and data in one project; pages can be found on Google | `npm run dev` |
| H | 1 | Node/Express + PostgreSQL | Your own server program; full control | `npm run dev` / `npm start` |
| I | 1 | Laravel + MySQL | PHP framework with a ready admin page | `php artisan serve` |
| J | 1 | Django or FastAPI + PostgreSQL | Python framework with a ready admin page | `uvicorn` / `manage.py runserver` |
| K | 1 | Flutter | One code base for website + Android + iPhone | Varies with the backend |

When asking A6, read the fourth column to the user, not the product names.

Recommendation rule: propose **Tier 1 only**. Tier 2 exists for projects that
already depend on it; offer it only when the user asks, state its limits, and
keep the closest Tier 1 alternative on the table.

Rule: choose ONE main stack. Hybrid only if the user states
clearly which layer does what.

## PRD quality

- Chapter 3 includes a complete Role-Based Access Control (RBAC) permissions matrix across all entities.
- Every functional requirement in Chapter 7 has an ID, User Story, business rules, input validation matrix, Given-When-Then acceptance criteria, and edge cases.
- Chapter 8 details primary happy path, state lifecycle transitions, and toast/feedback states.
- Chapter 9 specifies the complete data dictionary, API endpoint request/response contracts, and physical DDL schema with RLS.
- Chapter 10 details performance budgets (LCP < 1.5s, CLS = 0), OWASP security controls, WCAG AA accessibility, and audit logging.
- Chapter 12 is detailed enough to extract the Design System Blueprint directly, strictly adhering to `UIUX_TECHNICAL_DICTIONARY.md` (3-tier tokens, density archetypes, 4 screen states, 6-state buttons).
- Every screen in Chapter 12.4 defines all 4 mandatory states (Default, Loading/Skeleton, Empty/Zero-state, Error/Retry).
- Chapter 13 provides concrete local test commands, deterministic demo accounts/seed data, and test cases.
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
> will continue to Phase 2 (UI Design dari lampiran gambar)."
Do not start Phase 2 without clear approval.
