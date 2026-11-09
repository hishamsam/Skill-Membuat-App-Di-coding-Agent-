# Stack I — Laravel + MySQL

Sesuai: projek PHP, admin panel, hosting biasa atau VPS/Dokploy.

## Prasyarat

```bash
php -v          # PHP 8.2+
composer -V
mysql --version
```

## Cipta projek

```bash
cd projek/<slug>/app
composer create-project laravel/laravel . 
```

Jika folder ada fail, cipta dalam folder sementara kemudian salin.

## Pangkalan data

```bash
cp .env.example .env
php artisan key:generate
```

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=<nama>
DB_USERNAME=<user>
DB_PASSWORD=<kata-laluan>
```

```bash
php artisan migrate
```

## Ujian tempatan

```bash
cd projek/<slug>/app
php artisan serve --host=127.0.0.1 --port=4173
```

Atau:

```bash
bash skrip/test-local.sh <slug> --check
```

## Deploy VPS/Dokploy

1. Tetapkan document root ke `public/`.
2. Tetapkan env production di Dokploy.
3. Jalankan `php artisan migrate --force`.
4. `php artisan config:cache` dan `route:cache`.

## Semakan

- [ ] `APP_DEBUG=false` di production.
- [ ] `.env` tidak di-commit.
- [ ] Validation di Form Request, bukan hanya klien.
- [ ] `qa-check.sh` lulus.
