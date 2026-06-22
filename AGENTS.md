# SuperSpecs — Agent Bootstrap

SuperSpecs: spec-driven planning + parallel TDD execution + wiki memory.

## Commands

**Claude Code / Cursor:** `/superspecs:<cmd>`
**OpenCode:** `/superspecs-<cmd>`

## Lifecycle (always in order)

**Phase 0 — Setup**
- `/superspecs:techstack` — questionnaire: define stack, get skill & library recommendations, save to wiki

**Phase 1 — Plan**
- `/superspecs:design-import <path>` — (optional) import DesignOS export → design-context.md; enriches /discuss + /spec with design constraints, data shapes, milestone structure, and test scaffolding
- `/superspecs:discuss` — capture decisions before planning; required before /spec
- `/superspecs:spec` — write spec (fits 200k context window); requires DISCUSS.md
- `/superspecs:grill` — mandatory gate: stress-test spec against wiki + techstack; READY verdict required before /pick-spec; requires spec.md

**Phase 2 — Execute**
- `/superspecs:pick-spec` — validate spec, check context fit
- `/superspecs:branch` — create branch/worktree
- `/superspecs:subagent` — fresh subagent per task; RED→GREEN→REFACTOR TDD runs inside each task
- `/superspecs:tdd` — invoke directly if writing code outside of subagent mode
- `/superspecs:code-review` — critical issues block progress

**Phase 3 — Verify**
- `/superspecs:verify` — full suite + scenario coverage (Stage 1), then compile feature to wiki (Stage 2); gate between stages blocks wiki import if tests fail

**Phase 4 — Ship**
- `/superspecs:ship` — PR, archive, next cycle

## Wiki Operations (run any time)
- `/superspecs:wiki-query` — tiered retrieval query; answer stays in context or files back as a page
- `/superspecs:wiki-lint` — health check: orphans, broken links, contradictions, stale refs
- `/superspecs:cross-linker` — auto-insert `[[wikilinks]]` for unlinked mentions
- `/superspecs:wiki-status` — vault dashboard: size, hubs, tags, provenance, pending sources
- `/superspecs:wiki-capture` — save session findings to wiki (`--quick` or `--full`)
- `/superspecs:tag-taxonomy` — canonical tag vocabulary; audit and normalize vault-wide
- `/superspecs:wiki-rebuild` — archive + rebuild vault; restore from snapshot

## Wiki Architecture (Karpathy LLM Wiki pattern)
```
superspec/wiki/raw/   ← immutable source material (agent reads, never edits)
superspec/wiki/       ← compiled knowledge base (agent writes)
superspec/wiki/log.md ← append-only activity log
.skills/verify-wiki/  ← schema: how to ingest, link, and format
```
Compile once → query fast. The agent reads `wiki/`, not `raw/`, at query time.

## Rules
- No implementation code before a failing test
- Critical review findings block all progress
- Spec must fit a fresh 200k context window
- Spec must pass grill before execution
- Every shipped feature → wiki page
- Wiki query reads compiled `wiki/` only — never raw specs

## Paths
- `superspec/specs/` — specs + DISCUSS.md files
- `superspec/phases/` — execution working dirs
- `superspec/wiki/raw/` — immutable source material
- `superspec/wiki/` — compiled knowledge base (Obsidian vault)
- `superspec/wiki/log.md` — append-only activity log
- `.skills/` — skill definitions (schema layer)
