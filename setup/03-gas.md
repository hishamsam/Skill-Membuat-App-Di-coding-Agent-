# 03 — Google Apps Script (GAS)

## Overview

GAS has no official MCP server. Installation is done through the browser
(Google Sheets → Extensions → Apps Script) or the `clasp` CLI.

| Item | Value |
| --- | --- |
| Database | Google Sheets |
| Backend | `Code.gs` (Web App / JSON API) |
| Frontend | `index.html` (Vercel or Web App) |
| Local testing | Preview mode (`IS_PREVIEW = true`) |
| MCP | None |

## Installation

1. Open [sheets.new](https://sheets.new).
2. **Extensions → Apps Script**.
3. Paste `Code.gs`, run `setupDatabase()`.
4. **Project Settings → Script Properties**:
   - `TOKEN_SECRET` (long random text)
   - `SPREADSHEET_ID` (if standalone)
5. **Deploy → New deployment → Web app**:
   - Execute as: **Me**
   - Who has access: **Anyone**
6. Copy the URL ending in `/exec`.

## CLI option (clasp)

```bash
npx @google/clasp login
npx @google/clasp clone <scriptId>
npx @google/clasp push
```

`clasp` is not MCP; it only uploads files.

## Local testing

GAS does not run locally. Test two layers:

1. **Frontend in preview mode**
   ```bash
   cd projects/<slug>/app && python3 -m http.server 4173
   ```
   Set `IS_PREVIEW = true`; the demo data must be complete.

2. **Real backend**
   ```bash
   curl -L -X POST "<GAS_URL>" \
     -H "Content-Type: text/plain;charset=utf-8" \
     -d '{"action":"ping","data":{}}'
   ```

## Secrets

- Do not hardcode `TOKEN_SECRET`, `SPREADSHEET_ID`, or the URL in the code.
- Use `PropertiesService.getScriptProperties().getProperties()` once.
- The frontend stores no secrets; only the Web App URL.

## Limits to note in the PRD

- GAS daily quotas (calls, runtime, email).
- Google Sheets is not a transactional database; row and lock limits.
- 6-minute runtime per execution.
- Not suitable for high traffic or large data.
