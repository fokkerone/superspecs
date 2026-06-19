---
name: design-import
description: Import a DesignOS export as a SuperSpecs spec. Reads product-overview, incremental milestones, test instructions, data shapes, and design system. Generates DISCUSS.md + spec.md + tasks.md automatically. Replaces the manual /discuss + /spec flow when a DesignOS export is available. Triggers on /design-import, "import design", "import DesignOS", "import from design export".
slash_command: design-import
phase: "1.0 — Plan › Design Import"
---

# Skill: design-import

You are importing a DesignOS export into the SuperSpecs planning system.

A DesignOS export is a structured, ready-to-implement product package: product overview, incremental milestones, test instructions, TypeScript types, design system tokens, and component screenshots. This skill reads that package and produces the full Phase 1 output — `DISCUSS.md`, `spec.md`, `tasks.md` — ready for `/grill` and then execution.

This replaces the manual `/discuss` → `/spec` flow. The design export IS the discussion.

---

## Expected DesignOS Export Structure

```
<export-folder>/
├── product-plan/
│   ├── product-overview.md          ← product description, goals, non-goals
│   ├── one-shot-instructions.md     ← (optional) full one-shot implementation guide
│   └── incremental/
│       ├── 01-shell.md              ← milestone 1: design tokens + app shell
│       ├── 02-<section>.md          ← milestone 2: first content section
│       └── NN-<section>.md          ← milestone N: last section
│
├── prompts/
│   ├── one-shot-prompt.md           ← (optional) copy-paste prompt
│   └── section-prompt.md            ← (optional) per-section prompt template
│
├── design-system/
│   ├── tokens.css                   ← CSS custom properties
│   ├── tailwind.config.js           ← Tailwind configuration
│   └── fonts.md                     ← font setup instructions
│
├── data-shape/
│   ├── types.ts                     ← TypeScript interfaces
│   ├── sample-data.ts               ← sample data
│   └── entities.md                  ← entity documentation
│
├── components/
│   ├── shell/                       ← shell component files
│   └── <section>/
│       ├── <component>.tsx          ← React component
│       └── screenshots/             ← visual reference images
│
└── test-instructions/
    ├── tests.md                     ← overall test specification
    ├── user-flow-tests.md           ← (optional) end-to-end user flows
    └── <section>-tests.md           ← per-section test specs
```

---

## Steps

### 1. Locate the export

Ask the user for the path to the DesignOS export folder if not provided:
```
Path to DesignOS export folder?
(e.g. ./design-export/ or /Users/you/Downloads/my-app-designos/)
```

Verify the folder exists and contains at minimum `product-plan/product-overview.md`.

If the structure is partial (some files missing), proceed with what's available and note gaps.

---

### 2. Read all source material

Read in this order:

1. `product-plan/product-overview.md` — the product description
2. `product-plan/incremental/` — all milestone files, sorted numerically (01, 02, …)
3. `test-instructions/tests.md` — overall test spec
4. `test-instructions/<section>-tests.md` — per-section tests (if present)
5. `test-instructions/user-flow-tests.md` — user flow tests (if present)
6. `data-shape/types.ts` — TypeScript interfaces
7. `data-shape/entities.md` — entity docs
8. `design-system/tokens.css` — design token names (skim for naming convention)

Do NOT read component `.tsx` files or screenshots — they are preserved as reference, not as spec input.

---

### 3. Derive the slug

From `product-overview.md`, extract the product name and derive a slug:
- Lowercase, hyphenated
- Example: "Task Dashboard" → `task-dashboard`

Create `superspec/specs/<slug>/`.

---

### 4. Write DISCUSS.md

Auto-generate from the DesignOS content. This is the "virtual discussion" — the design export answered the questions before we asked them.

Create `superspec/specs/<slug>/DISCUSS.md`:

