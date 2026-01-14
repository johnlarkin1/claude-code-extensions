---
description: List all installed skills and plugins
allowed-tools: ["Bash", "Read"]
---

List all available Claude Code skills and plugins.

## Installed Skills
!ls -1 ~/.claude/skills 2>/dev/null || echo "No skills directory found"

## Installed Plugins  
!cat ~/.claude/plugins/installed_plugins.json 2>/dev/null || echo "No plugins installed"

For each skill found in ~/.claude/skills/, read its SKILL.md or README.md file to provide a brief description of what it does.

Format the output as a clean, readable list with:
- Skill/plugin name
- Brief description of its purpose
- How to invoke it (if applicable)
