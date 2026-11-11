# Phase 3 — Responsive Code Generation

Purpose: turn the PRD + Design System Blueprint (`design/DESIGN-BLUEPRINT.md`) + lampiran images in `refs/` into an application that works, is responsive,
and is secure. The attached reference design is a composition reference, not a width lock.

## Input

- `projects/<slug>/prd/PRD-v0.1.md` (Chapters 6, 7, 9, 12, 13)
- `projects/<slug>/design/DESIGN-BLUEPRINT.md`
- `projects/<slug>/refs/*` (gambar rujukan antarmuka)
- The stack in PRD Chapter 6.

## Responsive contract (MANDATORY)

A mobile design reference does NOT mean mobile-only code.
The code must work from 360px to 1920px.

| Range | Target | Navigation | Content grid |
| --- | --- | --- | --- |
| 360–639px | Phone | Bottom nav with 3–5 items | 1 column |
| 640–1023px | Tablet | Simple top bar / rail | 1–2 columns |
| 1024–1439px | Laptop | Sidebar / full top nav | 2–3 columns |
| ≥ 1440px | Desktop | Same, constrained container | 3–4 columns |

Hard rules:

- The `viewport` meta is present.
- No horizontal scroll on `body` / root.
- Tables: `overflow-x-auto` OR switch to a card list below `md`.
- Modal: `w-[calc(100%-2rem)] max-w-lg max-h-[85vh] overflow-y-auto`.
- Buttons/inputs: minimum height 44px, button text `whitespace-nowrap`.
- Mobile navigation: bottom nav with safe padding + `pb-24` on `<main>`.
- Desktop navigation: normal sidebar/top bar; do NOT show the bottom nav on desktop.
- Text: `clamp()` or the class `text-sm md:text-base`; no clipped text.
- The design must show desktop, not a stretched mobile.

## Steps

1. Generate the implementation table from the PRD:

   ```text
   | # | PRD requirement | Screen | File | Status |
   |---|---------------|-------|------|--------|
   | 1 | AUTH-1        | S-01  | app  | [ ]    |
   ```

2. Extract the tokens from `DESIGN-BLUEPRINT.md` into one place:
   - Tailwind `tailwind.config` or a `:root` CSS variables block.
   - Role names (`ink`, `surface`, `line`, `accent`), not scattered hex.
3. Build the files per stack (see below).

4. Check every button has a `data-action` and a real logic branch.

5. Work module by module. For each module: write the code, run its test, commit
   it, then start the next one (see below).

6. Run `bash scripts/qa-check.sh <slug>` until it passes.

7. Run `bash scripts/security-audit.sh <slug>` and clear every `FAIL` before the
   security gate (Phase 4.5).

8. Update `STATUS.md`: Phase 3 done.

## Module loop (MANDATORY)

A module is one screen plus the handler, endpoint, and data it needs. Never build
the whole app before testing anything.

For every module:

1. **Build** the module end to end: UI, handler or endpoint, validation, and the
   loading, empty, and error states.
2. **Test** it against the running app:

   ```bash
   bash scripts/test-local.sh <slug> --check --path <route>
   bash scripts/qa-check.sh <slug>
   ```

   `--path` repeats; one flag per module route. A non-200 response fails the run.
   Record the real output in the `STATUS.md` Modules table.
3. **Fix** failures before moving on. Do not stack unverified modules.
4. **Commit** the module in the project's local repository:

   ```bash
   bash scripts/git-save.sh <slug> "feat(module-<n>): <module name> + tests"
   ```

5. **Record** the module row in `STATUS.md`: module, screen/route, test evidence,
   commit id.

Rules:

- A module is not done until its test passes and the commit exists.
- Commit messages: `feat(module-<n>): ...`, `fix(...)`, `chore(...)`,
  `security(...)`, `test(...)`.
- `projects/<slug>/.git` is a separate local repository; the skill repo ignores
  `projects/*` so project history never pollutes the skill history.
- Never commit `.env`, `.dev.vars`, keys, or exports with personal data.

## File layout per stack

### A — GAS

