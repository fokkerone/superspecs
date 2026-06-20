---
name: plan-spec
description: Write an OpenSpec-style spec from the discussion document. Triggers on /spec, "write the spec", "create spec". Requires DISCUSS.md to exist. The spec must fit a fresh 200k context window.
slash_command: spec
phase: "1.2 — Plan › Spec"
---

# Skill: plan-spec

You are writing the feature spec. This is the contract between planning and execution.

**Prerequisite:** `superspec/specs/<slug>/DISCUSS.md` must exist. If it doesn't, stop and say: *"Run `/discuss` first to capture decisions before writing the spec."*

## What a spec is

A spec is a precise description of system behavior — not implementation details. It answers: *what must the system do?* Not: *how does it do it?*

It uses SHALL for requirements. It uses GIVEN/WHEN/THEN for scenarios. Every requirement is testable.

## The 200k Context Window Constraint

The complete spec — plus the implementation context — must fit in a fresh 200k-token context window. This is not optional. It's what makes parallel execution possible: each executor starts clean.

**Target:** spec.md under ~3,000 words. If you find yourself writing more, the feature is too large. Decompose it.

## Steps

### 1. Read DISCUSS.md and design-context.md

Read `superspec/specs/<slug>/DISCUSS.md`. Do not proceed without understanding it fully.

Then check for `superspec/specs/<slug>/design-context.md`. If it exists, read it completely before writing the spec. It carries design constraints from a DesignOS export — treat them as fixed inputs, not decisions to re-make:

- **Design system constraints** → add to Non-Functional Requirements + Out of Scope
- **Data contract types** → add an Interface/Contract section or enrich Requirements
- **Milestone structure** → use as the wave structure in `tasks.md`
- **Test scaffolding** → use as starting points for GIVEN/WHEN/THEN scenarios (adapt, don't copy verbatim)
- **Open questions** → check if they were answered in `DISCUSS.md`; if not, surface them in the spec's Out of Scope or flag them

DISCUSS.md carries the human decisions. design-context.md carries the design constraints. The spec merges both.

### 2. Query the wiki for relevant patterns

Perform a tiered wiki scan for patterns, interfaces, and decisions relevant to this feature:

**Tier 1 — Index scan:**
- Read `superspec/wiki/Home.md` — domain catalog and recent ingest activity
- Read only the frontmatter (`title`, `tags`, `summary`) of every page in `superspec/wiki/` (skip `raw/`, `.obsidian/`)
- Score for relevance to this feature's domain

**Tier 2 — Deep read:**
- Open the 3–5 most relevant pages in full
- Note:
  - Existing patterns this spec should follow or extend
  - Established interfaces this feature must be consistent with
  - Past decisions that constrain what's being designed
  - Open questions from previous features this spec might resolve

Also scan `superspec/specs/` for related specs (any status).

**Report before writing.** If established wiki patterns conflict with what's described in DISCUSS.md, flag the conflict explicitly — do not silently apply one over the other.

### 3. Write spec.md

Create `superspec/specs/<slug>/spec.md`:

```markdown
# <Feature Name> Specification

**Slug:** <slug>
**Status:** draft
**Depends on:** <other spec slugs, or "none">

## Purpose

One paragraph: what this feature does and why it exists. Written from the user/system perspective, not the implementation perspective.

## Requirements

### Requirement: <Requirement Name>
The system SHALL <behavior>.

#### Scenario: <Scenario Name>
- GIVEN <precondition>
- WHEN <action or event>
- THEN <expected outcome>
- AND <additional outcome> (if needed)

#### Scenario: <Edge case>
- GIVEN <setup>
- WHEN <unusual input or condition>
- THEN <expected safe behavior>

[Each requirement gets at least one happy-path scenario and at least one edge/error scenario]

## Error Behavior

Explicit SHALL statements for error cases:
- The system SHALL return <error format> when <condition>
- The system SHALL NOT <prohibited behavior>

## Non-Functional Requirements (if applicable)
- Performance: The system SHALL <behavior> within <timeframe>
- The system SHALL handle <load> without <failure mode>

## Out of Scope
- <Explicit exclusion>
- <Explicit exclusion>

## Glossary (if terms need definition)
- **<Term>:** <Definition>
```

### 4. Write tasks.md

Decompose into concrete implementation tasks. Each task is small enough for one subagent with a fresh context.

Create `superspec/specs/<slug>/tasks.md`:

```markdown
# Implementation Tasks: <Feature Name>

## Context Window Budget
Estimated spec + task tokens: ~<N>k / 200k ✅

## Wave 1 — Foundation
Tasks that must complete before Wave 2 can start.

### Task 1.1: <Name>
**What:** <Precise description>
**Files to create/modify:** <list>
**Test requirement:** Write a test for <specific behavior> that fails before implementation
**Done when:** Test passes, no regressions

### Task 1.2: <Name>
**What:** <Precise description>
**Files to create/modify:** <list>
**Test requirement:** <behavior to test>
**Done when:** Test passes, no regressions

## Wave 2 — Core Logic
Tasks runnable in parallel once Wave 1 is complete.

### Task 2.1: <Name>
...

### Task 2.2: <Name>
...

## Wave 3 — Integration
Final integration tasks.

### Task 3.1: <Name>
...

## Done Criteria
The feature is DONE when:
- [ ] All tasks complete
- [ ] All tests passing (zero skipped, zero pending)
- [ ] Every scenario in spec.md has a corresponding passing test
- [ ] Code review passed with no Critical findings
- [ ] No regressions in unrelated tests
```

### 5. Context window check

Estimate the token count of spec.md + tasks.md combined.

- Under 50k tokens: ✅ Excellent
- 50k–100k tokens: ✅ Fine
- 100k–150k tokens: ⚠️ Consider trimming
- Over 150k tokens: ❌ Too large — decompose into sub-specs

Report: `Context estimate: ~Xk tokens / 200k window ✅`

If over 150k, stop and propose decomposition before proceeding.

### 6. Update status.md

```markdown
## Phase
1.2 — Plan › Spec ✅

## Checklist
- [x] Discussion complete (DISCUSS.md)
- [x] Spec written
- [x] Spec fits context window (~Xk / 200k)
- [ ] Spec grilled and stress-tested (GRILL.md)
- [ ] Branch created
...
```

### 7. Handoff

Show spec summary:

```
Spec ready: <slug>

Requirements: X
Scenarios: Y
Tasks: Z across W waves
Context estimate: ~Xk / 200k ✅

Next: /grill <slug>
```

Do not suggest `/pick-spec` directly. The spec must survive a grill session first.

## Output

- `superspec/specs/<slug>/spec.md`
- `superspec/specs/<slug>/tasks.md`
- Updated `superspec/specs/<slug>/status.md`

## What NOT to do

- Do not write implementation details in the spec (no code, no file paths, no library choices)
- Do not write spec.md without reading DISCUSS.md first
- Do not proceed if the spec exceeds the context window budget — decompose instead
- Do not invent requirements not discussed in DISCUSS.md
