---
name: skill-creator
description: Create a new SuperSpecs skill. Use when the user wants to extend the framework with a new workflow step or tool.
slash_command: skill-creator
---

# Skill: skill-creator

Create a new SuperSpecs skill.

## A skill is

A markdown file in `.skills/<skill-name>/SKILL.md` that an AI agent reads when triggered. Skills are instruction sets, not code.

## Structure

```markdown
---
name: <skill-name>
description: <One sentence: what this skill does and when it triggers. Include trigger phrases.>
slash_command: <command:name>
---

# Skill: <skill-name>

Brief intro: what you're doing in this phase.

## Inputs
What files or context the agent needs to read first.

## Steps
Numbered, concrete steps. Include:
- What to read
- What to write
- What to verify
- What to report to the user

## Output
What files are created/updated.

## What NOT to do
Explicit prohibitions.
```

## Good skill design

- **Concrete steps, not vague instructions.** "Read `tasks.md` completely" not "understand the plan".
- **Explicit output.** List every file created or modified.
- **Stopping conditions.** When should the skill ask for input before proceeding?
- **Verification steps.** What does "done" look like?
- **Non-negotiables.** What must never be skipped?

## After creating

1. Place file in `.skills/<skill-name>/SKILL.md`
2. Run `setup.sh` to symlink into agent directories
3. Test: open your agent and say "tell me about <skill-name>"

## Integration with SuperSpecs lifecycle

If the new skill fits into the lifecycle, add it to:
- `README.md` skill reference table
- `CLAUDE.md` skills list
- `AGENTS.md` lifecycle overview
