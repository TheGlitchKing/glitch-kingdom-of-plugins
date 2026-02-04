---
title: Adding New Plugins to the Marketplace
tier: reference
domains:
  - quickstart
  - troubleshooting
audience:
  - developers
  - admin
tags:
  - api
  - testing
  - security
  - node
  - python
status: draft
last_updated: 2026-02-03T00:00:00.000Z
version: 1.0.0
purpose: This guide provides the complete procedure for adding a new plugin to
  the Glitch Kingdom Marketplace, from initial evaluation through final
  integration and publication.
estimated_read_time: 9 minutes
word_count: 1611
last_validated: 2026-02-04
backlinks: []
---

# Adding New Plugins to the Marketplace

## Overview

This guide provides the complete procedure for adding a new plugin to the Glitch Kingdom Marketplace, from initial evaluation through final integration and publication.

## Prerequisites

Before adding a plugin, ensure you have:

- **Repository access**: Write access to the marketplace repository
- **Tools installed**:
  - Git 2.0+ with submodule support
  - jq (JSON parsing)
  - Bash shell
  - Node.js 20+ (for validation scripts)
- **Plugin requirements met**: The plugin follows all standards in `plugin-standards.md`

## Quick Reference

```bash
# 1. Evaluate plugin
./scripts/evaluate-plugin.sh <plugin-repo-url>

# 2. Add as submodule
git submodule add <repo-url> plugins/<plugin-name>

# 3. Add to marketplace.json
# (edit file)

# 4. Validate
./scripts/validate-plugins.sh

# 5. Generate catalog
./scripts/generate-catalog.sh

# 6. Commit and push
git add .
git commit -m "feat: add <plugin-name> plugin"
git push origin main
```

## Detailed Procedure

### Phase 1: Initial Evaluation

#### Step 1: Review Plugin Repository

Before adding, verify the plugin meets baseline requirements:

**Repository Checklist**:
- [ ] Repository is public on GitHub
- [ ] Has comprehensive README.md
- [ ] Has LICENSE file (OSI-approved license)
- [ ] Has CHANGELOG.md or similar version tracking
- [ ] Code is well-documented
- [ ] Has at least one tagged release
- [ ] Repository name follows kebab-case convention

**Quality Checklist**:
- [ ] Code passes basic linting/formatting checks
- [ ] No secrets or credentials committed
- [ ] Dependencies are reasonable (not excessive)
- [ ] Has working installation instructions
- [ ] Includes usage examples

**Plugin Type Checklist**:

For **claude-plugin**:
- [ ] Has `.claude-plugin/plugin.json` manifest
- [ ] Provides hooks, commands, agents, or skills
- [ ] Compatible with Claude Code 1.0+

For **cli-tool**:
- [ ] Has `package.json` with bin configuration
- [ ] Published to NPM or provides npx support
- [ ] Includes `--help` and `--version` flags
- [ ] Works on Linux, macOS, Windows (WSL2)

For **library**:
- [ ] Has proper package configuration
- [ ] Includes API documentation
- [ ] Has published versions
- [ ] Includes usage examples

For **mcp-server**:
- [ ] Implements MCP protocol correctly
- [ ] Has server.py or server.js
- [ ] Documents all MCP tools
- [ ] Handles errors gracefully

#### Step 2: Test Plugin Installation

Install the plugin manually to verify it works:

**For CLI Tools**:
```bash
npm install -g <package-name>
<command> --version
<command> --help
# Test basic functionality
```

**For Claude Plugins**:
```bash
git clone <repo-url>
cd <plugin-name>
./install.sh --scope user
# Test in Claude Code
```

**For MCP Servers**:
```bash
git clone <repo-url>
cd <plugin-name>
pip install -r requirements.txt
python server.py
# Test with MCP client
```

#### Step 3: Document Installation Methods

Identify all available installation methods:

1. **Claude Marketplace**: `/plugin install owner/plugin-name`
2. **NPM Global**: `npm install -g @scope/plugin-name`
3. **NPX**: `npx plugin-name`
4. **Manual Git Clone**: `git clone && ./install.sh`
5. **GitHub Action**: `uses: owner/plugin-name@v1`

#### Step 4: Identify Dependencies

Check if the plugin has dependencies on other plugins:

**Required dependencies** (`requires`):
- Plugins that MUST be installed for this plugin to work
- Example: Plugin requires another plugin's API

