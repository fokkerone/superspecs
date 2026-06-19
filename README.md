# SuperSpecs 🚀

**A unified AI development framework that combines spec-driven planning, TDD implementation, and living wiki memory — in one coherent workflow.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Agent: Claude Code](https://img.shields.io/badge/agent-Claude%20Code-blue)](https://claude.ai/code)
[![Agent: Cursor](https://img.shields.io/badge/agent-Cursor-blue)](https://cursor.com)
[![Agent: OpenCode](https://img.shields.io/badge/agent-OpenCode-blue)](https://opencode.ai)
[![Agent: Copilot](https://img.shields.io/badge/agent-Copilot-blue)](https://github.com/features/copilot)

---

## The Problem

Every AI coding framework solves one thing in isolation:

| Tool          | What it solves               | What it ignores                   |
| ------------- | ---------------------------- | --------------------------------- |
| OpenSpec      | Spec-driven planning         | How to implement, how to remember |
| Superpowers   | TDD discipline during coding | Planning before, memory after     |
| obsidian-wiki | Living knowledge base        | The planning→coding lifecycle     |

**SuperSpecs combines all three into a single lifecycle.**

---

## The SuperSpecs Lifecycle

```
┌─────────────────────────────────────────────────────────────┐
│                    SUPERSPEC LIFECYCLE                       │
│                                                             │
│  1. PLAN          2. PROPOSE        3. IMPLEMENT            │
│  /spec:plan  ──▶  /spec:propose ──▶  /spec:implement        │
│                                          │                  │
│  Define feature    Review spec delta     TDD: red→green     │
│  in plain words    before any code       YAGNI + DRY        │
│                                          │                  │
│  4. SYNC          5. QUERY          6. REVIEW               │
│  /spec:wiki  ◀──  /spec:query  ◀──  /spec:review            │
│                                          │                  │
│  Write to wiki     Query past work       Subagent review    │
│  as living docs    before planning       & sign-off         │
└─────────────────────────────────────────────────────────────┘
```

### Phase 1 — Plan (`/spec:plan`)

Inspired by **OpenSpec**: Before touching code, the agent clarifies what you're actually trying to build. It asks about goals, constraints, and edge cases — then generates a `spec.md` in `superspec/specs/<feature>/`.

### Phase 2 — Propose (`/spec:propose`)

Inspired by **OpenSpec**: Creates a reviewable proposal: `proposal.md`, `design.md`, `tasks.md`, and a spec delta. You review the plan. Nothing is coded yet.

### Phase 3 — Implement (`/spec:implement`)

Inspired by **Superpowers**: Kicks off subagent-driven TDD development. Tests first, always. Red → Green → Refactor. YAGNI. DRY. Each task gets verified before the next starts.

### Phase 4 — Review (`/spec:review`)

Inspired by **Superpowers**: A second subagent reviews the implementation against the spec. Checks spec compliance, then code quality.

### Phase 5 — Wiki Sync (`/spec:wiki`)

Inspired by **obsidian-wiki**: After implementation, distills the feature into your project wiki. Architecture decisions, patterns, trade-offs — the stuff you'd forget in 3 months.

### Phase 6 — Query (`/spec:query`)

Inspired by **obsidian-wiki**: Before planning a new feature, query what you already know. Surfaces past decisions, similar implementations, and relevant patterns from your wiki.

---

## Quick Start

### Install (Claude Code)

```bash
npx superspecs install
```

Or manually:

```bash
git clone https://github.com/your-org/superspecs.git ~/.superspecs
bash ~/.superspecs/setup.sh
```

Verify: open your agent and say **"Tell me about your superspecs"**.

### Install (OpenCode)

Add to your `opencode.json`:

```json
{
  "plugin": ["superspecs@git+https://github.com/your-org/superspecs.git"]
}
```

### Install (Cursor)

Skills are auto-discovered from `.cursor/skills/`. Run `setup.sh` and restart Cursor.

### Install (GitHub Copilot)

```bash
bash ~/.superspecs/setup.sh
```

Skills symlink to `~/.copilot/skills/` automatically.

---

## Usage

### Start a new feature

```
/spec:plan Add user authentication with JWT tokens
```

The agent clarifies goals, reads the wiki for past auth patterns, and generates `superspec/specs/auth-jwt/spec.md`.

### Review and propose

```
/spec:propose auth-jwt
```

Generates proposal, design decisions, and implementation tasks. You review before any code is written.

### Implement with TDD

```
/spec:implement auth-jwt
```

Subagent-driven TDD. Tests first. Verified task by task.

### Sync to wiki after shipping

```
/spec:wiki auth-jwt
```

Distills the implementation into your project wiki. Links specs to wiki pages.

### Query before building

```
/spec:query what do we know about rate limiting?
```

Searches both specs and wiki before starting a new feature.

---

## Project Structure

```
your-project/
├── superspec/
│   ├── specs/                    # Living feature specifications
│   │   └── <feature>/
│   │       ├── spec.md           # The spec (what it should do)
│   │       └── status.md         # Current phase + checklist
│   │
│   ├── changes/                  # Proposals in review
│   │   └── <change-id>/
│   │       ├── proposal.md       # What we're building
│   │       ├── design.md         # Technical decisions
│   │       ├── tasks.md          # Implementation tasks
│   │       └── specs/            # Spec deltas
│   │
│   └── wiki/                     # Living knowledge base
│       ├── _index.md             # Wiki entry point
│       ├── _manifest.json        # Ingest tracking
│       └── <topic>/              # Auto-organized by domain
│           └── <page>.md
│
├── .skills/                      # SuperSpecs skill definitions
│   ├── spec-plan/SKILL.md
│   ├── spec-propose/SKILL.md
│   ├── spec-implement/SKILL.md
│   ├── spec-review/SKILL.md
│   ├── spec-wiki/SKILL.md
│   ├── spec-query/SKILL.md
│   ├── spec-status/SKILL.md
│   └── spec-complete/SKILL.md
│
├── CLAUDE.md                     # Bootstrap → Claude Code
├── AGENTS.md                     # Bootstrap → Codex, OpenCode, Aider
├── .cursor/rules/superspecs.mdc  # Always-on → Cursor
├── .windsurf/rules/superspecs.md # Always-on → Windsurf
├── setup.sh                      # One-command install
└── README.md                     # You are here
```

---

## Skill Reference

| Skill            | Command                     | What it does                           |
| ---------------- | --------------------------- | -------------------------------------- |
| `spec-plan`      | `/spec:plan <feature>`      | Clarify goals, query wiki, create spec |
| `spec-propose`   | `/spec:propose <feature>`   | Generate proposal + design + tasks     |
| `spec-implement` | `/spec:implement <feature>` | TDD subagent implementation            |
| `spec-review`    | `/spec:review <feature>`    | Dual-pass spec + code quality review   |
| `spec-wiki`      | `/spec:wiki <feature>`      | Sync completed feature to wiki         |
| `spec-query`     | `/spec:query <question>`    | Query specs + wiki together            |
| `spec-status`    | `/spec:status`              | Dashboard: all features + their phases |
| `spec-complete`  | `/spec:complete <feature>`  | Mark done, archive, update wiki        |
| `skill-creator`  | `/skill-creator`            | Create new SuperSpecs skills           |

---

## Philosophy

SuperSpecs borrows three hard-won principles:

**From OpenSpec:** _Specs live in your repo, not in your head._ A spec is not a prompt. It's a shared artifact you and your agent both commit to before a line of code is written.

**From Superpowers:** _Write tests first, always. Verify before declaring success._ An agent that skips tests is an agent making promises it can't keep.

**From obsidian-wiki / Karpathy's LLM Wiki pattern:** _Compile knowledge once, reuse forever._ Don't ask the same questions twice. After every feature ships, the knowledge stays — in structured, queryable markdown your next session can read.

---

## Agent Compatibility

| Agent              | Bootstrap                         | Skills Path          | Commands                            |
| ------------------ | --------------------------------- | -------------------- | ----------------------------------- |
| **Claude Code**    | `CLAUDE.md`                       | `.claude/skills/`    | `/spec:plan`, `/spec:propose`, etc. |
| **Cursor**         | `.cursor/rules/superspecs.mdc`    | `.cursor/skills/`    | `/spec:plan`, etc.                  |
| **Windsurf**       | `.windsurf/rules/superspecs.md`   | `.windsurf/skills/`  | via Cascade                         |
| **OpenCode**       | `AGENTS.md`                       | `~/.agents/skills/`  | `/spec:plan`, etc.                  |
| **Codex**          | `AGENTS.md`                       | `~/.codex/skills/`   | `$spec:plan`                        |
| **Gemini CLI**     | `GEMINI.md`                       | `~/.gemini/skills/`  | `/spec:plan`, etc.                  |
| **GitHub Copilot** | `.github/copilot-instructions.md` | `~/.copilot/skills/` | describe intent                     |

---

## License

MIT — build freely, ship confidently.
Fokker chartier
