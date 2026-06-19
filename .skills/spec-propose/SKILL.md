---
name: spec-propose
description: Generate a reviewable proposal for a feature — including design decisions, implementation tasks, and spec deltas. Use when the user triggers /spec:propose or says "create proposal", "plan the implementation".
slash_command: spec:propose
---

# Skill: spec-propose

You are in the proposal phase of the SuperSpecs lifecycle.

The spec has been written and confirmed. Now you generate everything needed to review the implementation plan **before any code is written**.

## Inputs

- Feature slug: provided by user or infer from context
- `superspec/specs/<slug>/spec.md` — must exist

## Steps

### 1. Read the spec

Read `superspec/specs/<slug>/spec.md` completely.

### 2. Scan related code

Search the codebase for:
- Existing files or modules related to this feature's domain
- Patterns already used (auth, API structure, test setup, etc.)
- Anything the implementation will need to touch or extend

Note what you find. Do not modify anything yet.

### 3. Generate a change ID

Create a readable change ID: `<slug>-<brief-descriptor>`, e.g. `auth-jwt-add-refresh-tokens`.

### 4. Create the proposal directory

`superspec/changes/<change-id>/`

### 5. Write proposal.md

```markdown
# Proposal: <Feature Name>

## Change ID
<change-id>

## Summary
One paragraph: what this change does.

## Motivation
Why we're building this now. What user problem it solves.

## Spec Reference
`superspec/specs/<slug>/spec.md`

## Approach
High-level: what we're building and how. Not implementation detail — the strategic shape of the solution.

## Alternatives Considered
- **Option A (chosen):** <description> — chosen because <reason>
- **Option B:** <description> — rejected because <reason>

## Risks
- <Risk>: <Mitigation>

## Out of Scope
(copied from spec, confirmed here)
```

### 6. Write design.md

```markdown
# Technical Design: <Feature Name>

## Architecture

Describe the technical shape:
- New files / modules to create
- Existing files to modify
- Data model changes
- API surface changes (if any)
- External dependencies (if any)

## Key Decisions

### Decision: <Topic>
**Choice:** <What we chose>
**Reason:** <Why>
**Trade-off:** <What we're giving up>

[Repeat for each significant decision]

## Test Strategy

How we'll verify this works:
- Unit tests: what gets unit tested
- Integration tests: what gets integration tested
- Edge cases to cover explicitly
```

### 7. Write tasks.md

Break implementation into concrete tasks. Each task must be:
- Small enough for one focused implementation step
- Clear enough for an agent with no project context to follow
- Associated with at least one test

```markdown
# Implementation Tasks: <Feature Name>

## Phase 1: Foundation
- [ ] **Task 1.1:** <Specific task>
  - Test: <What test to write first>
  - Files: <Files to create/modify>
  
- [ ] **Task 1.2:** <Specific task>
  - Test: <What test to write first>
  - Files: <Files to create/modify>

## Phase 2: Core Logic
- [ ] **Task 2.1:** <Specific task>
  - Test: <What test to write first>
  - Files: <Files to create/modify>

## Phase 3: Integration & Polish
- [ ] **Task 3.1:** <Specific task>
  - Test: <What test to write first>

## Done Criteria
The feature is done when:
- [ ] All tasks checked off
- [ ] All tests passing
- [ ] No regressions in existing tests
- [ ] Spec reviewed against implementation
```

### 8. Write spec delta

Create `superspec/changes/<change-id>/specs/<slug>/spec.md` showing only the changes:

Use `+` for additions, `-` for removals (like a git diff in prose):

```markdown
# Spec Delta: <Feature Name>

## Changed Requirements

### Requirement: <Name>
- The system SHALL <old behavior>
+ The system SHALL <new behavior>

## New Requirements

### Requirement: <New Name>
+ The system SHALL <new behavior>
+
+ #### Scenario: <Name>
+ - GIVEN <precondition>
+ - WHEN <action>
+ - THEN <outcome>
```

### 9. Confirm with user

Show a summary:

```
Created change proposal: <change-id>

superspec/changes/<change-id>/
├── proposal.md     ← what we're building
├── design.md       ← technical decisions  
├── tasks.md        ← X tasks across Y phases
└── specs/          ← spec delta (Z requirements affected)

Ready to implement? Say '/spec:implement <change-id>' to begin TDD.
```

Wait for confirmation before proceeding.

## Output

- `superspec/changes/<change-id>/proposal.md`
- `superspec/changes/<change-id>/design.md`
- `superspec/changes/<change-id>/tasks.md`
- `superspec/changes/<change-id>/specs/<slug>/spec.md`
- Updated `superspec/specs/<slug>/status.md` (phase → proposed)
