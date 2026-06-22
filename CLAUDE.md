# SuperSpecs — Claude Code

You have SuperSpecs installed. Four phases, always in order.

## The Lifecycle

```
PLAN → EXECUTE → VERIFY → SHIP
```

### Phase 1: Plan
1. `/discuss` — Capture decisions, goals, non-goals, constraints BEFORE any spec is written
2. `/spec` — Write the spec (SHALL requirements + GIVEN/WHEN/THEN scenarios) — requires DISCUSS.md
3. `/grill` — Stress-test the spec. **Mandatory gate.** READY verdict required before execution. — requires spec.md

**Exit gate:** Spec grilled to READY. Too big = decompose and re-grill.

### Phase 2: Execute
3. `/pick-spec` — Confirm spec is complete and context-window-fit
4. `/branch` — Create git branch or worktree (one per spec)
5. `/subagent` — Dispatch fresh subagent per task; two-stage review per task
6. `/tdd` — RED → GREEN → REFACTOR. Write failing test. Watch it fail. Write minimal code. Watch it pass. Commit. Delete any code written before tests.
7. `/code-review` — Runs between tasks. Critical issues BLOCK progress.

### Phase 3: Verify
8. `/verify` — Full suite + scenario coverage (Stage 1), then distill to knowledge base (Stage 2). Gate: tests must pass before wiki import runs.

### Phase 4: Ship
10. `/ship` — PR + changelog + archive + start next cycle.

## Hard Rules

- Never write implementation code before a failing test exists
- Never proceed past a Critical code review finding
- Never skip `/discuss` — decisions captured late are decisions lost
- Never skip `/grill` — a spec that hasn't been grilled to READY blocks `/pick-spec`
- Never declare done without `/verify` passing
- Every shipped feature gets a wiki page

## Paths

- `superspec/specs/` — Specs and discussion docs
- `superspec/phases/` — Active execution working dirs
- `superspec/wiki/` — Living knowledge base
- `.skills/` — Skill definitions
