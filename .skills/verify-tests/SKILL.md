---
name: verify-tests
description: Full test suite run. Every spec scenario must have a passing test. No skipped tests. No pending tests. Invoked as Stage 1 of /superspecs:verify. Can also be triggered standalone on /check-tests, "run tests". Runs after all execution waves are complete.
slash_command: check-tests
phase: "3 — Verify › Stage 1 Check Tests"
---

# Skill: verify-tests

You are doing the final test verification before the feature can be declared done.

Execution is complete. Now you verify *everything* works before moving to wiki and ship.

## Steps

### 1. Run the full test suite

```bash
<test-runner>
```

Expected output: all tests passing, zero failing, zero skipped.

Report the result:

```
Test suite: <date>

Total:   <N>
Passing: <N>  ✅
Failing: <N>  ❌
Skipped: <N>  ⚠️
Pending: <N>  ⚠️
```

If anything is failing, skipped, or pending: stop. Report. Do not proceed.

### 2. Verify spec scenario coverage

Read `superspec/specs/<slug>/spec.md`. For every scenario:

Search the test files for a test covering that scenario. Use the GIVEN/WHEN/THEN as search anchors.

```markdown
## Spec Coverage Report

### Requirement: <Name>

#### Scenario: <Name>
Status: ✅ covered
Test: `<test-file>:<line>` — `<test name>`

#### Scenario: <Edge case name>
Status: ❌ NOT COVERED
Action required: Write a test for this scenario

[...]

## Summary
Scenarios total: <N>
Covered: <N>  ✅
Missing: <N>  ❌
```

**If any scenario is uncovered:** this is a Critical gap. Write the missing test before proceeding.

### 3. Run tests with coverage (if available)

If the project has a coverage tool:

```bash
<coverage-tool> <test-runner>
```

Note:
- Overall coverage %
- Coverage of files touched by this feature
- Any significant uncovered branches

Coverage is informational — it informs judgment, but 100% coverage is not required. Scenario coverage (step 2) is required.

### 4. Check for regressions

Compare with baseline if available. Specifically check:
- Areas of the codebase adjacent to what was changed
- Integration points (APIs called, events emitted, etc.)

If any tests that were passing before this spec's execution are now failing: that's a regression. It must be fixed before shipping.

### 5. Update status.md

If all checks pass:

```markdown
## Phase
3.1 — Verify › Check Tests ✅

## Test Results
- Suite: X passing, 0 failing, 0 skipped
- Spec scenarios: Y/Y covered
- Regressions: none

## Checklist
...
- [x] All tests passing
- [x] Code review passed (no Critical findings)
- [ ] Wiki imported
...
```

### 6. Handoff

```
Tests verified: <slug>

Suite: <N> passing ✅
Scenarios: <N>/<N> covered ✅
Regressions: none ✅

Next: /superspecs-wiki <slug>
```

## Fail states

**Tests failing:**
```
❌ Test failures found: N

Failing tests:
- <test name> (<file>:<line>)
  Error: <message>

Execution is NOT done. Fix failures before proceeding.
```

**Skipped or pending tests:**
```
⚠️ Skipped tests found: N

Skipped tests are not passing tests. Options:
1. Fix and unskip
2. Delete if no longer relevant

Do not ship with skipped tests that cover spec scenarios.
```

**Missing scenario coverage:**
```
❌ Uncovered spec scenarios: N

- Scenario: <name> (Requirement: <name>)
  No test found. Write one before shipping.
```
