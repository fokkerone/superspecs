#!/bin/bash
# SuperSpecs Setup
# Symlinks skills into all supported AI agent directories

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/.skills"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║          SuperSpecs Setup                ║"
echo "║  Spec-driven · TDD · Living Wiki         ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ─── Helper ───────────────────────────────────────────────────────────────────

symlink_skills() {
  local target_dir="$1"
  local label="$2"
  mkdir -p "$target_dir"
  for skill_dir in "$SKILLS_DIR"/*/; do
    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"
    if [ -f "$skill_file" ]; then
      ln -sf "$skill_file" "$target_dir/$skill_name.md" 2>/dev/null || true
    fi
  done
  echo "  ✓ $label → $target_dir"
}

# ─── Project-level symlinks ───────────────────────────────────────────────────

echo "→ Setting up project-level skills..."

symlink_skills "$SCRIPT_DIR/.claude/skills" "Claude Code"
symlink_skills "$SCRIPT_DIR/.cursor/skills" "Cursor"
symlink_skills "$SCRIPT_DIR/.windsurf/skills" "Windsurf"
symlink_skills "$SCRIPT_DIR/.agents/skills" "OpenCode / Aider / generic"

# ─── Global symlinks ──────────────────────────────────────────────────────────

echo ""
echo "→ Setting up global skills..."

symlink_skills "$HOME/.claude/skills" "Claude Code (global)"
symlink_skills "$HOME/.codex/skills" "Codex"
symlink_skills "$HOME/.gemini/skills" "Gemini CLI"
symlink_skills "$HOME/.copilot/skills" "GitHub Copilot CLI"
symlink_skills "$HOME/.agents/skills" "OpenCode (global)"

# Optional agents (only if their config dirs exist)
[ -d "$HOME/.windsurf" ] && symlink_skills "$HOME/.windsurf/skills" "Windsurf (global)"
[ -d "$HOME/.cursor" ] && symlink_skills "$HOME/.cursor/skills" "Cursor (global)"
[ -d "$HOME/.kiro" ] && symlink_skills "$HOME/.kiro/skills" "Kiro"
[ -d "$HOME/.pi" ] && symlink_skills "$HOME/.pi/agent/skills" "Pi"

# ─── Initialize wiki structure ────────────────────────────────────────────────

echo ""
echo "→ Initializing SuperSpecs directories..."

mkdir -p "$SCRIPT_DIR/superspec/specs"
mkdir -p "$SCRIPT_DIR/superspec/changes/archive"
mkdir -p "$SCRIPT_DIR/superspec/wiki"

if [ ! -f "$SCRIPT_DIR/superspec/wiki/_index.md" ]; then
  cat > "$SCRIPT_DIR/superspec/wiki/_index.md" << 'EOF'
# Project Wiki

This wiki is maintained by SuperSpecs. It contains distilled knowledge from implemented features.

## Domains

(Added automatically as features are synced)

## Recent Updates

(Updated by /spec:wiki)
EOF
fi

if [ ! -f "$SCRIPT_DIR/superspec/wiki/_manifest.json" ]; then
  echo '{"sources":[]}' > "$SCRIPT_DIR/superspec/wiki/_manifest.json"
fi

# ─── Done ─────────────────────────────────────────────────────────────────────

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║  SuperSpecs is ready!                    ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Open your agent and say: \"Tell me about your superspecs\""
echo ""
echo "Start your first feature:"
echo "  /spec:plan <feature name>"
echo ""
