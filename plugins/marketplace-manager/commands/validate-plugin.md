---
name: validate-plugin
description: Comprehensive validation of plugin structure and best practices
args:
  - name: plugin-path
    type: string
    required: true
    description: Path to the plugin directory to validate
  - name: strict
    type: boolean
    required: false
    description: Enable strict mode for additional checks (warnings become errors)
---

# Validate Plugin

This command performs comprehensive validation of a plugin's structure and adherence to Claude Code plugin best practices.

## Validation Checks

### Required Structure
- ✓ `.claude-plugins/` directory exists
- ✓ `plugin.json` file exists
- ✓ At least one component directory (commands/, agents/, skills/, hooks/)
- ✓ README.md file exists

### plugin.json Validation
- ✓ Valid JSON syntax
- ✓ Required fields present: name, version, description
- ✓ Plugin name in kebab-case (lowercase, hyphens only)
- ✓ Version follows semver (X.Y.Z format)
- ✓ Description between 10-200 characters
- ✓ Optional fields properly formatted: author, license, keywords

### Component Validation
- ✓ Commands have proper YAML frontmatter
- ✓ Agents have proper structure
- ✓ Skills are properly formatted
- ✓ Hook files follow conventions

### Best Practices
- ✓ README.md includes usage examples
- ✓ All commands are documented
- ✓ Plugin has clear purpose and description
- ✓ Author information is present

## Output Format

### Standard Report
```
Plugin Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Plugin: my-plugin v1.0.0
Status: ✓ VALID

Checks:
✓ Directory structure valid
✓ plugin.json complete
✓ All components found
✓ Documentation present
✓ Best practices met

Summary: All checks passed
```

### Status Levels
- **✓ VALID** - All checks passed, ready for marketplace
- **⚠ VALID_WITH_WARNINGS** - Passed but has best practice warnings
- **✗ INVALID** - Failed required checks, cannot add to marketplace

## Usage

```bash
# Validate plugin in current directory
/validate-plugin .

# Validate with strict mode (warnings = errors)
/validate-plugin ./my-plugin --strict

# Validate and get detailed report
/validate-plugin ../other-plugin
```

## Common Issues

**Invalid name format**: Plugin names must be kebab-case
- ✗ MyPlugin, my_plugin, MY-PLUGIN
- ✓ my-plugin, awesome-tool

**Invalid version**: Must follow X.Y.Z format
- ✗ 1.0, 1.0.0.0, v1.0.0
- ✓ 1.0.0, 0.1.0, 2.5.3

**Missing components**: At least one required
- Commands, agents, skills, hooks, or .mcp.json

## Next Steps

After validation passes:
- Run `/add-to-marketplace` to add to a marketplace
- Run `/update-docs` to generate documentation
- Share plugin with the community

If issues found:
- Review error messages carefully
- Fix identified problems
- Re-run validation to confirm
