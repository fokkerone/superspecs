---
name: spec-wiki
description: After a feature ships, distill it into the project wiki. Architecture decisions, patterns, trade-offs — the knowledge that should outlive this session. Use when triggered by /spec:wiki after review is passed.
slash_command: spec:wiki
---

# Skill: spec-wiki

You are in the wiki sync phase of the SuperSpecs lifecycle.

The feature is implemented and reviewed. Now you distill the knowledge into the living wiki so it persists for future sessions and future features.

## Inputs

- Feature slug: provided or inferred
- `superspec/specs/<slug>/spec.md`
- `superspec/changes/<change-id>/design.md`
- `superspec/changes/<change-id>/proposal.md`
- The implementation itself

## What to distill

Not everything. Distill:

- **Architecture decisions** — what we chose and why
- **Patterns** — reusable approaches discovered during implementation
- **Trade-offs** — what we gave up and what we got
- **Gotchas** — things that were harder than expected
- **Interfaces** — key APIs, data shapes, contracts
- **Open questions** — things left unresolved for later

Do NOT copy:
- Code verbatim (link to the file instead)
- Task checklists
- The full spec (it already lives in `superspec/specs/`)

## Steps

### 1. Determine wiki organization

Check `superspec/wiki/` structure. Find the right domain folder or create one.

Domain examples: `auth/`, `api/`, `data/`, `ui/`, `infra/`, `patterns/`

### 2. Check for existing pages

Look for pages that should be updated vs. new pages to create. Merge new knowledge into existing pages when relevant.

### 3. Write wiki pages

For each significant knowledge unit, create or update a page:

```markdown
---
title: <Page Title>
tags: [<domain>, <tags>]
spec: superspec/specs/<slug>/spec.md
created: <date>
updated: <date>
sources: [<change-id>]
---

# <Page Title>

## Summary
1-2 sentences: what this is.

## Context
When and why this exists in the project.

## Key Decisions
### <Decision>
We chose <X> over <Y> because <reason>.
Trade-off: <what we gave up>.

## Patterns
### <Pattern Name>
<Description of reusable pattern discovered here>

```<language>
// Illustrative example (not full code)
<short example>
```

## Gotchas
- <Thing that was harder than expected and how we solved it>

## Related
- [[<wikilink to related page>]]
- `<path/to/key/file.ts>` — <what it does>
```

### 4. Update the wiki index

Update or create `superspec/wiki/_index.md`:

```markdown
# Project Wiki

## Domains
- [[auth/]] — Authentication & authorization
- [[api/]] — API patterns and contracts
- [add new domains]

## Recent Updates
- <date>: [[<page>]] — <what was added>
```

### 5. Update manifest

Update `superspec/wiki/_manifest.json`:

```json
{
  "sources": [
    {
      "change_id": "<change-id>",
      "slug": "<slug>",
      "ingested_at": "<timestamp>",
      "pages_created": ["<page1>", "<page2>"],
      "pages_updated": ["<page3>"]
    }
  ]
}
```

### 6. Link spec to wiki

Update `superspec/specs/<slug>/status.md`:

```markdown
## Wiki References
- [[superspec/wiki/<domain>/<page>]] — <what it covers>
```

### 7. Confirm

```
Wiki sync complete: <slug>

Pages created: X
Pages updated: Y

superspec/wiki/
├── <domain>/
│   ├── <page1>.md  (new)
│   └── <page2>.md  (updated)
└── _index.md       (updated)

Next: /spec:complete <slug>
```

## Output

- New/updated wiki pages in `superspec/wiki/`
- Updated `superspec/wiki/_index.md`
- Updated `superspec/wiki/_manifest.json`
- Updated `superspec/specs/<slug>/status.md` (wiki references populated)
