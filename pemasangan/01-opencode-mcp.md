# 01 — Registering MCP in OpenCode

Config file: `~/.config/opencode/opencode.json`

## Format

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "server-name": {
      "type": "local",
      "command": ["/usr/bin/figcraft-cli", "mcp"],
      "enabled": true
    },
    "remote-name": {
      "type": "remote",
      "url": "https://example.com/mcp",
      "enabled": true,
      "headers": {
        "Authorization": "Bearer {file:~/.secrets/token}"
      }
    }
  }
}
```

Rules:

- `local`: `command` is an array; the first element is an executable file.
- `remote`: `url` must end with `/mcp` or `/sse` depending on the provider.
- `enabled: false` = registered but not loaded.
- Tokens use `{file:...}`. Do not write tokens in the config file.
- After changing the config, close and reopen OpenCode.

## Registering a server

Edit `opencode.json`, add a block from
`pemasangan/mcp.opencode.example.json`. FigCraft example:

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

## Checking

```bash
opencode mcp list
```

Or inside an OpenCode session, look at the MCP tool list. If a server does not
appear:

1. Make sure the JSON is valid: `python3 -m json.tool ~/.config/opencode/opencode.json`.
2. Make sure `command` exists: `which figcraft-cli`.
3. Close all OpenCode sessions, open them again.
4. For remote servers, test the URL with `curl -I`.

## Adding via CLI

```bash
# Local server
opencode mcp add figcraft --global -- /usr/bin/figcraft-cli mcp

# Remote server (OAuth)
opencode mcp add supabase --global --url "https://mcp.supabase.com/mcp?project_ref=<ref>"
opencode mcp auth supabase

# Remote server (token in header)
opencode mcp add neon --global --url "https://mcp.neon.tech/mcp" \
  --header "Authorization=Bearer <token>"
```

Check again with `opencode mcp list`. The `add` command writes to the project
config by default; `--global` writes to `~/.config/opencode/opencode.json`.

## Security

- MCP servers can read/write the project. Enable only the ones you need.
- For production projects, scope the server to a single project and read-only
  mode.
- Do not keep a config containing tokens in the project repo.
