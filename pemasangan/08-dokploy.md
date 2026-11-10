# Dokploy for Local Testing (Optional)

Dokploy is a self-hosted deployment platform that uses Docker + Traefik.
In this repo, Dokploy is used as a local/dev test environment
**only if the user permits it**.

## Rules

1. The agent must ask the user's permission before installing Dokploy.
2. If the user declines, **skip** it and run manual testing:
   `bash skrip/test-local.sh <slug> --check`.
3. Do not install Dokploy on a production machine.
4. Do not keep `DOKPLOY_API_KEY` in the repo.

## Check status

```bash
bash skrip/setup-dokploy.sh --check
```

## Install with permission

```bash
bash skrip/setup-dokploy.sh           # asks y/N first
sudo bash skrip/setup-dokploy.sh --yes  # passes without a prompt, root required
```

The script installs Docker if missing, then runs the official script:

```bash
curl -sSL https://dokploy.com/install.sh | sh
```

Requirements:

- Linux (not a container).
- Root access.
- Ports 80, 443, and 3000 free.
- A dev/VPS machine, not production.

After installing:

1. Open `http://localhost:3000`.
2. Create the first admin account.
3. Set the environment (do not commit):

```bash
export DOKPLOY_URL="http://localhost:3000"
export DOKPLOY_API_KEY="<key-from-settings>"
```

4. Optional: register the Dokploy MCP in `opencode.json`:

```json
{
  "mcp": {
    "dokploy": {
      "type": "local",
      "command": ["npx", "-y", "@dokploy/mcp"],
      "environment": {
        "DOKPLOY_URL": "http://localhost:3000",
        "DOKPLOY_API_KEY": "<key>"
      }
    }
  }
}
```

## If declined or it fails

No problem. Local testing runs without Dokploy:

```bash
bash skrip/test-local.sh <slug> --check
bash skrip/qa-check.sh <slug>
```

Production deployment remains separate and requires permission.
