---
name: spec-complete
description: Mark a feature as complete — final status update, archive the change, and confirm wiki is current. Use when triggered by /spec:complete after wiki sync is done.
slash_command: spec:complete
---

# Skill: spec-complete

Mark a feature as complete. Final step in the SuperSpecs lifecycle.

## Preconditions

Before marking complete, verify:
- [ ] All tasks in `tasks.md` are checked
- [ ] All tests passing
- [ ] Review passed (Pass 1 + Pass 2)
- [ ] Wiki sync completed (pages exist in `superspec/wiki/`)

If any are missing, report what's needed before proceeding.

## Steps

### 1. Final spec update

Update `superspec/specs/<slug>/spec.md` if the implementation revealed anything the spec missed. The spec should reflect what was actually built.

### 2. Update status.md to complete

```markdown
# <Feature Name> — Status

## Phase
complete ✅

## Completed
<date>

## Checklist
- [x] Spec written
- [x] Proposal generated
- [x] Proposal reviewed
- [x] Implementation started
- [x] Tests passing
- [x] Review passed
- [x] Wiki synced
- [x] Complete

## Wiki References
- [[superspec/wiki/<domain>/<page>]] — <what it covers>

## Change History
- <date>: Spec created
- <date>: Proposed (<change-id>)
- <date>: Implementation complete
- <date>: Review passed
- <date>: Wiki synced
- <date>: Marked complete ✅
```

### 3. Archive the change

Move `superspec/changes/<change-id>/` to `superspec/changes/archive/<change-id>/`.

### 4. Confirm

```
Feature complete: <slug>

✅ Spec: superspec/specs/<slug>/spec.md
✅ Tests: passing
✅ Review: passed
✅ Wiki: X pages in superspec/wiki/

Change archived: superspec/changes/archive/<change-id>/

Ready for the next feature. Start with: /spec:plan <new feature>
```
