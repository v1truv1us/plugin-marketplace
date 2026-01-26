---
name: list-plugins
description: List all plugins in a marketplace with their details
args:
  - name: marketplace-path
    type: string
    required: false
    description: Path to marketplace directory (defaults to current directory)
  - name: format
    type: string
    required: false
    description: Output format (table, json, markdown) - defaults to table
---

# List Plugins

This command displays all plugins in a marketplace with their metadata in various formats.

## Output Formats

### Table Format (default)
```
Plugin Marketplace: My Plugin Marketplace
Owner: Acme Corp (acme@example.com)

╔════════════════════════════════════════════════════════════════════════════╗
║ Name                    │ Version │ Category      │ Description            ║
╠════════════════════════════════════════════════════════════════════════════╣
║ my-plugin               │ 1.0.0   │ development   │ My awesome plugin      ║
║ utility-helper          │ 2.1.0   │ productivity  │ Helpful utilities      ║
║ integration-tool        │ 1.5.2   │ integration   │ External integrations  ║
║ testing-framework       │ 3.0.0   │ testing       │ Testing and QA         ║
║ security-scanner        │ 1.2.1   │ security      │ Security analysis      ║
╚════════════════════════════════════════════════════════════════════════════╝

Total: 5 plugins
```

### JSON Format
```json
{
  "marketplace": "My Plugin Marketplace",
  "owner": {
    "name": "Acme Corp",
    "email": "acme@example.com"
  },
  "plugins": [
    {
      "name": "my-plugin",
      "version": "1.0.0",
      "category": "development",
      "description": "My awesome plugin",
      "author": "Jane Doe",
      "source": "./plugins/my-plugin"
    }
  ],
  "total": 5
}
```

### Markdown Format
```markdown
# My Plugin Marketplace

**Owner:** Acme Corp (acme@example.com)

## Available Plugins

1. **my-plugin** v1.0.0 [development]
   - Description: My awesome plugin
   - Author: Jane Doe

2. **utility-helper** v2.1.0 [productivity]
   - Description: Helpful utilities
   - Author: John Smith

3. **integration-tool** v1.5.2 [integration]
   - Description: External integrations
   - Author: Jane Doe
```

## Usage

```bash
# List plugins in default table format
/list-plugins

# List from specific marketplace
/list-plugins ./marketplace

# Get JSON output for programmatic use
/list-plugins . --format json

# Generate markdown listing
/list-plugins ./marketplace --format markdown
```

## Filtering and Sorting

You can pipe the output for further processing:

```bash
# Filter by category (with shell)
/list-plugins --format json | grep "development"

# Export to file
/list-plugins --format markdown > marketplace-listing.md

# Get plugin count
/list-plugins --format json | jq '.total'
```

## Display Information

Each plugin shows:
- **Name** - Plugin identifier (kebab-case)
- **Version** - Semantic version number
- **Category** - Plugin category
- **Description** - Short description
- **Author** - Plugin author name
- **Source** - Location of plugin code

## Categories

- **development** - Development tools
- **productivity** - Productivity enhancements
- **integration** - External integrations
- **testing** - Testing and QA
- **documentation** - Documentation tools
- **security** - Security tools
- **devops** - DevOps and deployment
- **lsp** - Language server integrations
- **mcp** - Model context protocol servers

## Sorted Output

Table format is automatically sorted by:
1. Category
2. Plugin name

This makes it easy to browse plugins by type.
