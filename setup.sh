#!/bin/bash
# SuperSpecs Setup — symlinks skills into all supported AI agent directories

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/.skills"

# PROJECT_DIR: where superspec/ dirs are created.
# When called via `superspecs install`, the CLI passes the user's CWD via env var.
# Falls back to SCRIPT_DIR for direct `bash setup.sh` usage inside the repo.
PROJECT_DIR="${SUPERSPECS_PROJECT_DIR:-$SCRIPT_DIR}"

# SUPERSPECS_SKIP_SYMLINKS=1 skips global/project skill symlinking (used by `superspecs init`)
SKIP_SYMLINKS="${SUPERSPECS_SKIP_SYMLINKS:-0}"

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

# ─── Project-level + Global symlinks ────────────────────────────────────────

if [ "$SKIP_SYMLINKS" != "1" ]; then
  echo "→ Project-level agent skills..."
  symlink_skills "$PROJECT_DIR/.claude/skills"    "Claude Code (project)"
  symlink_skills "$PROJECT_DIR/.cursor/skills"    "Cursor (project)"
  symlink_skills "$PROJECT_DIR/.windsurf/skills"  "Windsurf (project)"
  symlink_skills "$PROJECT_DIR/.agents/skills"    "OpenCode / Aider / generic (project)"

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
fi

# ─── Initialize SuperSpecs directories ───────────────────────────────────────

echo ""
echo "→ Initializing project structure..."

mkdir -p "$PROJECT_DIR/superspec/specs"
mkdir -p "$PROJECT_DIR/superspec/phases"
mkdir -p "$PROJECT_DIR/superspec/archive"
mkdir -p "$PROJECT_DIR/superspec/wiki"

if [ ! -f "$PROJECT_DIR/superspec/wiki/_index.md" ]; then
cat > "$PROJECT_DIR/superspec/wiki/_index.md" << 'WIKIEOF'
# Project Wiki

Maintained by SuperSpecs. Distilled knowledge from shipped features.

## Domains

(Added automatically via /wiki after each shipped feature)

## Recent Updates

(Updated by /wiki)
WIKIEOF
fi

if [ ! -f "$PROJECT_DIR/superspec/wiki/_manifest.json" ]; then
  echo '{"sources":[]}' > "$PROJECT_DIR/superspec/wiki/_manifest.json"
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
