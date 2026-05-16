## QA: smoke + evidence (qa)

### Live smoke checklist (Phase 4.1)

On the production target (iMac for gimle, dev Mac for codex-only uaudit):

1. **Restore production checkout to `{{project.integration_branch}}`** before any test:
   ```
   cd {{paths.production_checkout}} && git fetch && git checkout {{project.integration_branch}} && git pull --ff-only
   ```
   Codified after GIM-48: feature-branch checkout in production_checkout caused stale-code QA pass.
2. **Run real MCP tool against real palace-mcp/{{mcp.service_name}}** (not testcontainers):
   - For new extractor: `palace.ingest.run_extractor(name="<new>", project="<test-project>")`
   - For new tool: invoke directly via paperclip MCP client
3. **Verify output via direct query** (Cypher for Neo4j, jq for JSON, sqlite3 for SQL):
   - Don't trust the tool's success envelope — query the actual side effect.
4. **CLI invariant:** if the change touches CLI, run real CLI command and capture full stdout/stderr.

### Evidence format (QA Evidence comment)

PR body must contain `## QA Evidence` section before merge. CI check `qa-evidence-present` enforces this (grep-only — content quality is YOUR responsibility, not CI's).

```markdown
## QA Evidence

**Smoke run on:** iMac, 2026-05-15T14:23Z, on commit <SHA>

**1. Extractor invocation:**
$ palace.ingest.run_extractor(name="my_extractor", project="gimle")
{"ok": true, "run_id": "abc-...", "duration_ms": 1247, "nodes_written": 42, ...}

**2. Direct Cypher verification:**
MATCH (n:NewNodeType) RETURN count(n) → 42

**3. CLI smoke:**
$ ./scripts/my-new-cli --target gimle
... actual output ...

**4. Negative test (handles error correctly):**
$ palace.ingest.run_extractor(name="my_extractor", project="nonexistent")
{"ok": false, "error_code": "project_not_registered", ...}
```

### Forbidden evidence patterns (codified after GIM-127)

- Numbers exactly matching dev-Mac fixture oracle while claiming iMac smoke.
- Paraphrasing tool output ("returned successfully") instead of pasting envelope.
- Skipping negative test ("happy path passes" only).
- Evidence authored on dev Mac when PR claims iMac smoke (verify host in evidence header).
- Reusing evidence from a different PR (always include current PR's commit SHA in evidence).

### Restore checkout post-smoke

After smoke completes, restore `{{paths.production_checkout}}` to `{{project.integration_branch}}` (not the feature branch you tested) before handoff to CTO. Otherwise next session starts on stale feature branch.
