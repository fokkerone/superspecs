---
name: verify-wiki
description: Distill a completed, verified feature into the project wiki. Architecture decisions, patterns, trade-offs, gotchas. The knowledge that should outlive this session. Triggers on /wiki, "import to wiki", "document the feature". Runs after /check-tests passes.
slash_command: wiki
phase: "3.2 — Verify › Wiki Import"
---

# Skill: verify-wiki

You are distilling the completed feature into the living project wiki.

The feature works. The tests pass. Now you extract the knowledge that should survive beyond this session — so future planning, future features, and future sessions start informed.

The wiki lives at `superspec/wiki/` and doubles as an **Obsidian vault**. Write every page to be navigable in Obsidian: use `[[wikilinks]]` for internal links, YAML frontmatter with `tags:`, and keep each page focused on a single knowledge unit.

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

---

## Steps

### 1. Gather the source material

Read:
- `superspec/specs/<slug>/DISCUSS.md`
- `superspec/specs/<slug>/spec.md`
- `superspec/phases/<slug>-execute/review-log.md`
- The implementation itself (key files touched)

---

### 2. Scan existing wiki pages first

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

For topics with no existing page: create a new page (Step 4).

**Rule:** One knowledge unit = one page. Merge, don't proliferate.

---

### 3. Determine wiki structure

Check `superspec/wiki/Home.md`. Identify:
- Which domain folder this belongs in (create one if needed)
- Whether any existing pages should be updated vs. new pages created

Domain examples: `auth/`, `api/`, `data/`, `ui/`, `infra/`, `patterns/`, `decisions/`

Each domain is a subfolder. Each knowledge unit is a single `.md` file inside it.

---

### 4. Write wiki pages

For each new knowledge unit, create `superspec/wiki/<domain>/<topic>.md`:

```markdown
---
title: <Page Title>
tags: [<domain>, <feature-slug>, <topic-tags>]
spec: "[[<slug>]]"
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
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

**Obsidian linking rules:**
- Internal links: always use `[[page-title]]` or `[[folder/page]]`, never markdown `[text](path.md)`
- File references: use backtick code spans for source file paths (`src/auth/jwt.ts`)
- Tags: lowercase, hyphenated (`auth`, `jwt-tokens`, `session-management`)

---

### 5. Update the vault home page

Update `superspec/wiki/Home.md`:

```markdown
---
title: Wiki Home
tags: [index, home]
updated: <YYYY-MM-DD>
---

# Project Wiki

Knowledge base distilled from shipped features — architecture decisions, patterns, trade-offs, gotchas.

> Open `superspec/wiki/` in Obsidian for graph view, backlinks, and tag search.

## Domains

| Domain | Pages | Last updated |
|--------|-------|-------------|
| [[auth/Home\|auth]] | N | YYYY-MM-DD |
| [[<domain>/Home\|<domain>]] | N | YYYY-MM-DD |

## Recent Updates

_(last 10 — full history in [[log]])_

- <YYYY-MM-DD>: [[<domain>/<page>]] — <brief description>
```

Each domain folder should have its own `Home.md` listing its pages:

```markdown
---
title: <Domain> — Index
tags: [index, <domain>]
updated: <YYYY-MM-DD>
---

# <Domain>

- [[<page1>]] — <what it covers>
- [[<page2>]] — <what it covers>
```

---

### 6. Cross-link

After writing all pages:
- Scan existing wiki pages for unlinked mentions of new page topics
- Add `[[wikilinks]]` where relevant
- Ensure the new pages link back to related existing pages

---

### 7. Append to log.md

Append to `superspec/wiki/log.md` (create if missing):

```markdown
## [<YYYY-MM-DD>] ingest | <slug>: <feature title>

- **Created:** <domain>/<page>.md, <domain>/<page2>.md
- **Updated:** <domain>/<existing>.md
- **Domains touched:** <domain1>, <domain2>
- **Spec:** [[../specs/<slug>/spec.md]]
```

**log.md format rules:**
- Append-only — never edit existing entries
- One `##` heading per ingest event, timestamped
- Keep entries short: what changed and where
- The log is grep-friendly: `grep "## \[" log.md` lists all events

---

### 8. Update the manifest

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

---

### 9. Update spec status

Update `superspec/specs/<slug>/status.md`:

```markdown
## Wiki Pages
- [[<domain>/<page>]] — <what it covers>

## Phase
3.2 — Verify › Wiki Import ✅
```

---

### 10. Handoff

```
Wiki import complete: <slug>

Pages created: X
Pages updated: Y

superspec/wiki/
├── <domain>/
│   ├── Home.md      (domain index)
│   ├── <page1>.md   (new)
│   └── <page2>.md   (updated)
├── Home.md          (updated)
└── log.md           (appended)

Open superspec/wiki/ in Obsidian to browse the vault.

Next: /superspecs:ship <slug>
```

---

## Output

- New/updated pages in `superspec/wiki/<domain>/`
- Domain `Home.md` index (create if domain is new)
- Updated `superspec/wiki/Home.md`
- Appended `superspec/wiki/log.md`
- Updated `superspec/wiki/_manifest.json`
- Updated `superspec/specs/<slug>/status.md`
