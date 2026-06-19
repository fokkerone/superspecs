#!/bin/bash
# SuperSpecs Setup — symlinks skills into all supported AI agent directories

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/.skills"

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  SuperSpecs Setup                                        ║"
echo "║  Plan · Execute · Verify · Ship                         ║"
echo "╚══════════════════════════════════════════════════════════╝"
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
  echo "  ✓ $label"
}

# ─── Project-level ────────────────────────────────────────────────────────────

echo "→ Project-level agent skills..."
symlink_skills "$SCRIPT_DIR/.claude/skills"     "Claude Code (project)"
symlink_skills "$SCRIPT_DIR/.cursor/skills"     "Cursor (project)"
symlink_skills "$SCRIPT_DIR/.windsurf/skills"   "Windsurf (project)"
symlink_skills "$SCRIPT_DIR/.agents/skills"     "OpenCode / Aider / generic (project)"

# ─── Global ──────────────────────────────────────────────────────────────────

echo ""
echo "→ Global agent skills..."
symlink_skills "$HOME/.claude/skills"           "Claude Code (global)"
symlink_skills "$HOME/.codex/skills"            "Codex (global)"
symlink_skills "$HOME/.gemini/skills"           "Gemini CLI (global)"
symlink_skills "$HOME/.copilot/skills"          "GitHub Copilot CLI (global)"
symlink_skills "$HOME/.agents/skills"           "OpenCode (global)"

[ -d "$HOME/.windsurf" ] && symlink_skills "$HOME/.windsurf/skills"  "Windsurf (global)"
[ -d "$HOME/.cursor"   ] && symlink_skills "$HOME/.cursor/skills"    "Cursor (global)"
[ -d "$HOME/.kiro"     ] && symlink_skills "$HOME/.kiro/skills"      "Kiro (global)"
[ -d "$HOME/.pi"       ] && symlink_skills "$HOME/.pi/agent/skills"  "Pi (global)"

# ─── Initialize SuperSpecs directories ───────────────────────────────────────

echo ""
echo "→ Initializing project structure..."

mkdir -p "$SCRIPT_DIR/superspec/specs"
mkdir -p "$SCRIPT_DIR/superspec/phases"
mkdir -p "$SCRIPT_DIR/superspec/archive"
mkdir -p "$SCRIPT_DIR/superspec/wiki"

if [ ! -f "$SCRIPT_DIR/superspec/wiki/_index.md" ]; then
cat > "$SCRIPT_DIR/superspec/wiki/_index.md" << 'WIKIEOF'
# Project Wiki

Maintained by SuperSpecs. Distilled knowledge from shipped features.

## Domains

(Added automatically via /wiki after each shipped feature)

## Recent Updates

(Updated by /wiki)
WIKIEOF
fi

if [ ! -f "$SCRIPT_DIR/superspec/wiki/_manifest.json" ]; then
  echo '{"sources":[]}' > "$SCRIPT_DIR/superspec/wiki/_manifest.json"
fi

# ─── Done ─────────────────────────────────────────────────────────────────────

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  SuperSpecs ready!                                       ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "  Open your agent and say: \"Tell me about your superspecs\""
echo ""
echo "  Start your first feature:"
echo "    /discuss   ← capture decisions"
echo "    /spec      ← write the spec"
echo "    /pick-spec ← validate + prepare"
echo "    /branch    ← create worktree"
echo "    /subagent  ← execute with TDD"
echo "    /check-tests"
echo "    /wiki"
echo "    /ship"
echo ""
