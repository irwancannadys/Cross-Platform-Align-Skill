# Cross-Platform Align Skill — Setup Guide

A Claude Code skill for aligning, comparing, and porting features between **iOS (Swift/SwiftUI)** and **Android (Kotlin/Jetpack Compose)** projects consistently.

---

## What is LSP?

**LSP (Language Server Protocol)** is a standard protocol that separates "programming language intelligence" from the editor. Simply put, LSP is a smart engine that understands code structure — it knows where a function is defined, who uses it, and what type a variable is — without having to read every file one by one.

```
Claude Code  <-->  LSP  <-->  Source Code
```

**Swift LSP (SourceKit-LSP)** — a language server built specifically for Swift, already bundled inside Xcode. Once Xcode is installed, SourceKit-LSP is automatically available.

**Kotlin LSP** — a language server built specifically for Kotlin/Android, provided by Anthropic as a Claude Code plugin.

### Why does it save tokens?

Without LSP, Claude has to **manually scan files** to understand the project structure:
```
find . -name "*.swift" -> read 60+ files -> find the relevant ones
```

With LSP, Claude can **directly ask the language server**:
```
"Where is SupplyConfirmationViewModel defined?" -> answered in milliseconds
```

As a result, Claude only needs to read **2-3 entry point files** instead of dozens at once — saving significantly more tokens and producing more accurate results.

---

## Prerequisites

- **Claude Code** installed locally
- **Xcode** installed (for Swift LSP)

---

## Setup (4 Steps)

### 1. Install Swift LSP

Open Claude Code and run:
```
/plugin install swift-lsp@claude-plugins-official
```

### 2. Install Kotlin LSP

```
/plugin install kotlin-lsp@claude-plugins-official
```

Select **"Install for you (user scope)"** so it's active across all projects.

### 3. Install the Skill

There are 2 options, pick one:

#### Option 1 — Via Script (Recommended)

Clone the repo and run the install script — automatically installed with no manual setup needed.

```bash
git clone https://github.com/irwancannadys/Cross-Platform-Align-Skill.git
cd Cross-Platform-Align-Skill
./install.sh
```

#### Option 2 — Manual

Download `SKILL.md` from this repo, then place it in the Claude skills directory:

```bash
mkdir -p ~/.claude/skills/cross-platform-align
cp /path/to/SKILL.md ~/.claude/skills/cross-platform-align/SKILL.md
```

Replace `/path/to/` with the location where you downloaded the file.

> **Note:** The skill will remain active and usable even if it doesn't appear in the `/reload-plugins` count — this is normal. User skills are loaded separately from plugin skills.

### 4. Verify

Run in Claude Code:
```
/reload-plugins
```

Then check:
```
list all active skills
```

Make sure `cross-platform-align` appears in the list.

---

## How to Use

No special command needed. Just type naturally in Claude Code:

```
align the supply confirmation feature from Android to iOS
android path: /Users/.../android-project
ios path: /Users/.../ios-project
```

The skill will trigger automatically and Claude will:

1. Read the architecture of both projects via LSP (token-efficient)
2. Analyze the gap — what's already consistent, what's different
3. **Ask for your approval first** before writing any code
4. Implement following each project's existing conventions
5. Provide a verification checklist at the end

---

## Trigger Phrases

- `"align feature X from Android to iOS"`
- `"port feature X to iOS"`
- `"check if the behavior is the same on both platforms"`
- `"compare Android vs iOS implementation"`
- `"samain fitur ini"` / `"translate ke iOS"`

---

## Phases

1. **Project Foundation Discovery** — Understand both project architectures (DI, state management, modules)
2. **Feature Deep Dive** — Trace feature implementation across ViewModel, UI, data, and model layers
3. **Gap Analysis** — Compare implementations and identify differences with recommendations
4. **Implementation** — Write aligned code following each project's conventions
5. **Verification Checklist** — Structured testing checklist for behavioral parity

---

## Key Rules

- Follows each project's existing architecture — never injects new patterns
- **Never suggests libraries not already in the project** — always checks `build.gradle.kts` / `Package.swift` first
- Always shows gap analysis and waits for confirmation before writing code
- Leverages LSP (swift-lsp, kotlin-lsp) when available for efficient code navigation

---

## Estimated Benchmark

Benchmark was conducted using the **Kebun (Create Asset Farm)** feature — comparing Claude Code with and without this skill.

| | Without Skill | With Skill | Improvement |
|---|---|---|---|
| Time to complete | 6 min 30 sec | 2 min 47 sec | **~57% faster** |
| Files read by Claude | ~132 files | ~15-20 files | **~85% fewer** |
| Estimated tokens used | ~170,000 tokens | ~40,000-50,000 tokens | **~70% more efficient** |
| Output format | Unstructured | Gap Analysis + Checklist | **More consistent** |

**Why do tokens matter?** Tokens are the "unit of reading and writing" for Claude — the more tokens used, the higher the computational cost and the slower the response. This skill helps Claude focus only on relevant files instead of scanning the entire project.

> Results may vary depending on feature complexity and codebase size.

---

## Uninstall

To remove the skill:

```bash
rm -rf ~/.claude/skills/cross-platform-align
```

Then restart Claude Code or run `/reload-plugins`.

---

## License

MIT
