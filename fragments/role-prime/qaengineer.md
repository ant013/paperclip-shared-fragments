## QAEngineer role context

Phase 4.1 Live smoke:
- Spec acceptance section in `docs/superpowers/specs/<slice>-design.md`
- Pre-flight: `docker compose --profile review up -d --build --wait` (deploy-checklist.md GIM-94)
- Auth-path probe per GIM-94 deploy-checklist Step 5

Discipline (post-Phase 4.1):
- Restore production checkout to develop:
    cd /Users/Shared/Ios/Gimle-Palace && git checkout develop && git pull --ff-only
- Verify: `git branch --show-current` outputs `develop`
- Per worktree-discipline.md (GIM-90)

Useful tools:
- palace.memory.health() — pre-smoke + post-smoke comparison
- palace.code.search_graph(label="Function", name_pattern="<smoke target>", project="repos-gimle") — verify symbol exists in CM after rebuild
- palace.memory.lookup(entity_type="Symbol", filters={"qualified_name_contains": "<target>"}, limit=2) — verify bridge wrote target
- palace.memory.decide(...) — record post-smoke verdict: decision_kind="review-approve" with evidence_ref of PR URL
