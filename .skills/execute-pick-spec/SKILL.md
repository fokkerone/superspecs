---
name: execute-pick-spec
description: Choose and validate the next spec for execution. Verifies the spec is complete, dependencies are met, and it fits a clean 200k context window. Triggers on /pick-spec, "what should we build next", "start execution".
slash_command: pick-spec
phase: "2.1 — Execute › Pick Spec"
---

# Skill: execute-pick-spec

You are selecting the next spec to execute. This is the gate between planning and execution.

**Nothing is dispatched to subagents until this step passes.**

## Steps

### 1. List available specs

Scan `superspec/specs/`. For each directory, read `status.md` and categorize:

```
Ready to execute (spec written, not yet started):
  - <slug> — <purpose> — context: ~Xk

In progress:
  - <slug> — <phase>

Complete:
  - <slug>
```

If the user specified a slug, jump to step 3 with that slug.

If multiple specs are ready, present the list and ask which to pick.

### 2. Check dependencies

Read the spec's `spec.md`. Look for the `Depends on:` field.

For each dependency:
- Is there a spec for it in `superspec/specs/`?
- Is that spec complete (shipped)?

If unmet dependencies exist:
```
Cannot execute <slug> yet.
Depends on: <dep-slug> (status: <status>)

Options:
1. Execute <dep-slug> first
2. Remove the dependency if it's not actually needed (update spec)
```

Do not proceed until dependencies are resolved.

### 3. Validate the spec

Read `spec.md` and `tasks.md` completely. Check:

**Completeness**
- [ ] Every requirement has at least one scenario
- [ ] Every scenario is testable (concrete GIVEN/WHEN/THEN)
- [ ] tasks.md exists with at least one task
- [ ] Done criteria defined

**Clarity**
- [ ] No ambiguous SHALL statements
- [ ] No tasks that say "implement X" without specifying the test requirement
- [ ] No tasks that depend on unwritten decisions

**Context window**
- Estimate: `spec.md` (~Xk) + `tasks.md` (~Yk) + typical implementation context (~Zk)
- Total must be under 200k
- Report: `Context budget: ~<total>k / 200k`

If validation fails, list specific issues and say: *"Fix these before execution begins."*

### 4. Create the phase directory

Create `superspec/phases/<slug>-execute/`:

```
superspec/phases/<slug>-execute/
├── plan.md          ← execution plan (written here)
├── review-log.md    ← code review findings (populated during execution)
└── wave-1.md        ← populated when Wave 1 starts
```

### 5. Write plan.md

```markdown
# Execution Plan: <Feature Name>

**Spec:** superspec/specs/<slug>/spec.md
**Tasks:** superspec/specs/<slug>/tasks.md
**Context estimate:** ~<N>k / 200k ✅
**Started:** <date>

## Execution Strategy

Wave execution order: Wave 1 → Wave 2 → Wave 3
Parallelism: [list tasks that can run in parallel within each wave]

## Wave Summary

### Wave 1 — <Name>
Sequential / Parallel: <which>
Tasks: 1.1, 1.2, ...
Unblocks: Wave 2

### Wave 2 — <Name>
Sequential / Parallel: <which>
Tasks: 2.1, 2.2, ...
Unblocks: Wave 3

### Wave 3 — <Name>
Tasks: 3.1, ...

## Executor Instructions

Each subagent receives:
1. spec.md (full)
2. tasks.md (their task only)
3. The codebase (branch: <branch-name>)
4. No prior chat history

## Human Checkpoints
- After Wave 1: review and approve before Wave 2
- After Wave 2: review and approve before Wave 3
- After Wave 3: full verification before ship
```

### 6. Update status.md

```markdown
## Phase
2.1 — Execute › Pick Spec ✅

## Checklist
...
- [x] Spec fits context window (~Nk / 200k)
- [ ] Branch created
...
```

### 7. Handoff

```
Spec validated: <slug>

Dependencies: ✅ met
Context: ~<N>k / 200k ✅
Tasks: X across Y waves
Validation: ✅ complete

Next: /branch <slug>
```

## Output

- `superspec/phases/<slug>-execute/plan.md`
- `superspec/phases/<slug>-execute/review-log.md` (empty template)
- Updated `superspec/specs/<slug>/status.md`
