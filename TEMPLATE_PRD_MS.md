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
- Write every question for a non-technical person. No jargon; explain any
  unavoidable technical word in brackets in everyday words.
- Every question must have 3-4 ready options A/B/C(/D) plus a final
  "Other — describe" option, and ONE recommendation with a reason.
- An answer counts only when the user picks a letter or writes a clear answer.
  Recommendation text is advice, not an answer.
- Unanswered or vague: re-ask the same question in simpler words with one
  example. Do not move on and do not generate a partial PRD.
- If the user answers several questions at once, accept it and skip the ones already answered.
- DO NOT merge questions. Do not show the whole A1–A10 list at once.
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

Ask in order. Send ONE question per message and wait for the answer.

## How to ask (mandatory)

Every question must:

1. Be written for a person who is not technical. No jargon. When a technical
   word cannot be avoided, explain it in brackets in everyday words.
2. Give 3–4 ready-made options labelled A, B, C (D when needed), plus a final
   **Other** option: "Other — tell me in one sentence".
3. Give ONE recommendation: "Recommended if you are not sure: B — <reason>".
   A recommendation is advice, never an automatic answer.
4. Ask about ONE thing only. Never merge two questions in one message and never
   show the whole A1–A10 list at once.

## Completeness gate (do not skip)

- A question is answered only when the user picks a letter or writes a clear
  answer of their own. Silence, "whatever", "up to you", or a dodge does not
  count as an answer.
- If the answer is missing or vague: re-ask the SAME question in shorter words
  with one concrete example. Do not move to the next question.
- Do not treat a recommendation as the user's answer unless the user says
  "use your recommendation" / "ikut cadangan". Record such a reply as
  `[ASSUMPTION]` with the reason.
- A6 plus its A8 follow-ups must be answered. With no A6 answer, no PRD.
- Never write the PRD while any of A1–A10 is unanswered. Never fill a gap from
  the recommendation and present it as the user's decision.

## A1. Who will use it, and what problem does it solve?

**Recommended if you are not sure:** A — start with the smallest group that
already has this problem; opening it to outsiders later is easy.

- A. My own staff, for daily work (records, approvals, reports)
- B. Customers or the public (people outside the company)
- C. Both: staff manage the data, customers use part of it
- D. A specific group: students, teachers, members, patients, volunteers
- E. Other — describe the user and the problem in one sentence

If the answer is vague, ask: "What is that person doing today, and what goes
wrong with it?"

## A2. Who is allowed to do what inside the app?

Said another way: who can see everything, and who only sees their own part?

**Recommended if you are not sure:** B — one admin plus ordinary users covers
most first versions without over-building.

- A. One kind of user only: everyone sees and does the same thing
- B. Two kinds: an admin (manages everything) and a normal user (own data)
- C. Three kinds: admin, manager who approves, normal user
- D. Rights differ per department, branch, or customer company
- E. Other — describe who may see and change what

## A3. What is the one main job the app must finish, start to end?

Think of the single most important thing a user must complete. Give the steps
in order.

**Recommended if you are not sure:** A — record → check → approve → report
fits most office and admin systems.

- A. Create a record → someone checks or approves it → it appears in a report
- B. Choose something (booking/order) → pay → receive confirmation
- C. Submit a complaint or request → staff act on it → it is closed
- D. Sign up → get verified → unlock content or a service
- E. Other — write the steps in one sentence, with arrows

## A4. What are the 3–5 main "things" the app keeps?

Not screens: the items in the list. Example for a shop: customer, product,
order, payment.

**Recommended if you are not sure:** B if you sell anything; A for records,
requests, or internal processes.

- A. Person, record/entry, status, report
- B. Person, product or stock item, order, payment
- C. Person, request/ticket, attached file, comment or reply
- D. Person, course/event, registration, attendance
- E. Other — list your items, separated by commas

## A5. What must work in the first version, and what can wait?

"First version" means the smallest release that is genuinely useful. Everything
else moves to a later phase.

**Recommended if you are not sure:** A — sign in, add/edit/delete/view data,
search, one simple report. Ship that, then add approval and notifications.

