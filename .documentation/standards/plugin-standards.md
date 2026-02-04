---
title: Plugin Standards and Requirements
tier: standard
domains:
  - standards
  - testing
audience:
  - developers
  - admin
tags:
  - api
  - testing
  - security
  - npm
  - distribution
status: published
last_updated: 2026-02-03T17:20:00.000Z
version: 1.1.0
purpose: Standards and requirements for plugins in the Glitch Kingdom
  Marketplace to ensure consistency, quality, and maintainability. Includes NPM
  distribution standards.
estimated_read_time: 8 minutes
word_count: 1405
last_validated: 2026-02-04
backlinks: []
---

# Plugin Standards and Requirements

## Overview

Standards and requirements for plugins in the Glitch Kingdom Marketplace to ensure consistency, quality, and maintainability.

## Plugin Types

The marketplace supports four plugin types:

### claude-plugin
Native Claude Code plugins with hooks, commands, agents, skills, or MCP servers.

**Requirements**:
- Must have `.claude-plugin/plugin.json` manifest
- Must include installation script or clear installation instructions
- Should provide hooks, commands, skills, or agents
- Must be compatible with Claude Code 1.0+

### cli-tool
Command-line tools that can be used with or without Claude Code.

**Requirements**:
- Must have `package.json` with proper bin configuration
- Must be published to NPM or provide npx support
- Should include `--help` and `--version` flags
- Must work on Linux, macOS, and Windows (WSL2)

### library
Reusable code libraries imported into other projects.

**Requirements**:
- Must have proper package configuration (package.json, setup.py, etc.)
- Must include comprehensive API documentation
- Should have published versions (NPM, PyPI, etc.)
- Must include usage examples

### mcp-server
Model Context Protocol servers for knowledge integration.

**Requirements**:
- Must implement MCP protocol correctly
- Must include server.py or server.js with proper tool definitions
- Should document all available MCP tools
- Must handle errors gracefully

## Required Files

Every plugin must include:

### 1. README.md
- **Purpose**: Primary documentation and landing page
- **Required sections**:
  - Overview/Description
  - Features list
  - Installation instructions (all methods)
  - Usage examples
  - Configuration options
  - Contributing guidelines
  - License

### 2. LICENSE
- **Requirement**: Must be an OSI-approved open source license
- **Recommended**: MIT License (most permissive)
- **Must include**: Copyright year and author name

### 3. Plugin Manifest

**For Claude Plugins** (`.claude-plugin/plugin.json`):
```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Plugin description",
  "author": "Author Name",
  "license": "MIT",
  "keywords": ["keyword1", "keyword2"]
}
```

**For CLI Tools** (`package.json`):
```json
{
  "name": "@theglitchking/plugin-name",
  "version": "1.0.0",
  "description": "Plugin description",
  "bin": {
    "plugin-name": "./dist/cli/index.js"
  },
  "keywords": ["keyword1", "keyword2"],
  "author": "Author Name",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/TheGlitchKing/plugin-name"
  }
}
```

## Naming Conventions

### Repository Names
- **Format**: `kebab-case` (lowercase with hyphens)
- **Examples**:
  - ✅ `mind-glaive`
  - ✅ `hit-em-with-the-docs`
  - ❌ `MindGlaive`
  - ❌ `mind_glaive`

### Plugin IDs
- **Format**: Must match repository name
- **Pattern**: `^[a-z0-9]+(-[a-z0-9]+)*$`
- **Examples**:
  - ✅ `mind-glaive`
  - ✅ `aeon-flux`
  - ❌ `Mind-Glaive`
  - ❌ `mind_glaive`

### Display Names
- **Format**: Title Case with proper spacing
- **Examples**:
  - Repository: `mind-glaive` → Display: "Mind Glaive"
  - Repository: `hit-em-with-the-docs` → Display: "Hit 'Em With The Docs"

### NPM Package Names
- **Format**: Scoped under `@theglitchking/` (Required for all NPM packages)
- **Pattern**: `@theglitchking/[plugin-id]`
- **Examples**:
  - ✅ `@theglitchking/mind-glaive`
  - ✅ `@theglitchking/hit-em-with-the-docs`
  - ✅ `@theglitchking/aeon-loop`
  - ❌ `mind-glaive` (not scoped - unacceptable)
  - ❌ `@other-scope/plugin-name` (wrong scope)

## Version Management

### Semantic Versioning (Required)
All plugins must follow semantic versioning (MAJOR.MINOR.PATCH):

