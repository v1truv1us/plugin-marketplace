# Marketplace Manager

Create, validate, and manage plugins in Claude Code plugin marketplaces. Includes scaffolding, validation, and documentation generation.

**Version:** 1.0.0
**Category:** Development
**License:** MIT

## Features

- **Plugin Scaffolding** - Create new Claude Code plugins with proper structure
- **Comprehensive Validation** - Validate plugin structure and best practices
- **Marketplace Management** - Add plugins to and validate plugin marketplaces
- **Documentation Generation** - Auto-generate marketplace README files
- **Quality Assurance** - Expert agents for plugin and marketplace review
- **Best Practices Guide** - Ambient skills with plugin authoring guidance

## Installation

### From Claude Code Marketplace

```bash
# Add from marketplace
/add-to-marketplace plugins/marketplace-manager
```

### Local Installation

Clone or download the plugin to your `.claude-plugins` directory:

```bash
cd .claude-plugins
git clone https://github.com/anthropics/marketplace-manager.git
```

Or copy the plugin directory directly:

```bash
cp -r marketplace-manager ~/.claude-plugins/
```

## Quick Start

### Create Your First Plugin

```bash
/create-plugin my-awesome-plugin "A plugin that does awesome things"
```

This scaffolds:
- Plugin directory structure
- `plugin.json` manifest
- Component directories (commands, agents, skills)
- Example README.md

### Validate Plugin Quality

```bash
/validate-plugin ./plugins/my-awesome-plugin
```

Reports:
- ✓ Structure validation
- ✓ Best practices compliance
- ✓ Documentation quality
- Status: VALID, VALID_WITH_WARNINGS, or INVALID

### Add to Marketplace

```bash
/add-to-marketplace ./plugins/my-awesome-plugin --category development
```

Creates marketplace entry with:
- Plugin metadata extraction
- Duplicate checking
- marketplace.json updates
- Documentation sync

### Validate Marketplace

```bash
/validate-marketplace . --deep
```

Validates:
- Marketplace structure
- All plugin entries
- Local plugin sources
- Documentation consistency

### List Plugins

```bash
/list-plugins . --format table
```

Output formats: `table`, `json`, `markdown`

### Update Documentation

```bash
/update-docs
```

Generates:
- Plugin table
- Installation instructions
- Per-plugin sections
- Contributing guidelines

## Commands

### `/create-plugin`

Scaffold a new Claude Code plugin with proper directory structure.

**Arguments:**
- `plugin-name` (required) - Plugin identifier in kebab-case
- `description` (required) - Short description (10-200 characters)
- `author-name` (optional) - Author's name
- `author-email` (optional) - Author's email address

**Usage:**
```bash
/create-plugin my-plugin "Plugin description"
/create-plugin utility-tool "Helper utilities" --author-name "Jane Doe" --author-email "jane@example.com"
```

**Creates:**
- `.claude-plugins/my-plugin/` directory structure
- `plugin.json` manifest
- `commands/`, `agents/`, `skills/` directories
- Example components
- `README.md` template

### `/add-to-marketplace`

Add a validated plugin to a marketplace with full verification.

**Arguments:**
- `plugin-path` (required) - Path to plugin directory
- `marketplace-path` (optional) - Path to marketplace (defaults to `.`)
- `category` (optional) - Plugin category

**Valid Categories:**
- `development` - Development tools
- `productivity` - Productivity enhancements
- `integration` - External integrations
- `testing` - Testing and QA
- `documentation` - Documentation tools
- `security` - Security tools
- `devops` - DevOps and deployment
- `lsp` - Language server integrations
- `mcp` - Model context protocol servers

**Usage:**
```bash
/add-to-marketplace ./plugins/my-plugin --category development
/add-to-marketplace ../plugin --marketplace-path ./marketplace
```

**Process:**
1. Validates plugin structure
2. Checks for duplicates
3. Creates marketplace entry
4. Updates marketplace.json
5. Optionally updates README

### `/validate-plugin`

Comprehensive validation of plugin structure and best practices.

**Arguments:**
- `plugin-path` (required) - Path to plugin to validate
- `strict` (optional) - Enable strict mode (warnings become errors)

