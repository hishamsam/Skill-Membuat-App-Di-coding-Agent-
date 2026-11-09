# 06 — Firebase

## MCP

Firebase menyediakan MCP melalui Firebase CLI:

```bash
npx -y firebase-tools@latest login
npx -y firebase-tools@latest mcp
```

Daftar dalam OpenCode:

```bash
opencode mcp add firebase --global -- \
  npx -y firebase-tools@latest mcp
```

Server ini membolehkan agent mengurus projek, Firestore, Auth, Hosting, dan
membaca dokumentasi Firebase.

## Projek

```bash
npx firebase-tools@latest login
npx firebase-tools@latest projects:list
npx firebase-tools@latest use <project-id>
```

## Struktur projek

```text
projek/<slug>/app/
├── public/index.html
├── firebase.json
├── .firebaserc
├── firestore.rules
└── firestore.indexes.json
```

`firebase.json` asas:

```json
{
  "hosting": {
    "public": "public",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [{ "source": "**", "destination": "/index.html" }]
  },
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "emulators": {
    "auth": { "port": 9099 },
    "firestore": { "port": 8080 },
    "hosting": { "port": 5000 },
    "ui": { "enabled": true, "port": 4000 }
  }
}
```

## Ujian tempatan

Java 17 tersedia pada mesin ini.

```bash
cd projek/<slug>/app
npx firebase-tools emulators:start
```

Aplikasi mesti menyambung ke emulator dalam mod ujian sahaja:

```js
import { connectAuthEmulator } from "firebase/auth";
import { connectFirestoreEmulator } from "firebase/firestore";

if (location.hostname === "localhost") {
  connectAuthEmulator(auth, "http://localhost:9099");
  connectFirestoreEmulator(db, "localhost", 8080);
}
```

Jalankan ujian automatik:

```bash
npx firebase-tools emulators:exec --only firestore,auth "./tests/smoke.sh"
```

## Rules

- Setiap koleksi mesti ada peraturan baca/tulis.
- Uji kes negatif: pengguna tanpa kebenaran mesti ditolak.
- Jangan gunakan `allow read, write: if true`.

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /items/{id} {
      allow read: if request.auth != null;
      allow write: if request.auth != null
                   && request.auth.uid == request.resource.data.ownerId;
    }
  }
}
```

## Deploy

```bash
npx firebase-tools deploy --only hosting,firestore:rules,firestore:indexes
```

## Had

- Kos baca/tulis Firestore meningkat dengan penggunaan.
- Model dokumen berbeza daripada SQL; rancang koleksi dalam PRD.
- Vendor lock-in tinggi.
