<!--
=====================================================================
PRD TEMPLATE + PRD GENERATOR — ENGLISH & MALAYSIA (BILINGUAL COMPLIANT)
=====================================================================
This file is TWO things at once:
1. INTERVIEW PROTOCOL for collecting project information.
2. PRD TEMPLATE filled in after the interview.

INSTRUCTIONS FOR THE AI — READ EVERYTHING BEFORE STARTING
---------------------------------------------------------------------
You are the Product Manager + Solution Architect who assembles the PRD.

INPUT:
- The user's rough idea, meeting notes, transcript, or existing document.
- UI reference images (optional, used as visual reference only): screenshots, Figma mockups, Dribbble/Mobbin images. Confirm that you own the image or hold a license before reproducing its assets or trade dress.

TASK:
1. Run INTERVIEW MODE (Part A) until there is enough information.
2. Fill ALL {{...}} placeholders in Part B with deep, maximal, engineering-grade detail.
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
  concrete example. Do not move on and do not generate a partial PRD.
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
- Fill all 17 chapters with exhaustive, production-grade depth (matrices, schemas, contracts).
- Mark [ASSUMPTION] only for items the user deliberately leaves to the agent.
- Still show the PRD summary and the assumptions list in the final report.
- Formal, concise English or Malay matching user language, no marketing fluff.
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
wrong with it? What is the main metric of success (e.g. save 5 hours/week, 0 errors)?"

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

In plain words: which technology should power it? Read the list below to the
user, and say the recommendation.

**Recommended if you are not sure:** B — Supabase is the standard online
database for web apps: easy to start, handles login and data, scales up.

Tier 1 — recommended for new projects:
- B. Ready-made online database with login (Supabase / PostgreSQL)
- C. Fast global service that answers everywhere (Cloudflare Workers)
- D. Google app platform with live sync (Firebase)
- G. Pages and data combined in one project (Next.js + PostgreSQL)
- H. Your own server program (Node/Express + PostgreSQL)
- I. PHP framework with a ready admin page (Laravel + MySQL)
- J. Python framework with a ready admin page (FastAPI/Django + PostgreSQL)
- K. One code base for website and phones (Flutter)

Tier 2 — choose only if you already use it or need it:
- A. Google spreadsheet with a web app on top (Google Apps Script)
  *(Limit: slow with over ~100 users or ~10,000 rows)*
- E. Database only; a small program still sits in front (Neon)
  *(Limit: needs a separate place to run your program)*
- F. Combined: two or more of the above working together (Hybrid)
  *(Limit: more moving parts to maintain)*

**Other — describe:** if none of the codes fits, ask the user to describe the
setup. The agent picks the closest Tier 1 stack, explains in one sentence
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
   - B. Yes, save data and sync when connected
   - C. Not sure — recommend one
   - D. Other — describe
   Recommended if unsure: A.

## A9. Do you have pictures of how it should look?

**Recommended if you are not sure:** A — the agent proposes a direction that
fits the domain, and you review the result in Phase 2.

- A. No references — propose a direction
- B. Screenshots or mockups — I will put them in projects/<slug>/refs/
- C. A live website or app I like — I will send the link
- D. A mix of the above
- E. Other — describe the look in words (colors, mood, brand)

If references exist, ask these as separate messages, one at a time:

1. "Should the design follow the reference closely?"
   - A. Keep the structure only (default)
   - B. Match the layout and spacing closely, using original assets
   - C. Take only the mood and colors
   - D. Other — describe
   Recommended if unsure: A.
2. "Which device matters most?"
   - A. Phone first
   - B. Desktop first
   - C. Both equally
   - D. Other — describe
   Recommended if unsure: C.
3. "What visual density do you prefer?"
   - A. Balanced / Standard SaaS (comfortable padding, 44px rows, clear space)
   - B. Compact / High Density (dense data, 32px rows, dev/pro tools)
   - C. Relaxed / Consumer (large cards, generous whitespace)
   Recommended if unsure: A.

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

# PRODUCT REQUIREMENTS DOCUMENT — {{PRODUCT_NAME}}

**STATUS: {{DOCUMENT_STATUS}}**

| Metadata Item | Specification |
| --- | --- |
| **Product Name** | {{PRODUCT_FULL_NAME}} |
| **Document Version** | v0.1 (Provisional Draft) |
| **Prepared by** | {{AUTHOR_NAME}} |
| **For / Stakeholder** | {{CLIENT_NAME}} |
| **Date** | {{DOCUMENT_DATE}} |
| **Project Folder** | `projects/{{SLUG}}/` |
| **Target Technology** | {{SELECTED_TECHNOLOGY}} |
| **Related Documents** | `DESIGN-BLUEPRINT.md`, `STATUS.md`, `THREAT-MODEL.md` |

