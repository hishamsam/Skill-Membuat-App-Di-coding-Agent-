# Fasa 5 — Serahan & Deploy

Tujuan: serah app yang sudah diuji, dengan arahan jalan, tetapan, dan
rollback yang jelas.

## Output wajib

```text
projek/<slug>/
├── HANDOFF.md
├── prd/PRD-v0.1.md
├── design/design.figcraft + exports/
├── app/                  # kod siap
└── tests/                # skrip/senarai ujian
```

## Langkah

1. Isi `HANDOFF.md` daripada templat `templat/HANDOFF.md`.
2. Jalankan semula:

   ```bash
   bash skrip/qa-check.sh <slug>
   bash skrip/test-local.sh <slug> --check
   ```

3. Deploy mengikut stack:

   | Stack | Arahan deploy |
   | --- | --- |
   | GAS + static | Deploy `Code.gs` sebagai Web App; upload `index.html` ke Vercel |
   | Supabase | Deploy frontend (Vercel/Pages); `npx supabase db push`; tetapkan env |
   | Cloudflare Worker | `npx wrangler deploy`; `wrangler secret put` untuk rahsia |
   | Firebase | `npx firebase-tools deploy --only hosting,firestore:rules` |
   | Neon | Deploy API (Worker/Vercel); `db/migrations` dijalankan pada DB produksi |
   | Hibrid | Deploy setiap lapisan ikut jadual di atas |

4. Uji production (smoke test):
   - buka URL production;
   - login akaun sebenar;
   - satu CRUD;
   - satu kes ralat (input tidak sah).
5. Tanda `STATUS.md` selesai dan serahkan.

## HANDOFF.md mesti ada

- URL production + URL staging (jika ada).
- Akaun admin pertama dan cara tukar kata laluan.
- Senarai env var / rahsia (nama sahaja, bukan nilai).
- Arahan jalan tempatan.
- Arahan deploy semula.
- Backup & rollback.
- Had yang diketahui (kuota, had stack, kerja Fasa 2).
- Pautan ke PRD, design, dan eksport PNG.

## Backup & rollback

| Stack | Backup | Rollback |
| --- | --- | --- |
| GAS | Salinan Sheet + versi deployment | Deploy semula versi lama di Deployment ID sama |
| Supabase | `supabase db dump` / backup harian | Restore snapshot / `db reset` pada projek dev |
| Worker | Git + `wrangler deployments` | `wrangler rollback` |
| Firebase | Backup Firestore / Git rules | Deploy semula rules + hosting versi lama |
| Neon | Neon branch / restore | Restore branch atau PITR |

## Definisi siap

- [ ] PRD diluluskan dan disimpan.
- [ ] Fail FigCraft + eksport PNG disimpan.
- [ ] Kod lulus `qa-check` dan ujian tempatan.
- [ ] Semua keperluan **Wajib** PRD berfungsi.
- [ ] Ujian production lulus.
- [ ] HANDOFF.md lengkap.
- [ ] Tiada rahsia dalam repo.

## Selepas serahan

Perubahan seterusnya: kemas kini PRD dahulu jika keperluan berubah, kemudian
kod. Jangan ubah kod yang tidak berkaitan tanpa sebab.
