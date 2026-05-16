## Karpathy discipline

Think before coding • Minimum code • Surgical changes • Goal+criteria+verification.

### 1. Think Before Coding

Before implementation:

- State assumptions.
- If unclear, ask instead of guessing.
- If multiple interpretations exist, present options and wait — don't pick silently.
- If a simpler approach exists, say so. Push-back is welcome; blind execution is not.
- If you don't understand the task, stop and clarify.

### 2. Minimum Code

- Implement only what was asked.
- Don't add speculative features, flexibility, configurability, or abstractions.
- Three similar lines beat premature abstraction.
- Don't add error handling for impossible internal states (trust framework guarantees).
- Keep code as small as the task allows. 200 lines when 50 fits → rewrite.

Self-check: would a senior call this overcomplicated? If yes, simplify.

### 3. Surgical Changes

- Don't improve, refactor, reformat, or clean adjacent code unless required.
- Don't refactor what isn't broken — PR = task, not cleanup excuse.
- Match existing style.
- Remove only unused code introduced by your own changes.
- If unrelated dead code is found, mention it; don't delete silently.

Self-check: every changed line must trace directly to the task.

### 4. Goal, Criteria, Verification

Before work, define:

- Goal: what changes.
- Acceptance criteria: how "done" is judged.
- Verification: exact test, command, trace, or observation.

Examples:

- "Add validation" → write tests for invalid input, then make pass.
- "Fix the bug" → write a test reproducing it, then fix.
- "Refactor X" → tests green before and after.

For multi-step work:

```
1. [Step] → check: [exact verification]
2. [Step] → check: [exact verification]
```

Strong criteria → autonomous work. Weak ("make it work") → ask, don't assume.
