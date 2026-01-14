# Sync Extensions From Local

Sync Claude Code extensions from `~/.claude` into this repository for version control and backup.

## What to Sync

Copy the following from `~/.claude` to this repo, overwriting existing files:

| Source | Destination |
|--------|-------------|
| `~/.claude/commands/*` | `./commands/` |
| `~/.claude/skills/*` | `./skills/` |
| `~/.claude/settings.json` | `./settings.json` |

## Instructions

1. **Sync commands**: Copy all files from `~/.claude/commands/` to `./commands/`
   - Preserve symlinks (copy as symlinks, not resolved files)
   - Overwrite existing files

2. **Sync skills**: Copy all skill folders and `.skill` files from `~/.claude/skills/` to `./skills/`
   - Copy entire directory structures (SKILL.md, references/, etc.)
   - Overwrite existing files/folders

3. **Sync settings**: Copy `~/.claude/settings.json` to `./settings.json`
   - Overwrite if exists

4. **Report results**: After syncing, show a summary of what was copied:
   - Number of commands synced
   - Number of skills synced
   - Whether settings.json was synced
   - Any errors encountered

## Notes

- Do NOT sync `~/.claude/plugins/` - that's marketplace cache, not user content
- Do NOT sync ephemeral data (plans/, debug/, todos/, history.jsonl, etc.)
- User-created plugins live in separate repos, not in `~/.claude`

$ARGUMENTS
