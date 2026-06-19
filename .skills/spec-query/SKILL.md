---
name: spec-query
description: Query the project specs and wiki together to find past decisions, patterns, and knowledge. Use before starting a new feature, when triggered by /spec:query, or when the user asks "what do we know about X" or "have we built X before".
slash_command: spec:query
---

# Skill: spec-query

You are querying the project's combined knowledge: specs + wiki.

Use this before planning any new feature, and whenever a question could be answered by past work.

## Search Strategy

### 1. Parse the query

Identify:
- **Domain keywords** (auth, payment, export, etc.)
- **Concept type** (pattern, decision, implementation, API)
- **Time signal** (past, current, planned)

### 2. Search specs

Look in `superspec/specs/`:

```
- List all spec directories
- For each potentially relevant spec, read spec.md
- Note: requirements that match, decisions made, scenarios defined
```

### 3. Search wiki

Look in `superspec/wiki/`:

```
- Read _index.md to orient
- Read pages in relevant domain folders
- Follow wikilinks to related pages
- Note: patterns, decisions, gotchas
```

### 4. Search changes

Look in `superspec/changes/`:

```
- Find change IDs related to the query domain
- Read design.md for relevant changes
- Note: alternatives considered, trade-offs
```

### 5. Synthesize the answer

Present findings clearly:

```markdown
## Query: "<user's question>"

### Found in Specs
- **<spec slug>** (`superspec/specs/<slug>/spec.md`)
  Relevant: <what's relevant>

### Found in Wiki
- **[[<page>]]** (`superspec/wiki/<path>`)
  <Summary of relevant knowledge>

### Decisions Made
- We chose <X> over <Y> because <reason> (from change `<change-id>`)

### Patterns Available
- <Pattern name>: <brief description>
  See: [[<wiki page>]]

### Not Found
<If the query has no match, say so clearly>
```

### 6. Suggest next steps

If the query is about a new feature:
```
This area has no prior specs. Consider: /spec:plan <suggested slug>
```

If the query is about extending existing work:
```
Related spec exists: /spec:propose <slug> to plan an extension
```

## Speed mode

If the user says "quick" or "just scan", do a fast pass:
- Read only wiki page summaries (frontmatter + first paragraph)
- Skip design.md files
- Give a shorter answer

## Output

Synthesized answer with references to specific files and pages.
No hallucination: if it's not in the specs or wiki, say so.
