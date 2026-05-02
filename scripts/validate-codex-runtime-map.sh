#!/usr/bin/env bash
# Validate that confirmed Codex runtime references exist in CODEX_HOME.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MAP_FILE="${1:-$REPO_ROOT/targets/codex/runtime-map.json}"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 - "$MAP_FILE" "$CODEX_HOME" <<'PY'
import json
import re
import sys
from pathlib import Path

map_file = Path(sys.argv[1])
codex_home = Path(sys.argv[2]).expanduser()

data = json.loads(map_file.read_text())
valid_statuses = {"confirmed", "partial", "gap", "instruction_equivalent"}

errors = []

for item in data.get("concepts", []):
    status = item.get("status")
    if status not in valid_statuses:
        errors.append(f"invalid concept status for {item.get('claude')!r}: {status!r}")

agents_dir = codex_home / "agents"
skills_dir = codex_home / "skills"
config_file = codex_home / "config.toml"

available_agents = {p.stem for p in agents_dir.glob("*.toml")} if agents_dir.exists() else set()
available_skills = {p.parent.name for p in skills_dir.rglob("SKILL.md")} if skills_dir.exists() else set()

available_mcp = set()
if config_file.exists():
    pattern = re.compile(r"^\[mcp_servers\.([^\]]+)\]$")
    for line in config_file.read_text().splitlines():
        match = pattern.match(line.strip())
        if match:
            available_mcp.add(match.group(1))

required_agents = set()
required_skills = set()
required_mcp = set()

for item in data.get("concepts", []):
    requires = item.get("requires", {})
    required_agents.update(requires.get("agents", []))
    required_skills.update(requires.get("skills", []))
    required_mcp.update(requires.get("mcp", []))

for role in data.get("roles", []):
    required_agents.update(role.get("codex_primary_agents", []))
    support = role.get("codex_support", {})
    required_agents.update(support.get("agents", []))
    required_skills.update(support.get("skills", []))
    required_mcp.update(support.get("mcp", []))

missing_agents = sorted(required_agents - available_agents)
missing_skills = sorted(required_skills - available_skills)
missing_mcp = sorted(required_mcp - available_mcp)

if missing_agents:
    errors.append("missing Codex agents: " + ", ".join(missing_agents))
if missing_skills:
    errors.append("missing Codex skills: " + ", ".join(missing_skills))
if missing_mcp:
    errors.append("missing Codex MCP servers: " + ", ".join(missing_mcp))

if errors:
    print("Codex runtime map validation failed:")
    for error in errors:
        print(f"- {error}")
    sys.exit(1)

print(f"Codex runtime map OK: {map_file}")
print(f"CODEX_HOME: {codex_home}")
print(f"Agents checked: {len(required_agents)}")
print(f"Skills checked: {len(required_skills)}")
print(f"MCP servers checked: {len(required_mcp)}")
PY
