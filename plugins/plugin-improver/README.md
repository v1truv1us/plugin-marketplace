# Plugin Improver

**Iteratively evaluate and enhance plugins with Anthropic best practices.** Analyzes quality, suggests concrete improvements, and integrates with Ralph Loop for continuous self-improvement.

## Overview

Plugin Improver is a meta-plugin that helps you continuously improve other plugins in your marketplace. It provides:

- **Comprehensive Quality Assessment** - Multi-dimensional evaluation across best practices, code quality, and prompt clarity
- **Actionable Recommendations** - Concrete before/after code examples for every suggestion
- **Ralph Loop Integration** - Continuous improvement through automated iterative enhancement
- **Best Practices Alignment** - Reference implementation of Anthropic standards and conventions

## Quick Start

### Basic Usage

```bash
/improver:improve-plugin plugin-name
```

This will:
1. Analyze your plugin's structure, standards compliance, and quality
2. Launch specialized evaluation agents
3. Generate a comprehensive improvement report
4. Suggest concrete improvements with code examples

### With Ralph Loop

```bash
/ralph-loop:ralph-loop "improve plugins in my marketplace"
```

The Ralph Loop will iteratively:
1. Evaluate each plugin in your marketplace
2. Apply improvements from the evaluation
3. Generate new reports showing progress
4. Track quality metrics over time

## What Gets Evaluated

### Best Practices Compliance (30% of score)
- Plugin structure and organization
- plugin.json manifest validity
- YAML frontmatter standards
- Component naming conventions
- Documentation completeness

### Code Quality (35% of score)
- Architecture and separation of concerns
- Error handling and robustness
- Context efficiency and performance
- Maintainability and clarity
- Design patterns and anti-patterns

### Prompt Quality (35% of score)
- Skill descriptions and trigger phrases
- Agent system prompts and processes
- Command guidance clarity
- Consistency and tone across components
- Completeness and accuracy

## Example Output

```
# Plugin Improvement Report: my-plugin

## Executive Summary
Overall Quality Score: 72/100
Status: Important Improvements Needed

## Evaluation Results

### Best Practices Compliance: 68/100
- ✅ Directory structure organized
- ⚠️ Some skill trigger phrases too generic
- ❌ Missing CLAUDE.md documentation

### Code Quality: 75/100
- ✅ Good error handling patterns
- ⚠️ Context efficiency could improve
- ⚠️ Some command logic could delegate to agents

### Prompt Quality: 70/100
- ⚠️ Agent roles are generic
- ⚠️ Command guidance could be clearer
- ❌ Trigger phrases lack specificity

## Important Improvements

### 1. Enhance Trigger Phrases (Impact: High)
**Location**: skills/prioritization-skill.md

BEFORE:
```yaml
trigger-phrases:
  - "help with priorities"
  - "improve"
  - "organize"
```

AFTER:
```yaml
trigger-phrases:
  - "prioritize my tasks"
  - "what should I do first"
  - "organize my workload"
  - "which tasks matter most"
