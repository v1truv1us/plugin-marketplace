---
name: validate-marketplace
description: Validate marketplace structure and all plugin entries
args:
  - name: marketplace-path
    type: string
    required: false
    description: Path to marketplace directory (defaults to current directory)
  - name: deep
    type: boolean
    required: false
    description: Enable deep validation to check all local plugins
---

# Validate Marketplace

This command validates the integrity of a plugin marketplace and all its entries.

## Validation Checks

### Marketplace Schema
- ✓ marketplace.json exists and is valid JSON
- ✓ Required fields present: name, owner.name, owner.email, plugins (array)
- ✓ Marketplace name is kebab-case (no spaces)
- ✓ Owner is an object with name and email (not a string)
- ✓ Version follows semantic versioning (X.Y.Z)

### Plugin Entry Validation
- ✓ Each plugin has required fields: name, source, description, version, author, category
- ✓ Plugin names are unique (no duplicates)
- ✓ Plugin names match kebab-case convention
- ✓ Plugin source paths start with "./" (not "../")
- ✓ Plugin author is an object {name, email} (not a string)
- ✓ Plugin category is in valid list
- ✓ Local source paths exist and are valid plugins

### Documentation Consistency
- ✓ README.md references match marketplace entries
- ✓ Plugin table is up-to-date
- ✓ Installation commands are correct

### Deep Validation (--deep flag)
When enabled, also validates:
- ✓ Each local plugin's structure and components
- ✓ Plugin.json integrity for all local plugins
- ✓ README.md present in each plugin
- ✓ All plugin names match between marketplace.json and plugin.json

## Output Format

### Standard Report
```
Marketplace Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Marketplace: Plugin Marketplace v1.0
Owner: Acme Corp (acme@example.com)
Plugins: 5 total

Plugin Status:
✓ my-plugin v1.0.0
✓ utility-helper v2.1.0
✓ integration-tool v1.5.2
✓ testing-framework v3.0.0
✓ security-scanner v1.2.1

Summary: All checks passed - marketplace ready for release
```

### Status Levels
- **✓ VALID** - All plugins and marketplace structure valid
- **⚠ VALID_WITH_WARNINGS** - Valid but has non-blocking warnings
- **✗ INVALID** - Errors found, must fix before release

## Usage

```bash
# Validate marketplace in current directory
/validate-marketplace

# Validate specific marketplace with deep checks
/validate-marketplace ./marketplace --deep

# Validate and check all local plugins
/validate-marketplace . --deep
```

## Common Issues

**Marketplace name not kebab-case**: Name contains spaces or mixed case
- ✗ Invalid: "Claude Code Plugin Marketplace"
- ✓ Valid: "code-plugin-marketplace"
- Fix: Use lowercase letters, hyphens, and numbers only

**Author as string instead of object**: Author must be an object with name and email
- ✗ Invalid: `"author": "Anthropic"`
- ✓ Valid: `"author": {"name": "Anthropic", "email": "contact@example.com"}`
- Fix: Convert all author strings to {name, email} objects

**Source paths don't start with "./"**: Paths must start with ./
- ✗ Invalid: `"source": "../plugins/my-plugin"`, `"source": "plugins/my-plugin"`
- ✓ Valid: `"source": "./plugins/my-plugin"`
- Fix: Update all source paths to start with "./"

**Duplicate plugin names**: Each plugin must have unique name
- Check marketplace.json for name conflicts
- Verify plugin.json names match marketplace entries

**Invalid source paths**: Local plugins must exist
- Verify paths are relative and correct
- Check that plugin directories are readable
- Ensure plugin.json exists in each directory

**Missing owner information**: Marketplace requires owner
- Add name and email to marketplace.json root as an object, not a string

**Schema errors**: marketplace.json structure issues
- Verify JSON is valid (use a JSON validator)
- Check required fields are present
- Ensure plugins array is properly formatted
- Verify all data types match schema

## marketplace.json Template

```json
{
  "name": "My Plugin Marketplace",
  "owner": {
    "name": "Your Name",
    "email": "your@email.com"
  },
  "plugins": [
    {
      "name": "my-plugin",
      "source": "./plugins/my-plugin",
      "description": "Plugin description",
      "version": "1.0.0",
      "author": "Author Name",
      "category": "development"
    }
  ]
}
```

## Next Steps

After validation passes:
- Run `/update-docs` to generate README
- Run `/list-plugins` to see marketplace summary
- Commit marketplace.json to version control
- Share marketplace with the community