---

## 1. Product Summary & Strategic Alignment

### 1.1 Problem Statement & Background
<!-- 1-2 paragraphs detailing the real-world operational pain points, manual overhead, and cost of errors in the current process. -->
{{PROBLEM_STATEMENT}}

### 1.2 Solution Overview & Core Value Proposition
<!-- 1-2 paragraphs detailing the proposed digital solution, core modules, and primary user journey. -->
{{SOLUTION_SUMMARY}}

### 1.3 Target Audience & Primary Use Cases
<!-- Specific user groups and scenarios in which the application delivers highest impact. -->
{{TARGET_AUDIENCE}}

### 1.4 North Star Metric & Measurable Success Indicators
<!-- 3-5 concrete, quantifiable success metrics. -->
- **North Star Metric:** {{PRIMARY_METRIC}}
- **Efficiency Metric:** {{EFFICIENCY_METRIC}}
- **Accuracy Metric:** {{ACCURACY_METRIC}}
- **Adoption Target:** {{ADOPTION_METRIC}}

---

## 2. Goals & Objectives

### 2.1 Business Objectives
- {{BUSINESS_OBJECTIVE_1}}
- {{BUSINESS_OBJECTIVE_2}}

### 2.2 User Experience Objectives
- {{UX_OBJECTIVE_1}}
- {{UX_OBJECTIVE_2}}

### 2.3 Technical & Operational Objectives
- {{TECHNICAL_OBJECTIVE_1}}
- {{TECHNICAL_OBJECTIVE_2}}

---

## 3. Users, Personas & Role-Based Access Control (RBAC)

### 3.1 User Personas
<!-- Detailed persona profile per role: responsibilities, tech literacy, primary device. -->
- **{{ROLE_1}} :** {{ROLE_DESCRIPTION_1}}
- **{{ROLE_2}} :** {{ROLE_DESCRIPTION_2}}
- **{{ROLE_3}} :** {{ROLE_DESCRIPTION_3}}

### 3.2 Permissions & Access Control Matrix (RBAC)
<!-- Complete CRUD + Approve/Export permissions per role across all system entities. -->
| Entity / Resource | Role: {{ROLE_1}} | Role: {{ROLE_2}} | Role: {{ROLE_3}} | Public / Unauth |
| --- | --- | --- | --- | --- |
| **{{ENTITY_1}}** | C, R, U, D, Export | R, U (Own) | R (Assigned) | Denied |
| **{{ENTITY_2}}** | C, R, U, D, Approve | C, R (Own) | Denied | Denied |
| **{{ENTITY_3}}** | C, R, U, D | R | R | Denied |
| **User Management** | Full Access | Denied | Denied | Denied |
| **Audit Logs** | Read Only | Denied | Denied | Denied |

*Legend: C = Create, R = Read, U = Update, D = Delete*

---

## 4. Scope & Phasing

### 4.1 In Scope (MVP Core Capabilities)
<!-- Must be exhaustive: every feature included in v0.1 must be listed. -->
- {{MVP_SCOPE_1}}
- {{MVP_SCOPE_2}}
- {{MVP_SCOPE_3}}
- {{MVP_SCOPE_4}}

### 4.2 Out of Scope / Boundaries & Guardrails
<!-- Explicit non-goals to prevent scope creep during engineering. -->
- {{OUT_OF_SCOPE_1}}
- {{OUT_OF_SCOPE_2}}
- {{OUT_OF_SCOPE_3}}

### 4.3 Phasing & Roadmap Milestones
| Milestone | Scope Summary | Target Criteria |
| --- | --- | --- |
| **Phase 1: MVP (Current)** | Core CRUD, Auth, Essential Flows, Single Role / Basic RBAC | Test scripts pass, security scan clean |
| **Phase 2: Operational** | Automated notifications, bulk exports, managerial approvals | Real-world pilot launch |
| **Phase 3: Scale & Analytics**| Advanced reporting, external webhook integrations, mobile apps | Multi-branch / team scale |

---

## 5. Assumptions, Dependencies & Constraints

### 5.1 Technical Assumptions
<!-- Mark every assumption explicitly with [ASSUMPTION]. -->
- [ASSUMPTION] {{ASSUMPTION_1}}
- [ASSUMPTION] {{ASSUMPTION_2}}
- [ASSUMPTION] {{ASSUMPTION_3}}

