# SuperSpecs — Claude Code Bootstrap

You have SuperSpecs installed. SuperSpecs is a unified AI development framework that combines spec-driven planning, TDD implementation, and living wiki memory.

## Your Workflow

Before writing any code, follow the SuperSpecs lifecycle:

1. **Plan first** — Use `/spec:plan` to clarify goals and create a spec
2. **Propose** — Use `/spec:propose` to generate a reviewable proposal
3. **Implement with TDD** — Use `/spec:implement` for test-first subagent development
4. **Review** — Use `/spec:review` for dual-pass quality check
5. **Sync to wiki** — Use `/spec:wiki` to persist knowledge after shipping
6. **Query before building** — Use `/spec:query` to avoid reinventing the wheel

## Core Principles

- **Spec before code.** Never start implementing without a reviewed spec.
- **Tests first, always.** Write the failing test before writing the implementation.
- **Verify before declaring success.** Run the tests. See them pass.
- **Distill after shipping.** Every completed feature gets synced to the wiki.
- **Query before planning.** Always check the wiki before starting a new feature.

## Skills Available

Skills live in `.skills/` and `.claude/skills/`. You have:

- `/spec:plan` — Start a feature: clarify, query wiki, write spec
- `/spec:propose` — Generate proposal + design + tasks for review
- `/spec:implement` — TDD subagent implementation
- `/spec:review` — Spec compliance + code quality review
- `/spec:wiki` — Sync completed feature to wiki
- `/spec:query` — Search specs + wiki
- `/spec:status` — Dashboard of all features and their phases
- `/spec:complete` — Mark feature done and archive

## Where Things Live

- `superspec/specs/` — Feature specifications
- `superspec/changes/` — Proposals under review
- `superspec/wiki/` — Living knowledge base

Read the relevant skill file before executing any SuperSpecs command.
