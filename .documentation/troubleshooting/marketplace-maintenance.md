---
title: Marketplace Maintenance Guide
tier: reference
domains:
  - troubleshooting
  - workflows
  - quickstart
audience:
  - developers
  - devops
  - admin
tags:
  - api
  - ci/cd
  - testing
  - security
  - node
  - monitoring
  - performance
status: draft
last_updated: 2026-02-03T00:00:00.000Z
version: 1.0.0
purpose: Documentation for marketplace maintenance guide
estimated_read_time: 5 minutes
word_count: 946
last_validated: 2026-02-04
backlinks: []
---

# Marketplace Maintenance Guide

## Overview

This guide covers ongoing maintenance, DevOps practices, and CI/CD automation for the Glitch Kingdom Plugin Marketplace. Follow these procedures to keep the marketplace healthy, up-to-date, and reliable.

## Maintenance Schedule

### Daily Tasks (Automated)

**What**: Automated health checks and validation
**Who**: CI/CD pipeline
**When**: On every push and PR

```yaml
# .github/workflows/validate.yml
name: Daily Validation
on:
  push:
    branches: [main]
  pull_request:
  schedule:
    - cron: '0 0 * * *'  # Daily at midnight UTC
```

**Tasks**:
- Validate marketplace.json schema
- Check all plugin submodules are accessible
- Verify all URLs return 200 OK
- Test script executability
- Generate catalog and check for errors

### Weekly Tasks (Semi-Automated)

**What**: Plugin updates and synchronization
**Who**: Maintainer reviews automated PRs
**When**: Every Sunday at 4 PM UTC

```bash
# Manual weekly workflow
cd /mnt/e/docker-containers/glitch-kingdom-of-plugins

# 1. Update all submodules
./scripts/sync-submodules.sh

# 2. Review changes
git diff

# 3. Update marketplace.json versions if needed
# (edit marketplace.json)

# 4. Validate
./scripts/validate-plugins.sh

# 5. Regenerate catalog
./scripts/generate-catalog.sh

# 6. Commit and push
git add .
git commit -m "chore: weekly plugin sync"
git push origin main
```

**Automated workflow**:
```yaml
# .github/workflows/weekly-sync.yml
name: Weekly Plugin Sync
on:
  schedule:
    - cron: '0 16 * * 0'  # Sunday 4 PM UTC
  workflow_dispatch:  # Manual trigger
```

### Monthly Tasks (Manual)

**What**: Comprehensive review and maintenance
**Who**: Maintainer
**When**: First Monday of each month

**Checklist**:
- [ ] Review all plugin updates
- [ ] Test each plugin installation method
- [ ] Update documentation for breaking changes
- [ ] Review and close stale issues
- [ ] Check for security vulnerabilities
- [ ] Update dependencies in scripts
- [ ] Review GitHub Actions usage and limits
- [ ] Check marketplace analytics (if available)
- [ ] Update CHANGELOG.md
- [ ] Create monthly status report

### Quarterly Tasks (Manual)

**What**: Strategic review and planning
**Who**: Maintainer + stakeholders
**When**: End of Q1, Q2, Q3, Q4

**Checklist**:
- [ ] Review plugin adoption and usage
- [ ] Identify plugins for deprecation
- [ ] Plan new features for marketplace
- [ ] Review and update standards documentation
- [ ] Audit plugin quality across all plugins
- [ ] Update roadmap
- [ ] Community feedback review
- [ ] Performance optimization review

## CI/CD Pipeline Architecture

### Overview

```
┌─────────────┐
│   GitHub    │
│  Repository │
└──────┬──────┘
       │
       ├─── Push to main ────────────────┐
       │                                  │
       ├─── Pull Request ────────────────┤
       │                                  │
       ├─── Weekly Cron ─────────────────┤
       │                                  │
       └─── Manual Trigger ──────────────┤
                                          │
                                          ▼
                              ┌───────────────────┐
                              │  GitHub Actions   │
                              │   Workflows       │
                              └─────────┬─────────┘
                                        │
                    ┌──────────────────┼──────────────────┐
                    │                  │                  │
                    ▼                  ▼                  ▼
            ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
            │  Validation  │  │ Plugin Sync  │  │ Documentation│
            │   Pipeline   │  │   Pipeline   │  │   Pipeline   │
            └──────────────┘  └──────────────┘  └──────────────┘
```

