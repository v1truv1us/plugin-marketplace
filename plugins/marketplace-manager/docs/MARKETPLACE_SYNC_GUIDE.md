# Marketplace Synchronization Guide

## Overview

Claude Code plugin marketplaces require maintaining two synchronized marketplace files for proper plugin discovery and distribution:

| File | Location | Purpose | Audience |
|------|----------|---------|----------|
| **marketplace.json** | Repository root | Primary registry of all plugins | Plugin developers, repository maintainers |
| **.claude-plugin/marketplace.json** | `.claude-plugin/` subdirectory | Distribution manifest for Claude Code | Claude Code runtime, end users |

Understanding when and how to use each file is critical for ensuring plugins are discoverable and properly distributed.

---

## Why Two Files?

### marketplace.json (Primary Registry)

**Purpose:** Single source of truth for all plugins in your marketplace
**Location:** `marketplace.json` at repository root
**Audience:** Developers, repository maintainers
**Use cases:**
- Adding new plugins to marketplace
- Updating plugin metadata (version, description, author)
- Managing plugin permissions and categories
- Version control and audit trail

**Example:**
```json
{
  "name": "code-plugin-marketplace",
  "version": "1.0.0",
  "plugins": [
    {
      "name": "my-plugin",
      "source": "./plugins/my-plugin",
      "version": "1.0.0",
      "description": "..."
    }
  ]
}
```

### .claude-plugin/marketplace.json (Distribution Manifest)

**Purpose:** Optimized version sent to Claude Code for plugin discovery
**Location:** `.claude-plugin/marketplace.json`
**Audience:** Claude Code runtime, end users
**Use cases:**
- Plugin discovery in Claude Code
- Automatic plugin installation
- Distribution and packaging
- Performance-optimized queries

**When it's created:**
- Automatically when marketplace-manager plugin is installed
- Manually when setting up distribution
- Should be updated whenever marketplace.json changes

---

## Synchronization Model

### The Problem

Before synchronization:
```
marketplace.json
├── prompt-orchestrator ✓
├── marketplace-manager ✓
├── day-week-planner ✓
└── subagent-creator ✓

.claude-plugin/marketplace.json
├── prompt-orchestrator ✓
├── marketplace-manager ✓
└── day-week-planner ✓
    └── ✗ subagent-creator MISSING!
```

When `.claude-plugin/marketplace.json` is out of sync:
- ✗ Plugins don't appear in Claude Code
- ✗ Validator doesn't catch the discrepancy
- ✗ Distribution is broken
- ✗ Users can't discover/install missing plugins

### The Solution: The Validator

The marketplace-manager validator now detects synchronization issues automatically.

**Run the validator:**
```bash
/validate-marketplace . --deep
```

**What it checks:**
- ✓ Both marketplace.json files exist
- ✓ Plugin lists match between files
- ✓ Plugin metadata is consistent (version, author, etc.)
- ✓ All entries are properly formatted

**Output examples:**

✅ **Synchronized:**
```
✓ .claude-plugin/marketplace.json found
✓ Plugin lists are synchronized between marketplace.json and .claude-plugin/marketplace.json
```

⚠️ **Out of Sync:**
```
⚠ Marketplace files out of sync
✗ Missing in .claude-plugin/marketplace.json: subagent-creator
```

---

## How to Keep Marketplace Files in Sync

### Automatic Sync (Recommended)

Use the marketplace-manager's update commands to keep files synchronized automatically:

```bash
# Add new plugin to BOTH files
/add-to-marketplace ./plugins/my-plugin

# Update marketplace documentation (syncs metadata)
/update-docs

# Validate and check sync status
/validate-marketplace . --deep
```

These commands maintain both files in sync by design.

### Manual Sync (When Needed)

If you manually edit `marketplace.json`, you must also update `.claude-plugin/marketplace.json`:

**Step 1: Update marketplace.json**
```json
{
  "plugins": [
    {
      "name": "new-plugin",
      "source": "./plugins/new-plugin",
      "version": "1.0.0",
      ...
    }
  ]
}
```

**Step 2: Copy the same entry to .claude-plugin/marketplace.json**
```json
{
  "plugins": [
    {
      "name": "new-plugin",
      "source": "./plugins/new-plugin",
      "version": "1.0.0",
      ...
    }
  ]
}
```