- **MAJOR**: Breaking changes (incompatible API changes)
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

**Examples**:
- `1.0.0` → `1.0.1` (bug fix)
- `1.0.1` → `1.1.0` (new feature)
- `1.1.0` → `2.0.0` (breaking change)

### Git Tags
- **Format**: `vMAJOR.MINOR.PATCH`
- **Examples**: `v1.0.0`, `v1.2.3`, `v2.0.0`
- **Required**: Every release must be tagged
- **Command**: `git tag -a v1.0.0 -m "Release v1.0.0"`

### CHANGELOG.md
- **Required**: Yes, for all plugins
- **Format**: Keep a Changelog format
- **Sections**: Added, Changed, Deprecated, Removed, Fixed, Security
- **Example**:
  ```markdown
  # Changelog

  ## [1.1.0] - 2026-02-03
  ### Added
  - New feature X

  ### Fixed
  - Bug in feature Y

  ## [1.0.0] - 2026-01-15
  ### Added
  - Initial release
  ```

## NPM Distribution Standards

All plugins with NPM distribution must follow these standards:

### Package Configuration

**Required in package.json**:
```json
{
  "name": "@theglitchking/plugin-name",
  "version": "1.0.0",
  "description": "Clear description matching plugin.json",
  "bin": {
    "plugin-name": "./bin/plugin-name.js"
  },
  "files": [
    "bin/",
    "plugins/",
    ".claude-plugin/",
    "README.md",
    "LICENSE",
    "CHANGELOG.md"
  ],
  "publishConfig": {
    "access": "public"
  },
  "scripts": {
    "prepublishOnly": "bash scripts/validate-version.sh"
  },
  "keywords": ["claude-code", "claude-plugin", "..."],
  "author": {
    "name": "TheGlitchKing",
    "email": "theglitchking@users.noreply.github.com"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/TheGlitchKing/plugin-name"
  },
  "license": "MIT"
}
```

### CLI Wrapper Requirements

All NPM-distributed plugins must include a CLI wrapper at `bin/[plugin-name].js`:

**Required commands**:
- `install` - Install plugin to Claude Code
- `uninstall` - Uninstall plugin from Claude Code
- `status` - Check installation status
- `help` - Display help information

**Example structure**:
```javascript
#!/usr/bin/env node
const commands = {
  install: () => { /* Copy plugin files to ~/.claude/ */ },
  uninstall: () => { /* Remove plugin files */ },
  status: () => { /* Check if installed */ },
  help: () => { /* Show usage */ }
};

const command = process.argv[2] || 'help';
if (commands[command]) {
  commands[command]();
} else {
  console.error(`Unknown command: ${command}`);
  commands.help();
  process.exit(1);
}
```

### Version Validation Script

**Required**: `scripts/validate-version.sh` must verify version consistency across:
- `package.json`
- `.claude-plugin/plugin.json`
- Referenced in `prepublishOnly` script

**Example**:
```bash
#!/bin/bash
set -e

PACKAGE_VERSION=$(node -p "require('./package.json').version")
PLUGIN_VERSION=$(node -p "require('./.claude-plugin/plugin.json').version")

if [ "$PACKAGE_VERSION" != "$PLUGIN_VERSION" ]; then
  echo "❌ Version mismatch!"
  echo "  package.json: $PACKAGE_VERSION"
  echo "  plugin.json: $PLUGIN_VERSION"
  exit 1
fi

echo "✅ All versions match: $PACKAGE_VERSION"
```

### Postinstall Messaging

**Required**: `postinstall.js` must provide clear next steps:

```javascript
#!/usr/bin/env node
console.log(`
✨ @theglitchking/plugin-name installed successfully!

📦 Quick Start:
  plugin-name install --scope user    # Install to Claude Code
  plugin-name status                   # Check installation
  plugin-name help                     # Show all commands

📚 Documentation: https://github.com/TheGlitchKing/plugin-name
`);
```

### NPM Publishing Checklist

Before publishing to NPM:

- [ ] Package name is scoped: `@theglitchking/[plugin-name]`
- [ ] `publishConfig.access` is set to `"public"`
- [ ] Version matches across package.json and plugin.json
- [ ] `bin/` CLI wrapper is executable (`chmod +x`)
- [ ] Version validation script exists and passes
- [ ] Postinstall message is informative
- [ ] All files listed in `files` array exist
- [ ] Test with `npm pack` and extract tarball
- [ ] Test CLI commands work from unpacked tarball
- [ ] CHANGELOG.md is updated for new version
- [ ] Git tag matches version (`vX.Y.Z`)

