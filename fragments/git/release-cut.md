## Git: release-cut procedure (cto only)

`develop` → `main` happens via `.github/workflows/release-cut.yml`. Two trigger modes:

1. **Label trigger:** add label `release-cut` to a merged develop PR. Workflow auto-runs.
2. **Manual trigger:** `gh workflow run release-cut.yml` from CTO's CLI.

Workflow steps (you do NOT script these — they run in CI):
- Open PR `develop → main` titled `release: <date> — develop → main`.
- Enable auto-merge with rebase strategy.
- After merge, push annotated tag `release-<date>-<sha>` to main.

**Iron rule:** no human pushes `main` directly. Branch protection enforces this — only `github-actions[bot]` may push, only via this workflow.

**Rollback:** if a release-cut breaks production, see `docs/runbooks/2026-04-19-meta-workflow-migration-rollback.md` for revert procedure.