### Workflows

#### 1. Validation Workflow

**File**: `.github/workflows/validate.yml`

**Purpose**: Validate marketplace integrity on every change

**Triggers**:
- Every push to main
- Every pull request
- Manual dispatch

**Steps**:
```yaml
name: Validate Marketplace

on:
  push:
    branches: [main]
  pull_request:
  workflow_dispatch:

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout with submodules
        uses: actions/checkout@v4
        with:
          submodules: recursive

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install jq
        run: sudo apt-get install -y jq

      - name: Validate marketplace.json
        run: |
          chmod +x scripts/validate-plugins.sh
          ./scripts/validate-plugins.sh

      - name: Check submodule accessibility
        run: |
          for dir in plugins/*/; do
            if [ ! -d "$dir/.git" ] && [ ! -f "$dir/.git" ]; then
              echo "Error: Submodule $dir not initialized"
              exit 1
            fi
          done

      - name: Validate URLs
        run: |
          urls=$(jq -r '.plugins[].repository.url' marketplace.json)
          for url in $urls; do
            if ! curl -f -s -o /dev/null "$url"; then
              echo "Error: URL $url is not accessible"
              exit 1
            fi
          done

      - name: Test script executability
        run: |
          for script in scripts/*.sh; do
            if [ ! -x "$script" ]; then
              echo "Error: Script $script is not executable"
              exit 1
            fi
          done

      - name: Generate catalog
        run: |
          chmod +x scripts/generate-catalog.sh
          ./scripts/generate-catalog.sh

      - name: Upload validation report
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: validation-report
          path: |
            catalog/
            *.log
```

**Success Criteria**:
- All validation checks pass
- No schema errors
- All URLs accessible
- Catalog generates successfully

#### 2. Plugin Sync Workflow

**File**: `.github/workflows/sync-plugins.yml`

**Purpose**: Automatically sync plugin submodules and create PR

**Triggers**:
- Weekly cron (Sunday 4 PM UTC)
- Manual dispatch

**Steps**:
```yaml
name: Sync Plugin Submodules

on:
  schedule:
    - cron: '0 16 * * 0'  # Sunday 4 PM UTC
  workflow_dispatch:

jobs:
  sync:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write

    steps:
      - name: Checkout with submodules
        uses: actions/checkout@v4
        with:
          submodules: recursive
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Setup Git
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"

      - name: Update submodules
        run: |
          git submodule update --remote --merge
          git add plugins/

      - name: Detect changes
        id: changes
        run: |
          if git diff --staged --quiet; then
            echo "No changes detected"
            echo "has_changes=false" >> $GITHUB_OUTPUT
          else
            echo "Changes detected"
            echo "has_changes=true" >> $GITHUB_OUTPUT
          fi

      - name: Install jq
        if: steps.changes.outputs.has_changes == 'true'
        run: sudo apt-get install -y jq

      - name: Update marketplace.json versions
        if: steps.changes.outputs.has_changes == 'true'
        run: |
          # For each plugin, check if version changed
          for plugin in plugins/*/; do
            plugin_name=$(basename "$plugin")

            # Get version from plugin
            if [ -f "$plugin/package.json" ]; then
              new_version=$(jq -r '.version' "$plugin/package.json")
            elif [ -f "$plugin/.claude-plugin/plugin.json" ]; then
              new_version=$(jq -r '.version' "$plugin/.claude-plugin/plugin.json")
            else
              echo "No version file found for $plugin_name"
              continue
            fi

            # Update marketplace.json
            jq --arg name "$plugin_name" --arg ver "$new_version" \
              '(.plugins[] | select(.name == $name) | .version) = $ver' \
              marketplace.json > marketplace.json.tmp
            mv marketplace.json.tmp marketplace.json
          done

          git add marketplace.json

      - name: Generate catalog
        if: steps.changes.outputs.has_changes == 'true'
        run: |
          chmod +x scripts/generate-catalog.sh
          ./scripts/generate-catalog.sh
          git add catalog/

      - name: Create Pull Request
        if: steps.changes.outputs.has_changes == 'true'
        uses: peter-evans/create-pull-request@v5
        with:
          commit-message: 'chore: weekly plugin sync'
          title: 'Weekly Plugin Sync - ${{ github.run_number }}'
          body: |
            ## Automated Plugin Sync

            This PR updates plugin submodules to their latest versions.

            ### Changes
            - Updated plugin submodules
            - Updated marketplace.json versions
            - Regenerated catalog

            ### Review Checklist
            - [ ] Review version changes in marketplace.json
            - [ ] Check for breaking changes in plugin READMEs
            - [ ] Verify catalog looks correct
            - [ ] Test critical installation methods

            **Auto-generated by weekly-sync workflow**
          branch: auto/weekly-sync-${{ github.run_number }}
          delete-branch: true
          labels: |
            automated
            maintenance
```

