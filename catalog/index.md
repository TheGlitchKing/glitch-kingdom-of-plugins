# Plugin Catalog

**Marketplace**: glitch-kingdom-of-plugins v1.0.0
**Description**: Official marketplace for TheGlitchKing's Claude Code plugins and development tools
**Total Plugins**: 7

---

## All Plugins

### Hit 'Em With The Docs

**ID**: `hit-em-with-the-docs`
**Type**: cli-tool
**Version**: 2.0.0
**Status**: production-ready
**Category**: documentation

Self-managing documentation system with hierarchical structure, intelligent automation, pattern discovery, and agent orchestration

**Homepage**: https://github.com/TheGlitchKing/hit-em-with-the-docs

**Installation**:

### Mind Glaive

**ID**: `mind-glaive`
**Type**: claude-plugin
**Version**: 1.1.0
**Status**: production-ready
**Category**: productivity

Eliminate context rot in Claude Code with intelligent memory, auto-learning hooks, and specialized subagents

**Homepage**: https://github.com/TheGlitchKing/mind-glaive

**Installation**:

### Aeon Loop

**ID**: `aeon-loop`
**Type**: claude-plugin
**Version**: 1.1.0
**Status**: production-ready
**Category**: productivity

Autonomous task execution with loop engine, orchestrated subagents, context persistence, and intelligent failure recovery. Includes bundled aeon-flux.

**Homepage**: https://github.com/TheGlitchKing/aeon-loop

**Installation**:

### Aeon Flux

**ID**: `aeon-flux`
**Type**: claude-plugin
**Version**: 1.0.0
**Status**: production-ready
**Category**: productivity

Bash Loop operating mode - action over explanation, tight feedback loops, intelligent context preservation

**Homepage**: https://github.com/TheGlitchKing/aeon-flux

**Installation**:

### Gimme The Lint

**ID**: `gimme-the-lint`
**Type**: claude-plugin
**Version**: 1.0.1
**Status**: production-ready
**Category**: productivity

Progressive linting with directory-chunked baselines, drift detection, and auto-healing for monorepo projects (Python + JS/TS)

**Homepage**: https://github.com/TheGlitchKing/gimme-the-lint

**Installation**:

### Babel Fish

**ID**: `babel-fish`
**Type**: claude-plugin
**Version**: 1.0.0
**Status**: production-ready
**Category**: developer-tools

Auto-generates a project map, vocabulary translation layer, and developer skill for any codebase. Introspects routes, models, services, features, infrastructure, and session history to give Claude instant full-stack context. Self-updates via pre-commit hook. Iterative install with 90% quality threshold and human-readable grading reports.

**Homepage**: https://github.com/TheGlitchKing/babel-fish

**Installation**:

### Persistent Planning

**ID**: `persistent-planning`
**Type**: claude-plugin
**Version**: 1.0.0
**Status**: production-ready
**Category**: productivity

Persistent markdown-based planning with task directories, progress tracking, and context engineering for multi-step Claude Code workflows

**Homepage**: https://github.com/TheGlitchKing/persistent-planning

**Installation**:

- **NPM**: `npm install -g @theglitchking/hit-em-with-the-docs`
- **NPX**: `npx @theglitchking/hit-em-with-the-docs`
- **Claude**: `/plugin install TheGlitchKing/hit-em-with-the-docs`

**Tags**: documentation, cli, github-action, automation, self-managing, claude-plugin

---

- **NPM**: `npm install -g @theglitchking/mind-glaive && mind-glaive install --scope user --template full-stack`
- **NPX**: `npx @theglitchking/mind-glaive install --scope user --template full-stack`
- **Claude**: `/plugin install TheGlitchKing/mind-glaive`

**Tags**: context-management, memory, learning, automation, hooks, subagents

---

- **NPM**: `npm install -g @theglitchking/aeon-loop && aeon-loop install --scope user`
- **NPX**: `npx @theglitchking/aeon-loop install --scope user`
- **Claude**: `/plugin add TheGlitchKing/aeon-loop`

**Tags**: automation, autonomous, loop, task-execution, orchestration

---


**Tags**: bash-loop, action-oriented, subagent-control, context-preservation

---

- **NPM**: `npm install --save-dev @theglitchking/gimme-the-lint && npx gimme-the-lint install`
- **NPX**: `npx @theglitchking/gimme-the-lint install`
- **Claude**: `/plugin install TheGlitchKing/gimme-the-lint`

**Tags**: linting, progressive-linting, eslint, ruff, python, monorepo, git-hooks, drift-detection, github-action

---

- **Claude**: `/plugin install TheGlitchKing/babel-fish`

**Tags**: codebase-context, project-map, vocabulary, developer-skill, introspection, drift-management

---

- **NPM**: `npm install -g @theglitchking/persistent-planning && persistent-planning install --scope user`
- **NPX**: `npx @theglitchking/persistent-planning install --scope user`
- **Claude**: `/plugin install TheGlitchKing/persistent-planning`

**Tags**: planning, persistence, context-engineering, markdown, task-tracking

---


## By Category

- **[Developer Tools](./by-category/developer-tools.md)**: Tools for codebase introspection, context engineering, and developer workflow automation
- **[Documentation](./by-category/documentation.md)**: Tools for managing, generating, and maintaining documentation
- **[Productivity](./by-category/productivity.md)**: Tools that enhance development workflows and efficiency
- **[Automation](./by-category/automation.md)**: Tools for automating repetitive tasks
