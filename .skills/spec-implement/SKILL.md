---
name: spec-implement
description: Execute TDD implementation of a feature using subagent-driven development. Tests first, always. Use when the user triggers /spec:implement or says "implement", "build it", "start coding" after a proposal is reviewed.
slash_command: spec:implement
---

# Skill: spec-implement

You are in the implementation phase of the SuperSpecs lifecycle.

The proposal has been reviewed. Now you implement using strict TDD.

## Core Principles (non-negotiable)

1. **Write the failing test first.** Every task starts with a test. No exceptions.
2. **Make it pass with the minimum code.** YAGNI — You Aren't Gonna Need It.
3. **DRY — Don't Repeat Yourself.** If you see a pattern twice, extract it.
4. **Verify before moving on.** Run the tests. See green. Only then proceed.
5. **One task at a time.** Complete and verify each task before starting the next.

## Inputs

- Change ID: provided by user
- `superspec/changes/<change-id>/tasks.md` — implementation plan
- `superspec/changes/<change-id>/design.md` — technical decisions
- `superspec/specs/<slug>/spec.md` — the commitment

## Steps

### 1. Read the plan

Read `tasks.md`, `design.md`, and the spec completely. Do not start until you understand all three.

### 2. Confirm setup

Check:
- Test runner is configured and working
- Can run `npm test` / `pytest` / `go test` / equivalent
- Baseline: existing tests pass before you start

If baseline tests fail, stop and report. Do not start on a broken baseline.

### 3. Execute tasks in order

For each task in `tasks.md`:

#### Task loop

```
a. Read the task description and its test requirement
b. WRITE THE TEST — create a failing test that describes the behavior
c. Run the test — confirm it FAILS (red)
d. Write the minimum implementation to make it pass
e. Run the test — confirm it PASSES (green)
f. Refactor if needed — keep tests green
g. Run ALL tests — confirm no regressions
h. Mark task as done in tasks.md: [ ] → [x]
i. Proceed to next task
```

#### Red phase rules

- The test must fail for the RIGHT reason (not a syntax error or missing import)
- If the test passes immediately, the test is wrong — fix it

#### Green phase rules

- Write the simplest code that makes the test pass
- Do not add functionality not needed for this task

#### Refactor phase rules

- Tests must stay green throughout
- Improve clarity, remove duplication, improve naming
- Do not change behavior

### 4. Handle blockers

If you encounter an unexpected technical problem:

1. Stop the current task
2. Document the blocker clearly
3. Ask the user for guidance before proceeding
4. Do not work around blockers silently

### 5. Progress reporting

After each completed task, report briefly:
```
✅ Task 1.1: <name> — tests passing
⏳ Next: Task 1.2: <name>
```

### 6. Final verification

After all tasks are complete:

1. Run the complete test suite
2. Verify against each scenario in `spec.md` — do they all pass?
3. Report:

```
Implementation complete: <change-id>

Tasks: X/X completed
Tests: X passing, 0 failing
Spec coverage: all scenarios verified

Next: /spec:review <change-id>
```

## Output

- All implementation code, committed task by task
- `superspec/changes/<change-id>/tasks.md` updated (all checked)
- `superspec/specs/<slug>/status.md` updated (phase → implemented)

## What NOT to do

- Do not write code before writing the test
- Do not mark a task done until the test passes
- Do not skip the refactor step when duplication is obvious
- Do not proceed past a failing baseline
- Do not implement multiple tasks at once
