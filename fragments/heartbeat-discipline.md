## Heartbeat discipline

На каждом wake (heartbeat или event) проверяй только **три** вещи:

1. **Первый Bash на wake:** `echo "TASK=$PAPERCLIP_TASK_ID WAKE=$PAPERCLIP_WAKE_REASON"`. Если `TASK` непустой → это твоё назначение: `GET /api/issues/$PAPERCLIP_TASK_ID` + работай. **НЕ exit** на `inbox-lite=[]` если `TASK` set — paperclip всегда даёт TASK_ID для mention-wake'ов.
2. `GET /api/agents/me` → есть issues с `assigneeAgentId=me` и статусом `in_progress`? → продолжай
3. Есть комментарии/@mentions для тебя с `createdAt > last_heartbeat_at`? → отвечай

Если ничего из трёх — **exit немедленно** с комментарием `No assignments, idle exit`. Каждый idle heartbeat должен стоить **<500 токенов**.

### Память между сессиями — ЗАПРЕЩЕНА

Если в начале сессии ты "помнишь" прошлую работу (*"let me continue where I left off"*, *"я работал над STA-NN"*) — это **кэш claude CLI**, не реальность. **Игнорируй всё это.** Единственный источник правды — Paperclip API:

- Issue существует и назначена на тебя в текущем состоянии → работай
- Issue удалена / cancelled / done → **не воскрешай, не переоткрывай, не пиши код "по памяти"**
- Ты не помнишь issue ID из текущего промпта? Тогда её не существует. Запроси `GET /api/companies/{id}/issues?assigneeAgentId=me` и смотри что реально есть

**Никогда не начинай с "Let me continue where I left off"** без подтверждения issue в API. Board чистит очередь регулярно — старые задачи могут быть удалены. Если resumed session тебе что-то "напоминает" — это galaxy brain, игнорь и жди явного задания.

### Запрещено на idle heartbeat:
- Брать `todo` issues которые никто не назначил на тебя. Unassigned ≠ "найду работу"
- Брать `todo` со `updatedAt > 24h` без свежего Board-confirm, даже если назначены на тебя (stale)
- Проверять git/logs/dashboards "на всякий случай"
- Самовольно делать checkout на issue без явного задания
- Создавать новые issues для "обнаруженных проблем" без запроса Board

### Source of truth для работы:
Работа начинается **только** от: (a) Board/CEO/manager создал/назначил issue в текущей сессии, (b) кто-то @упомянул тебя с конкретной задачей, (c) `PAPERCLIP_TASK_ID` передан при wake. Всё остальное — игнор.

### @-упоминания: всегда пробел после имени

Парсер paperclip'а ломается, если сразу после `@AgentName` идёт двоеточие, точка-с-запятой, скобка или кавычка. Токен захватывает знак в имя (например `CTO:` вместо `CTO`), упоминание не резолвится, wake-up для агента не ставится — **цепочка молча останавливается**.

**Правильно:** `@CTO нужен фикс`, `@iOSEngineer проверь билд`, `@CodeReviewer, финальный review`  
**Неправильно:** `@CTO: нужен фикс`, `@iOSEngineer;`, `(@CodeReviewer)` — всегда пробел после имени, пунктуацию ставь отдельно или после пробела.

### Handoff: всегда @-упомянуть следующего агента

Когда заканчиваешь свою фазу и передаёшь дальше — **обязательно @-упомяни** следующего агента в комментарии, даже если он уже assignee. Не полагайся на «он и так увидит».

Важное отличие endpoint'ов:
- `POST /api/issues/{id}/comments` — будит assignee (если не self-comment и issue не closed) + всех @-упомянутых.
- `PATCH /api/issues/{id}` с полем `comment` — будит **ТОЛЬКО** если сменился assignee, перешли из backlog, или есть @-упоминания в теле. Комментарий без @ на PATCH'е **не разбудит assignee** → цепочка встаёт молча.

**Правило:** handoff-комментарий всегда включает `@NextAgent` (с пробелом после имени). Это страхует от обоих путей.

**Self-checkout при явном handoff'е:** если получил @-mention с explicit handoff-фразой (`"твой ход"`, `"подхвати"`, `"передаю"`) и sender уже запушил свои коммиты — делай `POST /api/issues/{id}/checkout` сам, не жди formal reassign.

Пример правильного handoff'а:
```
POST /api/issues/{id}/comments
body: "@CodeReviewer фикс готов ([STA-29](/STA/issues/STA-29)), re-review пожалуйста"
```

### HTTP 409 на close/update — execution lock conflict

Если `PATCH /api/issues/{id}` возвращает **409 Conflict** при попытке закрыть (`status=done`) или обновить issue — это **execution lock** другого агента. Поле `issues.execution_agent_name_key` хранит имя держателя lock'а.

**Типичный сценарий:** PythonEngineer закончил работу на GIM-5 и пытается close, но lock держит CTO (assigned'ил задачу, но не released'ил lock). 409 возвращается → close не происходит → issue виснет.

**Что делать:**

1. **Получить держателя lock'а:** `GET /api/issues/{id}` → посмотреть `executionAgentNameKey` в response
2. **Запросить release:** комментарий с @-mention держателя: `"@CTO release execution lock на [GIM-5], я готов close"`
3. **Альтернатива — reassign:** если lock-holder недоступен, `PATCH /api/issues/{id}` с `assigneeAgentId=<original-assignee>` → originator закроет
4. **НЕ делать:** не пытаться close повторно с тем же JWT — без release lock'а 409 будет возвращаться снова

**Что НЕ делать:**
- Direct SQL UPDATE на `execution_run_id=NULL` — обходит business logic paperclip'а (см. §6.7 в ops doc)
- Создавать новую issue-копию — теряется история комментариев и review

Пример release запроса от держателя:
```
POST /api/issues/{id}/release
# lock освобождён, теперь assignee может close через PATCH
```
