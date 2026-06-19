# SuperSpecs — Agent Bootstrap

SuperSpecs is installed in this project. It is a unified AI development framework combining spec-driven planning (OpenSpec pattern), TDD implementation (Superpowers methodology), and living wiki memory (Karpathy LLM Wiki pattern).

## Lifecycle

Before writing any code:

1. `/spec:plan <feature>` — Clarify goals, query wiki, write spec
2. `/spec:propose <feature>` — Reviewable proposal before any code
3. `/spec:implement <feature>` — TDD subagent implementation  
4. `/spec:review <feature>` — Dual-pass review
5. `/spec:wiki <feature>` — Sync to wiki after shipping
6. `/spec:query <question>` — Query specs + wiki

## Rules

- Never implement without a reviewed spec
- Write failing tests before implementation code
- Run tests and verify they pass before proceeding
- After every feature ships: sync to wiki
- Before every feature starts: query the wiki

## Paths

- `superspec/specs/` — Specifications
- `superspec/changes/` — Proposals
- `superspec/wiki/` — Knowledge base
- `.skills/` — Skill definitions

Skills are in `.skills/` and in `~/.agents/skills/superspecs/`.
