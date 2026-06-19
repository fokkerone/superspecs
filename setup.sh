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

# ─── Helpers ─────────────────────────────────────────────────────────────────

# Skills: create <name>/SKILL.md directory structure (required by Claude + OpenCode discovery)
symlink_skills() {
  local target_dir="$1"
  local label="$2"
  mkdir -p "$target_dir"
  for skill_dir in "$SKILLS_DIR"/*/; do
    local skill_name
    skill_name=$(basename "$skill_dir")
    local skill_file="$skill_dir/SKILL.md"
    if [ -f "$skill_file" ]; then
      rm -f "$target_dir/$skill_name.md" 2>/dev/null || true   # remove old flat-file if present
      mkdir -p "$target_dir/$skill_name"
      ln -sf "$skill_file" "$target_dir/$skill_name/SKILL.md" 2>/dev/null || true
    fi
  done
  echo "  ✓ $label"
}

# Commands: generate a clean command .md file for each skill
# File name determines command name — NOT frontmatter.
# Claude Code: <cmd_dir>/superspecs/<slash_cmd>.md  → /superspecs:<slash_cmd>
# OpenCode:    <cmd_dir>/superspecs-<slash_cmd>.md  → /superspecs-<slash_cmd>
# NOTE: Only `description` frontmatter is written — agent-specific fields
# (slash_command, name, phase) from SKILL.md are intentionally omitted.
install_commands() {
  local cmd_dir="$1"   # base commands directory
  local prefix="$2"    # "" (use superspecs/ subdir) or "superspecs-" (flat prefix)
  local label="$3"
  local target_dir

  if [ -z "$prefix" ]; then
    target_dir="$cmd_dir/superspecs"
  else
    target_dir="$cmd_dir"
  fi
  mkdir -p "$target_dir"

  for skill_dir in "$SKILLS_DIR"/*/; do
    local skill_file="$skill_dir/SKILL.md"
    [ -f "$skill_file" ] || continue

    # Read slash_command from frontmatter (determines the command file name)
    local slash_cmd
    slash_cmd=$(grep '^slash_command:' "$skill_file" 2>/dev/null | head -1 \
                | sed 's/^slash_command: *//' | tr -d '"' | tr -d "'")
    [ -z "$slash_cmd" ] && continue
    case "$slash_cmd" in *"<"*) continue ;; esac  # skip template placeholders

    # Read description from frontmatter (the only frontmatter field agents need)
    local description
    description=$(grep '^description:' "$skill_file" 2>/dev/null | head -1 \
                  | sed 's/^description: *//')

    # Extract body = everything after the closing frontmatter `---`
    local body
    body=$(awk 'BEGIN{c=0} /^---/{c++; next} c>=2{print}' "$skill_file")

    # Remove old file or symlink, then write a real generated command file
    local cmd_file="$target_dir/${prefix}${slash_cmd}.md"
    rm -f "$cmd_file" 2>/dev/null || true
    {
      printf -- '---\ndescription: %s\n---\n\n' "$description"
      printf '%s\n' "$body"
    } > "$cmd_file"
  done
  echo "  ✓ $label"
}

# ─── Selection helpers ────────────────────────────────────────────────────────

_apply_selection() {
  # Reads newline-separated selected labels from $1, updates SEL array
  local result="$1"
  SEL=( 0 0 0 0 0 0 0 0 0 0 0 0 )
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    for ((i=0; i<12; i++)); do
      [ "${LABELS[$i]}" = "$line" ] && SEL[$i]=1
    done
  done <<< "$result"
}

_select_with_fzf() {
  local result
  result=$(printf '%s\n' "${LABELS[@]}" | \
    fzf --multi \
        --bind 'start:select-all' \
        --bind 'ctrl-a:select-all' \
        --bind 'ctrl-d:deselect-all' \
        --height='~100%' \
        --layout=reverse \
        --border=rounded \
        --prompt='  Install › ' \
        --header=$'TAB/SPACE toggle · CTRL-A select all · CTRL-D deselect all · ENTER confirm\n\n  Project: Claude Code · Cursor · Windsurf · OpenCode\n  Global:  Claude Code · Codex · Gemini · Copilot · OpenCode · Cursor · Kiro · Pi'
  ) || return 1
  _apply_selection "$result"
}