**Success Criteria**:
- Submodules updated to latest commits
- marketplace.json versions updated
- Catalog regenerated
- PR created with changes

#### 3. Documentation Workflow

**File**: `.github/workflows/docs.yml`

**Purpose**: Validate and maintain documentation

**Triggers**:
- Push to docs/ or .documentation/
- Manual dispatch

**Steps**:
```yaml
name: Documentation Maintenance

on:
  push:
    paths:
      - 'docs/**'
      - '.documentation/**'
  workflow_dispatch:

jobs:
  maintain-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install hit-em-with-the-docs
        run: npm install -g hit-em-with-the-docs

      - name: Run documentation maintenance
        run: hewtd maintain --quick --fix

      - name: Commit documentation fixes
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add .documentation/
          git diff --staged --quiet || git commit -m "docs: auto-fix documentation issues"
          git push

      - name: Generate health report
        run: hewtd report health

      - name: Upload health report
        uses: actions/upload-artifact@v4
        with:
          name: docs-health-report
          path: .documentation/reports/
```

**Success Criteria**:
- Documentation passes health checks
- Metadata issues auto-fixed
- Health report generated

## Monitoring and Alerts

### GitHub Actions Monitoring

**Monitor**:
- Workflow success/failure rates
- Workflow execution time
- Action minutes usage

**Alerts**:
Configure notifications for:
- Failed validation workflows
- Failed sync workflows
- Usage approaching GitHub Actions limits

**Setup**:
1. Go to repository Settings → Notifications
2. Enable email notifications for workflow failures
3. Consider using GitHub Apps for Slack/Discord notifications

### Health Metrics

**Key Metrics**:
- Validation pass rate: Should be >95%
- Plugin sync success rate: Should be 100%
- Documentation health score: Should be >80%
- Submodule update frequency: Weekly
- Issue resolution time: <7 days average

**Dashboard** (manual tracking):
Create `reports/health-metrics.md`:
```markdown
# Marketplace Health Metrics

## Week of 2026-02-03

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Validation Pass Rate | 98% | >95% | ✅ |
| Plugin Sync Success | 100% | 100% | ✅ |
| Docs Health Score | 85% | >80% | ✅ |
| Avg Issue Resolution | 5 days | <7 days | ✅ |
| Open Issues | 3 | <5 | ✅ |
```

## Backup and Recovery

### Backup Strategy

**What to backup**:
- marketplace.json (most critical)
- All documentation in docs/
- All scripts in scripts/
- Generated catalogs (can be regenerated but backup for history)
- Git configuration (.gitmodules)

**Backup frequency**:
- Automatic: GitHub provides repository backup
- Manual: Weekly export of marketplace.json
- Cloud: Consider S3 or similar for redundancy

