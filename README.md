# Cross-Platform Align

A Claude Code skill for aligning features between **iOS (Swift/SwiftUI)** and **Android (Kotlin/Jetpack Compose)** projects.

## What it does

This skill helps you:

- **Analyze** both iOS and Android project architectures
- **Deep dive** into specific features across platforms
- **Generate gap analysis** reports showing what's consistent, what differs, and what can't be ported 1:1
- **Implement** aligned code that follows each platform's existing conventions
- **Verify** behavioral parity with structured checklists

## Installation

### 1. Install LSP Plugins

Open Claude Code and run:
```
/plugin install swift-lsp@claude-plugins-official
/plugin install kotlin-lsp@claude-plugins-official
```

Select **"Install for you (user scope)"** so it's active across all projects.

### 2. Install the Skill

```bash
git clone https://github.com/irwancannadys/Cross-Platform-Align-Skill.git
cd Cross-Platform-Align-Skill
./install.sh
```

### 3. Verify

Restart Claude Code or run `/reload-plugins`, then:
```
list all active skills
```

Make sure `cross-platform-align` appears in the list.

## Usage

No special command needed. Just type naturally:

```
align the supply confirmation feature from Android to iOS
android path: /Users/.../android-project
ios path: /Users/.../ios-project
```

### Trigger Phrases

- `"align feature X from Android to iOS"`
- `"port feature X to iOS"`
- `"compare Android vs iOS implementation"`
- `"check if the behavior is the same on both platforms"`

## Key Rules

- Follows each project's existing architecture — never injects new patterns
- Never suggests libraries not already in the project
- Always shows gap analysis and waits for confirmation before writing code
- Leverages LSP (swift-lsp, kotlin-lsp) when available for efficient code navigation

## Uninstall

```bash
rm -rf ~/.claude/skills/cross-platform-align
```

## License

MIT
