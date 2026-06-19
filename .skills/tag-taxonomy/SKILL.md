---
name: tag-taxonomy
description: Maintain a controlled vocabulary of canonical tags for the wiki vault. Creates and updates _meta/taxonomy.md. Audits all wiki pages for non-canonical tags and normalizes them. Triggers on /tag-taxonomy, "fix tags", "normalize wiki tags", "audit tags".
slash_command: tag-taxonomy
phase: "3.2 — Verify › Wiki Taxonomy"
---

# Skill: tag-taxonomy

You are maintaining tag consistency across the wiki vault.

Tags are how the Obsidian graph clusters knowledge. Without a controlled vocabulary, tags drift: "auth" and "authentication" and "Authorization" end up meaning the same thing, fragmenting the graph. This skill enforces one canonical tag per concept.

---

## The Taxonomy File

`superspec/wiki/_meta/taxonomy.md` is the source of truth for canonical tags.

Format:
```markdown
---
title: Tag Taxonomy
updated: <YYYY-MM-DD>
---

# Tag Taxonomy

Canonical tag vocabulary for this vault. All wiki pages must use tags from this list.
Add new tags here before using them in pages.

## Domain Tags
<!-- One tag per domain folder -->
- `auth` — authentication and authorization
- `api` — API design and contracts
- `data` — data models and storage
- `ui` — frontend and interface
- `infra` — infrastructure and deployment
- `patterns` — reusable implementation patterns
- `decisions` — architecture decision records

## Topic Tags
<!-- Cross-domain concept tags -->
- `jwt` — JSON Web Tokens
- `caching` — caching strategies and implementations
- `error-handling` — error handling patterns
- `testing` — test strategy and patterns
- `performance` — performance considerations
- `security` — security concerns

## Meta Tags
<!-- Reserved for wiki structure -->
- `index` — index and home pages (do not use in content pages)
- `log` — activity log (reserved)
- `insights` — generated insights pages
- `lint` — lint report pages
- `query-derived` — pages created from wiki-query results
- `capture` — pages created from wiki-capture

## Aliases
<!-- Non-canonical → canonical mappings -->
- `authentication` → `auth`
- `authorization` → `auth`
- `Authorization` → `auth`
- `caches` → `caching`
- `errors` → `error-handling`
```

---

## Steps

### Mode A — Init (first run, no taxonomy yet)

If `superspec/wiki/_meta/taxonomy.md` does not exist:

1. Scan all wiki pages and collect every tag in use
2. Group by apparent intent (cluster similar tags)
3. For each cluster, pick the shortest, clearest, lowercase-hyphenated canonical form
4. Write `_meta/taxonomy.md` with:
   - Domain tags (one per domain folder)
   - Topic tags (all unique concepts found)
   - Alias map (non-canonical → canonical for each cluster)
5. Report what was found and the proposed taxonomy — wait for confirmation before normalizing pages

---

### Mode B — Audit (taxonomy exists, check compliance)

1. Read `_meta/taxonomy.md` — build canonical set + alias map
2. Scan all wiki pages
3. For each page, check `tags:` in frontmatter:
   - Is every tag in the canonical set? → OK
   - Is the tag an alias? → candidate for normalization
   - Is the tag unknown (not canonical, not alias)? → flag for addition to taxonomy
4. Report findings:

```
Tag Audit Report

Canonical tags used: N
Non-canonical tags found: M pages

Aliases that can be auto-normalized:
  "authentication" (4 pages) → "auth"
  "Authorization" (2 pages) → "auth"
  "caches" (1 page) → "caching"

Unknown tags (not in taxonomy):
  "websocket" (3 pages) — add to taxonomy as: `websocket` — WebSocket connections?
  "rate-limit" (2 pages) — add to taxonomy as: `rate-limiting` — Rate limiting patterns?

Auto-normalize aliases? [Y/N]
Add unknown tags to taxonomy? [Y to review each / A for all / N to skip]
```

---

### Mode C — Normalize (apply fixes after confirmation)

For each alias normalization confirmed:
1. Update `tags:` in each affected page's frontmatter
2. Update `updated:` date
3. Update alias map in `_meta/taxonomy.md` if not already there

For each new tag added to taxonomy:
1. Add to appropriate section in `_meta/taxonomy.md`

Append to `log.md`:
```markdown
## [<YYYY-MM-DD>] taxonomy | normalized N tags across M pages
```

---

## Output

- `superspec/wiki/_meta/taxonomy.md` (created or updated)
- Modified wiki pages (normalized tags)
- Appended `superspec/wiki/log.md`
- Audit report in response
