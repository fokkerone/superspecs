# SuperSpecs — Agent Bootstrap

SuperSpecs: spec-driven planning + parallel TDD execution + wiki memory.

## Commands

**Claude Code / Cursor:** `/superspecs:<cmd>`
**OpenCode:** `/superspecs-<cmd>`

## Lifecycle (always in order)

**Phase 0 — Setup**
- `/superspecs:techstack` — questionnaire: define stack, get skill & library recommendations, save to wiki

**Phase 1 — Plan**
- `/superspecs:discuss` — capture decisions before planning
- `/superspecs:spec` — write spec (fits 200k context window)
- `/superspecs:grill` — stress-test spec against wiki + techstack before execution

**Phase 2 — Execute**
- `/superspecs:pick-spec` — validate spec, check context fit
- `/superspecs:branch` — create branch/worktree
- `/superspecs:subagent` — fresh subagent per task, two-stage review
- `/superspecs:tdd` — RED-GREEN-REFACTOR, no exceptions
- `/superspecs:code-review` — critical issues block progress

**Phase 3 — Verify**
- `/superspecs:check-tests` — full suite, every scenario covered
- `/superspecs:wiki` — distill to knowledge base

**Phase 4 — Ship**
- `/superspecs:ship` — PR, archive, next cycle

## Rules
- No implementation code before a failing test
- Critical review findings block all progress
- Spec must fit a fresh 200k context window
- Spec must pass grill before execution
- Every shipped feature → wiki page

## Paths
- `superspec/specs/` — specs + DISCUSS.md files
- `superspec/phases/` — execution working dirs
- `superspec/wiki/` — knowledge base
- `.skills/` — skill definitions
