# VS Code + Claude Code extension, layered on Docker's Claude Code sandbox base.
FROM docker.io/docker/sandbox-templates:claude-code-docker

USER root

# Install the full VS Code build. This provides the `code` CLI that the kit's
# entrypoint uses to start a tunnel (`code tunnel`).
RUN curl -Lo vscode.deb 'https://go.microsoft.com/fwlink/?LinkID=760868' && \
    apt-get update && \
    apt-get install --yes ./vscode.deb && \
    rm ./vscode.deb && \
    rm -rf /var/lib/apt/lists/*

USER agent

# Pre-install the Claude Code VS Code extension into the tunnel server's
# extension directory so it's available the moment you connect.
RUN code --extensions-dir ~/.vscode-server/extensions/ \
         --install-extension anthropic.claude-code
