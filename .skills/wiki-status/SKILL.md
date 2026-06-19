---
name: wiki-status
description: Show a health and activity dashboard for the compiled wiki vault. Ingested pages, pending sources, hub pages with most backlinks, tag distribution, recent activity. Triggers on /wiki-status, "wiki dashboard", "wiki stats", "what's in the wiki".
slash_command: wiki-status
phase: "3.2 — Verify › Wiki Status"
---

# Skill: wiki-status

You are producing a health and activity dashboard for `superspec/wiki/`.

This is a read-only operation. No files are written except an optional `_insights.md`.

---

## Steps

### 1. Inventory the vault

Scan all `.md` files in `superspec/wiki/` (excluding `raw/`, `.obsidian/`).

Collect for each page:
- Path, title, domain
- `created:` and `updated:` dates from frontmatter
- `tags:` list
- `summary:` (for preview)
- All outbound `[[wikilinks]]`
- Count of inbound `[[wikilinks]]` from other pages (backlinks)
- Provenance block if present

Also read:
- `_manifest.json` — ingestion history
- `log.md` — recent events

---

### 2. Compute metrics

**Vault size**
- Total pages (excluding Home indexes, log, manifest, lint report)
- Pages by domain
- Pages created this month / this quarter

**Activity**
- Last ingest: date + slug
- Last query: date + topic
- Last lint: date + issue count
- Last cross-link run: date + links inserted

**Hub pages** (most inbound backlinks)
- Top 5 pages by backlink count
- These are the most-referenced knowledge nodes

**Orphaned pages** (no inbound backlinks, not an index)
- Quick count — detail in `/wiki-lint`

**Tag distribution**
- Top 10 tags by frequency
- Tags not in `_meta/taxonomy.md` (if taxonomy exists)

**Provenance distribution** (across all pages with `provenance:` block)
- Average extracted / inferred / ambiguous ratios
- Pages with high inferred ratio (>50%) — flag for review

**Pending sources**
- Files in `superspec/wiki/raw/` not yet in `_manifest.json`
- Specs in `superspec/specs/` whose slugs don't appear in `_manifest.json` ingestion history

---

### 3. Output dashboard

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Wiki Status — superspec/wiki/
  Generated: <YYYY-MM-DD HH:MM>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

VAULT SIZE
  Total pages:    N
  Domains:        N (auth, api, data, ...)
  Created this month: N

RECENT ACTIVITY
  Last ingest:    <YYYY-MM-DD> — <slug>: <title>
  Last query:     <YYYY-MM-DD> — "<topic>"
  Last lint:      <YYYY-MM-DD> — N issues
  Last cross-link: <YYYY-MM-DD> — K links inserted

HUB PAGES (most referenced)
  N  [[auth/jwt-refresh]]
  N  [[patterns/error-handling]]
  N  [[api/rest-conventions]]
  N  [[decisions/database-choice]]
  N  [[infra/redis-cache]]

TAG DISTRIBUTION (top 10)
  auth (N)  api (N)  patterns (N)  ...

PROVENANCE
  Extracted:  ~X%   (directly from source material)
  Inferred:   ~X%   (agent synthesis)
  Ambiguous:  ~X%   (sources disagree)
  ⚠ High-inferred pages: N (>50% inferred — verify accuracy)

PENDING
  raw/ files not yet ingested:  N
  Specs not yet compiled:       N slugs
    - <slug-1>
    - <slug-2>

HEALTH
  Orphaned pages:    N  (run /wiki-lint for details)
  Broken wikilinks:  N  (run /wiki-lint for details)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Suggested actions:
  /wiki <slug>         Compile pending spec
  /wiki-lint           Full health check
  /cross-linker        Auto-weave missing [[wikilinks]]
  /wiki-query          Ask the wiki anything
```

---

### 4. Optionally write _insights.md

If the user asks for a persistent record, write `superspec/wiki/_insights.md`:

```markdown
---
title: Wiki Insights
generated: <YYYY-MM-DD HH:MM>
tags: [insights, status]
---

# Wiki Insights

<Full dashboard content as markdown>

## Hub Pages
<Ranked list with backlink counts>

## Domain Coverage
<Table: domain | pages | last updated | pending>

## Suggested Next Steps
<Concrete actions based on pending sources and health>
```

---

## Output

- Dashboard printed in response (always)
- Optionally: `superspec/wiki/_insights.md`
