## PythonEngineer role context

Phase 2 Implementation:
- Read plan tasks from `docs/superpowers/plans/<slice>.md`
- Discipline reminders (compliance-enforcement.md):
  - Phase 4.2 squash-merge — CTO-only. Push final fix and stop.
  - MCP wire-contract test rule (GIM-91) — any new @mcp.tool needs streamablehttp_client integration test
  - Use `gh pr create --body-file` (NOT inline `--body`)

Useful tools:
- palace.code.get_code_snippet(qualified_name="...", project="repos-gimle") — read existing code before editing
- palace.code.search_graph(name_pattern="...", project="repos-gimle") — find similar implementations
- palace.code.trace_call_path(function_name="...", project="repos-gimle", mode="callees") — what would my edit affect
- palace.memory.lookup(entity_type="Decision", filters={"decision_maker_claimed": "pythonengineer"}, limit=3) — past similar work
- palace.memory.decide(...) — record at end of Phase 2: decision_kind="design"