- A. Sign in, add/edit/delete/view data, search, one simple report
- B. A + an approval step + email or message notification
- C. A + online payment + receipt or invoice
- D. A + file upload + export to Excel/PDF
- E. Other — list the must-haves, one per line

## A6. Where should the app and its data live? (MANDATORY)

This answer decides which tools are used later. Ask the user the plain
question first: "Who will use the app, roughly how many people at once, and
about how much data will it hold in the first year?" Then use this table to
map the answer to a code. Read the second column to the user, not the product
names.

**Recommendation rule — results first:** recommend only **Tier 1**. It holds
industry-leading, widely adopted stacks with large ecosystems, current
security patches, and a deep pool of people who can maintain them. Never
propose a **Tier 2** option first; mention it only when the user asks for it or
already owns it, and state its limits plainly before continuing.

**Recommended if you are not sure:** B — a managed Postgres database with
login, file storage, and access rules, used by a very large developer base, and
nothing to install or maintain.

| Code | Tier | What it is, in plain words | Good for | Watch out for |
| --- | --- | --- | --- | --- |
| **B** | 1 | A ready-made online database with login, file storage, and access rules (Supabase on PostgreSQL) | Most web apps, customers, uploaded files | Small free tier; an idle project can pause |
| **C** | 1 | A service that answers requests fast, anywhere in the world (Cloudflare Workers) | Public apps with high traffic and small data | Storage size limits; fewer ready features |
| **D** | 1 | Google's app platform with instant sync and easy login (Firebase) | Chat-like, live-updating, mobile apps | Cost grows with reads and writes |
| **G** | 1 | One project that builds both pages and data access, good for Google search (Next.js + PostgreSQL) | Marketing sites plus an app; SEO matters | Tied to one host; separate database |
| **H** | 1 | Your own server program with full control (Node/Express + PostgreSQL) | Custom logic, unusual requirements | Someone must keep the server running and backed up |
| **I** | 1 | A PHP framework with a ready admin page (Laravel + MySQL) | PHP teams, ordinary hosting | More manual deployment |
| **J** | 1 | A Python framework with a ready admin page (Django or FastAPI + PostgreSQL) | Python teams, reports, data work | More manual deployment |
| **K** | 1 | One code base that ships website + Android + iPhone (Flutter) | You need phone apps from day one | Larger download; iPhone builds need a Mac |
| **A** | 2 | A Google spreadsheet with an app on top (Google Apps Script) | A very small internal tool, under ~100 users, under ~10,000 rows | Google's daily limits; not a real database; hard to grow |
| **E** | 2 | A database only; a small program still has to sit in front (Neon) | A PostgreSQL database with nothing else | Needs a second service; fewer proven deployments than managed Postgres |
| **F** | 2 | Two or more of the above combined (Hybrid) | Mixed needs, for example files here and data there | Two things to maintain; more ways to fail |

**Other — describe:** if none of the codes fits, ask the user to describe the
app in one sentence. The agent then picks the closest **Tier 1** code, states
which one it is and why, and asks for an explicit yes before continuing.

**If the user asks for a Tier 2 code:** say in one sentence what it cannot do
well, offer the closest Tier 1 alternative, and continue only after an explicit
yes. Never present Tier 2 as the recommended choice.

After the choice, ask ONE follow-up: "Why that one?" The answer goes into
Chapter 6.1. If the user has no preference, state your recommendation, ask for
an explicit yes or no, and only then continue. Do not silently pick for them.

## A7. Where will the website live, and what address will people type?

Use everyday words: "the address people open in their browser".

**Recommended if you are not sure:** E — the agent picks the standard
industry host for that stack (Vercel, Cloudflare, Firebase, Google, or a VPS),
and says which one and why in one sentence.

- A. A managed website host (Vercel) — simple, free for small use
- B. Cloudflare Pages or Workers — fast everywhere, generous free tier
- C. Firebase Hosting — Google, pairs with D
- D. Google Apps Script web app — nothing extra to host, pairs with A
- E. Not sure — recommend the standard host for that stack
- F. Own server (VPS with Dokploy) — fixed monthly cost, full control
- G. Other — describe where it should live, or the domain already owned