### Breaking Change Policy for NPM

**Unscoped → Scoped transition** (e.g., `plugin-name` → `@theglitchking/plugin-name`):
- **Requires**: MAJOR version bump
- **Requires**: MIGRATION.md document
- **Requires**: Deprecation notice on old package
- **Example**: hit-em-with-the-docs v1.0.0 → v2.0.0 (scoped)

**NPM-specific breaking changes**:
- Changing scope or package name
- Removing/renaming CLI commands
- Changing CLI argument formats
- Changing default installation scope

### marketplace.json NPM Entry

When plugin is distributed via NPM, marketplace.json must include:

```json
{
  "source": {
    "type": "npm",
    "package": "@theglitchking/plugin-name"
  },
  "installation": {
    "methods": [
      {
        "type": "npm",
        "command": "npm install -g @theglitchking/plugin-name && plugin-name install --scope user"
      },
      {
        "type": "npx",
        "command": "npx @theglitchking/plugin-name install --scope user"
      },
      {
        "type": "claude-marketplace",
        "command": "/plugin install TheGlitchKing/plugin-name"
      }
    ],
    "requirements": {
      "node": ">=16.0.0",
      "claude-code": ">=1.0.0"
    }
  }
}
```

**Installation method priority**:
1. NPM (global install) - Primary method
2. NPX (no installation) - Convenient alternative
3. Claude marketplace - Fallback
4. Manual (git clone) - Advanced users

## marketplace.json Standards

### Required Fields
```json
{
  "id": "plugin-name",                    // Required: kebab-case, unique
  "name": "plugin-name",                  // Required: matches id
  "displayName": "Plugin Name",           // Required: Title Case
  "type": "claude-plugin",                // Required: plugin type
  "version": "1.0.0",                     // Required: semver
  "description": "10-500 chars",          // Required: clear description
  "author": {                             // Required
    "name": "TheGlitchKing"
  },
  "repository": {                         // Required
    "type": "github",
    "owner": "TheGlitchKing",
    "repo": "plugin-name",
    "url": "https://github.com/TheGlitchKing/plugin-name"
  },
  "source": {                             // Required
    "type": "submodule",
    "path": "./plugins/plugin-name"
  },
  "installation": {                       // Required
    "methods": [                          // At least one method
      {
        "type": "claude-marketplace",
        "command": "/plugin install TheGlitchKing/plugin-name"
      }
    ],
    "requirements": {                     // Required
      "claude-code": ">=1.0.0"
    }
  },
  "category": "productivity",             // Required: from categories list
  "tags": ["tag1", "tag2"],              // Required: 1+ tags
  "keywords": ["keyword1"],              // Required: 1+ keywords
  "license": "MIT",                       // Required
  "homepage": "https://...",              // Required
  "status": "production-ready"            // Required
}
```

### Optional but Recommended Fields
```json
{
  "dependencies": {
    "requires": ["other-plugin"],         // Required plugins
    "recommends": ["helper-plugin"],      // Recommended plugins
    "includes": ["sub-plugin"]            // Bundled plugins
  },
  "features": {
    "hooks": ["SessionStart", "SessionEnd"],
    "commands": ["/command1", "/command2"],
    "skills": ["/skill1"],
    "mcpServers": ["server-name"],
    "agents": ["agent-name"]
  }
}
```

## Code Quality Standards

### Documentation
- **README completeness**: 100% - must cover all features
- **Code comments**: Required for complex logic
- **API documentation**: Required for libraries
- **Examples**: Must include working examples

### Testing
- **Unit tests**: Recommended coverage >70%
- **Integration tests**: Required for key workflows
- **Test command**: Must have `npm test` or equivalent
- **CI/CD**: Recommended to run tests automatically

### Code Style
- **Linting**: Must pass linter (ESLint, Pylint, etc.)
- **Formatting**: Must use consistent formatting (Prettier, Black, etc.)
- **Type checking**: Recommended for TypeScript/Python

### Security
- **No secrets**: Never commit API keys, tokens, or credentials
- **Input validation**: Always validate user input
- **Dependencies**: Keep dependencies up to date
- **Security policy**: Include SECURITY.md for reporting vulnerabilities

## Repository Structure Standards

