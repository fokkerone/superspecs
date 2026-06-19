#!/bin/bash
# SuperSpecs Setup — symlinks skills into supported AI agent directories

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/.skills"

# PROJECT_DIR: where superspec/ dirs are created.
# When called via `superspecs install`, the CLI passes the user's CWD via env var.
# Falls back to SCRIPT_DIR for direct `bash setup.sh` usage inside the repo.
PROJECT_DIR="${SUPERSPECS_PROJECT_DIR:-$SCRIPT_DIR}"

# SUPERSPECS_SKIP_SYMLINKS=1 skips agent symlinking (used by `superspecs init`)
SKIP_SYMLINKS="${SUPERSPECS_SKIP_SYMLINKS:-0}"

# ─── Banner ───────────────────────────────────────────────────────────────────

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  SuperSpecs Setup                                        ║"
echo "║  Plan · Execute · Verify · Ship                         ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# ─── Agent definitions ────────────────────────────────────────────────────────
# Indices 0-3: project-level   |   Indices 4-11: global

LABELS=(
  "Claude Code (project)"
  "Cursor (project)"
  "Windsurf (project)"
  "OpenCode / Aider / generic (project)"
  "Claude Code (global)"
  "Codex (global)"
  "Gemini CLI (global)"
  "GitHub Copilot CLI (global)"
  "OpenCode (global)"
  "Cursor (global)"
  "Kiro (global)"
  "Pi (global)"
)

DIRS=(
  "$PROJECT_DIR/.claude/skills"
  "$PROJECT_DIR/.cursor/skills"
  "$PROJECT_DIR/.windsurf/skills"
  "$PROJECT_DIR/.agents/skills"
  "$HOME/.claude/skills"
  "$HOME/.codex/skills"
  "$HOME/.gemini/skills"
  "$HOME/.copilot/skills"
  "$HOME/.agents/skills"
  "$HOME/.cursor/skills"
  "$HOME/.kiro/skills"
  "$HOME/.pi/agent/skills"
)

# Selection state (1=selected, 0=deselected) — all selected by default
SEL=( 1 1 1 1 1 1 1 1 1 1 1 1 )

# Menu cursor: 0=All, 1-4=project items, 5-12=global items
MENU_CURSOR=0
MENU_LINES=15  # All(1) + sep(1) + project(4) + sep(1) + global(8) = 15

# ─── Symlink helper ───────────────────────────────────────────────────────────

