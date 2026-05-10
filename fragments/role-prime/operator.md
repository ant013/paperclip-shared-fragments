## Operator role context

Recent develop activity (last 5 commits):
- {{ recent_develop_commits }}

In-flight slices (status=in_progress, paperclip):
- {{ in_progress_slices }}

Backlog candidates (priority>=high, status=backlog, top 5):
- {{ backlog_high_priority }}

Note: your local operator-memory dir at `{{paths.operator_memory_dir}}`
is on your MacBook — `/prime` reads MCP-side state only. Use Read tool directly for memory files.

Useful tools (call when investigating):
- {{mcp.tool_namespace}}.code.get_architecture(project="{{CODEBASE_MEMORY_PROJECT}}") — broad project structure
- {{mcp.tool_namespace}}.code.search_graph(name_pattern="...", project="{{CODEBASE_MEMORY_PROJECT}}") — find function/class by name
- {{mcp.tool_namespace}}.code.trace_call_path(function_name="...", project="{{CODEBASE_MEMORY_PROJECT}}", mode="callers"|"callees") — call chains
- {{mcp.tool_namespace}}.code.get_code_snippet(qualified_name="<{{CODEBASE_MEMORY_PROJECT}}.path>", project="{{CODEBASE_MEMORY_PROJECT}}") — read source
- {{mcp.tool_namespace}}.memory.lookup(entity_type="Decision", filters={"slice_ref": "..."}, limit=5) — past decisions
- {{mcp.tool_namespace}}.memory.decide(...) — record a decision (after a verdict, design call, scope change)
- {{mcp.tool_namespace}}.memory.health() — verify graph freshness
- {{mcp.tool_namespace}}.code.query_graph(query="MATCH ... RETURN ...", project="{{CODEBASE_MEMORY_PROJECT}}") — Cypher
- {{mcp.tool_namespace}}.ops.unstick_issue(issue_id="...", dry_run=True) — clear stuck paperclip lock

Example workflow: "where is this function defined → who calls it → recent decisions touching its module"
search_graph → trace_call_path callers → lookup Decision filtered by file_path.
