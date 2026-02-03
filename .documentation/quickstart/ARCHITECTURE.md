---
title: Marketplace Architecture
tier: reference
domains:
  - quickstart
audience:
  - developers
  - admin
tags:
  - ci/cd
  - testing
  - security
  - performance
status: draft
last_updated: 2026-02-03T00:00:00.000Z
version: 1.0.0
purpose: Documentation for marketplace architecture
estimated_read_time: 6 minutes
word_count: 1032
last_validated: 2026-02-03
backlinks: []
---

# Marketplace Architecture

## Overview

The Glitch Kingdom Plugin Marketplace uses a hybrid architecture combining Git submodules with a centralized registry to provide unified plugin discovery while maintaining complete code-level independence for each plugin.

## Design Principles

### 1. Code Independence
Each plugin maintains its own:
- Git repository
- Development workflow
- Release cycle
- Version management
- Issue tracking

### 2. Centralized Discovery
The marketplace provides:
- Single source of truth for plugin metadata
- Unified installation instructions
- Cross-plugin dependency management
- Version compatibility tracking

### 3. Multiple Distribution Channels
Plugins can be distributed through:
- Git submodules (for developers)
- NPM packages (for CLI tools)
- Claude marketplace (for Claude plugins)
- Manual installation (for all plugins)

## Architecture Components

```
glitch-kingdom-of-plugins/
├── marketplace.json          # Central registry (single source of truth)
├── schemas/
│   └── plugin-schema.json    # JSON schema for validation
├── plugins/                  # Git submodules
│   ├── hit-em-with-the-docs/ # → GitHub repo
│   ├── mind-glaive/          # → GitHub repo
│   └── aeon-flux/            # → GitHub repo
├── scripts/                  # Helper scripts
├── docs/                     # Documentation
└── catalog/                  # Generated catalogs
```

## Core Concepts

### Git Submodules

**What they are**: Git submodules are references to other Git repositories at specific commits.

**Why we use them**:
- Preserves plugin independence
- Maintains separate git history per plugin
- Allows different release cycles
- Enables direct development in plugin repos

**How they work**:
```bash
# Add a plugin as submodule
git submodule add https://github.com/TheGlitchKing/plugin-name.git plugins/plugin-name

# Clone marketplace with all plugins
git clone --recursive https://github.com/TheGlitchKing/glitch-kingdom-of-plugins.git

# Update submodules to latest versions
git submodule update --remote --merge
```

### Centralized Registry (marketplace.json)

The `marketplace.json` file is the **single source of truth** for:

- Plugin metadata (name, description, version)
- Installation methods and requirements
- Categories and tags
- Dependencies and compatibility
- Repository URLs

**Example plugin entry**:
```json
{
  "id": "mind-glaive",
  "name": "mind-glaive",
  "displayName": "Mind Glaive",
  "type": "claude-plugin",
  "version": "1.0.0",
  "description": "Intelligent memory management...",
  "repository": {
    "type": "github",
    "owner": "TheGlitchKing",
    "repo": "mind-glaive",
    "url": "https://github.com/TheGlitchKing/mind-glaive"
  },
  "source": {
    "type": "submodule",
    "path": "./plugins/mind-glaive"
  },
  "installation": {
    "methods": [...],
    "requirements": {...}
  }
}
```

### Plugin Types

The marketplace supports multiple plugin types:

1. **claude-plugin**: Native Claude Code plugins with hooks, commands, agents
2. **cli-tool**: Command-line tools (can be used with or without Claude)
3. **library**: Reusable code libraries
4. **mcp-server**: Model Context Protocol servers

Each type has different installation methods and requirements.

## Data Flow

### User Discovery Flow

```
User → README.md → catalog/index.md → marketplace.json → Plugin repo
   ↓
   └→ scripts/install-plugin.sh → Installation instructions
```

### Plugin Update Flow

```
Plugin repo (new release)
   ↓
   └→ Tag release (v1.1.0)
       ↓
       └→ Marketplace maintainer updates submodule
           ↓
           └→ cd plugins/plugin-name && git checkout v1.1.0
               ↓
               └→ Update marketplace.json version
                   ↓
                   └→ scripts/generate-catalog.sh
                       ↓
                       └→ Commit to marketplace repo
```

### Automated Sync Flow (CI/CD)

```
Weekly cron job
   ↓
   └→ scripts/sync-submodules.sh
       ↓
       ├→ git submodule update --remote
       ├→ Detect version changes
       ├→ Update marketplace.json
       └→ Create PR with changes
```

## Version Management

### Semantic Versioning

All plugins and the marketplace use semantic versioning (MAJOR.MINOR.PATCH):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Version Pinning Strategy

**Marketplace**: Pins submodules to specific commits/tags for stability

**Plugins**: Use latest stable release by default, allow users to choose versions

**Example**:
```bash
# Pin to specific version
cd plugins/mind-glaive
git checkout v1.0.0

# Track latest
git checkout main
git pull
```

## Dependency Management

### Plugin Dependencies

Plugins can declare dependencies:

```json
{
  "dependencies": {
    "requires": ["other-plugin"],    // Must be installed
    "recommends": ["helper-plugin"], // Suggested
    "includes": ["sub-plugin"]       // Bundled with this plugin
  }
}
```

### Dependency Resolution