**Backup script**:
```bash
#!/bin/bash
# scripts/backup-marketplace.sh

BACKUP_DIR="backups/$(date +%Y-%m-%d)"
mkdir -p "$BACKUP_DIR"

# Backup critical files
cp marketplace.json "$BACKUP_DIR/"
cp -r docs/ "$BACKUP_DIR/"
cp -r scripts/ "$BACKUP_DIR/"
cp -r catalog/ "$BACKUP_DIR/"
cp .gitmodules "$BACKUP_DIR/"

# Create tarball
tar -czf "$BACKUP_DIR.tar.gz" "$BACKUP_DIR"

echo "Backup created: $BACKUP_DIR.tar.gz"
```

### Recovery Procedures

**Scenario 1: Corrupted marketplace.json**

```bash
# Restore from Git history
git checkout HEAD~1 marketplace.json

# Or restore from backup
cp backups/latest/marketplace.json .

# Validate
./scripts/validate-plugins.sh

# Commit if valid
git add marketplace.json
git commit -m "fix: restore marketplace.json from backup"
git push
```

**Scenario 2: Broken submodule**

```bash
# Remove broken submodule
git submodule deinit -f plugins/<plugin-name>
git rm -f plugins/<plugin-name>
rm -rf .git/modules/plugins/<plugin-name>

# Re-add submodule
git submodule add <repo-url> plugins/<plugin-name>

# Update to correct version
cd plugins/<plugin-name>
git checkout v1.0.0
cd ../..

# Commit fix
git add .gitmodules plugins/<plugin-name>
git commit -m "fix: restore <plugin-name> submodule"
git push
```

**Scenario 3: Complete repository loss**

```bash
# Clone from GitHub (GitHub is primary backup)
git clone --recursive https://github.com/TheGlitchKing/glitch-kingdom-of-plugins.git

# Verify integrity
cd glitch-kingdom-of-plugins
./scripts/validate-plugins.sh

# If validation fails, restore from manual backup
cp backups/latest/marketplace.json .
```

## Security Maintenance

### Security Checklist

**Weekly**:
- [ ] Review Dependabot alerts
- [ ] Check for vulnerable dependencies
- [ ] Review new GitHub security advisories

**Monthly**:
- [ ] Audit plugin permissions
- [ ] Review secrets and tokens
- [ ] Check GitHub Actions logs for suspicious activity
- [ ] Update Node.js/Python/Bash scripts

**Quarterly**:
- [ ] Full security audit of all plugins
- [ ] Review access controls
- [ ] Update security documentation
- [ ] Penetration testing (if applicable)

### Dependabot Configuration

**File**: `.github/dependabot.yml`

```yaml
version: 2
updates:
  # GitHub Actions
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    labels:
      - "dependencies"
      - "github-actions"

  # NPM (if marketplace has package.json)
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    labels:
      - "dependencies"
      - "npm"
```

### Security Scanning

**Code scanning**:
```yaml
# .github/workflows/codeql.yml
name: "CodeQL"

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 0 * * 1'  # Weekly on Monday

jobs:
  analyze:
    runs-on: ubuntu-latest
    permissions:
      security-events: write
    steps:
      - uses: actions/checkout@v4
      - uses: github/codeql-action/init@v2
      - uses: github/codeql-action/analyze@v2
```

## Performance Optimization

### Caching Strategies

**Cache submodule data**:
```yaml
- name: Cache submodules
  uses: actions/cache@v3
  with:
    path: plugins/
    key: ${{ runner.os }}-submodules-${{ hashFiles('.gitmodules') }}
```

**Cache dependencies**:
```yaml
- name: Cache npm
  uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
```

**Optimize workflow execution**:
- Use matrix builds for parallel testing
- Skip unnecessary steps with conditionals
- Use artifacts to pass data between jobs
- Minimize checkout depth: `fetch-depth: 1`

### Script Optimization

