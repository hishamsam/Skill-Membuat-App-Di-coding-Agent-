<!--
=====================================================================
PRD TEMPLATE + PRD GENERATOR — ENGLISH
=====================================================================
This file is TWO things at once:
1. INTERVIEW PROTOCOL for collecting project information.
2. PRD TEMPLATE filled in after the interview.

INSTRUCTIONS FOR THE AI — READ EVERYTHING BEFORE STARTING
---------------------------------------------------------------------
You are the Product Manager + Solution Architect who assembles the PRD.

INPUT:
- The user's rough idea, meeting notes, transcript, or existing document.
- UI reference images (optional): screenshots, Figma mockups, Dribbble/Mobbin images.

TASK:
1. Run INTERVIEW MODE (Part A) until there is enough information.
2. Fill ALL {{...}} placeholders in Part B.
3. Save the result to: projects/<slug>/prd/PRD-v0.1.md
   (see workflow/01-prd.md for the folder steps).
4. Show the full PRD, then STOP and wait for user approval.

HARD RULES:
- DO NOT invent facts. Anything not decided goes into Chapter 16 (Open Questions).
- Reasonable technical assumptions: put them in Chapter 5, mark them "ASSUMPTION".
- One question only per message. Do not flood the user.
- Every question must have options A/B/C (+ "Specify" added automatically).
- If the user answers several questions at once, accept it and skip the ones already answered.
- DO NOT merge questions. Do not show the whole A1–A10 list at once.
- Vague answer: ask a follow-up question first before moving on.
- If the user says "just generate" / "auto", explain that a short interview
  is still required, then continue one question per message.

AUTO MODE (ONE-SHOT):
- If the user writes "auto", "full auto", "do everything", "finish it",
  or "one-shot", the Part A interview is STILL MANDATORY.
- Ask one question per message until all answers are complete.
- Auto mode only removes the approval gate after the PRD: after the last
  question, generate the PRD and continue with Phases 2-4, then report.
- Pick the stack from the A6 answer. If A6 was not answered, suggest one and
  ask for confirmation before continuing.
- Fill all 17 chapters. Mark [ASSUMPTION] only for items the user
  deliberately leaves to the agent.
- Still show the PRD summary and the assumptions list in the final report.
- Formal, concise English, no marketing sentences.
- Functional requirements use unique IDs PREFIX-N (example: AUTH-1, TRX-2).
- Priority only: **Mandatory** / **Important** / **Phase 2**.
- First version is always v0.1 (Provisional Draft).
- Instruction comments <!-- --> MUST NOT appear in the final document.

APPROVAL:
- Manual mode: after showing the PRD, ask: "Do you accept this PRD, or are there changes?"
  Do not write code until the user gives clear approval.
- Auto mode: the PRD is shown in the final report; continue with Phases 2-4.
=====================================================================
-->

# PART A — INTERVIEW PROTOCOL (10 QUESTIONS)

Ask in order. Stop after ONE question. Wait for the answer.

## A1. Problem & users
"Who uses this system, and what problem should it solve?"
- A. Internal company staff (daily operations)
- B. External customers / public
- C. Both: staff manage, customers access
- D. Specific users: students / teachers / members / patients (specify)

## A2. Roles & permissions
"What roles must exist?"
- A. Admin only
- B. Admin + regular user
- C. Admin + manager + user
- D. More than three (specify)

## A3. Core workflow
"What is the one main flow from start to finish?"
- A. Record created → reviewed → approved → report
- B. Booking / order → pay → done
- C. Complaint / request → action → close
- D. Registration → verification → content access
- E. Other (specify in one sentence)

## A4. Main data
"What are the 3–5 main entities stored?"
- A. User, transaction record, status, report
- B. User, product/stock, order, payment
- C. User, request, attachment, comment
- D. Specify your own entity list

## A5. MVP scope
"What must exist in the first version?"
- A. Auth + CRUD + search + basic report
- B. Auth + CRUD + approval + notification
- C. Auth + CRUD + payment + receipt
- D. Specify the MVP feature list

## A6. TECHNOLOGY — MANDATORY QUESTION
"Choose the backend/data technology. Pick one, or more if hybrid."

