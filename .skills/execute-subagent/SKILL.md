---
name: execute-subagent
description: Dispatch fresh subagents per task for parallel execution. Each subagent runs RED-GREEN-REFACTOR TDD on their task. Two-stage review per task. Human checkpoints between waves. Triggers on /subagent, "start executing", "run the tasks", "dispatch agents". Run after /branch.
slash_command: subagent
phase: "2.3 — Execute › Subagent Development"
---

# Skill: execute-subagent

You are orchestrating subagent-driven execution.

Each subagent gets a **clean 200k-token context**: the spec, one task, and the codebase. Nothing else. No prior chat history. No shared state.

**TDD is not a separate step after subagent development. TDD happens inside every subagent task.** Each task follows RED → GREEN → REFACTOR before it is considered done. The `/superspecs:tdd` skill defines the cycle; this skill embeds it into every task.

## Core Principles

- **Fresh context per task.** Each subagent starts clean.
- **TDD per task.** Every task: RED → GREEN → REFACTOR → commit. No exceptions.
- **Two-stage review per task.** Every task gets reviewed for spec compliance first, then code quality.
- **Human checkpoints between waves.** No wave starts without human approval.
- **Critical findings block progress.** A Critical issue in code review stops the wave.

## Steps

### 1. Read the execution plan

Read `superspec/phases/<slug>-execute/plan.md` and `superspec/specs/<slug>/tasks.md`.

Identify:
- The current wave (which one hasn't started yet)
- Tasks in this wave
- Whether they're sequential or parallel

### 2. Prepare subagent context package

For each task in this wave, assemble the context package. This is what each subagent receives — and ONLY this:

```markdown
# Subagent Context: <Task ID>

## Spec
<full contents of spec.md>

## Your Task
<single task block from tasks.md>

## Codebase State
Branch: superspec/<slug>
Relevant files: <list files the task touches>

## TDD — Non-Negotiable
You follow RED → GREEN → REFACTOR for every piece of implementation code.

**RED**
1. Write a failing test for the behavior described in your task
2. Run it — confirm it fails for the RIGHT reason (feature missing, not a syntax error)
   - If it passes immediately: the test is wrong. Rewrite it.
   - If it fails for the wrong reason: fix the test, not the implementation.

**GREEN**
3. Write the minimum code to make the test pass
   - No YAGNI additions. No refactoring yet.
4. Run the test — confirm PASS
5. Run the full test suite — confirm no regressions

**REFACTOR**
6. Clean up: duplication, naming, complexity — keep tests green throughout
7. Run the full suite after each refactor step

**COMMIT**
8. `git commit -m "task <task-id>: <description>"`

**Code written before a failing test exists gets deleted. Start over from RED.**

## Done When
<done criteria from tasks.md for this task>
```

### 3. Execute the wave

#### Sequential tasks
Execute task by task. For each task, the subagent follows the full TDD cycle (RED-GREEN-REFACTOR) as defined in the context package above. After TDD is complete:
1. Run `/code-review` (see code-review skill)
2. If Critical finding: STOP. Report. Wait for resolution.
3. If no Critical finding: proceed to next task.

#### Parallel tasks
For tasks that can run in parallel (stated in plan.md):

Note: true parallel execution requires multiple worktrees or the user to manually run tasks in separate terminals. In single-agent mode, execute tasks sequentially but treat them as logically independent.

Document in `wave-<N>.md` which tasks were parallelizable.

### 4. Track progress in wave-N.md

Create `superspec/phases/<slug>-execute/wave-<N>.md`:

```markdown
# Wave <N>: <Name>

Started: <timestamp>

## Task Status

| Task | Status | Review | Notes |
|------|--------|--------|-------|
| 1.1 | ⏳ in progress | — | |
| 1.2 | ✅ done | ✅ passed | |
| 1.3 | ❌ blocked | ⚠️ critical finding | <issue> |

## Review Log Summary
(populated by /code-review)

## Completed: <timestamp>
```

### 5. Human checkpoint

After the wave completes (all tasks done, no Critical findings):

```
Wave <N> complete: <slug>

Tasks: X/X ✅
Review findings:
  - Critical: 0
  - High: <N> (resolved)
  - Medium: <N> (noted)
  - Low: <N> (noted)

Tests: X passing

Ready for Wave <N+1>?
Show me the diff first, or type '/subagent <slug>' to continue.
```

**Wait for human approval before starting the next wave.**

### 6. Final wave complete

After all waves are done:

```
All waves complete: <slug>

Total tasks: X
Review findings resolved: Y
Tests: X passing

Next: /check-tests <slug>
```

Update `superspec/specs/<slug>/status.md`:
```markdown
## Phase
2.3–2.5 — Execute ✅
```

## Batch Mode (alternative to wave mode)

If the user says "batch mode", run all waves without human checkpoints between waves, but still run code review between tasks. Stop only on Critical findings.

## Output

- All task implementations committed to `superspec/<slug>` branch
- `superspec/phases/<slug>-execute/wave-<N>.md` for each wave
- `superspec/phases/<slug>-execute/review-log.md` populated
- Updated status
