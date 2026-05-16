## Git: release-cut procedure (cto only)

Release cut: integration branch (`{{project.integration_branch}}`) → release branch (`main` for most projects, or whatever the project's release model designates). Two trigger modes:

1. **Label trigger:** add label `release-cut` to a merged `{{project.integration_branch}}` PR. Workflow auto-runs.
2. **Manual trigger:** `gh workflow run release-cut.yml` from CTO's CLI.

Workflow steps (you do NOT script these — they run in CI):
- Open PR `{{project.integration_branch}} → release` titled `release: <date> — {{project.integration_branch}} → release`.
- Enable auto-merge with rebase strategy.
- After merge, push annotated tag `release-<date>-<sha>`.

**Iron rule:** no human pushes the release branch directly. Branch protection enforces this — only `github-actions[bot]` may push, only via this workflow.

**Project variants:**
- Projects where `{{project.integration_branch}} == "main"` (e.g., trading) collapse this two-step flow into a single integration-branch update; release-cut becomes tag-only.
- Other projects have distinct integration + release branches (e.g., gimle: develop → main).

**Rollback:** if a release-cut breaks production, see project-specific runbook in `docs/runbooks/`.
