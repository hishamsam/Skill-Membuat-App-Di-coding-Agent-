# 12 — Stack J: FastAPI / Django + Postgres

Suitable for: Python API, data science, Django admin.

## Choose one

### FastAPI

```bash
cd projek/<slug>/app
python3 -m venv .venv
source .venv/bin/activate
pip install fastapi uvicorn psycopg[binary] sqlalchemy alembic python-dotenv
```

```text
app/
├── main.py
├── models.py
├── db.py
├── requirements.txt
└── .env.example
```

Run:

```bash
python3 -m uvicorn main:app --host 127.0.0.1 --port 4173
```

### Django

```bash
cd projek/<slug>/app
python3 -m venv .venv
source .venv/bin/activate
pip install django psycopg[binary] python-dotenv
django-admin startproject config .
python3 manage.py startapp core
```

Run:

```bash
python3 manage.py migrate
python3 manage.py runserver 127.0.0.1:4173
```

## Postgres

```env
DATABASE_URL="postgres://..."
SECRET_KEY="..."
DEBUG=false
```

## Local testing

```bash
bash skrip/test-local.sh <slug> --check
```

## VPS/Dokploy deploy

1. Add a Python `Dockerfile` or use the Dokploy Python buildpack.
2. Set the env vars in Dokploy.
3. Run the migration: `alembic upgrade head` or `python manage.py migrate`.
4. Test `/api/health` or `/admin/`.

## Checks

- [ ] `DEBUG=false` in production.
- [ ] No `DATABASE_URL` in client code.
- [ ] Validation on the server.
- [ ] `qa-check.sh` passes.
