# Phase 4 — Local Test

Purpose: prove the app runs on this machine before deploy. Never report
"done" without evidence.

## Main commands

```bash
bash skrip/test-local.sh <slug>                        # start the local server
bash skrip/test-local.sh <slug> --check                # start, test HTTP, stop
bash skrip/test-local.sh <slug> --check --path /orders # also require /orders to answer 200
bash skrip/qa-check.sh <slug>                          # static check
bash skrip/security-audit.sh <slug>                    # security gate (Phase 4.5)
```

The script reads `projek/<slug>/STACK`, written by `skrip/new-project.sh`.

## Module tests

Every finished module is tested before the next one starts:

```bash
bash skrip/test-local.sh <slug> --check --path / --path /<module-route>
bash skrip/git-save.sh <slug> "feat(module-<n>): <module name> + tests"
```

`--path` may be repeated. Each route must answer 200; anything else fails the
run. Paste the real output into the `STATUS.md` Modules table. A module without
a passing test and a commit is not finished.

## Exit criteria for Phase 4

- `test-local --check` returns HTTP 200 for every module route.
- `qa-check` reports 0 failed.
- `security-audit` reports 0 `FAIL`, and every `WARN` has a recorded decision
  (see `aliran-kerja/06-security-audit.md`).
- The browser checklist below is done at 360, 768, 1024, and 1440.

## Per stack

### A — GAS

GAS cannot be fully run locally. Two test layers:

1. **Preview mode (required):** `IS_PREVIEW = true` with complete demo data.
   ```bash
   cd projek/<slug>/app && python3 -m http.server 4173
   ```
   Open `http://localhost:4173` and test every screen/flow.
2. **Real backend:** deploy to Apps Script, then test the endpoint.
   ```bash
   curl -L -X POST "<GAS_URL>" \
     -H "Content-Type: text/plain;charset=utf-8" \
     -d '{"action":"ping","data":{}}'
   ```
   CLI option: `npx @google/clasp push` (needs login).

Pass when: the demo flow works, there are no console errors, and at least
one real backend call succeeds.

### B — Supabase

This machine has NO Docker, so `supabase start` cannot be used.

1. Use a Supabase dev project (free) + the anon key.
2. `public/index.html` + `python3 -m http.server 4173`.
3. Test auth, RLS, CRUD through the client.
4. Negative RLS test: user A must not be able to read user B's data.

If Docker is installed later:

```bash
npx supabase@latest start
npx supabase@latest db reset
```

### C — Cloudflare Worker

```bash
cd projek/<slug>/app
npx wrangler dev            # default http://localhost:8787
```

- Local D1 data is stored in `.wrangler/state`.
- Local secrets in `.dev.vars` (do not commit).
- Test `GET /api/health` (if present) and at least one CRUD.

### D — Firebase

Java 17 is available on this machine.

```bash
cd projek/<slug>/app
npx firebase-tools emulators:start
```

- Connect the app to the emulator (`connectAuthEmulator`,
  `connectFirestoreEmulator`) in test mode only.
- Test rules: a user without permission must be rejected.
- For automated tests: `npx firebase-tools emulators:exec "./tests/smoke.sh"`.

For an automated check: `bash skrip/test-local.sh <slug> --check` starts
the hosting emulator only and confirms HTTP 200.

### E — Neon

There is no `psql` on this machine.

1. Test the API locally:
   ```bash
   cd projek/<slug>/app/api
   npx wrangler dev
   ```
   Connection string in `.dev.vars`.
2. Test migrations with a Node script:
   ```bash
   cd projek/<slug>/app
   npm i @neondatabase/serverless
   node db/migrate.mjs
   ```
3. Never put the connection string in the frontend.

### F — Hybrid

Run every service involved, then test the end-to-end flow.
Example: `wrangler dev` (API) + `python3 -m http.server` (frontend).

### G — Next.js

```bash
cd projek/<slug>/app
npm install
npm run dev -- -p 4173
```

- Test the server routes and API routes.
- `npm run build` must pass before handoff.

### H — Node/Express

```bash
cd projek/<slug>/app
npm install
npm run dev        # or npm start
```

- Test `/api/health` and one CRUD.
- Make sure `.env` is not committed.

### I — Laravel

```bash
cd projek/<slug>/app
composer install
php artisan migrate
php artisan serve --host=127.0.0.1 --port=4173
```

- Test login, CRUD, and validation.
- `APP_DEBUG=false` for production-like testing.

### J — FastAPI/Django

FastAPI:

```bash
cd projek/<slug>/app
python3 -m uvicorn main:app --host 127.0.0.1 --port 4173
```

Django:

```bash
cd projek/<slug>/app
python3 manage.py migrate
python3 manage.py runserver 127.0.0.1:4173
```

## Optional: Dokploy for local testing

Dokploy is installed **only if the user allows it**. Ask first, then:

```bash
bash skrip/setup-dokploy.sh
```

If the user declines or the install fails, skip it and continue with the manual
tests above. Do not make Dokploy a pass condition.

## Test checklist (all stacks)

- [ ] The login screen / main screen opens with no console errors.
- [ ] Every button in the PRD list produces an action.
- [ ] CRUD works with seed data.
- [ ] Loading, empty, error states can be triggered.
- [ ] Refreshing the page does not force a logout.
- [ ] Responsiveness checked: 390, 768, 1024, 1440.
- [ ] No horizontal scroll at 360px.
- [ ] No secrets in `index.html` / the frontend bundle.
- [ ] `qa-check.sh` passes.
- [ ] All PRD Chapter 13.3 test cases pass.

## How to check responsiveness

1. Open DevTools → Toggle device toolbar.
2. Test 360×800, 390×844, 768×1024, 1024×768, 1440×900.
3. Check: no element overflows, text does not overlap, nav does not overlap
   content, modal is not clipped.

## When a test fails

1. Record the reproduce steps + the real error message.
2. Fix the cause, not the symptom.
3. Run the same test again.
4. Do not continue to Phase 5 while the checklist has not passed.
