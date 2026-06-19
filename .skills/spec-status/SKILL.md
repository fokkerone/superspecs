---
name: spec-status
description: Show a dashboard of all features and their current SuperSpecs phase. Use when triggered by /spec:status or when the user asks "what are we working on" or "what's the status".
slash_command: spec:status
---

# Skill: spec-status

Generate a dashboard of all features in the project.

## Steps

### 1. Scan all specs

List all directories in `superspec/specs/`. For each, read `status.md`.

### 2. Scan active changes

List all directories in `superspec/changes/`. Note which are linked to specs.

### 3. Scan wiki

Count pages in `superspec/wiki/`, read `_index.md`.

### 4. Render dashboard

```markdown
# SuperSpecs Dashboard

## Active Features

| Feature | Phase | Next Action |
|---------|-------|-------------|
| <slug> | 🔵 planning | /spec:propose <slug> |
| <slug> | 🟡 proposed | /spec:implement <change-id> |
| <slug> | 🟠 implementing | /spec:review <change-id> |
| <slug> | 🟣 reviewing | /spec:wiki <slug> |
| <slug> | ✅ complete | — |

## Wiki
Pages: X | Domains: Y | Last updated: <date>

## Change History (last 5)
- <date> <slug> → <phase>
```

Phase icons:
- 🔵 planning — spec written, not yet proposed
- 🟡 proposed — proposal ready, awaiting implementation
- 🟠 implementing — TDD in progress
- 🟣 reviewing — implementation done, review in progress
- 🟢 wiki-sync — syncing to wiki
- ✅ complete — shipped and documented