**Usage:**
```bash
/validate-plugin ./plugins/my-plugin
/validate-plugin . --strict
```

**Validates:**
- Directory structure
- `plugin.json` completeness
- Component presence
- Documentation quality
- Best practices compliance

**Output:**
- ✓ VALID - Ready for marketplace
- ⚠ VALID_WITH_WARNINGS - Valid but has improvements needed
- ✗ INVALID - Has errors to fix

### `/validate-marketplace`

Validate marketplace structure and all plugin entries.

**Arguments:**
- `marketplace-path` (optional) - Path to marketplace (defaults to `.`)
- `deep` (optional) - Validate all local plugins

**Usage:**
```bash
/validate-marketplace
/validate-marketplace ./marketplace --deep
```

**Validates:**
- marketplace.json schema
- All plugin entries
- Source path existence
- Duplicate detection
- Documentation consistency

**With --deep flag:**
- Validates each local plugin structure
- Checks plugin.json in all plugins
- Verifies component presence

### `/list-plugins`

List all plugins in a marketplace with details.

**Arguments:**
- `marketplace-path` (optional) - Path to marketplace (defaults to `.`)
- `format` (optional) - Output format (table, json, markdown)

**Usage:**
```bash
/list-plugins                              # Table format
/list-plugins ./marketplace --format json  # JSON output
/list-plugins . --format markdown          # Markdown listing
```

**Display Information:**
- Plugin name and version
- Category and author
- Description
- Source location

### `/update-docs`

Update marketplace README.md to match marketplace.json entries.

**Arguments:**
- `marketplace-path` (optional) - Path to marketplace (defaults to `.`)

**Usage:**
```bash
/update-docs
/update-docs ./marketplace
```

**Generates:**
- Marketplace header and owner info
- Plugin table with all entries
- Installation instructions
- Per-plugin detail sections
- Contributing guidelines

**Ensures:**
- Plugin table matches marketplace.json
- All new plugins documented
- Versions are current
- Categories are correct

## Agents

### Plugin Reviewer

Expert agent for comprehensive plugin quality assessment.

**Capabilities:**
- Plugin structure review
- Code quality assessment
- Documentation evaluation
- Security analysis
- Best practices enforcement

**Invoked by:**
- `/validate-plugin` with detailed review
- `/add-to-marketplace` pre-submission check
- Manual invocation for audit

**Output:**
- Overall quality score (0-100)
- Component-by-component analysis
- Issue categorization
- Improvement recommendations
- Marketplace readiness assessment

### Marketplace Validator

Expert agent for marketplace validation and release readiness.

**Capabilities:**
- Marketplace schema validation
- Plugin entry verification
- Local plugin validation
- Documentation consistency
- Release readiness assessment

**Invoked by:**
- `/validate-marketplace` command
- `/validate-marketplace --deep` for full validation
- Pre-release verification

**Output:**
- Comprehensive validation report
- Plugin-by-plugin status
- Documentation sync verification
- Release readiness status

## Skills

### Plugin Authoring

Ambient guidance for creating high-quality Claude Code plugins.

**Covers:**
- Plugin structure standards
- Directory layout conventions
- plugin.json template and schema
- Component templates (commands, agents, skills)
- Naming conventions (kebab-case)
- Best practices and security
- Version control and releases
- Testing and validation

**Helps with:**
- Creating new plugins
- Understanding plugin.json schema
- Component file structure
- Documentation standards
- Common mistakes to avoid

### Marketplace Management

Ambient guidance for managing plugin marketplaces.

**Covers:**
- Marketplace structure and layout
- marketplace.json schema
- Plugin entry formats (local, GitHub, Git URLs)
- Valid categories and tags
- Adding and updating plugins
- Removing plugins
- Documentation standards
- Quality standards enforcement
- Release management

**Helps with:**
- Creating marketplaces
- Adding plugins to marketplace
- Validating marketplace integrity
- Managing plugin versions
- Documentation synchronization

## Scripts

### validate-plugin.sh

Bash script for plugin structure validation using jq for JSON parsing.

