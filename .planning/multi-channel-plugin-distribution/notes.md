# Notes: Multi-Channel Plugin Distribution Research

## Repository Exploration Results

### hit-em-with-the-docs
**Location**: `/mnt/e/docker-containers/hit-em-with-the-docs`

**Current State**:
- Published to NPM as UNSCOPED: `hit-em-with-the-docs` v1.0.0
- Has TypeScript/Node.js build system (src/ → dist/)
- Has Claude Code template at `templates/claude/CLAUDE.md` with /docs commands
- NO plugin.json manifest
- NO .claude-plugin/ directory
- Distribution: NPM (unscoped) + GitHub Action

**Key Files**:
- `package.json`: 95 lines, ES module, bin: hewtd + hit-em-with-the-docs
- `tsconfig.json`: TypeScript config
- `action.yml`: GitHub Action definition
- `README.md`: 869 lines comprehensive documentation

**Dependencies**: chalk, commander, fast-levenshtein, glob, gray-matter, yaml, zod

### mind-glaive
**Location**: `/mnt/e/docker-containers/mind-glaive`

**Current State**:
- Bash/Markdown/Python plugin
- Has `plugin.json` manifest v1.0.0
- Has `.claude-plugin/marketplace.json`
- Installation via `install.sh --scope user|project --template minimal|full-stack|data-science`
- NO package.json
- NO NPM packaging
- Distribution: Claude marketplace + manual git clone

**Key Files**:
- `install.sh`: Bash installer with scope and template options
- `plugin.json`: Plugin metadata
- `.claude-plugin/marketplace.json`: Marketplace entry
- `hooks/default-hooks.json`: SessionStart, SessionEnd, PreCompact hooks
- `scripts/`: Bash scripts for hook implementation
- `commands/`: 7 slash commands (/context/status, etc.)
- `agents/`: 3 subagents (context-cleaner, test-runner, doc-miner)
- `skills/`: 3 skills
- `templates/`: 3 project templates (minimal, full-stack, data-science)

**No Node.js dependencies**: Pure bash/python system

### aeon-loop
**Location**: `/mnt/e/docker-containers/aeon-loop`

**Current State**:
- Bash/Markdown plugin
- Has `.claude-plugin/plugin.json` v1.0.0
- Has `marketplace.json`
- Installation via Claude marketplace or manual
- NO package.json
- NO NPM packaging
- Distribution: Claude marketplace + manual
- **INCLUDES aeon-flux** in `plugins/aeon-loop/skills/aeon-flux/`

**Key Files**:
- `.claude-plugin/plugin.json`: Plugin manifest
- `marketplace.json`: Marketplace definition
- `plugins/aeon-loop/hooks/hooks.json`: 5 hooks
- `plugins/aeon-loop/commands/`: /loop, /abort, /pause, /resume, /status
- `plugins/aeon-loop/skills/aeon-flux/SKILL.md`: 984 lines unified workflow
- `plugins/aeon-loop/scripts/`: setup-loop.sh, stop-loop.sh, session-start.sh

**aeon-flux relationship**: Bundled within aeon-loop, not separate repo

## Architecture Decisions Rationale

### Why NPM Wrapper for Bash Plugins?

**Problem**: mind-glaive and aeon-loop are bash-based with complex install.sh scripts

**Options Considered**:
1. Rewrite in Node.js (rejected - too much work, breaks existing users)
2. Pure bash distribution only (rejected - misses npm ecosystem benefits)
3. NPM wrapper that calls bash installer (CHOSEN)

**Chosen Solution**: NPM package with:
- `bin/[plugin-name].js` - Node.js CLI wrapper
- Executes existing `install.sh` with flags
- Commands: install, uninstall, status, help
- Maintains single source of truth (bash scripts)

**Benefits**:
- Users get `npm install -g @theglitchking/[plugin]` convenience
- No code duplication
- Existing bash logic preserved
- Easy migration path

