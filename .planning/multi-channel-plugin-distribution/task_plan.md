# Task Plan: Multi-Channel Plugin Distribution

## Goal
Implement unified multi-channel distribution for all three Glitch Kingdom plugins (hit-em-with-the-docs, mind-glaive, aeon-loop) across NPM and Claude Code marketplace with consistent scoping under `@theglitchking/` namespace.

## Phases
- [x] Phase 1: hit-em-with-the-docs - Scoping & Plugin Structure (1-2 days)
  - Update package.json to scoped `@theglitchking/hit-em-with-the-docs` v2.0.0
  - Create `.claude-plugin/plugin.json` and marketplace.json
  - Create MIGRATION.md guide
  - Deprecate old unscoped package v1.1.0
  - Publish new scoped v2.0.0
  - Test: npm install, npx, Claude plugin commands

- [ ] Phase 2: mind-glaive - NPM Packaging (1-2 days)
  - Create package.json with scoped name v1.1.0
  - Create `bin/mind-glaive.js` CLI wrapper (executes install.sh)
  - Create postinstall.js messaging
  - Update README.md with NPM installation
  - Create CHANGELOG.md
  - Publish to NPM
  - Test: npm install, mind-glaive install, Claude commands

- [ ] Phase 3: aeon-loop - NPM Packaging with bundled aeon-flux (1-2 days)
  - Create package.json v1.1.0 noting bundled aeon-flux
  - Create `bin/aeon-loop.js` CLI wrapper (copies plugin files)
  - Create postinstall.js mentioning bundling
  - Update README.md with NPM + bundling info
  - Create CHANGELOG.md
  - Publish to NPM
  - Test: Both aeon-loop and aeon-flux available

- [ ] Phase 4: Marketplace Documentation Updates (1 day)
  - Update marketplace.json for all 4 plugins (hewtd v2.0.0, mind-glaive v1.1.0, aeon-loop v1.1.0, aeon-flux bundling note)
  - Update .documentation/quickstart/INSTALLATION_GUIDE.md with NPM sections
  - Update .documentation/standards/plugin-standards.md with scoping requirements
  - Update README.md quick start
  - Regenerate catalog
  - Run hewtd maintain --quick --fix
  - Validate marketplace.json

- [ ] Phase 5: Testing & Verification (1 day)
  - Test all NPM installations (global + npx) for all 3 plugins
  - Test Claude Code integration after NPM install
  - Test on multiple platforms (Linux, macOS, WSL2)
  - Validate marketplace.json schema
  - Verify documentation accuracy
  - Check health score ≥ 80%

## Key Questions
1. ✅ Should we use scoped NPM packages? YES - `@theglitchking/` for all
2. ✅ How to handle bash-based plugins (mind-glaive, aeon-loop) in NPM? NPM wrapper executes bash installers
3. ✅ Should aeon-flux be bundled or separate? Bundled with aeon-loop
4. ✅ What version bumps? hewtd: 1.0.0→2.0.0 (breaking), mind-glaive: 1.0.0→1.1.0 (feature), aeon-loop: 1.0.0→1.1.0 (feature)
5. ✅ Backwards compatibility strategy? Deprecate old hewtd but maintain 6 months, others add new channels

## Decisions Made
- **NPM Scoping**: All packages scoped under `@theglitchking/` for brand consistency and namespace management
- **NPM Wrapper Strategy**: Bash plugins (mind-glaive, aeon-loop) use Node.js CLI wrappers that execute existing install.sh scripts
- **Version Management**: Unified validation script ensures package.json, plugin.json, marketplace.json all match
- **aeon-flux Bundling**: Remains bundled with aeon-loop for simplicity (one install gets both)
- **hit-em-with-the-docs Scoping**: 1.0.0→2.0.0 (breaking change due to package name), add Claude plugin capability
- **Backwards Compatibility**: Deprecate unscoped hit-em-with-the-docs but keep available for 6 months

## Critical Files

### Phase 1: hit-em-with-the-docs
- `/mnt/e/docker-containers/hit-em-with-the-docs/package.json` - Rename to scoped, v2.0.0
- `/mnt/e/docker-containers/hit-em-with-the-docs/.claude-plugin/plugin.json` - NEW
- `/mnt/e/docker-containers/hit-em-with-the-docs/.claude-plugin/marketplace.json` - NEW
- `/mnt/e/docker-containers/hit-em-with-the-docs/MIGRATION.md` - NEW

