# VS Code + Claude Code in a Docker Sandbox

[![kind: sandbox](https://img.shields.io/badge/kind-sandbox-blue)](https://docs.docker.com/ai/sandboxes/customize/kits/)
[![Docker Sandboxes](https://img.shields.io/badge/Docker-Sandboxes-2496ED?logo=docker&logoColor=white)](https://docs.docker.com/ai/sandboxes/)
[![Claude Code](https://img.shields.io/badge/Claude-Code-D97757)](https://www.anthropic.com/claude-code)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-green.svg)](LICENSE)

Run **VS Code** with the **Claude Code** extension inside an isolated [Docker Sandbox](https://docs.docker.com/ai/sandboxes/), and open it from your browser or desktop VS Code over a tunnel. Nothing touches your host.

## Quick start

```bash
# 1. Install sbx and sign in  →  https://docs.docker.com/ai/sandboxes/get-started/
sbx login

# 2. Set your Anthropic API key (used for the sandbox's network auth)
export ANTHROPIC_API_KEY=sk-ant-...

# 3. Launch — pulls the kit + image automatically, no clone needed
sbx run claude-vscode . --kit docker.io/ajeetraina777/sbx-vscode-kit:latest
```

Then:

1. Open the **https://github.com/login/device** link it prints and enter the code.
2. Open the **`https://vscode.dev/tunnel/…`** URL — or attach from desktop VS Code with the [Remote - Tunnels](https://marketplace.visualstudio.com/items?itemName=ms-vscode.remote-server) extension.

Claude Code is already installed — sign in with your Claude account and start building. 🎉

```
 sbx run claude-vscode ~/proj --name claude-vscode-v2 --kit docker.io/ajeetraina777/sbx-vscode-kit:latest
Creating new sandbox 'claude-vscode-v2'...

This kit wants to use these credentials:
  anthropic    API key → sent to api.anthropic.com   (not set)
[A]pprove all · [R]eview each · [N]o: A
  ✓ Binding saved to /Users/ajeetraina/.config/sbx/credentials.yaml
e818f689a961: Already exists 
857c2f588d1f: Already exists 
55317001df85: Already exists 
f2d056c3259b: Already exists 
da3db32c16db: Download complete 
027e0e2c3b62: Download complete 
4db8a5dbebf4: Download complete 
649b28d1298a: Download complete 
7dcc7d82c6fe: Download complete 
Digest: sha256:da3db32c16db777724b7676532f005ab50484700177be0c0ed2517334f0591b0
Status: Downloaded newer image for ajeetraina777/sbx-vscode:latest
To re-attach to this sandbox later, run:
  sbx run --kit docker.io/ajeetraina777/sbx-vscode-kit:latest --name claude-vscode-v2

Starting claude-vscode agent in sandbox 'claude-vscode-v2'...
Workspace: /Users/ajeetraina/proj

*
* Visual Studio Code Server
*
* By using the software, you agree to
* the Visual Studio Code Server License Terms (https://aka.ms/vscode-server-license) and
* the Microsoft Privacy Statement (https://privacy.microsoft.com/en-US/privacystatement).
*
[2026-07-05 19:55:46] info Using GitHub for authentication, run `code tunnel user login --provider <provider>` option to change this.
To grant access to the server, please log into https://github.com/login/device and use code XXXX-XXXX
[2026-07-05 19:56:22] info Creating tunnel with the name: claude-vscode-v2

  Visual Studio Code Tunnel v1.127.0

  ➜  Tunnel:   claude-vscode-v2
  ➜  Open:  https://vscode.dev/tunnel/claude-vscode-v2/Users/ajeetraina/proj

[2026-07-05 19:56:30] info No agent host supervisor running; starting one in the background
[2026-07-05 19:57:02] info [tunnels::connections::relay_tunnel_host] Opened new client on channel 2
[2026-07-05 19:57:02] info [russh::server] wrote id
[2026-07-05 19:57:02] info [russh::server] read other id
[2026-07-05 19:57:02] info [russh::server] session is running
[2026-07-05 19:57:40] info [rpc.0] Checking /home/agent/.vscode/cli/servers/Stable-XXXXX/log.txt and /home/agent/.vscode/cli/servers/Stable-XXXXXX/pid.txt for a running server...
[2026-07-05 19:57:40] info [rpc.0] Starting server...
[2026-07-05 19:57:40] info [rpc.0] Server started
[2026-07-05 20:02:34] info [rpc.0] Forwarding port 13332 (public=false)
```

## What you get

- Full VS Code over a secure tunnel (browser **or** desktop)
- Claude Code extension pre-installed
- Isolated, firewalled sandbox
- Multi-arch image (amd64 + arm64)

## Prefer to clone?

```bash
git clone https://github.com/ajeetraina/sbx-kits-vscode
cd sbx-kits-vscode
./sbx-vscode ~/your/project      # helper: creates the sandbox + starts the tunnel
```

The `sbx-vscode` helper names the sandbox `claude-<dir>` and re-attaches if it already exists. Add `-d` to run detached.

## Troubleshooting

- **No device code appears** — the sandbox can't reach `github.com`; check `sbx login` succeeded.
- **`code: command not found`** — bad image build; re-pull `ajeetraina777/sbx-vscode:latest`.
- **Tunnel blocked by network policy** (`403 … Blocked by network policy`) — you're on a **governed** sbx setup; see below.

<details>
<summary><b>Governed environments</b> (corporate Docker Hub policy)</summary>

If `sbx policy ls` shows `Governance  Managed by <org>`, the org policy **overrides and deactivates all local rules** — including this kit's `caps.network.allow`. Confirm with `sbx policy ls --include-inactive` (the `kit:<sandbox>` rule shows `inactive — corporate policy takes precedence`).

The kit's allow-list then has no effect, so you must add the VS Code tunnel domains to the **Hub org network policy**:

```
**.tunnels.api.visualstudio.com:443     # tunnel relays + management API
vscode.dev:443
# needed if the VS Code server has to download on first connect:
update.code.visualstudio.com:443
vscode.download.prss.microsoft.com:443
main.vscode-cdn.net:443
```

Use the **double-star** `**.` for multi-level subdomains (a single `*.` won't match `global.rel.tunnels.api.visualstudio.com`). Then let it sync and restart:

```bash
sbx policy ls | grep -i visualstudio
sbx run --name <sandbox>
```

</details>

<details>
<summary><b>Build & publish it yourself</b></summary>

The kit references the image `ajeetraina777/sbx-vscode` and is published as an OCI artifact `ajeetraina777/sbx-vscode-kit`. To build/publish your own, see **[DOCKERHUB.md](DOCKERHUB.md)**. Validate the kit anytime with `sbx kit validate .`.

> `sbx --kit` needs the full registry host (`docker.io/…`) — a bare `ajeetraina777/…` reference fails with `dial tcp: lookup ajeetraina777: no such host`.

</details>

## Links

- Image: [`ajeetraina777/sbx-vscode`](https://hub.docker.com/r/ajeetraina777/sbx-vscode)
- Kit artifact: `docker.io/ajeetraina777/sbx-vscode-kit:latest`
- Docker Sandboxes docs: <https://docs.docker.com/ai/sandboxes/>
