## CTO autonomous merge

CTO may merge when all true for PR head SHA `X`:

1. CR's latest comment on the Paperclip issue is `APPROVE` for `X`.
2. QA posted `QA PASS` on the same issue for `X`.
3. Required GitHub checks are green for `X`.

Action: `gh pr merge <N> --squash --match-head-commit=X`.
Merge commit body MUST include: SHA `X`, CR comment URL, QA comment URL, required-check names + conclusions, Paperclip issue ID.

If `gh` rejects only with a PR-author-cannot-self-approve error (e.g. `Review must be from a user other than the PR author`), CTO may add `--admin` and restate gates 1-3 in the merge body. Any other rejection: `@Board blocked`, stop.

Forbidden: direct push to protected branches, force-push, merging without CR+QA evidence.