Then ask, as its own message: "Do you already own a domain name?"
- A. No — use the free address from the host
- B. Yes — say which one
- C. Not sure what a domain is — explain in one line, then re-ask
- D. Other — write the address wanted

## A8. Follow-up questions for the chosen stack (ask MAXIMUM 4)

Ask only the block that matches the A6 code. Each follow-up keeps the same
rules: plain words, ready options, one recommendation, and an Other option.
The Tier 2 blocks (A, E, F) are asked only when the user explicitly chose that
code after the warning in A6.
Record answers in the user's words; technical internals (routers, ORMs,
languages, containers) are your decision and go into Chapter 5 marked
`[ASSUMPTION]` unless the user already answered them.

### If A — Google spreadsheet app (Tier 2, only on request)
1. Which Google account will run it?
   - A. A company Google Workspace account
   - B. A personal Gmail account
   - C. Both kinds of users
   - D. Other — describe
   Recommended if unsure: A — company data should not depend on one person's Gmail.
2. About how much data in the first year?
   - A. Under 1,000 rows
   - B. 1,000–10,000 rows
   - C. More than 10,000 rows
   - D. Other — give an estimate
   Recommended if unsure: B. If the answer is C, say that A may be too small and
   offer to switch to B or E before continuing.
3. How many people use it at the same moment?
   - A. 1–5
   - B. 6–20
   - C. More than 20
   - D. Other — give a number
   Recommended if unsure: A.
4. Does it need to send email or store files?
   - A. Email only
   - B. Files only
   - C. Both
   - D. Neither
   - E. Other — describe
   Recommended if unsure: D — add it only when a screen needs it.

### If B — ready-made online database with login (Supabase)
1. How should people sign in?
   - A. Email and password
   - B. A one-time link sent by email (no password to remember)
   - C. A Google account
   - D. No sign-in; anyone can open it
   - E. Other — describe
   Recommended if unsure: C — fewer passwords to support.
2. Will people upload files?
   - A. No
   - B. Small pictures
   - C. Documents (PDF, Excel)
   - D. Both pictures and documents
   - E. Other — describe
   Recommended if unsure: A — start without uploads.
3. Who may see which data?
   - A. Everyone sees everything
   - B. Each person sees only their own data
   - C. Staff see all, customers see their own
   - D. Anyone may read, only staff may change
   - E. Other — describe
   Recommended if unsure: C.
4. Any automatic work in the background?
   - A. None
   - B. Send an email/notification when something happens
   - C. A scheduled summary or report
   - D. Other — describe
   Recommended if unsure: A.

### If C — fast global service (Cloudflare Worker)
1. What does it store?
   - A. Small settings or counters
   - B. Records, up to about 100,000
   - C. Pictures or files
   - D. Other — describe
   Recommended if unsure: B.
2. Must it run on a schedule or react to another service?
   - A. No
   - B. A daily summary
   - C. React instantly when another service sends an event
   - D. Other — describe
   Recommended if unsure: A.
3. Where do the pages come from?
   - A. The same service
   - B. A separate website host
   - C. Not sure — pick one and say why
   - D. Other — describe
   Recommended if unsure: A — one place to deploy.
4. Do you already own a domain name?
   - A. No, use the free address
   - B. Yes — say which one
   - C. Want a free subdomain
   - D. Other — describe
   Recommended if unsure: A.

### If D — Google app platform with live sync (Firebase)
1. When one person changes data, how fast must others see it?
   - A. Instantly
   - B. Within a few seconds
   - C. On the next refresh is fine
   - D. Other — describe
   Recommended if unsure: C — live sync costs more and is rarely required.
2. How should people sign in?
   - A. Email and password
   - B. A Google account
   - C. A phone number
   - D. No sign-in
   - E. Other — describe
   Recommended if unsure: B.
3. Uploaded files?
   - A. None
   - B. Pictures
   - C. Documents
   - D. Both
   - E. Other — describe
   Recommended if unsure: A.
