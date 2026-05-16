## Pre-work: existing field semantics

Before renaming, removing, or repurposing a field on an existing data structure (Pydantic model, Cypher node label, JSON schema, env var):

1. **Find all readers** via `search_graph` + `trace_path(... mode=data_flow)`.
2. **Find all writers** (often more than readers — backfill scripts, migrations, fixtures).
3. **Document the migration** in PR description: old → new mapping, deprecation window, rollback.
4. **Add backwards-compat shim** if external API surface (MCP tool args, REST endpoint params) — at least one release cycle.

Renaming a field that's referenced in saved Neo4j data without migration loses that data. Renaming an MCP tool arg without shim breaks every caller silently.
