---
name: wiki-rebuild
description: Archive the current wiki vault and rebuild it from scratch from raw source material and specs. Use when the wiki has drifted too far from its sources or accumulated too much drift. Also restores from a previous archive. Triggers on /wiki-rebuild, "rebuild the wiki", "archive and rebuild", "reset the wiki".
slash_command: wiki-rebuild
phase: "3.2 — Verify › Wiki Rebuild"
---

# Skill: wiki-rebuild

You are managing the vault lifecycle — archiving and rebuilding when the wiki needs a clean slate.

**When to rebuild:**
- The wiki has accumulated too much drift (contradictions, stale content, structural mess)
- A major architectural change makes existing pages misleading
- The tag taxonomy was restructured and pages need a full re-pass

**This is a destructive operation on the compiled wiki.** Raw source material in `raw/` and specs in `superspec/specs/` are never touched. The rebuild reconstructs from those sources.

---

## Modes

### `archive` — Snapshot and preserve
Create a timestamped archive of the current vault. No rebuild.

### `rebuild` — Archive then reconstruct
Archive the current vault, then compile all sources from scratch.

### `restore <timestamp>` — Roll back
Restore a previous archive by timestamp.

### `list` — Show available archives
List all archived snapshots.

---

## Steps

### Archive

1. Create `superspec/wiki/_archives/<YYYY-MM-DD-HH-MM>/`
2. Copy the entire `superspec/wiki/` directory into it (excluding `raw/`, `_archives/`, `.obsidian/`)
3. Write a manifest for the archive:

```json
// _archives/<timestamp>/archive-manifest.json
{
  "archived_at": "<ISO timestamp>",
  "pages": N,
  "domains": ["auth", "api", ...],
  "reason": "<user-provided or 'manual'>",
  "last_ingested_slug": "<slug>"
}
```

4. Print:
```
Archive created: superspec/wiki/_archives/<timestamp>/
Pages preserved: N
```

---

### Rebuild

After archiving:

1. **Clear the compiled wiki** — delete all `.md` files and `_manifest.json` from `superspec/wiki/` except:
   - `raw/` (source material — never touched)
   - `.obsidian/` (vault config — never touched)
   - `_archives/` (previous snapshots)
   - `log.md` (append-only — preserve, add rebuild event)

2. **Re-initialize vault structure:**
   - New `Home.md` from template
   - New `_manifest.json`: `{"sources": []}`
   - Preserve `_meta/taxonomy.md` if it exists (tag vocabulary is still valid)

3. **Recompile all sources in order:**

   For each slug in `superspec/specs/` (ordered by `status.md` phase — shipped first):
   - If spec has `## Phase ... ✅` in status.md → it was shipped → compile to wiki
   - Follow the full `verify-wiki` ingest process for each slug

   For each file in `superspec/wiki/raw/`:
   - Compile to wiki pages

4. **Post-rebuild:**
   - Run cross-linker to weave all `[[wikilinks]]`
   - Run tag-taxonomy audit
   - Append to `log.md`:

```markdown
## [<YYYY-MM-DD>] rebuild | Vault rebuilt from scratch

- Archive: _archives/<timestamp>/
- Sources recompiled: N specs + M raw files
- Pages created: K
- Reason: <user-provided>
```

5. Print:
```
Rebuild complete

Archive: superspec/wiki/_archives/<timestamp>/
Pages rebuilt: K
Specs compiled: N
Raw files compiled: M

Run /wiki-status to see the new vault state.
Run /wiki-lint to verify health.
```

---

### Restore

1. Confirm with user: `Restore from <timestamp>? This will overwrite the current wiki. [Y/N]`
2. Archive the current state first (auto-archive before restore)
3. Copy `_archives/<timestamp>/` → `superspec/wiki/` (excluding `raw/`, `.obsidian/`, `_archives/`)
4. Append to `log.md`:

```markdown
## [<YYYY-MM-DD>] restore | Restored from archive <timestamp>

- Previous state auto-archived as: _archives/<auto-timestamp>/
```

---

### List

Print all available archives:

```
Available archives:

  2026-06-15-14-30  (N pages, reason: "pre-refactor snapshot")
  2026-05-20-09-15  (N pages, reason: "manual")
  2026-04-10-16-00  (N pages, reason: "rebuild")

To restore: /wiki-rebuild restore <timestamp>
```

---

## Safety Rules

- **Never delete `raw/`** — source material is immutable
- **Never delete `.obsidian/`** — vault config must survive
- **Never delete `log.md`** — append-only, always preserved
- **Always archive before rebuild or restore** — no data loss
- **Always confirm before destructive operations** — print what will happen and wait for [Y/N]

---

## Output

- `superspec/wiki/_archives/<timestamp>/` (archive)
- Rebuilt wiki pages (rebuild mode)
- Appended `superspec/wiki/log.md`
- Summary report in response