**Recommended dependencies** (`recommends`):
- Plugins that enhance functionality but aren't required
- Example: mind-glaive recommended for aeon-loop

**Bundled dependencies** (`includes`):
- Plugins that come bundled with this plugin
- Example: aeon-loop includes aeon-flux

### Phase 2: Add Plugin to Marketplace

#### Step 5: Add Git Submodule

Add the plugin repository as a Git submodule:

```bash
cd /mnt/e/docker-containers/glitch-kingdom-of-plugins

# Add submodule
git submodule add https://github.com/<owner>/<plugin-name>.git plugins/<plugin-name>

# Navigate to submodule
cd plugins/<plugin-name>

# Check available tags
git tag -l

# Checkout latest stable version (recommended)
git checkout v1.0.0
# OR checkout main branch for latest
git checkout main

# Return to marketplace root
cd ../..

# Stage submodule
git add .gitmodules plugins/<plugin-name>
```

**Best Practice**: Pin to a specific tag (not branch) for stability.

**Troubleshooting**:
- If repo is private: Ensure you have access and use SSH URL
- If submodule fails: Check URL is correct and repository exists
- If permission denied: Check GitHub authentication

#### Step 6: Create marketplace.json Entry

Add the plugin to `marketplace.json`:

**Template for Claude Plugin**:
```json
{
  "id": "plugin-name",
  "name": "plugin-name",
  "displayName": "Plugin Name",
  "type": "claude-plugin",
  "version": "1.0.0",
  "description": "Clear, concise description (10-500 characters)",
  "author": {
    "name": "Plugin Author",
    "url": "https://github.com/author",
    "email": "author@example.com"
  },
  "repository": {
    "type": "github",
    "owner": "PluginOwner",
    "repo": "plugin-name",
    "url": "https://github.com/PluginOwner/plugin-name"
  },
  "source": {
    "type": "submodule",
    "path": "./plugins/plugin-name"
  },
  "installation": {
    "methods": [
      {
        "type": "claude-marketplace",
        "command": "/plugin install PluginOwner/plugin-name",
        "description": "Install via Claude Code marketplace (recommended)"
      },
      {
        "type": "manual",
        "steps": [
          "git clone https://github.com/PluginOwner/plugin-name.git",
          "cd plugin-name",
          "./install.sh --scope user"
        ],
        "description": "Manual installation for development"
      }
    ],
    "requirements": {
      "claude-code": ">=1.0.0",
      "bash": "required",
      "python": ">=3.9.0",
      "node": ">=20.0.0"
    }
  },
  "category": "productivity",
  "tags": ["tag1", "tag2", "tag3"],
  "keywords": ["keyword1", "keyword2"],
  "license": "MIT",
  "homepage": "https://github.com/PluginOwner/plugin-name",
  "documentation": "https://github.com/PluginOwner/plugin-name#readme",
  "issues": "https://github.com/PluginOwner/plugin-name/issues",
  "status": "production-ready",
  "features": {
    "hooks": ["SessionStart", "SessionEnd"],
    "commands": ["/command1", "/command2"],
    "skills": ["/skill1"],
    "agents": ["agent-name"],
    "mcpServers": ["server-name"]
  },
  "dependencies": {
    "requires": [],
    "recommends": ["other-plugin"],
    "includes": []
  }
}
```

**Template for CLI Tool**:
```json
{
  "id": "plugin-name",
  "name": "plugin-name",
  "displayName": "Plugin Name",
  "type": "cli-tool",
  "version": "1.0.0",
  "description": "Clear, concise description",
  "author": {
    "name": "Plugin Author",
    "url": "https://github.com/author"
  },
  "repository": {
    "type": "github",
    "owner": "PluginOwner",
    "repo": "plugin-name",
    "url": "https://github.com/PluginOwner/plugin-name"
  },
  "source": {
    "type": "submodule",
    "path": "./plugins/plugin-name"
  },
  "installation": {
    "methods": [
      {
        "type": "npm",
        "command": "npm install -g @scope/plugin-name",
        "description": "Install globally via NPM"
      },
      {
        "type": "npx",
        "command": "npx @scope/plugin-name",
        "description": "Run without installation"
      }
    ],
    "requirements": {
      "node": ">=20.0.0",
      "npm": ">=9.0.0"
    }
  },
  "category": "development",
  "tags": ["cli", "tool"],
  "keywords": ["keyword1"],
  "license": "MIT",
  "homepage": "https://github.com/PluginOwner/plugin-name",
  "npmPackage": "@scope/plugin-name",
  "status": "production-ready"
}
```

