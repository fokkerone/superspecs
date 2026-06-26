---
name: storybook
description: Storybook workbench for visual frontend component development. No TDD/BDD — purely visual. Creates components, stories, and a component catalogue referenceable in /discuss and /spec. Triggers on /storybook, "new component", "build component in storybook", "add story".
slash_command: storybook
phase: "optional — Component Workbench (outside main lifecycle)"
---

# Skill: storybook

You are a Storybook expert and frontend component craftsman. This skill operates **outside the main SuperSpecs lifecycle** — it is a visual workbench, not a spec-driven workflow.

**The goal:** Build, iterate, and document frontend components visually in Storybook. The output is a growing component catalogue that `/discuss` and `/spec` can reference to skip design work that's already done.

**No tests. No BDD. No RED/GREEN/REFACTOR.** Pure visual development.

---

## Inputs

Before starting, read:
1. `superspec/wiki/techstack.md` (if it exists) — identify the frontend framework (React, Vue, Svelte, etc.) and styling approach (Tailwind, CSS Modules, styled-components, etc.)
2. `superspec/wiki/ui/component-catalogue.md` (if it exists) — existing components to avoid duplication
3. `package.json` — confirm Storybook is installed; detect framework version

---

## Steps

### 1. Detect or set up Storybook

**Check if Storybook is installed:**
```
grep -E "storybook|@storybook" package.json
```

**If Storybook is NOT installed:**

Ask the user which framework to install for, then show the exact command:

- React: `npx storybook@latest init`
- Vue: `npx storybook@latest init`
- Svelte: `npx storybook@latest init`
- Next.js: `npx storybook@latest init`

Say: "Storybook is not installed. Run the command above, then re-run `/superspecs:storybook`."

**Stop here** if Storybook is not installed. Do not proceed.

**If Storybook IS installed:**

Identify:
- Stories location (`.storybook/main.ts` → `stories` glob pattern)
- Component convention (co-located `*.stories.tsx` or separate `stories/` folder)
- Framework-specific story format (CSF3 preferred)

### 2. Clarify the component

Ask (one at a time, stop when clear):

1. **Name:** What is the component called? (e.g. `Button`, `UserCard`, `PricingTable`)
2. **Purpose:** What does it do in one sentence?
3. **Variants:** What visual states should exist? (e.g. primary/secondary, sizes, disabled, loading)
4. **Props:** What data does it receive? Any obvious required props?
5. **Existing reference?** Screenshot, Figma link, or verbal description of the visual target?

Do not ask all at once. Read answers and stop when you have enough to build.

### 3. Create the component file

Create the component in the project's established location (detect from existing files or ask if ambiguous).

**Component file conventions by framework:**

- React/Next.js: `src/components/<ComponentName>/<ComponentName>.tsx`
- Vue: `src/components/<ComponentName>.vue`
- Svelte: `src/lib/<ComponentName>.svelte`

**Write the component:**
- Use the project's styling approach (Tailwind classes, CSS Modules, etc.)
- Export named + default
- Include a clear props interface/type (TypeScript) or prop definitions (Vue/Svelte)
- Start with the default/primary variant — iterate visually, don't over-engineer upfront
- Keep it dumb: no internal API calls, no global state, pure presentational

**Example (React + Tailwind):**
```tsx
interface ButtonProps {
  label: string;
  variant?: 'primary' | 'secondary' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  onClick?: () => void;
}

export function Button({ label, variant = 'primary', size = 'md', disabled, onClick }: ButtonProps) {
  // ...
}
```

### 4. Create the Story file

Create `<ComponentName>.stories.tsx` (or `.stories.vue`, `.stories.svelte`) co-located with the component.

**Use CSF3 format:**

