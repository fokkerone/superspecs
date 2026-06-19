# How SuperSpecs Works

An explanation of the mechanics behind the framework — how skills are discovered, how slash commands are registered, and how the four-phase lifecycle runs.

---

## The Core Idea

AI coding agents (Claude Code, Cursor, Copilot, OpenCode, Gemini CLI, Codex, Windsurf) are instruction-followers. They do not have an opinion about _how_ to develop software — they follow whatever guidance is in their context. SuperSpecs exploits this by injecting a structured, opinionated workflow into every agent's context before any development begins.

The result: every agent on every project follows the same four-phase lifecycle — Plan, Execute, Verify, Ship — without any custom integration code.

---

## Skills

A **skill** is a Markdown file (`SKILL.md`) that contains step-by-step instructions for one phase of the workflow. Skills are the only real source code in the framework.

```
.skills/
└── execute-tdd/
    └── SKILL.md        ← plain Markdown, no code
```

Each `SKILL.md` starts with a YAML frontmatter block:

```yaml
---
name: execute-tdd
description: Enforce RED → GREEN → REFACTOR with no exceptions
slash_command: tdd
phase: "2.3 — Execute › per task (TDD)"
---
```

- `slash_command` determines the command file name (e.g. `tdd.md` → `/superspecs:tdd`)
- `description` is used in command files and agent skill listings
- The body is the detailed instruction set the agent follows when invoked

---

## Two-Layer Installation

`setup.sh` runs two separate installation steps for each agent:

### 1. Skills (auto-discovery)

Each AI tool has a designated directory it scans for skills. `setup.sh` creates a `<name>/SKILL.md` symlink structure in each of those directories:

```
~/.claude/skills/execute-tdd/SKILL.md   → .skills/execute-tdd/SKILL.md
~/.agents/skills/execute-tdd/SKILL.md   → .skills/execute-tdd/SKILL.md
~/.config/opencode/skills/execute-tdd/SKILL.md  → .skills/execute-tdd/SKILL.md
# ... same for every agent and every skill
```

When an agent starts, it reads its skills directory and registers each skill as available context. The `description` field tells the agent when to invoke a skill automatically.

### 2. Commands (slash invocation)

`setup.sh` also generates **real command files** (not symlinks) in each agent's commands directory. The file name determines the slash command — not the frontmatter:

```
~/.claude/commands/superspecs/ship.md        →  /superspecs:ship   (Claude Code)
~/.config/opencode/commands/superspecs-ship.md  →  /superspecs-ship   (OpenCode)
```

Generated command files contain only a `description` frontmatter field and the skill body. The SKILL.md-specific fields (`slash_command`, `name`, `phase`) are intentionally stripped.

```
# ~/.claude/commands/superspecs/ship.md (generated)
---
description: Create the PR, write the changelog...
---

# Skill: ship
You are shipping the feature...
```

**Command naming by agent:**

| Agent | Format | Example |
|---|---|---|
| Claude Code | `/superspecs:<cmd>` (subdir namespace) | `/superspecs:ship` |
| OpenCode | `/superspecs-<cmd>` (flat prefix) | `/superspecs-ship` |

> OpenCode does not support colon namespacing in command names.

---

## Bootstrap Files

Beyond skills and commands, each agent also gets a **bootstrap file** that is loaded at the start of every session. These prime the agent with the lifecycle summary so it behaves correctly even before a slash command is issued.

| File | Agent | Mechanism |
|---|---|---|
| `CLAUDE.md` | Claude Code | Auto-read at session start |
| `AGENTS.md` | OpenCode / Aider / Codex | Auto-read at session start |
| `GEMINI.md` | Gemini CLI | Auto-read at session start |
| `.cursor/rules/superspecs.mdc` | Cursor | Always-on rule (`alwaysApply: true`) |
| `.windsurf/rules/superspecs.md` | Windsurf | Always-on rule |
| `.github/copilot-instructions.md` | GitHub Copilot | Workspace instructions |

