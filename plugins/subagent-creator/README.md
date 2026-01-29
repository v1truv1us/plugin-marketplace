# Subagent Creator Plugin

An interactive Claude Code plugin for creating, designing, and implementing custom subagents with guided best practices, design patterns, and automated validation.

## Features

- **Interactive creation workflow** - Linear questionnaire guides you through subagent design
- **Intelligent recommendations** - Checks existing subagents and recommends reusable agents
- **Best practices guidance** - Two comprehensive skills covering design patterns and implementation
- **Automated validation** - Validates subagent design for completeness and best practices
- **System prompt generation** - Automatically generates detailed system prompts
- **Proactive triggering** - Works both explicitly via `/create-subagent` and when you mention "I need a subagent that..."

## Installation

This plugin is part of the Claude Code plugin marketplace. Enable it via Claude Code's plugin manager or copy to your plugins directory.

## Usage

### Create a New Subagent

```
/create-subagent
```

The command will guide you through:
1. **Role & Purpose** - What should the subagent do?
2. **Tool Access** - Which tools does it need?
3. **Model Selection** - Which AI model to use?
4. **Advanced Options** - Permission modes, skills to preload, etc.

The wizard generates a properly formatted subagent markdown file and saves it to `.claude/agents/` automatically.

### Proactive Creation

Simply mention what you need:

```
I need a subagent that analyzes performance issues in Go applications
```

Claude will proactively invoke the subagent architect to help you design it.

## Plugin Components

### Command
- **`/create-subagent`** - Interactive wizard for subagent creation with validation and recommendations

### Agents
- **Subagent Architect** - Validates designs, recommends existing subagents, generates markdown with proper YAML frontmatter and system prompts

### Skills
- **Subagent Design Patterns** - Comprehensive guide to designing effective subagents, including trade-offs, anti-patterns, and team scenarios
- **Subagent Implementation** - Complete reference for YAML frontmatter, tutorial walkthrough, and copy-paste templates for common subagent types

## Learning Resources

Check out the included skills for:
- When to create a subagent vs. using the main conversation
- How to write effective descriptions for delegation
- Tool access patterns and permission modes
- Model selection guidance
- Real-world examples and templates

## Best Practices

✅ Design focused subagents for specific tasks
✅ Write clear, detailed descriptions for proper delegation
✅ Limit tool access to what's necessary
✅ Use appropriate models for the task (Haiku for speed, Sonnet for capability)
✅ Test and iterate on subagent behavior

See the Claude Code documentation on [subagents](https://code.claude.com/docs/en/sub-agents) for comprehensive guidance.

## License

MIT