4. Notifications?
   - A. None
   - B. Inside the app only
   - C. Push to phone or browser
   - D. Other — describe
   Recommended if unsure: B.

### If E — database only (Neon, Tier 2, only on request)
1. The database needs a small program in front. Where should it run?
   - A. Together with the pages
   - B. As a separate small service
   - C. Not sure — recommend one
   - D. Other — describe
   Recommended if unsure: A — fewer moving parts.
2. Who handles sign-in?
   - A. Supabase
   - B. Firebase
   - C. Built into the app itself
   - D. No sign-in
   - E. Other — describe
   Recommended if unsure: C — one less account to manage.
3. Do you need a separate copy of the database for testing?
   - A. Yes
   - B. No
   - C. Not sure — explain in one line, then re-ask
   - D. Other — describe
   Recommended if unsure: A — test data never touches real data.
4. About how much data and traffic?
   - A. Small: under 1 GB, few users
   - B. Medium: a few GB, daily use
   - C. Large or unknown
   - D. Other — estimate
   Recommended if unsure: A.

### If F — two or more services combined (Hybrid, Tier 2, only on request)
1. What does each part do?
   - A. Pages in one place, data and login in another
   - B. Pages and login together, data elsewhere
   - C. Not sure — recommend one split
   - D. Other — one sentence per part
   Recommended if unsure: A.
2. Which service holds the main data?
   - A. One clear database
   - B. It is split across services
   - C. Not sure — recommend one
   - D. Other — describe
   Recommended if unsure: A — one source of truth.
3. If one part fails, what may still work?
   - A. Pages still open, data is unavailable
   - B. Everything can go down, that is acceptable
   - C. Not sure — recommend one
   - D. Other — describe
   Recommended if unsure: A.
4. Who keeps it running after launch?
   - A. Me or my team
   - B. Nobody — prefer the least maintenance
   - C. A hosting provider
   - D. Other — describe
   Recommended if unsure: B.

### If G — pages and data in one project (Next.js)
1. Must pages be found on Google?
   - A. Yes, that matters
   - B. No, it is a private app
   - C. Not sure — explain the trade-off
   - D. Other — describe
   Recommended if unsure: B.
2. How should people sign in?
   - A. Email and password
   - B. A Google account
   - C. A one-time link by email
   - D. No sign-in
   - E. Other — describe
   Recommended if unsure: B.
3. One project or separate front and back?
   - A. One project
   - B. Separate
   - C. Not sure — recommend one
   - D. Other — describe
   Recommended if unsure: A.
4. Where should it be published?
   - A. Vercel
   - B. My own server
   - C. Not sure — recommend one
   - D. Other — describe
   Recommended if unsure: A.

### If H — own server program (Node/Express)
1. Who keeps the server running after launch?
   - A. Someone on my team
   - B. Nobody — prefer a managed service
   - C. Not sure — recommend one
   - D. Other — describe
   Recommended if unsure: B.
2. How should people sign in?
   - A. Email and password
   - B. A Google account
   - C. No sign-in
   - D. Other — describe
   Recommended if unsure: A.
3. How should the app talk to the database?
   - A. Through a standard helper that handles the details
   - B. With hand-written database commands
   - C. Let the agent decide and record it
   - D. Other — describe
   Recommended if unsure: A or C.
4. Should the server be packaged so it starts the same way on any machine
   (this packaging is called Docker)?
   - A. Yes
   - B. No
   - C. Not sure — recommend one
   - D. Other — describe
   Recommended if unsure: C.

### If I — PHP framework with admin page (Laravel)
1. Do you need a ready-made admin panel?
   - A. Yes
   - B. No
   - C. Not sure — explain in one line
   - D. Other — describe
   Recommended if unsure: A.
2. How should people sign in?
   - A. Email and password
   - B. A Google account
   - C. Both
   - D. Other — describe
   Recommended if unsure: A.
3. Should the database sit on the same server?
   - A. Yes
   - B. Separate
   - C. Not sure — recommend one
   - D. Other — describe
   Recommended if unsure: A.
