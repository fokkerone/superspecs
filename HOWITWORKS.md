# How SuperSpecs Works

An explanation of the mechanics behind the framework — how skills are discovered, how agents load instructions, and how the four-phase lifecycle runs.

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
name: TDD Execution
description: Enforce RED → GREEN → REFACTOR with no exceptions
slash_command: /tdd
phase: "2.4"
---
```

The rest of the file is a detailed, imperative instruction set written for the agent to follow when that slash command is invoked.

---

## Skill Discovery — How Agents Find Skills

Each AI coding tool has a designated directory it scans for skills at startup. `setup.sh` symlinks every `SKILL.md` into each of those directories:

```
~/.claude/skills/execute-tdd.md   → .skills/execute-tdd/SKILL.md
~/.agents/skills/execute-tdd.md   → .skills/execute-tdd/SKILL.md
~/.codex/skills/execute-tdd.md    → .skills/execute-tdd/SKILL.md
# ... same for every agent
```

When an agent starts, it reads its skills directory and registers each file as an available skill. The agent now knows about `/tdd`, `/spec`, `/ship`, and all the others — before any user message is sent.

```
Agent startup
     │
     ▼
Read ~/.claude/skills/*.md
     │
     ▼
Register skill: /discuss, /spec, /pick-spec, /branch,
                /subagent, /tdd, /code-review,
                /check-tests, /wiki, /ship
     │
     ▼
Agent is ready — all commands available
```

---

## Bootstrap Files

Beyond skills, each agent also gets a **bootstrap file** that is loaded at the start of every session. These prime the agent with the lifecycle summary so it behaves correctly even before a slash command is issued.

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

### Phase 1 — Plan

**Goal:** Produce a spec that fits a fresh 200k-token context window.

```
/discuss  →  DISCUSS.md   (decisions, constraints, non-goals)
/spec     →  spec.md      (SHALL requirements + GIVEN/WHEN/THEN scenarios)
              tasks.md    (implementation task list)
              status.md   (phase tracker)
```

The 200k window constraint is deliberate: any executor (subagent, fresh session, different agent) must be able to pick up the spec and work from it without needing prior chat history. If a spec is too large to fit, it is decomposed into smaller specs.

### Phase 2 — Execute

**Goal:** Implement the spec in parallel using isolated subagents, with TDD enforced at every step.

```
/pick-spec  →  Validates spec completeness; creates phases/<slug>-execute/plan.md
/branch     →  git branch or worktree; one branch per spec
/subagent   →  Fresh subagent per task; wave-based dispatch; human checkpoints
/tdd        →  RED (failing test) → GREEN (minimal code) → REFACTOR → commit
/code-review →  Spec compliance then code quality; Critical findings block progress
```

Each subagent receives: the spec, its task, and nothing else. No shared state. No reliance on context from other agents. This is what makes parallel execution safe.

### Phase 3 — Verify

**Goal:** Confirm the implementation matches the spec and the knowledge is preserved.

```
/check-tests  →  Full suite run; every spec scenario covered by a test; no skips
/wiki         →  Distill to superspec/wiki/<domain>/<topic>.md
```

The wiki is a living knowledge base — architecture decisions, patterns, trade-offs, gotchas. It survives after the session ends and informs future planning.

### Phase 4 — Ship

**Goal:** Merge and close the loop.

```
/ship  →  PR creation; changelog entry; phase directory archived; spec marked complete
```

After `/ship`, the cycle resets: `/pick-spec` for the next item.

---

## The `superspec/` Directory

All runtime artifacts live under `superspec/`:

```
superspec/
├── specs/
│   └── <slug>/
│       ├── DISCUSS.md      ← pre-planning decisions
│       ├── spec.md         ← SHALL requirements + scenarios
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
| No implementation code before a failing test | `/tdd` deletes code written before tests |
| Critical code-review findings block all progress | `/code-review` reports severity; Critical = hard stop |
| Spec must fit a fresh 200k-token context window | `/spec` and `/pick-spec` both check this |
| Every shipped feature → wiki page | `/ship` requires `/wiki` to have run first |

---

## The CLI

`bin/superspecs.js` is a thin Node.js wrapper with a single command:

```bash
superspecs install   # runs setup.sh
```

It exists so the framework can be distributed and installed via npm. All real logic is in `setup.sh` and the `.skills/` Markdown files.

---

## Creating a New Skill

The `skill-creator` meta-skill documents the process. In short:

1. Create `.skills/<name>/SKILL.md` with YAML frontmatter (`name`, `description`, `slash_command`, `phase`)
2. Write the step-by-step instructions in the body
3. Run `bash setup.sh` to symlink the new skill into all agent directories
4. Open your agent and invoke the new slash command to test it
