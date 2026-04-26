## Operator role context

Recent develop activity (last 5 commits):
- {{ recent_develop_commits }}

In-flight slices (status=in_progress, paperclip):
- {{ in_progress_slices }}

Backlog candidates (priority>=high, status=backlog, top 5):
- {{ backlog_high_priority }}

Note: your local operator-memory dir at `~/.claude/projects/-Users-ant013-Android-Gimle-Palace/memory/`
is on your MacBook — `/prime` reads MCP-side state only. Use Read tool directly for memory files.

Useful tools (call when investigating):
- palace.code.get_architecture(project="repos-gimle") — broad project structure
- palace.code.search_graph(name_pattern="...", project="repos-gimle") — find function/class by name
- palace.code.trace_call_path(function_name="...", project="repos-gimle", mode="callers"|"callees") — call chains
- palace.code.get_code_snippet(qualified_name="<repos-gimle.path>", project="repos-gimle") — read source
- palace.memory.lookup(entity_type="Decision", filters={"slice_ref": "..."}, limit=5) — past decisions
- palace.memory.decide(...) — record a decision (after a verdict, design call, scope change)
- palace.memory.health() — verify graph freshness
- palace.code.query_graph(query="MATCH ... RETURN ...", project="repos-gimle") — Cypher
- palace.ops.unstick_issue(issue_id="...", dry_run=True) — clear stuck paperclip lock

Example workflow: "where is this function defined → who calls it → recent decisions touching its module"
search_graph → trace_call_path callers → lookup Decision filtered by file_path.