| Option | Technology | Best when | Cost / limits |
| --- | --- | --- | --- |
| **A** | **Google Apps Script (GAS) + Google Sheets** | Internal app, users < 100, rows < ~10,000, already on Google Workspace | Free; GAS daily quota; not a real DB |
| **B** | **Supabase** | Need Postgres, Auth, RLS, Storage, Realtime; a real SaaS | Limited free tier; idle projects can pause |
| **C** | **Cloudflare Worker** (+ D1 / KV / R2) | Global API, high traffic, low latency, static assets | Daily free tier; D1 size limit; not full Postgres |
| **D** | **Firebase** (Firestore + Auth + Hosting) | Realtime sync, mobile/web apps, fast auth | Free tier; read/write cost can grow; vendor lock-in |
| **E** | **Neon** (serverless Postgres) | Need real Postgres, branching, scale-to-zero | Needs an API layer (Worker/Vercel); cold start |
| **F** | **Hybrid** | Example: static frontend + Neon + Worker API | Two services to maintain |
| **G** | **Next.js + Postgres** (Vercel + Neon/Supabase) | SSR, API routes, SEO, one project for UI + API | Vercel vendor; separate Postgres |
| **H** | **Node/Express + Postgres** (VPS/Dokploy) | Full control, custom API, self-deploy | Must maintain server, backup, TLS |
| **I** | **Laravel + MySQL** (VPS/Dokploy) | PHP project, admin panel, ordinary hosting | Needs PHP + MySQL; more manual deploy |
| **J** | **FastAPI/Django + Postgres** (VPS/Dokploy) | Python API, data science, Django admin | Needs a Python runtime; more manual deploy |
| **K** | **Flutter** (Web + Android/iOS) | One Dart codebase for responsive web and mobile apps; backend follows B/D/E/F | Needs Flutter SDK; larger web bundle; iOS needs macOS |

Also ask: "Why that choice?" The answer goes into Chapter 6.1.
If the user has no preference, suggest one and give the reason in one sentence.

## A7. Deployment & domain
"Where will the app be hosted?"
- A. Vercel (static frontend) + backend chosen in A6
- B. Cloudflare Pages/Workers
- C. Firebase Hosting
- D. Google Apps Script Web App
- E. Not sure yet — recommend the cheapest
- F. Own VPS (Dokploy) — controlled deploy, fixed cost

## A8. Technology follow-up questions (ask according to the A6 choice — MAXIMUM 4)

### If A — GAS
1. Use a Google Workspace account or a personal account?
2. Estimated data rows per year? (< 1k / 1k–10k / > 10k)
3. Concurrent users at peak time?
4. Need file upload (Google Drive) or email sending (MailApp)?

### If B — Supabase
1. Login method: email+password / magic link / Google OAuth?
2. Need Storage (images/documents) and Realtime?
3. RLS roles: who may read/write which rows?
4. Any Edge Function, or logic in the frontend + RLS only?

### If C — Cloudflare Worker
1. Data in D1, KV, R2, or Durable Object?
2. Need cron trigger / queue / webhook?
3. Static assets on the same Worker or Cloudflare Pages?
4. Any custom domain?

### If D — Firebase
1. Firestore or Realtime Database?
2. Auth provider: email, Google, phone, or anonymous?
3. Need Cloud Functions? (region?)
4. Need Storage for files?

### If E — Neon
1. Neon is DB only; API through Worker, Vercel Function, or Neon Data API?
2. Who handles Auth? (Supabase Auth / Firebase Auth / own / none)
3. Need branching for dev/staging/prod?
4. Estimated DB size and monthly traffic?

### If F — Hybrid
1. Which layer does what? (frontend / API / DB / auth)
2. Which service holds the primary data?
3. Which service may fail without taking the app down?

### If G — Next.js + Postgres
1. App Router or Pages Router?
2. Auth: NextAuth/Auth.js, Clerk, Supabase Auth, or own?
3. API inside Next.js (`app/api`) or a separate service?
4. Deploy Vercel + Postgres Neon/Supabase, or VPS?

