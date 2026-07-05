# VHS tape for the README demo GIF — reenacts the real `sbx` tunnel flow.
# Regenerate with:  vhs docs/demo.tape
Output docs/demo.gif

Set Shell "bash"
Set FontSize 20
Set Width 1120
Set Height 640
Set Padding 26
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source /tmp/demo-sbx.sh" Enter
Type "clear" Enter
Show

Sleep 600ms
Type "# 1) peek at the kit" Sleep 250ms Enter
Type "sbx kit inspect docker.io/ajeetraina777/sbx-vscode-kit:latest" Sleep 250ms Enter
Sleep 2s

Type "# 2) launch VS Code + Claude Code and get a tunnel" Sleep 250ms Enter
Type "sbx run claude-vscode ~/proj --kit docker.io/ajeetraina777/sbx-vscode-kit:latest" Sleep 250ms Enter
Sleep 8s

Type "# open the vscode.dev URL, or attach with Remote - Tunnels" Sleep 250ms Enter
Sleep 2500ms
