---
name: wiki-query
description: Query the compiled project wiki to answer a question. Synthesizes answers from existing wiki pages — not from raw specs or the internet. Optionally files the answer back as a new wiki page. Triggers on /wiki-query, "search the wiki for...", "what does the wiki say about...", "ask the wiki".
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

## Steps

### 1. Receive the question

The user provides a question, topic, or keyword. Examples:
- "What do we know about authentication?"
- "What was the decision on database choice?"
- "What patterns do we use for error handling?"
- "Find everything about the payment integration"

---

### 2. Search the compiled wiki

Read `superspec/wiki/Home.md` and `superspec/wiki/log.md` first to orient.

Then search:
- Domain `Home.md` indexes for matching domains
- Pages with matching `tags:` in frontmatter
- Pages whose title or `## Summary` contains query keywords
- `[[wikilinks]]` chains — follow related pages one level deep

Collect all relevant pages.

---

### 3. Synthesize the answer

Write a synthesized answer **in your response** (not to a file by default):

```
## Answer: <query topic>

<2–4 paragraph synthesis drawn from the wiki>

### Sources
- [[<domain>/<page>]] — <one-line summary of what it contributed>
- [[<domain>/<page2>]] — <one-line summary>

### Gaps
<If the wiki doesn't have full coverage, say so clearly:>
"The wiki has no pages about <X>. If this was covered in a spec, run /wiki to compile it first."
```

**Cite only wiki pages** — not raw spec files, not source code files.

---

### 4. Optionally file the answer back

After answering, offer:

```
File this answer to the wiki?
  [Y] Yes — create wiki/<domain>/<topic>.md
  [U] Update an existing page instead
  [N] No — one-off answer only
```

If the user confirms, write the page using the standard wiki page format:

```markdown
---
title: <Topic>
tags: [<domain>, query-derived]
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
---

# <Topic>

> Compiled in response to query: "<original question>"

## Summary
<synthesis>

## Sources
- [[<page1>]] — <what it contributed>
- [[<page2>]] — <what it contributed>

## Related
- [[<related-page>]]
```

Then:
- Update the relevant domain `Home.md` to list the new page
- Append to `log.md`: `## [YYYY-MM-DD] query | <topic>`
- If the new page fills a gap: note it as a candidate for deeper treatment next `/wiki` run

---

### 5. Signal gaps clearly

If the wiki lacks coverage for the query:

```
The wiki doesn't have pages about "<X>" yet.

This means either:
  a) The feature hasn't been shipped yet (no spec/execution cycle completed)
  b) The feature was shipped but not imported — run: /wiki <slug>
  c) The knowledge lives only in raw/ — run: /wiki-ingest to compile it

I found partial coverage in: [[<related-page>]]
```

---

## Output

- Synthesized answer in the response
- Optionally: new wiki page in `superspec/wiki/<domain>/<topic>.md`
- Optionally: updated domain `Home.md`
- Optionally: appended `superspec/wiki/log.md`
