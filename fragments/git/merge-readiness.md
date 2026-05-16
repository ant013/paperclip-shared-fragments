## Git: merge-readiness check (cto / reviewer)

Before approving or merging a PR, verify:

1. **CI green:** `gh pr checks <PR>` — all required checks pass (`lint`, `typecheck`, `test`, `docker-build`, `qa-evidence-present` per project rules in AGENTS.md).
2. **PR approved by CR:** GitHub PR review state = `APPROVED`.
3. **Branch up-to-date with target:** `mergeStateStatus` = `CLEAN` (see `merge-state-decoder.md`).
4. **No conflict markers in diff:** `gh pr diff <PR> | grep -E '^(<<<<<<<|=======|>>>>>>>)'` → empty.
5. **Spec/plan references valid:** if PR references `docs/superpowers/plans/...`, that file exists on the branch.

Self-approval forbidden — you cannot approve your own PR even if you are the only reviewer hired.
