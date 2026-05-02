# Codex Paperclip Team Parity Mapping

## Context

Claude Paperclip teams are working and must remain intact. Codex support is a
parallel target: build duplicate Paperclip agent bundles that preserve the same
role coverage and operational discipline using Codex models, MCP servers,
plugins, skills, and subagents.

This mapping is the first inventory for that duplicate team. It does not modify
Claude roles, shared fragments, Paperclip build scripts, or live agent bundles.

## Goals

- Map Claude/Paperclip runtime concepts to Codex equivalents.
- Identify gaps that block Codex parity.
- Define the first Codex bundle shape without changing Claude output.
- Keep future implementation scoped: add Codex analogs, do not remove Claude
  instructions.

## Non-Goals

- Rewriting existing Claude role files.
- Renaming live Claude agents.
- Changing Paperclip adapter/model config.
- Deploying Codex bundles to live Paperclip agents.
- Removing `superpowers:*`, `claude-api`, `OpusArchitectReviewer`, or other
  Claude runtime concepts from the Claude target.

## Current Codex Runtime Inventory

Confirmed local Codex configuration:

- Model: `gpt-5.5`
- Reasoning: `high`
- MCP servers configured:
  - `codebase-memory`
  - `serena`
  - `context7`
  - `playwright`
- Global agents available: 138 `.toml` agents under `~/.codex/agents`.
- Important installed Codex agents:
  - `architect-reviewer`
  - `backend-developer`
  - `blockchain-developer`
  - `code-reviewer`
  - `debugger`
  - `devops-engineer`
  - `docker-expert`
  - `frontend-design`
  - `kotlin-specialist`
  - `mcp-developer`
  - `multi-agent-coordinator`
  - `platform-engineer`
  - `python-pro`
  - `qa-expert`
  - `research-analyst`
  - `reviewer`
  - `search-specialist`
  - `security-auditor`
  - `swift-pro`
  - `test-automator`
  - `technical-writer`
  - `workflow-orchestrator`
- Important installed Codex skills:
  - `create-plan`
  - `frontend-design`
  - `frontend-skill`
  - `gh-address-comments`
  - `gh-fix-ci`
  - `mcp-builder`
  - `openai-docs` (system skill)
  - `swift-pro`
  - `webapp-testing`

## Runtime Concept Mapping

| Claude concept | Codex equivalent | Status | Notes |
|---|---|---|---|
| `CLAUDE.md` auto-loaded project rules | `AGENTS.md` | Confirmed | Codex global and project instructions support this path. |
| Claude role instruction bundle path | Paperclip `instructions/AGENTS.md` with Codex content | Confirmed | Paperclip already deploys bundle files named `AGENTS.md`; content needs Codex target. |
| `context7` MCP | `context7` MCP | Confirmed | Configured in Codex `config.toml`. |
| `serena` MCP | `serena` MCP | Confirmed | Configured in Codex `config.toml`. |
| `filesystem` MCP | Codex native filesystem/shell access | Instruction equivalent | Do not require filesystem MCP unless Paperclip runtime requires MCP-only file access. |
| `github` MCP | `gh` CLI plus GitHub-related Codex skills | Partial | `gh-address-comments` and `gh-fix-ci` exist; generic GitHub MCP is not configured. |
| `sequential-thinking` MCP | Codex reasoning + explicit plan/checklist discipline | Instruction equivalent | No separate MCP required unless workflow depends on tool traces. |
| `playwright`/browser testing | `playwright` MCP + `webapp-testing` skill | Confirmed | Configured locally. |
| `supabase` MCP | Gap | Gap | Required for Medic Backend/QA if direct DB work remains in agent instructions. |
| `tavily` MCP | Gap | Gap | Required for Medic Research/CEO/UX if live web search must be tool-backed. |
| `figma` MCP | Gap | Gap | Required for Medic UX/iOS if Figma remains source of truth. |
| `magic` / 21st.dev UI tooling | Gap | Gap | Required for Medic UX if UI generation workflow remains expected. |
| Claude `superpowers:test-driven-development` | Explicit TDD discipline or Codex skill to create | Partial | `create-plan` exists, but TDD/systematic-debugging skills are not installed as direct equivalents. |
| Claude `superpowers:systematic-debugging` | Explicit debugging discipline or Codex skill to create | Partial | Codex `debugger` agent exists; skill-level trigger is missing. |
| Claude `superpowers:verification-before-completion` | Global Karpathy verification rule + explicit role text | Partial | Behavior can be preserved by instructions; no direct skill invocation. |
| Claude `superpowers:receiving-code-review` | `reviewer` / `code-reviewer` agent + explicit instruction | Partial | Needs Codex role text. |
| Claude `superpowers:writing-plans` | `create-plan` skill | Confirmed | Installed. |
| Claude `superpowers:brainstorming` | `product-manager`, `business-analyst`, `research-analyst` agents or explicit ideation rule | Partial | No direct skill found. |
| Claude `superpowers:dispatching-parallel-agents` | Codex subagent delegation rules + `multi-agent-coordinator` | Partial | Codex has agents, but parent-agent spawning depends on runtime support. |
| `pr-review-toolkit:*` skills | Codex reviewer agents + `gh-*` skills | Partial | No direct toolkit skill installed. Must map per use case. |
| `research-deep` / `research-add-fields` / `research-report` | `content-research-writer`, `docs-researcher`, `research-analyst`, `search-specialist` | Partial | Equivalent workflow needs Codex-specific instructions. |
| `claude-api` skill | Gap or external docs lookup | Gap | Do not replace in Claude target. For Codex target, use Context7/web docs or create/install an Anthropic SDK skill if needed. |
| `OpusArchitectReviewer` high-tier reviewer | Codex reviewer role on `gpt-5.5` high/xhigh | Partial | Keep Claude role name in Claude target. Codex target may use `ArchitectReviewer` or a distinct Codex agent record. |

