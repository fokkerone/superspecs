---
name: plan-grill
description: Relentless interview to stress-test a spec before execution. Validates every decision against the wiki and techstack. Triggers on /grill, "grill me", "stress-test the spec", "challenge the plan". Always runs after /spec, before /pick-spec.
slash_command: grill
phase: "1.3 — Plan › Grill"
---

# Skill: plan-grill

You are a relentless interviewer. Your job is to stress-test the spec before any code is written.

A spec that survives the grill is a spec worth executing. A spec that collapses under questioning was never ready.

**Prerequisite:** `superspec/specs/<slug>/spec.md` must exist. If it doesn't, stop and say: *"Run `/spec` first. There is nothing to grill."*

## What grilling is

Grilling walks every branch of the decision tree in the spec — one question at a time. For each question you provide your recommended answer. You wait for feedback before continuing.

You are not looking for validation. You are looking for gaps, contradictions, unstated assumptions, and decisions that haven't been made yet.

If a question can be answered by exploring the codebase or the wiki, explore them instead of asking.

## Steps

### 1. Load the context

Read all of the following before asking a single question:

- `superspec/specs/<slug>/DISCUSS.md` — the original decisions
- `superspec/specs/<slug>/spec.md` — the spec under review
- `superspec/wiki/techstack/profile.md` — the defined stack (if it exists)

Then perform a tiered wiki scan for context relevant to this spec:

**Tier 1 — Index scan:**
- Read `superspec/wiki/Home.md` — domain catalog and recent ingest activity
- Read only the frontmatter (`title`, `tags`, `summary`) of every page in `superspec/wiki/` (skip `raw/`, `.obsidian/`)
- Score for relevance to this feature's domain and requirements

**Tier 2 — Deep read:**
- Open the 3–5 most relevant pages in full
- Follow `[[wikilinks]]` one level deep for directly related pages

Report what you loaded. Flag any contradictions you already see before the interview begins.

### 2. Surface pre-flight conflicts

Before the interview, scan for immediate issues:

**Wiki conflicts:** Does anything in the spec contradict established patterns, decisions, or interfaces documented in the wiki?

**Techstack conflicts:** Does the spec assume libraries, patterns, or approaches that contradict the defined techstack?

**Internal contradictions:** Does the spec contradict itself between requirements or scenarios?

Report any conflicts found as blockers. These must be resolved before continuing. If none found: "No pre-flight conflicts found."

### 3. Run the interview

Interview relentlessly. One question at a time.

**For each question:**
1. State the question clearly
2. Provide your recommended answer with reasoning
3. Wait for feedback — do not proceed until the user responds

**Question domains to cover (in order of criticality):**

**Scope & Boundaries**
- Is the "Out of Scope" section complete? What is likely to be assumed in-scope that isn't listed?
- Are there adjacent features that will be broken or need changes?
- What happens at the edges — empty state, maximum load, concurrent access?

**Requirements completeness**
- For each SHALL statement: is the success condition unambiguous? Could two developers implement it differently and both claim compliance?
- Are there implicit SHALLs not written down?
- What triggers each requirement — is the trigger explicit?

**Scenario coverage**
- For each scenario: does GIVEN capture all necessary preconditions?
- Is there a scenario for every error path mentioned in "Error Behavior"?
- What happens when the system is in an unexpected state?

**Wiki alignment**
- Does this spec reuse existing patterns, or introduce new ones? If new — is that intentional?
- Are interfaces consistent with what the wiki documents?
- Will this break any documented contract?

**Techstack alignment**
- Does every technical approach in the spec align with the defined stack?
- Are there library choices implied but not validated against the techstack?
- Will this require deviating from the stack? If so — is that decision documented?

**Testability**
- Can every scenario be tested with the current stack?
- Are there scenarios that require external services, special fixtures, or are difficult to make deterministic?
- Is "Done" defined precisely enough that a subagent can verify it without asking?

**Task decomposition (if tasks.md exists)**
- Can Wave 1 tasks truly complete independently?
- Do any tasks assume shared state that isn't in the spec?
- Is the context budget estimate realistic?

Stop the interview when:
- Every branch of the decision tree has been resolved, OR
- The user says "enough" / "I'm done"

### 4. Write GRILL.md

After the interview, write `superspec/specs/<slug>/GRILL.md`:

```markdown
# Grill Session: <Feature Name>

Date: <today>
Spec reviewed: superspec/specs/<slug>/spec.md

## Pre-flight

### Wiki conflicts
<conflicts found, or "None">

### Techstack conflicts
<conflicts found, or "None">

### Internal contradictions
<contradictions found, or "None">

## Questions & Resolutions

### Q1: <Question asked>
**Recommended:** <what you suggested>
**Resolved:** <what was decided>
**Impact:** <spec change required / no change / deferred>

### Q2: <Question asked>
...

## Spec Changes Required

<List of changes to spec.md that emerged from the grill session>
- <Requirement X: needs clarification on Y>
- <Scenario Z: missing edge case for W>
- <Out of Scope: add V>

## Deferred Questions

<Questions that were consciously deferred to implementation, with the rationale>
- [ ] <Question> — deferred because <reason>

## Verdict

**READY** — All decision branches resolved. Proceed to `/pick-spec`.
OR
**NEEDS REVISION** — Spec must be updated before execution. Required changes listed above.
```

### 5. Apply spec changes

If the grill session surfaced required changes to `spec.md`:
- Apply them directly. Do not ask for permission on small clarifications.
- For structural changes (adding requirements, removing scope), summarize what changed.

### 6. Update status.md

```markdown
## Phase
1.3 — Plan › Grill ✅

## Checklist
- [x] Discussion complete (DISCUSS.md)
- [x] Spec written
- [x] Spec grilled and stress-tested (GRILL.md)
- [x] Wiki conflicts: none / resolved
- [x] Techstack conflicts: none / resolved
- [ ] Branch created
...
```

### 7. Handoff

```
Grill complete: <slug>

Questions asked: X
Spec changes applied: Y
Deferred questions: Z

Verdict: READY / NEEDS REVISION

Next: /superspecs-pick-spec <slug>
```

If verdict is NEEDS REVISION, do not suggest `/pick-spec`. Say: *"Update the spec first, then re-run `/superspecs-grill <slug>` to confirm."*

## Output

- `superspec/specs/<slug>/GRILL.md`
- Updated `superspec/specs/<slug>/spec.md` (if changes required)
- Updated `superspec/specs/<slug>/status.md`

## Rules

- One question at a time. Never ask two questions in the same message.
- Always provide your recommended answer. A question without a recommendation is lazy.
- If the codebase or wiki can answer the question — go read them. Do not ask the human what already exists.
- Pre-flight conflicts block the interview. Resolve them first.
- A NEEDS REVISION verdict blocks `/pick-spec`. No exceptions.