Bootstrap files are short — they contain the lifecycle diagram, the slash command table, the four hard rules, and the key directory paths. They fit comfortably in the initial context window and cost negligible tokens.

---

## The Four-Phase Lifecycle

### Phase 0 — Setup

**Goal:** Ground every future session with a permanent stack profile.

```
/superspecs:techstack  →  wiki/techstack.md   (stack + recommended skills)
```

### Phase 1 — Plan

**Goal:** Produce a spec that fits a fresh 200k-token context window.

```
/superspecs:discuss  →  DISCUSS.md   (decisions, constraints, non-goals)
/superspecs:spec     →  spec.md      (SHALL requirements + GIVEN/WHEN/THEN scenarios)
                         tasks.md    (implementation task list)
                         status.md   (phase tracker)
/superspecs:grill    →  GRILL.md     (verdict: READY or NEEDS REVISION)
```

The 200k window constraint is deliberate: any executor (subagent, fresh session, different agent) must be able to pick up the spec and work from it without needing prior chat history. If a spec is too large to fit, it is decomposed into smaller specs.

A spec that hasn't passed `/superspecs:grill` does not proceed to execution.

### Phase 2 — Execute

**Goal:** Implement the spec in parallel using isolated subagents, with TDD enforced inside every task.

```
/superspecs:pick-spec    Validates spec completeness; creates phases/<slug>-execute/plan.md
/superspecs:branch       git branch or worktree; one branch per spec
/superspecs:subagent     Fresh subagent per task; TDD per task; wave dispatch; human checkpoints
/superspecs:code-review  Spec compliance then code quality; Critical findings block progress
```

Each subagent receives: the spec, its task, and nothing else. No shared state. No reliance on context from other agents. This is what makes parallel execution safe.

**TDD is not a separate step after subagent development.** Every subagent task follows RED → GREEN → REFACTOR before it is considered done. The `/superspecs:tdd` skill defines the cycle; it runs inside every task dispatched by `/superspecs:subagent`.

The per-task cycle:
1. Write a failing test — confirm it fails for the right reason (RED)
2. Write minimum code — confirm it passes (GREEN)
3. Refactor — clean up while tests stay green (REFACTOR)
4. Run the full suite — no regressions
5. Commit
6. Code review: spec compliance first, then code quality

### Phase 3 — Verify

**Goal:** Confirm the implementation matches the spec and the knowledge is preserved.

```
/superspecs:check-tests  Full suite run; every spec scenario covered by a test; no skips
/superspecs:wiki         Compile feature → superspec/wiki/<domain>/<topic>.md
```

The wiki implements the **Karpathy LLM Wiki pattern**: raw sources are compiled once into structured, interlinked markdown pages. Future sessions query the compiled wiki — never the raw specs. The agent compiles once; queries are fast and accurate.

```
superspec/wiki/raw/   ← immutable source material (agent reads, never edits)
superspec/wiki/       ← compiled knowledge base (agent writes on ingest)
superspec/wiki/log.md ← append-only activity log (grep-friendly)
.skills/verify-wiki/  ← schema: how to ingest, link, and format
```

#### The wiki as an Obsidian vault

`superspec/wiki/` is pre-configured as an Obsidian vault. `setup.sh` creates:

```
superspec/wiki/
├── .obsidian/
│   ├── app.json            ← wikilinks on, attachment folder set
│   ├── core-plugins.json   ← graph, backlinks, tag pane, search enabled
│   └── .gitignore          ← workspace + cache excluded from git
├── raw/                    ← source material (drop articles, PDFs, notes here)
├── Home.md                 ← vault home page (updated by /wiki)
├── log.md                  ← append-only activity log
├── _manifest.json          ← machine-readable ingestion log
└── <domain>/
    ├── Home.md             ← domain index
    └── <topic>.md          ← one page per knowledge unit
```

To open the vault: **Obsidian → Open folder as vault → select `superspec/wiki/`**

