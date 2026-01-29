# Plugin Authoring

Concise guidance for creating Claude Code plugins. Use `/create-plugin` for scaffolding.

## Plugin Structure

```
my-plugin/
├── .claude-plugin/
│   ├── plugin.json    # Required manifest
│   ├── commands/      # Slash commands (*.md)
│   ├── agents/        # AI agents (*.md)
│   ├── skills/        # Ambient skills (*.md)
│   ├── hooks/         # Event hooks (*.md)
│   ├── .mcp.json      # MCP server config
│   └── README.md      # Required documentation
└── LICENSE
```

**Note**: Use `.claude-plugin/` (singular), not `.claude-plugins/`

## plugin.json Template

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "Brief description (10-200 chars)",
  "author": { "name": "Your Name", "email": "you@email.com" },
  "category": "development",
  "license": "MIT"
}
```

### Required Fields
- **name**: kebab-case identifier
- **version**: semver format X.Y.Z
- **description**: 10-200 characters

## Naming Conventions

**Everything uses kebab-case**: lowercase letters and hyphens only

| Component | Valid | Invalid |
|-----------|-------|---------|
| Plugin | `my-plugin` | `MyPlugin`, `my_plugin` |
| Command | `run-tests` | `runTests`, `run_tests` |
| Agent | `code-reviewer` | `CodeReviewer` |
| Skill | `best-practices` | `bestPractices` |

## Component Templates

### Command (commands/my-command.md)
```markdown
---
name: my-command
description: What this command does
args:
  - name: input
    type: string
    required: true
    description: Input description
---

# My Command

Brief description and usage instructions.
```

### Agent (agents/my-agent.md)
```markdown
---
name: my-agent
description: What this agent does
model: sonnet
tools: [Read, Glob, Grep]
---

# My Agent

Purpose: Clear statement of role

When to use: Key use cases

Output: What it produces
```

### Skill (skills/my-skill.md)
```markdown
# My Skill

Purpose: What expertise this provides

## Key Guidance
- Essential point 1
- Essential point 2
- Essential point 3
```

## Valid Categories
`development` | `productivity` | `integration` | `testing` | `documentation` | `security` | `devops` | `lsp` | `mcp`

## Version Rules (semver)
- **Major (X.0.0)**: Breaking changes
- **Minor (0.X.0)**: New features, backward compatible
- **Patch (0.0.X)**: Bug fixes

## Publishing Checklist

1. `/validate-plugin ./my-plugin` passes
2. README.md has usage examples
3. All components have descriptions
4. Version follows semver
5. Category is valid

## Common Mistakes

- Using `.claude-plugins/` instead of `.claude-plugin/`
- CamelCase or snake_case names
- Missing required fields in plugin.json
- No README.md
- Description too short/long (need 10-200 chars)