4. Where will it be hosted?
   - A. My own server (VPS)
   - B. Shared PHP hosting
   - C. Not sure — recommend one
   - D. Other — describe
   Recommended if unsure: A.

### If J — Python framework with admin page (FastAPI/Django)
1. Do you need a ready-made admin panel?
   - A. Yes
   - B. No
   - C. Not sure — explain in one line
   - D. Other — describe
   Recommended if unsure: A.
2. How should people sign in?
   - A. Email and password
   - B. A Google account
   - C. Both
   - D. No sign-in
   - E. Other — describe
   Recommended if unsure: A.
3. Any heavy data work?
   - A. No
   - B. Reports and charts
   - C. Predictions or machine learning
   - D. Other — describe
   Recommended if unsure: B.
4. Where will it be hosted?
   - A. My own server (VPS)
   - B. A managed platform
   - C. Not sure — recommend one
   - D. Other — describe
   Recommended if unsure: A.

### If K — one code base for web and phones (Flutter)
1. Which platforms first?
   - A. Web only
   - B. Android only
   - C. Web and Android
   - D. Web, Android and iPhone
   - E. Other — describe
   Recommended if unsure: C.
2. Where do data and login live?
   - A. Supabase
   - B. Firebase
   - C. My own API
   - D. Not sure — recommend one
   - E. Other — describe
   Recommended if unsure: A.
3. How should people sign in?
   - A. Email and password
   - B. A Google account
   - C. A phone number
   - D. No sign-in
   - E. Other — describe
   Recommended if unsure: B.
4. Should it work without internet?
   - A. No, always online is fine
   - B. Read offline
   - C. Full offline with sync later
   - D. Other — describe
   Recommended if unsure: A.

## A9. Do you have pictures of how it should look?

**Recommended if you are not sure:** A — the agent proposes a direction that
fits the domain, and you review the result in Phase 2.

- A. No references — propose a direction
- B. Screenshots or mockups — I will put them in projects/<slug>/refs/
- C. A live website or app I like — I will send the link
- D. A mix of the above
- E. Other — describe the look in words (colours, mood, brand)

If references exist, ask these as separate messages, one at a time:

1. "Should the design follow the reference closely?"
   - A. Keep the structure only (default)
   - B. Copy it closely, pixel by pixel
   - C. Take only the mood and colours
   - D. Other — describe
   Recommended if unsure: A.
2. "Which device matters most?"
   - A. Phone first
   - B. Desktop first
   - C. Both equally
   - D. Other — describe
   Recommended if unsure: C.

## A10. How will we know it is finished and good enough?

In plain terms: what must you be able to do in front of the app before you say
"yes, this works"?

**Recommended if you are not sure:** B — every screen opens, sign-in works, and
saved data is still there after a reload.

- A. Every main screen opens; add, edit, and delete work without errors
- B. A + sign-in works + saved data appears again after a reload
- C. B + looks right on phone, tablet, and desktop + a test copy online
- D. B + the staff who will really use it try it and approve
- E. Other — write your own checklist, one item per line

After A10 is answered: generate the full PRD (Part B), save the file, show it,
and wait for approval. If any answer is still missing, go back to that question
first; do not generate a partial PRD.

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

## 12. UI Contract & Design Blueprint Handoff (Lampiran Images)

<!-- MANDATORY. Bab ini dan gambar-gambar rujukan di projects/{{SLUG}}/refs/ adalah input langsung untuk Phase 2 (UI Designer).
Ekstrak spesifikasi ke dalam projects/{{SLUG}}/design/DESIGN-BLUEPRINT.md merangkumi 7 langkah:
1. Karakter & Gaya Desain (UI Style)
2. Palet Warna & Token (HEX & Tailwind)
3. Tipografi & Hierarki Teks
4. Struktur Layout & Navigasi
5. Bedah Komponen Detail
6. Detail Visual & Interaksi
7. Design System Blueprint untuk Webapp Builder
Tulis dengan tepat supaya blueprint dan kod Phase 3 dapat dijana tanpa perlu bertanya semula. -->
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
