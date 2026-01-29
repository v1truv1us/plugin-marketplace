# Claude Code Plugin Marketplace Guide

## Overview

This guide explains how the marketplace works and how to manage plugins according to the official Anthropic architecture.

**Important:** This guide is based on the official [Anthropic Plugin Marketplace documentation](https://code.claude.com/docs/en/plugin-marketplaces#create-and-distribute-a-plugin-marketplace).

---

## Architecture

### The Single Source of Truth: `.claude-plugin/marketplace.json`

According to Anthropic documentation, **only one file matters for plugin discovery:**

**`.claude-plugin/marketplace.json`** - This is THE file Claude Code reads to discover and install plugins.

When users add your marketplace:
```bash
/plugin marketplace add owner/repo
```

Claude Code looks for and reads **only** `.claude-plugin/marketplace.json`.

### File Structure

Your marketplace repository should look like:

```
my-marketplace/
├── .claude-plugin/
│   └── marketplace.json          ← THE file Claude Code reads
├── plugins/
│   ├── my-plugin/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   ├── commands/
│   │   ├── agents/
│   │   └── README.md
│   └── another-plugin/
└── README.md                     ← Optional: document your marketplace
```

That's it. The only required file for Claude Code is `.claude-plugin/marketplace.json`.

---

## `.claude-plugin/marketplace.json` Structure

This file defines your marketplace's name, owner, and list of plugins.

### Minimal Example

```json
{
  "name": "my-plugins",
  "owner": {
    "name": "Your Team"
  },
  "plugins": [
    {
      "name": "my-plugin",
      "source": "./plugins/my-plugin",
      "description": "What this plugin does"
    }
  ]
}
```

### Full Example with All Fields

```json
{
  "name": "company-tools",
  "owner": {
    "name": "DevTools Team",
    "email": "devtools@example.com"
  },
  "plugins": [
    {
      "name": "code-formatter",
      "source": "./plugins/formatter",
      "description": "Automatic code formatting",
      "version": "2.1.0",
      "author": {
        "name": "DevTools Team",
        "email": "team@example.com"
      },
      "category": "development",
      "keywords": ["formatting", "code-quality"]
    }
  ]
}
```

### Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Marketplace identifier (kebab-case) |
| `owner` | object | Marketplace owner info (`name` required, `email` optional) |
| `plugins` | array | List of available plugins |

### Plugin Entry Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | Yes | Plugin identifier (kebab-case) |
| `source` | string\|object | Yes | Where to fetch plugin (relative path or git source) |
| `description` | string | No | Brief description |
| `version` | string | No | Plugin version |
| `author` | object | No | Plugin author info |
| `category` | string | No | Plugin category |
| `keywords` | array | No | Search keywords |

### Plugin Source Types

**Local path (relative):**
```json
{
  "name": "my-plugin",
  "source": "./plugins/my-plugin"
}
```

**GitHub repository:**
```json
{
  "name": "github-plugin",
  "source": {
    "source": "github",
    "repo": "owner/repo",
    "ref": "main"
  }
}
```

**Git URL:**
```json
{
  "name": "git-plugin",
  "source": {
    "source": "url",
    "url": "https://gitlab.com/team/plugin.git"
  }
}
```

See [Anthropic documentation](https://code.claude.com/docs/en/plugin-marketplaces#plugin-sources) for complete source options.

---

## Managing Your Marketplace

### Adding Plugins

Use the marketplace-manager plugin to add plugins:

```bash
/add-to-marketplace ./plugins/my-new-plugin
```

This will update `.claude-plugin/marketplace.json` with your plugin entry.

### Updating Plugin Metadata

Edit `.claude-plugin/marketplace.json` directly:

1. Open `.claude-plugin/marketplace.json`
2. Update the plugin entry (version, description, keywords, etc.)
3. Validate your changes:
   ```bash
   /validate-marketplace . --deep
   ```
4. Commit your changes:
   ```bash
   git add .claude-plugin/marketplace.json
   git commit -m "Update my-plugin to v2.0.0"
   ```

### Removing Plugins

Edit `.claude-plugin/marketplace.json`:

1. Find the plugin entry
2. Delete the entire plugin object from the `plugins` array
3. Validate:
   ```bash
   /validate-marketplace . --deep
   ```
4. Commit:
   ```bash
   git add .claude-plugin/marketplace.json
   git commit -m "Remove deprecated-plugin from marketplace"
   ```

---

## Validation

### Validate Your Marketplace

Always validate before publishing:

```bash
# Quick validation
/validate-marketplace .

# Deep validation (validates all plugins)
/validate-marketplace . --deep
```

### What the Validator Checks

**Schema Validation:**
- ✓ `.claude-plugin/marketplace.json` exists and is valid JSON
- ✓ Required fields present (name, owner, plugins array)
- ✓ Marketplace name is kebab-case
- ✓ Owner information is correct

**Plugin Entry Validation:**
- ✓ Each plugin has required fields (name, source)
- ✓ Plugin names are unique
- ✓ Plugin names are kebab-case
- ✓ Source paths are valid

**Deep Validation (--deep flag):**
- ✓ Local plugin directories exist
- ✓ Each plugin has a plugin.json or .claude-plugin/plugin.json
- ✓ Plugin names match between marketplace and plugin.json
- ✓ README.md present in each plugin

### Common Validation Errors

| Error | Solution |
|-------|----------|
| `.claude-plugin/marketplace.json not found` | Create `.claude-plugin/marketplace.json` |
| `Invalid JSON syntax` | Fix JSON syntax (check commas, quotes) |
| `Duplicate plugin name` | Ensure each plugin has unique name |
| `Plugin X source missing plugin.json` | Add plugin.json to plugin directory |

---

## Publishing Your Marketplace

### Host on GitHub (Recommended)

1. Create a repository
2. Commit your marketplace files including `.claude-plugin/marketplace.json`
3. Push to GitHub
4. Share your marketplace: Users add it with `/plugin marketplace add owner/repo`

### Other Git Services

Works with GitLab, Bitbucket, and self-hosted Git:

```bash
/plugin marketplace add https://gitlab.com/company/plugins.git
```

### Private Repositories

For private repositories:

1. **Manual use:** Ensure you're authenticated with `git` (e.g., `gh auth login`)
2. **Auto-updates:** Set environment variable:
   ```bash
   export GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx
   ```

---

## Testing Your Marketplace Locally

Before publishing:

```bash
# Add your marketplace locally
/plugin marketplace add ./path/to/marketplace

# Install a test plugin
/plugin install my-plugin@my-plugins

# Test the plugin
/my-plugin:test-command
```

---

## Best Practices

### ✅ DO

1. **Validate before every commit**
   ```bash
   /validate-marketplace . --deep
   ```

2. **Use semantic versioning** for plugins
   ```json
   "version": "1.2.3"
   ```

3. **Write clear plugin descriptions**
   ```json
   "description": "Analyzes database query performance with execution plans"
   ```

4. **Test plugins locally** before publishing
   ```bash
   /plugin marketplace add .
   /plugin install my-plugin@my-plugins
   ```

5. **Keep plugin.json synchronized** with marketplace entry name
   ```json
   // .claude-plugin/marketplace.json
   { "name": "my-plugin" }

   // plugins/my-plugin/.claude-plugin/plugin.json or plugins/my-plugin/plugin.json
   { "name": "my-plugin" }
   ```

### ❌ DON'T

1. **Don't skip validation**
   - Always run `/validate-marketplace . --deep` before committing

2. **Don't manually edit `.claude-plugin/marketplace.json` without validation**
   - Invalid JSON breaks plugin discovery

3. **Don't use spaces in plugin names**
   - Use kebab-case: `my-plugin`, not `my plugin` or `MyPlugin`

4. **Don't forget to commit**
   - Changes only take effect after you push to git

5. **Don't mix local and remote sources haphazardly**
   - Document your plugin sourcing strategy

---

## Troubleshooting

### Plugins not appearing in Claude Code

**Check:**
1. `.claude-plugin/marketplace.json` exists and is valid:
   ```bash
   /validate-marketplace . --deep
   ```
2. Repository is accessible
3. Plugin names are kebab-case
4. Each plugin has valid source

### Plugin installation fails

**Check:**
1. Plugin directory exists at source path
2. Plugin has `.claude-plugin/plugin.json` or `plugin.json`
3. Plugin name matches between marketplace and plugin.json

### Validation errors

Run `/validate-marketplace . --deep` and fix reported errors.

---

## References

- **Official Docs:** [Anthropic Plugin Marketplace](https://code.claude.com/docs/en/plugin-marketplaces)
- **Plugin Creation:** [Creating Plugins](https://code.claude.com/docs/en/plugins)
- **Plugin Discovery:** [Discover and Install Plugins](https://code.claude.com/docs/en/discover-plugins)

---

## Questions?

1. Run validation: `/validate-marketplace . --deep`
2. Check output for specific issues
3. Consult official [Anthropic documentation](https://code.claude.com/docs/en/plugin-marketplaces)

Last updated: 2026-01-28