## Shared Role Mapping

| Paperclip role | Codex primary agents | Codex supporting agents/skills | Gaps |
|---|---|---|---|
| CTO | `multi-agent-coordinator`, `workflow-orchestrator`, `architect-reviewer` | `create-plan`, `project-manager`, `business-analyst` | Direct equivalents for `superpowers:brainstorming` and `dispatching-parallel-agents` need instruction text. |
| PythonEngineer | `python-pro`, `backend-developer` | `test-automator`, `debugger`, `performance-engineer`, `security-auditor` | No direct `superpowers:TDD/debugging/verification` skills. |
| InfraEngineer | `devops-engineer`, `docker-expert`, `deployment-engineer` | `sre-engineer`, `platform-engineer`, `security-auditor` | No direct `superpowers:*` skills. |
| CodeReviewer | `code-reviewer`, `reviewer` | `architect-reviewer`, `security-auditor`, `test-automator`, `gh-address-comments`, `gh-fix-ci` | No direct `pr-review-toolkit:*`. |
| OpusArchitectReviewer / ArchitectReviewer | `architect-reviewer` | `docs-researcher`, `code-reviewer`, `context7` MCP | Codex model tier must be configured high/xhigh for this role. |
| QAEngineer | `qa-expert`, `test-automator` | `debugger`, `error-detective`, `performance-engineer`, `webapp-testing` | No direct `superpowers:*` skills. |
| SecurityAuditor | `security-auditor`, `security-engineer` | `penetration-tester`, `compliance-auditor`, `risk-manager` | Semgrep/Snyk/GitGuardian MCPs not configured. |
| ResearchAgent | `research-analyst`, `search-specialist` | `docs-researcher`, `competitive-analyst`, `trend-analyst`, `content-research-writer` | Tavily/deep-research workflow not configured as tools. |
| TechnicalWriter | `technical-writer`, `documentation-engineer` | `docs-researcher`, `qa-expert`, `create-plan` | No direct fresh-checkout verification skill; use explicit commands. |

## Gimle-Palace Extra Role Mapping

