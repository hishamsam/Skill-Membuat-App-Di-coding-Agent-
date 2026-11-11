# HANDOFF — {{PRODUCT_NAME}}

Date: {{DATE}}
Version: {{VERSION}}
Folder: `projects/{{SLUG}}/`

## URL

| Environment | URL |
| --- | --- |
| Production | {{URL_PRODUCTION}} |
| Staging | {{URL_STAGING}} |

## Accounts

| Role | Email / ID | Notes |
| --- | --- | --- |
| Admin | {{ADMIN_LOGIN}} | Change the password after the first login |
| Demo user | {{DEMO_LOGIN}} | For testing only |

## Tech stack

| Layer | Technology |
| --- | --- |
| Frontend | {{FE}} |
| Backend | {{BE}} |
| Database | {{DB}} |
| Auth | {{AUTH}} |
| Hosting | {{HOST}} |

## Environment variables

| Name | Where | Notes |
| --- | --- | --- |
| `{{ENV_1}}` | {{ENV_LOCATION_1}} | {{ENV_NOTE_1}} |

Secret values are NOT written here.

## Local run

```bash
bash scripts/test-local.sh {{SLUG}}
```

## Redeploy

```bash
{{DEPLOY_INSTRUCTIONS}}
```

## Test

```bash
bash scripts/qa-check.sh {{SLUG}}
bash scripts/test-local.sh {{SLUG}} --check
```

Last result: {{TEST_RESULT}}

## Backup & rollback

{{BACKUP_ROLLBACK}}

## Known limitations

- {{KNOWN_LIMITATION_1}}
- {{KNOWN_LIMITATION_2}}

## Links

- PRD: `projects/{{SLUG}}/prd/PRD-v0.1.md`
- Design Blueprint: `projects/{{SLUG}}/design/DESIGN-BLUEPRINT.md`
- References: `projects/{{SLUG}}/refs/`
