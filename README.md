# Cross-Platform Align

A Claude Code plugin/skill for aligning features between **iOS (Swift/SwiftUI)** and **Android (Kotlin/Jetpack Compose)** projects.

## What it does

This skill helps you:

- **Analyze** both iOS and Android project architectures
- **Deep dive** into specific features across platforms
- **Generate gap analysis** reports showing what's consistent, what differs, and what can't be ported 1:1
- **Implement** aligned code that follows each platform's existing conventions
- **Verify** behavioral parity with structured checklists

## Installation

```bash
git clone https://github.com/irwancannadys/Cross-Platform-Align-Skill.git
cd Cross-Platform-Align-Skill
./install.sh
```

Then restart Claude Code or run `/reload-plugins`.

## Usage

Trigger phrases:

- "samain fitur ini"
- "translate ke iOS" / "translate ke Android"
- "compare Android vs iOS"
- "port fitur dari Android/iOS"
- "align kedua platform"
- "cek apakah behavior-nya sama"

Or provide paths to both an iOS and Android project and ask about a feature.

## Phases

1. **Project Foundation Discovery** — Understand both project architectures (DI, state management, modules)
2. **Feature Deep Dive** — Trace feature implementation across ViewModel, UI, data, and model layers
3. **Gap Analysis** — Compare implementations and identify differences with recommendations
4. **Implementation** — Write aligned code following each project's conventions
5. **Verification Checklist** — Structured testing checklist for behavioral parity

## Key Rules

- Follows each project's existing architecture — never injects new patterns
- Never suggests libraries not already in the project
- Always shows gap analysis and waits for confirmation before writing code
- Leverages LSP (swift-lsp, kotlin-lsp) when available for efficient code navigation

## License

MIT