```text
projects/<slug>/app/
├── index.html          # one whole file: HTML + Tailwind CDN + JS
├── Code.gs             # doPost router, auth, LockService, batch sheet
└── appsscript.json     # timezone, webapp access
```

Follow the GAS standard in `SKILL.md` (batch `getValues`, `LockService`,
SHA-256 + salt, HMAC token, `setupDatabase()`).

### B — Supabase

```text
projects/<slug>/app/
├── public/index.html   # or a single-file index.html
├── supabase/migrations/0001_init.sql
├── supabase/migrations/0002_rls.sql
└── .env.example        # SUPABASE_URL, SUPABASE_ANON_KEY
```

- The client uses `@supabase/supabase-js` (CDN or bundler).
- RLS is MANDATORY on for every table.
- `service_role` only in an Edge Function / server; never in the client.
- Auth: use Supabase Auth, do not rebuild password hashing yourself.

### C — Cloudflare Worker

```text
projects/<slug>/app/
├── public/             # static assets
├── src/index.js        # fetch handler / API
├── migrations/0001_init.sql
├── wrangler.jsonc
└── .dev.vars           # local secrets (do not commit)
```

- D1/KV/R2 bindings per PRD Chapter 9.2.
- `wrangler.jsonc` has `assets.directory` for the static frontend.
- Input is validated on the server; do not trust the raw body.

### D — Firebase

```text
projects/<slug>/app/
├── public/index.html
├── firebase.json
├── firestore.rules
└── firestore.indexes.json
```

- `firestore.rules` locks read/write per role.
- Use Firebase Auth; do not store passwords yourself.
- Emulator only for tests; production configuration in a separate file.

### E — Neon

```text
projects/<slug>/app/
├── public/index.html
├── api/src/index.js    # Worker / Vercel function
├── api/wrangler.jsonc
├── db/migrations/0001_init.sql
└── .dev.vars
```

- The browser must NOT connect directly to Neon with a connection string.
- All queries go through the API; verify the session in the API.
- Use connection pooling / the serverless driver.

### F — Hybrid

Combine the layouts above. Write in PRD Chapter 6.3 which layer does what.
Do not repeat the same logic in two services.

### G — Next.js

```text
projects/<slug>/app/
├── app/
│   ├── layout.tsx
│   ├── page.tsx
│   └── api/...
├── components/
├── lib/
├── package.json
└── .env.example
```

- Server components for data; client components only for interaction.
- Auth and DB queries on the server, not in the client bundle.
- Do not put `DATABASE_URL` in `NEXT_PUBLIC_*`.

### H — Node/Express

```text
projects/<slug>/app/
├── src/index.js
├── src/routes/
├── src/db.js
├── public/             # static frontend if any
├── package.json
└── .env.example
```

- Validation and auth in server middleware.
- The static frontend can be served by Express or a separate service.

### I — Laravel

```text
projects/<slug>/app/
├── app/Http/Controllers/
├── app/Models/
├── routes/web.php
├── resources/views/
├── public/
├── composer.json
└── .env.example
```

- Use Form Requests for validation.
- Blade + Tailwind for the UI; avoid logic in views.
- The production document root must be `public/`.

### J — FastAPI/Django

```text
projects/<slug>/app/
├── main.py / manage.py
├── app/                # FastAPI routers or Django apps
├── templates/          # if there is a UI
├── requirements.txt
└── .env.example
```

- FastAPI: Pydantic for validation, dependencies for auth.
- Django: form/model validation, templates + Tailwind.
- Debug must be off in production.

## Code rules (all stacks)

- One frontend file that can run straight away; do not split it into
  "Part 1/2".
- No `TODO`, empty functions, or `console.log` as a substitute for logic.
- No dead buttons: every button has a real action.
- Every screen has a loading / empty / error state.
- Light mode only. No `dark:` classes.
- Icons from one library (Lucide). No emoji as icons.
- Forms: label, error message, and clear focus.
- Do not put secrets in frontend files.
- Do not invent endpoints or deploy URLs that do not exist.

## Output

- Application files in `projects/<slug>/app/`.
- Implementation table updated.
- File list + line counts reported.