**Optimize validation script**:
```bash
# Parallel URL checking
urls=$(jq -r '.plugins[].repository.url' marketplace.json)
echo "$urls" | xargs -P 10 -I {} curl -f -s -o /dev/null {}
```

**Optimize catalog generation**:
- Cache parsed JSON in memory
- Use jq streaming for large files
- Generate only changed pages

## Troubleshooting

### Common Issues

#### Issue 1: Workflow Fails to Checkout Submodules

**Symptoms**:
```
Error: Submodule 'plugins/plugin-name' could not be updated
```

**Solution**:
```yaml
# Ensure recursive checkout
- uses: actions/checkout@v4
  with:
    submodules: recursive
    token: ${{ secrets.GITHUB_TOKEN }}

# Or initialize manually
- run: |
    git submodule init
    git submodule update --recursive
```

#### Issue 2: Permission Denied on Scripts

**Symptoms**:
```
permission denied: ./scripts/validate-plugins.sh
```

**Solution**:
```yaml
- name: Make scripts executable
  run: chmod +x scripts/*.sh

# Or in the script step:
- run: bash scripts/validate-plugins.sh
```

#### Issue 3: Rate Limiting on GitHub API

**Symptoms**:
```
API rate limit exceeded
```

**Solution**:
- Use GITHUB_TOKEN for authentication
- Implement exponential backoff
- Cache API responses
- Reduce API calls

```bash
# Use authenticated requests
curl -H "Authorization: token $GITHUB_TOKEN" \
     https://api.github.com/repos/owner/repo
```

#### Issue 4: Submodule Out of Sync

**Symptoms**:
- marketplace.json version doesn't match submodule
- Installation instructions reference wrong version

**Solution**:
```bash
# Manual sync
cd plugins/<plugin-name>
git fetch --tags
git checkout v1.2.0
cd ../..

# Update marketplace.json to match
jq --arg name "plugin-name" --arg ver "1.2.0" \
  '(.plugins[] | select(.name == $name) | .version) = $ver' \
  marketplace.json > marketplace.json.tmp
mv marketplace.json.tmp marketplace.json

# Validate and commit
./scripts/validate-plugins.sh
git add plugins/<plugin-name> marketplace.json
git commit -m "chore: sync <plugin-name> to v1.2.0"
git push
```

## Maintenance Scripts

### Health Check Script

**File**: `scripts/health-check.sh`

```bash
#!/bin/bash
# Comprehensive health check for marketplace

set -e

echo "=== Marketplace Health Check ==="
echo ""

# Check 1: Validate marketplace.json
echo "1. Validating marketplace.json..."
if ./scripts/validate-plugins.sh > /dev/null 2>&1; then
  echo "   ✅ marketplace.json is valid"
else
  echo "   ❌ marketplace.json validation failed"
  exit 1
fi

# Check 2: Verify submodules
echo "2. Checking submodules..."
submodule_count=$(git submodule status | wc -l)
echo "   Found $submodule_count submodules"

for dir in plugins/*/; do
  plugin_name=$(basename "$dir")
  if [ -d "$dir/.git" ] || [ -f "$dir/.git" ]; then
    echo "   ✅ $plugin_name"
  else
    echo "   ❌ $plugin_name (not initialized)"
  fi
done

# Check 3: Verify URLs
echo "3. Checking repository URLs..."
urls=$(jq -r '.plugins[].repository.url' marketplace.json)
for url in $urls; do
  if curl -f -s -o /dev/null "$url"; then
    echo "   ✅ $url"
  else
    echo "   ❌ $url (not accessible)"
  fi
done

# Check 4: Check for updates
echo "4. Checking for plugin updates..."
cd plugins/
for plugin_dir in */; do
  cd "$plugin_dir"
  plugin_name=$(basename "$plugin_dir")

  git fetch --quiet --tags
  local_version=$(git describe --tags --abbrev=0 2>/dev/null || echo "unknown")
  remote_version=$(git describe --tags --abbrev=0 origin/main 2>/dev/null || echo "unknown")

  if [ "$local_version" != "$remote_version" ]; then
    echo "   ⚠️  $plugin_name: $local_version → $remote_version (update available)"
  else
    echo "   ✅ $plugin_name: $local_version (up to date)"
  fi

  cd ..
done
cd ..

# Check 5: Documentation health
echo "5. Checking documentation..."
if command -v hewtd > /dev/null; then
  cd .documentation
  health_score=$(hewtd report health --format json | jq -r '.health_score' 2>/dev/null || echo "unknown")
  if [ "$health_score" != "unknown" ]; then
    echo "   Health Score: $health_score%"
    if (( $(echo "$health_score >= 80" | bc -l) )); then
      echo "   ✅ Documentation health is good"
    else
      echo "   ⚠️  Documentation health needs improvement"
    fi
  fi
  cd ..
else
  echo "   ℹ️  hit-em-with-the-docs not installed, skipping"
fi

echo ""
echo "=== Health Check Complete ==="
```

