---
name: verify
description: Phase 3 combined verify. Stage 1 — run the full test suite, check spec scenario coverage, confirm no regressions. Stage 2 — distill the completed feature into the project wiki (architecture decisions, patterns, trade-offs, gotchas). Gate between stages: if tests fail, stop — do not proceed to wiki. Triggers on /verify, "verify", "check and wiki". Runs after all execution waves are complete.
slash_command: verify
phase: "3 — Verify"
---

# Skill: verify

You are doing the final verification before the feature can be shipped.

Execution is complete. This skill runs in two sequential stages:

1. **Stage 1 — Check Tests:** confirm the implementation works
2. **Stage 2 — Wiki Import:** distill the knowledge

**Gate:** If Stage 1 fails for any reason — failing tests, skipped tests, uncovered scenarios — stop. Do not proceed to Stage 2. Fix first.

---

## Stage 1 — Check Tests

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

If any tests that were passing before this spec's execution are now failing: that's a regression. It must be fixed before proceeding.

---

**Stage 1 gate:** All tests passing ✅ · All scenarios covered ✅ · No regressions ✅ → Proceed to Stage 2.

---

## Stage 2 — Wiki Import

You are distilling the completed feature into the living project wiki.

The feature works. The tests pass. Now you extract the knowledge that should survive beyond this session — so future planning, future features, and future sessions start informed.

The wiki lives at `superspec/wiki/` and doubles as an **Obsidian vault**. Write every page to be navigable in Obsidian: use `[[wikilinks]]` for internal links, YAML frontmatter with `tags:`, and keep each page focused on a single knowledge unit.

### What to distill (and what not to)

**Distill:**
- Architecture decisions (what was chosen and why)
- Patterns discovered or established
- Trade-offs made (what was given up, what was gained)
- Gotchas (things harder than expected + how they were solved)
- Key interfaces / contracts / data shapes
- Open questions deferred to future work

**Do NOT copy:**
- Full code listings (reference file paths instead)
- Task checklists or execution logs
- The full spec (it lives in `superspec/specs/`)

### Provenance

Mark the origin of every claim so future readers know what is fact vs. synthesis:

- Default (no marker): directly extracted from source material
- `^[inferred]` — synthesized by the agent; not stated verbatim in sources
- `^[ambiguous]` — sources disagree or the claim is uncertain

Example:
```
The team chose Redis over Postgres for session storage because of latency requirements.
A TTL of 15 minutes was selected as the balance point. ^[inferred]
Note: the DISCUSS.md mentions 10 minutes but the spec says 15 — see review-log. ^[ambiguous]
```

### 5. Gather the source material

Read:
- `superspec/specs/<slug>/DISCUSS.md`
- `superspec/specs/<slug>/spec.md`
- `superspec/phases/<slug>-execute/review-log.md`
- The implementation itself (key files touched)

### 6. Scan existing wiki pages first

**Before writing anything new**, scan the existing wiki for related content.

```
superspec/wiki/
├── Home.md              ← read first: domain index
├── log.md               ← read: recent activity
└── <domain>/
    ├── Home.md          ← domain index
    └── *.md             ← existing knowledge pages
```

For each existing page that overlaps with this feature:
- **Update it** — don't create a duplicate. Add a new `## <New Section>` or extend existing sections.
- Mark it with `updated: <today>` in the YAML frontmatter.
- Note it in the "pages_updated" list for the manifest and log.

**Rule:** One knowledge unit = one page. Merge, don't proliferate.

### 7. Determine wiki structure

Read `superspec/wiki/_meta/taxonomy.md` → build the canonical domain set from the `## Domains` table.

**Domain routing — use this decision tree for every knowledge unit:**

1. **Reusable cross-cutting pattern** (error handling, caching, retry, logging, testing patterns)?
   → `patterns/`

2. **Architecture decision** — why X was chosen over Y, with trade-offs documented?
   → `decisions/`

3. **Authentication, authorization, sessions, or tokens**?
   → `auth/`

4. **API contract, endpoint design, versioning, or request/response shape**?
   → `api/`

5. **Data model, schema, or storage decision**?
   → `data/`

6. **Infrastructure, deployment, CI/CD, or environment config**?
   → `infra/`

7. **Frontend, UI component, routing, or styling pattern**?
   → `ui/`

8. **Feature-specific knowledge that fits none of the above**?
   → Create a domain named after the feature slug (e.g. `payment-flow/`)
   → Add the new domain to `_meta/taxonomy.md` under "Project Domains" before creating the folder

**Rules:**
- **One domain per page.** If a page spans multiple concerns, split it into separate pages.
- **Prefer existing domains.** Only create a new domain if nothing in the taxonomy fits.
- **Feature traceability lives in `spec:` frontmatter**, not in the folder name.

After routing: does the chosen domain folder have a `Home.md`? If not, create a domain index listing its pages.

### 8. Write wiki pages

For each new knowledge unit, create `superspec/wiki/<domain>/<topic>.md`:

