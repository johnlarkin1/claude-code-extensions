---
description: This tool is a meta-tool to generate other tools in a clean and re-usable way.
allowed-tools: ["Bash", "Read", "Write"]
---

# Generate a New Slash Command

You are helping the user create a new Claude Code slash command.

## Gather Requirements

Ask the user the following questions one at a time:

1. **Command name**: What should the command be called? (e.g., `review-code`, `write-tests`, `explain`)
2. **Purpose**: What should this command do? What problem does it solve?
3. **Scope**: Should this be a user command (`~/.claude/commands/`) or project command (`./.claude/commands/`)?
4. **Arguments**: Should the command accept arguments via `$ARGUMENTS`? If so, what kind of input?
5. **Any special instructions**: Specific tone, output format, constraints, or behaviors?

## Generate the Command

Once you have the answers, create the slash command markdown file with:

- A clear, concise system prompt
- Well-structured instructions for Claude
- `$ARGUMENTS` placeholder if the command accepts input
- Any relevant examples or constraints

Save the file to the appropriate commands directory based on the user's scope choice.

## Template Reference

A typical slash command looks like:
```
# Command Title

Brief description of what this command does.

## Instructions

- Specific instruction 1
- Specific instruction 2

## Input

$ARGUMENTS
```

---

Start by asking: "What would you like your new slash command to do?"
