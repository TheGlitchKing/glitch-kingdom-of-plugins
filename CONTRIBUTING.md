# Contributing to the Glitch Kingdom Marketplace

Welcome. This guide covers everything you need to add a plugin to the marketplace — from building it to getting it listed.

**Full references**:
- [Plugin Development Guide](./docs/PLUGIN_DEVELOPMENT.md) — step-by-step build process
- [Plugin Standards](./.documentation/standards/plugin-standards.md) — all requirements in one place
- [README Template](./docs/README_TEMPLATE.md) — copy this for your plugin's README
- [Architecture Overview](./docs/ARCHITECTURE.md) — how the marketplace works
- [JSON Schema](./schemas/plugin-schema.json) — marketplace.json validation rules

---

## Plugin Types

| Type | What it is | Examples |
|------|-----------|---------|
| `claude-plugin` | Native Claude Code plugin (hooks, commands, skills, agents) | mind-glaive, aeon-loop |
| `cli-tool` | Standalone command-line tool, usable with or without Claude | hit-em-with-the-docs |
| `library` | Reusable code library imported into other projects | — |
| `mcp-server` | Model Context Protocol server for knowledge integration | semantic-pages |

---

## Required Files (Every Plugin)

| File | Purpose |
|------|---------|
| `README.md` | Primary documentation — use the [README template](./docs/README_TEMPLATE.md) |
| `LICENSE` | OSI-approved license. MIT is strongly recommended. |
| `CHANGELOG.md` | Release history in [Keep a Changelog](https://keepachangelog.com) format |
| `plugin.json` or `package.json` | Plugin manifest |
| `install.sh` | (claude-plugin only) Installation script |

---

## Naming Standards

- **Plugin ID / repo name**: `kebab-case` — `my-awesome-plugin` ✅ `MyAwesomePlugin` ❌
- **Display name**: Title Case — `My Awesome Plugin`
- **NPM package**: Scoped under `@theglitchking/` — `@theglitchking/my-awesome-plugin` ✅
- **Slash commands**: Namespaced — `/my-plugin/command`

---

## Versioning

All plugins use [Semantic Versioning](https://semver.org) (`MAJOR.MINOR.PATCH`):

| Change type | Version bump | Example |
|------------|-------------|---------|
| Bug fix | PATCH | `1.0.0` → `1.0.1` |
| New feature (backward compatible) | MINOR | `1.0.1` → `1.1.0` |
| Breaking change | MAJOR | `1.1.0` → `2.0.0` |

Every release must have a matching git tag: `git tag -a v1.0.0 -m "Release v1.0.0"`

---

## Installation Methods

At least one method is required. More is better — list them in this priority order:

1. **NPM** (global install) — primary method for npm-distributed plugins
2. **NPX** (no install) — convenient zero-install alternative
3. **Claude marketplace** (`/plugin install Owner/repo`) — Claude Code native install
4. **Manual** (git clone + script) — fallback for advanced users

---

## Adding Your Plugin to the Marketplace

### Step 1 — Build and publish your plugin

Follow the [Plugin Development Guide](./docs/PLUGIN_DEVELOPMENT.md). Make sure:
- Your repo is public on GitHub
- At least one tagged release exists (`v1.0.0`)
- Your README follows the [README template](./docs/README_TEMPLATE.md)
- Installation works end-to-end on a clean machine

### Step 2 — Fork this repository

```bash
# Fork on GitHub, then:
git clone https://github.com/YourUsername/glitch-kingdom-of-plugins.git
cd glitch-kingdom-of-plugins
```

### Step 3 — Add your plugin as a submodule

```bash
git submodule add https://github.com/YourUsername/my-awesome-plugin.git plugins/my-awesome-plugin
```

### Step 4 — Add your entry to `marketplace.json`

See the [Plugin Standards](./docs/PLUGIN_STANDARDS.md) for the full field reference. Minimum required entry:

```json
{
  "id": "my-awesome-plugin",
  "name": "my-awesome-plugin",
  "displayName": "My Awesome Plugin",
  "type": "claude-plugin",
  "version": "1.0.0",
  "description": "One sentence description of what this plugin does.",
  "author": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "repository": {
    "type": "github",
    "owner": "YourUsername",
    "repo": "my-awesome-plugin",
    "url": "https://github.com/YourUsername/my-awesome-plugin"
  },
  "source": {
    "type": "submodule",
    "path": "./plugins/my-awesome-plugin"
  },
  "installation": {
    "methods": [
      {
        "type": "claude-marketplace",
        "command": "/plugin install YourUsername/my-awesome-plugin"
      }
    ],
    "requirements": {
      "claude-code": ">=1.0.0"
    }
  },
  "category": "productivity",
  "tags": ["tag1", "tag2"],
  "keywords": ["keyword1"],
  "license": "MIT",
  "homepage": "https://github.com/YourUsername/my-awesome-plugin",
  "status": "production-ready"
}
```

### Step 5 — Validate and test

```bash
./scripts/validate-plugins.sh
./scripts/generate-catalog.sh
./scripts/install-plugin.sh my-awesome-plugin
```

### Step 6 — Submit a pull request

```bash
git add .
git commit -m "feat: add my-awesome-plugin to marketplace"
git push origin main
# Open PR on GitHub
```

---

## PR Checklist

Before submitting, confirm all of these:

- [ ] Plugin repository is public on GitHub
- [ ] Repository name is `kebab-case`
- [ ] README follows the [README template](./docs/README_TEMPLATE.md) with all required sections present
- [ ] `LICENSE` file exists (MIT recommended)
- [ ] `CHANGELOG.md` exists and covers the current release
- [ ] Plugin manifest (`plugin.json` or `package.json`) is valid
- [ ] Version follows semantic versioning and a matching git tag exists
- [ ] `marketplace.json` entry is complete and passes schema validation
- [ ] All listed installation methods have been tested on a clean machine
- [ ] No API keys, tokens, or secrets are committed anywhere
- [ ] GitHub repository has appropriate topics set (`claude-code`, `claude-plugin`, etc.)
- [ ] `./scripts/validate-plugins.sh` passes with no errors

---

## Quality Gates

Plugins that don't meet these standards will be asked to fix before merge:

1. Schema validation passes (`./scripts/validate-plugins.sh`)
2. README has all required sections
3. Valid open source license present
4. At least one installation method works end-to-end
5. A tagged release exists in the plugin repo
6. Repository is clean and organized

---

## Maintenance Expectations

Once listed, plugin maintainers agree to:

- Respond to critical issues within **1 week**
- Apply security patches within **2 weeks** of discovery
- Update for Claude Code compatibility when breaking changes occur
- Document all breaking changes with a migration guide

---

## Categories

Choose the one that best fits:

| Category | Use for |
|----------|---------|
| `documentation` | Documentation management and generation |
| `productivity` | Development workflow enhancement |
| `developer-tools` | Codebase introspection and context engineering |
| `automation` | Task automation |
| `search` | Semantic search and knowledge graphs |

---

## Status Levels

| Status | Meaning |
|--------|---------|
| `experimental` | Early development — may change significantly |
| `beta` | Feature complete but needs more testing |
| `production-ready` | Stable, tested, ready for production |
| `deprecated` | No longer maintained — alternatives documented |

---

## Questions?

Open an issue on this repository with the `question` label.