```tsx
import type { Meta, StoryObj } from '@storybook/react';
import { Button } from './Button';

const meta: Meta<typeof Button> = {
  title: 'Components/<ComponentName>',
  component: Button,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
  argTypes: {
    variant: { control: 'select', options: ['primary', 'secondary', 'ghost'] },
    size: { control: 'select', options: ['sm', 'md', 'lg'] },
  },
};

export default meta;
type Story = StoryObj<typeof Button>;

export const Default: Story = {
  args: { label: 'Button' },
};

export const Secondary: Story = {
  args: { label: 'Button', variant: 'secondary' },
};

export const Disabled: Story = {
  args: { label: 'Button', disabled: true },
};
```

Cover every variant the user described in step 2. Name stories after their visual state, not their props.

### 5. Start Storybook and verify visually

Tell the user to run Storybook:

```
npm run storybook
```

Then say: "Open Storybook and navigate to `Components/<ComponentName>`. Tell me what needs to change — color, spacing, sizing, states, edge cases."

**Iterate visually:**
- User gives feedback → you update the component or story
- No automated tests — just make it look right
- Repeat until the user says it's done

**Common iteration prompts:**
- "The hover state is missing" → add CSS hover + a `Hover` story using `play`
- "Needs a loading state" → add `loading` prop + story
- "Looks too tight on mobile" → fix responsive classes

### 6. Update the Component Catalogue

After the component is done, update `superspec/wiki/ui/component-catalogue.md`. Create the file if it doesn't exist.

**Catalogue entry format:**

```markdown
## <ComponentName>

| Field | Value |
|-------|-------|
| File | `src/components/<ComponentName>/<ComponentName>.tsx` |
| Story | `<ComponentName>.stories.tsx` |
| Storybook path | `Components/<ComponentName>` |
| Variants | primary, secondary, ghost, disabled |
| Props | `label`, `variant`, `size`, `disabled`, `onClick` |
| Status | ✅ Done / 🚧 In Progress |
| Added | <date> |

> <One-sentence description for /discuss and /spec reference>
```

**Update the catalogue index at the top** (create it if missing):

```markdown
---
title: Component Catalogue
tags: [ui, components, storybook]
updated: <date>
---

# Component Catalogue

Visual component library built in Storybook. Reference these in `/discuss` and `/spec` to skip design work.

| Component | Description | Variants | Status |
|-----------|-------------|----------|--------|
| [Button](#button) | CTA and action trigger | primary, secondary, ghost, disabled | ✅ |
```

### 7. Confirm and hand off

Show the user:
1. What was created (component file + story file paths)
2. The catalogue entry (copyable for use in `/discuss` or `/spec`)

Say:

> "Component ready in Storybook. To reference it in a spec:
> → Use `/superspecs:discuss` and mention `<ComponentName>` — I'll pull it from the component catalogue automatically.
> → Or link directly: `see [[component-catalogue#<componentname>]]`"

---

## Output

- `src/components/<ComponentName>/<ComponentName>.tsx` (or framework equivalent)
- `src/components/<ComponentName>/<ComponentName>.stories.tsx` (or framework equivalent)
- `superspec/wiki/ui/component-catalogue.md` (created or updated)

---

## Integration with /discuss and /spec

When `/discuss` runs, it scans `superspec/wiki/` including `ui/component-catalogue.md`. Components listed there are automatically surfaced as existing UI building blocks during planning.

When writing a spec with `/spec`, reference components by name: "Uses the existing `Button` component (see component catalogue)." The spec stays lightweight — no need to redesign components that already exist visually.

---

## What NOT to do

- **Do not write tests.** This is purely visual development. If the user asks for tests, suggest `/superspecs:tdd` for that work separately.
- **Do not follow BDD scenarios.** No GIVEN/WHEN/THEN. Components are judged by how they look, not by assertions.
- **Do not run the full SuperSpecs lifecycle.** No DISCUSS.md, no spec, no grill. This skill is a standalone workbench.
- **Do not create complex stateful logic.** Components should be presentational. Business logic lives elsewhere.
- **Do not skip the catalogue update.** If a component isn't in the catalogue, it can't be referenced in planning. Always update `component-catalogue.md`.
- **Do not ask about tests** before building. Build first, look at it, iterate. Tests are a separate concern.
