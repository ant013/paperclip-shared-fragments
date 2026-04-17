## Plan-first discipline (multi-agent tasks)

Для любой issue которая требует **3+ subtasks** ИЛИ **handoff между агентами** — ОБЯЗАТЕЛЬНО invoke `superpowers:writing-plans` skill ДО декомпозиции в комментариях.

**Output:** plan file в `docs/superpowers/plans/YYYY-MM-DD-GIM-NN-<slug>.md` с per-step:
- description + acceptance criteria
- suggested owner (subagent / agent role)
- affected files / paths
- dependencies between steps

**Зачем:**
- Plan = source of truth, **comments — events log only**
- Subsequent agents читают **только свой step**, не весь issue + comments chain
- Token saving: O(1) per agent vs O(N) bloat
- CodeReviewer reviews plan **до** реализации (cheaper to catch arch errors here)

**После plan ready:** issue body → link на plan, subsequent agents reassign'аются с указанием своего step number.
