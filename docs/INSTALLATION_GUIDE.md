# Installation Guide

Complete guide for installing plugins from the Glitch Kingdom Marketplace.

## Prerequisites

### Required Tools

- **Git** 2.0+ with submodule support
- **Bash** shell

### Plugin-Specific Requirements

#### hit-em-with-the-docs
- Node.js 20.0.0 or higher
- npm or npx

#### mind-glaive
- Claude Code 1.0.0 or higher
- Bash shell
- Python 3.9+ (for MCP servers)
- (Optional) Ollama for local LLM summarization

#### aeon-loop & aeon-flux
- Claude Code 2.0.13 or higher
- Bash shell

## Installation Methods

### Method 1: Clone Entire Marketplace (Recommended for Developers)

Best for developers who want access to all plugins or want to contribute.

```bash
# Clone with all submodules
git clone --recursive https://github.com/TheGlitchKing/glitch-kingdom-of-plugins.git
cd glitch-kingdom-of-plugins

# Browse available plugins
ls plugins/

# Use the universal installer
./scripts/install-plugin.sh mind-glaive
```

**Updating plugins**:
```bash
cd glitch-kingdom-of-plugins
git pull
git submodule update --remote --merge
```

### Method 2: Install Individual Plugins (Recommended for Users)

Best for users who want specific plugins without cloning the marketplace.

#### CLI Tools (hit-em-with-the-docs)

**Option A: Global NPM Installation**
```bash
npm install -g hit-em-with-the-docs

# Verify installation
hewtd --version

# Use it
hewtd init
```

**Option B: NPX (No Installation)**
```bash
npx hit-em-with-the-docs init
npx hit-em-with-the-docs maintain
```

**Option C: GitHub Action**

Add to `.github/workflows/docs.yml`:
```yaml
name: Documentation Maintenance

on:
  push:
    branches: [main]
  schedule:
    - cron: '0 0 * * 0'  # Weekly

jobs:
  maintain-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Hit Em With The Docs
        uses: TheGlitchKing/hit-em-with-the-docs@v1
        with:
          command: maintain
          mode: fix
```

#### Claude Plugins (mind-glaive, aeon-loop, aeon-flux)

**Option A: Claude Marketplace (Easiest)**
```bash
# In Claude Code
/plugin install TheGlitchKing/mind-glaive
/plugin add TheGlitchKing/aeon-loop
```

**Option B: Manual Installation (Full Control)**
```bash
# mind-glaive
git clone https://github.com/TheGlitchKing/mind-glaive.git
cd mind-glaive
./install.sh --scope user --template full-stack

# Verify installation
ls ~/.claude/
# Should show .claude directory with plugin files
```

**Note**: aeon-flux is included with aeon-loop, no separate installation needed.

### Method 3: Marketplace Helper Script

Use the marketplace's universal installer for guided installation.

```bash
# Clone marketplace (lightweight, no submodules)
git clone https://github.com/TheGlitchKing/glitch-kingdom-of-plugins.git
cd glitch-kingdom-of-plugins

# List available plugins
./scripts/install-plugin.sh list

# Get installation instructions for a specific plugin
./scripts/install-plugin.sh mind-glaive

# Follow the instructions displayed
```

## Detailed Installation Steps

### Installing hit-em-with-the-docs

**Step 1: Check Node.js version**
```bash
node --version
# Should be v20.0.0 or higher
```

**Step 2: Install globally**
```bash
npm install -g hit-em-with-the-docs
```

**Step 3: Initialize in your project**
```bash
cd your-project
hewtd init
```

**Step 4: Configure (optional)**

Edit `.documentation/config.yml` to customize:
- Domain structure
- Metadata requirements
- Automation rules

**Step 5: Run maintenance**
```bash
hewtd maintain --mode fix
```

### Installing mind-glaive

**Step 1: Verify Claude Code version**
```bash
claude --version
# Should be v1.0.0 or higher
```

**Step 2: Choose installation scope**

- **User scope** (recommended): Applies to all your projects
- **Project scope**: Applies to current project only

**Step 3: Choose template**

- **minimal** (1KB): Small projects
- **full-stack** (8KB): Web applications
- **data-science** (6KB): ML/research projects

**Step 4: Install**
```bash
git clone https://github.com/TheGlitchKing/mind-glaive.git
cd mind-glaive
./install.sh --scope user --template full-stack
```

**Step 5: Verify installation**
```bash
# Check for .claude directory
ls ~/.claude/

# Files should include:
# - CLAUDE.md (project memory)
# - rules/ (modular rules)
# - commands/ (slash commands)
# - hooks/ (lifecycle hooks)
```

**Step 6: Optional - Install MCP servers**
```bash
cd mcp-servers/project-kb
pip install -r requirements.txt
python server.py
```

**Step 7: Optional - Install Ollama (for local summarization)**
```bash
# Visit https://ollama.ai/ for installation
# Pull required models
ollama pull mistral:7b-instruct
ollama pull nomic-embed-text
```

