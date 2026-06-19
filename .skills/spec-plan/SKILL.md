---
name: spec-plan
description: Start a new feature by clarifying goals, querying the project wiki, and writing a spec. Use when the user says "plan", "I want to build", "new feature", "add X", or triggers /spec:plan.
slash_command: spec:plan
---

# Skill: spec-plan

You are starting the SuperSpecs planning phase for a new feature.

## Your job

Turn a rough idea into a clear, committed spec before any code is written.

## Steps

### 1. Query the wiki first

Before anything else, check `superspec/wiki/` for relevant past knowledge.

```
- List pages in superspec/wiki/ that relate to this feature domain
- Read any relevant pages
- Note: existing patterns, past decisions, known gotchas
```

If the wiki is empty or has nothing relevant, proceed without it.

### 2. Clarify goals (if needed)

If the feature description is vague, ask ONE clarifying question at a time:

- What problem does this solve for the user?
- What is explicitly out of scope?
- What are the acceptance criteria?

Do not ask more than 3 questions total. If you have enough, proceed.

### 3. Determine the feature slug

Convert the feature name to a kebab-case slug, e.g. `user-auth-jwt`, `payment-stripe`, `export-csv`.

### 4. Check for existing spec

Look for `superspec/specs/<slug>/spec.md`. If it exists, say so and ask whether to update or create a new version.

### 5. Write the spec

Create `superspec/specs/<slug>/spec.md` with this structure:

```markdown
# <Feature Name> Specification

## Purpose
One paragraph: what this feature does and why it exists.

## Requirements

### Requirement: <Requirement Name>
The system SHALL <behavior>.

#### Scenario: <Scenario Name>
- GIVEN <precondition>
- WHEN <action>
- THEN <outcome>
- AND <additional outcome> (if needed)

[Repeat for each requirement]

## Out of Scope
- List of explicitly excluded behaviors

## Dependencies
- Other specs or systems this feature depends on

## Open Questions
- [ ] Any unresolved decisions
```

### 6. Create status file

Create `superspec/specs/<slug>/status.md`:

```markdown
# <Feature Name> — Status

## Phase
planning

## Checklist
- [x] Spec written
- [ ] Proposal generated
- [ ] Proposal reviewed
- [ ] Implementation started
- [ ] Tests passing
- [ ] Review passed
- [ ] Wiki synced
- [ ] Complete

## Wiki References
(populated after wiki sync)

## Change History
- <date>: Spec created
```

### 7. Confirm with user

Show the spec. Ask: *"Does this capture what you're building? Say 'yes' to proceed to proposal, or tell me what to change."*

Do not proceed to `/spec:propose` automatically. Wait for confirmation.

## Output

- `superspec/specs/<slug>/spec.md` — Created
- `superspec/specs/<slug>/status.md` — Created
- Summary of wiki references found (if any)
- Prompt to review and proceed
