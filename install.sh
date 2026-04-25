#!/bin/bash

SKILL_DIR="$HOME/.claude/skills/cross-platform-align"
SKILL_FILE="skills/cross-platform-align/SKILL.md"

if [ ! -f "$SKILL_FILE" ]; then
    echo "Error: SKILL.md not found. Make sure you run this script from the repo root."
    exit 1
fi

mkdir -p "$SKILL_DIR"
cp "$SKILL_FILE" "$SKILL_DIR/SKILL.md"

echo "Done! Skill 'cross-platform-align' installed at $SKILL_DIR"
echo "Restart Claude Code or run /reload-plugins to activate."
