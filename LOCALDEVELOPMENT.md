# Local Development

How to install SuperSpecs into your local environment and how to work on the framework itself.

---

## Prerequisites

- **Bash** — `setup.sh` is the install script (macOS / Linux / WSL)
- **Node.js** — only required if you use the `npx` / `npm` install path; not needed for direct `bash` usage

---

## Installation Methods

### Option 1 — Global clone (recommended)

Clone once, use in every project on your machine.

```bash
git clone https://github.com/your-org/superspecs.git ~/.superspecs
bash ~/.superspecs/setup.sh
```

Then, in any project you want to use SuperSpecs in, add the bootstrap files. The skills are already symlinked globally so your agents will find them automatically.

---

### Option 2 — Per-project clone

Embed SuperSpecs directly inside a project. Useful when you want the framework versioned alongside the project.

```bash
cd your-project
git clone https://github.com/your-org/superspecs.git .superspecs
bash .superspecs/setup.sh
```

`setup.sh` symlinks skills both at project level (`.claude/skills/`, `.agents/skills/`, etc.) and globally (`~/.claude/skills/`, `~/.agents/skills/`, etc.).

---

### Option 3 — npm global install

```bash
npm install -g superspecs
superspecs install
```

`superspecs install` runs `setup.sh` from the package's own directory. Same result as Option 1.

---

### Option 4 — npx (no install)

```bash
npx superspecs install
```

Downloads the package, runs `setup.sh`, and discards the download. Good for a one-off bootstrap. Skills will be symlinked from the npx cache, so re-running after cache eviction re-installs them.

---

## What `setup.sh` Does

Running `setup.sh` from any install method does three things:

**1. Project-level skill symlinks**

Creates `<skills-dir>/<skill-name>.md` symlinks inside agent config dirs relative to where the script runs:

| Directory | Agent |
|---|---|
| `.claude/skills/` | Claude Code |
| `.cursor/skills/` | Cursor |
| `.windsurf/skills/` | Windsurf |
| `.agents/skills/` | OpenCode / Aider |

**2. Global skill symlinks**

Creates the same symlinks in your home directory so agents pick up skills across all projects:

| Directory | Agent |
|---|---|
| `~/.claude/skills/` | Claude Code |
| `~/.agents/skills/` | OpenCode |
| `~/.codex/skills/` | Codex |
| `~/.gemini/skills/` | Gemini CLI |
| `~/.copilot/skills/` | GitHub Copilot CLI |
| `~/.windsurf/skills/` | Windsurf (if installed) |
| `~/.cursor/skills/` | Cursor (if installed) |
| `~/.kiro/skills/` | Kiro (if installed) |

**3. Project directory scaffold**

Creates the `superspec/` working directories if they don't already exist:

```
superspec/
├── specs/
├── phases/
├── archive/
└── wiki/
    ├── _index.md
    └── _manifest.json
```

---

## Verifying the Install

After running `setup.sh`, confirm skills are in place:

```bash
ls ~/.claude/skills/
# plan-discuss.md  plan-spec.md  execute-pick-spec.md ...

ls ~/.agents/skills/
# same list
```

Then open your agent and say:

```
Tell me about your superspecs
```

A correctly installed agent will describe the four-phase lifecycle and the available slash commands.

---

## Working on the Framework

The framework's source of truth is the `.skills/` directory. Each skill is a single `SKILL.md` file.

```
.skills/
├── plan-discuss/SKILL.md
├── plan-spec/SKILL.md
├── execute-pick-spec/SKILL.md
├── execute-branch/SKILL.md
├── execute-subagent/SKILL.md
├── execute-tdd/SKILL.md
├── execute-review/SKILL.md
├── verify-tests/SKILL.md
├── verify-wiki/SKILL.md
├── ship/SKILL.md
└── skill-creator/SKILL.md
```

**Edit a skill:**

```bash
# Edit the source file directly
$EDITOR .skills/execute-tdd/SKILL.md

# Re-run setup to propagate symlinks (only needed if you added a new skill)
bash setup.sh
```

Because the installed files are symlinks back to `.skills/`, edits to a `SKILL.md` take effect immediately for all agents — no re-run of `setup.sh` required unless you add or rename a skill directory.

**Add a new skill:**

1. Create `.skills/<your-skill>/SKILL.md`
2. Run `bash setup.sh` — it will symlink the new file everywhere

**Remove a skill:**

1. Delete `.skills/<skill-name>/`
2. Remove the dangling symlinks manually or run `setup.sh` again (it uses `ln -sf`, so stale links pointing to deleted files remain — remove them by hand if needed)

---

## Updating the Framework

### Global clone

```bash
cd ~/.superspecs
git pull
bash setup.sh   # refreshes symlinks
```

### Per-project clone

```bash
cd your-project/.superspecs
git pull
bash setup.sh
```

### npm global

```bash
npm update -g superspecs
superspecs install
```

---

## Uninstalling

Symlinks can be removed with a one-liner:

```bash
# Remove global symlinks
find ~/.claude/skills ~/.agents/skills ~/.codex/skills ~/.gemini/skills \
     -name "*.md" -type l -delete 2>/dev/null

# Remove project-level symlinks (run from project root)
find .claude/skills .agents/skills .cursor/skills .windsurf/skills \
     -name "*.md" -type l -delete 2>/dev/null
```

The `superspec/` directory (specs, wiki, phases) is your project data — it is not touched by uninstall.
