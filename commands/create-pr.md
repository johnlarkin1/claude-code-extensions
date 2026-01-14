---
description: Review branch changes (including staged/uncommitted), generate commit message, and create PR using Claude Code template
allowed-tools: ["Bash", "Read", "Write"]
---

# Create PR from Branch Changes

## Step 1: Gather Context

!git fetch origin main 2>/dev/null || git fetch origin master 2>/dev/null

!git branch --show-current

## Step 2: Review All Changes (Excluding Lock Files)

Committed changes vs origin:
!git diff origin/main...HEAD -- . ':!uv.lock' ':!poetry.lock' ':!Cargo.lock' ':!package-lock.json' ':!yarn.lock' ':!pnpm-lock.yaml' ':!composer.lock' ':!Gemfile.lock' ':!bun.lockb' ':!go.sum' 2>/dev/null || git diff origin/master...HEAD -- . ':!uv.lock' ':!poetry.lock' ':!Cargo.lock' ':!package-lock.json' ':!yarn.lock' ':!pnpm-lock.yaml' ':!composer.lock' ':!Gemfile.lock' ':!bun.lockb' ':!go.sum'

Staged but uncommitted:
!git diff --cached -- . ':!uv.lock' ':!poetry.lock' ':!Cargo.lock' ':!package-lock.json' ':!yarn.lock' ':!pnpm-lock.yaml' ':!composer.lock' ':!Gemfile.lock' ':!bun.lockb' ':!go.sum'

Unstaged working directory changes:
!git diff -- . ':!uv.lock' ':!poetry.lock' ':!Cargo.lock' ':!package-lock.json' ':!yarn.lock' ':!pnpm-lock.yaml' ':!composer.lock' ':!Gemfile.lock' ':!bun.lockb' ':!go.sum'

Commit history on this branch:
!git log origin/main..HEAD --oneline 2>/dev/null || git log origin/master..HEAD --oneline

## Step 3: Read Claude Code PR Template

!cat .github/cc_pull_request_template.md

Use this template structure for the PR body.

## Step 4: Generate Commit Message and PR

Based on all changes above:
1. **Commit message** (conventional format) for any uncommitted work
2. **PR title** – concise summary
3. **PR body** – follow the template structure from Step 3

## Step 5: Execute (After Confirmation)

Present the generated content for approval, then:
1. `git add -A && git commit -m "<message>"` (if uncommitted changes exist)
2. `git push`
3. Write PR body to `/tmp/pr-body.md`, then `gh pr create --base main --title "<title>" --body-file /tmp/pr-body.md`

$ARGUMENTS
