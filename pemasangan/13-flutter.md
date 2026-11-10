# 13 — Stack K: Flutter (Web + Android/iOS)

Suitable for: a single Dart codebase for responsive web 360–1920 and Android/iOS
apps. The backend is chosen from B (Supabase), D (Firebase), E (Neon API), or
your own REST/Worker. The automated test surface is **web**; Android/iOS are
built from the same code and tested manually.

## Prerequisites

```bash
flutter --version
flutter doctor
```

- Flutter SDK 3.24 or newer.
- Chrome for `flutter run -d chrome`.
- Android SDK + emulator/device for `flutter build appbundle`.
- iOS requires macOS + Xcode for `flutter build ipa`.

Note: the Flutter SDK is not available on this machine. Install it following
`https://docs.flutter.dev/get-started/install`, then run
`bash skrip/preflight.sh` to confirm `flutter` is detected. Preflight only
reports `flutter`; the SDK must be installed manually.

## Create a project

```bash
cd projek/<slug>/app
flutter create --project-name <slug_dart> --platforms web,android,ios .
flutter config --enable-web
```

`<slug_dart>` is the slug with `-` and `.` replaced by `_`; for example
`grocery-shop` becomes `grocery_shop`.

## Backend

### Supabase

```bash
cd projek/<slug>/app
flutter pub add supabase_flutter
```

```dart
await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
```

The anon key is the client's public key and is allowed. The `service_role` key
must NOT go into Dart.

### Firebase

```bash
cd projek/<slug>/app
flutter pub add firebase_core cloud_firestore firebase_auth
dart pub global activate flutterfire_cli
flutterfire configure
```

### REST / Neon API

```bash
cd projek/<slug>/app
flutter pub add http
```

```bash
flutter run -d chrome --dart-define=API_URL=http://127.0.0.1:8787
```

Do not keep server secrets in Dart or in `--dart-define` values sent to the
client.

## Local testing

```bash
cd projek/<slug>/app
flutter test
flutter run -d chrome --web-port 4173
```

```bash
bash skrip/test-local.sh <slug> --check
```

`--check` runs `flutter build web --release`, serves `build/web`, and confirms
HTTP 200.

## Deploy

```bash
cd projek/<slug>/app
flutter build web
```

1. Upload `build/web` to Vercel, Cloudflare Pages, or Firebase Hosting.
2. Android: `flutter build appbundle` → upload `build/app/outputs/bundle/release/app-release.aab`.
3. iOS: `flutter build ipa` (requires macOS) → upload via Transporter/Xcode.

Do not deploy `build/web` from a debug build.

## Checks

- [ ] `flutter analyze` passes.
- [ ] `flutter test` passes.
- [ ] `flutter build web` passes.
- [ ] Responsiveness checked at 360, 390, 768, 1024, 1440.
- [ ] No dark theme (`ThemeMode.light` only).
- [ ] No server key (`service_role`) in the Dart code.
- [ ] `bash skrip/qa-check.sh <slug>` passes.

## Common problems

| Symptom | Solution |
| --- | --- |
| `flutter: command not found` | The SDK is not on PATH; install the SDK and add `flutter/bin` to PATH |
| `Web support is not enabled` | Run `flutter config --enable-web` |
| `Target dart2js failed` | `flutter clean` then `flutter pub get`, repeat the build |
