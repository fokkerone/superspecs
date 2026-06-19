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

**A unified AI development framework: spec-driven planning → parallel TDD execution → verified shipping — with living wiki memory.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Works with: Claude Code · Cursor · OpenCode · Copilot · Codex · Gemini CLI](https://img.shields.io/badge/agents-Claude%20Code%20·%20Cursor%20·%20OpenCode%20·%20Copilot-blue)]()

---

## The Four Phases

```

┌─────────────────────────────────────────────────────────────────────────┐
│ SUPERSPEC LIFECYCLE │
│ │
│ 1 ── PLAN 2 ── EXECUTE │
│ ───────────────── ────────────────────────────── │
│ /discuss /pick-spec │
│ Capture decisions → /branch → fresh worktree │
│ /spec /subagent → parallel tasks │
│ Write spec → /tdd → RED-GREEN-REFACTOR │
│ Fits 200k window /code-review → block on critical │
│ │
│ 3 ── VERIFY 4 ── SHIP │
│ ───────────────── ────────────────────────────── │
│ /check-tests /ship │
│ All green? → Create PR │
│ /wiki Archive phase │
│ Distill knowledge Repeat for next spec │
└─────────────────────────────────────────────────────────────────────────┘

```

---

## Phase 1 — Plan

Before any code exists, the plan must fit in a fresh 200k-token context window. This discipline ensures every executor starts clean.

### 1.1 Discuss (`/discuss`)

Capture implementation decisions _before_ anything is planned. Goals, constraints, open questions, non-goals. The output is a `DISCUSS.md` — the foundation for the spec.

### 1.2 Spec (`/spec`)

Write an OpenSpec-style spec from the discussion. Requirements expressed as SHALL statements with GIVEN/WHEN/THEN scenarios. Lives in `superspec/specs/<slug>/spec.md`.

**Exit criterion:** The spec + context fits a fresh 200k-token window. If it doesn't, decompose into smaller specs.

---

## Phase 2 — Execute

Parallel execution. Each executor gets a clean context. No shared state between tasks.

### 2.1 Pick Spec (`/pick-spec`)

Choose the next spec to execute. Check dependencies, verify the spec is complete, confirm it fits a fresh context window.

### 2.2 Branch (`/branch`)

Create a git branch or worktree for isolated execution. One branch per spec.

### 2.3 Subagent Development (`/subagent`)

Dispatches a fresh subagent per task. Each subagent gets: the spec, the task, and nothing else. Two-stage review per task: spec compliance first, code quality second.

Can also run in batch mode with human checkpoints between waves.

### 2.4 TDD (`/tdd`)

Enforces RED → GREEN → REFACTOR strictly:

1. Write failing test — watch it fail for the right reason
2. Write minimal code — watch it pass
3. Commit
4. Code written before tests gets deleted

### 2.5 Code Review (`/code-review`)

Runs between tasks. Reviews against the spec. Reports issues by severity. **Critical issues block progress** — no moving forward until resolved.

---

## Phase 3 — Verify

Walk through what was built. Diagnose and fix before declaring done.

### 3.1 Check Tests (`/check-tests`)

Full test suite run. Coverage check. Every spec scenario verified by a test. No passing with skipped or pending tests.

### 3.2 Wiki Import (`/wiki`)

Distill the implemented feature into the project wiki. Architecture decisions, patterns, trade-offs, gotchas. The wiki is the memory that outlives the session.

---

## Phase 4 — Ship

### Ship (`/ship`)

Create the PR. Write a changelog entry. Archive the phase directory. Mark spec complete. Trigger the next cycle: pick the next spec.

---

## Quick Start

```bash
# Install
git clone https://github.com/your-org/superspecs.git
cd your-project
bash ~/.superspecs/setup.sh   # symlinks skills into all your agents

# Or per-project
git clone https://github.com/your-org/superspecs.git .superspecs
bash .superspecs/setup.sh
```

Then open your agent and say: **"Tell me about your superspecs"**

### First feature

```
/discuss  What are we building and why?
/spec     Write the spec
/pick-spec  Confirm it fits a clean context
/branch   Create worktree
/subagent Start execution
/tdd      Enforce RED-GREEN-REFACTOR
/code-review  Check between tasks
/check-tests  Verify everything passes
/wiki     Distill to knowledge base
/ship     PR + archive
```

---

## Project Structure

```
your-project/
├── superspec/
│   ├── specs/                      # Feature specifications
│   │   └── <slug>/
│   │       ├── DISCUSS.md          # Pre-planning decisions
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
│   └── wiki/                       # Living knowledge base
│       ├── _index.md
│       ├── _manifest.json
│       └── <domain>/
│           └── <topic>.md
│
├── .skills/                        # SuperSpecs skills (source of truth)
│   ├── plan-discuss/SKILL.md
│   ├── plan-spec/SKILL.md
│   ├── execute-pick-spec/SKILL.md
│   ├── execute-branch/SKILL.md
│   ├── execute-subagent/SKILL.md
│   ├── execute-tdd/SKILL.md
│   ├── execute-review/SKILL.md
│   ├── verify-tests/SKILL.md
│   ├── verify-wiki/SKILL.md
│   └── ship/SKILL.md
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

| Phase   | Skill               | Command        | What it does                       |
| ------- | ------------------- | -------------- | ---------------------------------- |
| Plan    | `plan-discuss`      | `/discuss`     | Capture decisions before planning  |
| Plan    | `plan-spec`         | `/spec`        | Write OpenSpec-style spec          |
| Execute | `execute-pick-spec` | `/pick-spec`   | Choose + validate next spec        |
| Execute | `execute-branch`    | `/branch`      | Create branch / worktree           |
| Execute | `execute-subagent`  | `/subagent`    | Parallel subagent task execution   |
| Execute | `execute-tdd`       | `/tdd`         | RED-GREEN-REFACTOR enforcement     |
| Execute | `execute-review`    | `/code-review` | Between-task spec + quality review |
| Verify  | `verify-tests`      | `/check-tests` | Full suite + scenario coverage     |
| Verify  | `verify-wiki`       | `/wiki`        | Distill feature to wiki            |
| Ship    | `ship`              | `/ship`        | PR + archive + next cycle          |

---

## Design Principles

**Plan fits a fresh context window.** No executor should need prior chat history to understand their task. If the plan is too big, it gets decomposed.

**Tests first, always.** Code written before tests gets deleted. No exceptions. RED before GREEN.

**Critical issues block progress.** A `/code-review` finding rated Critical is not a suggestion. Nothing moves forward until it's resolved.

**Knowledge outlives the session.** After every shipped feature, the wiki gains a page. Future planning sessions start informed.

**One branch per spec.** Isolation prevents interference between parallel workstreams.

---

## License

MIT
