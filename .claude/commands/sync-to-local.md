# Sync Extensions To Local

Sync Claude Code extensions from this repository to `~/.claude` to restore or update your local setup.

## What to Sync

Copy the following from this repo to `~/.claude`, overwriting existing files:

| Source | Destination |
|--------|-------------|
| `./commands/*` | `~/.claude/commands/` |
| `./skills/*` | `~/.claude/skills/` |
| `./settings.json` | `~/.claude/settings.json` |

## Instructions

1. **Sync commands**: Copy all files from `./commands/` to `~/.claude/commands/`
   - Preserve symlinks (copy as symlinks, not resolved files)
   - Overwrite existing files
   - Create `~/.claude/commands/` if it doesn't exist

2. **Sync skills**: Copy all skill folders and `.skill` files from `./skills/` to `~/.claude/skills/`
   - Copy entire directory structures (SKILL.md, references/, etc.)
   - Overwrite existing files/folders
   - Create `~/.claude/skills/` if it doesn't exist

3. **Sync settings**: Copy `./settings.json` to `~/.claude/settings.json`
   - Overwrite if exists
   - Skip if `./settings.json` doesn't exist in this repo

4. **Report results**: After syncing, show a summary of what was copied:
   - Number of commands synced
   - Number of skills synced
   - Whether settings.json was synced
   - Any errors encountered

## Notes

- This will overwrite your local `~/.claude` extensions with the repo versions
- Back up your local extensions first if you have unsaved changes (run `/sync-from-local`)
- User-created plugins live in separate repos and are not synced by this command

$ARGUMENTS
