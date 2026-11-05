#!/usr/bin/env bash
# ⚡ unthrottle-agents — Zero-dependency installer & read-only auditor
# Companion toolkit to "SUPER INTELLIGENCE" (https://a.co/d/0gO1eMZX)
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DEST="${HOME}/.local/bin"

echo "⚡ unthrottle-agents — Running read-only system audit..."
python3 "${REPO_DIR}/bin/agent-audit"

if [[ "${1:-}" == "--audit-only" ]]; then
  exit 0
fi

mkdir -p "${BIN_DEST}"
for tool in agent-audit agent-statusline agy-unlock-1m agent-coord; do
  chmod +x "${REPO_DIR}/bin/${tool}"
  ln -sf "${REPO_DIR}/bin/${tool}" "${BIN_DEST}/${tool}"
done
echo "✅ Linked CLI tools into ${BIN_DEST}: agent-audit, agy-unlock-1m, agent-statusline, agent-coord"

# Install Book2Skill (super-intelligence) for Claude Code & Antigravity if present
for skill_root in "${HOME}/.claude/skills" "${HOME}/.gemini/skills"; do
  if [[ -d "$(dirname "${skill_root}")" ]]; then
    mkdir -p "${skill_root}/super-intelligence"
    cp -f "${REPO_DIR}/skills/super-intelligence/SKILL.md" "${skill_root}/super-intelligence/SKILL.md"
    echo "✅ Installed Book2Skill: ${skill_root}/super-intelligence/SKILL.md"
  fi
done

echo ""
echo "📖 Companion Book: «SUPER INTELLIGENCE» — https://a.co/d/0gO1eMZX"
echo "Run 'agent-audit' or 'agent-coord status' anytime."
