---
name: execute-review
description: Review implementation against the spec between tasks. Two passes: spec compliance, then code quality. Critical findings BLOCK progress. Triggers on /code-review, between tasks, or when requested. Runs after each task in /subagent.
slash_command: code-review
phase: "2.5 — Execute › Code Review"
---

# Skill: execute-review

You are reviewing implementation against the spec and for code quality.

**This runs between tasks.** Not at the end — between each task, while changes are still small and fixable.

**Critical findings block progress.** No task starts after a Critical finding until it's resolved.

## Severity Levels

| Level | Meaning | Action |
|---|---|---|
| **Critical** | Spec violation, security issue, data loss risk, test circumvented | **BLOCK. Stop all execution. Must be fixed before next task.** |
| **High** | Logic error, wrong behavior, missing error handling | Must be resolved before wave ends |
| **Medium** | Code quality issue, missed edge case, unclear abstraction | Should be resolved; note in review-log |
| **Low** | Style, naming, minor improvement | Note in review-log; optional to fix |

## Two-Pass Review

### Pass 1: Spec Compliance

Read `superspec/specs/<slug>/spec.md`. For every requirement in scope of the completed task:

```markdown
## Pass 1: Spec Compliance

### ✅ Requirement: <Name>
Scenario: <Name>
Coverage: `<test-file>:<line>` — `<test name>`
Verified: behavior matches spec ✅

### ⚠️ Requirement: <Name>
Scenario: <Name>
Coverage: MISSING
Severity: Critical
Issue: This scenario has no test. The behavior is not verified.

### ❌ Requirement: <Name>
Scenario: <Name>
Coverage: `<test-file>:<line>`
Verified: FAILS — the implementation does X but spec says Y
Severity: Critical
```

**If any Critical findings in Pass 1:** stop immediately. Report. Do not run Pass 2.

### Pass 2: Code Quality

Only run if Pass 1 is fully ✅ (or only Medium/Low findings).

Review dimensions:

**Logic correctness**
- Are there cases where the code does the wrong thing?
- Are error paths handled?
- Are assumptions safe?

**Test quality**
- Do tests test behavior (not implementation)?
- Are edge cases covered?
- Are tests readable as documentation?

**Structure**
- DRY: is there duplication that should be extracted?
- YAGNI: is there code that serves no current requirement?
- Clarity: can this be read and understood without mental overhead?

**Consistency**
- Does this match patterns in the rest of the codebase?
- Does naming follow existing conventions?

```markdown
## Pass 2: Code Quality

### Strengths
- <What's done well>

### Findings

#### [Critical] <Title>
File: `<path>:<line>`
Issue: <precise description>
Why it matters: <impact>
Fix: <concrete suggestion>

#### [High] <Title>
File: `<path>:<line>`
Issue: <description>
Fix: <suggestion>

#### [Medium] <Title>
...

#### [Low] <Title>
...
```

## After Review

### Append to review-log.md

Append to `superspec/phases/<slug>-execute/review-log.md`:

```markdown
## Review: Task <id> — <timestamp>

### Pass 1: Spec Compliance
Result: ✅ PASS / ❌ FAIL (N critical)

### Pass 2: Code Quality
Result: ✅ PASS / ⚠️ FINDINGS

### Findings Summary
| Severity | Count | Status |
|----------|-------|--------|
| Critical | 0 | — |
| High     | 1 | resolved |
| Medium   | 2 | noted |
| Low      | 1 | noted |

### Resolution
<Critical findings resolved by: <description of fix>>
```

### Decision

```
Code Review: Task <id>

Pass 1 (Spec): ✅ / ❌
Pass 2 (Quality): ✅ / ⚠️ / ❌

Critical findings: <N>

→ APPROVED — proceed to next task
→ BLOCKED — fix Critical findings before continuing
```

## Blocked State

When blocked:

```
⛔ BLOCKED: Critical finding in Task <id>

Finding: <description>
File: <path>
Fix required: <what needs to change>

Execution paused. Resolve this before running the next task.
When fixed, run /code-review again to clear the block.
```

Nothing proceeds until the block is cleared by a clean re-review.