**Field Guidelines**:

- **id**: Must match repository name (kebab-case)
- **displayName**: Title Case for display
- **version**: Use semantic versioning (MAJOR.MINOR.PATCH)
- **description**: 10-500 characters, clear and concise
- **category**: One of: documentation, productivity, automation, security, testing, development
- **status**: One of: experimental, beta, production-ready, deprecated
- **tags**: 1-10 relevant tags
- **keywords**: 1-20 searchable keywords

#### Step 7: Validate marketplace.json

Run validation to ensure the entry is correct:

```bash
./scripts/validate-plugins.sh
```

**Expected output**:
```
Validating marketplace.json...
✓ JSON syntax is valid
✓ Schema validation passed
✓ Semantic versioning is valid for all plugins
✓ All repository URLs are valid
✓ All categories are valid
✓ Submodule paths exist
✓ No duplicate plugin IDs

Validation successful!
```

**Common Errors**:

1. **Invalid JSON syntax**:
   ```
   ✗ JSON syntax is invalid
   ```
   - Fix: Check for missing commas, brackets, quotes
   - Use `jq . marketplace.json` to validate JSON

2. **Schema validation failed**:
   ```
   ✗ Schema validation failed
   ```
   - Fix: Check required fields are present
   - Verify field types match schema

3. **Invalid semantic version**:
   ```
   ✗ Invalid version: "1.0"
   ```
   - Fix: Use format MAJOR.MINOR.PATCH (e.g., "1.0.0")

4. **Invalid category**:
   ```
   ✗ Invalid category: "invalid-category"
   ```
   - Fix: Use one of the allowed categories

5. **Duplicate plugin ID**:
   ```
   ✗ Duplicate plugin ID: "plugin-name"
   ```
   - Fix: Ensure plugin ID is unique

### Phase 3: Generate and Test

#### Step 8: Generate Plugin Catalog

Generate human-readable and machine-readable catalogs:

```bash
./scripts/generate-catalog.sh
```

**Generated files**:
- `catalog/index.md` - Human-readable plugin list
- `catalog/plugins.json` - Machine-readable metadata
- `catalog/by-category/<category>.md` - Category pages

**Verify output**:
```bash
# Check catalog was generated
ls -la catalog/

# View generated index
cat catalog/index.md

# Check category page
cat catalog/by-category/productivity.md
```

#### Step 9: Test Installation

Test all installation methods for the new plugin:

**Test 1: Clone marketplace with submodules**:
```bash
cd /tmp
git clone --recursive <marketplace-url>
cd glitch-kingdom-of-plugins
ls plugins/<plugin-name>
# Should show plugin files
```

**Test 2: Use marketplace installer**:
```bash
./scripts/install-plugin.sh <plugin-name>
# Follow displayed instructions
# Verify installation works
```

**Test 3: Direct installation**:
Follow the installation instructions from marketplace.json and verify they work.

**Test 4: Check documentation links**:
```bash
# All URLs should be accessible
curl -I <plugin-homepage>
curl -I <plugin-documentation>
curl -I <plugin-repository>
```

#### Step 10: Update Documentation

Update marketplace documentation to reference the new plugin:

**Update README.md**:
- Add plugin to features list
- Add to plugin showcase section
- Include in quick start if relevant

**Update INSTALLATION_GUIDE.md**:
- Add plugin-specific installation section
- Include any special requirements
- Add to troubleshooting if needed

**Update catalog/index.md** (auto-generated):
- Regenerate catalog: `./scripts/generate-catalog.sh`

### Phase 4: Finalize and Publish

#### Step 11: Commit Changes

Commit all changes with a descriptive message:

```bash
# Stage all changes
git add .gitmodules plugins/<plugin-name> marketplace.json catalog/ docs/

# Commit with conventional commit format
git commit -m "feat: add <plugin-name> plugin

- Add <plugin-name> as git submodule
- Add marketplace.json entry with installation methods
- Update documentation with plugin details
- Regenerate catalog

Closes #<issue-number>
"

# Push to remote
git push origin main
```

