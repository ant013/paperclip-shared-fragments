# Paperclip Shared Fragments

Reusable building blocks для [Paperclip AI](https://github.com/paperclipai/paperclip)
agent teams, переиспользуемые между проектами.

## Содержимое

| Директория | Что | Когда используется |
|---|---|---|
| `fragments/` | Атомарные `@include`-блоки правил (heartbeat, git-workflow, @-mention format, handoff rule, review-report-format, qa-skeptic, ...) | Включаются в role AGENTS.md при сборке — каждый wake агента |
| `templates/` | Скелеты ролей (CEO, CTO, 5+ инженеров, 6 reviewer personalities, support) | Копируются при bootstrap новой paperclip-команды |
| `research/` | Domain best-practices per role (security / privacy / performance / blockchain / MCP / …) | **НЕ** грузится в agent context — читается по запросу через filesystem MCP |
| `build.sh` | awk-препроцессор: резолвит `<!-- @include fragments/X.md -->` | `./build.sh` в проекте-потребителе |
| `bootstrap-new-project.sh` | Scaffold нового paperclip-enabled проекта с submodule | При старте нового проекта |

## Почему это отдельный репо

Paperclip-механика (wake-up rules, @-mention quirks, worktree discipline, handoff
правила) универсальна, не зависит от проекта. Дублирование правил по проектам —
гарантия что фиксы будут забыты. Реальные инциденты уже случались. Этот репо —
единый source of truth, подключается как git submodule в каждый проект.

## Current consumers

- [Medic](https://github.com/ant013/Medic) — health/medication kit (iOS + Android + Supabase)
- [Gimlé Palace](https://github.com/ant013/Gimle-Palace) — memory palace for AI coding agents

## Conventions

Строгий token-budget discipline:

- Fragments ≤500 tokens (most), ≤1200 (heartbeat-discipline)
- Role body ≤2000 tokens
- Полный AGENTS.md ≤8000 tokens
- Research notes **не грузятся** в agent context — на отдельной полке

Селективный `@include` — роли подключают только то что реально нужно, не всё подряд.
См. `CONVENTIONS.md`.
