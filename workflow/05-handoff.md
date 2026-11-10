# Phase 5 — Handoff & Deploy

Purpose: hand over the tested app, with clear run instructions, settings, and
rollback.

## Mandatory output

```text
projects/<slug>/
├── HANDOFF.md
├── prd/PRD-v0.1.md
├── design/design.figcraft + exports/
├── app/                  # finished code
├── security/             # THREAT-MODEL.md, REPORT.md, findings.json, evidence/
├── tests/                # test scripts/checklist
└── .git/                 # local history: one commit per module and fix
```

Do not start Phase 5 while the security gate is open: `security-audit.sh` must
report 0 `FAIL` and no `confirmed` high/critical record may remain open
(`workflow/06-security-audit.md`).

## Steps

1. Fill `HANDOFF.md` from the `templates/HANDOFF.md` template.
2. Run again:

   ```bash
   bash scripts/qa-check.sh <slug>
   bash scripts/security-audit.sh <slug>
   bash scripts/test-local.sh <slug> --check
   ```

   Every module's test result and commit id from `STATUS.md` goes into
   `HANDOFF.md`, together with the security summary (findings fixed, decisions on
   remaining `WARN`s, any `needs_validation` lead).

3. Deploy per stack:

   | Stack | Deploy instruction |
   | --- | --- |
   | GAS + static | Deploy `Code.gs` as a Web App; upload `index.html` to Vercel |
   | Supabase | Deploy the frontend (Vercel/Pages); `npx supabase db push`; set env |
   | Cloudflare Worker | `npx wrangler deploy`; `wrangler secret put` for secrets |
   | Firebase | `npx firebase-tools deploy --only hosting,firestore:rules` |
   | Neon | Deploy the API (Worker/Vercel); `db/migrations` run on the production DB |
   | Hybrid | Deploy each layer per the table above |
   | Next.js | Deploy Vercel (import repo) + Postgres env |
   | Node/Express | Deploy VPS/Dokploy (Docker/buildpack) + DB env |
   | Laravel | Deploy VPS/Dokploy; document root `public/`; `php artisan migrate --force` |
   | FastAPI/Django | Deploy VPS/Dokploy; run migrations; turn off debug |
   | Flutter | `flutter build web` → upload `build/web` to Vercel/Pages; Android: `flutter build appbundle`; iOS: `flutter build ipa` (needs macOS) |

4. Test production (smoke test):
   - open the production URL;
   - log in with a real account;
   - one CRUD;
   - one error case (invalid input).
5. Mark `STATUS.md` complete and hand over.

## HANDOFF.md must contain

- Production URL + staging URL (if any).
- The first admin account and how to change the password.
- The env var / secret list (names only, not values).
- Local run instructions.
- Redeploy instructions.
- Backup & rollback.
- Known limits (quotas, stack limits, Phase 2 work).
- Links to the PRD, design, and PNG exports.

## Backup & rollback

| Stack | Backup | Rollback |
| --- | --- | --- |
| GAS | Sheet copy + deployment version | Redeploy the old version at the same Deployment ID |
| Supabase | `supabase db dump` / daily backup | Restore a snapshot / `db reset` on the dev project |
| Worker | Git + `wrangler deployments` | `wrangler rollback` |
| Firebase | Firestore backup / rules in Git | Redeploy the rules + the old hosting version |
| Neon | Neon branch / restore | Restore a branch or PITR |
| Next.js | Git + Vercel deployment history | Promote the old deployment |
| Node/Express | DB backup + Docker/Git image | Redeploy the old image |
| Laravel | `mysqldump` + Git | Restore the dump + deploy the old build |
| FastAPI/Django | `pg_dump` + Git | Restore the dump + deploy the old build |

## Definition of done

- [ ] PRD approved and saved.
- [ ] FigCraft file + PNG exports saved.
- [ ] Code passes `qa-check` and the local tests.
- [ ] All **Mandatory** PRD requirements work.
- [ ] Production test passes.
- [ ] HANDOFF.md is complete.
- [ ] No secrets in the repo.

## After handoff

Next changes: update the PRD first if the requirements change, then
the code. Do not change unrelated code without a reason.