**Usage:**
```bash
./scripts/validate-plugin.sh /path/to/plugin
./scripts/validate-plugin.sh . -strict
```

**Checks:**
- `.claude-plugins/` directory
- `plugin.json` validity and fields
- Component existence
- `README.md` presence
- Naming conventions
- Version format

**Output:**
- Colored status (✓✗⚠)
- Detailed check results
- Exit code 0 for valid, 1 for invalid

### validate-marketplace.sh

Bash script for marketplace structure validation.

**Usage:**
```bash
./scripts/validate-marketplace.sh /path/to/marketplace
./scripts/validate-marketplace.sh . --deep
```

**Checks:**
- `marketplace.json` schema
- Plugin entries
- Source path existence
- Duplicate detection
- Local plugin validation (--deep)

**Output:**
- Colored status report
- Plugin-by-plugin validation
- Marketplace integrity summary
- Exit code 0 for valid, 1 for invalid

## Plugin Structure Reference

### Directory Layout

```
my-plugin/
├── .claude-plugins/
│   └── my-plugin/
│       ├── plugin.json          # Plugin manifest
│       ├── commands/            # Slash commands
│       ├── agents/              # AI agents
│       ├── skills/              # Ambient skills
│       ├── hooks/               # Event hooks (optional)
│       ├── scripts/             # Utility scripts (optional)
│       └── README.md            # Documentation
└── LICENSE                      # License file (optional)
```

### plugin.json Schema

```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Plugin description",
  "category": "development",
  "author": {
    "name": "Author Name",
    "email": "author@example.com"
  },
  "license": "MIT",
  "keywords": ["tag1", "tag2"],
  "components": {
    "commands": ["cmd1", "cmd2"],
    "agents": ["agent1"],
    "skills": ["skill1"]
  }
}
```

### Plugin Naming

- **kebab-case** (lowercase, hyphens): `my-awesome-plugin` ✓
- Not camelCase: `myAwesomePlugin` ✗
- Not snake_case: `my_awesome_plugin` ✗
- Not UPPERCASE: `MY-AWESOME-PLUGIN` ✗

### Versioning

Follow semantic versioning (X.Y.Z):
- **X** - Major (breaking changes)
- **Y** - Minor (new features, backward compatible)
- **Z** - Patch (bug fixes)

Examples: `0.1.0`, `1.0.0`, `1.2.3`

## Marketplace Structure Reference

### Directory Layout

```
marketplace/
├── marketplace.json     # Marketplace registry
├── README.md           # Generated/manual documentation
├── CONTRIBUTING.md     # Contributing guidelines (optional)
└── plugins/
    ├── plugin1/
    ├── plugin2/
    └── plugin3/
```

### marketplace.json Schema

```json
{
  "name": "My Plugin Marketplace",
  "version": "1.0.0",
  "description": "Description of marketplace",
  "owner": {
    "name": "Owner Name",
    "email": "owner@example.com",
    "url": "https://example.com"
  },
  "repository": "https://github.com/example/marketplace",
  "license": "MIT",
  "plugins": [
    {
      "name": "my-plugin",
      "source": "./plugins/my-plugin",
      "description": "Plugin description",
      "version": "1.0.0",
      "author": "Author Name",
      "category": "development",
      "keywords": ["tag1", "tag2"],
      "repository": "https://github.com/author/plugin"
    }
  ]
}
```

### Plugin Entry Fields

**Required:**
- `name` - Plugin identifier (kebab-case)
- `source` - Path or URL to plugin
- `description` - Short description

**Optional:**
- `version` - Semantic version
- `author` - Plugin author
- `category` - Plugin category
- `keywords` - Search tags
- `repository` - Source repository URL
- `documentation` - Documentation URL
- `homepage` - Plugin website

### Valid Categories

| Category | Description |
|----------|-------------|
| development | Development tools, linters, formatters |
| productivity | Workflow tools, automation |
| integration | External service connections |
| testing | Test frameworks, QA tools |
| documentation | Doc generation, API documentation |
| security | Security analysis, vulnerability scanning |
| devops | CI/CD, deployment, infrastructure |
| lsp | Language server integrations |
| mcp | Model context protocol servers |

