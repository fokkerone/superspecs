---
name: execute-tdd
description: Enforce RED-GREEN-REFACTOR for every implementation task. This cycle runs inside each subagent task — not as a separate sequential step. Triggers on /tdd, when a task starts, or when code is being written without a failing test. Also used standalone when implementing outside of subagent mode.
slash_command: tdd
phase: "2.3 — Execute › per task (TDD)"
---

# Skill: execute-tdd

You are enforcing test-driven development. **This skill runs inside every subagent task** — it is not a separate phase that happens after subagent development. Every implementation task, in every wave, follows this cycle.

If you are implementing code outside of subagent mode (e.g., a quick fix or a standalone task), this skill applies exactly the same way.

## The Law

```
RED → GREEN → REFACTOR
```

This is not a suggestion. It is the only permitted order of operations.

Code written before a failing test exists gets **deleted**.

## Steps

### RED Phase

#### 1. Read the task's test requirement

Every task in `tasks.md` has a `Test requirement:` field. Read it before touching any implementation file.

#### 2. Write the test

Write a test that:
- Tests the **behavior** described in the task (not implementation details)
- Is specific enough to fail for the right reason
- Uses the same test framework as the rest of the project (detect from existing test files)

The test should read like documentation: *given this setup, when I do this, I expect this outcome.*

#### 3. Run the test — confirm RED

```bash
# Run ONLY the new test (not the full suite)
<test-runner> <test-file> -t "<test-name>"
```

**Expected: FAIL**

Check the failure reason:
- ✅ Right reason: the feature doesn't exist yet → proceed
- ❌ Wrong reason: import error, syntax error, test setup problem → fix the test, not the implementation
- ❌ Passes immediately: the test is wrong — it's not testing anything new → rewrite it

Do not proceed to GREEN until the test fails for the right reason.

### GREEN Phase

#### 4. Write the minimum implementation

Write the smallest amount of code that makes the test pass. That's it.

Rules:
- No code that isn't needed for this test
- No "I'll need this later" additions (YAGNI)
- No refactoring yet (that's REFACTOR phase)
- No changing the test to make it pass easier

#### 5. Run the test — confirm GREEN

```bash
<test-runner> <test-file> -t "<test-name>"
```

**Expected: PASS**

If it fails, fix the implementation. Do not touch the test.

#### 6. Run the full suite — confirm no regressions

```bash
<test-runner>
```

**Expected: all previously-passing tests still pass**

If regressions exist: fix them before proceeding. A new feature that breaks existing behavior is not done.

### REFACTOR Phase

#### 7. Improve without changing behavior

Look for:
- Duplication (same logic in 2+ places) → extract
- Unclear naming → rename
- Unnecessary complexity → simplify
- Inconsistency with project patterns → align

Rules:
- Tests stay green throughout
- No new functionality
- No changes that aren't improvements

Run the full suite after each refactor step.

#### 8. Commit

```bash
git add <changed files>
git commit -m "task <task-id>: <description>

- test: <what the test verifies>
- impl: <what was implemented>
"
```

## Violations

### Code before test

If implementation code was written before the test:

```
⚠️ Code found without test coverage.

Files affected: <list>
Action required: Delete implementation, write test first.

The RED-GREEN-REFACTOR cycle must start from RED.
```

Delete the untested code. Start from RED.

### Skipped tests

If a test is skipped (`xit`, `skip`, `@pytest.mark.skip`, etc.):

```
⚠️ Skipped test found: <test name>

Skipped tests do not count. Either:
1. Remove the skip and make it pass
2. Delete the test if it's no longer relevant
```

### Pending tests (test written, no implementation)

This is acceptable as a planning step, but a task is not DONE until the test passes green.

## Progress Report Format

After each completed task:

```
✅ Task <id> — RED-GREEN-REFACTOR complete

RED:   <test name> — failed (reason: <right reason>)
GREEN: <test name> — passing
SUITE: X tests passing, 0 failing, 0 skipped

Commit: <short SHA> — "task <id>: <description>"
```

## What NOT to do

- Do not write `// TODO: add test later`
- Do not mock away the behavior being tested
- Do not test implementation details (private methods, internal state)
- Do not mark a task done while any test is red or skipped
- Do not proceed to the next task before committing the current one
