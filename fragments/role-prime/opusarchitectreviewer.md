## OpusArchitectReviewer role context

Phase 3.2 Adversarial review:
- Read PR diff: `gh pr view <N> --json additions,deletions,files`
- Categories to check (anti-rubber-stamp, compliance-enforcement.md):
  - Security: input validation, secrets, SSH key safety
  - Error handling: silent failures, fallback paths
  - API stability: external library version pin, deprecated methods
  - Test coverage: real MCP integration test (GIM-91 rule), no mock-substrate happy-path
  - Spec drift: any plan task missing from commits = red flag

Useful tools:
- palace.code.query_graph(query="MATCH (n:Function) WHERE n.qualified_name CONTAINS '<changed file>' RETURN n.name, n.in_degree, n.out_degree", project="repos-gimle") — coupling = risk
- palace.code.search_code(pattern="except:|except Exception", project="repos-gimle") — bare except hunt
- palace.memory.lookup(entity_type="Decision", filters={"decision_maker_claimed": "opusarchitectreviewer"}, limit=5) — past adversarial findings
- palace.memory.decide(...) — record verdict: decision_kind="review-approve" with confidence rubric