### Phase 2: mind-glaive
- `/mnt/e/docker-containers/mind-glaive/package.json` - NEW
- `/mnt/e/docker-containers/mind-glaive/bin/mind-glaive.js` - NEW CLI wrapper
- `/mnt/e/docker-containers/mind-glaive/postinstall.js` - NEW
- `/mnt/e/docker-containers/mind-glaive/plugin.json` - Update to v1.1.0

### Phase 3: aeon-loop
- `/mnt/e/docker-containers/aeon-loop/package.json` - NEW
- `/mnt/e/docker-containers/aeon-loop/bin/aeon-loop.js` - NEW CLI wrapper
- `/mnt/e/docker-containers/aeon-loop/postinstall.js` - NEW
- `/mnt/e/docker-containers/aeon-loop/.claude-plugin/plugin.json` - Update to v1.1.0

### Phase 4: Marketplace
- `/mnt/e/docker-containers/glitch-kingdom-of-plugins/marketplace.json`
- `/mnt/e/docker-containers/glitch-kingdom-of-plugins/.documentation/quickstart/INSTALLATION_GUIDE.md`
- `/mnt/e/docker-containers/glitch-kingdom-of-plugins/.documentation/standards/plugin-standards.md`
- `/mnt/e/docker-containers/glitch-kingdom-of-plugins/README.md`

## Errors Encountered
(None yet - will be logged as they occur)

## Rollback Plans

### Phase 1 Rollback
```bash
npm unpublish @theglitchking/hit-em-with-the-docs@2.0.0
npm deprecate hit-em-with-the-docs@1.1.0 ""
git revert <commit> && git tag -d v2.0.0
```

### Phase 2/3 Rollback
```bash
npm unpublish @theglitchking/[plugin-name]@1.1.0
git revert <commit> && git tag -d v1.1.0
```

### Phase 4 Rollback
```bash
git revert <commit>
./scripts/generate-catalog.sh
```

## Testing Checklist

### Per-Plugin NPM Tests
- [ ] hewtd: `npm install -g @theglitchking/hit-em-with-the-docs` works
- [ ] hewtd: `npx @theglitchking/hit-em-with-the-docs init` works
- [ ] hewtd: Claude plugin commands work
- [ ] mind-glaive: `npm install -g @theglitchking/mind-glaive` installs CLI
- [ ] mind-glaive: `mind-glaive install --scope user` creates ~/.claude/ files
- [ ] mind-glaive: Claude commands (/context/status) work
- [ ] aeon-loop: `npm install -g @theglitchking/aeon-loop` installs CLI
- [ ] aeon-loop: `aeon-loop install --scope user` creates files + includes aeon-flux
- [ ] aeon-loop: Both /aeon-flux and /loop commands work

### Platform Tests
- [ ] Test on Linux (WSL2)
- [ ] Test on macOS (if available)
- [ ] Test on Windows WSL2

### Validation Tests
- [ ] `./scripts/validate-plugins.sh` passes
- [ ] `hewtd maintain --quick --fix` on marketplace docs
- [ ] Documentation health score ≥ 80%
- [ ] All URLs in marketplace.json accessible
- [ ] Catalog regeneration successful

## Success Metrics
- [ ] All three plugins published to NPM under `@theglitchking/` scope
- [ ] All three plugins installable via Claude marketplace
- [ ] Documentation updated and accurate
- [ ] Validation scripts pass
- [ ] Marketplace health score ≥ 80%
- [ ] No breaking changes for existing users (except documented migration)

## Timeline Estimate
**Total**: 5-7 days

- Phase 1: 1-2 days
- Phase 2: 1-2 days
- Phase 3: 1-2 days
- Phase 4: 1 day
- Phase 5: 1 day

## Status
**Currently in Phase 1** - Implementing hit-em-with-the-docs scoping and plugin structure

## Next Actions
1. Navigate to `/mnt/e/docker-containers/hit-em-with-the-docs`
2. Read current package.json
3. Update package.json to scoped name and v2.0.0
4. Create `.claude-plugin/` directory structure
5. Create plugin.json and marketplace.json
6. Create MIGRATION.md
7. Test locally with `npm pack`
8. Publish deprecated v1.1.0
9. Publish new scoped v2.0.0
