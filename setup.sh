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

# ── Obsidian vault config ──────────────────────────────────────────────────
# Creates superspec/wiki/.obsidian/ so the wiki can be opened as an Obsidian
# vault directly. Workspace and plugin-data files are gitignored.

OBSIDIAN_DIR="$PROJECT_DIR/superspec/wiki/.obsidian"
mkdir -p "$OBSIDIAN_DIR"

if [ ! -f "$OBSIDIAN_DIR/app.json" ]; then
cat > "$OBSIDIAN_DIR/app.json" << 'APPEOF'
{
  "attachmentFolderPath": "_attachments",
  "newFileLocation": "folder",
  "newFileFolderPath": "",
  "useMarkdownLinks": false,
  "showUnsupportedFiles": false,
  "promptDelete": true,
  "trashOption": "local"
}
APPEOF
fi

if [ ! -f "$OBSIDIAN_DIR/core-plugins.json" ]; then
cat > "$OBSIDIAN_DIR/core-plugins.json" << 'CPEOF'
[
  "file-explorer",
  "global-search",
  "switcher",
  "graph",
  "backlinks",
  "outgoing-link",
  "tag-pane",
  "page-preview",
  "outline",
  "starred",
  "command-palette",
  "file-recovery",
  "templates",
  "word-count"
]
CPEOF
fi

