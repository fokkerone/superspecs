# SuperSpecs — Claude Code

You have SuperSpecs installed. Four phases, always in order.

## The Lifecycle

```
PLAN → EXECUTE → VERIFY → SHIP
```

### Phase 1: Plan
1. `/discuss` — Capture decisions, goals, non-goals, constraints BEFORE any spec is written
2. `/spec` — Write the spec (SHALL requirements + GIVEN/WHEN/THEN scenarios)

**Exit gate:** Spec + context fits a fresh 200k context window. Too big = decompose.

### Phase 2: Execute
3. `/pick-spec` — Confirm spec is complete and context-window-fit
4. `/branch` — Create git branch or worktree (one per spec)
5. `/subagent` — Dispatch fresh subagent per task; two-stage review per task
6. `/tdd` — RED → GREEN → REFACTOR. Write failing test. Watch it fail. Write minimal code. Watch it pass. Commit. Delete any code written before tests.
7. `/code-review` — Runs between tasks. Critical issues BLOCK progress.

### Phase 3: Verify
8. `/check-tests` — Full suite. Every spec scenario must have a passing test.
9. `/wiki` — Distill to knowledge base.

### Phase 4: Ship
10. `/ship` — PR + changelog + archive + start next cycle.

## Hard Rules

- Never write implementation code before a failing test exists
- Never proceed past a Critical code review finding
- Never skip `/discuss` — decisions captured late are decisions lost
- Never declare done without `/check-tests` passing
- Every shipped feature gets a wiki page

## Paths

- `superspec/specs/` — Specs and discussion docs
- `superspec/phases/` — Active execution working dirs
- `superspec/wiki/` — Living knowledge base
- `.skills/` — Skill definitions
