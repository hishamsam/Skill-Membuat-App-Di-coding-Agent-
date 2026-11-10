# Phase 4.5 — Security Audit (gate before handoff)

The security audit sits between Phase 4 (local test) and Phase 5 (handoff).
The five workflow phases do not change; this is a gate that must pass before a
project can be handed over, and it repeats at the end of every module in Phase 3.

Goal: find vulnerabilities that cross a real trust boundary, then give the owner
the source evidence, a safe reproduction, a priority, and the smallest effective
fix. A suspicion without an affected principal, resource, or security outcome is
not a finding.

## 1. Authorization and rules of engagement

Write these down before any test:

| Item | Rule |
| --- | --- |
| Target | Only `projects/<slug>/app` of this project. Never another person's system. |
| Accounts | Dummy accounts, fixtures, and dummy data created for the test. |
| Environment | Local machine, local dev server, or an isolated loopback. |
| Data | Never real customer data, real credentials, or production records. |
| Out of scope | Production, shared infrastructure, third-party services, DNS, billing. |
| Prohibited | Denial-of-service, brute force beyond a few requests, spam, social engineering, physical access. |
| Evidence | Minimum effect that proves the defect; stop as soon as it is proven. |

If a decisive fact only exists in the deployment (provider setting, proxy,
identity policy), do not guess it: record it as `needs_validation` with the exact
missing fact and a non-destructive check the owner can run.

## 2. Threat model first

Write `projects/<slug>/security/THREAT-MODEL.md` before scanning:

1. **Assets** — what is worth stealing or breaking (records, sessions, keys, money, availability).
2. **Actors** — anonymous visitor, authenticated user, other tenant, admin, service account, insider.
3. **Trust boundaries** — browser to API, API to database, API to third-party, job to job, admin to tenant.
4. **Data classes** — public, internal, personal, secret; where each is stored and logged.
5. **STRIDE pass** — one line per category per boundary: Spoofing, Tampering, Repudiation, Information disclosure, Denial of service, Elevation of privilege.
6. **Controls claimed** — authentication, authorization, validation, escaping, rate limits, encryption. State where each lives (file, middleware, policy).

The PRD (Chapter 9 data model, Chapter 10 non-functional requirements, Chapter 12
screens) is the source for this model; do not invent an architecture.

## 3. Automated pass

```bash
bash scripts/security-audit.sh <slug>          # static rules
bash scripts/security-audit.sh <slug> --json   # machine-readable
bash scripts/security-audit.sh <slug> --deps   # plus npm audit (needs the network)
```

Reading the result:

| Level | Meaning | Required action |
| --- | --- | --- |
| `FAIL` | A control gap that is visible in source (secret in client, concatenated SQL, missing RLS) | Fix, then rerun. The gate stays blocked. |
| `WARN` | A candidate that needs a human trace | Confirm or reject with source evidence; record the decision |
| `PASS` | Rule evaluated, no pattern found | none |

The script never contacts a deployed endpoint and never writes to the project.
It prints `SECURITY_JSON` as its last line for automation.

## 4. Manual hunt, by attack class

Automated rules cannot find logic errors. Walk these classes against the threat
model; skip a class only when you can say why it does not apply.

| Class | What to check | Reference |
| --- | --- | --- |
| Access control | Every endpoint re-checks the right permission for the right resource; no path to the same state change with a weaker check; body fields cannot override authorization; bulk/export paths enforce per-item rights | OWASP WSTG ATHN/AUTHZ, ASVS V4 |
| Authentication and session | Password storage (hashing, cost), lockout, reset-token lifecycle, session fixation, cookie flags, logout invalidation | WSTG ATHN, ASVS V2/V3 |
| Injection | Untrusted input reaching SQL, shell, template, path, redirect, or deserialization; second-order injection through stored values | WSTG INPV, ASVS V5 |
| Cryptography and secrets | Weak randomness, hardcoded keys, secrets in client or logs, unauthenticated encryption, static IV, nonce reuse | ASVS V6/V8 |
| Business logic | Skipped steps, replayed flows, concurrent double-submit, negative/zero/overflow quantities, time-boundary and timezone bugs | WSTG BUSL |
| Files and server-side requests | Path traversal, upload type/size limits, stored-file execution, SSRF through URL fields and webhooks, redirect chains | WSTG INPV, ASVS V12 |
| Client side | DOM XSS sinks, `postMessage` origin checks, prototype pollution, token storage, CSP, third-party script trust | WSTG CLNT, ASVS V1/V14 |
| Data isolation and lifecycle | Tenant scoping in every query, cache and search leaks, export/backup scope, soft delete, retention, restore paths | ASVS V8/V9 |
| Availability and abuse | Rate limits on login and expensive endpoints, unbounded pagination, unauthenticated work, quota exhaustion | WSTG DoS guidance |
| Supply chain | Pinned dependencies, lockfile committed, `npm audit`, no install scripts from unknown packages, no secrets in CI | ASVS V14 |

For each candidate, trace the full path before reporting it: entry point, the
lower-trust principal, the input, the control that should apply, the crossed
boundary, the affected resource, and the observable result.

## 5. Validation and finding states

Keep only one state per root cause:

