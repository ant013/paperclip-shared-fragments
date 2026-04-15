## Pre-work discovery (перед началом любой задачи)

Перед тем как писать код или декомпозировать — проверь что фича/фикс не существует:

1. `git fetch --all && git log --all --grep="<keyword>" --oneline`
2. `gh pr list --state all --search "<keyword>"` — открытые и смёрженные
3. `serena find_symbol` / `get_symbols_overview` — существующие реализации
4. `docs/` — спека возможно написана
5. Paperclip issues — кто-то уже работает?

**Если существует** — закрой issue как `duplicate` со ссылкой, или переформулируй ("интегрировать X из feature/Y"). Не начинай новую.