```

**Why**: Specific phrases improve discovery and reduce false positives.

### 2. Clarify Agent Role (Impact: High)
**Location**: agents/prioritization-agent.md

BEFORE:
```markdown
You are an assistant that helps with task prioritization.
```

AFTER:
```markdown
You are a prioritization specialist using the Eisenhower matrix to classify tasks by urgency and importance.
```

**Why**: Specific role enables better analysis and prevents generic responses.

### 3. Add CLAUDE.md Documentation (Impact: Medium)
**Location**: Create plugins/my-plugin/CLAUDE.md

See `references/` for template and examples.

**Why**: Helps other developers understand plugin architecture and make changes.

## Ralph Loop Integration

When running with Ralph Loop:

1. **Initial Assessment** - Comprehensive evaluation of all plugins
2. **Improvement Suggestions** - Concrete recommendations with examples
3. **Implementation** - Apply suggested improvements to plugins
4. **Re-evaluation** - Measure quality improvements
5. **Iteration** - Continue improving across multiple cycles

Each iteration tracks:
- Quality score changes
- Number of improvements applied
- Categories where most progress was made
- Remaining issues to address

## Key Features

### Multi-Agent Evaluation
- **Best Practices Evaluator** - Checks structure and conventions
- **Quality Analyzer** - Assesses code and architecture
- **Prompt Optimizer** - Evaluates clarity and specificity

### Reusable Knowledge
- **best-practices-reference** - Anthropic standards checklist
- **prompt-enhancement** - Techniques for improving clarity
- **architecture-patterns** - Design patterns and guidance

### Comprehensive Feedback
- Specific file references (file:line-number)
- Before/after code examples
- Clear explanations of WHY changes matter
- Actionable implementation steps

## Commands

### improve-plugin [plugin-name]

Evaluate a plugin and generate improvement recommendations.

```bash
/improver:improve-plugin planner
/improver:improve-plugin prompt-orchestrator
```

Provides:
- Quality score breakdown
- Critical issues (must fix)
- Important improvements (should fix)
- Optional enhancements (nice to have)
- Implementation roadmap

## Agents

### improver-coordinator
Orchestrates the multi-agent evaluation workflow and synthesizes results.

### best-practices-evaluator
Assesses plugin structure, standards compliance, and conventions.

### quality-analyzer
Analyzes code architecture, error handling, and design patterns.

### prompt-optimizer
Evaluates skill descriptions, agent system prompts, and command guidance.

## Skills

### best-practices-reference
Comprehensive checklist of Anthropic plugin standards and conventions.

### prompt-enhancement
Techniques for improving clarity, specificity, and effectiveness of plugin prompts.

### architecture-patterns
Design patterns, structural guidance, and plugin architecture best practices.

## Installation

1. Clone this plugin into your plugins directory:
```bash
cp -r plugin-improver ~/.claude-plugin/plugin-improver
```

2. Or add to your marketplace:
```bash
cp -r plugin-improver plugins/plugin-improver
```

3. Restart Claude Code to load the plugin.

## Configuration

Plugin Improver works out of the box. No configuration required.

Optional: Use with Ralph Loop for continuous improvement:
```bash
/ralph-loop:ralph-loop "improve plugins" --max-iterations 10
```

## Ralph Loop Usage

### Start Continuous Improvement Loop

```bash
/ralph-loop:ralph-loop "iteratively improve all plugins in my marketplace using plugin-improver"
```

### Track Progress

Monitor improvements over time in `.improvements/` directory:
- `plugin-[name]-evaluation.md` - Latest evaluation report
- `scores.json` - Quality score history

### Example Loop Results

**Iteration 1**: Overall quality 65/100
- 3 critical issues found
- 12 important improvements suggested

**Iteration 2**: Overall quality 73/100
- Critical issues addressed
- 8 important improvements remaining

**Iteration 3**: Overall quality 81/100
- Most improvements implemented
- Polish and refinement remaining

## Best Practices

### Regular Evaluation
- Run `/improver:improve-plugin` after adding new commands/agents/skills
- Use as part of your development workflow
- Track scores over time

### Concrete Implementation
- Apply suggested improvements incrementally
- Test changes before committing
- Reference the before/after examples provided

### Ralph Loop Iteration
- Start with automated improvement loop
- Manually review and refine as needed
- Track progress metrics over time

## Troubleshooting

### "Plugin not found"
Check that the plugin directory exists and path is correct.

### "Score lower than expected"
- Review the detailed findings in the report
- Focus on critical issues first
- Use suggestions as a roadmap

### "Ralph Loop not completing"
Ensure you set `--max-iterations N` to avoid infinite loop.

## Contributing

Improvements and suggestions welcome! This plugin is designed to be iteratively enhanced.

## License

MIT

## See Also

- [Anthropic Plugin Development Guide](https://github.com/anthropics/claude-code)
- [prompt-orchestrator](../prompt-orchestrator) - Prompt quality optimization
- [marketplace-manager](../marketplace-manager) - Plugin distribution
- [subagent-creator](../subagent-creator) - Agent design guidance
