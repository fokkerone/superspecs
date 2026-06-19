---
name: wiki-capture
description: Save findings from the current session directly to the wiki. Bugs fixed, decisions made, patterns discovered, gotchas hit. Quick mode stages a draft to raw/ for later ingest. Full mode distills directly to wiki pages. Triggers on /wiki-capture, "save to wiki", "capture this session", "note this for the wiki".
slash_command: wiki-capture
phase: "3.2 — Verify › Wiki Capture"
---

# Skill: wiki-capture

You are capturing knowledge from the current session before it disappears.

The context window is ephemeral. This skill saves what's worth keeping — decisions made, bugs fixed, patterns discovered, gotchas hit — directly to the wiki or to `raw/` for later ingest.

Use this mid-session when something important happened that shouldn't be lost.

---

## Modes

### `--quick` (default)
Stage a structured draft to `superspec/wiki/raw/capture-<YYYY-MM-DD-HH-MM>.md`.  
Fast: no subagent, no manifest update, no cross-linking.  
The next `/wiki` or `/wiki-ingest` run will promote the raw file to proper pages.

### `--full`
Distill directly to proper wiki pages. Follows the full ingest process from `verify-wiki`.  
Use when the session produced significant, self-contained knowledge worth filing immediately.

---

## Steps

### 1. Scan the current session

Review what happened in this session. Extract the following (drop noise):

**Worth capturing:**
- Decisions made (what was chosen, why, what was traded away)
- Bugs found and fixed (what the bug was, root cause, fix)
- Patterns established or discovered
- Gotchas — things that took longer than expected
- Interface or contract changes
- Open questions that arose but weren't resolved

**Drop:**
- Step-by-step implementation details already in code
- Routine task execution
- Anything that's obvious from reading the code

---

### 2. Quick mode — stage to raw/

Create `superspec/wiki/raw/capture-<YYYY-MM-DD-HH-MM>.md`:

```markdown
---
capture_date: <YYYY-MM-DD HH:MM>
session_context: <brief description of what this session was about>
promote: true
---

# Session Capture: <YYYY-MM-DD>

## Decisions

### <Decision>
**Chose:** <X>
**Over:** <Y>
**Because:** <reason>

## Bugs Fixed

### <Bug title>
**Symptom:** <what it looked like>
**Root cause:** <why it happened>
**Fix:** <what resolved it>
**Gotcha:** <anything surprising>

## Patterns

### <Pattern name>
<What the pattern is and when to use it>

## Open Questions

- [ ] <Question that came up but wasn't resolved>

## Files touched
- `<path/to/file>` — <what changed and why>
```

Print:
```
Captured to superspec/wiki/raw/capture-<timestamp>.md

Run /wiki to promote to proper wiki pages.
Or the next /wiki <slug> run will pick it up automatically.
```

---

### 3. Full mode — distill to wiki pages

Follow the full ingest process from `verify-wiki`:

1. Determine which domain(s) the captured knowledge belongs to
2. Check existing pages — update rather than duplicate
3. Write/update pages with full frontmatter including `summary:`, `provenance:`
4. Mark inferred content `^[inferred]`
5. Update domain `Home.md` and vault `Home.md`
6. Append to `log.md`: `## [YYYY-MM-DD] capture | <topic>`
7. Suggest running `/cross-linker` to weave new pages in

---

### 4. Always suggest

After either mode:
```
Consider also running:
  /cross-linker    Auto-weave [[wikilinks]] across the vault
  /wiki-status     See what's now in the wiki
```

---

## Output

**Quick mode:**
- `superspec/wiki/raw/capture-<timestamp>.md`

**Full mode:**
- New/updated wiki pages
- Updated `Home.md` files
- Appended `log.md`