### Why Scope All Packages?

**Problem**: hit-em-with-the-docs currently unscoped, violates marketplace standards

**Options**:
1. Keep hewtd unscoped, scope others (rejected - inconsistent)
2. Scope all under @theglitchking/ (CHOSEN)

**Benefits**:
- Brand consistency
- Namespace management (prevents conflicts)
- Professional appearance
- Follows plugin-standards.md requirements
- Easier to find related packages

**Cost**: Breaking change for hewtd (1.0.0 → 2.0.0), requires migration guide

### Why Bundle aeon-flux with aeon-loop?

**Problem**: aeon-flux and aeon-loop relationship

**Current State**: aeon-flux already bundled in aeon-loop repo

**Options**:
1. Separate NPM packages (rejected - complicates installation)
2. Keep bundled (CHOSEN)

**Benefits**:
- Simpler for users (one install)
- Matches current architecture
- No dependency resolution needed
- Documentation clearer

## Code Snippets for Implementation

### package.json Template for CLI Tool (hewtd)

```json
{
  "name": "@theglitchking/hit-em-with-the-docs",
  "version": "2.0.0",
  "type": "module",
  "bin": {
    "hit-em-with-the-docs": "dist/cli/index.js",
    "hewtd": "dist/cli/index.js",
    "docs": "dist/cli/index.js"
  },
  "files": [
    "dist",
    "templates",
    ".claude-plugin",
    "action.yml",
    "README.md",
    "LICENSE",
    "MIGRATION.md"
  ],
  "publishConfig": {
    "access": "public"
  },
  "scripts": {
    "prepublishOnly": "npm run build:all && npm run test && ./scripts/validate-version.sh"
  }
}
```

### package.json Template for Bash Plugin (mind-glaive)

```json
{
  "name": "@theglitchking/mind-glaive",
  "version": "1.1.0",
  "type": "commonjs",
  "bin": {
    "mind-glaive": "./bin/mind-glaive.js"
  },
  "scripts": {
    "postinstall": "node postinstall.js",
    "prepublishOnly": "./scripts/validate-version.sh"
  },
  "files": [
    "bin/",
    "agents/",
    "commands/",
    "hooks/",
    "scripts/",
    "skills/",
    "templates/",
    "install.sh",
    "uninstall.sh",
    "postinstall.js",
    "plugin.json",
    ".claude-plugin/",
    "README.md",
    "LICENSE"
  ],
  "engines": {
    "node": ">=16.0.0"
  },
  "publishConfig": {
    "access": "public"
  }
}
```

### CLI Wrapper Pattern (bin/plugin-name.js)

```javascript
#!/usr/bin/env node

const { execSync } = require('child_process');
const path = require('path');

const INSTALL_SCRIPT = path.join(__dirname, '..', 'install.sh');

function showHelp() {
  console.log(`
plugin-name CLI

Usage:
  plugin-name install [--scope user|project] [--template template-name]
  plugin-name uninstall
  plugin-name status
  plugin-name help
  `);
}

const args = process.argv.slice(2);
const command = args[0];

switch (command) {
  case 'install':
    const scope = args.includes('--scope') ? args[args.indexOf('--scope') + 1] : 'user';
    console.log(`Installing (scope: ${scope})...`);
    try {
      execSync(`bash "${INSTALL_SCRIPT}" --scope ${scope}`, {
        stdio: 'inherit',
        cwd: path.dirname(INSTALL_SCRIPT)
      });
    } catch (error) {
      console.error('Installation failed:', error.message);
      process.exit(1);
    }
    break;

  // ... other commands
}
```

### Version Validation Script Template

```bash
#!/bin/bash
# scripts/validate-version.sh

set -e

PACKAGE_VERSION=$(node -p "require('./package.json').version")
PLUGIN_VERSION=$(node -p "require('./plugin.json').version")

if [ "$PACKAGE_VERSION" != "$PLUGIN_VERSION" ]; then
  echo "❌ Version mismatch!"
  echo "  package.json: $PACKAGE_VERSION"
  echo "  plugin.json: $PLUGIN_VERSION"
  exit 1
fi

echo "✓ Versions match: $PACKAGE_VERSION"
```