**Commit Message Format**:
- Type: `feat` (new plugin), `fix` (plugin update), `docs` (documentation only)
- Subject: Clear description of what was added
- Body: Bullet points with details
- Footer: Reference issues/PRs

#### Step 12: Create Release (Optional)

If this is a significant addition, create a marketplace release:

```bash
# Tag the release
git tag -a v1.1.0 -m "Release v1.1.0: Add <plugin-name> plugin"

# Push tag
git push origin v1.1.0
```

**Update CHANGELOG.md**:
```markdown
## [1.1.0] - 2026-02-03
### Added
- New plugin: <plugin-name> - <short-description>
- Installation via <installation-methods>

### Changed
- Updated catalog with new plugin
- Enhanced documentation
```

#### Step 13: Notify Community

Announce the new plugin:

1. **GitHub**: Create release notes
2. **README.md**: Plugin is now listed
3. **Documentation**: Updated installation guide
4. **Issues**: Close related feature requests

### Phase 5: Post-Addition Verification

#### Step 14: Verify Integration

**Checklist**:
- [ ] Plugin appears in `catalog/index.md`
- [ ] Plugin has category page in `catalog/by-category/`
- [ ] All installation methods documented
- [ ] Submodule correctly configured
- [ ] marketplace.json validates successfully
- [ ] Documentation links work
- [ ] GitHub repository topics updated
- [ ] README.md lists the plugin

#### Step 15: Monitor Initial Usage

**First Week**:
- Monitor GitHub issues for installation problems
- Check for broken links or missing documentation
- Respond to user questions promptly
- Update documentation based on feedback

**First Month**:
- Verify plugin updates sync correctly
- Check compatibility with other plugins
- Review usage patterns
- Update marketplace.json if needed

## Common Issues and Solutions

### Issue: Submodule Already Exists

**Error**:
```
A git directory for 'plugins/plugin-name' is found locally
```

**Solution**:
```bash
# Remove existing submodule
git submodule deinit -f plugins/<plugin-name>
git rm -f plugins/<plugin-name>
rm -rf .git/modules/plugins/<plugin-name>

# Re-add submodule
git submodule add <repo-url> plugins/<plugin-name>
```

### Issue: Validation Fails

**Error**:
```
✗ Schema validation failed
```

**Solution**:
1. Check JSON syntax: `jq . marketplace.json`
2. Compare entry against schema: `cat schemas/plugin-schema.json`
3. Verify all required fields are present
4. Check field types match schema
5. Use a JSON schema validator for detailed errors

### Issue: Catalog Generation Fails

**Error**:
```
./scripts/generate-catalog.sh: line 42: jq: command not found
```

**Solution**:
```bash
# Install jq
sudo apt-get install jq  # Ubuntu/Debian
brew install jq          # macOS

# Retry generation
./scripts/generate-catalog.sh
```

### Issue: Installation Method Doesn't Work

**Problem**: User reports installation instructions don't work

**Solution**:
1. Test installation on clean system
2. Update installation.methods in marketplace.json
3. Add troubleshooting to INSTALLATION_GUIDE.md
4. Update plugin repository's README.md
5. Regenerate catalog
6. Commit and push fixes

### Issue: Plugin Version Mismatch

**Problem**: marketplace.json version doesn't match plugin's actual version

**Solution**:
```bash
# Check plugin version
cd plugins/<plugin-name>
git describe --tags
# or
cat package.json | jq .version
# or
cat .claude-plugin/plugin.json | jq .version

# Update marketplace.json to match
cd ../..
# Edit marketplace.json with correct version

# Validate
./scripts/validate-plugins.sh
```

## Automation Options

### GitHub Actions for Auto-Adding Plugins

Create `.github/workflows/add-plugin.yml`:

```yaml
name: Add Plugin from PR

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  validate-plugin-addition:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: true

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install jq
        run: sudo apt-get install -y jq

      - name: Validate marketplace.json
        run: ./scripts/validate-plugins.sh

      - name: Generate catalog
        run: ./scripts/generate-catalog.sh

      - name: Test plugin installation
        run: |
          for plugin in $(jq -r '.plugins[].id' marketplace.json); do
            ./scripts/install-plugin.sh "$plugin" --dry-run
          done

      - name: Comment on PR
        uses: actions/github-script@v7
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '✅ Plugin validation passed! Ready for review.'
            })
```

