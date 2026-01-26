# Plugin Authoring Guide

Expert guidance for creating high-quality Claude Code plugins following official conventions and best practices.

## Plugin Structure Standards

### Directory Layout
```
my-plugin/
├── .claude-plugins/
│   └── my-plugin/
│       ├── plugin.json
│       ├── commands/
│       ├── agents/
│       ├── skills/
│       ├── hooks/
│       ├── scripts/
│       └── README.md
└── LICENSE
```

### .claude-plugins Directory
All plugin components live under `.claude-plugins/{plugin-name}/`:
- **plugin.json** - Plugin manifest (required)
- **commands/** - Slash commands (optional)
- **agents/** - AI agents (optional)
- **skills/** - Ambient skills (optional)
- **hooks/** - Event-driven hooks (optional)
- **.mcp.json** - MCP server config (optional)
- **scripts/** - Utility scripts (optional)
- **README.md** - Plugin documentation (required)

## Plugin.json Template

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "Brief description of what the plugin does",
  "category": "development",
  "author": {
    "name": "Your Name",
    "email": "your@email.com"
  },
  "license": "MIT",
  "keywords": ["tag1", "tag2", "tag3"],
  "components": {
    "commands": ["command1", "command2"],
    "agents": ["agent1"],
    "skills": ["skill1"]
  }
}
```

### Required Fields
- **name** - Plugin identifier in kebab-case
- **version** - Semantic version (X.Y.Z)
- **description** - 10-200 character description

### Optional Fields
- **category** - Plugin category
- **author** - Author name and email
- **license** - License type (MIT recommended)
- **keywords** - Search tags
- **components** - Component references

## Naming Conventions

### Plugin Names
- Format: kebab-case (lowercase, hyphens only)
- Examples: `my-plugin`, `awesome-tool`, `code-formatter`
- Invalid: `MyPlugin`, `my_plugin`, `MY-PLUGIN`

### Command Names
- Format: kebab-case
- Examples: `create-file`, `validate-code`, `run-tests`
- Prefix with category for related commands: `doc-generate`, `doc-validate`

### Agent Names
- Format: kebab-case, descriptive of function
- Examples: `code-reviewer`, `bug-finder`, `refactor-helper`

### Skill Names
- Format: kebab-case
- Describe the expertise provided
- Examples: `python-best-practices`, `api-design-guidance`

## Component Templates

### Command Template (Slash Commands)
```markdown
---
name: command-name
description: What this command does
args:
  - name: arg1
    type: string
    required: true
    description: Description of argument
  - name: arg2
    type: boolean
    required: false
    description: Optional flag description
---

# Command Name

Brief description of what the command does.

## Usage

```bash
/command-name value --flag
```

## Examples

Real-world usage examples.

## Output

Description of what the command produces.
```

### Agent Template (AI Agents)
```markdown
---
name: agent-name
description: What this agent does
model: sonnet
tools: [Read, Glob, Grep]
color: blue
---

# Agent Name

**Purpose:** Clear statement of agent's role

**Capabilities:**
- What the agent can do
- Key features
- Special abilities

**When to Use:**
- Use case 1
- Use case 2

**Input:**
What the agent expects to receive

**Output:**
What the agent produces
```

### Skill Template (Ambient Skills)
```markdown
# Skill Name

**Purpose:** What expertise this skill provides

**When Applied:** When agent or user would benefit

**Key Guidance:**

1. **Topic 1**
   - Key point
   - Best practice
   - Common pitfall

2. **Topic 2**
   - Guidance and examples

3. **Implementation Tips**
   - Practical advice
   - Code patterns
   - Tools to use
```

## Best Practices

### Structure
✓ Keep components focused and single-purpose
✓ Organize related commands into logical groups
✓ Use clear, descriptive names
✓ Document every component thoroughly

### Documentation
✓ Write README.md first (helps clarify purpose)
✓ Include clear usage examples
✓ Document all arguments and options
✓ Provide troubleshooting section
✓ Link components together

### Code Quality
✓ Keep scripts simple and focused
✓ Use consistent formatting
✓ Add comments for complex logic
✓ Handle errors gracefully
✓ Validate inputs

### Security
✓ Validate all user inputs
✓ Use safe default configurations
✓ Don't hardcode secrets or credentials
✓ Document security considerations
✓ Follow principle of least privilege

### Performance
✓ Keep commands responsive
✓ Use appropriate caching
✓ Avoid expensive operations
✓ Stream output for long operations
✓ Provide progress indicators

## Version Control

### Semantic Versioning (X.Y.Z)
- **X** (Major) - Breaking changes
- **Y** (Minor) - New features, backward compatible
- **Z** (Patch) - Bug fixes

Examples:
- 0.1.0 - Initial release
- 1.0.0 - First stable release
- 1.1.0 - New feature added
- 1.1.1 - Bug fix

## Categories

Classify your plugin with one of these:

| Category | Use Cases |
|----------|-----------|
| **development** | Code writing, testing, debugging tools |
| **productivity** | Workflow enhancement, automation |
| **integration** | External service connections |
| **testing** | Testing frameworks, QA tools |
| **documentation** | Doc generation, API documentation |
| **security** | Security analysis, vulnerability scanning |
| **devops** | CI/CD, deployment, infrastructure |
| **lsp** | Language server integrations |
| **mcp** | Model context protocol servers |

## README.md Structure

```markdown
# Plugin Name

Brief one-line description.

## Installation

How to install the plugin.

## Quick Start

Simple example to get started.

## Commands

List all commands with descriptions.

## Agents

Describe agent capabilities.

## Skills

Describe ambient skills.

## Configuration

Configuration options if any.

## Examples

Real-world usage examples.

## Troubleshooting

Common issues and solutions.

## Contributing

How others can contribute.

## License

License information.
```

## Testing Your Plugin

Before releasing:
1. Validate with `/validate-plugin`
2. Test all commands work correctly
3. Test agents with various inputs
4. Check documentation for accuracy
5. Verify file structure is correct
6. Get feedback from others

## Publishing to Marketplace

1. Ensure plugin passes `/validate-plugin`
2. Create marketplace.json entry
3. Run `/add-to-marketplace`
4. Update documentation with `/update-docs`
5. Get marketplace validated with `/validate-marketplace`
6. Commit and push changes
7. Share marketplace URL

## Common Mistakes to Avoid

❌ Using uppercase or underscores in names
❌ Inconsistent command naming
❌ Missing documentation
❌ No error handling
❌ Hardcoded paths or credentials
❌ Not following component conventions
❌ Unclear descriptions
❌ Missing component templates
❌ Version mismatch between plugin.json and marketplace
❌ Incomplete README.md

## Resources

- Official Claude Code documentation
- Plugin marketplace examples
- Community plugin repository
- Best practices guide
