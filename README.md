# sbx kits for VS Code

[![kind: sandbox](https://img.shields.io/badge/kind-sandbox-blue)](https://docs.docker.com/ai/sandboxes/customize/kits/)
[![Docker Sandboxes](https://img.shields.io/badge/Docker-Sandboxes-2496ED?logo=docker&logoColor=white)](https://docs.docker.com/ai/sandboxes/)
[![Claude Code](https://img.shields.io/badge/Claude-Code-D97757)](https://www.anthropic.com/claude-code)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-green.svg)](LICENSE)

A [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/) [Kit](https://docs.docker.com/ai/sandboxes/customize/kits/) (`kind: sandbox`) that runs **VS Code** with the **Claude Code** extension inside an isolated, firewalled sandbox and exposes it over a **VS Code tunnel** — so you can drive it from your local desktop VS Code (via **Remote - Tunnels**) or from `vscode.dev` in a browser.

Build agentic tasks in a throwaway sandbox, with a full editor, without touching your host.

## What the kit does

- Extends Docker's official `sandbox-templates:claude-code-docker` base image.
- Installs the full VS Code build (gives you the `code` CLI).
- Pre-installs the `anthropic.claude-code` VS Code extension.
- Starts `code tunnel` as the sandbox entrypoint.
- Wires your `ANTHROPIC_API_KEY` to `api.anthropic.com` (as `x-api-key`).
- Allow-lists only the VS Code CDN, tunnel relay, GitHub device-auth, and Claude domains through the sandbox firewall.

## Prerequisites

You need Docker Sandboxes and the `sbx` CLI installed — see [Getting started](https://docs.docker.com/ai/sandboxes/get-started/).

```bash
# Sign in to Docker (required for sbx)
sbx login
```

A **GitHub account** is required to authenticate the VS Code tunnel. An **Anthropic API key** (`ANTHROPIC_API_KEY`) is used for network auth to the Anthropic API; the Claude Code extension itself signs you in with your Claude account on first use.

## Install

Clone the kit:

```bash
git clone https://github.com/ajeetraina/sbx-kits-vscode /path/to/sbx-kits-vscode
```

Optionally link the helper script onto your `$PATH`:

```bash
ln -s /path/to/sbx-kits-vscode/sbx-vscode /usr/local/bin/sbx-vscode
```

## Usage

### Quick start (helper script)

Create a sandbox and start a tunnel in the **current** directory:

```bash
sbx-vscode
```

...or in a specific project directory:

```bash
sbx-vscode /path/to/project
```

Run it detached (create in the background, don't attach):

```bash
sbx-vscode -d /path/to/project
```

The helper names the sandbox `claude-<project-dir>` and re-attaches if it already exists.

### Manual (without the helper)

Apply the kit to a new sandbox:

```bash
sbx run claude . --kit /path/to/sbx-kits-vscode
```

...or add it to an already-running sandbox:

```bash
sbx kit add my-sandbox /path/to/sbx-kits-vscode
```

## Connecting to the tunnel

After the sandbox starts you'll see a GitHub device-login prompt:

```
To grant access to the server, please log into
https://github.com/login/device and use code XXXX-XXXX
```

Open <https://github.com/login/device>, enter the code, and the tunnel comes up:

```
  Visual Studio Code Tunnel

  ➜  Tunnel:   claude-xxxx
  ➜  Open:  https://vscode.dev/tunnel/claude-xxxx/...
```

Then connect either way:

- **Browser** — open the `https://vscode.dev/tunnel/...` URL.
- **Desktop VS Code** — install the [Remote - Tunnels](https://marketplace.visualstudio.com/items?itemName=ms-vscode.remote-server) extension, open the **Remote Explorer** sidebar, sign in with the same GitHub account, and open your tunnel.

The Claude Code extension is already installed on the server. The first time you use it in a fresh sandbox, sign in with your Claude account.

## How it works

| File | Purpose |
|------|---------|
| [`spec.yaml`](spec.yaml) | The kit manifest — image, `code tunnel` entrypoint, network allow-list, and Anthropic credential wiring. |
| [`image/Dockerfile`](image/Dockerfile) | Builds the sandbox image: base + VS Code + Claude Code extension. |
| [`sbx-vscode`](sbx-vscode) | Convenience wrapper around `sbx run` for naming, re-attaching, and detached mode. |

## Building the image

The kit references `ajeetraina777/sbx-vscode`. To build and publish your own:

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t ajeetraina777/sbx-vscode:latest \
  --push \
  image/
```

CI (`.github/workflows/build.yml`) does this automatically on push to `main`. See [DOCKERHUB.md](DOCKERHUB.md) for the publishing setup.

Validate the kit manifest at any time:

```bash
sbx kit validate .
```

## Troubleshooting

- **Tunnel never prints a device code** — the sandbox couldn't reach `github.com`. Confirm the allow-list in `spec.yaml` and that `sbx login` succeeded.
- **`code: command not found`** — the image didn't build the VS Code `.deb`; rebuild `image/Dockerfile`.
- **Claude Code asks for login every time** — expected on a freshly-created sandbox; state lives inside the container.

## License

[Apache-2.0](LICENSE) © Ajeet Singh Raina

## Acknowledgements

Inspired by [`TriticeaeToolbox/sbx-vscode`](https://github.com/TriticeaeToolbox/sbx-vscode) and Docker's [`sbx-kits-contrib`](https://github.com/docker/sbx-kits-contrib).
