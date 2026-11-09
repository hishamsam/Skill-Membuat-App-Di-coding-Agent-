# 01 — Daftar MCP dalam OpenCode

Fail config: `~/.config/opencode/opencode.json`

## Format

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "nama-server": {
      "type": "local",
      "command": ["/usr/bin/figcraft-cli", "mcp"],
      "enabled": true
    },
    "nama-remote": {
      "type": "remote",
      "url": "https://contoh.com/mcp",
      "enabled": true,
      "headers": {
        "Authorization": "Bearer {file:~/.secrets/token}"
      }
    }
  }
}
```

Peraturan:

- `local`: `command` ialah array; elemen pertama fail boleh laku.
- `remote`: `url` mesti berakhir dengan `/mcp` atau `/sse` ikut penyedia.
- `enabled: false` = didaftar tetapi tidak dimuatkan.
- Token guna `{file:...}`. Jangan tulis token dalam fail config.
- Selepas ubah config, tutup dan buka semula OpenCode.

## Daftar server

Edit `opencode.json`, tambah blok daripada
`pemasangan/mcp.opencode.example.json`. Contoh FigCraft:

```json
"figcraft": {
  "type": "local",
  "command": ["/usr/bin/figcraft-cli", "mcp"],
  "enabled": true
},
"figcraft-app": {
  "type": "local",
  "command": ["/usr/bin/figcraft-cli", "mcp", "--attach", "7979"],
  "enabled": true
}
```

## Semak

```bash
opencode mcp list
```

Atau dalam sesi OpenCode, lihat senarai tool MCP. Jika server tidak muncul:

1. Pastikan JSON sah: `python3 -m json.tool ~/.config/opencode/opencode.json`.
2. Pastikan `command` wujud: `which figcraft-cli`.
3. Tutup semua sesi OpenCode, buka semula.
4. Untuk server remote, uji URL dengan `curl -I`.

## Tambah melalui CLI

```bash
# Server local
opencode mcp add figcraft --global -- /usr/bin/figcraft-cli mcp

# Server remote (OAuth)
opencode mcp add supabase --global --url "https://mcp.supabase.com/mcp?project_ref=<ref>"
opencode mcp auth supabase

# Server remote (token dalam header)
opencode mcp add neon --global --url "https://mcp.neon.tech/mcp" \
  --header "Authorization=Bearer <token>"
```

Semak semula dengan `opencode mcp list`. Command `add` menulis ke config
projek secara lalai; `--global` menulis ke `~/.config/opencode/opencode.json`.

## Keselamatan

- Server MCP boleh baca/tulis projek. Aktifkan hanya yang perlu.
- Untuk projek produksi, skop server ke satu projek dan mod read-only.
- Jangan simpan config yang mengandungi token dalam repo projek.