**Step 3: Validate sync**
```bash
/validate-marketplace . --deep
```

### Git Workflow for Sync

```bash
# 1. Edit marketplace.json
vi marketplace.json

# 2. Make corresponding changes to .claude-plugin/marketplace.json
vi .claude-plugin/marketplace.json

# 3. Validate before committing
/validate-marketplace . --deep

# 4. Commit both files together
git add marketplace.json .claude-plugin/marketplace.json
git commit -m "Add new plugin and sync marketplace files"
```

**Important:** Always commit both files in the same commit to maintain history clarity.

---

## Common Sync Scenarios

### Scenario 1: Adding a New Plugin

**Situation:** You've created a new plugin and want to add it to the marketplace.

**Solution:**
```bash
# Use the add command (handles sync automatically)
/add-to-marketplace ./plugins/my-new-plugin

# Verify
/validate-marketplace . --deep
```

**Result:** Plugin appears in BOTH marketplace.json and .claude-plugin/marketplace.json

---

### Scenario 2: Updating Plugin Version

**Situation:** You've released a new version of an existing plugin.

**Solution:**
```bash
# Update version in marketplace.json
# (use an editor or script to update version field)

# Update version in .claude-plugin/marketplace.json to match
# (keep entries identical except for version)

# Validate
/validate-marketplace . --deep

# Commit
git add marketplace.json .claude-plugin/marketplace.json
git commit -m "Bump my-plugin to v2.0.0"
```

**Result:** Both files reflect v2.0.0 for the plugin

---

### Scenario 3: Removing a Plugin

**Situation:** A plugin is no longer maintained and should be removed.

**Solution:**
```bash
# Remove entry from marketplace.json
# Remove SAME entry from .claude-plugin/marketplace.json

# Validate
/validate-marketplace . --deep

# Commit
git add marketplace.json .claude-plugin/marketplace.json
git commit -m "Remove obsolete-plugin from marketplace"
```

**Result:** Plugin removed from both files, won't be discoverable

---

### Scenario 4: Emergency Sync After Manual Edit

**Situation:** You manually edited marketplace.json but forgot to sync .claude-plugin/marketplace.json.

**Solution:**
```bash
# Check what's out of sync
/validate-marketplace . --deep

# Manually copy missing entries to .claude-plugin/marketplace.json
# OR use a sync script (see below)

# Validate again
/validate-marketplace . --deep

# Commit
git add .claude-plugin/marketplace.json
git commit -m "Sync .claude-plugin/marketplace.json with marketplace.json"
```

---

## Automated Sync Script (Optional)

For teams that frequently edit marketplace.json manually, here's a sync script:

```bash
#!/bin/bash
# sync-marketplace.sh - One-way sync from marketplace.json to .claude-plugin/marketplace.json

MARKETPLACE="./marketplace.json"
CLAUDE_PLUGIN_MARKETPLACE="./.claude-plugin/marketplace.json"

# Backup
cp "$CLAUDE_PLUGIN_MARKETPLACE" "$CLAUDE_PLUGIN_MARKETPLACE.backup"

# Sync plugins array
jq '.plugins = ('"$MARKETPLACE"' | .plugins)' "$CLAUDE_PLUGIN_MARKETPLACE" > "$CLAUDE_PLUGIN_MARKETPLACE.tmp"
mv "$CLAUDE_PLUGIN_MARKETPLACE.tmp" "$CLAUDE_PLUGIN_MARKETPLACE"

# Validate
/validate-marketplace . --deep

echo "✓ Synchronized $CLAUDE_PLUGIN_MARKETPLACE"
```

**Usage:**
```bash
chmod +x sync-marketplace.sh
./sync-marketplace.sh
```

---

## Validator Enhancements

The marketplace-manager's `validate-marketplace` command includes new sync detection:

### New Sync Validation Checks

**Check 1: File Existence**
```
✓ .claude-plugin/marketplace.json found
```
Warns if .claude-plugin/marketplace.json doesn't exist (optional for dev).

**Check 2: Plugin List Comparison**
```
✓ Plugin lists are synchronized between marketplace.json and .claude-plugin/marketplace.json
```
Compares plugin names; fails if lists don't match exactly.

**Check 3: Missing Plugins**
```
✗ Missing in .claude-plugin/marketplace.json: subagent-creator
```
Identifies plugins in marketplace.json but not in .claude-plugin version.

