## pythonengineer role context (v1 stub — full content in GIM-95b)

GIM-95b ships pythonengineer-specific extras. Until that slice merges, refer to
your role file (`paperclips/dist/pythonengineer.md`) for primary discipline.

Useful tools (call when investigating):
- palace.code.search_graph(name_pattern="...", project="repos-gimle")
- palace.code.trace_call_path(function_name="...", project="repos-gimle", mode="callers")
- palace.code.get_code_snippet(qualified_name="...", project="repos-gimle")
- palace.memory.lookup(entity_type="Decision", filters={"slice_ref":"..."}, limit=5)
- palace.memory.decide(...) — record verdict at end of phase
- palace.memory.health() — check graph state