### Installing aeon-loop (includes aeon-flux)

**Step 1: Verify Claude Code version**
```bash
claude --version
# Should be v2.0.13 or higher (Note: higher requirement than mind-glaive)
```

**Step 2: Install via Claude marketplace**
```bash
/plugin add TheGlitchKing/aeon-loop
```

**Step 3: Verify installation**

Check that the following commands are available:
```bash
/aeon-flux
/loop
/abort
/pause
/resume
/status
```

**Step 4: (Optional) Manual installation**
```bash
git clone https://github.com/TheGlitchKing/aeon-loop.git
cd aeon-loop
# Follow plugin-specific installation instructions in repo
```

## Dependency Management

### Plugin Dependencies

Some plugins depend on or recommend other plugins:

**aeon-loop**:
- Includes: aeon-flux (automatically installed)
- Recommends: mind-glaive (enhances context persistence)

**Installation with dependencies**:
```bash
# Install aeon-loop (includes aeon-flux)
/plugin add TheGlitchKing/aeon-loop

# Optionally install recommended plugin
/plugin install TheGlitchKing/mind-glaive
```

## Troubleshooting

### Common Issues

#### Issue: "jq: command not found"

**Solution**:
```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS
brew install jq

# Verify
jq --version
```

#### Issue: "Node.js version too old"

**Solution**:
```bash
# Install Node.js 20+ via nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 20
nvm use 20
node --version
```

#### Issue: "Submodule directory is empty"

**Solution**:
```bash
# Initialize and update submodules
git submodule init
git submodule update

# Or clone with --recursive flag
git clone --recursive <repo-url>
```

#### Issue: "Claude plugin not found"

**Solution**:
1. Check Claude Code version: `claude --version`
2. Verify plugin installation: `ls ~/.claude/` or `ls ./.claude/`
3. Restart Claude Code
4. Check plugin configuration: `cat ~/.claude/config.json`

#### Issue: "Permission denied" when running scripts

**Solution**:
```bash
# Make scripts executable
chmod +x scripts/*.sh

# Or run with bash
bash scripts/install-plugin.sh <plugin-name>
```

#### Issue: "Python module not found" (mind-glaive MCP servers)

**Solution**:
```bash
# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install requirements
cd mcp-servers/project-kb
pip install -r requirements.txt
```

### Getting Help

1. **Plugin-specific issues**: Open issue on plugin repository
   - hit-em-with-the-docs: https://github.com/TheGlitchKing/hit-em-with-the-docs/issues
   - mind-glaive: https://github.com/TheGlitchKing/mind-glaive/issues
   - aeon-loop: https://github.com/TheGlitchKing/aeon-loop/issues

2. **Marketplace issues**: https://github.com/TheGlitchKing/glitch-kingdom-of-plugins/issues

3. **Documentation**: Check plugin-specific README files

## Verification

### Verify hit-em-with-the-docs
```bash
hewtd --version
hewtd list
```

### Verify mind-glaive
```bash
# Check files
ls ~/.claude/

# Try a command in Claude Code
/context/status
```

### Verify aeon-loop/flux
```bash
# Try commands in Claude Code
/status
/aeon-flux
```

## Updating Plugins

### Update NPM packages
```bash
npm update -g hit-em-with-the-docs
```

### Update Claude plugins
```bash
# Via Claude marketplace (if available)
/plugin update mind-glaive

# Or manually
cd ~/.claude/plugins/mind-glaive
git pull
```

### Update marketplace submodules
```bash
cd glitch-kingdom-of-plugins
./scripts/sync-submodules.sh
```

## Uninstalling

### Uninstall NPM packages
```bash
npm uninstall -g hit-em-with-the-docs
```

### Uninstall Claude plugins
```bash
# User scope
rm -rf ~/.claude/

# Project scope
rm -rf ./.claude/

# Or use plugin uninstaller if available
cd mind-glaive
./uninstall.sh
```

### Remove marketplace clone
```bash
rm -rf glitch-kingdom-of-plugins
```

## Next Steps

After installation:

1. **Read plugin documentation**: Each plugin has detailed docs in its repository
2. **Try examples**: Check `examples/` directories in plugin repos
3. **Configure**: Customize plugin settings for your workflow
4. **Integrate**: Set up CI/CD, hooks, or automation as needed

## Best Practices

1. **Use stable versions**: Install tagged releases, not bleeding-edge commits
2. **Read changelogs**: Review breaking changes before updating
3. **Test in dev first**: Try new versions in development before production
4. **Keep plugins updated**: Regular updates include bug fixes and security patches
5. **Use virtual environments**: For Python-based plugins (mind-glaive MCP servers)
6. **Backup configs**: Save your `.claude/` and plugin configurations

## Support

For installation support:
- Check plugin README files
- Search existing issues
- Open a new issue with:
  - Operating system and version
  - Tool versions (Node.js, Python, Claude Code)
  - Full error message
  - Steps to reproduce