**Check 4: Extra Plugins**
```
⚠ Extra in .claude-plugin/marketplace.json: old-plugin
```
Warns about plugins only in .claude-plugin version (possibly deprecated).

**Check 5: Version Consistency**
```
⚠ Version mismatch for my-plugin: marketplace=1.0.0, .claude-plugin=0.9.0
```
Warns when plugin versions differ between files.

---

## Best Practices

### ✅ DO

1. **Validate before committing**
   ```bash
   /validate-marketplace . --deep
   ```
   Always run the validator before pushing changes.

2. **Use automation tools**
   Use `/add-to-marketplace` and `/update-docs` commands to ensure sync.

3. **Commit both files together**
   ```bash
   git add marketplace.json .claude-plugin/marketplace.json
   ```
   Never commit just one file.

4. **Document sync in commit messages**
   ```
   Add new-plugin to marketplace and sync .claude-plugin version
   ```
   Make it clear both files were updated.

5. **Review marketplace.json first**
   Keep marketplace.json as source of truth; .claude-plugin is derived.

6. **Test discovery after sync**
   After syncing, verify plugins appear in Claude Code.

### ❌ DON'T

1. **Don't manually edit .claude-plugin/marketplace.json only**
   Changes won't reflect in the primary registry and may be reverted.

2. **Don't forget to validate**
   Out-of-sync files silently break plugin discovery.

3. **Don't commit them in separate commits**
   This makes history confusing and can cause revert issues.

4. **Don't assume they're always in sync**
   Run the validator regularly to catch drift.

5. **Don't delete .claude-plugin/marketplace.json**
   It's needed for distribution even if it seems redundant.

6. **Don't manually merge conflicts without validation**
   Always run validator after resolving git conflicts.

---

## Troubleshooting

### Problem: Validator says plugins out of sync

**Diagnosis:**
```bash
/validate-marketplace . --deep
# Output: ✗ Missing in .claude-plugin/marketplace.json: subagent-creator
```

**Solution:**
1. Check which plugins are missing from .claude-plugin/marketplace.json
2. Manually copy missing entries from marketplace.json
3. Or use the sync script (see Automated Sync Script section)
4. Run validator again to confirm

### Problem: Plugin visible in marketplace.json but not in Claude Code

**Diagnosis:**
1. Plugin appears in marketplace.json
2. But doesn't show in Claude Code
3. Validator reports sync issue

**Solution:**
1. Update .claude-plugin/marketplace.json to include plugin
2. Restart Claude Code
3. Verify plugin now appears

### Problem: Plugin shows wrong version in Claude Code

**Diagnosis:**
1. Updated marketplace.json to v2.0.0
2. Claude Code still shows v1.0.0

**Solution:**
1. Update version in .claude-plugin/marketplace.json to match
2. Restart Claude Code
3. Version should update

### Problem: Git shows merge conflict in marketplace files

**Diagnosis:**
Multiple people edited marketplace.json and .claude-plugin/marketplace.json

**Solution:**
```bash
# 1. Resolve conflict in marketplace.json (source of truth)
# Edit marketplace.json to resolve conflicts

# 2. Copy resolved plugins to .claude-plugin/marketplace.json
# Ensure both files have identical plugins array

# 3. Validate
/validate-marketplace . --deep

# 4. Commit
git add marketplace.json .claude-plugin/marketplace.json
git commit -m "Resolve marketplace merge conflict and sync files"
```

---

## References

- **Anthropic Documentation:** [Create and Distribute a Plugin Marketplace](https://code.claude.com/docs/en/plugin-marketplaces#create-and-distribute-a-plugin-marketplace)
- **Plugin JSON Structure:** See `../examples/plugin.json` for required fields
- **Marketplace Commands:**
  - `/add-to-marketplace` - Add plugin with automatic sync
  - `/validate-marketplace` - Validate and check sync
  - `/update-docs` - Update documentation

---

## Questions?

For issues or questions about marketplace synchronization:
1. Run `/validate-marketplace . --deep` to diagnose
2. Check the validator output for specific sync problems
3. Refer to the "Common Sync Scenarios" section above
4. See the Troubleshooting section for known issues

Last updated: 2025-01-28
Version: 1.0.0
