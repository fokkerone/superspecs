---
name: verify-wiki
description: Distill a completed, verified feature into the project wiki. Architecture decisions, patterns, trade-offs, gotchas. The knowledge that should outlive this session. Triggers on /wiki, "import to wiki", "document the feature". Runs after /check-tests passes.
slash_command: wiki
phase: "3.2 — Verify › Wiki Import"
---

# Skill: verify-wiki

You are distilling the completed feature into the living project wiki.

The feature works. The tests pass. Now you extract the knowledge that should survive beyond this session — so future planning, future features, and future sessions start informed.

## What to distill (and what not to)

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

## Steps

### 1. Gather the source material

Read:
- `superspec/specs/<slug>/DISCUSS.md`
- `superspec/specs/<slug>/spec.md`
- `superspec/phases/<slug>-execute/review-log.md`
- The implementation itself (key files touched)

### 2. Determine wiki structure

Check `superspec/wiki/_index.md`. Identify:
- Which domain folder this belongs in (create one if needed)
- Whether any existing pages should be updated vs. new pages created

Domain examples: `auth/`, `api/`, `data/`, `ui/`, `infra/`, `patterns/`, `decisions/`

### 3. Write wiki pages

For each meaningful knowledge unit:

```markdown
---
title: <Page Title>
tags: [<domain>, <feature-slug>, <topic-tags>]
spec: superspec/specs/<slug>/spec.md
created: <date>
updated: <date>
sources: [<slug>]
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

### <Decision Topic>
...

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
- [[<wikilink>]] — <what it covers>
- `<path/to/key/file>` — <what it does>
```

### 4. Update the wiki index

Update `superspec/wiki/_index.md`:

```markdown
## Domains

- [[auth/]] — Authentication & authorization
- [[<new-domain>/]] — <description>

## Recent Updates

- <date>: [[<domain>/<page>]] — <brief description> (from `<slug>`)
```

### 5. Update the manifest

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

### 6. Cross-link

After writing all pages:
- Scan existing wiki pages for unlinked mentions of new page topics
- Add `[[wikilinks]]` where relevant
- Ensure the new pages link back to related existing pages

### 7. Update spec status

Update `superspec/specs/<slug>/status.md`:

```markdown
## Wiki Pages
- [[superspec/wiki/<domain>/<page>]] — <what it covers>

## Phase
3.2 — Verify › Wiki Import ✅
```

### 8. Handoff

```
Wiki import complete: <slug>

Pages created: X
Pages updated: Y

superspec/wiki/
├── <domain>/
│   ├── <page1>.md  (new)
│   └── <page2>.md  (updated)
└── _index.md (updated)

Next: /ship <slug>
```

## Output

- New/updated pages in `superspec/wiki/<domain>/`
- Updated `superspec/wiki/_index.md`
- Updated `superspec/wiki/_manifest.json`
- Updated `superspec/specs/<slug>/status.md`