### If H — Node/Express + Postgres
1. Language: JavaScript or TypeScript?
2. Auth: own JWT, session, or external provider?
3. ORM: Prisma, Drizzle, Kysely, or raw SQL?
4. Deploy VPS/Dokploy: Docker or a direct Node process?

### If I — Laravel + MySQL
1. Laravel and PHP version?
2. Auth: Breeze/Jetstream/Filament, or custom?
3. MySQL on the same server or a separate DB?
4. Deploy VPS/Dokploy or ordinary PHP hosting?

### If J — FastAPI/Django + Postgres
1. FastAPI or Django?
2. Auth: JWT, Django session, or external provider?
3. ORM: SQLAlchemy/Alembic or Django ORM?
4. Deploy VPS/Dokploy with Docker or a direct Python process?

### If K — Flutter (Web + Android/iOS)
1. State management: Riverpod, Bloc, or setState?
2. Backend: Supabase, Firebase, Neon/Worker API, or own REST?
3. Auth: backend SDK, provider OAuth, or custom?
4. Target platforms: web only, Android only, or web + Android + iOS?

## A9. Visual references & devices
"Any reference images? Where are the files?"
- A. None — pick a visual direction that suits the domain
- B. Screenshot / mockup available (place in projects/<slug>/refs/)
- C. Live app URL available
- D. Several mixed references

If there are images, ask ONE further question:
"Fidelity mode? A. Structural (default) B. Pixel-faithful C. Mood"
And: "Primary device? mobile / desktop / both"

## A10. Definition of done & testing
"What must pass before the app counts as done?"
- A. All main screens open, CRUD works, no console errors
- B. A + auth works + real data from the backend
- C. A + B + responsive test at 390/768/1440 + staging deploy
- D. Specify your own checklist

After A10: generate the full PRD (Part B), save the file, show it, wait for approval.

---

# PART B — PRD TEMPLATE

# PRODUCT REQUIREMENTS DOCUMENT — {{NAMA_PRODUK}}

**STATUS: {{STATUS_DOKUMEN}}**

| | |
| --- | --- |
| **Product Name** | {{NAMA_PRODUK_LENGKAP}} |
| **Document Version** | v0.1 |
| **Prepared by** | {{NAMA_PENGEMBANG}} |
| **For** | {{NAMA_KLIEN}} |
| **Date** | {{TANGGAL_DOKUMEN}} |
| **Project Folder** | `projects/{{SLUG}}/` |
| **Technology** | {{TEKNOLOGI_TERPILIH}} |
| **Related Documents** | {{DOKUMEN_TERKAIT}} |

---

## 1. Product Summary

<!-- 2 paragraphs. P1: the current problem. P2: the solution + main modules + goals. -->

{{RINGKASAN_PRODUK}}

## 2. Goals & Objectives

<!-- 4–6 bullets. Business outcomes, not a feature list. -->

- {{TUJUAN_1}}
- {{TUJUAN_2}}
- {{TUJUAN_3}}

## 3. Users & Roles

<!-- One bullet per role: **Role :** rights and main activities. -->

- **{{PERAN_1}} :** {{DESKRIPSI_PERAN_1}}
- **{{PERAN_2}} :** {{DESKRIPSI_PERAN_2}}

## 4. Scope

### 4.1 Included (MVP)

- {{LINGKUP_MVP_1}}
- {{LINGKUP_MVP_2}}

### 4.2 Out of Early Scope / Later Phase

{{LINGKUP_DILUAR_MVP}}

## 5. Assumptions & Constraints

<!-- Include: budget, time, language, devices, existing accounts/services,
and every ASSUMPTION the AI makes. Mark [ASSUMPTION] clearly. -->

- {{ASUMSI_1}}
- {{ASUMSI_2}}

## 6. Technology Decision (Tech Stack Decision)

<!-- MANDATORY. This section locks the stack before design and code. -->

### 6.1 Choice & Justification