### Script for Bulk Plugin Addition

Create `scripts/bulk-add-plugins.sh`:

```bash
#!/bin/bash

# Read plugins from CSV file
# Format: repo_url,plugin_name,type,category

while IFS=, read -r repo_url plugin_name type category; do
  echo "Adding $plugin_name..."

  # Add submodule
  git submodule add "$repo_url" "plugins/$plugin_name"

  # Create marketplace.json entry (requires manual editing)
  echo "TODO: Add marketplace.json entry for $plugin_name"

  # Validate
  ./scripts/validate-plugins.sh

  # Generate catalog
  ./scripts/generate-catalog.sh

  # Commit
  git add .
  git commit -m "feat: add $plugin_name plugin"

done < plugins-to-add.csv

git push origin main
```

## Best Practices

### 1. Test Before Adding
Always test the plugin manually before adding to marketplace. Verify:
- Installation works
- Basic functionality works
- Documentation is accurate
- No security concerns

### 2. Pin to Stable Versions
Use tagged releases (v1.0.0) instead of branch names (main) for submodules. This ensures marketplace stability.

### 3. Complete Documentation
Ensure marketplace.json has all relevant information:
- All installation methods
- All requirements
- All features
- Dependencies clearly stated

### 4. Maintain Quality Standards
Only add plugins that meet quality standards:
- Comprehensive README
- Open source license
- No secrets committed
- Reasonable dependencies
- Working installation

### 5. Monitor Dependencies
If adding a plugin with dependencies:
- Ensure dependencies are already in marketplace OR
- Add dependencies first, then the plugin

### 6. Communicate with Plugin Author
Before adding a plugin:
- Contact the plugin author
- Get permission to include in marketplace
- Ask about preferred installation method
- Coordinate on documentation

### 7. Version Consistency
Ensure version in marketplace.json matches:
- Git tag in submodule
- package.json version (for NPM packages)
- plugin.json version (for Claude plugins)

### 8. Regular Updates
Plan to update plugins regularly:
- Weekly: Check for new releases
- Monthly: Update submodules
- Quarterly: Review all plugins

## Checklist for Adding a Plugin

Use this checklist for every plugin addition:

### Pre-Addition
- [ ] Plugin repository reviewed
- [ ] README.md is comprehensive
- [ ] LICENSE file exists (OSI-approved)
- [ ] Installation instructions tested
- [ ] Plugin type identified
- [ ] Requirements documented
- [ ] Installation methods identified
- [ ] Dependencies identified

### During Addition
- [ ] Git submodule added successfully
- [ ] Submodule pinned to stable version
- [ ] marketplace.json entry created
- [ ] All required fields filled
- [ ] Validation passed
- [ ] Catalog generated successfully
- [ ] Installation tested

### Post-Addition
- [ ] Documentation updated
- [ ] README.md includes plugin
- [ ] INSTALLATION_GUIDE.md updated
- [ ] Changelog updated
- [ ] Changes committed with clear message
- [ ] Changes pushed to remote
- [ ] Release created (if applicable)
- [ ] Community notified

### Verification
- [ ] Plugin appears in catalog
- [ ] Installation methods work
- [ ] Documentation links work
- [ ] No broken links
- [ ] GitHub topics updated

## Maintenance After Addition

### Weekly Tasks
- Monitor GitHub issues for the plugin
- Check for new plugin versions
- Respond to user questions

### Monthly Tasks
- Update plugin submodule to latest stable version
- Update marketplace.json version
- Regenerate catalog
- Review usage and feedback

### Quarterly Tasks
- Review plugin quality standards compliance
- Check for security vulnerabilities
- Update documentation as needed
- Test all installation methods

## Support and Help

### Getting Help
- **Marketplace issues**: Open issue in marketplace repository
- **Plugin issues**: Open issue in plugin repository
- **Questions**: Use GitHub Discussions

### Contributing
See `PLUGIN_DEVELOPMENT.md` for guidelines on:
- Plugin development standards
- Testing requirements
- Documentation requirements
- Code quality standards

## Conclusion

Adding a plugin to the marketplace is a multi-step process that ensures quality and maintainability. Follow this procedure carefully to maintain marketplace integrity and provide a great user experience.

For questions or improvements to this procedure, open an issue or pull request in the marketplace repository.
