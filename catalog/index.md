# Plugin Catalog

**Marketplace**: glitch-kingdom-of-plugins v1.0.0
**Description**: Official marketplace for TheGlitchKing's Claude Code plugins and development tools
**Total Plugins**: 10

---

## All Plugins

### Hit 'Em With The Docs

**ID**: `hit-em-with-the-docs`
**Type**: cli-tool
**Version**: 2.1.0
**Status**: production-ready
**Category**: documentation

Self-managing documentation system with hierarchical structure, intelligent automation, pattern discovery, and agent orchestration

**Homepage**: https://github.com/TheGlitchKing/hit-em-with-the-docs

**Installation**:

### Mind Glaive

**ID**: `mind-glaive`
**Type**: claude-plugin
**Version**: 2.0.1
**Status**: production-ready
**Category**: productivity

Eliminate context rot in Claude Code with intelligent memory, auto-learning hooks, and specialized subagents

**Homepage**: https://github.com/TheGlitchKing/mind-glaive

**Installation**:

### Aeon Loop

**ID**: `aeon-loop`
**Type**: claude-plugin
**Version**: 2.0.0
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
**Version**: 1.2.0
**Status**: production-ready
**Category**: productivity

Progressive linting with directory-chunked baselines, drift detection, and auto-healing for monorepo projects (Python + JS/TS)

**Homepage**: https://github.com/TheGlitchKing/gimme-the-lint

**Installation**:

### Babel Fish

**ID**: `babel-fish`
**Type**: claude-plugin
**Version**: 2.0.0
**Status**: production-ready
**Category**: developer-tools

Auto-generates a project map, vocabulary translation layer, and developer skill for any codebase. Introspects routes, models, services, features, infrastructure, and session history to give Claude instant full-stack context. Self-updates via pre-commit hook. Iterative install with 90% quality threshold and human-readable grading reports.

**Homepage**: https://github.com/TheGlitchKing/babel-fish

**Installation**:

### Persistent Planning

**ID**: `persistent-planning`
**Type**: claude-plugin
**Version**: 2.0.0
**Status**: production-ready
**Category**: productivity

Persistent markdown-based planning with task directories, progress tracking, and context engineering for multi-step Claude Code workflows

**Homepage**: https://github.com/TheGlitchKing/persistent-planning

**Installation**:

### Semantic Pages

**ID**: `semantic-pages`
**Type**: mcp-server
**Version**: 0.10.0
**Status**: beta
**Category**: search

Semantic search + knowledge graph MCP server for any folder of markdown files. 21 tools: vector search, text search, graph traversal, CRUD, frontmatter/tag management. No Docker, no Python, no Obsidian.

**Homepage**: https://github.com/TheGlitchKing/semantic-pages

**Installation**:

### The Joy of Diagraming

**ID**: `the-joy-of-diagraming`
**Type**: claude-plugin
**Version**: 2.0.0
**Status**: production-ready
**Category**: developer-tools

Generate production-quality SVG technical diagrams (architecture, flowchart, UML, ER, sequence, and more) with 7 built-in visual styles. Export as SVG+PNG via @resvg/resvg-js — zero system dependencies, pure npm.

**Homepage**: https://github.com/TheGlitchKing/the-joy-of-diagraming

**Installation**:

### Glitch Browser Plugin

**ID**: `glitch-browser-plugin`
**Type**: claude-plugin
**Version**: 0.1.0
**Status**: beta
**Category**: developer-tools

Let Claude Code (on a remote dev box) drive your real local Chrome over a CDP-over-SSH reverse tunnel, for frontend troubleshooting. You watch and click in the same window.

**Homepage**: https://github.com/TheGlitchKing/glitch-browser-plugin

**Installation**:

- **NPM**: `npm install -g @theglitchking/hit-em-with-the-docs`
- **NPX**: `npx @theglitchking/hit-em-with-the-docs`
- **Claude**: `/plugin install TheGlitchKing/hit-em-with-the-docs`

**Tags**: documentation, cli, github-action, automation, self-managing, claude-plugin

---

- **NPM**: `npm install --save-dev @theglitchking/mind-glaive`
- **Claude**: `/plugin marketplace add TheGlitchKing/mind-glaive && /plugin install mind-glaive@mind-glaive-marketplace`

**Tags**: context-management, memory, learning, automation, hooks, subagents

---

- **NPM**: `npm install --save-dev @theglitchking/aeon-loop`
- **Claude**: `/plugin marketplace add TheGlitchKing/aeon-loop && /plugin install aeon-loop@aeon-loop-marketplace`

**Tags**: automation, autonomous, loop, task-execution, orchestration

---


**Tags**: bash-loop, action-oriented, subagent-control, context-preservation

---

- **NPM**: `npm install --save-dev @theglitchking/gimme-the-lint && npx gimme-the-lint install`
- **NPX**: `npx @theglitchking/gimme-the-lint install`
- **Claude**: `/plugin install TheGlitchKing/gimme-the-lint`

**Tags**: linting, progressive-linting, eslint, ruff, python, monorepo, git-hooks, drift-detection, github-action

---

- **NPM**: `npm install -g @theglitchking/babel-fish && babel-fish init`
- **NPX**: `npx @theglitchking/babel-fish init`
- **Claude**: `/plugin install babel-fish@glitch-kingdom-of-plugins`

**Tags**: codebase-context, project-map, vocabulary, developer-skill, introspection, drift-management

---

- **NPM**: `npm install --save-dev @theglitchking/persistent-planning`
- **Claude**: `/plugin marketplace add TheGlitchKing/persistent-planning && /plugin install persistent-planning@persistent-planning-marketplace`

**Tags**: planning, persistence, context-engineering, markdown, task-tracking

---

- **NPM**: `npm install -g semantic-pages`
- **NPX**: `npx semantic-pages --notes ./vault`
- **Claude**: `/plugin install TheGlitchKing/semantic-pages`

**Tags**: mcp-server, semantic-search, knowledge-graph, markdown, vector-search, embeddings, wikilinks

---

- **NPM**: `npm install @theglitchking/the-joy-of-diagraming`
- **NPX**: `npx skills add TheGlitchKing/the-joy-of-diagraming`
- **Claude**: `/plugin install TheGlitchKing/the-joy-of-diagraming`

**Tags**: diagram, svg, architecture, flowchart, uml, visualization, claude-skill, png-export

---

- **Claude**: `/plugin marketplace add TheGlitchKing/glitch-browser-plugin && /plugin install glitch-browser-plugin@glitch-kingdom-of-plugins`

**Tags**: browser, playwright, cdp, ssh-tunnel, frontend, remote-development

---


## By Category

- **[Developer Tools](./by-category/developer-tools.md)**: Tools for codebase introspection, context engineering, and developer workflow automation
- **[Documentation](./by-category/documentation.md)**: Tools for managing, generating, and maintaining documentation
- **[Productivity](./by-category/productivity.md)**: Tools that enhance development workflows and efficiency
- **[Automation](./by-category/automation.md)**: Tools for automating repetitive tasks
- **[Search & Knowledge](./by-category/search.md)**: Tools for semantic search, knowledge graphs, and information retrieval over markdown and code