_select_with_gum() {
  local selected_str result
  # Build comma-separated pre-selection string from all labels
  selected_str=$(printf '%s,' "${LABELS[@]}")
  selected_str="${selected_str%,}"  # remove trailing comma

  result=$(gum choose --no-limit \
    --height=16 \
    --header="Select agents to install (SPACE toggle, ENTER confirm):" \
    --selected="$selected_str" \
    "${LABELS[@]}") || return 1
  _apply_selection "$result"
}

_select_fallback() {
  # Simple numbered list — press ENTER to install all, or enter numbers to skip
  echo "  Agents available:"
  echo ""
  echo "  ── Project ──────────────────────────────────"
  for ((i=0; i<4; i++)); do
    printf "  %2d) %s\n" $((i+1)) "${LABELS[$i]}"
  done
  echo ""
  echo "  ── Global ───────────────────────────────────"
  for ((i=4; i<12; i++)); do
    printf "  %2d) %s\n" $((i+1)) "${LABELS[$i]}"
  done
  echo ""
  printf "  Enter numbers to SKIP (e.g. 5 6 7), or press ENTER to install all: "
  local skip_input
  read -r skip_input
  if [ -n "$skip_input" ]; then
    for n in $skip_input; do
      local idx=$((n-1))
      [ "$idx" -ge 0 ] && [ "$idx" -lt 12 ] && SEL[$idx]=0
    done
  fi
}

# ─── Tool detection + multiselect ─────────────────────────────────────────────

run_multiselect() {
  [ -t 0 ] && [ -t 1 ] || return 0  # Skip when non-interactive (CI, piped)

  if command -v fzf >/dev/null 2>&1; then
    _select_with_fzf && return 0
  fi

  if command -v gum >/dev/null 2>&1; then
    _select_with_gum && return 0
  fi

  # Neither fzf nor gum found — offer to install gum via brew
  if command -v brew >/dev/null 2>&1; then
    echo "  For a better selection UI, install gum (Charm):"
    echo "    brew install gum"
    echo ""
    printf "  Install gum now? [y/N] "
    local answer
    read -r answer
    echo ""
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      brew install gum
      _select_with_gum && return 0
    fi
  fi

  # Final fallback: numbered list
  _select_fallback
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

  # ── Commands ── always install for Claude Code + OpenCode (project + global)
  echo "→ Installing slash commands..."
  # Claude Code  (subdir style  →  /superspecs:<cmd>)
  install_commands "$PROJECT_DIR/.claude/commands"       ""             "Claude Code commands (project)"
  install_commands "$HOME/.claude/commands"              ""             "Claude Code commands (global)"
  # OpenCode     (flat prefix   →  /superspecs-<cmd>)
  install_commands "$PROJECT_DIR/.opencode/commands"     "superspecs-"  "OpenCode commands (project)"
  install_commands "$HOME/.config/opencode/commands"     "superspecs-"  "OpenCode commands (global)"
  echo ""
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
echo "  Claude Code / Cursor:  /superspecs:<cmd>"
echo "  OpenCode:              /superspecs-<cmd>"
echo ""
echo "  First feature workflow:"
echo "    /superspecs:techstack   (or /superspecs-techstack)"
echo "    /superspecs:discuss     (or /superspecs-discuss)"
echo "    /superspecs:spec        (or /superspecs-spec)"
echo "    /superspecs:grill       (or /superspecs-grill)"
echo "    /superspecs:pick-spec   (or /superspecs-pick-spec)"
echo "    /superspecs:branch      (or /superspecs-branch)"
echo "    /superspecs:subagent    (or /superspecs-subagent)"
echo "    /superspecs:tdd         (or /superspecs-tdd)"
echo "    /superspecs:code-review (or /superspecs-code-review)"
echo "    /superspecs:check-tests (or /superspecs-check-tests)"
echo "    /superspecs:wiki        (or /superspecs-wiki)"
echo "    /superspecs:ship        (or /superspecs-ship)"
echo ""
