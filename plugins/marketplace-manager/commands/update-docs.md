---
name: update-docs
description: Update marketplace README.md to match current marketplace.json entries
args:
  - name: marketplace-path
    type: string
    required: false
    description: Path to marketplace directory (defaults to current directory)
---

# Update Docs

This command automatically generates and updates marketplace documentation to reflect the current marketplace.json entries.

## What Gets Generated

### README.md Updates
- **Marketplace header** - Name and description
- **Owner information** - Contact and details
- **Plugin table** - All plugins with versions and categories
- **Installation section** - How to install each plugin
- **Plugin details** - Full description for each plugin
- **Contributing section** - Guidelines for adding plugins

## Generated Structure

The command creates or updates README.md with:

```markdown
# Marketplace Name

Brief marketplace description

**Owner:** Name (email@example.com)

## Quick Start

Installation instructions and getting started guide.

## Plugins

| Name | Version | Category | Description |
|------|---------|----------|-------------|
| plugin-name | 1.0.0 | development | Plugin description |

## Installation

### From Marketplace
Each plugin installation instruction with commands.

### Local Installation
Instructions for installing from local sources.

## Plugin Details

### plugin-name (v1.0.0)
Full description and usage details.

## Contributing

Guidelines for submitting new plugins.
```

## Usage

```bash
# Update README in current directory
/update-docs

# Update README for specific marketplace
/update-docs ./marketplace

# Update and maintain existing README sections
/update-docs . --preserve-custom
```

## Documentation Sync

The command ensures:
- Plugin table matches marketplace.json exactly
- All new plugins are documented
- Removed plugins are no longer listed
- Versions are current
- Categories are correct

## Features

### Plugin Table Generation
- Extracts plugin data from marketplace.json
- Creates formatted markdown table
- Sorts by category then name
- Includes version and description

### Installation Commands
- Generates per-plugin installation instructions
- Includes marketplace path references
- Provides both direct and manual installation options

### Plugin Descriptions
- Pulls full descriptions from marketplace.json
- Shows version and author information
- Lists plugin category
- Provides plugin source location

### Contributing Guidelines
- Adds plugin submission instructions
- References validate-plugin command
- Links to add-to-marketplace workflow
- Provides structure template

## Generated Example

```markdown
# My Plugin Marketplace

A curated marketplace of Claude Code plugins.

**Owner:** Acme Corp (plugins@acme.com)

## Available Plugins

| Name | Version | Category | Description |
|------|---------|----------|-------------|
| my-plugin | 1.0.0 | development | My awesome plugin |
| utility-helper | 2.1.0 | productivity | Helper utilities |

## Installation

### my-plugin
```bash
# Clone or add to marketplace
git clone https://github.com/acme/my-plugin.git
```

### utility-helper
```bash
# Add from marketplace
cd .claude-plugins && git clone https://github.com/acme/utility-helper.git
```

## Contributing

To add your plugin:
1. Validate with `/validate-plugin`
2. Add to marketplace with `/add-to-marketplace`
3. Update docs with `/update-docs`
```

## Options

### Preserve Custom Sections
Use `--preserve-custom` to keep custom README sections:
- Keep introduction
- Keep contributing guidelines
- Preserve custom formatting
- Only update plugin table and details

## Next Steps

After updating docs:
- Review generated README for accuracy
- Commit changes to version control
- Share updated marketplace
- Announce new plugins to users

## Tips

- Run `/list-plugins --format markdown` to see plugin list before updating
- Review generated README to ensure formatting is correct
- Use `/validate-marketplace` before updating docs
- Commit and push README changes with plugin updates
