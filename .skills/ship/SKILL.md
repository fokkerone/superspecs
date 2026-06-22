---
name: ship
description: Create the PR, write the changelog entry, archive the phase directory, mark the spec complete, and trigger the next cycle. Triggers on /ship, "create PR", "ship it", "merge". Final step in the SuperSpecs lifecycle.
slash_command: ship
phase: "4 — Ship"
---

# Skill: ship

You are shipping the feature. Final step.

**Preconditions — verify before proceeding:**
- [ ] Tests passing + wiki imported (Phase 3 complete)
- [ ] No open Critical review findings
- [ ] Branch is on `superspec/<slug>` with all commits

If any precondition fails, stop and name the missing step.

## Steps

### 1. Final diff review

```bash
git log main..superspec/<slug> --oneline
git diff main..superspec/<slug> --stat
```

Show a summary: how many files changed, how many commits. No surprises.

### 2. Write the PR description

```markdown
## <Feature Name>

### What
<1–2 paragraphs: what was built, from the user/system perspective>

### Why
<The problem this solves, from DISCUSS.md>

### How it works
<Brief technical summary — key decisions, architecture shape>

### Tests
- Suite: X tests, all passing
- New tests: Y (covering N spec scenarios)

### Spec
`superspec/specs/<slug>/spec.md`

### Wiki
<links to new wiki pages>

### Checklist
- [x] Tests passing
- [x] Spec scenarios covered
- [x] Code review passed
- [x] Wiki updated
- [x] No regressions
```

### 3. Create the PR

Instruct the user (or if gh CLI is available):

```bash
gh pr create \
  --base main \
  --head superspec/<slug> \
  --title "<Feature Name>" \
  --body-file /tmp/pr-body.md
```

Or: output the PR body and say *"Create the PR with this description."*

### 4. Write changelog entry

If the project has a `CHANGELOG.md`:

```markdown
## [Unreleased]

### Added
- <Feature description> (closes #<issue if applicable>)
```

### 5. Archive the phase directory

```bash
mkdir -p superspec/archive
mv superspec/phases/<slug>-execute superspec/archive/<slug>-execute
```

### 6. Mark spec complete

Update `superspec/specs/<slug>/status.md`:

```markdown
## Phase
4 — Shipped ✅

## Completed
<date>

## PR
<PR URL or number>

## Checklist
- [x] Discussion complete (DISCUSS.md)
- [x] Spec written
- [x] Spec fits context window
- [x] Branch created
- [x] Subagent execution complete
- [x] All tests passing
- [x] Code review passed (no Critical findings)
- [x] Wiki imported
- [x] PR created
- [x] Archived

## Wiki Pages
- [[superspec/wiki/<domain>/<page>]] — <description>
```

### 7. Trigger next cycle

```
Shipped: <slug> ✅

PR: <url or "ready to create">
Tests: X passing
Wiki: Y pages
Archive: superspec/archive/<slug>-execute/

─────────────────────────────────
What's next?

Available specs ready to execute:
<list specs in planning or proposed state>

Or start a new feature: /superspecs-discuss
```

## Output

- PR created (or PR body ready)
- `CHANGELOG.md` updated
- `superspec/phases/<slug>-execute/` → `superspec/archive/<slug>-execute/`
- `superspec/specs/<slug>/status.md` marked complete
- Prompt to start next cycle
