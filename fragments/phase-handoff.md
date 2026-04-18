## Phase handoff discipline (железное правило)

Между фазами plan'а (§8 плана) всегда **explicit reassign** на конкретного агента следующей фазы. Никогда не оставляй issue в состоянии "никому не назначена, разберутся".

Grounded in GIM-48 incident (2026-04-18): CodeReviewer после Phase 3.1 APPROVE сделал `status=todo` вместо `assignee=QAEngineer`; CTO увидел `todo` и закрыл через `done` без Phase 4.1 evidence; merged код крэшнулся на iMac. Гейт QA был пропущен **потому что никто не передал ownership**.

### Обязательные правила handoff'а между фазами

| Фаза закончена | Следующая фаза | Handoff обязателен |
|----------------|-----------------|---------------------|
| 1.1 Формализация (CTO) | 1.2 Plan-first review | `assignee=CodeReviewer` + @CodeReviewer |
| 1.2 Plan-first (CR) | 2.x Implementation | `assignee=<implementer>` + @mention |
| 2 Implementation | 3.1 Mechanical review | `assignee=CodeReviewer` + @mention + **git push сделан** |
| 3.1 CR APPROVE | 3.2 Opus adversarial | `assignee=OpusArchitectReviewer` + @mention |
| 3.2 Opus APPROVE | 4.1 QA live smoke | `assignee=QAEngineer` + @mention |
| 4.1 QA PASS | 4.2 Merge | `assignee=<merger>` (обычно CTO) + @mention |

### НИКОГДА не делай

- `status=todo` между фазами. `todo` = "никем не назначена, доступна для claim". Между фазами должен быть **explicit assignee** следующей фазы.
- `release` execution lock без одновременного `PATCH assignee=<next-phase-agent>`. Просто release → issue зависает без владельца.
- "Assignee текущий (я), status=in_progress" после завершения моей фазы. Assignee должен смениться до того, как я пишу handoff-comment.
- Закрытие `status=done` без проверки что Phase 4.1 evidence-comment опубликован **от правильного агента** (QAEngineer, не implementer и не CR).

### Формат handoff-комментария

```
## Phase N.M complete — [краткий результат]

[Evidence / артефакты / commits / links]

@<NextAgent> твой ход — Phase <N.M+1>: [что нужно сделать]
```

`@` обязательно **с пробелом** после имени (см. `heartbeat-discipline.md` §«@-упоминания»). Именно @-mention гарантирует wake следующего агента, даже если assignee уже выставлен.

### Pre-handoff checklist (implementer → reviewer)

Перед тем как писать "Phase 2 complete — @CodeReviewer":

- [ ] `git push origin <feature-branch>` выполнен — коммиты доступны на origin
- [ ] Локально зелёный `uv run ruff check && uv run mypy src/ && uv run pytest` (или язык-эквивалент)
- [ ] CI на feature branch запущен — или будет запущен автоматически пушем
- [ ] PR открыт, либо PR будет открыт на Phase 4.2 (зависит от plan §8)
- [ ] В handoff-comment **конкретные commit SHAs** и ссылка на ветку, не просто "готово"

Пропуск любого пункта = CR получает "готово" на коде которого нет на origin = тупик.

### Pre-close checklist (CTO → status=done)

Перед `PATCH status=done`:

- [ ] Phase 4.2 merge уже выполнен (squash-commit на develop / main)
- [ ] Phase 4.1 evidence-comment **существует** и написан **QAEngineer'ом** (проверь `authorAgentId` в activity log или в UI)
- [ ] Evidence содержит: commit SHA, runtime-смок (healthcheck / tool call), plan-specific invariant check (например `MATCH ... RETURN DISTINCT n.group_id`)
- [ ] CI green на merge-коммите (или admin-override задокументирован в merge message с причиной)

Если хотя бы один пункт не выполнен — **не закрывай**. Эскалируй к Board (`@Board evidence missing на Phase 4.1 перед close`).

### Формат Phase 4.1 QA-evidence комментария

Эталон (из GIM-52 Phase 4.1 PASS):

```
## Phase 4.1 — QA PASS ✅

### Evidence

1. Commit SHA tested: `<git rev-parse HEAD на feature branch>`
2. `docker compose --profile <x> ps` — [контейнеры healthy]
3. `/healthz` — `{"status":"ok","neo4j":"reachable"}` (или эквивалент для другого сервиса)
4. MCP tool: `palace.memory.<tool>()` → [вывод] (реальный MCP call, не только healthz)
5. Ingest CLI / runtime-смок — [вывод команды]
6. Direct invariant check (plan-specific) — [например `MATCH (n) RETURN DISTINCT n.group_id` с ожидаемой 1 строкой]
7. После QA — checkout обратно на `develop` на iMac (cм. `feedback_imac_checkout_discipline.md`)

@<merger> Phase 4.1 green, передаю на Phase 4.2 — squash-merge к develop.
```

Замена `/healthz`-only evidence на реальный tool-call — критично. `/healthz` может быть зелёным при fundamentally-broken функциональности (GIM-48).

### Lock stale edge case

Если `POST /release` возвращает 200 но `executionAgentNameKey` не сбрасывается (GIM-52 Phase 4.1 reported by OpusArchitectReviewer) — **не игнорируй**, эскалируй Board с details (issue id, run id, последовательность попыток). Это либо bug в paperclip, либо endpoint rename — Board разберёт.

### Самопроверка перед handoff

- "Я написал @NextAgent с пробелом после имени?" — да/нет
- "Assignee сейчас — следующий агент или всё ещё я?" — должен быть next
- "Мой push виден в `git ls-remote origin <branch>`?" — обязан быть yes для implementer handoff
- "Evidence в моём комментарии — от меня или я пересказал чужую работу?" — для QA только собственный evidence засчитывается
