Here's the key difference:

**Skills** are individual capability modules that Claude automatically invokes based on context. They're essentially SKILL.md files containing instructions and guidance that Claude loads on-demand when it detects a relevant task. For example, a "pdf-form-filler" skill would automatically activate when you ask Claude to fill out a PDF form. Skills add knowledge to the conversation without you needing to explicitly call them.

**Plugins** are distribution packages that bundle multiple components together into a single installable unit. A plugin can contain:

- Skills
- Slash commands
- Subagents
- Hooks
- MCP servers

Think of plugins as the "shipping container" that lets you package and share an entire configuration. Before plugins, setting up Claude Code with custom commands, agents, and integrations meant scattered configuration files across different projects. When teammates asked "How do I set up the same thing?", reproducing your setup was tedious and error-prone.

**Key distinctions:**

| Aspect       | Skills                                                        | Plugins                                                     |
| ------------ | ------------------------------------------------------------- | ----------------------------------------------------------- |
| Scope        | Single capability                                             | Bundle of capabilities                                      |
| Invocation   | Claude automatically loads them based on your request         | Installed via `/plugins` command                            |
| Availability | Skills work everywhere Claude does: web app, API, Claude Code | Plugins are specific to Claude Code (the terminal/IDE tool) |
| Purpose      | Add domain expertise/guidance                                 | Package and distribute configurations                       |

In short: a plugin _can contain_ skills (along with other components), but a skill is just one type of extension that provides auto-loaded guidance.
