```
            ________  ________  ________  ________  ________
           ╱        ╲╱    ╱   ╲╱        ╲╱        ╲╱        ╲
          ╱        _╱         ╱         ╱         ╱         ╱
         ╱-        ╱         ╱       __╱        _╱        _╱
         ╲_______╱╱╲________╱╲______╱  ╲________╱╲____╱___╱
                             ________  ________  ________  ________  ________
                            ╱        ╲╱        ╲╱        ╲╱        ╲╱        ╲
                           ╱        _╱         ╱         ╱         ╱        _╱
                          ╱-        ╱       __╱        _╱       --╱-        ╱
                          ╲_______╱╱╲______╱  ╲________╱╲________╱╲________╱
```

# SuperSpecs

**Spec-driven planning. Parallel TDD execution. A wiki that never forgets.**

[![npm](https://img.shields.io/npm/v/superspecs)](https://www.npmjs.com/package/superspecs)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Works with: Claude Code · Cursor · OpenCode · Copilot · Codex · Gemini CLI](https://img.shields.io/badge/agents-Claude%20Code%20·%20Cursor%20·%20OpenCode%20·%20Copilot-blue)]()

[How It Works](HOWITWORKS.md) · [Local Development](LOCALDEVELOPMENT.md)

---

Most teams using AI coding agents hit the same wall: the agent hallucinates architecture it didn't build, re-solves problems solved three sessions ago, and contradicts decisions made last week. The context window resets. The knowledge vanishes. Every session starts from zero.

**SuperSpecs is the discipline layer that makes AI-driven development actually compound.**

Three pillars — each solving a distinct failure mode:

**Spec** — before any code exists, intent is captured as testable, machine-readable requirements: GIVEN/WHEN/THEN scenarios, SHALL statements, explicit non-goals. The spec fits a fresh 200k context window. Every executor starts with the full contract — not a partial reconstruction of chat history.

**TDD** — RED before GREEN, without exception. Tests are written first. Code written without a failing test gets deleted. The test suite is the ground truth, not the agent's confidence.

**Wiki** — Andrej Karpathy's insight, applied at the project level: the context window is ephemeral, but the wiki is permanent. After every shipped feature, knowledge is distilled into structured pages — architecture decisions, patterns, trade-offs, gotchas, open questions. The next session opens the wiki and starts _informed_, not blind. Knowledge compounds. Problems stay solved. The codebase has memory.

The result: five AI agents running in parallel, each with a fresh context, each working from the same spec, each contributing to the same wiki. Nothing lost between sessions. Nothing re-discovered twice. Every shipped feature leaves the system more legible than it found it.

---

## The Four Phases

```
 _  _  __  _   _   _ _____   _   _  __  ___ _  __ __
| || |/__\| | | | | |_   _| | | | |/__\| _ \ |/ /' _/
| >< | \/ | 'V' | | | | |   | 'V' | \/ | v /   <`._`.
|_||_|\__/!_/ \_! |_| |_|   !_/ \_!\__/|_|_\_|\_\___/
┌─────────────────────────────────────────────────────┐
│  PHASE 0  ·  SETUP                                  │
├─────────────────────────────────────────────────────┤
│  Define the stack. Get skill & library recs.        │
│  Ground every session that follows.                 │
├─────────────────────────────────────────────────────┤
│  /techstack                                         │
└─────────────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────┐
│  PHASE 1  ·  PLAN                                   │
├─────────────────────────────────────────────────────┤
│  Intent before implementation.                      │
│  Every requirement is testable.                     │
│  The spec fits a fresh 200k context window.         │
├─────────────────────────────────────────────────────┤
│  /design-import <path>  (optional, see §1.0)        │
│  /discuss  →  /spec  →  /grill                      │
└─────────────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────┐
│  PHASE 2  ·  EXECUTE                                │
├─────────────────────────────────────────────────────┤
│  One branch per spec. One subagent per task.        │
│  RED before GREEN, always.                          │
│  Critical findings block all progress.              │
├─────────────────────────────────────────────────────┤
│  /pick-spec  →  /branch  →  /subagent               │
│  (TDD per task)  →  /code-review                    │
└─────────────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────┐
│  PHASE 3  ·  VERIFY                                 │
├─────────────────────────────────────────────────────┤
│  Full suite. Every spec scenario has a test.        │
│  Then distill everything into the wiki.             │
├─────────────────────────────────────────────────────┤
│  /check-tests  →  /wiki                             │
└─────────────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────┐
│  PHASE 4  ·  SHIP                                   │
├─────────────────────────────────────────────────────┤
│  PR. Changelog. Archive. Start the next cycle.      │
├─────────────────────────────────────────────────────┤
│  /ship                                              │
└─────────────────────────────────────────────────────┘
```

---

## Phase 0 — Setup

> Run once per project. Revisit when the stack changes.

Define the project's tech stack through a guided questionnaire. Get concrete recommendations for specialist skills to install, ecosystem libraries per domain, and a production-readiness checklist tailored to your stack. Also fetches and filters the [awesome-skills.com](https://awesome-skills.com/) community directory live — surfacing the highest-starred, best-matched skills for your stack, with a curated fallback if unavailable. Saves a permanent profile to the wiki that every future session can reference.

**Skills:** `/superspecs:techstack`

---

## Phase 1 — Plan

Before any code exists, the plan must fit in a fresh 200k-token context window. This discipline ensures every executor starts clean — no partial history, no reconstructed intent.

### 1.0 Design Import (`/superspecs:design-import`) — optional

> **Optional enrichment.** Run before `/discuss` when you have a DesignOS export. Creates `design-context.md` that carries design constraints, data shapes, milestone structure, and test scaffolding. The normal `/discuss` + `/spec` flow still runs — it just reads `design-context.md` alongside `DISCUSS.md`.

A DesignOS export is a structured product package: product overview, incremental milestones, test instructions, TypeScript types, design system tokens, and component screenshots. This skill reads the export and extracts the planning-relevant material into a single context file.

**What gets extracted into `design-context.md`:**

| DesignOS file | Extracted as |
|--------------|--------------|
| `product-overview.md` | Product overview + open questions for `/discuss` |
| `incremental/01-shell.md` … `NN-section.md` | Milestone → wave mapping for `tasks.md` |
| `test-instructions/tests.md` | Test scaffolding → GIVEN/WHEN/THEN starting points for `/spec` |
| `data-shape/types.ts` | Data contract → Interface section in `/spec` |
| `design-system/` | Locked constraint → NFRs + Out of Scope in `/spec` |
| `components/screenshots/` | Preserved in `wiki/raw/design-system/screenshots/` (visual refs for subagents) |

**Build order is sequential:** Each DesignOS milestone maps to one execution wave. Wave N always depends on Wave N-1. The shell milestone (01) is always Wave 1 — it installs design tokens and structure that all later sections depend on.

**Output:** `design-context.md` (or enriched `DISCUSS.md` if one already exists) + design assets in `wiki/raw/design-system/`.

**Next:** `/superspecs:discuss` — the discussion reads both `design-context.md` and any existing context. Then `/superspecs:spec` writes the spec from both sources. Then `/superspecs:grill`.

---

### 1.1 Discuss (`/superspecs:discuss`)

Capture implementation decisions _before_ anything is planned. Goals, constraints, open questions, explicit non-goals. One question at a time, conversational. The output is a `DISCUSS.md` — the foundation for the spec.

### 1.2 Spec (`/superspecs:spec`)

Write an OpenSpec-style spec from the discussion. Requirements expressed as SHALL statements with GIVEN/WHEN/THEN scenarios. Lives in `superspec/specs/<slug>/spec.md`.

If `design-context.md` exists alongside `DISCUSS.md`, the spec reads both: `DISCUSS.md` carries human decisions; `design-context.md` carries design constraints. Design system constraints land in Non-Functional Requirements, data contract types in an Interface section, milestones drive the wave structure in `tasks.md`, and test scaffolding becomes scenario starting points.

**Exit criterion:** spec + context fits a fresh 200k-token window. If it doesn't, decompose into smaller specs.

### 1.3 Grill (`/superspecs:grill`)

A relentless interview to stress-test the spec before any code is written. The agent walks every branch of the decision tree — one question at a time, always providing a recommended answer.

The grill validates the spec against two sources of truth:

- **Wiki** — does the spec contradict established patterns, decisions, or interfaces already documented?
- **Techstack** — does the spec assume libraries, approaches, or patterns that conflict with the defined stack?

If the codebase can answer a question, the agent explores it instead of asking. The session ends with a verdict: **READY** (proceed to `/pick-spec`) or **NEEDS REVISION** (spec must be updated and re-grilled).

Output: `superspec/specs/<slug>/GRILL.md` + any required updates to `spec.md`.

**Exit criterion:** verdict is READY. A spec that hasn't been grilled does not proceed to execution.

**Skills:** `/superspecs:discuss` → `/superspecs:spec` → `/superspecs:grill`  
**With DesignOS export:** `/superspecs:design-import <path>` → `/superspecs:discuss` → `/superspecs:spec` → `/superspecs:grill`

---

## Phase 2 — Execute

Parallel execution. Each subagent gets a clean context. No shared state between tasks. No "do you remember what we talked about earlier" — the spec and the wiki carry everything.

### 2.1 Pick Spec (`/superspecs:pick-spec`)

Choose the next spec to execute. Check dependencies, verify the spec is complete, confirm it fits a fresh context window.

### 2.2 Branch (`/superspecs:branch`)

Create a git branch or worktree for isolated execution. One branch per spec.

### 2.3 Subagent Development (`/superspecs:subagent`)

Dispatches a fresh subagent per task. Each gets: the spec, the task, and nothing else. **TDD runs inside each task** — every subagent follows RED → GREEN → REFACTOR before a task is considered done. Two-stage review after each task: spec compliance first, code quality second. Supports wave mode with human checkpoints between waves, or batch mode.

The cycle per task:
1. Write a failing test — watch it fail for the right reason (RED)
2. Write minimal code — watch it pass (GREEN)
3. Refactor — clean up while tests stay green (REFACTOR)
4. Commit
5. Code review (spec compliance → code quality)

Code written before a failing test gets deleted.

### 2.4 Code Review (`/superspecs:code-review`)

Runs between tasks. Reviews against the spec. Reports issues by severity. **Critical issues block all progress** — nothing moves forward until resolved.

**Skills:** `/superspecs:pick-spec` → `/superspecs:branch` → `/superspecs:subagent` (with TDD per task) → `/superspecs:code-review`

---

## Phase 3 — Verify

Walk through what was built. Diagnose and fix before declaring done. Then distill everything learned into the wiki — so the next session inherits the knowledge.

### 3.1 Check Tests (`/superspecs:check-tests`)

Full test suite. Coverage check. Every spec scenario verified by a test. No passing with skipped or pending tests.

### 3.2 Wiki Import (`/superspecs:wiki`)

Compile the implemented feature into the project wiki — architecture decisions, patterns, trade-offs, gotchas. The wiki is the memory that outlives the session. See [The Wiki](#the-wiki) for the full architecture, ingest process, query, and lint operations.

**Skills:** `/superspecs:check-tests` → `/superspecs:wiki`

### Wiki Operations (any time)

| Command | What it does |
|---------|-------------|
| **`/superspecs:wiki-query`** | Query the compiled wiki using tiered retrieval; optionally file the answer back as a new page |
| **`/superspecs:wiki-capture`** | Save session findings now — `--quick` stages to `raw/`, `--full` ingests directly |
| **`/superspecs:wiki-lint`** | Health check: orphans, broken wikilinks, contradictions, stale file refs |
| **`/superspecs:cross-linker`** | Auto-insert `[[wikilinks]]` for unlinked mentions across the vault |
| **`/superspecs:wiki-status`** | Vault dashboard: page count, hub pages, tag distribution, provenance, pending sources |
| **`/superspecs:tag-taxonomy`** | Canonical tag vocabulary; audit and normalize tags vault-wide |
| **`/superspecs:wiki-rebuild`** | Archive + rebuild vault from scratch; restore from snapshot |

---

## Phase 4 — Ship

### Ship (`/superspecs:ship`)

Create the PR. Write a changelog entry. Archive the phase directory. Mark the spec complete. Trigger the next cycle.

**Skills:** `/superspecs:ship`

---

## The Wiki

The wiki is a compiled, structured knowledge base that outlives every session. It implements the **Karpathy LLM Wiki pattern**: raw source material is compiled once into interlinked markdown pages. Future sessions query the compiled wiki — never the raw specs. Compile once, query fast. Knowledge compounds.

### Architecture

```
superspec/wiki/
├── raw/                ← you drop files here; agent reads, never edits
├── _meta/
│   └── taxonomy.md     ← canonical tag vocabulary (managed by /tag-taxonomy)
├── _archives/          ← timestamped vault snapshots (managed by /wiki-rebuild)
├── Home.md             ← vault home: domain table + recent updates
├── log.md              ← append-only activity log (grep-friendly)
├── _manifest.json      ← machine-readable ingestion history
├── _lint-report.md     ← written by /wiki-lint
├── _insights.md        ← written by /wiki-status (optional)
└── <domain>/
    ├── Home.md         ← domain index
    ├── <topic-a>.md    ← one page per knowledge unit
    └── <topic-b>.md
```

Three layers:

| Layer | Path | Who touches it |
|-------|------|----------------|
| **Raw** (source material) | `wiki/raw/` | You drop files; agent reads only |
| **Compiled** (knowledge base) | `wiki/` | Agent writes on ingest/query/capture |
| **Schema** (operating rules) | `.skills/verify-wiki/SKILL.md` | Defines how to ingest, link, and format |

The wiki doubles as an **Obsidian vault**. Open `superspec/wiki/` in Obsidian for graph view, backlinks, tag search, and hover previews — all pre-configured by `superspecs install`.

---

### Ingest — `/superspecs:wiki`

Run after every `/ship`. Compiles a completed, verified feature into the wiki.

**What it does:**

1. Reads raw source material — `DISCUSS.md`, `spec.md`, `review-log.md`, key implementation files
2. **Scans existing wiki pages first** — updates a page if the topic already exists, never creates duplicates
3. Writes new pages with full frontmatter:
   - `summary:` — 1–2 sentence preview (used by `/wiki-query` for fast retrieval)
   - `tags:` — from `_meta/taxonomy.md` canonical vocabulary
   - `provenance:` — tracks what % of content is extracted vs. inferred
   - `[[wikilinks]]` for all internal cross-references
4. Updates domain `Home.md` index and vault `Home.md`
5. Appends to `wiki/log.md`
6. Updates `_manifest.json`

**Provenance tracking** — every page marks claim origins:
- No marker = extracted directly from source material
- `^[inferred]` = agent synthesis, not stated verbatim
- `^[ambiguous]` = sources disagree or claim is uncertain

**What it distills:** architecture decisions, patterns, gotchas, key interfaces, open questions.  
**What it does NOT copy:** full code listings, task checklists, or the spec itself.

---

### Query — `/superspecs:wiki-query`

Ask a question; get an answer synthesized from the compiled wiki using **tiered retrieval**.

```
"What do we know about error handling?"
"What was the decision on the database choice?"
"Find everything about the payment integration."
```

**Tiered retrieval — cost stays flat as the vault grows:**

1. **Phase 1 (cheap):** scan frontmatter only — `title`, `tags`, `summary:` — across all pages. Score relevance, select top 3–5 candidates
2. **Phase 2 (targeted):** open full body of top candidates only. Follow `[[wikilinks]]` one level deep

Say **"quick answer"** or **"just scan"** to force index-only mode (Phase 1 only).

**Key rule:** reads `wiki/` only — never `raw/`, never specs, never source code.

**Optional:** file the answer back as a new wiki page — useful for synthesized cross-domain knowledge.

---

### Lint — `/superspecs:wiki-lint`

Periodic health check. Finds structural and semantic problems.

| Check | What it finds |
|-------|--------------|
| **Orphaned pages** | Pages with no inbound `[[wikilinks]]` |
| **Broken wikilinks** | `[[links]]` pointing to non-existent pages |
| **Missing cross-links** | Page A mentions a topic with its own page B but doesn't link to it |
| **Contradictions** | Two pages make conflicting claims about the same decision or pattern |
| **Stale file refs** | Backtick paths pointing to files that no longer exist |
| **Missing frontmatter** | Pages missing `title`, `tags`, `summary:`, `created`, or `updated` |
| **Undocumented domains** | Domain folder exists but has no `Home.md` |

Output: `wiki/_lint-report.md` + appended `log.md`. Auto-fixes safe issues with confirmation; contradictions always require human review.

---

### Cross-link — `/superspecs:cross-linker`

Automatically weave `[[wikilinks]]` across the vault. Run after any ingest to connect new knowledge to existing pages.

**What it does:**
1. Builds a map of all page titles and aliases
2. Scans every page body for unlinked mentions of other page titles
3. Inserts `[[wikilinks]]` for first occurrences only (not inside code blocks or headings)
4. Reports every change made

**Guards:** skips aliases shorter than 4 characters, generic English words, self-references, and anything already linked.

---

### Status — `/superspecs:wiki-status`

Dashboard of the vault's current state.

```
VAULT SIZE       32 pages across 6 domains
RECENT ACTIVITY  Last ingest: 2026-06-19 (auth-flow)
HUB PAGES        [[auth/jwt-refresh]] (12 backlinks), [[patterns/error-handling]] (9)
TAG DISTRIBUTION auth (14)  api (11)  patterns (9) ...
PROVENANCE       Extracted: 72%  Inferred: 23%  Ambiguous: 5%
PENDING          2 specs not yet compiled, 1 raw/ file not yet ingested
HEALTH           3 orphans, 1 broken link (run /wiki-lint for details)
```

Optionally writes a full `_insights.md` to the vault.

---

### Capture — `/superspecs:wiki-capture`

Save findings from the current session before the context window resets.

- **`--quick` (default):** stages a structured draft to `wiki/raw/capture-<timestamp>.md` in under 60 seconds. The next `/wiki` run promotes it to proper pages.
- **`--full`:** distills directly to wiki pages following the full ingest process.

**What gets captured:** decisions made, bugs fixed and their root causes, patterns discovered, gotchas, open questions. Noise is dropped.

---

### Tag Taxonomy — `/superspecs:tag-taxonomy`

Maintain a controlled vocabulary so tags stay consistent across the vault.

- `_meta/taxonomy.md` — the canonical tag list (domain tags, topic tags, aliases)
- **Audit mode:** scans all pages, finds non-canonical tags, proposes normalization
- **Normalize mode:** applies fixes after confirmation — updates frontmatter across the vault
- **Init mode:** first run with no taxonomy — scans all existing tags and proposes a vocabulary

---

### Rebuild — `/superspecs:wiki-rebuild`

When the wiki has accumulated too much drift, archive and rebuild from scratch.

| Mode | What it does |
|------|-------------|
| `archive` | Snapshot current vault to `_archives/<timestamp>/` |
| `rebuild` | Archive + wipe compiled wiki + recompile all shipped specs + raw files |
| `restore <timestamp>` | Roll back to a previous archive (auto-archives current state first) |
| `list` | Show all available snapshots |

**Safety rules:** never touches `raw/`, `.obsidian/`, `log.md`, or `_archives/`. Always archives before any destructive operation. Always asks for confirmation.

---

### When to run each command

| When | Command |
|------|---------|
| After every `/ship` | `/superspecs:wiki <slug>` |
| After ingest — connect new pages | `/superspecs:cross-linker` |
| Before new planning cycle | `/superspecs:wiki-query "What do we know about X?"` |
| Before `/grill` — check existing decisions | `/superspecs:wiki-query` |
| Mid-session — save important findings | `/superspecs:wiki-capture` |
| Drop article/doc into `raw/` | `/superspecs:wiki <filename>` |
| Check vault health | `/superspecs:wiki-status` |
| Tags getting inconsistent | `/superspecs:tag-taxonomy` |
| Monthly / before a release | `/superspecs:wiki-lint` |
| Wiki has too much drift | `/superspecs:wiki-rebuild` |

---

```bash
# Install globally
npm install -g superspecs

# Run in your project to symlink skills into all your AI agents
cd your-project
superspecs install

# Or without a global install
npx superspecs install
```

Then open your agent and say: **"Tell me about your superspecs"**

> **Command format by agent**
> - Claude Code / Cursor: `/superspecs:techstack`
> - OpenCode / Aider: `/superspecs-techstack`

> **Wiki as Obsidian vault** — after `superspecs install`, open `superspec/wiki/` in [Obsidian](https://obsidian.md) as a vault. Graph view, backlinks, and tag search work out of the box.

### First feature

```
/superspecs:techstack    Define stack, get skill & library recommendations
/superspecs:discuss      What are we building and why?
/superspecs:spec         Write the spec
/superspecs:grill        Stress-test spec against wiki + techstack
/superspecs:pick-spec    Confirm it fits a clean context
/superspecs:branch       Create worktree
/superspecs:subagent     Start execution (TDD runs inside each task)
/superspecs:tdd          Standalone: enforce RED-GREEN-REFACTOR outside subagent
/superspecs:code-review  Check between tasks
/superspecs:check-tests  Verify everything passes
/superspecs:wiki         Distill to knowledge base
/superspecs:ship         PR + archive
```

---

## Project Structure

```
your-project/
├── superspec/
│   ├── specs/                      # Feature specifications
│   │   └── <slug>/
│   │       ├── DISCUSS.md          # Pre-planning decisions
│   │       ├── design-context.md   # Optional — from /design-import (DesignOS enrichment)
│   │       ├── spec.md             # The spec (SHALL + scenarios)
│   │       ├── tasks.md            # Implementation tasks
│   │       └── status.md           # Phase + checklist
│   │
│   ├── phases/                     # Active phase working dirs
│   │   └── <slug>-<phase>/
│   │       ├── plan.md             # Decomposed execution plan
│   │       ├── review-log.md       # Code review history
│   │       └── wave-*.md           # Parallel execution waves
│   │
│   └── wiki/                       # Living knowledge base (Obsidian vault)
│       ├── raw/                    # Source material — agent reads, never edits
│       ├── Home.md                 # Vault home + domain catalog
│       ├── log.md                  # Append-only activity log
│       ├── _manifest.json          # Machine-readable ingestion history
│       └── <domain>/
│           ├── Home.md             # Domain index
│           └── <topic>.md          # One page per knowledge unit
│
├── .skills/                        # SuperSpecs skills (source of truth)
│   ├── design-import/SKILL.md
│   ├── techstack/SKILL.md
│   ├── plan-discuss/SKILL.md
│   ├── plan-spec/SKILL.md
│   ├── plan-grill/SKILL.md
│   ├── execute-pick-spec/SKILL.md
│   ├── execute-branch/SKILL.md
│   ├── execute-subagent/SKILL.md
│   ├── execute-tdd/SKILL.md
│   ├── execute-review/SKILL.md
│   ├── verify-tests/SKILL.md
│   ├── verify-wiki/SKILL.md
│   ├── wiki-query/SKILL.md
│   ├── wiki-lint/SKILL.md
│   ├── cross-linker/SKILL.md
│   ├── wiki-status/SKILL.md
│   ├── wiki-capture/SKILL.md
│   ├── tag-taxonomy/SKILL.md
│   ├── wiki-rebuild/SKILL.md
│   ├── ship/SKILL.md
│   └── skill-creator/SKILL.md
│
├── CLAUDE.md                       # Bootstrap → Claude Code
├── AGENTS.md                       # Bootstrap → Codex / OpenCode / Aider
├── .cursor/rules/superspecs.mdc    # Always-on → Cursor
├── .windsurf/rules/superspecs.md   # Always-on → Windsurf
├── .github/copilot-instructions.md # Always-on → Copilot
└── setup.sh
```

---

## Skill Reference

| Phase   | Skill               | Command                      | What it does                                                                 |
| ------- | ------------------- | ---------------------------- | ---------------------------------------------------------------------------- |
| Setup   | `techstack`         | `/superspecs:techstack`      | Questionnaire: define stack, recommend skills & libraries, save wiki profile |
| Plan    | `design-import`     | `/superspecs:design-import`  | Optional enrichment: reads DesignOS export, creates `design-context.md` for `/discuss` + `/spec` to use |
| Plan    | `plan-discuss`      | `/superspecs:discuss`        | Capture decisions before planning                                            |
| Plan    | `plan-spec`         | `/superspecs:spec`           | Write OpenSpec-style spec                                                    |
| Plan    | `plan-grill`        | `/superspecs:grill`          | Stress-test spec against wiki + techstack, blocks execution until READY      |
| Execute | `execute-pick-spec` | `/superspecs:pick-spec`      | Choose + validate next spec                                                  |
| Execute | `execute-branch`    | `/superspecs:branch`         | Create branch / worktree                                                     |
| Execute | `execute-subagent`  | `/superspecs:subagent`       | Parallel subagent task execution                                             |
| Execute | `execute-tdd`       | `/superspecs:tdd`            | RED-GREEN-REFACTOR — runs inside each subagent task; invoke standalone for code outside subagent mode |
| Execute | `execute-review`    | `/superspecs:code-review`    | Between-task spec + quality review                                           |
| Verify  | `verify-tests`      | `/superspecs:check-tests`    | Full suite + scenario coverage                                               |
| Verify  | `verify-wiki`       | `/superspecs:wiki`           | Compile feature to wiki — ingest, provenance, summary frontmatter           |
| Wiki    | `wiki-query`        | `/superspecs:wiki-query`     | Tiered retrieval query; optionally file answer back as a page               |
| Wiki    | `wiki-lint`         | `/superspecs:wiki-lint`      | Health check: orphans, broken links, contradictions, stale refs             |
| Wiki    | `cross-linker`      | `/superspecs:cross-linker`   | Auto-insert `[[wikilinks]]` for unlinked mentions across the vault          |
| Wiki    | `wiki-status`       | `/superspecs:wiki-status`    | Vault dashboard: size, hubs, tag stats, provenance, pending sources         |
| Wiki    | `wiki-capture`      | `/superspecs:wiki-capture`   | Save session findings to wiki (`--quick` stages to raw/, `--full` ingests)  |
| Wiki    | `tag-taxonomy`      | `/superspecs:tag-taxonomy`   | Canonical tag vocabulary; audit and normalize tags vault-wide               |
| Wiki    | `wiki-rebuild`      | `/superspecs:wiki-rebuild`   | Archive + rebuild vault; restore from snapshot                              |
| Ship    | `ship`              | `/superspecs:ship`           | PR + archive + next cycle                                                   |
| Meta    | `skill-creator`     | `/superspecs:skill-creator`  | Create a new SuperSpecs skill to extend the framework                        |

---

## Design Principles

**Plan fits a fresh context window.** No executor should need prior chat history to understand their task. If the plan is too big, it gets decomposed.

**Tests first, always.** Code written before tests gets deleted. No exceptions. RED before GREEN.

**Critical issues block progress.** A `/code-review` finding rated Critical is not a suggestion. Nothing moves forward until it's resolved.

**Knowledge outlives the session.** The wiki uses the Karpathy LLM Wiki pattern: raw sources are compiled once into structured, interlinked pages. Future sessions query the wiki — not the raw specs. Knowledge compounds; problems stay solved.

**One branch per spec.** Isolation prevents interference between parallel workstreams.

---

## License

MIT
