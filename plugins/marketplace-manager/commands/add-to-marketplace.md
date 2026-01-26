---
name: add-to-marketplace
description: Add a plugin to marketplace.json with full validation
args:
  - name: plugin-path
    type: string
    required: true
    description: Path to the plugin directory (relative or absolute)
  - name: marketplace-path
    type: string
    required: false
    description: Path to marketplace.json directory (defaults to current directory)
  - name: category
    type: string
    required: false
    description: Category for the plugin (development, productivity, integration, testing, documentation, security, devops, lsp, mcp)
---

# Add to Marketplace

This command adds a validated plugin to a marketplace.json file, managing all entries and metadata.

## What It Does

1. **Validates Plugin Structure**
   - Checks that plugin directory exists and is valid
   - Verifies plugin.json has required fields
   - Confirms at least one component exists

2. **Checks for Duplicates**
   - Ensures no plugin with the same name exists in marketplace
   - Verifies source path is unique

3. **Creates Marketplace Entry**
   - Extracts plugin metadata from plugin.json
   - Adds name, description, version, author, source, and category
   - Generates entry with all required fields

4. **Updates Marketplace**
   - Adds plugin to marketplace.json
   - Validates the updated marketplace structure
   - Creates marketplace.json if it doesn't exist

5. **Optional Documentation Update**
   - Updates README.md with new plugin information
   - Regenerates plugin table
   - Updates installation instructions

## Usage

```bash
# Add plugin from current directory structure
/add-to-marketplace ./.claude-plugins/my-plugin

# Add with specific marketplace location and category
/add-to-marketplace ./plugins/my-plugin --marketplace-path ./marketplace --category development

# Add to parent directory marketplace
/add-to-marketplace ../my-plugin --marketplace-path . --category productivity
```

## Requirements

Before adding to marketplace, plugin must have:
- Valid plugin.json with name, version, description
- At least one component (commands, agents, skills, hooks, or .mcp.json)
- README.md file
- Proper kebab-case naming

## Marketplace Entry Format

```json
{
  "name": "my-plugin",
  "source": "./.claude-plugins/my-plugin",
  "description": "Plugin description",
  "version": "1.0.0",
  "author": "Author Name",
  "category": "development"
}
```

## Valid Categories

- **development** - Development tools and utilities
- **productivity** - Productivity enhancements
- **integration** - External integrations
- **testing** - Testing and quality assurance
- **documentation** - Documentation tools
- **security** - Security and compliance
- **devops** - DevOps and deployment
- **lsp** - Language server integrations
- **mcp** - Model context protocol servers

## Next Steps

After adding to marketplace:
- Run `/validate-marketplace` to verify integrity
- Run `/update-docs` to generate README
- Commit marketplace.json changes to version control
