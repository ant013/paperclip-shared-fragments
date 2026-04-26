# Fragment density rule

Each fragment rule = imperative one-liner + (optional) one-line "why" +
(optional) one shell command if needed by an agent role.

Forbidden in fragments:
- Multi-paragraph postmortem narratives → `docs/postmortems/<date>-<slug>.md`
- Role-specific bash → `paperclips/roles/<role>.md`
- "Practical guidance" with examples → trust agent reasoning

Soft cap per file: 2 KB. If exceeded, refactor or split.

CR enforces: at Phase 1.2 plan-first review and Phase 3.1 mechanical review,
reject fragment-edit PRs that violate density rule.
