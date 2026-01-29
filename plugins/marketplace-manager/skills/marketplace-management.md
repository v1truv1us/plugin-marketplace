# Marketplace Management

Concise guidance for managing plugin marketplaces. Use validation commands for detailed checks.

## Core Concepts

**Structure**: `marketplace.json` registry + `plugins/` directory containing plugin subdirectories
**Location**: Place `marketplace.json` at root or in `.claude-plugin/` directory
**Validation**: Always run `/validate-marketplace` before releases

## marketplace.json Quick Reference

```json
{
  "name": "my-marketplace",
  "owner": { "name": "...", "email": "..." },
  "plugins": [
    {
      "name": "plugin-name",
      "source": "./plugins/plugin-name",
      "description": "What it does"
    }
  ]
}
```

### Required Fields
- **name**: Marketplace identifier
- **owner.name** and **owner.email**: Contact info
- **plugins**: Array with name, source, description per entry

### Plugin Entry Fields
| Field | Required | Format |
|-------|----------|--------|
| name | Yes | kebab-case |
| source | Yes | `./path` (local) or URL (remote) |
| description | Yes | 10-200 chars |
| version | No | semver X.Y.Z |
| category | No | see categories below |
| author | No | `{name, email}` object |

### Valid Categories
`development` | `productivity` | `integration` | `testing` | `documentation` | `security` | `devops` | `lsp` | `mcp`

## Common Workflows

### Add Plugin
```bash
/validate-plugin ./plugins/new-plugin    # Validate first
/add-to-marketplace ./plugins/new-plugin # Add entry
/validate-marketplace --deep             # Verify
```

### Release Checklist
1. All plugins pass `/validate-plugin`
2. Marketplace passes `/validate-marketplace --deep`
3. README.md is current
4. Version bumped if changed

## Quick Fixes

**"marketplace.json not found"**
→ Ensure file exists at root or `.claude-plugin/marketplace.json`

**"Plugin name not kebab-case"**
→ Use lowercase-with-hyphens: `my-plugin` not `MyPlugin`

**"Source path not found"**
→ Local paths must start with `./` and exist

**"Duplicate plugin name"**
→ Each name must be unique in plugins array

## Commands Reference
- `/validate-marketplace [path] [--deep]` - Check marketplace integrity
- `/validate-plugin <path>` - Check single plugin
- `/add-to-marketplace <path>` - Add plugin entry
- `/list-plugins [--format json|table]` - List all plugins
- `/update-docs` - Regenerate README
