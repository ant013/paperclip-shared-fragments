## Pre-work discovery (before any task)

Before writing code or decomposing — verify the feature / fix doesn't already exist:

1. `git fetch --all && git log --all --grep="<keyword>" --oneline`
2. `gh pr list --state all --search "<keyword>"` — open and merged
3. `serena find_symbol` / `get_symbols_overview` — existing implementations
4. `docs/` — spec may already be written
5. Paperclip issues — is someone already working on it?

**If it exists** — close the issue as `duplicate` with a link, or reframe it ("integrate X from feature/Y"). Don't start a new one.

## External library reference rule

Any spec line that references an external library API (constructor,
method, return-type) MUST be backed by a live-verified spike committed
to the repo under `docs/research/<library-version>-spike/` or a
`reference_<lib>_api_truth.md` memory file dated within the last 30
days.

Memory references are not enough by themselves — memory drifts; cite
both the memory file AND the underlying repo spike.

CTO Phase 1.1 runs:

    grep -E 'from <lib> import|<lib>\.<method>' <spec-file> | wc -l

For every match, verify a corresponding spike file exists or REQUEST
CHANGES citing this rule.

**Why:** N+1a (2026-04-18) was reverted because the spec referenced
`graphiti-core 0.4.3` API that didn't exist in the installed version;
N+1a.1 rev1 (2026-04-24) hardcoded `LLM: None` against the same
unverified guess. Both could have been caught by a 30-minute spike.

## Existing-field semantic-change rule

If the spec changes the semantics of a field/property/column that
already exists in code (e.g. "`:Project` stores slug in
`EntityNode.name`"), the spec writer MUST include in the spec:

1. Output of `grep -r '<field-name>' src/` showing every existing
   call-site.
2. An explicit list of which call-sites change and which don't.

CTO Phase 1.1 verifies the grep output is current (re-runs against
HEAD); REQUEST CHANGES if the spec is missing the audit or if grep
output reveals call-sites the spec doesn't acknowledge.

**Why:** N+1a.1 §3.10 changed `:Project.name` semantics without grep'ing
`UPSERT_PROJECT` which already used `name` for a display string.
OpusArchitectReviewer caught the latent production bug at Phase 3.2 —
should have been caught at Phase 1.1 with a 1-minute grep.
