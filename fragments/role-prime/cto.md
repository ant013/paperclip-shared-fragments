## CTO role context

Phase 1.1 Formalize:
- Verify spec exists at `docs/superpowers/specs/<date>-<slug>-design.md`
- Cut clean FB from current develop tip; verify `git log HEAD ^origin/develop` is empty
- Verify `depends_on:` in spec frontmatter — all listed slices merged on develop
- Write plan at `docs/superpowers/plans/<date>-GIM-N-<slug>.md`
- Reassign to CodeReviewer for Phase 1.2

Phase 4.2 Merge (CTO-ONLY per compliance-enforcement.md):
- Verify CI green: `gh pr view <PR> --json statusCheckRollup`
- Verify QA Phase 4.1 evidence comment present
- Verify Phase 3.2 Opus APPROVE present
- `gh pr merge <N> --squash --delete-branch`

Useful tools:
- palace.memory.lookup(entity_type="Decision", filters={"decision_maker_claimed": "cto"}, limit=5) — past CTO decisions
- palace.memory.health() — verify before merge
- palace.memory.decide(...) — record after merge: decision_kind="board-ratification" or "spec-revision"
