---
name: design-import
description: Import a DesignOS export as structured context for Phase 1 planning. Reads the export and creates a design-context.md that enriches /discuss and /spec with design constraints, data shapes, milestone structure, and test scaffolding. Optional — the normal /discuss + /spec flow still runs. Triggers on /design-import, "import design", "import DesignOS", "import from design export".
slash_command: design-import
phase: "1.x — Plan › Design Import (optional)"
---

# Skill: design-import

You are enriching the Phase 1 planning process with a DesignOS export.

This is an **optional step** — it does not replace `/discuss` or `/spec`. It reads a DesignOS export and extracts the design constraints, data shapes, milestone structure, and test scaffolding into a `design-context.md` file. The normal `/discuss` + `/spec` flow then uses both the discussion and the design context together.

**Use it to integrate a DesignOS-built prototype into your planning — not to skip planning.**

---

## When to run it

```
# Run before /discuss — design context informs the conversation:
/design-import <path> → /discuss → /spec → /grill

# Run after /discuss — enrich discussion with design details before writing spec:
/discuss → /design-import <path> → /spec → /grill

# Run alongside /discuss — reference the context during discussion:
/discuss (with design-context.md open as reference) + /design-import <path>
```

All paths still go through `/discuss`, `/spec`, and `/grill`. The design import adds structured input; it doesn't make those steps optional.

---

## Expected DesignOS Export Structure

```
<export-folder>/
├── product-plan/
│   ├── product-overview.md          ← product description, goals, non-goals
│   ├── one-shot-instructions.md     ← (optional) full one-shot guide
│   └── incremental/
│       ├── 01-shell.md              ← milestone 1: design tokens + app shell
│       ├── 02-<section>.md          ← milestone 2: first content section
│       └── NN-<section>.md          ← milestone N: last section
│
├── design-system/
│   ├── tokens.css                   ← CSS custom properties
│   ├── tailwind.config.js           ← Tailwind configuration
│   └── fonts.md                     ← font setup
│
├── data-shape/
│   ├── types.ts                     ← TypeScript interfaces
│   ├── sample-data.ts               ← sample data
│   └── entities.md                  ← entity documentation
│
├── components/
│   └── <section>/
│       └── screenshots/             ← visual references
│
└── test-instructions/
    ├── tests.md                     ← overall test specification
    ├── user-flow-tests.md           ← (optional) end-to-end user flows
    └── <section>-tests.md           ← per-section test specs
```

---

## Steps

### 1. Locate the export

Ask the user for the path to the DesignOS export folder if not provided.

Verify the folder exists and contains at minimum `product-plan/product-overview.md`.

If the structure is partial (some files missing), proceed with what's available and note gaps.

---

### 2. Read the export

Read in this order:

1. `product-plan/product-overview.md` — product description, goals, constraints
2. `product-plan/incremental/` — all milestone files, sorted numerically
3. `test-instructions/tests.md` + per-section test files
4. `data-shape/types.ts` + `entities.md`
5. `design-system/tokens.css` — skim for token naming convention

Do NOT read component `.tsx` files — they are reference material, not planning input.

---

### 3. Check for existing DISCUSS.md

Check if `superspec/specs/<slug>/DISCUSS.md` already exists.

- **If it does:** the design context will enrich it — merge relevant design decisions into the existing doc (Step 4b)
- **If it doesn't:** create `design-context.md` as standalone context for the upcoming `/discuss` session (Step 4a)

If no slug exists yet, derive one from the product name in `product-overview.md`.

---

### 4a. Create design-context.md (no DISCUSS.md yet)

Create `superspec/specs/<slug>/design-context.md`:

