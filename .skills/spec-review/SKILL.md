---
name: spec-review
description: Dual-pass review of a completed implementation: first spec compliance, then code quality. Use when triggered by /spec:review or after implementation is complete.
slash_command: spec:review
---

# Skill: spec-review

You are in the review phase of the SuperSpecs lifecycle.

Implementation is complete. Now you perform a two-pass review before signing off.

## Pass 1: Spec Compliance

### Read the spec

Read `superspec/specs/<slug>/spec.md` completely.

### Verify each scenario

For each scenario in the spec, verify:

1. There is a test covering this scenario
2. The test passes
3. The implementation actually produces the specified behavior

Document each:

```markdown
## Spec Compliance Review

### ✅ Requirement: <Name>
  - Scenario: <Name> → covered by `<test file>:<test name>`
  - Verified: behavior matches spec

### ⚠️ Requirement: <Name>
  - Scenario: <Name> → MISSING test coverage
  - Issue: <what's missing or wrong>

### ❌ Requirement: <Name>
  - Scenario: <Name> → FAILS
  - Issue: <what's broken>
```

If there are ⚠️ or ❌ items, stop. Report them. Do not proceed to Pass 2.

## Pass 2: Code Quality

Only run Pass 2 if Pass 1 is fully ✅.

### Review dimensions

**Clarity**
- Is the code readable without comments?
- Are names descriptive and accurate?
- Are abstractions at the right level?

**Structure**
- Is there unnecessary duplication? (DRY)
- Is there unnecessary complexity? (YAGNI)
- Are responsibilities cleanly separated?

**Tests**
- Are tests testing behavior, not implementation details?
- Are edge cases covered?
- Are tests readable as documentation?

**Consistency**
- Does the code follow existing project patterns?
- Are conventions consistent with the codebase?

### Output format

```markdown
## Code Quality Review

### Strengths
- <What's done well>

### Suggestions
- **<File/function>:** <Specific suggestion>
  Reason: <Why this matters>

### Required changes (blocking)
- <Only list things that are actual bugs or spec violations>

### Non-blocking notes
- <Style suggestions, future improvements>
```

## Final Sign-off

```markdown
## Review Result

Pass 1 (Spec Compliance): ✅ PASS / ❌ FAIL
Pass 2 (Code Quality): ✅ PASS / ⚠️ SUGGESTIONS / ❌ FAIL

Status: APPROVED / CHANGES REQUESTED

Next step: /spec:wiki <slug>
```

If approved, update `superspec/specs/<slug>/status.md` (phase → reviewed).
