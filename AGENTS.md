# SuperSpecs — Agent Bootstrap

SuperSpecs: spec-driven planning + parallel TDD execution + wiki memory.

## Lifecycle (always in order)

**Phase 1 — Plan**
- `/discuss` — capture decisions before planning
- `/spec` — write spec (fits 200k context window)

**Phase 2 — Execute**
- `/pick-spec` — validate spec, check context fit
- `/branch` — create branch/worktree
- `/subagent` — fresh subagent per task, two-stage review
- `/tdd` — RED-GREEN-REFACTOR, no exceptions
- `/code-review` — critical issues block progress

**Phase 3 — Verify**
- `/check-tests` — full suite, every scenario covered
- `/wiki` — distill to knowledge base

**Phase 4 — Ship**
- `/ship` — PR, archive, next cycle

## Rules
- No implementation code before a failing test
- Critical review findings block all progress
- Spec must fit a fresh 200k context window
- Every shipped feature → wiki page

## Paths
- `superspec/specs/` — specs + DISCUSS.md files
- `superspec/phases/` — execution working dirs
- `superspec/wiki/` — knowledge base
- `.skills/` — skill definitions
