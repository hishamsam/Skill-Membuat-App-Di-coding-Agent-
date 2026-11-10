# 06 — Firebase

## MCP

Firebase provides MCP through the Firebase CLI:

```bash
npx -y firebase-tools@latest login
npx -y firebase-tools@latest mcp
```

Register in OpenCode:

```bash
opencode mcp add firebase --global -- \
  npx -y firebase-tools@latest mcp
```

This server lets the agent manage projects, Firestore, Auth, Hosting, and read
the Firebase documentation.

## Project

```bash
npx firebase-tools@latest login
npx firebase-tools@latest projects:list
npx firebase-tools@latest use <project-id>
```

## Project structure

```text
projek/<slug>/app/
├── public/index.html
├── firebase.json
├── .firebaserc
├── firestore.rules
└── firestore.indexes.json
```

Basic `firebase.json`:

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

## Local testing

Java 17 is available on this machine.

```bash
cd projek/<slug>/app
npx firebase-tools emulators:start
```

The application must connect to the emulator in test mode only:

```js
import { connectAuthEmulator } from "firebase/auth";
import { connectFirestoreEmulator } from "firebase/firestore";

if (location.hostname === "localhost") {
  connectAuthEmulator(auth, "http://localhost:9099");
  connectFirestoreEmulator(db, "localhost", 8080);
}
```

Run the automated test:

```bash
npx firebase-tools emulators:exec --only firestore,auth "./tests/smoke.sh"
```

## Rules

- Every collection must have read/write rules.
- Test negative cases: a user without permission must be rejected.
- Do not use `allow read, write: if true`.

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

## Limits

- Firestore read/write costs grow with usage.
- The document model differs from SQL; plan collections in the PRD.
- High vendor lock-in.
