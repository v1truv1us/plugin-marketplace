---
name: create-plugin
description: Scaffold a new Claude Code plugin with proper directory structure
args:
  - name: plugin-name
    type: string
    required: true
    description: Name of the plugin in kebab-case (e.g., my-awesome-plugin)
  - name: description
    type: string
    required: true
    description: Short description of the plugin (10-200 characters)
  - name: author-name
    type: string
    required: false
    description: Author's name (defaults to current user)
  - name: author-email
    type: string
    required: false
    description: Author's email address
---

# Create Plugin

This command scaffolds a new Claude Code plugin with the proper directory structure and standard files.

## What Gets Created

- `.claude-plugins/{plugin-name}/plugin.json` - Plugin manifest with metadata
- `.claude-plugins/{plugin-name}/commands/` - Directory for slash commands
- `.claude-plugins/{plugin-name}/agents/` - Directory for AI agents
- `.claude-plugins/{plugin-name}/skills/` - Directory for ambient skills
- `.claude-plugins/{plugin-name}/README.md` - Plugin documentation
- Example component files showing proper structure

## Usage

```bash
/create-plugin my-awesome-plugin "A plugin that does awesome things"

/create-plugin utility-helper "Helper utilities" --author-name "John Doe" --author-email "john@example.com"
```

## Validation

After creation, the command will:
1. Verify the plugin directory was created
2. Validate plugin.json structure and required fields
3. Check that example components exist
4. Generate a creation report

## Plugin Name Rules

- Must be kebab-case (lowercase letters, numbers, hyphens only)
- Cannot contain special characters or spaces
- Should be descriptive and unique
- Will be used as the directory name

## Next Steps

After creation, you can:
- Edit the plugin.json to add more metadata
- Create commands in `commands/` directory
- Create agents in `agents/` directory
- Create skills in `skills/` directory
- Run `/validate-plugin` to ensure everything meets standards
- Run `/add-to-marketplace` to add to a plugin marketplace
