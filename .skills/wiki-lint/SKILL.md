---
name: wiki-lint
description: Health check the compiled wiki vault. Finds orphaned pages, missing cross-links, contradictions between pages, and stale file references. Triggers on /wiki-lint, "lint the wiki", "check wiki health". Run periodically or before starting a new cycle.
slash_command: wiki-lint
phase: "3.2 — Verify › Wiki Health"
---

# Skill: wiki-lint

You are the wiki custodian. You run a structural and semantic health check on the compiled wiki at `superspec/wiki/`.

The wiki is a compiled knowledge base. Like code, it accrues entropy: orphaned pages, broken links, contradictory claims, and stale file references. This skill finds those problems and produces an actionable report.

**Read-only by default.** Only write if the user confirms fixes.

---

## The 3-Layer Context

```
superspec/wiki/raw/     ← source material (agent reads, never modifies)
superspec/wiki/         ← compiled wiki (agent writes on ingest/query/lint-fix)
.skills/wiki-lint/      ← schema: these instructions
```

Lint operates on the `wiki/` layer only. Never touch `raw/`.

---

## Steps

### 1. Index all wiki pages

Build a complete map of the vault:

```
for each .md file in superspec/wiki/ (excluding raw/, .obsidian/):
  - record: path, title, tags, created, updated dates
  - extract: all [[wikilinks]] referenced outward
  - extract: all `file path` references (backtick spans)
  - note: whether it appears in any other page as a [[wikilink]]
```

### 2. Run lint checks

#### 2a. Orphaned pages
A page is an orphan if no other wiki page links to it via `[[wikilink]]`.

Exception: `Home.md`, domain `Home.md` indexes, and `log.md` are not orphans by design.

#### 2b. Broken wikilinks
A `[[wikilink]]` that does not resolve to any `.md` file in the vault.

#### 2c. Missing cross-links
Page A mentions a topic that has its own wiki page B, but doesn't link to B.

Detection: for each page, check if its prose contains the exact title or common aliases of other wiki pages without a `[[wikilink]]`.

#### 2d. Contradictions
Two pages make conflicting factual claims about the same topic.

Detection: look for pages with overlapping tags or domains that assert opposite things about the same decision, pattern, or interface. Flag for human review — don't auto-resolve.

#### 2e. Stale file references
Backtick file paths (`` `src/auth/jwt.ts` ``) that no longer exist in the project filesystem.

Walk the actual project root and check each referenced path.

#### 2f. Outdated pages
Pages whose `updated:` date in frontmatter predates a related spec that was re-opened or re-shipped.

Cross-reference `superspec/wiki/_manifest.json` ingestion timestamps.

#### 2g. Missing frontmatter
Pages missing required YAML fields: `title`, `tags`, `created`, `updated`.

#### 2h. Undocumented domains
A domain folder exists in `wiki/` but has no `Home.md` index.

---

### 3. Write the lint report

Write `superspec/wiki/_lint-report.md` (overwrite on each run):

```markdown
---
title: Wiki Lint Report
generated: <YYYY-MM-DD HH:MM>
tags: [lint, health]
---

# Wiki Lint Report

Generated: <YYYY-MM-DD HH:MM>
Pages scanned: <N>

## Summary

| Check | Issues |
|-------|--------|
| Orphaned pages | N |
| Broken wikilinks | N |
| Missing cross-links | N |
| Contradictions | N |
| Stale file refs | N |
| Outdated pages | N |
| Missing frontmatter | N |
| Undocumented domains | N |

**Total issues: N** (<critical> critical, <warning> warnings)

---

## Orphaned Pages

> Pages with no inbound [[wikilinks]] from other wiki pages.

- [ ] `<domain>/<page>.md` — no inbound links _(fix: link from `<domain>/Home.md` or a related page)_

---

## Broken Wikilinks

> [[wikilinks]] that point to non-existent pages.

- [ ] `<page>.md` line 42: `[[<missing-page>]]` — target not found _(fix: create the page or correct the link)_

---

## Missing Cross-Links

> Page mentions a topic that has a wiki page but doesn't link to it.

- [ ] `<page-a>.md` mentions "<topic>" — should link to [[<domain>/<page-b>]]

---

## Contradictions

> Pages with conflicting claims. Requires human review.

- [ ] `<page-a>.md` says: "<claim A>"
      `<page-b>.md` says: "<claim B>"
      _(topic: <shared tag or topic>)_

---

## Stale File References

> Backtick file paths that no longer exist in the project.

- [ ] `<wiki-page>.md`: `` `<missing/file.ts>` `` — file not found

---

## Outdated Pages

> Pages whose `updated:` date predates a related re-ingested spec.

- [ ] `<domain>/<page>.md` — last updated <date>, but spec `<slug>` was re-ingested <later-date>

---

## Missing Frontmatter

> Pages missing required YAML fields.

- [ ] `<domain>/<page>.md` — missing: `title`, `updated`

---

## Undocumented Domains

> Domain folders without a Home.md index.

- [ ] `<domain>/` — no Home.md _(fix: create domain index)_

---

## Passed Checks

- ✓ <N> pages with complete frontmatter
- ✓ <N> wikilinks resolved correctly
- ✓ <N> file references verified
```

---

### 4. Append to log.md

```markdown
## [<YYYY-MM-DD>] lint | <N> issues found

- Pages scanned: <N>
- Critical: <N> | Warnings: <N>
- Report: [[_lint-report]]
```

---

### 5. Offer to fix

After producing the report, ask the user:

```
Wiki lint complete: N issues found (X critical, Y warnings).

Report: superspec/wiki/_lint-report.md

Would you like me to fix:
  [A] All auto-fixable issues (missing frontmatter, broken links with clear targets)
  [B] Specific issues (list which)
  [N] No — review manually in Obsidian

Contradictions always require your decision before I change anything.
```

If the user confirms fixes, apply them and append a `## [date] lint-fix` entry to `log.md`.

---

## Output

- `superspec/wiki/_lint-report.md` (overwritten)
- Appended `superspec/wiki/log.md`
- Optionally: fixed pages (with user confirmation)
