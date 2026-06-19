---
name: cross-linker
description: Scan the wiki vault for unlinked mentions of page titles and topics. Insert [[wikilinks]] automatically. Run after /wiki ingest or standalone. Triggers on /cross-linker, "cross-link the wiki", "add wikilinks", "link wiki pages".
slash_command: cross-linker
phase: "3.2 — Verify › Wiki Cross-link"
---

# Skill: cross-linker

You are weaving the knowledge graph. After new pages are ingested, unlinked mentions of their topics exist across the vault — prose that says "JWT refresh" without linking to `[[auth/jwt-refresh]]`. You find those gaps and insert `[[wikilinks]]`.

---

## Steps

### 1. Build the link target map

Scan every `.md` file in `superspec/wiki/` (excluding `raw/`, `.obsidian/`, `_meta/`).

For each page, collect:
- The page path (e.g. `auth/jwt-refresh`)
- The `title:` from frontmatter
- Common aliases: derived from the title (e.g. "JWT Refresh", "jwt refresh", "JWT refresh token")
- Any explicit `aliases:` field in frontmatter if present

Build a lookup: `alias → [[domain/page]]`

---

### 2. Scan all pages for unlinked mentions

For each wiki page, scan the body text for occurrences of any alias from the map that:
1. Is **not already inside a `[[wikilink]]`**
2. Is **not in a code block** (fenced ``` or inline `` ` ``)
3. Is **not in a heading** (`#`, `##`, etc.)
4. Is **not a self-reference** (page doesn't link to itself)
5. Appears as a **standalone phrase** (not a substring of a longer word)

Collect all candidates: `{page, line, alias, target}`.

---

### 3. Apply links — first occurrence per page only

For each candidate:
- Link only the **first occurrence** of each alias per page
- Replace the plain text with `[[target|alias]]` if the alias differs from the page title, or `[[target]]` if it matches exactly
- Preserve surrounding punctuation and capitalization

Example:
```
Before: The system uses JWT refresh tokens to maintain sessions.
After:  The system uses [[auth/jwt-refresh|JWT refresh tokens]] to maintain sessions.
```

Do **not** link:
- Occurrences in frontmatter
- Occurrences already inside `[[...]]`
- Occurrences inside code blocks
- Generic words that happen to match a title (use judgment — "data" should not auto-link to a page titled "Data")

---

### 4. Avoid over-linking

Apply these guards:
- Skip aliases shorter than 4 characters (too generic)
- Skip aliases that are common English words unlikely to be intentional references (use judgment)
- If uncertain: skip and note it in the report

---

### 5. Write changes

For each modified page:
- Apply all link insertions in a single write (don't write page multiple times)
- Update the `updated:` date in frontmatter to today

---

### 6. Report

```
Cross-link complete

Pages scanned: N
Pages modified: M
Links inserted: K

Changes:
- auth/session-management.md: 3 links inserted
    - "JWT refresh" → [[auth/jwt-refresh]]
    - "Redis" → [[infra/redis-cache]]
    - "session TTL" → [[auth/session-management]] (self-link skipped)
- patterns/error-handling.md: 1 link inserted
    - "circuit breaker" → [[patterns/circuit-breaker]]

Skipped (ambiguous):
- data/pipeline.md: "data" matched [[data/Home]] — too generic, skipped

Append to log.md: [YYYY-MM-DD] cross-link | K links inserted across M pages
```

---

### 7. Append to log.md

```markdown
## [<YYYY-MM-DD>] cross-link | <K> links inserted across <M> pages
```

---

## Output

- Modified wiki pages with `[[wikilinks]]` inserted
- Updated `updated:` dates in modified pages
- Appended `superspec/wiki/log.md`
- Cross-link report in response