# Gitignore for vault-local / user-specific Obsidian files
if [ ! -f "$OBSIDIAN_DIR/.gitignore" ]; then
cat > "$OBSIDIAN_DIR/.gitignore" << 'OGIEOF'
# User-specific Obsidian state — do not commit
workspace.json
workspace-mobile.json
cache
.trash/
plugins/*/data.json
OGIEOF
fi

# ── Wiki 3-layer structure (Karpathy LLM Wiki pattern) ────────────────────
# raw/  — immutable source material (agent reads, never modifies)
# wiki/ — compiled knowledge base (agent writes on ingest/query/lint-fix)
# .skills/verify-wiki/SKILL.md — schema / operating rules

mkdir -p "$PROJECT_DIR/superspec/wiki/raw"

# raw/.gitkeep so the folder is tracked in git
if [ ! -f "$PROJECT_DIR/superspec/wiki/raw/.gitkeep" ]; then
  touch "$PROJECT_DIR/superspec/wiki/raw/.gitkeep"
fi

# raw/README.md — instructions for humans dropping in source material
if [ ! -f "$PROJECT_DIR/superspec/wiki/raw/README.md" ]; then
cat > "$PROJECT_DIR/superspec/wiki/raw/README.md" << 'RAWEOF'
# raw/ — Source Material

Drop articles, PDFs, bookmarks, meeting notes, and external docs here.

**Rules:**
- Agent reads this folder but never edits or deletes files here.
- You commit these files; the agent compiles them into `../` (the wiki).
- To compile a raw document: `/superspecs:wiki-ingest <filename>`
- To compile a completed spec: `/superspecs:wiki <slug>`

Supported: `.md`, `.txt`, `.pdf` (text-extractable)
RAWEOF
fi

# ── Wiki home page ─────────────────────────────────────────────────────────

TODAY=$(date +%Y-%m-%d 2>/dev/null || echo "")

if [ ! -f "$PROJECT_DIR/superspec/wiki/Home.md" ]; then
cat > "$PROJECT_DIR/superspec/wiki/Home.md" << HOMEEOF
---
title: Wiki Home
tags: [index, home]
updated: $TODAY
---

# Project Wiki

Compiled knowledge base — architecture decisions, patterns, trade-offs, gotchas.

> **Obsidian vault** — open \`superspec/wiki/\` in [Obsidian](https://obsidian.md) for graph view, backlinks, tag search, and hover previews.

## Domains

| Domain | Description | Last updated |
|--------|-------------|-------------|

_(domains added automatically by \`/superspecs:wiki\` as features ship)_

## Recent Updates

_(last 10 entries — full history in [[log]])_

---

## Wiki Operations

| Command | What it does |
|---------|-------------|
| \`/superspecs:wiki <slug>\` | Compile a shipped spec into wiki pages |
| \`/superspecs:wiki-query\` | Query the compiled wiki |
| \`/superspecs:wiki-lint\` | Health check: orphans, broken links, contradictions |

---

_Maintained by [SuperSpecs](https://github.com/fokkerone/superspecs)_
HOMEEOF
fi

# ── Wiki log (append-only activity log) ───────────────────────────────────

if [ ! -f "$PROJECT_DIR/superspec/wiki/log.md" ]; then
cat > "$PROJECT_DIR/superspec/wiki/log.md" << LOGEOF
---
title: Wiki Log
tags: [log, activity]
---

# Wiki Log

Append-only activity log. Every ingest, query, and lint run appends an entry here.

> grep-friendly: \`grep "## \[" log.md\` lists all events

---

## [$TODAY] init | Wiki initialized

- Structure: \`raw/\` (sources) + \`wiki/\` (compiled) + \`.skills/verify-wiki/SKILL.md\` (schema)
- Vault ready to open in Obsidian

LOGEOF
fi

if [ ! -f "$PROJECT_DIR/superspec/wiki/_manifest.json" ]; then
  echo '{"sources":[]}' > "$PROJECT_DIR/superspec/wiki/_manifest.json"
fi

# ── Wiki meta directory (taxonomy, insights) ───────────────────────────────

mkdir -p "$PROJECT_DIR/superspec/wiki/_meta"
mkdir -p "$PROJECT_DIR/superspec/wiki/_archives"

if [ ! -f "$PROJECT_DIR/superspec/wiki/_meta/taxonomy.md" ]; then
cat > "$PROJECT_DIR/superspec/wiki/_meta/taxonomy.md" << 'TAXEOF'
---
title: Wiki Taxonomy
updated: ""
---

# Wiki Taxonomy

Canonical vocabulary for this vault: domain folders and tags.
- Run `/superspecs:tag-taxonomy` to audit and normalize tags.
- Run `/superspecs:wiki-lint` to detect domain drift.

---

## Domains

Domains are concern-centric, not feature-centric. A page's domain describes *what the
knowledge is about*, not which feature introduced it. Feature traceability lives in
`spec:` frontmatter, not in the folder name.

### Core Domains

| Domain | Folder | What goes here |
|--------|--------|----------------|
| `patterns` | `patterns/` | Cross-cutting implementation patterns: error handling, caching, retry, testing |
| `decisions` | `decisions/` | Architecture Decision Records — why X was chosen over Y |
| `auth` | `auth/` | Authentication, authorization, sessions, tokens |
| `api` | `api/` | API contracts, endpoint design, versioning, request/response shapes |
| `data` | `data/` | Data models, schemas, storage strategy, migrations |
| `ui` | `ui/` | Frontend components, routing, state management, styling patterns |
| `infra` | `infra/` | Deployment, CI/CD, environment config, hosting |
| `techstack` | `techstack/` | Stack profile and library choices (managed by /techstack) |

### Routing Rules

When ingesting a feature, assign each knowledge unit to a domain using this decision tree:

1. **Reusable cross-cutting pattern** (error handling, caching, retry, logging)? → `patterns/`
2. **Architecture decision** — why X was chosen over Y? → `decisions/`
3. **Auth, sessions, tokens, permissions**? → `auth/`
4. **API contract, endpoint, or request/response shape**? → `api/`
5. **Data model, schema, or storage decision**? → `data/`
6. **Infrastructure or deployment**? → `infra/`
7. **Frontend / UI concern**? → `ui/`
8. **Feature-specific knowledge that fits none of the above**?
   → Create a domain named after the feature slug (e.g. `payment-flow/`)
   → Add it to this file under "Project Domains" before creating the folder

**One domain per page.** If a page spans multiple concerns, split it into separate pages.
**Prefer existing domains.** Only create a new domain if nothing above fits.

### Project Domains

_(feature-specific domains added here as the project grows)_

---

## Domain Tags

Tags mirror domain names. Every page gets a tag matching its domain.

- `auth` — authentication and authorization
- `api` — API design and contracts
- `data` — data models and storage
- `ui` — frontend and interface
- `infra` — infrastructure and deployment
- `patterns` — reusable implementation patterns
- `decisions` — architecture decision records

## Topic Tags

_(add project-specific topic tags here)_

## Meta Tags

- `index` — index and home pages (reserved)
- `log` — activity log (reserved)
- `insights` — generated insights pages (reserved)
- `lint` — lint report pages (reserved)
- `query-derived` — pages created from /wiki-query results
- `capture` — pages created from /wiki-capture

## Aliases

_(non-canonical → canonical mappings, managed by /tag-taxonomy)_
TAXEOF
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
echo "  Wiki as Obsidian vault → open superspec/wiki/ in Obsidian"
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
