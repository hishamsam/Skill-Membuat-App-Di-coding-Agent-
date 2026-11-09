# Stack H — Node/Express + Postgres

Sesuai: API tersuai, kawalan penuh, deploy VPS/Dokploy.

## Cipta projek

```bash
cd projek/<slug>/app
npm init -y
npm i express pg dotenv
npm i -D nodemon
```

Struktur cadangan:

```text
app/
├── src/
│   ├── index.js
│   ├── routes/
│   └── db.js
├── .env.example
├── .gitignore
└── package.json
```

`package.json` scripts:

```json
{
  "scripts": {
    "dev": "nodemon src/index.js",
    "start": "node src/index.js"
  }
}
```

## Postgres

```bash
# .env
DATABASE_URL="postgres://..."
PORT=3000
JWT_SECRET="..."
```

## Ujian tempatan

```bash
cd projek/<slug>/app
npm install
npm run dev
```

Atau:

```bash
bash skrip/test-local.sh <slug> --check
```

## Deploy VPS/Dokploy

1. Tambah `Dockerfile` atau gunakan buildpack Node Dokploy.
2. Tetapkan env var di Dokploy.
3. Deploy + jalankan migrasi DB.
4. Uji `/api/health`.

## Semakan

- [ ] Auth dan kebenaran di server.
- [ ] Tiada rahsia dalam kod klien.
- [ ] Input disahkan di server.
- [ ] `qa-check.sh` lulus.
