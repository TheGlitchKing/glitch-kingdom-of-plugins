---
title: Marketplace Maintainer Quickstart
tier: reference
domains:
  - troubleshooting
  - quickstart
  - quickstart
audience:
  - devops
  - admin
tags:
  - ci/cd
  - node
status: draft
last_updated: 2026-02-03T00:00:00.000Z
version: 1.0.0
purpose: Welcome to the Glitch Kingdom Plugin Marketplace maintainer team! This
  guide will get you up and running quickly with the essential knowledge and
  tools you need.
estimated_read_time: 6 minutes
word_count: 1155
last_validated: 2026-02-04
backlinks: []
---

# Marketplace Maintainer Quickstart

## Welcome

Welcome to the Glitch Kingdom Plugin Marketplace maintainer team! This guide will get you up and running quickly with the essential knowledge and tools you need.

## Your First Day

### 1. Setup Your Environment

**Clone the marketplace repository**:
```bash
# Clone with all submodules
git clone --recursive https://github.com/TheGlitchKing/glitch-kingdom-of-plugins.git
cd glitch-kingdom-of-plugins

# If you already cloned without --recursive
git submodule init
git submodule update
```

**Install required tools**:
```bash
# Check Git version (need 2.0+)
git --version

# Install jq for JSON parsing
# Ubuntu/Debian:
sudo apt-get install jq

# macOS:
brew install jq

# Verify jq
jq --version

# Install Node.js 20+ (for hit-em-with-the-docs)
node --version  # Should be v20.0.0 or higher

# Install hit-em-with-the-docs globally
npm install -g hit-em-with-the-docs

# Verify installation
hewtd --version
```

**Make scripts executable**:
```bash
chmod +x scripts/*.sh
```

### 2. Understand the Repository Structure

```
glitch-kingdom-of-plugins/
├── marketplace.json          # ⭐ Central registry (most important file)
├── schemas/
│   └── plugin-schema.json    # JSON schema for validation
├── plugins/                  # Git submodules (one per plugin)
│   ├── hit-em-with-the-docs/
│   ├── mind-glaive/
│   └── aeon-loop/
├── scripts/                  # Helper scripts you'll use daily
│   ├── install-plugin.sh     # Universal installer
│   ├── validate-plugins.sh   # Validate marketplace.json
│   ├── sync-submodules.sh    # Update plugins
│   └── generate-catalog.sh   # Generate catalog
├── docs/                     # Comprehensive documentation
│   ├── ARCHITECTURE.md
│   ├── INSTALLATION_GUIDE.md
│   └── PLUGIN_DEVELOPMENT.md
├── .documentation/           # Self-documenting via hit-em-with-the-docs
│   ├── INDEX.md
│   ├── REGISTRY.md
│   └── [15 domain folders]
└── catalog/                  # Generated (don't edit manually)
    ├── index.md
    └── plugins.json
```

### 3. Run Your First Health Check

**Validate everything**:
```bash
# Check marketplace.json is valid
./scripts/validate-plugins.sh

# Expected output:
# ✓ JSON syntax is valid
# ✓ Schema validation passed
# ✓ All checks passed
```

**Generate catalog**:
```bash
# Generate human and machine-readable catalogs
./scripts/generate-catalog.sh

# View the output
cat catalog/index.md
```

**Check documentation health**:
```bash
# Run hit-em-with-the-docs maintenance
hewtd maintain --quick

# You should see health score and any issues
```

### 4. Explore the Plugins

**List all plugins**:
```bash
ls -la plugins/

# You should see:
# hit-em-with-the-docs/
# mind-glaive/
# (aeon-loop/ if available)
```

**Check plugin versions**:
```bash
jq '.plugins[] | {name: .name, version: .version}' marketplace.json
```

**Enter a plugin directory**:
```bash
cd plugins/mind-glaive
cat README.md
git log --oneline -10
cd ../..
```

## Essential Tasks

### Daily: Monitor Issues and PRs

**Check for new issues**:
1. Visit: https://github.com/TheGlitchKing/glitch-kingdom-of-plugins/issues
2. Review any new issues
3. Label appropriately: `bug`, `enhancement`, `question`, `plugin:plugin-name`
4. Respond within 24 hours

**Check for PRs**:
1. Visit: https://github.com/TheGlitchKing/glitch-kingdom-of-plugins/pulls
2. Review automated sync PRs from weekly workflow
3. Check validation passed
4. Merge if all checks pass

### Weekly: Sync Plugin Updates