## Complete Workflow Example

### 1. Create Plugin

```bash
/create-plugin code-formatter "Format and lint code files"
```

### 2. Develop Components

Add commands, agents, and skills to your plugin:

```
.claude-plugins/code-formatter/
├── commands/
│   └── format-code.md
├── agents/
│   └── format-reviewer.md
├── skills/
│   └── formatting-best-practices.md
└── README.md
```

### 3. Validate Plugin

```bash
/validate-plugin ./.claude-plugins/code-formatter
```

Expected output:
```
✓ VALID
Plugin is ready for marketplace
```

### 4. Set Up Marketplace

Create `marketplace.json` in your project:

```json
{
  "name": "Code Tools Marketplace",
  "owner": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "plugins": []
}
```

### 5. Add to Marketplace

```bash
/add-to-marketplace ./.claude-plugins/code-formatter --category development
```

### 6. Validate Marketplace

```bash
/validate-marketplace . --deep
```

### 7. Update Documentation

```bash
/update-docs
```

### 8. List All Plugins

```bash
/list-plugins . --format table
```

### 9. Publish

Commit changes and share marketplace:

```bash
git add marketplace.json README.md
git commit -m "Add code-formatter plugin"
git push
```

## Validation Rules

### Plugin Names
- Must be kebab-case (lowercase with hyphens)
- Examples: `my-plugin`, `awesome-tool`
- Invalid: `MyPlugin`, `my_plugin`

### Versions
- Must follow semver (X.Y.Z)
- Examples: `1.0.0`, `2.5.3`
- Invalid: `1.0`, `v1.0.0`

### Descriptions
- Should be 10-200 characters
- Clear and descriptive
- Single or brief multi-line

### Components
- At least one required
- Can have commands, agents, skills, hooks, or .mcp.json
- Each component in proper directory

### Marketplace
- No duplicate plugin names
- All source paths must exist
- Plugin names match between marketplace.json and plugin.json

## Best Practices

### Naming
✓ Use descriptive, kebab-case names
✓ Keep names under 30 characters
✓ Avoid generic names
✓ Use prefixes for related commands

### Organization
✓ Keep components focused
✓ Group related functionality
✓ Use clear directory structure
✓ Document everything

### Documentation
✓ Write README first (clarifies purpose)
✓ Include usage examples
✓ Document all arguments
✓ Add troubleshooting section

### Quality
✓ Validate before adding to marketplace
✓ Test all components
✓ Handle errors gracefully
✓ Keep code simple and focused

### Security
✓ Validate user inputs
✓ Don't hardcode secrets
✓ Use safe defaults
✓ Document security considerations

## Common Issues

### Plugin validation fails
- Check naming conventions (kebab-case)
- Verify plugin.json has required fields
- Ensure at least one component exists
- Run with `--strict` for detailed feedback

### Marketplace validation fails
- Check marketplace.json is valid JSON
- Verify all plugin sources exist
- Check for duplicate plugin names
- Ensure owner information is complete

### Documentation out of sync
- Run `/update-docs` after changes
- Verify all plugins are listed
- Check version numbers match
- Test links and references

## Troubleshooting

### Plugin directory not found
```bash
# Make sure path is correct
/validate-plugin ./path/to/plugin

# Check directory structure
ls -la .claude-plugins/my-plugin/
```

### marketplace.json invalid
```bash
# Validate JSON
jq . marketplace.json

# Check with validation script
./scripts/validate-marketplace.sh .
```

### Source paths not found
- Verify relative paths are correct
- Check path separators (/ not \)
- Use absolute paths if needed
- Ensure plugin directories exist

## Contributing

Contributions are welcome! To add your plugin to the marketplace:

1. Create and test your plugin
2. Run `/validate-plugin` to ensure quality
3. Add to marketplace with `/add-to-marketplace`
4. Submit PR with marketplace.json changes
5. Include documentation updates

## License

MIT License - See LICENSE file for details

## Support

For questions and support:
- Check the skills for guidance
- Review example plugins
- Use validation agents for feedback
- Consult the documentation sections

---

**Made with ❤️ for the Claude Code community**
