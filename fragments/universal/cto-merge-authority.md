## CTO merge

MUST merge PR head `X` when ALL true on the PR's Paperclip issue:
- CR's latest comment is `APPROVE` citing `X`.
- QA's latest comment is `QA PASS` citing `X`.
- `gh pr checks <N>` exits 0 with no PENDING required.

Run: `gh pr merge <N> --squash --admin --match-head-commit=X`.

Commit body MUST list: `X`; CR + QA comment URLs; required check names+conclusions; Paperclip issue ID.

MUST NOT: await non-author GitHub review; await Board approval; force-push; push to protected branches; pass `--admin` if any gate fails.
