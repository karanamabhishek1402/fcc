# free-claude-code skill

A Claude Code skill that installs, configures, runs and troubleshoots
[Free Claude Code](https://github.com/Alishahryar1/free-claude-code).

## Install (one line)

macOS / Linux / WSL:
```bash
curl -fsSL https://raw.githubusercontent.com/karanamabhishek1402/fcc/main/install.sh | sh
```

Windows PowerShell:
```powershell
$d="$HOME\.claude\skills\free-claude-code"; mkdir $d -Force | Out-Null; irm https://raw.githubusercontent.com/karanamabhishek1402/fcc/main/skills/free-claude-code/SKILL.md -OutFile "$d\SKILL.md"
```

Or with the skills CLI: `npx skills add karanamabhishek1402/fcc`

Then restart Claude Code and say "set up free claude code" (or `/free-claude-code`).