```markdown
# Discussion: <Product Name>

Date: <today>
Source: DesignOS export — <export-folder-name>
Note: This discussion was auto-generated from a DesignOS export. Review and amend if decisions need to be captured that aren't reflected here.

## What We're Building

<2-3 paragraph summary derived from product-overview.md>

## Goals

<Extracted from product-overview.md goals section>

## Non-Goals (explicitly out of scope)

<Extracted from product-overview.md non-goals / out-of-scope section>
- Styling decisions are handled by the design system tokens — not re-specified here
- Component layout is defined in the DesignOS export screenshots — not duplicated in spec

## Constraints

- **Design system:** Tokens from `design-system/tokens.css` + Tailwind config must be used as-is
- **Data shape:** TypeScript types from `data-shape/types.ts` define the data contract
- **Build order:** Incremental — shell first, then sections in milestone order
- **Stack:** <inferred from product-overview.md or ask user>

## Key Decisions Made

### Decision: Incremental build order
**We will:** Build shell first (milestone 01), then each section in milestone order
**Because:** Each section depends on the shell and design tokens being in place
**We won't:** Build all sections in parallel from the start

### Decision: Design system is locked
**We will:** Use the provided tokens.css and tailwind.config.js without modification
**Because:** The design system is the single source of truth for visual decisions
**We won't:** Introduce new colors, spacing, or typography outside the token set

<Additional decisions extracted from product-overview.md>

## Open Questions

- [ ] <Any gaps or ambiguities found in the export>

## Success Criteria

<Derived from product-overview.md and test-instructions/tests.md>

## Milestones (from DesignOS incremental/)

| # | Milestone | File |
|---|-----------|------|
| 01 | Shell + Design Tokens | incremental/01-shell.md |
| 02 | <Section Name> | incremental/02-<section>.md |
| … | … | … |

## Wiki References

- Design system → will be stored in `superspec/wiki/raw/design-system/` after import
```

---

### 5. Write spec.md

Create `superspec/specs/<slug>/spec.md`:

```markdown
# <Product Name> Specification

**Slug:** <slug>
**Status:** draft
**Source:** DesignOS export
**Depends on:** none

## Purpose

<Derived from product-overview.md — what the product does and why it exists>

## Requirements

### Requirement: Shell and Design System
The system SHALL implement the application shell using the provided design tokens.
The system SHALL apply `design-system/tokens.css` as CSS custom properties.
The system SHALL configure Tailwind using `design-system/tailwind.config.js`.
The system SHALL set up fonts as specified in `design-system/fonts.md`.

#### Scenario: Design tokens applied
- GIVEN the application is loaded
- WHEN any component renders
- THEN all colors, spacing, and typography SHALL use the defined CSS tokens
- AND no hardcoded color or spacing values SHALL appear outside the token set

#### Scenario: Font loading
- GIVEN the application is loaded
- WHEN the page renders
- THEN the specified fonts SHALL be loaded and applied

### Requirement: <Section N from milestones>
<One requirement block per incremental milestone section>

The system SHALL implement <section description from milestone file>.

#### Scenario: <Happy path from test-instructions>
- GIVEN <setup from test>
- WHEN <action from test>
- THEN <expected outcome from test>

#### Scenario: Empty state
- GIVEN <section has no data>
- WHEN the section renders
- THEN <empty state from test-instructions SHALL be shown>

<Repeat for each milestone section>

## Data Contract

<Derived from data-shape/types.ts — the TypeScript interfaces as behavior contracts>

The system SHALL conform to the following data shapes:

```typescript
<key interfaces from types.ts — trimmed to what matters for behavior>
```

## Error Behavior

- The system SHALL handle missing or empty data gracefully with the defined empty states
- The system SHALL NOT crash when optional fields are undefined
<Additional error behaviors from test-instructions>

## Non-Functional Requirements

- The system SHALL use the provided design tokens for all styling — no hardcoded values
- The system SHALL implement components in milestone order (shell before sections)

## Out of Scope

- Visual design decisions — handled by DesignOS design system
- Component layout pixel values — defined by DesignOS screenshots
- <Additional items from product-overview.md out-of-scope>

## Glossary

<Derived from data-shape/entities.md>
```

---

### 6. Write tasks.md

Map each DesignOS incremental milestone to a SuperSpecs wave. Process sequentially — each wave depends on the previous.

Create `superspec/specs/<slug>/tasks.md`:

```markdown
# Implementation Tasks: <Product Name>

**Source:** DesignOS incremental milestones
**Build order:** Sequential — each wave depends on the previous shell/section

## Context Window Budget
Estimated spec + task tokens: ~<N>k / 200k ✅

## Wave 1 — Shell + Design System
_(from incremental/01-shell.md)_

### Task 1.1: Design system setup
**What:** Apply `tokens.css` as CSS custom properties. Configure `tailwind.config.js`. Set up fonts per `fonts.md`.
**Files:** `src/styles/tokens.css`, `tailwind.config.js`, font imports
**Test requirement:** Write a test that verifies the CSS token variables are defined and a Tailwind utility using a token compiles correctly
**Done when:** Test passes, tokens available globally, no hardcoded values in shell

### Task 1.2: App shell
**What:** <Derived from 01-shell.md — the structural shell (layout, nav, containers)>
**Files:** `src/components/shell/`, `src/layouts/`
**Test requirement:** <From test-instructions/tests.md shell section>
**Done when:** Shell renders, design tokens applied, no regressions

## Wave 2 — <Section Name>
_(from incremental/02-<section>.md)_
**Depends on:** Wave 1 complete

### Task 2.1: <Section component>
**What:** <Derived from milestone file>
**Files:** `src/components/<section>/`
**Test requirement:** <From test-instructions/<section>-tests.md>
**Visual reference:** `components/<section>/screenshots/` in DesignOS export
**Done when:** Component renders with design tokens, test passes, empty state handled

<Repeat for each milestone>

## Done Criteria
The feature is DONE when:
- [ ] All milestones implemented in order
- [ ] All tests passing (zero skipped, zero pending)
- [ ] Every scenario in spec.md has a corresponding passing test
- [ ] User flow tests passing
- [ ] All components use design tokens — no hardcoded values
- [ ] Code review passed with no Critical findings
```

