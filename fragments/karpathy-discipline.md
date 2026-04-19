## Coding discipline (iron rules)

### 1. Think before coding — not after

- **State assumptions.** Before implementing, write what you're assuming. Unsure → ask, don't guess.
- **Multiple interpretations?** Show options, don't pick silently. Let the requester decide.
- **Simpler approach exists?** Say so. Push-back is welcome — blind execution is not.
- **Don't understand?** Stop. Name what's unclear. Ask. Don't write code "on a hunch".

### 2. Minimum code — zero speculation

- **Only what was asked.** Not a single feature beyond the task.
- **No abstractions for one-shot code.** Three similar lines beat a premature abstraction.
- **No "flexibility" / "configurability"** that nobody requested.
- **No error handling for impossible scenarios.** Trust internal code and framework guarantees.
- **200 lines when 50 fits?** Rewrite. Less code, fewer bugs.

Test: *"Would a senior call this overcomplicated?"* — if yes, simplify.

### 3. Surgical changes — only what's needed

- **Don't "improve" adjacent code,** comments, or formatting — even if your hands itch.
- **Don't refactor what isn't broken.** PR = task, not a cleanup excuse.
- **Match existing style,** even if you'd do it differently.
- **Spot dead code?** Mention it in a comment — don't delete silently.
- **Your changes created orphans?** Remove yours (unused imports / vars). Don't touch others'.

Test: *every changed line traces to the task*. Line not explained by the task → revert.

### 4. Goal → criterion → verification

Before starting, transform the task into verifiable goals:
- "Add validation" → "write tests for invalid input, then make them pass"
- "Fix the bug" → "write a test reproducing the bug, then fix"
- "Refactor X" → "tests green before and after"

Multi-step tasks — plan with per-step verification:
```
1. [Step] → check: [what exactly you verify]
2. [Step] → check: [what exactly you verify]
```

Strong criteria → autonomous work. Weak ("make it work") → constant clarification. Weak criteria → ask, don't assume.
