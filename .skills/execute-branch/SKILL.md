---
name: execute-branch
description: Create a git branch or worktree for isolated spec execution. One branch per spec. Triggers on /branch, "create branch", "set up worktree". Run after /pick-spec.
slash_command: branch
phase: "2.2 — Execute › Branch"
---

# Skill: execute-branch

You are creating an isolated execution environment for this spec.

**One branch per spec. No exceptions.** Isolation prevents parallel workstreams from interfering with each other.

## Steps

### 1. Check git status

```bash
git status
git branch --show-current
```

Verify:
- The working directory is clean (no uncommitted changes)
- We're on the correct base branch (usually `main` or `develop`)

If there are uncommitted changes, stop: *"Commit or stash changes before creating a branch."*

### 2. Determine branch name

Convention: `superspec/<slug>`

Examples:
- `superspec/auth-jwt`
- `superspec/export-csv`
- `superspec/payment-stripe`

### 3. Choose: branch or worktree

**Standard branch** (default, single workstream):
```bash
git checkout -b superspec/<slug>
```

**Git worktree** (parallel workstreams, recommended when executing multiple specs simultaneously):
```bash
git worktree add ../project-<slug> -b superspec/<slug>
```

Ask the user: *"Use a worktree for parallel execution, or a standard branch?"*

If worktree: note the path in `plan.md`.

### 4. Verify branch was created

```bash
git branch --show-current
# should output: superspec/<slug>
```

### 5. Update plan.md

Add to `superspec/phases/<slug>-execute/plan.md`:

```markdown
## Branch

Branch name: `superspec/<slug>`
Type: [branch | worktree]
Worktree path: <path if worktree, else N/A>
Created from: <base branch> @ <short SHA>
Created: <timestamp>
```

### 6. Update status.md

```markdown
## Phase
2.2 — Execute › Branch ✅

## Checklist
...
- [x] Branch created (superspec/<slug>)
...
```

### 7. Handoff

```
Branch ready: superspec/<slug>

Type: <branch/worktree>
Base: <base-branch> @ <SHA>

Next: /subagent <slug>   (to start Wave 1)
```

## Output

- Git branch `superspec/<slug>` created
- `superspec/phases/<slug>-execute/plan.md` updated with branch info
- Updated `superspec/specs/<slug>/status.md`
