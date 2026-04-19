# Glitch Kingdom Plugin Marketplace

> Official marketplace for TheGlitchKing's Claude Code plugins and development tools

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Plugins](https://img.shields.io/badge/Plugins-9-blue)](./catalog/index.md)

## Overview

The Glitch Kingdom Plugin Marketplace is a centralized hub for discovering and installing high-quality Claude Code plugins and development tools. Each plugin is independently developed and maintained while being accessible through this unified marketplace.

### Architecture

This marketplace uses a **hybrid approach** combining:
- **Git Submodules**: Each plugin maintains its own repository and development workflow
- **Centralized Registry**: The `marketplace.json` file provides unified discovery and metadata
- **Multiple Installation Methods**: Support for npm, Claude marketplace, manual installation, and more

## Featured Plugins

### 🎯 [Hit 'Em With The Docs](./plugins/hit-em-with-the-docs) — `2.1.0`
**Self-Managing Documentation System**

A TypeScript-based CLI tool and GitHub Action that creates hierarchical, metadata-rich documentation with intelligent automation and pattern discovery.

- **Type**: CLI Tool + GitHub Action
- **Status**: Production Ready
- **Install**: `/plugin marketplace add TheGlitchKing/hit-em-with-the-docs && /plugin install hit-em-with-the-docs@hit-em-with-the-docs-marketplace` — or `npm install --save-dev @theglitchking/hit-em-with-the-docs`
- **Features**: 15-domain hierarchy, 22-field metadata schema, pattern discovery, self-healing

[Learn More →](https://github.com/TheGlitchKing/hit-em-with-the-docs)

### 🧠 [Mind Glaive](./plugins/mind-glaive) — `2.0.1`
**Intelligent Memory Management for Claude Code**

Eliminate context rot through intelligent memory hierarchy, auto-learning hooks, and specialized subagents.

- **Type**: Claude Native Plugin
- **Status**: Production Ready
- **Install**: `/plugin marketplace add TheGlitchKing/mind-glaive && /plugin install mind-glaive@mind-glaive-marketplace` — or `npm install --save-dev @theglitchking/mind-glaive`
- **Features**: 8-layer architecture, SessionStart/End hooks, MCP knowledge base, pattern learning

[Learn More →](https://github.com/TheGlitchKing/mind-glaive)

### ⚡ [Aeon Loop](./plugins/aeon-loop) — `2.0.0`
**Autonomous Task Execution Engine**

"Start and walk away" autonomous execution with fresh sessions per iteration, filesystem-based state, and intelligent recovery.

- **Type**: Claude Native Plugin (includes Aeon Flux)
- **Status**: Production Ready
- **Install**: `/plugin marketplace add TheGlitchKing/aeon-loop && /plugin install aeon-loop@aeon-loop-marketplace` — or `npm install --save-dev @theglitchking/aeon-loop`
- **Features**: Loop orchestrator, DAG-based execution, circuit breaker, worker timeout

[Learn More →](https://github.com/TheGlitchKing/aeon-loop)

### 🌊 [Aeon Flux](./plugins/aeon-flux) — `1.0.0`
**Bash Loop Operating Mode**

Action over explanation - tight feedback loops with intelligent context preservation.

- **Type**: Claude Native Plugin (bundled with Aeon Loop)
- **Status**: Production Ready
- **Install**: Included with Aeon Loop — no separate install required
- **Features**: Action-first mode, error recovery, attention markers, checkpoint/resume

[Learn More →](https://github.com/TheGlitchKing/aeon-flux)

### 📋 [Persistent Planning](./plugins/persistent-planning) — `2.0.0`
**Persistent Markdown-Based Planning**

Use on-disk markdown files as "working memory" for planning, progress tracking, and knowledge storage. Based on Manus AI context engineering principles.

- **Type**: Claude Native Plugin
- **Status**: Production Ready
- **Install**: `/plugin marketplace add TheGlitchKing/persistent-planning && /plugin install persistent-planning@persistent-planning-marketplace` — or `npm install --save-dev @theglitchking/persistent-planning`
- **Features**: Task directories, session persistence, concurrent tasks, `/start-planning` command

[Learn More →](https://github.com/TheGlitchKing/persistent-planning)

### 🗺️ [Babel Fish](./plugins/babel-fish) — `2.0.0`
**Auto-Generated Project Map + Vocabulary Translator**

Gives Claude instant, accurate knowledge of every route, model, service, feature, and infrastructure element in any codebase. Maps plain-English phrases to exact file paths, mines past sessions for learned aliases, and self-updates on every commit.

- **Type**: Claude Native Plugin
- **Status**: Production Ready
- **Install**: `/plugin marketplace add TheGlitchKing/babel-fish && /plugin install babel-fish@babel-fish-marketplace` — or `npm install --save-dev @theglitchking/babel-fish`
- **Features**: 19-section project map, vocabulary translator, session-mined aliases, iterative 90% quality grading, pre-commit hook

[Learn More →](https://github.com/TheGlitchKing/babel-fish)

### 🔍 [Gimme The Lint](https://github.com/TheGlitchKing/gimme-the-lint) — `1.2.0`
**Progressive Linting System**

Progressive linting that only blocks on new violations, not legacy code. Baseline existing issues and enforce clean code going forward.

- **Type**: Claude Native Plugin + CLI Tool + GitHub Action
- **Status**: Production Ready
- **Install**: `/plugin marketplace add TheGlitchKing/gimme-the-lint && /plugin install gimme-the-lint@gimme-the-lint-marketplace` — or `npm install --save-dev @theglitchking/gimme-the-lint`
- **Features**: Directory-chunked baselines, drift detection, auto-healing, monorepo support (Python + JS/TS), git hooks

[Learn More →](https://github.com/TheGlitchKing/gimme-the-lint)

### 📄 [Semantic Pages](./plugins/semantic-pages) — `0.10.0`
**Semantic Search + Knowledge Graph MCP Server**

Give Claude semantic search, knowledge graph traversal, and full CRUD over any folder of markdown files. Replaces the Obsidian + Smart Connections + MCP plugin stack with a single `npx` command.

- **Type**: MCP Server
- **Status**: Production Ready
- **Install**: `/plugin marketplace add TheGlitchKing/semantic-pages && /plugin install semantic-pages@semantic-pages-marketplace` — or `npm install --save-dev @theglitchking/semantic-pages`
- **Features**: 21 MCP tools, local embeddings (no API key), wikilink graph, hybrid search, frontmatter/tag management, file watcher

[Learn More →](https://github.com/TheGlitchKing/semantic-pages)

### 🎨 [The Joy of Diagraming](https://github.com/TheGlitchKing/the-joy-of-diagraming) — `2.0.0`
**SVG Technical Diagram Generator**

Generate production-quality SVG technical diagrams (architecture, flowchart, UML, ER, sequence, etc.) with 7 built-in styles. Export as SVG+PNG via `@resvg/resvg-js` — zero system dependencies.

- **Type**: Claude Native Plugin (skill)
- **Status**: Production Ready
- **Install**: `/plugin marketplace add TheGlitchKing/the-joy-of-diagraming && /plugin install the-joy-of-diagraming@the-joy-of-diagraming-marketplace` — or `npm install --save-dev @theglitchking/the-joy-of-diagraming`
- **Features**: 7 visual styles, SVG + PNG export, pure npm (no librsvg / no system deps), templates + fixtures

[Learn More →](https://github.com/TheGlitchKing/the-joy-of-diagraming)

---

## 🛠️  Build Your Own Plugin

All Glitch Kingdom plugins share a common runtime for postinstall, SessionStart update-nudging, and the standard `update` / `policy` / `status` / `relink` subcommand surface:

### [`@theglitchking/claude-plugin-runtime`](https://github.com/TheGlitchKing/claude-plugin-runtime)

A tiny (~13 KB, zero runtime deps) package that handles the boilerplate every plugin needs:

- **Skill symlinking** — bundled skills in `node_modules/` get linked into `<project>/.claude/skills/` on install.
- **Default policy config** — writes `<project>/.claude/<plugin>.json` with `{ "updatePolicy": "nudge" }`.
- **Hook registration with plugin-vs-npm dedup** — registers a SessionStart hook in `.claude/settings.json` only when the marketplace plugin isn't already handling it.
- **Policy-aware update check** — `off` / `nudge` / `auto` with 3s network budget, 6h cache, CI-skip.
- **CLI subcommand registration** — `update`, `policy`, `status`, `relink` for terminal parity with the slash commands.

📖 **[Authoring scaffold →](https://github.com/TheGlitchKing/claude-plugin-runtime/blob/main/docs/PLUGIN_AUTHORING_SCAFFOLD.md)** — copy-paste templates for every file a new plugin needs.

📘 **[Plugin Development Guide](./docs/PLUGIN_DEVELOPMENT.md)** — step-by-step build process for this marketplace.

📜 **[Plugin Standards](./.documentation/standards/plugin-standards.md)** — mandatory requirements for plugins listed here.

## Quick Start

### Installation Options

#### Option 1: Clone Marketplace with All Plugins
```bash
# Clone with submodules to get all plugins
git clone --recursive https://github.com/TheGlitchKing/glitch-kingdom-of-plugins.git
cd glitch-kingdom-of-plugins

# Browse plugins
ls plugins/

# Use the universal installer
./scripts/install-plugin.sh <plugin-name>
```

#### Option 2: Install Individual Plugins

All plugins in this marketplace share the same two-install-path shape:

**A. Claude Code Plugin Marketplace (recommended for most users):**
```
/plugin marketplace add TheGlitchKing/<plugin-name>
/plugin install <plugin-name>@<plugin-name>-marketplace
```

**B. Project-level npm install (recommended for teams, CI, and AI-assisted projects):**
```bash
npm install --save-dev @theglitchking/<plugin-name>
```

The npm postinstall writes `.claude/<plugin-name>.json` (update policy: `nudge`), symlinks any bundled skills into `.claude/skills/`, and registers a SessionStart update-check hook in `.claude/settings.json` — with plugin-vs-npm dedup, so you never get duplicate hooks firing if you also have the marketplace version enabled.

After install, every plugin exposes the same update-management surface:

```bash
npx --no @theglitchking/<plugin-name> status      # installed / latest / policy / hook state
npx --no @theglitchking/<plugin-name> policy auto # auto-update on session start
npx --no @theglitchking/<plugin-name> policy off  # silent
npx --no @theglitchking/<plugin-name> update      # update now
```

Slash-command parity: `/<plugin-name>:{status,policy,update,relink}`.

**Legacy (pre-runtime — some plugins only):**

```bash
# hit-em-with-the-docs CLI via npx (no project dep required)
npx @theglitchking/hit-em-with-the-docs init

# semantic-pages via .mcp.json — point at any markdown folder
npx @theglitchking/semantic-pages --notes ./vault

# Old placeholder for multi-plugin install:
npm install -g @theglitchking/gimme-the-lint
gimme-the-lint install

# Or via NPX (no install)
npx @theglitchking/mind-glaive install --scope user --template full-stack
npx @theglitchking/aeon-loop install --scope user
npx @theglitchking/gimme-the-lint install
```

#### Option 3: Install via Claude Marketplace

```bash
# In Claude Code
/plugin install TheGlitchKing/mind-glaive
/plugin add TheGlitchKing/aeon-loop
/plugin install TheGlitchKing/gimme-the-lint
```

#### Option 4: Manual Installation

```bash
# Clone and install manually
git clone https://github.com/TheGlitchKing/mind-glaive.git
cd mind-glaive
./install.sh --scope user --template full-stack
```

### Browsing the Catalog

View the complete plugin catalog:
```bash
cat catalog/index.md
```

Or browse by category:
- [Developer Tools](./catalog/by-category/developer-tools.md)
- [Documentation Tools](./catalog/by-category/documentation.md)
- [Productivity Tools](./catalog/by-category/productivity.md)
- [Automation Tools](./catalog/by-category/automation.md)
- [Search & Knowledge](./catalog/by-category/search.md)

## Documentation

- [**Architecture**](./docs/ARCHITECTURE.md) - Technical architecture and design decisions
- [**Installation Guide**](./docs/INSTALLATION_GUIDE.md) - Detailed installation instructions
- [**Plugin Development**](./docs/PLUGIN_DEVELOPMENT.md) - Guide for plugin developers
- [**Marketplace Schema**](./schemas/plugin-schema.json) - JSON schema for plugin metadata

## Plugin Categories

### 📚 Documentation
Tools for managing, generating, and maintaining documentation
- hit-em-with-the-docs

### 🚀 Productivity
Tools that enhance development workflows and efficiency
- mind-glaive
- aeon-loop
- aeon-flux
- gimme-the-lint
- persistent-planning

### 🤖 Automation
Tools for automating repetitive tasks
- aeon-loop
- hit-em-with-the-docs

### 🔎 Search & Knowledge
Tools for semantic search, knowledge graphs, and information retrieval
- semantic-pages

## Requirements

### For Marketplace Usage
- Git 2.0+ with submodule support
- Bash (for scripts)

### For Individual Plugins

**NPM Installation**:
- **hit-em-with-the-docs**: Node.js 20+
- **mind-glaive**: Node.js 16+, Claude Code 1.0+, Optional: Python 3.9+ (for MCP servers), Optional: Ollama
- **aeon-loop/flux**: Node.js 16+, Claude Code 2.0.13+
- **gimme-the-lint**: Node.js 18+, Optional: Python 3.8+ (for backend linting)
- **semantic-pages**: Node.js 18+

**Manual/Marketplace Installation**:
- **mind-glaive**: Claude Code 1.0+, Bash, Python 3.9+ (for MCP servers), Optional: Ollama
- **aeon-loop/flux**: Claude Code 2.0.13+, Bash

## Scripts

The marketplace provides helper scripts for common tasks:

- `./scripts/install-plugin.sh <plugin-name>` - Universal plugin installer
- `./scripts/validate-plugins.sh` - Validate marketplace.json against schema
- `./scripts/sync-submodules.sh` - Update submodules to latest versions
- `./scripts/generate-catalog.sh` - Generate plugin catalog

## Contributing

We welcome contributions! Here's how to get involved:

### Adding a New Plugin

1. Develop your plugin in its own repository
2. Follow the [Plugin Development Guide](./docs/PLUGIN_DEVELOPMENT.md)
3. Add plugin metadata to `marketplace.json`
4. Add plugin as a git submodule: `git submodule add <repo-url> plugins/<plugin-name>`
5. Run validation: `./scripts/validate-plugins.sh`
6. Submit a pull request

### Reporting Issues

Found a bug or have a suggestion? Please open an issue on the relevant repository:
- Marketplace issues: [glitch-kingdom-of-plugins/issues](https://github.com/TheGlitchKing/glitch-kingdom-of-plugins/issues)
- Plugin-specific issues: See individual plugin repositories

## Version Management

The marketplace uses semantic versioning:
- **MAJOR**: Breaking changes to marketplace structure or API
- **MINOR**: New plugins added, backward compatible changes
- **PATCH**: Bug fixes, documentation updates

Each plugin maintains its own versioning independent of the marketplace.

## License

MIT License - see individual plugin repositories for their specific licenses.

## Maintenance

### For Users

**Update NPM packages**:
```bash
# Update all plugins
npm update -g @theglitchking/hit-em-with-the-docs
npm update -g @theglitchking/mind-glaive
npm update -g @theglitchking/aeon-loop
npm update -g @theglitchking/gimme-the-lint

# Or update individually
npm update -g @theglitchking/[plugin-name]
```

**Update marketplace submodules**:
```bash
cd glitch-kingdom-of-plugins
git pull
git submodule update --remote --merge
```

### For Maintainers

Sync submodules and update marketplace:
```bash
./scripts/sync-submodules.sh
./scripts/generate-catalog.sh
git add .
git commit -m "chore: sync plugin versions"
```

## Support

- **Documentation**: See [docs/](./docs/)
- **Issues**: Open an issue on the relevant repository
- **Discussions**: GitHub Discussions (coming soon)

## Roadmap

- [ ] Web-based marketplace browser UI
- [ ] Plugin search and filtering
- [ ] Automated release notes aggregation
- [ ] Download/usage analytics
- [ ] Community plugin submission process
- [ ] Plugin compatibility matrix
- [ ] CI/CD automation for plugin sync

---

**Made with ❤️ by TheGlitchKing**

[View on GitHub](https://github.com/TheGlitchKing/glitch-kingdom-of-plugins) | [Report an Issue](https://github.com/TheGlitchKing/glitch-kingdom-of-plugins/issues)