### Cleanup Script

**File**: `scripts/cleanup.sh`

```bash
#!/bin/bash
# Cleanup old backups, logs, and temporary files

set -e

echo "=== Marketplace Cleanup ==="

# Remove old backups (keep last 10)
echo "Cleaning old backups..."
ls -t backups/*.tar.gz 2>/dev/null | tail -n +11 | xargs rm -f
echo "  ✅ Old backups removed"

# Remove log files older than 30 days
echo "Cleaning old logs..."
find . -name "*.log" -mtime +30 -delete
echo "  ✅ Old logs removed"

# Clean git
echo "Cleaning git..."
git gc --auto
git prune
echo "  ✅ Git cleaned"

# Remove catalog cache
echo "Cleaning catalog cache..."
rm -f catalog/.cache/*
echo "  ✅ Catalog cache cleared"

echo "=== Cleanup Complete ==="
```

## Reporting

### Weekly Status Report

Generate weekly status report:

```bash
#!/bin/bash
# scripts/weekly-report.sh

REPORT_FILE="reports/weekly-$(date +%Y-%m-%d).md"

cat > "$REPORT_FILE" << EOF
# Weekly Marketplace Report - $(date +%Y-%m-%d)

## Plugin Status

| Plugin | Current Version | Latest Version | Status |
|--------|----------------|----------------|--------|
EOF

# Add plugin status
jq -r '.plugins[] | [.name, .version] | @tsv' marketplace.json | while IFS=$'\t' read -r name version; do
  echo "| $name | $version | - | ✅ |" >> "$REPORT_FILE"
done

cat >> "$REPORT_FILE" << EOF

## Metrics

- Total Plugins: $(jq '.plugins | length' marketplace.json)
- Validation Passes: -
- Issues Opened: -
- Issues Closed: -
- PRs Merged: -

## Actions This Week

- [ ] Reviewed plugin updates
- [ ] Merged sync PR
- [ ] Updated documentation
- [ ] Responded to issues

## Next Week Plan

- Continue monitoring plugin updates
- Review any open PRs
- Update documentation as needed
EOF

echo "Report generated: $REPORT_FILE"
```

## Best Practices

1. **Automate Everything**: Use GitHub Actions for repetitive tasks
2. **Validate Often**: Run validation on every change
3. **Monitor Continuously**: Track health metrics weekly
4. **Backup Regularly**: Automated backups of critical files
5. **Document Changes**: Keep CHANGELOG.md updated
6. **Review PRs Carefully**: Especially automated sync PRs
7. **Test Before Merging**: Always test installation after updates
8. **Communicate**: Notify users of breaking changes
9. **Stay Secure**: Regular security audits and updates
10. **Be Responsive**: Address issues within 7 days

## Conclusion

Proper maintenance ensures the marketplace remains reliable and useful. Follow this guide to establish a robust DevOps practice and keep the marketplace healthy.

For questions or improvements to these procedures, open an issue in the marketplace repository.