### Claude Plugins
```
plugin-name/
├── .claude-plugin/
│   └── plugin.json
├── .claude/
│   ├── commands/
│   └── hooks/
├── agents/
├── skills/
├── scripts/
├── tests/
├── docs/
├── README.md
├── LICENSE
├── CHANGELOG.md
└── install.sh
```

### CLI Tools
```
plugin-name/
├── src/
│   ├── cli/
│   └── core/
├── dist/
├── tests/
├── docs/
├── package.json
├── tsconfig.json
├── README.md
├── LICENSE
└── CHANGELOG.md
```

## GitHub Repository Settings

### Branch Protection
- **Default branch**: `main` or `master`
- **Required**: Status checks must pass before merging
- **Recommended**: Require pull request reviews

### Topics/Tags
Add relevant GitHub topics:
- `claude-code`
- `claude-plugin`
- `documentation`
- `cli-tool`
- Plugin-specific tags

### Repository Settings
- **Description**: Clear one-line description
- **Website**: Link to documentation or marketplace
- **License**: Must be set in GitHub UI
- **Include**: README, LICENSE, .gitignore

## Installation Methods Standards

### Claude Marketplace
```json
{
  "type": "claude-marketplace",
  "command": "/plugin install TheGlitchKing/plugin-name"
}
```

### NPM
```json
{
  "type": "npm",
  "command": "npm install -g @theglitchking/plugin-name"
}
```

### Manual
```json
{
  "type": "manual",
  "steps": [
    "git clone https://github.com/TheGlitchKing/plugin-name.git",
    "cd plugin-name",
    "./install.sh --scope user"
  ]
}
```

## Quality Gates

Before adding to marketplace, plugins must pass:

1. **Schema validation**: `./scripts/validate-plugins.sh` passes
2. **README completeness**: All required sections present
3. **License**: Valid open source license
4. **Installation**: At least one installation method works
5. **Documentation**: Clear usage instructions
6. **Version**: Tagged release exists
7. **Repository**: Clean, organized structure

## Categories

Plugins must belong to one of these categories:

- **documentation**: Tools for managing documentation
- **productivity**: Tools enhancing development workflows
- **automation**: Tools for automating tasks
- **security**: Security-focused tools
- **testing**: Testing frameworks and tools
- **development**: Development utilities

## Status Levels

- **experimental**: Early development, may change significantly
- **beta**: Feature complete but needs more testing
- **production-ready**: Stable, tested, ready for production use
- **deprecated**: No longer maintained, use alternatives

## Deprecation Policy

When deprecating a plugin:

1. Update `status` to `deprecated`
2. Add deprecation notice to README
3. Update marketplace.json with alternatives
4. Keep in marketplace for 6 months minimum
5. Archive GitHub repository after removal

## Support Requirements

Plugin maintainers must:

1. **Respond to issues**: Within 1 week for critical issues
2. **Update dependencies**: Quarterly security updates
3. **Fix critical bugs**: Within 2 weeks of discovery
4. **Document breaking changes**: Clear migration guides
5. **Maintain compatibility**: Support latest Claude Code version

## Review Checklist

Before submitting plugin to marketplace:

- [ ] Repository name follows kebab-case convention
- [ ] README.md is comprehensive and complete
- [ ] LICENSE file exists (MIT recommended)
- [ ] CHANGELOG.md tracks all releases
- [ ] Plugin manifest (plugin.json or package.json) is valid
- [ ] Version follows semantic versioning
- [ ] Git tags exist for releases
- [ ] marketplace.json entry is complete
- [ ] Installation works on all supported platforms
- [ ] Documentation includes usage examples
- [ ] Tests pass (if applicable)
- [ ] No secrets or credentials committed
- [ ] GitHub repository is public
- [ ] Category and tags are appropriate

## Best Practices

### Documentation
- Include animated GIFs or screenshots
- Provide step-by-step tutorials
- Document all configuration options
- Include troubleshooting section

### Code
- Keep plugins focused (single responsibility)
- Minimize external dependencies
- Handle errors gracefully
- Provide helpful error messages

### Maintenance
- Release regularly (at least quarterly)
- Keep dependencies updated
- Respond to user feedback
- Monitor for security issues

### Community
- Welcome contributions
- Provide clear contribution guidelines
- Use GitHub Discussions or Issues
- Be responsive and friendly

## Non-Compliance

Plugins that don't meet standards:

1. **Warning**: First notification with 2-week fix period
2. **Temporary removal**: After 2 weeks if not fixed
3. **Permanent removal**: After 3 months of non-compliance
4. **Exceptions**: Security issues result in immediate removal