The `/superspecs:wiki` skill writes every page with:
- `[[wikilinks]]` for all internal cross-references
- YAML frontmatter: `tags`, `created`, `updated`, `spec` (links back to the source spec)
- Domain `Home.md` index files for each folder
- Entries in the vault-wide `Home.md` under Recent Updates
- An entry appended to `log.md`

The shared config (`app.json`, `core-plugins.json`) is committed so every team member opens the vault with the same settings. User-specific state (`workspace.json`, `cache`, plugin data) is gitignored.

#### Wiki Operations (any time)

**`/superspecs:wiki-query`** — Query the compiled wiki for an answer. The agent reads `wiki/` only — not raw specs, not source code. Optionally files the synthesized answer back as a new wiki page.

**`/superspecs:wiki-lint`** — Periodic health check. Finds:
- Orphaned pages (no inbound wikilinks)
- Broken `[[wikilinks]]` (target page missing)
- Missing cross-links (page mentions a topic but doesn't link to its page)
- Contradictions (two pages make conflicting claims)
- Stale file references (backtick paths that no longer exist)
- Missing frontmatter fields

Produces `superspec/wiki/_lint-report.md`. Offers to auto-fix safe issues; contradictions always require human review.

### Phase 4 — Ship

**Goal:** Merge and close the loop.

```
/superspecs:ship  →  PR creation; changelog entry; phase directory archived; spec marked complete
```

After `/superspecs:ship`, the cycle resets: `/superspecs:pick-spec` for the next item.

---

## The `superspec/` Directory

All runtime artifacts live under `superspec/`:

```
superspec/
├── specs/
│   └── <slug>/
│       ├── DISCUSS.md      ← pre-planning decisions
│       ├── spec.md         ← SHALL requirements + scenarios
│       ├── GRILL.md        ← grill verdict + open questions
│       ├── tasks.md        ← task list for /subagent
│       └── status.md       ← phase tracker + checklist
│
├── phases/
│   └── <slug>-execute/
│       ├── plan.md         ← decomposed execution plan
│       ├── review-log.md   ← code review history
│       └── wave-*.md       ← parallel execution waves
│
├── archive/
│   └── <slug>-execute/     ← moved here after /ship
│
└── wiki/
    ├── _index.md           ← domain listing + recent updates
    ├── _manifest.json      ← ingestion log
    └── <domain>/
        └── <topic>.md      ← one page per shipped feature
```

`specs/` is permanent — specifications are never deleted, only marked complete in `status.md`.

`phases/` is ephemeral — working directories are moved to `archive/` after shipping.

`wiki/` grows continuously — every shipped feature adds at least one page.

---

## The Four Hard Rules

These are enforced by the skills and bootstrap files. Agents are instructed to refuse to continue if any rule is violated.

| Rule | Enforcement |
|---|---|
| No implementation code before a failing test | `/superspecs:tdd` deletes code written before tests |
| Critical code-review findings block all progress | `/superspecs:code-review` reports severity; Critical = hard stop |
| Spec must fit a fresh 200k-token context window | `/superspecs:spec` and `/superspecs:pick-spec` both check this |
| Every shipped feature → wiki page | `/superspecs:ship` requires `/superspecs:wiki` to have run first |

---

## The CLI

`bin/superspecs.js` is a thin Node.js wrapper around `setup.sh`:

```bash
superspecs install   # symlink skills + generate command files into all agent dirs
superspecs init      # init superspec/ directory structure only (no agent symlinking)
superspecs version   # print version
superspecs help      # show help
```

```bash
npx superspecs install   # run without a global install
```

All real logic lives in `setup.sh` and the `.skills/` Markdown files.

---

## Creating a New Skill

The `/superspecs:skill-creator` meta-skill documents the full process. In short:

1. Create `.skills/<name>/SKILL.md` with YAML frontmatter (`name`, `description`, `slash_command`, `phase`)
2. Write the step-by-step instructions in the body
3. Run `bash setup.sh` (or `superspecs install`) to:
   - Symlink the skill into all agent skill directories (auto-discovery)
   - Generate a clean command file in each agent's commands directory (slash invocation)
4. Open your agent and invoke the new slash command to test it
