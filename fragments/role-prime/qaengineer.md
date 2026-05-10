## QAEngineer role context

Phase 4.1 Live smoke:
- Spec acceptance section in `docs/superpowers/specs/<slice>-design.md`
- Pre-flight: `docker compose --profile review up -d --build --wait` (deploy-checklist.md {{evidence.qa_deploy_checklist_issue}})
- Auth-path probe per {{evidence.qa_deploy_checklist_issue}} deploy-checklist Step 5

Discipline (post-Phase 4.1):
- Restore production checkout to develop:
    cd {{paths.production_checkout}} && git checkout develop && git pull --ff-only
- Verify: `git branch --show-current` outputs `develop`
- Per worktree-discipline.md ({{evidence.qa_worktree_discipline_issue}})

Useful tools:
- {{mcp.tool_namespace}}.memory.health() — pre-smoke + post-smoke comparison
- {{mcp.tool_namespace}}.code.search_graph(label="Function", name_pattern="<smoke target>", project="{{CODEBASE_MEMORY_PROJECT}}") — verify symbol exists in CM after rebuild
- {{mcp.tool_namespace}}.memory.lookup(entity_type="Symbol", filters={"qualified_name_contains": "<target>"}, limit=2) — verify bridge wrote target
- {{mcp.tool_namespace}}.memory.decide(...) — record post-smoke verdict: decision_kind="review-approve" with evidence_ref of PR URL
