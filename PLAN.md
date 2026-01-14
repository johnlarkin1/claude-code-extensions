# Plugin Development Plan

## Current Status

### Done
- [x] Marketplace structure (`.claude-plugin/marketplace.json`)
- [x] Plugin template (`plugins/_template/`)
- [x] `tauri-dev` plugin

### Not Done
- [ ] `textual-tui` plugin
- [ ] `excalidraw-diagrams` plugin
- [ ] `manim-animations` plugin

---

## What Needs to Be Created

### Plugin 1: tauri-dev
```
plugins/tauri-dev/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── tauri/
│       ├── SKILL.md              ← copy from skills/tauri/
│       └── references/           ← copy from skills/tauri/references/
└── agents/
    └── tauri-debugger.md         ← NEW: subagent to create
```

### Plugin 2: textual-tui
```
plugins/textual-tui/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── textual/
│       ├── SKILL.md              ← copy from skills/textual/
│       └── references/           ← copy from skills/textual/references/
└── agents/
    └── tui-reviewer.md           ← NEW: subagent to create
```

### Plugin 3: excalidraw-diagrams
```
plugins/excalidraw-diagrams/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── excalidraw/
│       ├── SKILL.md              ← copy from skills/excalidraw/
│       └── references/           ← copy from skills/excalidraw/references/
└── agents/
    └── diagram-generator.md      ← NEW: subagent to create
```

### Plugin 4: manim-animations
```
plugins/manim-animations/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── manim/
│       ├── SKILL.md              ← copy from skills/manim/
│       └── references/           ← copy from skills/manim/references/
└── agents/
    └── animation-planner.md      ← NEW: subagent to create
```

---

## Steps to Create Each Plugin

For each plugin (e.g., tauri-dev):

1. **Create directory structure**
   ```bash
   mkdir -p plugins/tauri-dev/.claude-plugin
   mkdir -p plugins/tauri-dev/skills
   mkdir -p plugins/tauri-dev/agents
   ```

2. **Copy skill content**
   ```bash
   cp -r skills/tauri plugins/tauri-dev/skills/
   ```

3. **Create plugin.json**
   ```json
   {
     "name": "tauri-dev",
     "description": "Tauri v2 desktop app development with debugger agent",
     "version": "1.0.0",
     "author": { "name": "John Larkin" },
     "keywords": ["tauri", "rust", "desktop", "webview"],
     "license": "MIT"
   }
   ```

4. **Create subagent** (e.g., `agents/tauri-debugger.md`)
   ```markdown
   ---
   name: tauri-debugger
   description: Debug Tauri apps - IPC issues, command failures, permission errors. Use proactively when Tauri builds fail or commands don't work.
   tools: Read, Grep, Glob, Bash
   model: sonnet
   ---

   You are a Tauri debugging specialist...
   ```

5. **Add to marketplace.json**
   ```json
   {
     "name": "tauri-dev",
     "source": "tauri-dev",
     "description": "Tauri v2 development with debugger agent",
     "keywords": ["tauri", "rust", "desktop", "webview"]
   }
   ```

6. **Test locally**
   ```
   /plugin marketplace add ./
   /plugin install tauri-dev@larkin-plugins
   ```

---

## After All Plugins Are Created

1. Push to GitHub
2. Users can install via:
   ```
   /plugin marketplace add johnlarkin/claude-code-extensions
   /plugin install tauri-dev@larkin-plugins
   ```

---

## Summary

| Plugin | Skill Source | Subagent to Create |
|--------|--------------|-------------------|
| tauri-dev | `skills/tauri/` | tauri-debugger |
| textual-tui | `skills/textual/` | tui-reviewer |
| excalidraw-diagrams | `skills/excalidraw/` | diagram-generator |
| manim-animations | `skills/manim/` | animation-planner |
