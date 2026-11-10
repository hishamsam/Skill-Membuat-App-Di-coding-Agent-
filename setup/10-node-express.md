# 10 — Stack H: Node/Express + Postgres

Suitable for: custom API, full control, VPS/Dokploy deploy.

## Create a project

```bash
cd projects/<slug>/app
npm init -y
npm i express pg dotenv
npm i -D nodemon
```

Suggested structure:

```text
projects/<slug>/app/
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

## Local testing

```bash
cd projects/<slug>/app
npm install
npm run dev
```

Or:

```bash
bash scripts/test-local.sh <slug> --check
```

## VPS/Dokploy deploy

1. Add a `Dockerfile` or use the Dokploy Node buildpack.
2. Set the env vars in Dokploy.
3. Deploy + run the DB migration.
4. Test `/api/health`.

## Checks

- [ ] Auth and authorisation on the server.
- [ ] No secrets in client code.
- [ ] Input validated on the server.
- [ ] `qa-check.sh` passes.
