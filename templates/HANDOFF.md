# HANDOFF — {{NAMA_PRODUK}}

Date: {{TARIKH}}
Version: {{VERSI}}
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
| `{{ENV_1}}` | {{LOKASI_ENV_1}} | {{NOTA_ENV_1}} |

Secret values are NOT written here.

## Local run

```bash
bash scripts/test-local.sh {{SLUG}}
```

## Redeploy

```bash
{{ARAHAN_DEPLOY}}
```

## Test

```bash
bash scripts/qa-check.sh {{SLUG}}
bash scripts/test-local.sh {{SLUG}} --check
```

Last result: {{KEPUTUSAN_UJIAN}}

## Backup & rollback

{{BACKUP_ROLLBACK}}

## Known limitations

- {{HAD_1}}
- {{HAD_2}}

## Links

- PRD: `projects/{{SLUG}}/prd/PRD-v0.1.md`
- Design: `projects/{{SLUG}}/design/design.figcraft`
- Exports: `projects/{{SLUG}}/design/exports/`