| Layer | Technology | Reason | Rejected alternative |
| --- | --- | --- | --- |
| Frontend | {{FE_TECH}} | {{FE_SEBAB}} | {{FE_ALT}} |
| Backend / API | {{BE_TECH}} | {{BE_SEBAB}} | {{BE_ALT}} |
| Database | {{DB_TECH}} | {{DB_SEBAB}} | {{DB_ALT}} |
| Auth | {{AUTH_TECH}} | {{AUTH_SEBAB}} | {{AUTH_ALT}} |
| Hosting | {{HOST_TECH}} | {{HOST_SEBAB}} | {{HOST_ALT}} |

### 6.2 Services & Configuration

| Item | Value |
| --- | --- |
| Project / Region | {{PROJEK_REGION}} |
| Env variables | {{ENV_VARS}} |
| Server-side secrets | {{SECRETS}} |
| Domain | {{DOMAIN}} |
| Local mode | {{LOCAL_MODE}} |

**Secret rule:** `service_role` / admin / DB URL keys MUST NOT be placed in
frontend files. Only public keys (anon/publishable) are allowed on the client.

### 6.3 Architecture Sketch

```text
{{ALIRAN_ARKITEKTUR}}
```

## 7. Functional Requirements

<!-- Group by module: 7.1, 7.2, ... Naming pattern: "Actor — Module".
Table EXACTLY as below. Capability sentences: "Admin can...", "The system displays..." -->

### 7.1 {{NAMA_MODUL_1}}

| **ID** | **Functional Requirement** | **Priority** |
| --- | --- | --- |
| **{{PREFIX}}-1** | {{DESKRIPSI_KEBUTUHAN}} | **Mandatory** |
| **{{PREFIX}}-2** | {{DESKRIPSI_KEBUTUHAN}} | **Important** |

## 8. Main User Flows

<!-- 3–5 flows. Numbered steps. Include the system state in quotes. -->

### 8.1 {{NAMA_ALUR_1}}

1. {{LANGKAH_1}}
2. {{LANGKAH_2}}

## 9. Data Model

### 9.1 Entities & Fields

| Entity | Main Fields | Description |
| --- | --- | --- |
| **{{ENTITAS_1}}** | {{FIELD_UTAMA}} | {{KETERANGAN}} |

**Note:** fields in [square brackets] are Later Phase features (Chapter 14).

### 9.2 Physical Implementation

<!-- Choose ONE block according to Chapter 6. Delete unused blocks. -->

**If GAS:**
- Sheets: `Users`, `{{SHEET_UTAMA}}`, `Settings`
- Exact columns, data types, PK/FK, status enums.
- Record ID = `timestamp + random`, not the row number.

**If Supabase / Neon (Postgres):**
- SQL schema: `public.{{TABLE}}`
- Primary keys, FK, `created_at`, `updated_at`.
- RLS policies per role (Supabase) or DB roles (Neon).
- Indexes for search and lists.

**If Cloudflare Worker (D1):**
- D1 schema (`migrations/0001_init.sql`), SQLite types.
- Bindings: `DB`, `KV`, `BUCKET` (state which are used).

**If Firebase:**
- Firestore collections: `{{COLLECTION}}`
- Document structure, subcollections, composite indexes.
- Security rules (`firestore.rules`) per role.

## 10. Non-Functional Requirements

<!-- Include responsive, security, performance, privacy, and stack limits. -->

- **Responsive :** {{NFR_RESPONSIF}}
- **Security :** {{NFR_KESELAMATAN}}
- **Performance :** {{NFR_PRESTASI}}
- **Privacy :** {{NFR_PRIVASI}}
- **Technology limits :** {{NFR_HAD}}

## 11. Third-Party Integrations

| Service | Function | Notes |
| --- | --- | --- |
| **{{LAYANAN_1}}** | {{FUNGSI_1}} | {{CATATAN_1}} |

## 12. UI Contract & FigCraft Handoff

<!-- MANDATORY. This chapter is direct input for the FigCraft design phase.
FigCraft MCP cannot read PRD text; a human/AI will do the building.
Write precisely enough that the design script can be generated without asking again. -->

### 12.1 Image References

