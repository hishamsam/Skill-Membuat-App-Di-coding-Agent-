# 11 — Stack I: Laravel + MySQL

Suitable for: PHP projects, admin panels, ordinary hosting or VPS/Dokploy.

## Prerequisites

```bash
php -v          # PHP 8.2+
composer -V
mysql --version
```

## Create a project

```bash
cd projects/<slug>/app
composer create-project laravel/laravel .
```

If the folder has files, create it in a temporary folder then copy.

## Database

```bash
cp .env.example .env
php artisan key:generate
```

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=<name>
DB_USERNAME=<user>
DB_PASSWORD=<password>
```

```bash
php artisan migrate
```

## Local testing

```bash
cd projects/<slug>/app
php artisan serve --host=127.0.0.1 --port=4173
```

Or:

```bash
bash scripts/test-local.sh <slug> --check
```

## VPS/Dokploy deploy

1. Set the document root to `public/`.
2. Set the production env in Dokploy.
3. Run `php artisan migrate --force`.
4. `php artisan config:cache` and `route:cache`.

## Checks

- [ ] `APP_DEBUG=false` in production.
- [ ] `.env` is not committed.
- [ ] Validation in Form Request, not only on the client.
- [ ] `qa-check.sh` passes.
