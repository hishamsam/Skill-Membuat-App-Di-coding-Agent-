# HANDOFF — {{NAMA_PRODUK}}

Tarikh: {{TARIKH}}
Versi: {{VERSI}}
Folder: `projek/{{SLUG}}/`

## URL

| Persekitaran | URL |
| --- | --- |
| Production | {{URL_PRODUCTION}} |
| Staging | {{URL_STAGING}} |

## Akaun

| Peranan | E-mel / ID | Nota |
| --- | --- | --- |
| Admin | {{ADMIN_LOGIN}} | Tukar kata laluan selepas login pertama |
| Pengguna demo | {{DEMO_LOGIN}} | Untuk ujian sahaja |

## Teknologi

| Lapisan | Teknologi |
| --- | --- |
| Frontend | {{FE}} |
| Backend | {{BE}} |
| Pangkalan data | {{DB}} |
| Auth | {{AUTH}} |
| Hosting | {{HOST}} |

## Pemboleh ubah persekitaran

| Nama | Di mana | Nota |
| --- | --- | --- |
| `{{ENV_1}}` | {{LOKASI_ENV_1}} | {{NOTA_ENV_1}} |

Nilai rahsia TIDAK ditulis di sini.

## Jalan tempatan

```bash
bash skrip/test-local.sh {{SLUG}}
```

## Deploy semula

```bash
{{ARAHAN_DEPLOY}}
```

## Ujian

```bash
bash skrip/qa-check.sh {{SLUG}}
bash skrip/test-local.sh {{SLUG}} --check
```

Keputusan terakhir: {{KEPUTUSAN_UJIAN}}

## Backup & rollback

{{BACKUP_ROLLBACK}}

## Had diketahui

- {{HAD_1}}
- {{HAD_2}}

## Pautan

- PRD: `projek/{{SLUG}}/prd/PRD-v0.1.md`
- Reka bentuk: `projek/{{SLUG}}/design/design.figcraft`
- Eksport: `projek/{{SLUG}}/design/exports/`