symlink_skills() {
  local target_dir="$1"
  local label="$2"
  mkdir -p "$target_dir"
  for skill_dir in "$SKILLS_DIR"/*/; do
    local skill_name
    skill_name=$(basename "$skill_dir")
    local skill_file="$skill_dir/SKILL.md"
    [ -f "$skill_file" ] && ln -sf "$skill_file" "$target_dir/$skill_name.md" 2>/dev/null || true
  done
  echo "  ✓ $label"
}

# ─── Multiselect UI ───────────────────────────────────────────────────────────

_all_sel() {
  for v in "${SEL[@]}"; do [ "$v" -eq 0 ] && return 1; done
  return 0
}

_draw_menu() {
  local i check

  # Row: All
  _all_sel 2>/dev/null && check="✓" || check=" "
  if [ "$MENU_CURSOR" -eq 0 ]; then
    printf "\e[1;36m ▶ [%s] All agents\e[0m\n" "$check"
  else
    printf "   [%s] All agents\n" "$check"
  fi

  # Section: Project
  printf "   \e[2m── Project ─────────────────────────────────\e[0m\n"
  for ((i=0; i<4; i++)); do
    [ "${SEL[$i]}" -eq 1 ] && check="✓" || check=" "
    if [ "$MENU_CURSOR" -eq $((i+1)) ]; then
      printf "\e[1;36m ▶ [%s] %s\e[0m\n" "$check" "${LABELS[$i]}"
    else
      printf "   [%s] %s\n" "$check" "${LABELS[$i]}"
    fi
  done

  # Section: Global
  printf "   \e[2m── Global ──────────────────────────────────\e[0m\n"
  for ((i=4; i<12; i++)); do
    [ "${SEL[$i]}" -eq 1 ] && check="✓" || check=" "
    if [ "$MENU_CURSOR" -eq $((i+1)) ]; then
      printf "\e[1;36m ▶ [%s] %s\e[0m\n" "$check" "${LABELS[$i]}"
    else
      printf "   [%s] %s\n" "$check" "${LABELS[$i]}"
    fi
  done

  tput cuu "$MENU_LINES" 2>/dev/null || true
}

run_multiselect() {
  # Skip when non-interactive (piped, CI, etc.)
  [ -t 0 ] && [ -t 1 ] || return 0

  local old_stty
  old_stty=$(stty -g 2>/dev/null) || return 0

  tput civis 2>/dev/null || true
  stty raw -echo 2>/dev/null || { stty "$old_stty" 2>/dev/null || true; return 0; }

  printf "  Select agents to install into:\n"
  printf "  \e[2m↑↓ navigate · space toggle · a select all · enter confirm\e[0m\n\n"

  _draw_menu

  while true; do
    local key seq
    IFS= read -r -s -n1 key || break

    if [[ "$key" == $'\x1b' ]]; then
      IFS= read -r -s -n2 -t 0.1 seq || seq=""
      case "$seq" in
        '[A') [ "$MENU_CURSOR" -gt 0  ] && MENU_CURSOR=$((MENU_CURSOR-1)) ;;
        '[B') [ "$MENU_CURSOR" -lt 12 ] && MENU_CURSOR=$((MENU_CURSOR+1)) ;;
      esac

    elif [[ "$key" == ' ' ]]; then
      if [ "$MENU_CURSOR" -eq 0 ]; then
        if _all_sel 2>/dev/null; then
          SEL=( 0 0 0 0 0 0 0 0 0 0 0 0 )
        else
          SEL=( 1 1 1 1 1 1 1 1 1 1 1 1 )
        fi
      else
        local idx=$((MENU_CURSOR-1))
        [ "${SEL[$idx]}" -eq 1 ] && SEL[$idx]=0 || SEL[$idx]=1
      fi

    elif [[ "$key" == 'a' || "$key" == 'A' ]]; then
      SEL=( 1 1 1 1 1 1 1 1 1 1 1 1 )

    elif [[ "$key" == $'\r' || "$key" == $'\n' || -z "$key" ]]; then
      break
    fi

    _draw_menu
  done

  tput cud "$MENU_LINES" 2>/dev/null || true
  printf "\n"

  stty "$old_stty" 2>/dev/null || true
  tput cnorm 2>/dev/null || true
}

# ─── Project-level + Global symlinks ────────────────────────────────────────

if [ "$SKIP_SYMLINKS" != "1" ]; then
  run_multiselect

  proj_done=0
  glob_done=0

  for ((i=0; i<4; i++)); do
    if [ "${SEL[$i]}" -eq 1 ]; then
      [ "$proj_done" -eq 0 ] && echo "→ Project-level agent skills..." && proj_done=1
      symlink_skills "${DIRS[$i]}" "${LABELS[$i]}"
    fi
  done
  [ "$proj_done" -eq 1 ] && echo ""

  for ((i=4; i<12; i++)); do
    if [ "${SEL[$i]}" -eq 1 ]; then
      [ "$glob_done" -eq 0 ] && echo "→ Global agent skills..." && glob_done=1
      symlink_skills "${DIRS[$i]}" "${LABELS[$i]}"
    fi
  done
  [ "$glob_done" -eq 1 ] && echo ""
fi

# ─── Initialize SuperSpecs directories ───────────────────────────────────────

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
echo "  First feature workflow:"
echo "    /techstack   ← define stack + get library recommendations"
echo "    /discuss     ← capture decisions"
echo "    /spec        ← write the spec"
echo "    /grill       ← stress-test spec against wiki + techstack"
echo "    /pick-spec   ← validate + prepare"
echo "    /branch      ← create worktree"
echo "    /subagent    ← execute with TDD"
echo "    /tdd         ← RED-GREEN-REFACTOR"
echo "    /code-review ← review between tasks"
echo "    /check-tests ← verify full suite"
echo "    /wiki        ← distill to knowledge base"
echo "    /ship        ← PR + archive"
echo ""