### 5.2 Business & Operational Constraints
- {{OPERATIONAL_CONSTRAINT_1}}
- {{OPERATIONAL_CONSTRAINT_2}}

### 5.3 Compliance, Security & Privacy Constraints
- Data protection: Personal Identifiable Information (PII) handled in compliance with local privacy standards.
- Audit trail: All state changes and sensitive deletions must record actor ID and timestamp.
- Secret isolation: No private database keys or service role tokens allowed on the client bundle.

---

## 6. Technology Decision & System Architecture

### 6.1 Stack Architecture & Justification
| Layer | Chosen Technology | Engineering Rationale | Rejected Alternatives & Trade-offs |
| --- | --- | --- | --- |
| **Frontend Framework** | {{FE_TECH}} | {{FE_SEBAB}} | {{FE_ALT}} |
| **Backend / API Engine** | {{BE_TECH}} | {{BACKEND_REASON}} | {{BE_ALT}} |
| **Primary Database** | {{DB_TECH}} | {{DATABASE_REASON}} | {{DB_ALT}} |
| **Authentication & RBAC** | {{AUTH_TECH}} | {{AUTH_REASON}} | {{AUTH_ALT}} |
| **File Storage** | {{STORAGE_TECH}} | {{STORAGE_REASON}} | {{STORAGE_ALT}} |
| **Hosting & Deployment** | {{HOST_TECH}} | {{HOST_SEBAB}} | {{HOST_ALT}} |