**Manual sync** (if automated PR didn't run):
```bash
# Update all submodules to latest
./scripts/sync-submodules.sh

# Review what changed
git diff

# If versions changed, update marketplace.json
# (Manual edit or use jq)

# Validate
./scripts/validate-plugins.sh

# Regenerate catalog
./scripts/generate-catalog.sh

# Commit and push
git add .
git commit -m "chore: weekly plugin sync"
git push origin main
```

**Reviewing automated sync PR**:
1. Check the PR created by GitHub Actions
2. Review changed files (submodules, marketplace.json, catalog)
3. Look for breaking changes in plugin CHANGELOGs
4. If everything looks good, approve and merge
5. If issues found, close PR and investigate

### Monthly: Comprehensive Review

**Run full health check**:
```bash
# Create this script if it doesn't exist
./scripts/health-check.sh
```

**Review metrics**:
- Number of issues opened/closed
- PR merge rate
- Plugin update frequency
- Documentation health score

**Update documentation**:
```bash
# Run full maintenance with link checking
hewtd maintain --fix

# Review the report
cat .documentation/reports/maintenance-*.md
```

## Common Maintenance Tasks

### Task: Add a New Plugin

**Quick steps**:
```bash
# 1. Add as submodule
git submodule add https://github.com/TheGlitchKing/new-plugin.git plugins/new-plugin

# 2. Checkout stable version
cd plugins/new-plugin
git checkout v1.0.0
cd ../..

# 3. Edit marketplace.json
# Add new plugin entry (see plugin-standards.md for format)

# 4. Validate
./scripts/validate-plugins.sh

# 5. Generate catalog
./scripts/generate-catalog.sh

# 6. Commit
git add .gitmodules plugins/new-plugin marketplace.json catalog/
git commit -m "feat: add new-plugin"
git push origin main
```

**Detailed guide**: See `adding-plugins-procedure.md`

### Task: Update Plugin Version

**Quick steps**:
```bash
# 1. Update submodule
cd plugins/plugin-name
git fetch --tags
git checkout v1.2.0
cd ../..

# 2. Update marketplace.json
jq --arg name "plugin-name" --arg ver "1.2.0" \
  '(.plugins[] | select(.name == $name) | .version) = $ver' \
  marketplace.json > marketplace.json.tmp
mv marketplace.json.tmp marketplace.json

# 3. Validate and commit
./scripts/validate-plugins.sh
./scripts/generate-catalog.sh
git add plugins/plugin-name marketplace.json catalog/
git commit -m "chore: update plugin-name to v1.2.0"
git push origin main
```

### Task: Fix Broken Submodule

**Quick steps**:
```bash
# 1. Remove broken submodule
git submodule deinit -f plugins/plugin-name
git rm -f plugins/plugin-name
rm -rf .git/modules/plugins/plugin-name

# 2. Re-add submodule
git submodule add <repo-url> plugins/plugin-name
cd plugins/plugin-name
git checkout v1.0.0
cd ../..

# 3. Commit fix
git add .gitmodules plugins/plugin-name
git commit -m "fix: restore plugin-name submodule"
git push origin main
```

### Task: Respond to Installation Issue

**Workflow**:
1. **Reproduce**: Try to install the plugin yourself
2. **Diagnose**: Identify the root cause (script error, version mismatch, doc error)
3. **Fix**: Update scripts, marketplace.json, or docs as needed
4. **Validate**: Test the fix works
5. **Document**: Update INSTALLATION_GUIDE.md if needed
6. **Respond**: Comment on issue with solution
7. **Close**: Close issue once confirmed fixed

**Example response**:
```markdown
Thanks for reporting this! I've reproduced the issue and found that the
installation command in the README was incorrect.

I've updated the documentation in commit abc1234. The correct installation
method is:

\`\`\`bash
npm install -g hit-em-with-the-docs
\`\`\`

Please try again and let me know if you still have issues.
```

### Task: Deprecate a Plugin

**Quick steps**:
```bash
# 1. Update marketplace.json status
jq --arg name "plugin-name" \
  '(.plugins[] | select(.name == $name) | .status) = "deprecated"' \
  marketplace.json > marketplace.json.tmp
mv marketplace.json.tmp marketplace.json

# 2. Add deprecation notice
jq --arg name "plugin-name" --arg alt "alternative-plugin" \
  '(.plugins[] | select(.name == $name) | .deprecated) = {
    "reason": "No longer maintained",
    "alternative": $alt,
    "endOfLife": "2026-12-31"
  }' marketplace.json > marketplace.json.tmp
mv marketplace.json.tmp marketplace.json

# 3. Regenerate catalog
./scripts/generate-catalog.sh

# 4. Commit
git add marketplace.json catalog/
git commit -m "chore: deprecate plugin-name"
git push origin main
```

## Key Files You'll Edit

### marketplace.json

**Most important file** - the single source of truth.

**When to edit**:
- Adding new plugins
- Updating plugin versions
- Changing plugin metadata
- Deprecating plugins

**Always**:
- Validate after editing: `./scripts/validate-plugins.sh`
- Regenerate catalog: `./scripts/generate-catalog.sh`
- Test installation methods

### Documentation Files

**When to update**:
- Installation procedures change
- New features added
- Standards updated
- Common issues discovered

**Key docs**:
- `README.md` - Marketplace overview
- `docs/INSTALLATION_GUIDE.md` - User installation guide
- `.documentation/` - Using hit-em-with-the-docs system

**Update workflow**:
```bash
# Edit documentation
vim docs/INSTALLATION_GUIDE.md

# Run maintenance
hewtd maintain --quick --fix

# Commit
git add docs/ .documentation/
git commit -m "docs: update installation guide"
git push origin main
```

## Tools and Scripts Reference

### scripts/validate-plugins.sh

**Purpose**: Validate marketplace.json against schema

**Usage**:
```bash
./scripts/validate-plugins.sh
```

**When to use**:
- After editing marketplace.json
- Before committing changes
- As part of PR review
- In CI/CD pipelines

### scripts/sync-submodules.sh

**Purpose**: Update all plugin submodules to latest versions

**Usage**:
```bash
# Dry run (see what would change)
./scripts/sync-submodules.sh --dry-run

# Actually update
./scripts/sync-submodules.sh

# Update to specific branch
./scripts/sync-submodules.sh --branch main
```

**When to use**:
- Weekly maintenance
- After plugin releases
- Before major marketplace releases

### scripts/generate-catalog.sh

**Purpose**: Generate catalog files from marketplace.json

**Usage**:
```bash
./scripts/generate-catalog.sh
```

**When to use**:
- After editing marketplace.json
- After updating submodules
- Before committing changes

**Output**:
- `catalog/index.md` - Human-readable
- `catalog/plugins.json` - Machine-readable
- `catalog/by-category/*.md` - Category pages

### scripts/install-plugin.sh

**Purpose**: Universal plugin installer helper

**Usage**:
```bash
# Show installation instructions
./scripts/install-plugin.sh mind-glaive

# List all plugins
./scripts/install-plugin.sh list

# Dry run (check without installing)
./scripts/install-plugin.sh mind-glaive --dry-run
```

**When to use**:
- Testing plugin installations
- Verifying installation instructions
- Helping users with install issues

### hit-em-with-the-docs (hewtd)

**Purpose**: Documentation management and maintenance

**Common commands**:
```bash
# Quick health check
hewtd maintain --quick

# Full maintenance with auto-fix
hewtd maintain --fix

# Health report
hewtd report health

# Search docs
hewtd search "installation"

# Integrate new document
hewtd integrate new-doc.md
```

**When to use**:
- Weekly documentation maintenance
- After adding new docs
- Before releases
- Monitoring doc health

## GitHub Workflows

### Validation Workflow

**Triggers**: Every push, PR, daily
**Purpose**: Validate marketplace.json and check integrity
**Action**: Automatically runs, check for red X or green checkmark

### Weekly Sync Workflow

**Triggers**: Sunday 4 PM UTC (weekly cron)
**Purpose**: Auto-update plugins and create PR
**Action**: Review and merge the PR if checks pass

### Documentation Workflow

**Triggers**: Changes to docs/ or .documentation/
**Purpose**: Auto-fix documentation issues
**Action**: Automatically runs, commits fixes

## Troubleshooting Guide

### Problem: Validation fails after editing marketplace.json

**Solution**:
```bash
# Check JSON syntax
jq . marketplace.json

# If jq fails, you have a syntax error
# Common issues:
# - Missing comma between entries
# - Trailing comma after last entry
# - Unclosed brackets or quotes

# Fix and try again
./scripts/validate-plugins.sh
```

### Problem: Submodule shows "modified" in git status

**Cause**: Submodule commit changed

**Solution**:
```bash
# See what changed
git diff plugins/plugin-name

# If intentional (you updated it), commit
git add plugins/plugin-name
git commit -m "chore: update plugin-name submodule"

# If unintentional, reset
git submodule update plugins/plugin-name
```

### Problem: Script says "permission denied"

**Solution**:
```bash
# Make executable
chmod +x scripts/*.sh

# Or run with bash
bash scripts/validate-plugins.sh
```

### Problem: Can't push to repository

**Solution**:
```bash
# Check you're on the right branch
git branch

# Check you have permission
git remote -v

# If using HTTPS, you might need to authenticate
# Consider using SSH instead

# Check if upstream is set
git push -u origin main
```

## Best Practices

1. **Always validate**: Run `./scripts/validate-plugins.sh` before committing
2. **Test installations**: Verify installation methods work after changes
3. **Document everything**: Update docs when making changes
4. **Communicate early**: Respond to issues within 24 hours
5. **Review carefully**: Check automated PRs before merging
6. **Stay organized**: Use GitHub labels and milestones
7. **Keep it simple**: Don't over-engineer solutions
8. **Ask for help**: Reach out to team if unsure
9. **Learn continuously**: Read plugin READMEs and code
10. **Be proactive**: Fix issues before users report them

## Resources

### Documentation
- **Architecture**: `docs/ARCHITECTURE.md` - Understanding the system
- **Installation**: `docs/INSTALLATION_GUIDE.md` - User installation guide
- **Plugin Dev**: `docs/PLUGIN_DEVELOPMENT.md` - Plugin development guide
- **Standards**: `docs-to-integrate/plugin-standards.md` - Plugin requirements
- **Procedures**: `docs-to-integrate/adding-plugins-procedure.md` - Step-by-step guides
- **Maintenance**: `docs-to-integrate/marketplace-maintenance.md` - DevOps and CI/CD

### External Links
- **GitHub Repo**: https://github.com/TheGlitchKing/glitch-kingdom-of-plugins
- **Issues**: https://github.com/TheGlitchKing/glitch-kingdom-of-plugins/issues
- **Discussions**: https://github.com/TheGlitchKing/glitch-kingdom-of-plugins/discussions

### Plugin Repositories
- **hit-em-with-the-docs**: https://github.com/TheGlitchKing/hit-em-with-the-docs
- **mind-glaive**: https://github.com/TheGlitchKing/mind-glaive
- **aeon-loop**: https://github.com/TheGlitchKing/aeon-loop

### Tools
- **jq Tutorial**: https://stedolan.github.io/jq/tutorial/
- **Git Submodules**: https://git-scm.com/book/en/v2/Git-Tools-Submodules
- **GitHub Actions**: https://docs.github.com/en/actions
- **hit-em-with-the-docs**: https://github.com/TheGlitchKing/hit-em-with-the-docs#readme

## Getting Help

### Internal Help
- **Review documentation**: Start with docs in this repository
- **Check existing issues**: Someone may have had the same question
- **Ask maintainer team**: Use GitHub Discussions

### Plugin-Specific Help
- **Plugin issues**: Open issue in plugin repository
- **Plugin features**: Contact plugin maintainer
- **Plugin bugs**: Report in plugin repo, not marketplace

## Your First Week Checklist

- [ ] Environment setup complete
- [ ] Successfully cloned repository with submodules
- [ ] Ran health check and all passed
- [ ] Generated catalog successfully
- [ ] Read ARCHITECTURE.md
- [ ] Read INSTALLATION_GUIDE.md
- [ ] Explored all three plugins
- [ ] Ran validation script successfully
- [ ] Tested one plugin installation method
- [ ] Reviewed open issues
- [ ] Checked GitHub Actions workflows
- [ ] Made a test commit to your fork
- [ ] Asked at least one question
- [ ] Read plugin-standards.md
- [ ] Understand weekly sync workflow

## Next Steps

After your first week:

1. **Take ownership of a plugin**: Become the primary contact for one plugin
2. **Improve documentation**: Find gaps and fill them
3. **Automate more**: Look for manual tasks to automate
4. **Engage community**: Respond to issues and discussions
5. **Plan improvements**: Propose enhancements to the marketplace

## Welcome to the Team!

You're now ready to maintain the Glitch Kingdom Plugin Marketplace. Remember:

- **Start small**: Don't try to learn everything at once
- **Ask questions**: No question is too basic
- **Make mistakes**: They're learning opportunities
- **Have fun**: This is an opportunity to help the community

For any questions, open an issue or reach out to the maintainer team.

Happy maintaining! 🎉
