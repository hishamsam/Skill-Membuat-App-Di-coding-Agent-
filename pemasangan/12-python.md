# Stack J — FastAPI / Django + Postgres

Sesuai: API Python, data science, admin Django.

## Pilih satu

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

Jalan:

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

Jalan:

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

## Ujian tempatan

```bash
bash skrip/test-local.sh <slug> --check
```

## Deploy VPS/Dokploy

1. Tambah `Dockerfile` Python atau gunakan buildpack Python Dokploy.
2. Tetapkan env var di Dokploy.
3. Jalankan migrasi: `alembic upgrade head` atau `python manage.py migrate`.
4. Uji `/api/health` atau `/admin/`.

## Semakan

- [ ] `DEBUG=false` di production.
- [ ] Tiada `DATABASE_URL` dalam kod klien.
- [ ] Validation di server.
- [ ] `qa-check.sh` lulus.
