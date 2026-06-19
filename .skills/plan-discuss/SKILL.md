---
name: plan-discuss
description: Capture implementation decisions BEFORE any spec is written. Triggers on /discuss, "what are we building", "let's plan", "I want to build X", "new feature". Always runs before /spec.
slash_command: discuss
phase: "1.1 — Plan › Discuss"
---

# Skill: plan-discuss

You are opening the discussion phase. This happens **before any spec is written**.

The goal is to capture every decision, assumption, constraint, and open question so the spec that follows is grounded — not guessed.

## Why this step exists

Decisions made during planning are cheap. Decisions discovered during implementation are expensive. This step makes the cheap ones explicit before they become expensive ones.

## Steps

### 1. Orient with the wiki

Before asking anything, check `superspec/wiki/`:
- Read `_index.md`
- Scan domain folders relevant to what's being described
- Note: existing patterns, past decisions, anything that should inform this discussion

Report what you found (or "wiki is empty / nothing relevant").

### 2. Understand the rough idea

Ask the user to describe what they want to build. Keep it conversational. One question at a time. Cover:

**What**
- What does this feature do from the user's perspective?
- What problem does it solve?

**Why now**
- What's the trigger for building this?
- What happens if we don't build it?

**Constraints**
- Technical constraints (existing stack, performance requirements, etc.)
- Scope constraints (what's explicitly NOT included?)
- Time or complexity constraints?

**Success**
- How do we know this is done?
- What does "working" look like?

**Risks**
- What could go wrong?
- What are we uncertain about?

Do not ask all questions at once. Read the answers and ask follow-ups. Stop when you have enough to write the discussion doc.

### 3. Write DISCUSS.md

Create `superspec/specs/<slug>/DISCUSS.md`:

```markdown
# Discussion: <Feature Name>

Date: <today>
Participants: human + AI

## What We're Building

<1-2 paragraph summary in plain language>

## Goals
- <Goal>
- <Goal>

## Non-Goals (explicitly out of scope)
- <Non-goal>
- <Non-goal>

## Constraints
- **Technical:** <constraint>
- **Scope:** <constraint>
- **Other:** <constraint>

## Key Decisions Made

### Decision: <Topic>
**We will:** <chosen approach>
**Because:** <reason>
**We won't:** <rejected alternative>

[Repeat for each significant decision]

## Open Questions
- [ ] <Question that needs resolution before or during implementation>

## Success Criteria
- [ ] <Measurable outcome>
- [ ] <Measurable outcome>

## Risks
- **<Risk>:** <Mitigation or acceptance>

## Wiki References
<Links to relevant existing wiki pages, or "None">
```

### 4. Create the spec directory and status file

Create `superspec/specs/<slug>/status.md`:

```markdown
# <Feature Name> — Status

## Phase
1.1 — Plan › Discuss ✅

## Checklist
- [x] Discussion complete (DISCUSS.md)
- [ ] Spec written
- [ ] Spec fits context window
- [ ] Branch created
- [ ] Subagent execution complete
- [ ] All tests passing
- [ ] Code review passed (no Critical findings)
- [ ] Wiki imported
- [ ] PR created
- [ ] Archived

## Slug
<slug>

## Started
<date>
```

### 5. Confirm and hand off

Show the DISCUSS.md. Say:

> "Discussion captured. Ready to write the spec? → `/spec <slug>`"

Do not write the spec automatically. The user confirms first.

## Output

- `superspec/specs/<slug>/DISCUSS.md`
- `superspec/specs/<slug>/status.md`
- A clear handoff prompt to `/spec`
