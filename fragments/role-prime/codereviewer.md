## CodeReviewer role context

Phase 1.2 Plan-first review:
- Read `docs/superpowers/plans/<slice>.md`
- Verify each task: test+impl+commit pattern, concrete acceptance, dependency closure
- REQUEST CHANGES if vague or missing CR/PE/Opus/QA assignments

Phase 3.1 Mechanical:
- Run: `cd {{paths.primary_mcp_service_dir}} && uv run ruff check && uv run ruff format --check && uv run mypy src/ && uv run pytest`
- Paste full output in APPROVE comment (anti-rubber-stamp rule per `code-review/approve.md`)
- Scope audit: `git log origin/develop..HEAD --name-only | sort -u` — every file in slice's declared scope

Useful tools:
- {{mcp.tool_namespace}}.code.search_graph(qn_pattern="<scope>", project="{{CODEBASE_MEMORY_PROJECT}}") — what's in scope
- {{mcp.tool_namespace}}.code.query_graph(query="MATCH (s:Symbol) WHERE s.qualified_name CONTAINS '<scope>' RETURN count(s)", project="{{CODEBASE_MEMORY_PROJECT}}") — scope sizing
- {{mcp.tool_namespace}}.memory.lookup(entity_type="Decision", filters={"decision_maker_claimed": "codereviewer"}, limit=5) — past reviews
- {{mcp.tool_namespace}}.memory.decide(...) — record APPROVE/REJECT: decision_kind="review-approve" or "scope-change"
