# Plugin Development Guide

Guide for developing and contributing plugins to the Glitch Kingdom Marketplace.

> **Start here: adopt the shared runtime.** All new plugins in this marketplace must use [`@theglitchking/claude-plugin-runtime`](https://github.com/TheGlitchKing/claude-plugin-runtime) for postinstall, SessionStart update-nudge, and the `update` / `policy` / `status` / `relink` CLI subcommand surface. The runtime's [authoring scaffold](https://github.com/TheGlitchKing/claude-plugin-runtime/blob/main/docs/PLUGIN_AUTHORING_SCAFFOLD.md) has copy-paste templates for every file a new plugin needs.
>
> This doc covers the marketplace-side concerns: plugin types, listing your plugin, submission, validation. For the actual build/authoring step, jump to the scaffold.

## Canonical Plugin Shape (2026+)

Every plugin in this marketplace ships the same three files that wire it into the shared runtime:

**1. `scripts/link-skills.js`** (postinstall):
```js
#!/usr/bin/env node
import { runPostinstall } from "@theglitchking/claude-plugin-runtime";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const packageRoot = resolve(dirname(fileURLToPath(import.meta.url)), "..");

runPostinstall({
  packageName: "@theglitchking/<plugin-name>",
  pluginName: "<plugin-name>",
  configFile: "<plugin-name>.json",
  skillsDir: "skills",            // or null if the plugin ships no skills
  packageRoot,
  hookCommand: "node ./node_modules/@theglitchking/<plugin-name>/hooks/session-start.js",
});
```

**2. `hooks/session-start.js`** (update-check hook):
```js
#!/usr/bin/env node
import { runSessionStart } from "@theglitchking/claude-plugin-runtime";

await runSessionStart({
  packageName: "@theglitchking/<plugin-name>",
  pluginName: "<plugin-name>",
  configFile: "<plugin-name>.json",
  reconcile: (projectRoot) => { /* optional plugin-specific setup */ },
});
```

**3. `bin/<plugin-name>.js`** (CLI entry — commander-based):
```js
import { program } from "commander";
import { registerUpdateCommands } from "@theglitchking/claude-plugin-runtime";
// ... register your own subcommands
registerUpdateCommands(program, {
  packageName: "@theglitchking/<plugin-name>",
  pluginName: "<plugin-name>",
  configFile: "<plugin-name>.json",
});
program.parse();
```

Plus `commands/{update,policy,status,relink}.md` for slash-command parity (templates in the scaffold doc).

The result: every plugin exposes the same update-management surface, and bug fixes in the runtime propagate to every plugin on their next `npm update`.

## Plugin Types

The marketplace supports four plugin types:

### 1. claude-plugin
Native Claude Code plugins with hooks, commands, agents, skills, or MCP servers.

**Examples**: mind-glaive, aeon-loop, aeon-flux

**Key files**:
- `.claude-plugin/plugin.json` - Plugin manifest
- `.claude/commands/` - Slash commands
- `.claude/hooks/` - Lifecycle hooks
- `agents/` - Subagent definitions
- `skills/` - Skill implementations

### 2. cli-tool
Command-line tools usable with or without Claude Code.

**Examples**: hit-em-with-the-docs

**Key files**:
- `package.json` - NPM package configuration
- `src/cli/` - CLI implementation
- `bin/` - Executable scripts

### 3. library
Reusable code libraries imported into other projects.

**Key files**:
- Language-specific package file (package.json, setup.py, etc.)
- `src/` or `lib/` - Source code
- API documentation

### 4. mcp-server
Model Context Protocol servers for knowledge integration.

**Key files**:
- `server.py` or `server.js` - MCP server implementation
- `requirements.txt` or `package.json` - Dependencies
- MCP tool definitions

## Development Process

### 1. Create Your Plugin Repository

```bash
# Create a new repository for your plugin
mkdir my-awesome-plugin
cd my-awesome-plugin
git init

# Create basic structure
mkdir -p .claude-plugin src docs tests
touch README.md LICENSE
```

### 2. Define Plugin Manifest

Create `.claude-plugin/plugin.json`:

```json
{
  "name": "my-awesome-plugin",
  "version": "1.0.0",
  "description": "Does something awesome",
  "author": "Your Name",
  "license": "MIT",
  "keywords": ["claude", "plugin", "awesome"]
}
```

### 3. Implement Core Functionality

**For Claude Plugins**:

Create commands in `.claude/commands/`:
```markdown
---
description: My awesome command
allowed-tools: Read, Write, Bash
---

# Command implementation
```

Create hooks in `hooks/`:
```json
{
  "hooks": {
    "SessionStart": [{
      "matcher": "*",
      "command": "my-hook-script.sh"
    }]
  }
}
```

**For CLI Tools**:

Create executable in `bin/` or `src/cli/`:
```javascript
#!/usr/bin/env node
// CLI implementation
```

### 4. Write Documentation

Create a comprehensive README.md:
```markdown
# Plugin Name

## Overview
Brief description

## Features
- Feature 1
- Feature 2

## Installation
Step-by-step instructions

## Usage
Examples and commands

## Configuration
Options and settings

## Contributing
Guidelines for contributors

## License
MIT
```

### 5. Add Tests

Create tests in `tests/`:
```bash
tests/
├── unit/
├── integration/
└── fixtures/
```

### 6. Version Your Plugin

Use semantic versioning:
```bash
# Tag a release
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0
```

### 7. Publish Your Plugin

**Option A: GitHub Only**
- Push to GitHub
- Ready for marketplace submission

**Option B: NPM (for CLI tools)**
```bash
npm publish
```

**Option C: PyPI (for Python tools)**
```bash
python setup.py sdist bdist_wheel
twine upload dist/*
```

## Adding Plugin to Marketplace

### 1. Prepare Metadata

Create plugin metadata following the schema:

```json
{
  "id": "my-awesome-plugin",
  "name": "my-awesome-plugin",
  "displayName": "My Awesome Plugin",
  "type": "claude-plugin",
  "version": "1.0.0",
  "description": "Short description (10-500 chars)",
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
      "claude-code": ">=1.0.0",
      "bash": true
    }
  },
  "category": "productivity",
  "tags": ["tag1", "tag2"],
  "keywords": ["keyword1", "keyword2"],
  "license": "MIT",
  "homepage": "https://github.com/YourUsername/my-awesome-plugin",
  "status": "production-ready"
}
```

### 2. Fork Marketplace Repository

```bash
# Fork on GitHub, then clone
git clone https://github.com/YourUsername/glitch-kingdom-of-plugins.git
cd glitch-kingdom-of-plugins
```

### 3. Add Your Plugin as Submodule

```bash
git submodule add https://github.com/YourUsername/my-awesome-plugin.git plugins/my-awesome-plugin
```

### 4. Update marketplace.json

Add your plugin metadata to the `plugins` array in `marketplace.json`.

### 5. Validate Your Changes

```bash
# Validate marketplace.json
./scripts/validate-plugins.sh

# Generate catalog
./scripts/generate-catalog.sh
```

### 6. Test Installation

```bash
# Test your plugin installation
./scripts/install-plugin.sh my-awesome-plugin
```

### 7. Create Pull Request

```bash
git add .
git commit -m "feat: add my-awesome-plugin to marketplace"
git push origin main

# Create PR on GitHub
```

### 8. PR Checklist

- [ ] Plugin repository exists and is public
- [ ] README.md is comprehensive
- [ ] LICENSE file is present
- [ ] Plugin is tagged with semantic version
- [ ] marketplace.json entry is valid
- [ ] Validation script passes
- [ ] Installation instructions are clear
- [ ] Plugin has been tested

## Plugin Guidelines

### Required Files

All plugins must include:
- **README.md**: Comprehensive documentation
- **LICENSE**: Open source license (MIT recommended)
- **plugin.json** or **package.json**: Plugin metadata

### Code Quality

- Use consistent code style
- Include comments for complex logic
- Follow language-specific best practices
- Pass linting and formatting checks

### Documentation

- Clear installation instructions
- Usage examples
- API/command reference
- Troubleshooting section
- Contributing guidelines

### Testing

- Unit tests for core functionality
- Integration tests for key workflows
- CI/CD for automated testing
- Test coverage >70% (recommended)

### Security

- No hardcoded secrets or credentials
- Validate all user input
- Use secure dependencies
- Follow OWASP guidelines
- Include security policy

### Versioning

- Use semantic versioning
- Tag releases on GitHub
- Maintain CHANGELOG.md
- Document breaking changes

## Best Practices

### Plugin Structure

**Claude Plugins**:
```
my-plugin/
├── .claude-plugin/
│   └── plugin.json
├── .claude/
│   ├── commands/
│   └── hooks/
├── agents/
├── skills/
├── scripts/
├── docs/
├── tests/
├── README.md
├── LICENSE
└── install.sh
```

**CLI Tools**:
```
my-cli/
├── src/
│   ├── cli/
│   └── core/
├── bin/
├── tests/
├── docs/
├── package.json
├── README.md
└── LICENSE
```

### Naming Conventions

- **Plugin ID**: kebab-case (e.g., `my-awesome-plugin`)
- **Display Name**: Title Case (e.g., "My Awesome Plugin")
- **Repository**: kebab-case matching ID
- **Commands**: Namespaced (e.g., `/plugin/command`)

### Installation Methods

Provide multiple installation options:

```json
"installation": {
  "methods": [
    {
      "type": "claude-marketplace",
      "command": "/plugin install Owner/plugin"
    },
    {
      "type": "manual",
      "steps": [
        "git clone https://github.com/Owner/plugin.git",
        "cd plugin",
        "./install.sh"
      ]
    }
  ]
}
```

### Dependencies

Minimize external dependencies:
- List all requirements clearly
- Pin versions for stability
- Provide fallbacks when possible
- Document optional dependencies

### Configuration

Make plugins configurable:
- Use config files (JSON, YAML)
- Support environment variables
- Provide sensible defaults
- Document all options

## Maintenance

### Updating Your Plugin

1. Make changes in your plugin repository
2. Test thoroughly
3. Update version in plugin.json/package.json
4. Update CHANGELOG.md
5. Tag release: `git tag v1.1.0`
6. Push: `git push && git push --tags`

### Updating Marketplace Entry

After releasing a new version:

```bash
# In marketplace repo
cd plugins/my-awesome-plugin
git fetch --tags
git checkout v1.1.0
cd ../..

# Update marketplace.json version
# Run validation
./scripts/validate-plugins.sh

# Commit and PR
git add .
git commit -m "chore: update my-awesome-plugin to v1.1.0"
```

## Community Guidelines

### Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Help other contributors
- Follow project guidelines

### Contributing

1. Fork and clone
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit PR with clear description

### Issue Reporting

When reporting issues:
- Use issue templates
- Provide reproduction steps
- Include environment details
- Add relevant logs/screenshots

### Feature Requests

For new features:
- Check existing issues first
- Explain use case
- Describe expected behavior
- Consider implementation approach

## Support

### Getting Help

- **Documentation**: Read plugin and marketplace docs
- **Examples**: Check existing plugins for patterns
- **Issues**: Search/create issues on GitHub
- **Community**: Join discussions (coming soon)

### Resources

- [Marketplace Architecture](./ARCHITECTURE.md)
- [Installation Guide](./INSTALLATION_GUIDE.md)
- [JSON Schema](../schemas/plugin-schema.json)
- [Example Plugins](../plugins/)

## Advanced Topics

### Cross-Plugin Dependencies

Declare dependencies in marketplace.json:

```json
"dependencies": {
  "requires": ["other-plugin"],
  "recommends": ["helper-plugin"],
  "includes": ["bundled-plugin"]
}
```

### MCP Server Development

Create Model Context Protocol servers:

```python
# server.py
from mcp import Server, Tool

server = Server("my-server")

@server.tool()
def my_tool(query: str) -> str:
    """Tool description"""
    return "result"

server.run()
```

### GitHub Actions Integration

Create action.yml for CLI tools:

```yaml
name: 'My Plugin'
description: 'Plugin description'
inputs:
  command:
    description: 'Command to run'
    required: true
runs:
  using: 'node20'
  main: 'dist/index.js'
```

### CI/CD for Plugins

Example GitHub Actions workflow:

```yaml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm install
      - run: npm test
      - run: npm run lint
```

## FAQ

**Q: Can plugins be private?**
A: Yes, but they won't be in the public marketplace. You can still use the marketplace structure for private plugins.

**Q: How long does PR review take?**
A: Typically 1-2 weeks, depending on complexity and review queue.

**Q: Can I update my plugin frequently?**
A: Yes, but marketplace updates are manual. Consider major releases for marketplace updates, with minor updates in your repo.

**Q: What if my plugin has breaking changes?**
A: Increment major version, document breaking changes clearly, and provide migration guide.

**Q: Can plugins depend on each other?**
A: Yes, declare dependencies in marketplace.json. The installer will check them.

**Q: Is there a plugin size limit?**
A: No hard limit, but keep plugins focused and lightweight. Large plugins may be rejected.

## Examples

Check these plugins for reference:
- [mind-glaive](https://github.com/TheGlitchKing/mind-glaive) - Full-featured Claude plugin
- [hit-em-with-the-docs](https://github.com/TheGlitchKing/hit-em-with-the-docs) - CLI tool with GitHub Action
- [aeon-loop](https://github.com/TheGlitchKing/aeon-loop) - Complex plugin with dependencies

## Questions?

Open an issue on the [marketplace repository](https://github.com/TheGlitchKing/glitch-kingdom-of-plugins/issues) with the `question` label.