The `install-plugin.sh` script checks dependencies and:
1. Validates required plugins are available
2. Warns about recommended plugins
3. Automatically handles included plugins

## Installation Mechanisms

### Method 1: Git Submodules (Developers)

**Best for**: Developers who want all plugins or want to contribute

```bash
git clone --recursive https://github.com/TheGlitchKing/glitch-kingdom-of-plugins.git
cd glitch-kingdom-of-plugins
./scripts/install-plugin.sh mind-glaive
```

**Pros**:
- All plugins available locally
- Easy to update
- Can contribute directly

**Cons**:
- Larger download
- Requires Git knowledge

### Method 2: Direct Plugin Installation (Users)

**Best for**: Users who want specific plugins

```bash
# Claude plugins
/plugin install TheGlitchKing/mind-glaive

# CLI tools
npm install -g hit-em-with-the-docs
```

**Pros**:
- Minimal download
- Official installation method
- Automatic updates

**Cons**:
- Must install each plugin separately

### Method 3: Manual Installation (Advanced)

**Best for**: Custom setups or development

```bash
git clone https://github.com/TheGlitchKing/mind-glaive.git
cd mind-glaive
./install.sh --scope user
```

**Pros**:
- Full control
- Can modify plugins
- Offline installation

**Cons**:
- Manual update process
- More steps required

## Marketplace Maintenance

### Weekly Tasks

1. **Sync submodules**: `./scripts/sync-submodules.sh`
2. **Validate**: `./scripts/validate-plugins.sh`
3. **Generate catalog**: `./scripts/generate-catalog.sh`
4. **Test installations**: Verify each plugin still installs correctly

### Monthly Tasks

1. **Review plugin updates**: Check for new versions
2. **Update documentation**: Ensure docs are current
3. **Test compatibility**: Verify plugins work together
4. **Security audit**: Check for vulnerabilities

### Release Process

1. Update plugin submodules to new versions
2. Update marketplace.json with new versions
3. Run validation
4. Regenerate catalog
5. Test installation flows
6. Tag marketplace release
7. Update README with release notes

## CI/CD Integration

### Automated Workflows

**Plugin Sync Workflow** (`.github/workflows/sync-plugins.yml`):
- Runs weekly
- Updates submodules
- Creates PR with changes
- Runs validation tests

**Validation Workflow** (`.github/workflows/validate.yml`):
- Runs on every PR and push
- Validates marketplace.json schema
- Checks submodule accessibility
- Verifies script executability

### Testing Strategy

1. **Unit tests**: Validate individual components
2. **Integration tests**: Test cross-plugin interactions
3. **Installation tests**: Verify each installation method
4. **Smoke tests**: Quick validation of core functionality

## Scalability

### Adding New Plugins

1. Develop plugin in its own repository
2. Tag a stable release
3. Add as submodule: `git submodule add <repo-url> plugins/<name>`
4. Add metadata to marketplace.json
5. Run validation
6. Submit PR

### Growing the Marketplace

The architecture supports:
- Unlimited plugins (submodules are lightweight)
- Multiple categories
- Complex dependency graphs
- Different plugin types
- Community contributions

### Performance Considerations

- Submodules are cloned on-demand
- Catalog files are pre-generated (not dynamically created)
- JSON schema validation is fast
- Scripts are optimized for performance

## Security

### Repository Access

- Marketplace repository: Public
- Plugin repositories: Public (by default)
- Installation scripts: Reviewed and validated

### Validation

- JSON schema validation prevents malformed metadata
- Scripts validate URLs before using them
- Submodule hashes prevent tampering
- Installation methods are explicit (no arbitrary code execution)

### Best Practices

1. Always use HTTPS for Git URLs
2. Pin submodules to tags, not branches
3. Review plugin code before installation
4. Keep dependencies minimal
5. Use semantic versioning strictly

## Future Enhancements

### Planned Features

1. **Web UI**: Browser-based marketplace interface
2. **Plugin Search**: Full-text search across plugins
3. **Compatibility Matrix**: Version compatibility tracking
4. **Analytics**: Download and usage statistics
5. **Community Submissions**: PR-based plugin additions
6. **Automated Testing**: CI/CD for plugin testing
7. **Dependency Graph**: Visual dependency visualization

### Extensibility

The architecture is designed to support:
- New plugin types
- Additional installation methods
- Custom categories
- Plugin ratings and reviews
- Multi-language support
- Private plugin repositories

## Trade-offs

### Git Submodules vs Monorepo

**Choice**: Git submodules

**Rationale**:
- Preserves plugin independence ✅
- Separate git histories ✅
- Different release cycles ✅
- Individual plugin forks possible ✅

**Trade-offs**:
- More complex for beginners ⚠️
- Two-step update process ⚠️
- Submodule management required ⚠️

### Centralized vs Federated

**Choice**: Centralized marketplace.json

**Rationale**:
- Single source of truth ✅
- Easy validation ✅
- Simple for users ✅

**Trade-offs**:
- Manual updates required ⚠️
- Bottleneck for rapid releases ⚠️
- Central maintenance burden ⚠️

## Conclusion

The hybrid architecture balances plugin independence with marketplace convenience. Git submodules maintain separation while the centralized registry provides discovery and validation. This design scales well and supports diverse plugin types while keeping maintenance manageable.

For questions or suggestions about the architecture, please open an issue on GitHub.