| State | Requires | May carry severity |
| --- | --- | --- |
| `confirmed` | Complete source trace plus a bounded local reproduction with a dummy principal | yes |
| `needs_validation` | Real trace, but a deployment or runtime fact decides it; name the exact blocker and a safe check | no |
| `rejected` | Source, a visible control, or an impossible prerequisite refutes the claim | no |

Reproduce with the minimum effect: a wrong return value, a dummy record read that
belongs to another dummy tenant, a blocked-then-bypassed check. Do not continue
to persistence, post-exploitation, or concealment.

## 6. Severity

Record a CVSS v3.1 vector and one of these anchors, with overall severity never
higher than the demonstrated impact:

| Severity | Anchor |
| --- | --- |
| critical | Unauthenticated code execution, full data-store access, or takeover of any account |
| high | Full defeat of an explicit control with real consequences: auth bypass, cross-tenant read/write, stored XSS affecting others |
| medium | Real boundary violation with limited blast radius or uncommon preconditions |
| low | Non-secret internal disclosure, or an effect needing sustained effort for minimal gain |
| informational | Confirmed but minimal; useful only as part of a larger finding |

A missing best practice with no reachable boundary violation is hardening, not a
finding. Report hardening separately.

## 7. Artifacts

```text
projects/<slug>/security/
├── THREAT-MODEL.md       # section 2
├── REPORT.md             # posture, table of findings, hardening, coverage limits
├── findings.json         # confirmed / needs_validation / rejected records
├── NEEDS-VALIDATION.md   # leads with exact blockers, no severity
└── evidence/             # logs, request/response captures, screenshots (no secrets, no PII)
```

Each `findings.json` record:

```json
{
  "id": "SEC-001",
  "state": "confirmed",
  "title": "Booking detail endpoint returns another tenant's record",
  "fingerprint": "bookings-get-missing-owner-check",
  "severity": "high",
  "cvss": "CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:N",
  "trace": ["app/api/bookings.js:41", "app/api/bookings.js:58"],
  "principal": "authenticated user of tenant A",
  "resource": "booking of tenant B",
  "observed": "GET /api/bookings/<id> returned 200 with tenant B data",
  "conditions": "any valid session; id is sequential",
  "fix": "filter by owner_id from the session at app/api/bookings.js:58",
  "regression": "tests/idor-booking.test.js",
  "evidence": "evidence/sec-001-request.txt"
}
```

Rules: the `trace` starts at a real entry point and ends at the sink; `observed`
states what happened, not what could happen; `fix` names the file and the
invariant; secrets and personal data never enter `evidence/`.

## 8. Independent re-check

Before writing `REPORT.md`, re-read every trace from source with fresh eyes and
try to refute each `confirmed` record. Check the entry point, the control that
should have applied, whether the control exists elsewhere on the path, and
whether the demonstrated impact matches the claimed severity. Downgrade or move
to `needs_validation`/`rejected` when the evidence does not hold. A record that
survives this pass is what the report may claim.

## 9. Fix and retest

1. Fix at the last trusted decision point (server-side authorization, parameterized
   query, escaping at render, validated allowlist) — not by hiding the symptom.
2. Add a regression test that fails before the fix and passes after it.
3. Rerun `bash scripts/security-audit.sh <slug>` and the module test.
4. Update the record to `fixed` in `REPORT.md` with the commit id.
5. Commit with `bash scripts/git-save.sh <slug> "fix(security): ..."`.

## 10. Gate and traceability

The gate passes when:

- `security-audit.sh` exits 0 (`FAIL` count is zero);
- every `WARN` has a recorded decision with evidence;
- `THREAT-MODEL.md` and `REPORT.md` exist and agree with `findings.json`;
- no `confirmed` record of severity `high` or `critical` is open;
- every fix has a commit and a regression test.

Then mark `STATUS.md` Phase 4.5 done, record the audit summary in `HANDOFF.md`,
and only then run Phase 5.

## Anti-patterns

1. Checklist deviations presented as vulnerabilities.
2. Defense-in-depth advice with no reachable boundary violation.
3. Probing production, shared services, or third parties.
4. Guessing provider, proxy, browser, or deployment behaviour that is not in source.
5. Treating same-principal or self-inflicted impact as a cross-boundary result.
6. Claiming a stronger result than the observed effect.
7. Prose-only findings that cannot be traced or reproduced.
8. Severity on `needs_validation` records.
9. Writing the report before the independent re-check.
10. Marking the gate passed while a `FAIL` or an open high/critical record exists.

## Provenance

Adapted for this repository from
[cloudflare/security-audit-skill](https://github.com/cloudflare/security-audit-skill)
(MIT License, Copyright (c) 2025-2026 Cloudflare, Inc.). Changes for this workflow:

- scoped to one local app project under `projects/<slug>/` instead of a multi-agent
  codebase audit with a coverage ledger and schema validators;
- added the local `scripts/security-audit.sh` static gate;
- kept the source-evidence contract, `confirmed` / `needs_validation` / `rejected`
  states, severity calibration, smallest-fix rule, and independent re-check;
- mapped the manual hunt table to OWASP WSTG and ASVS, and severity to CVSS v3.1;
- tied findings to the local git history and to per-module tests.