---

### 7. Preserve design assets in wiki/raw/

The design system and screenshots are reference material — preserve them for wiki compilation.

Copy or reference:
```
superspec/wiki/raw/design-system/
├── tokens.css              ← from design-system/tokens.css
├── tailwind.config.js      ← from design-system/tailwind.config.js
├── fonts.md                ← from design-system/fonts.md
├── entities.md             ← from data-shape/entities.md
└── screenshots/
    └── <section>/          ← from components/<section>/screenshots/
```

Create `superspec/wiki/raw/design-system/README.md`:
```markdown
# Design System — <Product Name>

Source: DesignOS export — <export-folder-name>
Imported: <today>
Spec: [[<slug>]]

## Files
- `tokens.css` — CSS custom properties (colors, spacing, typography)
- `tailwind.config.js` — Tailwind configuration
- `fonts.md` — Font setup
- `entities.md` — Data entity documentation
- `screenshots/` — Visual component references

## Usage
Run `/wiki <slug>` after the feature ships to compile the design system into the wiki.
```

---

### 8. Write status.md

Create `superspec/specs/<slug>/status.md`:

```markdown
# <Product Name> — Status

## Phase
1.0 — Plan › Design Import ✅

## Source
DesignOS export: <export-folder-name>
Milestones: <N> (→ <N> waves)

## Checklist
- [x] Design export imported (DISCUSS.md)
- [x] Spec written from export (spec.md)
- [x] Tasks mapped from milestones (tasks.md)
- [x] Design assets preserved (wiki/raw/design-system/)
- [ ] Spec grilled (GRILL.md)
- [ ] Branch created
- [ ] Subagent execution complete
- [ ] All tests passing
- [ ] Code review passed
- [ ] Wiki imported
- [ ] PR created
- [ ] Archived

## Slug
<slug>

## Started
<date>
```

---

### 9. Handoff

```
Design import complete: <slug>

Source: <N> DesignOS milestones → <N> execution waves
Spec:   <X> requirements, <Y> scenarios
Tasks:  <Z> tasks across <N> waves (sequential)
Design: wiki/raw/design-system/ (preserved for wiki ingest)
Context estimate: ~Xk / 200k ✅

Files created:
  superspec/specs/<slug>/DISCUSS.md
  superspec/specs/<slug>/spec.md
  superspec/specs/<slug>/tasks.md
  superspec/specs/<slug>/status.md
  superspec/wiki/raw/design-system/

Review the spec — especially:
  - Data contract matches your actual types
  - Milestone-to-wave mapping looks right
  - Any open questions in DISCUSS.md need answers

Next: /superspecs:grill <slug>
```

---

## Notes

**Sequential build order is enforced in tasks.md:** Each wave has `Depends on: Wave N-1 complete`. The shell wave (01) is always Wave 1 — it sets up design tokens and structure that all later sections depend on.

**Design system is locked:** The skill treats `tokens.css` and `tailwind.config.js` as the authoritative design contract. It will not suggest modifying them.

**Screenshots are reference, not spec:** Component screenshots are preserved in `wiki/raw/` as visual references for subagents. They are not parsed or described in spec.md — the agent looks at them during execution.

**Partial exports:** If some files are missing (e.g. no test-instructions), the skill notes the gaps in DISCUSS.md and generates scenarios based on product-overview.md instead. It never blocks on missing optional files.

---

## Output

- `superspec/specs/<slug>/DISCUSS.md`
- `superspec/specs/<slug>/spec.md`
- `superspec/specs/<slug>/tasks.md`
- `superspec/specs/<slug>/status.md`
- `superspec/wiki/raw/design-system/` (design assets for later wiki ingest)