## Marketplace Documentation Updates

### marketplace.json Installation Methods Pattern

```json
"installation": {
  "methods": [
    {
      "type": "npm",
      "command": "npm install -g @theglitchking/plugin-name"
    },
    {
      "type": "npx",
      "command": "npx @theglitchking/plugin-name [args]"
    },
    {
      "type": "claude-marketplace",
      "command": "/plugin install TheGlitchKing/plugin-name"
    }
  ],
  "requirements": {
    "node": ">=16.0.0",
    "bash": true
  }
}
```

### INSTALLATION_GUIDE.md NPM Section Pattern

```markdown
### Option A: NPM Installation (Recommended)

**Global Install**:
```bash
npm install -g @theglitchking/plugin-name
plugin-name install --scope user
```

**One-Time Use (npx)**:
```bash
npx @theglitchking/plugin-name install --scope user
```

**Check Status**:
```bash
plugin-name status
```
```

## Testing Strategy

### Local Testing Before Publish

```bash
# In plugin directory
npm pack

# Install from tarball
npm install -g ./theglitchking-plugin-name-1.1.0.tgz

# Test CLI
plugin-name --help
plugin-name install --scope user

# Verify files
ls ~/.claude/

# Uninstall
npm uninstall -g @theglitchking/plugin-name
```

### Post-Publish Testing

```bash
# Wait for NPM propagation (5 minutes)
sleep 300

# Test from NPM
npm install -g @theglitchking/plugin-name

# Test npx
npx @theglitchking/plugin-name --help

# Verify in Claude Code
# Run slash commands to verify plugin works
```

## Edge Cases to Handle

### User Has Old Unscoped Package

Add to postinstall.js:
```javascript
try {
  const unscopedInstalled = execSync('npm list -g hit-em-with-the-docs', { encoding: 'utf8' });
  if (unscopedInstalled && !unscopedInstalled.includes('(empty)')) {
    console.warn('\n⚠️  Warning: Old unscoped package detected');
    console.warn('   Consider uninstalling: npm uninstall -g hit-em-with-the-docs\n');
  }
} catch (e) {
  // Not installed, no warning needed
}
```

### No Bash on Windows

Add to bin/plugin-name.js:
```javascript
function checkBash() {
  try {
    execSync('bash --version', { stdio: 'ignore' });
    return true;
  } catch (e) {
    return false;
  }
}

if (!checkBash()) {
  console.error('❌ Error: Bash required');
  console.error('Windows users: Install WSL2 or use Claude marketplace');
  process.exit(1);
}
```

## Version History Plan

### hit-em-with-the-docs
- v1.0.0 (current): Unscoped NPM package
- v1.1.0 (deprecation): Final unscoped release with deprecation warning
- v2.0.0 (breaking): Scoped package + Claude plugin support

### mind-glaive
- v1.0.0 (current): Claude plugin only, manual/marketplace install
- v1.1.0 (feature): Added NPM distribution channel

### aeon-loop
- v1.0.0 (current): Claude plugin only, includes aeon-flux
- v1.1.0 (feature): Added NPM distribution channel

## References

- Plugin standards: `/mnt/e/docker-containers/glitch-kingdom-of-plugins/.documentation/standards/plugin-standards.md`
- Installation guide: `/mnt/e/docker-containers/glitch-kingdom-of-plugins/.documentation/quickstart/INSTALLATION_GUIDE.md`
- Marketplace architecture: `/mnt/e/docker-containers/glitch-kingdom-of-plugins/.documentation/quickstart/ARCHITECTURE.md`
- Full plan: `/home/morpheus_1/.claude/plans/functional-gathering-globe.md`