```markdown
---
title: <Page Title>
summary: <1–2 sentence summary used for fast query previews — what this is and why it matters>
tags: [<domain>, <feature-slug>, <topic-tags>]
spec: "[[<slug>]]"
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
provenance:
  sources: [specs/<slug>/spec.md, phases/<slug>-execute/review-log.md]
  extracted: ~70%
  inferred: ~25%
  ambiguous: ~5%
---

# <Page Title>

## Summary
1–2 sentences: what this is and why it exists in the project.

## Context
When and why this was built. What problem it solves.

## Key Decisions

### <Decision Topic>
**Chose:** <X>
**Over:** <Y>
**Because:** <reason>
**Trade-off:** <what was given up>

## Patterns

### <Pattern Name>
<Description>

```<lang>
// Short illustrative example
<example>
```

## Gotchas

- **<Problem>:** <how it manifested and what resolved it>

## Interface / Contract (if applicable)

<Key API shape, data model, event format — whatever future code needs to know>

## Open Questions

- [ ] <Unresolved question deferred to future work>

## Related
- [[<domain>/<page>]] — <what it covers>
- `<path/to/key/file>` — <what it does>
```

**Provenance markers in body text:**
- No marker = extracted directly from source material
- `^[inferred]` = agent synthesis, not stated verbatim
- `^[ambiguous]` = sources disagree or claim is uncertain

**Obsidian linking rules:**
- Internal links: always use `[[page-title]]` or `[[folder/page]]`, never markdown `[text](path.md)`
- File references: use backtick code spans for source file paths (`src/auth/jwt.ts`)
- Tags: lowercase, hyphenated (`auth`, `jwt-tokens`, `session-management`)
- Tags must come from `_meta/taxonomy.md` if it exists; add new tags there if needed

### 9. Update the vault home page

Update `superspec/wiki/Home.md`:

```markdown
---
title: Wiki Home
tags: [index, home]
updated: <YYYY-MM-DD>
---

# Project Wiki

...

## Domains

| Domain | Pages | Last updated |
|--------|-------|-------------|
| [[auth/Home\|auth]] | N | YYYY-MM-DD |

## Recent Updates

_(last 10 — full history in [[log]])_

- <YYYY-MM-DD>: [[<domain>/<page>]] — <brief description>
```

Each domain folder should also have its own `Home.md` listing its pages.

### 10. Cross-link

After writing all pages:
- Scan existing wiki pages for unlinked mentions of new page topics
- Add `[[wikilinks]]` where relevant
- Ensure the new pages link back to related existing pages

Or invoke `/superspecs:cross-linker` to automate this step.

### 11. Append to log.md

Append to `superspec/wiki/log.md` (create if missing):

```markdown
## [<YYYY-MM-DD>] ingest | <slug>: <feature title>

- **Created:** <domain>/<page>.md, <domain>/<page2>.md
- **Updated:** <domain>/<existing>.md
- **Domains touched:** <domain1>, <domain2>
- **Spec:** [[../specs/<slug>/spec.md]]
```

### 12. Update the manifest

Update `superspec/wiki/_manifest.json`:

```json
{
  "sources": [
    {
      "slug": "<slug>",
      "ingested_at": "<ISO timestamp>",
      "pages_created": ["<domain>/<page>"],
      "pages_updated": ["<domain>/<existing-page>"]
    }
  ]
}
```

### 13. Update spec status

Update `superspec/specs/<slug>/status.md`:

```markdown
## Test Results
- Suite: X passing, 0 failing, 0 skipped
- Spec scenarios: Y/Y covered
- Regressions: none

## Wiki Pages
- [[<domain>/<page>]] — <what it covers>

## Phase
3 — Verify ✅
```

### 14. Handoff

```
Verify complete: <slug>

Stage 1 — Tests
Suite: <N> passing ✅
Scenarios: <N>/<N> covered ✅
Regressions: none ✅

Stage 2 — Wiki
Pages created: X
Pages updated: Y

superspec/wiki/
├── <domain>/
│   ├── Home.md      (domain index)
│   ├── <page1>.md   (new)
│   └── <page2>.md   (updated)
├── Home.md          (updated)
└── log.md           (appended)

Run /cross-linker to auto-weave [[wikilinks]] across the vault.
Open superspec/wiki/ in Obsidian to browse the vault.

Next: /superspecs-ship <slug>
```

---

## Fail states

**Tests failing:**
```
❌ Test failures found: N

Failing tests:
- <test name> (<file>:<line>)
  Error: <message>

Stage 1 failed. Fix failures before proceeding to wiki import.
```

**Skipped or pending tests:**
```
⚠️ Skipped tests found: N

Skipped tests are not passing tests. Options:
1. Fix and unskip
2. Delete if no longer relevant

Do not proceed to wiki import with skipped tests that cover spec scenarios.
```

**Missing scenario coverage:**
```
❌ Uncovered spec scenarios: N

- Scenario: <name> (Requirement: <name>)
  No test found. Write one before proceeding to wiki import.
```

---

## Output

- New/updated pages in `superspec/wiki/<domain>/`
- Domain `Home.md` index (create if domain is new)
- Updated `superspec/wiki/Home.md`
- Appended `superspec/wiki/log.md`
- Updated `superspec/wiki/_manifest.json`
- Updated `superspec/specs/<slug>/status.md`