### 6.2 Services, Configuration & Secret Separation
| Configuration Item | Exposure Level | Target Environment / Variable | Notes |
| --- | --- | --- | --- |
| Public API URL / Host | Client (Public) | `NEXT_PUBLIC_API_URL` / `VITE_API_URL` | Safe to bundle in browser |
| Public Anon Key | Client (Public) | `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Restricted by RLS policies |
| Database Connection String | Server (Confidential) | `DATABASE_URL` | Never exposed to client bundle |
| Service Role / Admin Secret | Server (Strict Secret) | `SUPABASE_SERVICE_ROLE_KEY` / `API_SECRET` | Backend worker / API only |
| Session Token / Cookie Key | Server (Strict Secret) | `SESSION_SECRET` / `JWT_SECRET` | HttpOnly, Secure, SameSite=Lax |

### 6.3 System Architecture Diagram
```text
{{ARCHITECTURE_FLOW}}
```

### 6.4 Data Consistency & Failure Isolation Strategy
- All write transactions that span multiple tables must execute within a database transaction or atomic RPC call.
- Optimiztic UI updates must revert smoothly with an error toast if the backend mutation rejects.
- External API calls must incorporate a 5-second timeout and graceful degradation fallback.

---

## 7. Functional Requirements & Business Rules

<!-- Grouped by logical module (7.1, 7.2, etc.). Each module contains user story, capability table, validation rules, Gherkin criteria, and edge cases. -->

### 7.1 Module: {{MODULE_NAME_1}}

**User Story:** As a {{ROLE_1}}, I want to {{USER_ACTION_1}}, so that {{BUSINESS_VALUE_1}}.

#### Capabilities & Functional Matrix
| ID | Requirement Description | Priority | Business Logic & Rules |
| --- | --- | --- | --- |
| **{{PREFIX}}-1** | {{REQUIREMENT_DESCRIPTION_1}} | **Mandatory** | {{BUSINESS_RULE_1}} |
| **{{PREFIX}}-2** | {{REQUIREMENT_DESCRIPTION_2}} | **Mandatory** | {{BUSINESS_RULE_2}} |
| **{{PREFIX}}-3** | {{REQUIREMENT_DESCRIPTION_3}} | **Important** | {{BUSINESS_RULE_3}} |

#### Input Validation Matrix
| Field Name | Type | Required | Validation Constraints / Regex | Error Message |
| --- | --- | --- | --- | --- |
| `{{FIELD_1}}` | {{TYPE_1}} | Yes | {{VALIDATION_RULE_1}} | "{{ERROR_MESSAGE_1}}" |
| `{{FIELD_2}}` | {{TYPE_2}} | Yes | {{VALIDATION_RULE_2}} | "{{ERROR_MESSAGE_2}}" |

#### Acceptance Criteria (Given-When-Then)
- **Scenario 1 (Happy Path):**
  - **Given** {{INITIAL_CONDITION_1}}
  - **When** {{TEST_ACTION_1}}
  - **Then** {{TEST_RESULT_1}}
- **Scenario 2 (Validation Failure):**
  - **Given** {{INITIAL_CONDITION_2}}
  - **When** {{TEST_ACTION_2}}
  - **Then** {{TEST_RESULT_2}}

#### Edge Cases & Failure Handling
- **Duplicate submission:** Double-click on submit button is prevented by immediate button disable + loading spinner.
- **Network timeout:** If server does not respond within 8 seconds, request aborts and shows inline retry banner.
- **Concurrent edits:** Last-write-wins or optimistic lock verification based on `updated_at` timestamp.

---

### 7.2 Module: {{MODULE_NAME_2}}

**User Story:** As a {{ROLE_2}}, I want to {{USER_ACTION_2}}, so that {{BUSINESS_VALUE_2}}.

#### Capabilities & Functional Matrix
| ID | Requirement Description | Priority | Business Logic & Rules |
| --- | --- | --- | --- |
| **{{PREFIX_2}}-1** | {{REQUIREMENT_DESCRIPTION_2_1}} | **Mandatory** | {{BUSINESS_RULE_2_1}} |
| **{{PREFIX_2}}-2** | {{REQUIREMENT_DESCRIPTION_2_2}} | **Important** | {{BUSINESS_RULE_2_2}} |

#### Input Validation Matrix
| Field Name | Type | Required | Validation Constraints / Regex | Error Message |
| --- | --- | --- | --- | --- |
| `{{FIELD_2_1}}` | {{TYPE_2_1}} | Yes | {{VALIDATION_RULE_2_1}} | "{{ERROR_MESSAGE_2_1}}" |

#### Acceptance Criteria (Given-When-Then)
- **Scenario 1:**
  - **Given** {{INITIAL_CONDITION_2_1}}
  - **When** {{TEST_ACTION_2_1}}
  - **Then** {{TEST_RESULT_2_1}}

#### Edge Cases & Failure Handling
- {{EDGE_CASE_HANDLING_2}}

---

## 8. Main User Flows & State Machines

### 8.1 Primary End-to-End User Flow (Happy Path)
<!-- Detailed step-by-step sequence from entry to successful completion. -->
1. **Entry & Authentication:** User navigates to `/login`, enters credentials, and receives authenticated session with redirect to `/dashboard`.
2. **Initiation:** User clicks `{{PRIMARY_ACTION_BUTTON}}` on the dashboard; system transitions to `{{FORM_MODAL_STATE}}`.
3. **Data Entry & Validation:** User completes required fields; client-side validation evaluates in real-time.
4. **Submission & Processing:** User clicks "Submit"; button disables with spinner, payload posts to API endpoint.
5. **Confirmation & Feedback:** Backend persists record; UI displays success toast "{{SUCCESS_TOAST}}", dismisses modal, and updates list via optimistic update.

### 8.2 Entity Lifecycle & State Transition Matrix
<!-- Status state machine for main business entity (e.g. Draft -> Submitted -> Approved / Rejected). -->
| Current State | Trigger / Event | Allowed Actor | Next State | System Actions & Notifications |
| --- | --- | --- | --- | --- |
| `draft` | Click "Submit for Review" | Creator | `pending_review` | Send notification to Manager |
| `pending_review` | Click "Approve" | Manager / Admin | `approved` | Generate confirmation record |
| `pending_review` | Click "Reject" (with reason)| Manager / Admin | `rejected` | Send rejection email to Creator |
| `approved` | Click "Complete" | System / Admin | `completed` | Lock record from further edits |

### 8.3 Exception & Error Recovery Flows
- **Session Expiry:** If JWT token expires during active entry, form data is preserved in `sessionStorage`, modal triggers login prompt without page reload, and submission retries upon re-auth.
- **Resource Not Found (404):** Clean zero-state message with single "Return to Dashboard" CTA.
- **Internal Server Error (500):** Generic user-friendly message with error tracking ID, avoiding raw stack-trace leakage.

---

## 9. Data Architecture, Schemas & API Contracts

### 9.1 Data Model Dictionary
<!-- Complete dictionary of entities, attributes, data types, and constraints. -->

#### Entity: `{{ENTITY_1}}`
| Column / Field | Data Type | Nullable | Constraints & Defaults | Description |
| --- | --- | --- | --- | --- |
| `id` | `uuid` / `text` | No | Primary Key, `gen_random_uuid()` | Unique record identifier |
| `created_at` | `timestamptz` | No | Default `now()` | Timestamp of creation |
| `updated_at` | `timestamptz` | No | Default `now()` | Timestamp of last modification |
| `{{COLUMN_1}}` | {{DATA_TYPE_1}} | {{NULL_1}} | {{CONSTRAINT_1}} | {{COLUMN_DESCRIPTION_1}} |
| `{{COLUMN_2}}` | {{DATA_TYPE_2}} | {{NULL_2}} | {{CONSTRAINT_2}} | {{COLUMN_DESCRIPTION_2}} |
| `status` | `text` / `enum` | No | Default `'pending'` | Current lifecycle status |

#### Entity: `{{ENTITY_2}}`
| Column / Field | Data Type | Nullable | Constraints & Defaults | Description |
| --- | --- | --- | --- | --- |
| `id` | `uuid` / `text` | No | Primary Key, `gen_random_uuid()` | Unique record identifier |
| `{{ENTITY_1_FK}}` | `uuid` / `text` | No | FK references `{{ENTITY_1}}(id)` | Foreign key relationship |
| `{{COLUMN_2_1}}` | {{DATA_TYPE_2_1}} | {{NULL_2_1}} | {{CONSTRAINT_2_1}} | {{COLUMN_DESCRIPTION_2_1}} |

### 9.2 API & Server Endpoint Contracts

#### Endpoint 1: `GET /api/{{RESOURCES}}`
- **Description:** Retrieve paginated list of resources with filtering.
- **Authentication:** Required (Bearer Token / Cookie Session).
- **Query Parameters:** `page=1&limit=20&status=active&search=keyword`
- **Success Response (200 OK):**
```json
{
  "data": [
    {
      "id": "uuid-here",
      "status": "active"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 45,
    "totalPages": 3
  }
}
```
- **Error Responses:** `401 Unauthorized`, `403 Forbidden`, `500 Internal Server Error`.

#### Endpoint 2: `POST /api/{{RESOURCES}}`
- **Description:** Create a new resource record.
- **Authentication:** Required (Role: `{{ROLE_1}}`).
- **Request Body (application/json):**
```json
{
  "{{COLUMN_1}}": "Example Value",
  "{{COLUMN_2}}": 100
}
```
- **Success Response (201 Created):**
```json
{
  "id": "uuid-here",
  "status": "pending",
  "createdAt": "2026-11-11T10:00:00Z"
}
```
- **Error Responses:** `400 Bad Request` (Validation errors map), `409 Conflict`, `500 Server Error`.

### 9.3 Physical Database Implementation
<!-- Choose ONE block matching the stack chosen in Chapter 6. Delete or adapt others. -->

**If Supabase / PostgreSQL:**
```sql
-- DDL Migration Schema
CREATE TABLE public.{{TABLE_NAME}} (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    CONSTRAINT chk_status CHECK (status IN ('pending', 'approved', 'rejected', 'completed'))
);

-- Performance Indexes
CREATE INDEX idx_{{TABLE_NAME}}_user_id ON public.{{TABLE_NAME}}(user_id);
CREATE INDEX idx_{{TABLE_NAME}}_status ON public.{{TABLE_NAME}}(status);

-- Row Level Security (RLS)
ALTER TABLE public.{{TABLE_NAME}} ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own records"
    ON public.{{TABLE_NAME}} FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own records"
    ON public.{{TABLE_NAME}} FOR INSERT
    WITH CHECK (auth.uid() = user_id);
```

**If Cloudflare Worker (D1 SQLite):**
```sql
-- D1 Migration: 0001_init.sql
CREATE TABLE {{TABLE_NAME}} (
    id TEXT PRIMARY KEY,
    created_at INTEGER NOT NULL DEFAULT (unixepoch()),
    updated_at INTEGER NOT NULL DEFAULT (unixepoch()),
    user_id TEXT NOT NULL,
    title TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending'
);
CREATE INDEX idx_{{TABLE_NAME}}_user_id ON {{TABLE_NAME}}(user_id);
```

---

## 10. Non-Functional Requirements & Service Level Objectives

### 10.1 Web Vitals & Performance Budgets
- **Largest Contentful Paint (LCP):** < 1.5 seconds on fast 4G / broadband.
- **First Input Delay / INP:** < 100 milliseconds for all interactive elements.
- **Cumulative Layout Shift (CLS):** 0.00 (enforced via skeleton loaders with matched dimensions).
- **API Response Latency:** p95 < 250 milliseconds for read queries; p95 < 400ms for mutations.
- **Bundle Size Ceiling:** Initial JavaScript payload < 180 KB compressed.

### 10.2 Security Controls & Hardening
- **Authentication & Sessions:** Secure cookies with `HttpOnly`, `SameSite=Lax`, `Secure` flags; JWT expiration ≤ 24 hours.
- **Injection Prevention:** All database queries parameterized or generated via type-safe ORM/client; zero string concatenation SQL.
- **XSS & Content Security Policy (CSP):** HTML content sanitized; user inputs escaped before rendering.
- **Cross-Site Request Forgery (CSRF):** SameSite cookie validation or CSRF tokens for mutating actions.
- **Rate Limiting:** Maximum 60 requests per minute per IP on authentication and public submission endpoints.

### 10.3 Accessibility & Inclusivity (WCAG 2.1 Level AA)
- Text contrast ratio ≥ 4.5:1 for body copy; ≥ 3:1 for large text and interactive borders.
- Full keyboard navigability: logical tab order, visible focus rings (`focus-visible:ring-2`).
- Touch targets: minimum 44×44px interactive bounding box on touch devices.
- Screen reader accessibility: semantic landmarks (`<main>`, `<nav>`, `<header>`), explicit `aria-label` on icon-only buttons.

### 10.4 Reliability, Fault Tolerance & Error Recovery
- Graceful offline detection: banner notification informing user of disconnected state.
- Form preservation: draft state retained in local storage during unexpected session drops.
- Error boundary wrappers around individual dashboard widgets to isolate failures.

### 10.5 Audit Trail & Mutation Logging
- All insert, update, and delete actions record: `actor_id`, `action_type`, `entity_name`, `entity_id`, `timestamp`, and `diff_summary`.
- Audit logs are immutable (append-only; no update/delete capabilities granted to app users).

---

## 11. Third-Party Integrations & External Services

| External Service | Category / Function | Integration Method | Auth / Credentials | Fallback Strategy if Unavailable |
| --- | --- | --- | --- | --- |
| **{{SERVICE_1}}** | {{FUNCTION_1}} | REST API / Webhook | API Key (Server Env) | Queue request in DB and retry via cron |
| **{{SERVICE_2}}** | {{FUNCTION_2}} | SDK / Client Script | Public Client Key | Degrade gracefully without blocking core app |

---

## 12. UI Contract & Design System Blueprint (Image Attachments)

<!-- MANDATORY. This section bridges directly into Phase 2 (UI Designer) and Phase 3 (Codegen).
All specifications must comply with the UI/UX Technical Dictionary standard rules. -->

### 12.1 Image References & Visual Strategy
| Item | Specification |
| --- | --- |
| **Fidelity Mode** | `Pixel-faithful` (owned references only) / `Structural` / `Mood-only` |
| **Reference Files** | `projects/{{SLUG}}/refs/{{FILE_NAME}}` |
| **Target Device Orientation** | Mobile First (390px) + Desktop Master (1440px) |
| **Extracted Elements** | {{EXTRACTED_ELEMENTS}} |
| **Replaced / Localized Elements** | {{REPLACED_ELEMENTS}} |
| **Copyright & Legal Protection** | Original assets only. No logos, trademarks, illustrations, stock photos, avatars, or copyrighted text reproduced. Fidelity beyond `Structural` requires the user to own the reference or hold a license. |

### 12.2 Design DNA & Aesthetic Archetype
<!-- Informed by UI/UX Technical Dictionary (Modern SaaS, Linear Dark, Apple HIG, Bento Grid, etc.) -->
| Visual Dimension | Specification | Reference Standard |
| --- | --- | --- |
| **Design Language** | {{DNA_STYLE}} | Modern Minimalist SaaS / Linear Clean |
| **Information Density** | {{DNA_DENSITY}} | Standard (44px rows) / Compact (32px rows) |
| **Grid Architecture** | 12-col desktop, 8-col tablet, 4-col mobile | `max-w-7xl mx-auto px-4 sm:px-6 lg:px-8` |
| **Corner Radius Scale** | Concentric: Card `rounded-2xl` (16px), Button `rounded-lg` (8px), Pill `rounded-full` | Formula: $r_{inner} = r_{outer} - padding$ |
| **Shadow System** | Dual-layer ambient: `shadow-sm` base, `shadow-md` floating | Rule 12: Ambient + Key Light |
| **Visual Anti-Slop** | Light canvas default, no cheap purple gradients, no emoji icons, no browser alerts | Zero AI Slop Compliance |

### 12.3 3-Tier Color Token Map
| Token Role | Semantic Class | Hex Code | Purpose & Usage |
| --- | --- | --- | --- |
| **Canvas Background** | `bg-slate-50` / `bg-canvas` | `#F8FAFC` | Root viewport canvas (soft neutral) |
| **Surface Card** | `bg-white` / `bg-surface-1`| `#FFFFFF` | Primary cards, panels, modals |
| **Surface Hover** | `bg-slate-100` | `#F1F5F9` | Table row hover, chip inactive |
| **Border / Hairline** | `border-slate-200/80` | `#E2E8F0` | Razor 1px card and divider borders |
| **Primary Brand Accent** | `bg-slate-900 text-white` | `#0F172A` | Primary CTA, active navigation item |
| **Primary Accent Hover** | `hover:bg-slate-800` | `#1E293B` | Interactive hover for primary button |
| **Secondary Accent** | `text-blue-600 bg-blue-50`| `#2563EB` | Interactive links, badges, focus rings |
| **Typography Heading** | `text-slate-900` | `#0F172A` | Primary titles and section headings |
| **Typography Body** | `text-slate-700` | `#334155` | Paragraph copy, table cell text |
| **Typography Muted** | `text-slate-500` | `#64748B` | Timestamps, subtitles, helper hints |
| **Semantic Success** | `bg-emerald-50 text-emerald-700` | `#10B981` | Completed, paid, approved status pill |
| **Semantic Warning** | `bg-amber-50 text-amber-700` | `#F59E0B` | Pending review, incomplete badge |
| **Semantic Danger** | `bg-rose-50 text-rose-700` | `#EF4444` | Destructive action, error alerts |

### 12.4 Screen Inventory & 4-State Coverage
<!-- Every screen must define 4 states: Default, Loading (Skeleton), Empty, and Error. -->
| Screen ID | Screen Name | Route Path | Access Role | Main Components | 4-State Specifications |
| --- | --- | --- | --- | --- | --- |
| `S-01` | Dashboard Home | `/dashboard` | Authenticated | KPI Bento cards, recent items table, quick action CTA | Default, Skeleton card pulse, Empty ("No records yet"), Error retry |
| `S-02` | Resource List | `/records` | Authenticated | Search & filter bar, data table, pagination bar | Default, Table skeleton 5 rows, Empty search filter, Error toast |
| `S-03` | Record Detail / Form | `/records/:id` | Authenticated | Multi-field form, status timeline, action footer | Default, Form skeleton, 404 Not Found, Validation error |
| `S-04` | Settings / Admin | `/settings` | Admin Only | User management table, profile form, audit trail | Default, List skeleton, Empty user list, Error alert |

### 12.5 Interactive Components & Micro-interactions
- **Buttons (6 States):**
  - Primary: `h-10 px-4 bg-slate-900 hover:bg-slate-800 active:scale-[0.98] text-white font-medium rounded-lg transition-[transform,colors] duration-150 inline-flex items-center justify-center gap-2`.
  - Secondary: `h-10 px-4 border border-slate-300 hover:bg-slate-50 text-slate-700 font-medium rounded-lg transition-colors`.
  - Destructive: `h-10 px-4 bg-rose-600 hover:bg-rose-700 text-white font-medium rounded-lg transition-colors`.
- **Inputs & Form Controls:**
  - Jitter-free focus: `h-10 px-3 bg-white border border-slate-300 focus:outline-none focus:ring-2 focus:ring-slate-900 focus:ring-offset-1 rounded-lg text-sm text-slate-900 placeholder:text-slate-400 transition-shadow`.
- **Data Table Ergonomics:**
  - Text cells left-aligned; numerical/currency cells right-aligned with `font-mono tabular-nums`.
  - Row hover: `hover:bg-slate-50/80 transition-colors`.
  - Sticky right action column with fixed width `w-20`.

### 12.6 Navigation Architecture & Responsive Adaptation
- **Desktop (≥ 1024px):** Fixed left sidebar (`w-64 border-r border-slate-200 bg-white h-screen fixed`) or clean top navigation with search bar and user profile dropdown.
- **Tablet (768px–1023px):** Collapsible sidebar toggle or streamlined topbar with dropdown menu.
- **Mobile (< 768px):** Fixed Bottom Navigation Bar (`fixed bottom-0 left-0 right-0 z-40 bg-white/90 backdrop-blur-md border-t border-slate-200 py-2 pb-[max(8px,env(safe-area-inset-bottom))]`), 3–5 core tabs with icons + text, `<main>` container styled with mandatory `pb-24` to prevent content overlap.
- **Responsive Requirement:** Layout must gracefully adapt across 360px, 390px, 768px, 1024px, 1440px, and 1920px viewports without horizontal root scrollbars.

---

## 13. Local Test Plan & Acceptance Criteria

### 13.1 Local Commands & Quality Verification
```bash
# Automated local smoke & endpoint test
bash scripts/test-local.sh {{SLUG}} --check

# Code quality & anti-pattern verification
bash scripts/qa-check.sh {{SLUG}}

# Security & vulnerability audit gate
bash scripts/security-audit.sh {{SLUG}}
```

### 13.2 Deterministic Demo Accounts & Test Seed Matrix
| Role | Demo Username / Email | Password (Local Dev) | Expected Initial State |
| --- | --- | --- | --- |
| **Admin** | `admin@local.test` | `Admin123!` | Sees all records, audit logs, and settings |
| **Standard User** | `user@local.test` | `User123!` | Sees only own records; create/edit enabled |
| **Approver / Manager** | `manager@local.test` | `Manager123!` | Sees assigned records pending review |

### 13.3 Test Cases & Verification Scenarios
| Test ID | Module | Scenario / Trigger | Action Steps | Expected Outcome |
| --- | --- | --- | --- | --- |
| `T-01` | Auth | Valid User Sign-in | Navigate to `/login`, submit valid credentials | Redirects to `/dashboard`, session established |
| `T-02` | Auth | Invalid Password | Submit invalid password on `/login` | Inline error displayed; no redirect; status 401 |
| `T-03` | CRUD | Create Entity Record | Fill valid form on `/records/new`, click Submit | Record persists; success toast; appears in list |
| `T-04` | Validation | Missing Required Fields| Submit blank form | Field errors highlight in red; submission blocked |
| `T-05` | RBAC | Unauthorized Access | Standard user navigates to `/settings` | Access Denied banner / 403 redirect |
| `T-06` | Responsive | Mobile Viewport | Open app at 390×844 viewport | Bottom nav visible, table scrolls or stacks cleanly |

### 13.4 Strict Definition of Done Checklist
- [ ] All screens listed in Chapter 12.4 open without uncaught browser console errors.
- [ ] Every **Mandatory** requirement in Chapter 7 passes functional verification.
- [ ] Complete CRUD cycle (Create, Read, Update, Delete) succeeds with real or seeded database.
- [ ] Responsive design verified across 360px, 768px, 1024px, and 1440px with zero root horizontal scroll.
- [ ] No dead buttons: every interactive element triggers action, modal, toast, or feedback.
- [ ] Zero exposed credentials or private keys in client-side bundle (`NEXT_PUBLIC_` / `VITE_` audits clean).
- [ ] `bash scripts/qa-check.sh {{SLUG}}` exits with code 0.
- [ ] `bash scripts/security-audit.sh {{SLUG}}` exits with code 0 (zero FAIL findings).

---

## 14. Proposed Features / Later Phase (Post-MVP Roadmap)

- **{{PROPOSED_FEATURE_1}}:** {{FEATURE_DESCRIPTION_1}}
- **{{PROPOSED_FEATURE_2}}:** {{FEATURE_DESCRIPTION_2}}
- **{{PROPOSED_FEATURE_3}}:** {{FEATURE_DESCRIPTION_3}}

---

## 15. Explicitly Rejected Features (Scope Guardrails)

<!-- Features intentionally omitted to prevent scope creep and unnecessary complexity. -->
- **{{REJECTED_FEATURE_1}}:** Deliberately omitted because {{REJECTION_REASON_1}}.
- **{{REJECTED_FEATURE_2}}:** Deliberately omitted because {{REJECTION_REASON_2}}.

---

## 16. Open Questions & Technical Spikes (TBD)

<!-- Decisions that cannot be confirmed until stakeholder validation or external access is granted. -->
- **{{QUESTION_1}}:** {{QUESTION_STATUS_1}}
- **{{QUESTION_2}}:** {{QUESTION_STATUS_2}}

---

## 17. Project Glossary & Domain Terms

- **{{GLOSSARY_TERM_1}} :** {{DEFINITION_1}}
- **{{GLOSSARY_TERM_2}} :** {{DEFINITION_2}}
- **RBAC :** Role-Based Access Control — Method of restricting system access to authorized users based on their assigned role.
- **CLS :** Cumulative Layout Shift — Metric measuring visual stability; target is 0.00 using matched skeleton screens.
- **RLS :** Row Level Security — Database engine security feature that restricts row access based on authenticated user context.

---

*This document serves as the formal specification and binding engineering contract for {{PRODUCT_FULL_NAME}}. Subsequent phases (Phase 2 UI Design, Phase 3 Codegen, Phase 4 Local Testing, and Phase 4.5 Security Gate) must adhere strictly to the requirements defined herein.*
