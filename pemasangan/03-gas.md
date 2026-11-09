# 03 — Google Apps Script (GAS)

## Ringkasan

GAS tidak mempunyai MCP server rasmi. Pemasangan dibuat melalui pelayar
(Google Sheets → Extensions → Apps Script) atau CLI `clasp`.

| Perkara | Nilai |
| --- | --- |
| Pangkalan data | Google Sheets |
| Backend | `Code.gs` (Web App / JSON API) |
| Frontend | `index.html` (Vercel atau Web App) |
| Ujian tempatan | Mod pratonton (`IS_PREVIEW = true`) |
| MCP | Tiada |

## Pemasangan

1. Buka [sheets.new](https://sheets.new).
2. **Extensions → Apps Script**.
3. Tampal `Code.gs`, jalankan `setupDatabase()`.
4. **Project Settings → Script Properties**:
   - `TOKEN_SECRET` (teks rawak panjang)
   - `SPREADSHEET_ID` (jika standalone)
5. **Deploy → New deployment → Web app**:
   - Execute as: **Me**
   - Who has access: **Anyone**
6. Salin URL berakhir `/exec`.

## Pilihan CLI (clasp)

```bash
npx @google/clasp login
npx @google/clasp clone <scriptId>
npx @google/clasp push
```

`clasp` bukan MCP; ia hanya muat naik fail.

## Ujian tempatan

GAS tidak berjalan di tempatan. Uji dua lapisan:

1. **Frontend mod pratonton**
   ```bash
   cd projek/<slug>/app && python3 -m http.server 4173
   ```
   Set `IS_PREVIEW = true`, data demo mesti lengkap.

2. **Backend sebenar**
   ```bash
   curl -L -X POST "<GAS_URL>" \
     -H "Content-Type: text/plain;charset=utf-8" \
     -d '{"action":"ping","data":{}}'
   ```

## Rahsia

- Jangan hardcode `TOKEN_SECRET`, `SPREADSHEET_ID`, atau URL dalam kod.
- Guna `PropertiesService.getScriptProperties().getProperties()` sekali.
- Frontend tidak menyimpan rahsia; hanya URL Web App.

## Had yang perlu dicatat dalam PRD

- Kuota harian GAS (panggilan, masa jalan, e-mel).
- Google Sheets bukan pangkalan data transaksi; had baris dan kunci.
- Masa jalan 6 minit setiap pelaksanaan.
- Tidak sesuai untuk trafik tinggi atau data besar.