| Paperclip role | Codex primary agents | Codex supporting agents/skills | Gaps |
|---|---|---|---|
| MCPEngineer | `mcp-developer`, `api-designer`, `python-pro` | `security-auditor`, `test-automator`, `context7`, `mcp-builder` | `claude-api` remains a gap when Anthropic SDK behavior is relevant. |
| BlockchainEngineer | `blockchain-developer` | `security-auditor`, `swift-pro`, `kotlin-specialist`, `test-automator` | Crypto-specific external tooling not mapped yet. |

## Medic Extra Role Mapping

| Paperclip role | Codex primary agents | Codex supporting agents/skills | Gaps |
|---|---|---|---|
| CEO | `product-manager`, `project-manager`, `business-analyst` | `market-researcher`, `competitive-analyst`, `workflow-orchestrator` | Figma/Tavily tools not configured. |
| BackendEngineer | `backend-developer`, `typescript-pro`, `sql-pro`, `postgres-pro` | `security-engineer`, `test-automator`, `debugger` | Supabase MCP and `claude-api` equivalent gap. |
| KMPEngineer | `kotlin-specialist`, `mobile-developer` | `test-automator`, `debugger`, `refactoring-specialist` | SQLDelight/Ktor docs rely on Context7 availability. |
| iOSEngineer | `swift-pro`, `swift-expert`, `mobile-developer` | `ui-designer`, `kotlin-specialist`, `test-automator` | Direct SwiftUI Claude skills should map to installed `swift-pro` and related Codex skills. |
| UXDesigner | `frontend-design`, `ui-designer`, `ux-researcher` | `accessibility-tester`, `frontend-developer`, `webapp-testing` | Figma and Magic tooling not configured. |

## Codex Target Bundle Requirements

For a Codex Paperclip agent bundle, generated instructions must:

- Reference `AGENTS.md` instead of `CLAUDE.md` for project rules.
- Keep Claude-only skills out of Codex output unless the same skill is installed
  and verified for Codex.
- Replace missing skill invocations with explicit discipline text or a documented
  gap.
- Use Codex agent names that exist under `~/.codex/agents`.
- Use MCP names configured in Codex `config.toml`, or mark the tool as a gap.
- Preserve Paperclip handoff semantics: agent names, issue assignment, comments,
  and @mention behavior must match the actual Paperclip agent records.
- Maintain the same evidence standards: branch, spec, tests, live smoke, review,
  QA evidence, and merge handoff.

## First Implementation Slice

The first safe implementation slice should not touch Claude output. It should:

1. Add Codex-only role mapping data or templates.
2. Add a build path that can emit Codex bundles separately from Claude bundles.
3. Add a validation command that compares Claude output before/after and fails if
   Claude output changes unexpectedly.
4. Add a Codex validation scan that fails on unmapped Claude runtime concepts in
   Codex output.

Suggested output layout:

```text
paperclips/dist/claude/*.md
paperclips/dist/codex/*.md
```

If the current consumer layout cannot support target directories without
disrupting deploy scripts, use a separate Codex-only generation command first
and leave existing `dist/*.md` untouched.

## Open Gaps Before Codex Parity

- Confirm or install Codex equivalents for `superpowers:test-driven-development`,
  `superpowers:systematic-debugging`, `superpowers:verification-before-completion`,
  and `superpowers:receiving-code-review`, or write explicit replacement
  discipline blocks.
- Decide how to handle `pr-review-toolkit:*` in Codex.
- Configure or replace missing MCPs: `supabase`, `tavily`, `figma`, `magic`,
  Semgrep/Snyk/GitGuardian if required by the role.
- Decide whether the high-tier reviewer remains named `OpusArchitectReviewer` in
  Paperclip records for Codex or gets a separate Codex agent record such as
  `ArchitectReviewer`.
- Sync verified Codex global instructions and installed agents/skills to the
  iMac server before live Paperclip runs.

## Acceptance Criteria

- Claude target remains byte-for-byte unchanged for the first Codex slice unless
  explicitly approved.
- Codex target has a documented equivalent or gap for every Claude runtime
  concept used by the role.
- Codex role instructions only reference installed/configured Codex agents,
  skills, and MCP servers, or explicitly mark missing dependencies.
- Paperclip deploy scripts are not changed until Codex bundle generation is
  verified locally.
- The user receives the generated Codex bundle path before any live deployment.