| Item | Value |
| --- | --- |
| Fidelity mode | `None` / `Structural` / `Pixel-faithful` / `Mood` |
| Reference file | `projects/{{SLUG}}/refs/{{NAMA_FAIL}}` |
| Reference URL | {{URL_RUJUKAN}} |
| Reference device | Mobile / Desktop / Both |
| What is taken | {{APA_DIAMBIL}} |
| What is replaced | {{APA_DIGANTI}} |
| Legal limits | No copyrighted logo/illustration/photo copied |

### 12.2 Design DNA

| Aspect | Value |
| --- | --- |
| Grid & container | {{DNA_GRID}} |
| Layout hierarchy | {{DNA_LAYOUT}} |
| Typography | {{DNA_TIPOGRAFI}} |
| Palette | {{DNA_PALETTE}} |
| Spacing & radius | {{DNA_SPACING}} |
| Components | {{DNA_KOMPONEN}} |
| Density | {{DNA_DENSITY}} |
| Motion | {{DNA_MOTION}} |
| Signature app | {{SIGNATURE}} |

### 12.3 Token Map

| Token | Value | Usage |
| --- | --- | --- |
| `ink` | {{TOKEN_INK}} | Primary text |
| `surface` | {{TOKEN_SURFACE}} | Card background |
| `line` | {{TOKEN_LINE}} | Border |
| `accent` | {{TOKEN_ACCENT}} | Primary action |

### 12.4 Screen List

<!-- Every screen must have 4 states: default, loading, empty, error.
Viewport: Mobile 390×844 / Desktop 1440×900. -->

| ID | Screen | Role | Main content | States | Viewport |
| --- | --- | --- | --- | --- | --- |
| `S-01` | {{NAMA_SKRIN_1}} | {{PERAN_SKRIN_1}} | {{ISI_SKRIN_1}} | default, loading, empty, error | 390 + 1440 |
| `S-02` | {{NAMA_SKRIN_2}} | {{PERAN_SKRIN_2}} | {{ISI_SKRIN_2}} | default, loading, empty, error | 390 + 1440 |

### 12.5 Navigation & Responsive

- **Desktop (≥ 1024px):** {{NAV_DESKTOP}}
- **Tablet (768–1023px):** {{NAV_TABLET}}
- **Mobile (< 768px):** {{NAV_MOBILE}}
- **Rule:** mobile design does NOT mean mobile-only code.
  Code must be responsive from 360px to 1920px.
- **Touch target:** minimum 44×44px.
- **Prohibitions:** no dark mode, no horizontal scroll on the root.

## 13. Local Test Plan & Acceptance Criteria

### 13.1 Local Commands

```bash
# filled per stack, for example:
bash scripts/test-local.sh {{SLUG}}
```

### 13.2 Test Data

| Item | Value |
| --- | --- |
| Demo account | {{AKAUN_DEMO}} |
| Seed data | {{SEED_DATA}} |
| Preview mode | {{MOD_PRATONTON}} |

### 13.3 Test Cases

| ID | Scenario | Steps | Expectation |
| --- | --- | --- | --- |
| `T-01` | {{SKENARIO_1}} | {{LANGKAH_UJIAN_1}} | {{JANGKAAN_1}} |
| `T-02` | {{SKENARIO_2}} | {{LANGKAH_UJIAN_2}} | {{JANGKAAN_2}} |

### 13.4 Acceptance Criteria

- [ ] All screens in Chapter 12.4 open without console errors.
- [ ] All **Mandatory** requirements in Chapter 7 pass.
- [ ] CRUD works with real or seed data.
- [ ] Responsive checked at 390, 768, 1024, 1440.
- [ ] No dead buttons.
- [ ] No secrets in frontend files.
- [ ] `bash scripts/qa-check.sh {{SLUG}}` passes.

## 14. Proposed Features / Later Phase

- **{{FITUR_USULAN_1}}.** {{PENJELASAN_FITUR_1}}

## 15. Rejected Features (Out of Scope)

<!-- List of features deliberately not built, so they are not raised again. -->

- {{DITOLAK_1}}

## 16. Open Questions / TBD

- {{PERTANYAAN_1}}
- {{PERTANYAAN_2}}

## 17. Glossary

- **{{ISTILAH_1}} :** {{DEFINISI_1}}

---

*This document is a provisional draft and may change as further discussion continues.*
