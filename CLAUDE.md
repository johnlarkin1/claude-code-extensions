# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a collection of Claude Code extensions, including custom CLI tools, skills, and commands. The repository serves as both a personal configuration and a reference implementation for extending Claude Code capabilities.

## Project Structure

- **cli-tools/claude-extended-flags/**: Shell wrapper that adds `--status`, `--usage`, and `--config` flags to the Claude CLI (macOS only, uses Keychain for OAuth)
- **skills/**: Custom skills with SKILL.md files and reference documentation (tauri, textual, excalidraw, manim)
- **commands/**: User-invokable slash commands (create-pr, generate-pr, generate-command, list-skills)
- **claude-docs/**: Reference documentation for plugin/skill development
- **settings.json**: Project-level Claude Code settings with enabled plugins

## CLI Tool Installation

```bash
cd cli-tools/claude-extended-flags
./install.sh      # Installs wrapper to ~/.local/bin and configures shell
./uninstall.sh    # Removes wrapper and shell configuration
```

Dependencies: `jq`, `curl`, `claude` CLI

## Skills Structure

Skills follow this pattern:
- `skills/<name>/SKILL.md` - Main skill instructions
- `skills/<name>/references/*.md` - Reference documentation
- `skills/<name>.skill` - Alternative single-file format

## Key Architecture Notes

The claude-wrapper in cli-tools intercepts `claude` commands and handles extended flags (`--status`, `--usage`, `--config`) via direct API calls to `api.anthropic.com/api/oauth`, falling through to the real Claude binary for all other commands. It reads OAuth tokens from macOS Keychain and local config from `~/.claude/settings.json`.
