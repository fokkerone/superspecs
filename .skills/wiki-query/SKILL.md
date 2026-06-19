---
name: wiki-query
description: Query the compiled project wiki to answer a question. Uses tiered retrieval — summaries first, full pages only when needed. Synthesizes answers from existing wiki pages only, never from raw specs or the internet. Optionally files the answer back as a new wiki page. Triggers on /wiki-query, "search the wiki for...", "what does the wiki say about...", "ask the wiki".
slash_command: wiki-query
phase: "3.2 — Verify › Wiki Query"
---

# Skill: wiki-query

You are answering a question using the compiled project wiki.

The wiki at `superspec/wiki/` is a compiled knowledge base. It has already processed the raw specs, decisions, and review logs. **Read the wiki, not the raw sources.** This is the key efficiency of the LLM Wiki pattern: compile once, query fast.

---

## The 3-Layer Context

```
superspec/wiki/raw/     ← source material (ingest reads this; query does NOT)
superspec/wiki/         ← compiled wiki (query reads this exclusively)
.skills/wiki-query/     ← schema: these instructions
```

**Never read `raw/` to answer a query.** If the answer isn't in `wiki/`, the knowledge hasn't been compiled yet — that's a signal to run `/wiki` first.

---

## Tiered Retrieval

Query in two phases to keep cost flat as the vault grows:

### Phase 1 — Index scan (cheap)

Read only the frontmatter of every wiki page (excluding `raw/`, `.obsidian/`):
- `title`
- `summary` (1–2 sentence preview)
- `tags`

Also read:
- `superspec/wiki/Home.md` — domain table and recent updates
- `superspec/wiki/log.md` — recent activity

Score each page for relevance to the query. Select the top 3–5 candidates.

**If the user says "quick answer" or "just scan":** answer from Phase 1 only — do not open page bodies.

### Phase 2 — Deep read (targeted)

Open the full body of the top 3–5 candidate pages only. Read:
- All sections
- Follow `[[wikilinks]]` to directly related pages (one level deep)

Synthesize the answer from Phase 2 content.

---

## Steps

### 1. Receive the question

The user provides a question, topic, or keyword. Examples:
- "What do we know about authentication?"
- "What was the decision on database choice?"
- "What patterns do we use for error handling?"
- "Find everything about the payment integration"

---

### 2. Phase 1 — Index scan

For each wiki page, read frontmatter only. Score relevance:
- Title contains query keyword → high relevance
- `tags:` overlap with query topic → medium relevance
- `summary:` contains query concept → medium relevance

Select top 3–5 by relevance score. If Phase 1 returns zero candidates → signal gap (Step 5).

---

### 3. Phase 2 — Deep read

Open full body of top candidates. Follow `[[wikilinks]]` one level deep for directly linked pages.

Collect all relevant content. Note provenance markers:
- No marker = extracted from source
- `^[inferred]` = agent synthesis
- `^[ambiguous]` = sources disagree — flag this in the answer

---

### 4. Synthesize the answer

Write a synthesized answer **in your response**:

```
## Answer: <query topic>

<2–4 paragraph synthesis drawn from the wiki>

### Sources
- [[<domain>/<page>]] — <one-line summary of what it contributed>
- [[<domain>/<page2>]] — <one-line summary>

### Inferred content
<If any part of the answer is marked ^[inferred] or ^[ambiguous], call it out:>
"Note: the claim about X is inferred synthesis, not stated verbatim in sources."

### Gaps
<If the wiki doesn't have full coverage:>
"The wiki has no pages about <X>. If this was covered in a spec, run /wiki to compile it first."
```

**Cite only wiki pages** — not raw spec files, not source code files.

---

### 5. Signal gaps clearly

If Phase 1 returns no relevant pages:

```
The wiki doesn't have pages about "<X>" yet.

This means either:
  a) The feature hasn't been shipped yet (no spec/execution cycle completed)
  b) The feature was shipped but not imported — run: /wiki <slug>
  c) The knowledge lives only in raw/ — it hasn't been compiled yet

I found partial coverage in: [[<related-page>]] (if any)
```

---

### 6. Optionally file the answer back

After answering, offer:

```
File this answer to the wiki?
  [Y] Yes — create wiki/<domain>/<topic>.md
  [U] Update an existing page instead
  [N] No — one-off answer only
```

If the user confirms, write the page using the standard wiki page format including `summary:` and `provenance:` fields. Mark synthesized content as `^[inferred]`. Then:
- Update the relevant domain `Home.md`
- Append to `log.md`: `## [YYYY-MM-DD] query | <topic>`
- Run `/cross-linker` to weave new page into the knowledge graph

---

## Output

- Synthesized answer in the response
- Optionally: new wiki page in `superspec/wiki/<domain>/<topic>.md`
- Optionally: updated domain `Home.md`
- Optionally: appended `superspec/wiki/log.md`
