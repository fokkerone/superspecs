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
│  /tdd  →  /code-review                              │
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

**Skills:** `/techstack`

---

## Phase 1 — Plan

Before any code exists, the plan must fit in a fresh 200k-token context window. This discipline ensures every executor starts clean — no partial history, no reconstructed intent.

### 1.1 Discuss (`/discuss`)

Capture implementation decisions _before_ anything is planned. Goals, constraints, open questions, explicit non-goals. One question at a time, conversational. The output is a `DISCUSS.md` — the foundation for the spec.

### 1.2 Spec (`/spec`)

Write an OpenSpec-style spec from the discussion. Requirements expressed as SHALL statements with GIVEN/WHEN/THEN scenarios. Lives in `superspec/specs/<slug>/spec.md`.

**Exit criterion:** spec + context fits a fresh 200k-token window. If it doesn't, decompose into smaller specs.

### 1.3 Grill (`/grill`)

A relentless interview to stress-test the spec before any code is written. The agent walks every branch of the decision tree — one question at a time, always providing a recommended answer.

The grill validates the spec against two sources of truth:

- **Wiki** — does the spec contradict established patterns, decisions, or interfaces already documented?
- **Techstack** — does the spec assume libraries, approaches, or patterns that conflict with the defined stack?

If the codebase can answer a question, the agent explores it instead of asking. The session ends with a verdict: **READY** (proceed to `/pick-spec`) or **NEEDS REVISION** (spec must be updated and re-grilled).

Output: `superspec/specs/<slug>/GRILL.md` + any required updates to `spec.md`.

**Exit criterion:** verdict is READY. A spec that hasn't been grilled does not proceed to execution.

**Skills:** `/discuss` → `/spec` → `/grill`

---

## Phase 2 — Execute

Parallel execution. Each subagent gets a clean context. No shared state between tasks. No "do you remember what we talked about earlier" — the spec and the wiki carry everything.

### 2.1 Pick Spec (`/pick-spec`)

Choose the next spec to execute. Check dependencies, verify the spec is complete, confirm it fits a fresh context window.

### 2.2 Branch (`/branch`)

Create a git branch or worktree for isolated execution. One branch per spec.

### 2.3 Subagent Development (`/subagent`)

Dispatches a fresh subagent per task. Each gets: the spec, the task, and nothing else. Two-stage review per task: spec compliance first, code quality second. Supports batch mode with human checkpoints between waves.

### 2.4 TDD (`/tdd`)

Enforces RED → GREEN → REFACTOR strictly:

1. Write a failing test — watch it fail for the right reason
2. Write minimal code — watch it pass
3. Commit
4. Code written before a failing test gets deleted

### 2.5 Code Review (`/code-review`)

Runs between tasks. Reviews against the spec. Reports issues by severity. **Critical issues block all progress** — nothing moves forward until resolved.

**Skills:** `/pick-spec` → `/branch` → `/subagent` → `/tdd` → `/code-review`

---

## Phase 3 — Verify

Walk through what was built. Diagnose and fix before declaring done. Then distill everything learned into the wiki — so the next session inherits the knowledge.

### 3.1 Check Tests (`/check-tests`)

Full test suite. Coverage check. Every spec scenario verified by a test. No passing with skipped or pending tests.

### 3.2 Wiki Import (`/wiki`)

Distill the implemented feature into the project wiki. Architecture decisions, patterns, trade-offs, gotchas. The wiki is the memory that outlives the session — it's what makes the next planning cycle start informed instead of blind. Structured, linked, searchable. Not chat history: a real knowledge base.

**Skills:** `/check-tests` → `/wiki`

---

## Phase 4 — Ship

### Ship (`/ship`)

Create the PR. Write a changelog entry. Archive the phase directory. Mark the spec complete. Trigger the next cycle.

**Skills:** `/ship`

---

## Quick Start

```bash
# Install
git clone git@github.com:fokkerone/superspecs.git
cd your-project
bash ~/.superspecs/setup.sh   # symlinks skills into all your agents

# Or per-project
git clone git@github.com:fokkerone/superspecs.git .superspecs
bash .superspecs/setup.sh
```

Then open your agent and say: **"Tell me about your superspecs"**

### First feature

```
/superspecs:techstack  Define stack, get skill & library recommendations
/superspecs:discuss    What are we building and why?
/superspecs:spec       Write the spec
/superspecs:grill      Stress-test spec against wiki + techstack
/superspecs:pick-spec  Confirm it fits a clean context
/superspecs:branch     Create worktree
/superspecs:subagent   Start execution
/superspecs:tdd        Enforce RED-GREEN-REFACTOR
/superspecs:code-review  Check between tasks
/superspecs:check-tests  Verify everything passes
/superspecs:wiki       Distill to knowledge base
/superspecs:ship       PR + archive
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
│   ├── techstack/SKILL.md
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

| Phase   | Skill               | Command        | What it does                                                                 |
| ------- | ------------------- | -------------- | ---------------------------------------------------------------------------- |
| Setup   | `techstack`         | `/techstack`   | Questionnaire: define stack, recommend skills & libraries, save wiki profile |
| Plan    | `plan-discuss`      | `/discuss`     | Capture decisions before planning                                            |
| Plan    | `plan-spec`         | `/spec`        | Write OpenSpec-style spec                                                    |
| Plan    | `plan-grill`        | `/grill`       | Stress-test spec against wiki + techstack, blocks execution until READY      |
| Execute | `execute-pick-spec` | `/pick-spec`   | Choose + validate next spec                                                  |
| Execute | `execute-branch`    | `/branch`      | Create branch / worktree                                                     |
| Execute | `execute-subagent`  | `/subagent`    | Parallel subagent task execution                                             |
| Execute | `execute-tdd`       | `/tdd`         | RED-GREEN-REFACTOR enforcement                                               |
| Execute | `execute-review`    | `/code-review` | Between-task spec + quality review                                           |
| Verify  | `verify-tests`      | `/check-tests` | Full suite + scenario coverage                                               |
| Verify  | `verify-wiki`       | `/wiki`        | Distill feature to wiki                                                      |
| Ship    | `ship`              | `/ship`        | PR + archive + next cycle                                                    |

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
