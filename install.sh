#!/bin/sh
# Installs the free-claude-code skill for Claude Code into ~/.claude/skills
set -e
REPO="${SKILL_REPO:-karanamabhishek1402/free-claude-code-skill}"
DEST="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/free-claude-code"
mkdir -p "$DEST"
curl -fsSL "https://raw.githubusercontent.com/$REPO/main/skills/free-claude-code/SKILL.md" -o "$DEST/SKILL.md"
echo "Installed free-claude-code skill to $DEST — restart Claude Code, then ask it to 'set up free claude code'."
