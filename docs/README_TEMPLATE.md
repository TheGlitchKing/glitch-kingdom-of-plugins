# [Plugin Display Name]

<!--
  BADGE INSTRUCTIONS
  ------------------
  Replace all [PLACEHOLDERS] below with your actual values.
  Remove the GitHub Action badge line entirely if your plugin has no GitHub Action.

  npm version badge — replace YOUR_NPM_PACKAGE with your scoped package name (e.g. @theglitchking/my-plugin)
  License badge — keep as-is if MIT. Change "MIT" in both the label and link if using a different license.
  GitHub Action badge — only include if your plugin ships a GitHub Action (action.yml). Replace OWNER/REPO.
-->

[![npm version](https://img.shields.io/npm/v/[YOUR_NPM_PACKAGE].svg)](https://www.npmjs.com/package/[YOUR_NPM_PACKAGE])
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Action](https://img.shields.io/badge/GitHub%20Action-available-2088FF?logo=github-actions)](https://github.com/[OWNER]/[REPO]/blob/main/action.yml)

---

## Summary

<!--
  Write 3–5 sentences at an 8th grade reading level.
  Answer: What problem does this plugin solve? Who is it for? Why does it matter?
  Avoid jargon. Pretend you are explaining it to a smart 13-year-old.

  EXAMPLE (replace with your own):
  "Keeping your project's documentation up to date is a pain — files get stale, links break, and
  nobody knows where to look. [Plugin Name] fixes that by automatically scanning your codebase and
  rebuilding your docs every time you make a change. You don't have to remember to update anything;
  the plugin handles it for you. It works inside Claude Code, so it fits right into the workflow
  you already use every day."
-->

[SUMMARY — 3 to 5 sentences. 8th grade reading level. What problem does this solve and who is it for?]

---

## How It Works

<!--
  2 paragraphs maximum. You can get technical here. Explain the approach:
  - What does the plugin actually do under the hood?
  - What makes it work? What technology or method is it built on?
  Keep it high-level enough that a developer can understand without reading all the source code.

  EXAMPLE paragraph 1:
  "[Plugin Name] hooks into Claude Code's SessionStart event and runs a lightweight file watcher
  in the background. When it detects a change in your /docs directory, it triggers a rebuild
  pipeline that parses your source files, extracts structured metadata, and writes updated
  markdown files to the output folder."

  EXAMPLE paragraph 2:
  "The plugin uses [technology/approach] to [do X]. All configuration lives in a single
  plugin.json file at the root of your project, so there is nothing to memorize and nothing
  hidden in a global config that breaks between machines."
-->

[PARAGRAPH 1 — How does the plugin solve the problem? What is the core mechanism or approach?]

[PARAGRAPH 2 — What technology, protocol, or method powers it? Any notable design decisions worth knowing?]

---

## Features

<!--
  A flat list. Each item is one feature. Be specific — avoid generic phrases like "easy to use."
  Start each line with a verb or noun. Keep it scannable.
-->

- [Feature 1 — e.g., "Automatically rebuilds documentation on every file save"]
- [Feature 2 — e.g., "Supports three installation scopes: user, project, and global"]
- [Feature 3]
- [Feature 4]
- [Feature 5]

---

## Quick Start

### 1. Installation

#### NPM

<!--
  Write these instructions as if the reader has never used npm before.
  Include every step: install, then how to enable/init the plugin in Claude Code.
  Use plain language — no assumptions about terminal experience.
-->

**Step 1 — Install the package**

Open your terminal and run this command:

```bash
npm install -g @theglitchking/[plugin-name]
```

This downloads the plugin to your computer and makes it available as a command you can run from anywhere.

**Step 2 — Install it into Claude Code**

Next, run this command to add the plugin to your Claude Code setup:

```bash
[plugin-name] install --scope user
```

> Use `--scope user` to install for your user account (works in all your projects).
> Use `--scope project` to install for the current project only.

**Step 3 — Verify it worked**

```bash
[plugin-name] status
```

You should see a message confirming the plugin is active. If you see an error, check the Troubleshooting section in [Technical Details](#technical-details).

**NPX (no install required)**

If you don't want to install globally, you can run it directly:

```bash
npx @theglitchking/[plugin-name] install --scope user
```

---

#### Claude Marketplace (`/plugin install`)

<!--
  Write these instructions for someone who has Claude Code open and wants to install
  without touching the terminal. Use plain language and numbered steps.
-->

**Step 1 — Open Claude Code**

Start a new Claude Code session in your terminal by running `claude` in any project folder.

**Step 2 — Run the install command**

Type this exactly into the Claude Code prompt and press Enter:

```
/plugin install [OWNER]/[plugin-name]
```

Claude Code will download and install the plugin automatically.

**Step 3 — Enable the plugin**

After installation, run this to activate it in your current session:

```
[any required enable/init command, e.g. /plugin-name/init]
```

> If no activation step is needed, remove this step and note that the plugin is active immediately after install.

**Step 4 — Confirm it's running**

```
[status or verification command]
```

---

### 2. How to Use

<!--
  SECTION STRUCTURE:
  - First: a table listing every CLI command (command + one-line description)
  - Then: examples OUTSIDE the table showing how, when, what to use it on, and what to expect
  Repeat the same pattern for Claude slash commands below.
-->

#### CLI Commands

| Command | Description |
|---------|-------------|
| `[plugin-name] install` | Installs the plugin into Claude Code |
| `[plugin-name] uninstall` | Removes the plugin from Claude Code |
| `[plugin-name] status` | Shows whether the plugin is currently installed and active |
| `[plugin-name] [command]` | [Description of what this command does] |
| `[plugin-name] help` | Prints all available commands and options |

---

**`[plugin-name] [command]`**

*How to use it:*
Run `[plugin-name] [command] [arguments]` from your terminal in any project folder.

*When to use it:*
Use this when [describe the situation or trigger — e.g., "you want to rebuild your docs after making major changes"].

*What to run it on:*
[Describe what type of files, directories, or project state this command applies to.]

*What to expect:*
[Describe the output — what prints to the terminal, what files are created or changed, how long it takes, etc.]

```bash
# Example
[plugin-name] [command] ./src

# Output
[paste or describe the expected terminal output here]
```

---

<!-- Repeat the block above for each CLI command that needs examples. -->

---

#### Claude Slash Commands

| Command | Description |
|---------|-------------|
| `/[plugin-name]/[command]` | [One-line description] |
| `/[plugin-name]/[command2]` | [One-line description] |

---

**`/[plugin-name]/[command]`**

*How to use it:*
Type `/[plugin-name]/[command]` into the Claude Code prompt and press Enter. [Add any arguments or options if applicable.]

*When to use it:*
Use this when [describe the situation — e.g., "you're starting a new session and want to load your project context automatically"].

*What to use it on:*
[Describe what this command works with — files, directories, a specific project state, etc.]

*What to expect:*
[Describe what Claude does after you run this command. What does the output look like? Does it create files? Does it ask follow-up questions? How long does it take?]

```
/[plugin-name]/[command] [optional arguments]

# Claude will respond with:
[describe or paste example output]
```

---

<!-- Repeat the block above for each Claude command that needs examples. -->

---

## Technical Details

<!--
  This section is for developers who want to understand the internals.
  Include all of the following that apply to your plugin. Remove sections that don't apply.
-->

### File Structure

```
[plugin-name]/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest (name, version, description)
├── .claude/
│   ├── commands/            # Slash command definitions (.md files)
│   └── hooks/               # Lifecycle hooks (SessionStart, PreToolUse, etc.)
├── agents/                  # Subagent definitions (if applicable)
├── skills/                  # Skill implementations (if applicable)
├── bin/
│   └── [plugin-name].js     # CLI entry point (npm-distributed plugins)
├── src/
│   ├── cli/                 # CLI command implementations
│   └── core/                # Core plugin logic
├── scripts/
│   └── validate-version.sh  # Pre-publish version consistency check
├── tests/
│   ├── unit/
│   └── integration/
├── docs/                    # Additional documentation
├── README.md
├── LICENSE
├── CHANGELOG.md
└── install.sh               # Manual installation script
```

### Architecture

<!--
  Explain how the major pieces connect. A short diagram or description is fine.
  Answer: what runs when, what calls what, and where state lives.
-->

[Describe the high-level architecture. For example: "When Claude Code starts, the SessionStart hook fires install-check.sh, which verifies the plugin is configured correctly. The slash commands are defined as markdown files in .claude/commands/ and are loaded by Claude Code automatically..."]

### Hooks Used

<!--
  List any Claude Code lifecycle hooks your plugin registers and what they do.
  Remove this section if your plugin uses no hooks.
-->

| Hook | Trigger | What this plugin does |
|------|---------|----------------------|
| `SessionStart` | Every time Claude Code starts | [e.g., "Checks plugin configuration and prints status"] |
| `PreToolUse` | Before any tool runs | [e.g., "Validates file paths to prevent writes outside project root"] |
| `PostToolUse` | After a tool completes | [e.g., "Logs the tool call for audit purposes"] |

### Configuration

<!--
  Document every configuration option — file location, key names, types, defaults, and examples.
-->

Configuration lives in `[path, e.g., .claude-plugin/config.json]`.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `[option_name]` | `string` | `"[default]"` | [What it controls] |
| `[option_name]` | `boolean` | `false` | [What it controls] |

**Example config:**

```json
{
  "[option_name]": "[value]",
  "[option_name]": true
}
```

### Edge Cases and Known Limitations

<!--
  Be honest here. List known issues, unsupported scenarios, and workarounds.
  This saves users hours of debugging.
-->

- **[Edge case 1]**: [What happens and how to work around it. e.g., "If your project has no src/ directory, the scan command will exit with a warning. Run it from a subdirectory instead."]
- **[Edge case 2]**: [What happens and how to work around it.]
- **[Limitation]**: [Something the plugin intentionally does not support, and why.]

### Dependencies

<!--
  List runtime dependencies and what they're used for.
  This helps users debug environment issues.
-->

| Dependency | Version | Required? | Purpose |
|-----------|---------|-----------|---------|
| Node.js | `>=16.0.0` | Yes | Runtime |
| Claude Code | `>=1.0.0` | Yes | Plugin host |
| `[npm package]` | `^[version]` | Yes | [What it does] |
| `[npm package]` | `^[version]` | No | [What it does — optional feature] |

### Troubleshooting

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| `command not found: [plugin-name]` | npm global bin not in PATH | Add `$(npm bin -g)` to your PATH, or use `npx` |
| Plugin installed but commands don't appear in Claude | Install scope mismatch | Run `[plugin-name] install --scope project` from your project root |
| `[error message]` | [cause] | [fix] |