```markdown
# Design Context: <Product Name>

Source: DesignOS export — <export-folder-name>
Imported: <today>

> This file is input for `/discuss` and `/spec`. It captures the design constraints,
> data contract, milestone plan, and test scaffolding from the DesignOS export.
> Review it before running `/discuss` so these decisions inform the conversation.

---

## Product Overview

<Summary from product-overview.md — what the product is and why it exists>

## Design System (locked)

The following are provided by the DesignOS export and should be treated as constraints, not decisions to re-make:

- **CSS tokens:** `design-system/tokens.css` — all colors, spacing, typography
- **Tailwind config:** `design-system/tailwind.config.js`
- **Fonts:** see `design-system/fonts.md`

No hardcoded color or spacing values. All styling via the token set.

## Data Contract

Types from `data-shape/types.ts` that are relevant to planning:

```typescript
<key interfaces — trimmed to what matters for behavior decisions>
```

Entity relationships: <summary from entities.md>

## Build Order (Incremental Milestones)

The DesignOS export defines N milestones. Each should become one execution wave:

| Wave | Milestone | What it builds |
|------|-----------|---------------|
| 1 | 01-shell | Design tokens applied, app shell structure |
| 2 | 02-<section> | <section description> |
| … | … | … |

**Shell (Wave 1) must complete before any section wave.** Each section wave depends on the shell having established design tokens and layout structure.

## Test Scaffolding

Key behaviors from `test-instructions/tests.md` to incorporate into spec scenarios:

<Extracted test scenarios as bullet points — what needs to be verified>

**User flows:**
<From user-flow-tests.md if present>

**Per-section tests:**
<Summarized from section test files>

## Open Questions for /discuss

Based on the export, these decisions still need to be made in the discussion:

- [ ] <Gap or ambiguity found in the export>
- [ ] <Stack/framework choice if not specified>
- [ ] <Integration points not covered by the design>

## Visual References

Screenshots preserved in `superspec/wiki/raw/design-system/screenshots/` for use during execution.
```

---

### 4b. Enrich existing DISCUSS.md

If DISCUSS.md already exists, add a `## Design Import` section to it:

```markdown
## Design Import

Source: DesignOS export — <export-folder-name>
Imported: <today>

### Design System Constraints (locked)
- CSS tokens: `design-system/tokens.css` — use as-is
- Tailwind: `design-system/tailwind.config.js` — use as-is
- No hardcoded styling values

### Data Contract
<Key types from types.ts relevant to this feature>

### Milestone Structure → Waves
| Wave | Milestone | What it builds |
|------|-----------|---------------|
| 1 | 01-shell | Design tokens + shell |
| … | … | … |

### Test Scaffolding
<Key test scenarios to incorporate into spec>

### Additional Open Questions
- [ ] <Gaps found in the design export>
```

---

### 5. Preserve design assets in wiki/raw/

Copy to `superspec/wiki/raw/design-system/`:

```
superspec/wiki/raw/design-system/
├── tokens.css
├── tailwind.config.js
├── fonts.md
├── entities.md
└── screenshots/
    └── <section>/
```

Create `superspec/wiki/raw/design-system/README.md` with source info and link to spec slug.

---

### 6. Update status.md

If status.md exists, add a line. If not, create it:

```markdown
## Design Import
- [x] DesignOS export imported (design-context.md)
- [x] Design assets preserved (wiki/raw/design-system/)
```

---

### 7. Handoff

```
Design import complete: <slug>

Created: superspec/specs/<slug>/design-context.md
Preserved: superspec/wiki/raw/design-system/

What was extracted:
  - Design system constraints (tokens, Tailwind, fonts)
  - Data contract (N TypeScript interfaces)
  - N milestones → N execution waves (sequential)
  - Test scaffolding (N scenarios)
  - N open questions for /discuss

Next steps:
  /superspecs:discuss <slug>   Open the discussion (design-context.md is ready as input)
  /superspecs:spec <slug>      Write the spec (reads DISCUSS.md + design-context.md)
```

---

## How /spec uses design-context.md

When `/spec` runs, it should check for `design-context.md` alongside `DISCUSS.md`:

- Design system constraints → Non-Functional Requirements + Out of Scope section
- Data contract types → Interface/Contract section
- Milestone structure → waves in `tasks.md`
- Test scaffolding → GIVEN/WHEN/THEN scenarios (starting points, not verbatim copy)
- Open questions → open questions in DISCUSS.md (if not yet addressed)

The spec writer merges both sources. DISCUSS.md carries the human decisions; design-context.md carries the design constraints.

---

## Output

- `superspec/specs/<slug>/design-context.md` (if no DISCUSS.md exists)
- OR enriched `superspec/specs/<slug>/DISCUSS.md` (if DISCUSS.md already exists)
- `superspec/wiki/raw/design-system/` (design assets for later wiki ingest)
- Updated `superspec/specs/<slug>/status.md`
