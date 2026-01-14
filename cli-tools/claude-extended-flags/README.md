# claude-extended-flags

> [!IMPORTANT]  
> Only tested on MacOS M4 with Claude Code `2.0.76`
> in `zshrc` as of 2026-01-12

This was driving me up a freaking wall.

I'm not sure why Anthropic can't just quickly add this. I cannot imagine it's that hard, but maybe there's some security element I'm missing...

regardless, this provides some quick scripting and basically re-wraps `claude` with a `claude-wrapper` that is basically a pass through minus a couple things.

`claude-wrapper` lets you specify:

- `claude --status`
- `claude --config`
- `claude --usage`

I want to check my usage without firing up a claude process just for the API call.

> [!NOTE]  
> I used CLaude to write these `.sh` scripts given it's a better programmer than me, so feel free to dig in at your own level.

Really meant to address this:

- https://github.com/anthropics/claude-code/issues/1886

## installation

I would probably just `git clone` this repo and then `./install.sh` but feel free to clone and ask Claude how to set it up.

## examples

```bash
╭─johnlarkin@Mac ~/Documents/coding
╰─➤  claude --usage
error: unknown option '--usage'

╭─johnlarkin@Mac ~/Documents/coding
╰─➤  source ~/.zshrc

╭─johnlarkin@Mac ~/Documents/coding
╰─➤  claude --usage

 Current session
 ████████████████████████████                       56% used
 Resets Jan 13 at 12AM (EST)

 Current week (all models)
 ███████████████                                    30% used
 Resets Jan 15 at 8AM (EST)

 Current week (Sonnet only)
                                                    0% used
 Resets not enabled

 ○ Extra usage not enabled


╭─johnlarkin@Mac ~/Documents/coding
╰─➤  claude --status

 Version: 2.0.76
 Session ID: d9010208-8551-4ce7-bfb4-f8ae885ef8bd
 cwd: /Users/johnlarkin/Documents/coding
 Login method: Claude Max Account
 Organization: John
 Email: <redacted>

 Model: Default (Opus 4.5)
 MCP servers: 21 enabled
 Memory: none
 Setting sources: User,settings


╭─johnlarkin@Mac ~/Documents/coding
╰─➤  claude --config

 Claude Code Settings (from ~/.claude/settings.json)

 ❯ Enabled Plugins                          21 plugins enabled
   Always Thinking Enabled                  true

 Note: Full config available via 'claude' then '/status' → Config tab


╭─johnlarkin@Mac ~/Documents/coding
╰─➤  claude --usage --format=json
{
  "current_session": {
    "percent_used": 56,
    "resets": "Jan 13 at 12AM (EST)"
  },
  "current_week_all_models": {
    "percent_used": 30,
    "resets": "Jan 15 at 8AM (EST)"
  },
  "current_week_sonnet_only": {
    "percent_used": 0,
    "resets": "not enabled"
  },
  "extra_usage": "unknown",
  "timestamp": "2026-01-13T03:37:01Z"
}
```

## other nice resources

furthermore, i should note, there are some other great resources that i didn't quite want, but that are also nice (and I'm always skittish despite them being opensource about the code)

- https://github.com/ryoppippi/ccusage
- https://github.com/steipete/CodexBar
- https://github.com/richhickson/claudecodeusage

I (/ Claude) did take inspiration from their underlying implementations however.
