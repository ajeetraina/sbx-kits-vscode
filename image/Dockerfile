# VS Code + Claude Code extension, layered on Docker's Claude Code sandbox base.
FROM docker.io/docker/sandbox-templates:claude-code-docker

USER root

# `docker buildx` sets TARGETARCH per platform (amd64 / arm64). Map it to VS
# Code's download slug and pull the matching .deb so the image builds correctly
# for both linux/amd64 and linux/arm64.
ARG TARGETARCH

# Install the full VS Code build. This provides the `code` CLI that the kit's
# entrypoint uses to start a tunnel (`code tunnel`).
RUN case "$TARGETARCH" in \
      amd64) VSARCH=x64 ;; \
      arm64) VSARCH=arm64 ;; \
      *) echo "unsupported TARGETARCH: $TARGETARCH" >&2; exit 1 ;; \
    esac && \
    curl -fSL -o vscode.deb "https://update.code.visualstudio.com/latest/linux-deb-${VSARCH}/stable" && \
    apt-get update && \
    apt-get install --yes ./vscode.deb && \
    rm ./vscode.deb && \
    rm -rf /var/lib/apt/lists/*

USER agent

# Pre-install the Claude Code VS Code extension into the tunnel server's
# extension directory so it's available the moment you connect.
RUN code --extensions-dir ~/.vscode-server/extensions/ \
         --install-extension anthropic.claude-code
