---
name: Subagent Design Patterns
description: Core principles for designing effective subagents. Use when asked to "design a subagent", "structure a subagent", "subagent best practices". Provides essential guidance with references for deep dives.
version: 0.2.0
---

## Core Concepts

A **subagent** is an autonomous AI assistant with custom configuration, operating in its own context window.

### When to Use Subagents vs. Main Conversation

| Use Main Conversation | Use Subagents |
|----------------------|---------------|
| Iterative refinement | Verbose output (logs, data) |
| Shared context across phases | Tool restrictions needed |
| Frequent user feedback | Self-contained tasks |
| Low latency required | Parallel/background work |

**Key trade-off:** Subagents isolate context but start fresh. Use for self-contained tasks with summary outputs.

For detailed analysis, see `references/when-to-use.md`.

## Five Core Design Decisions

### 1. Role Clarity (Most Critical)

Write descriptions with:
- **Role statement**: "Database performance analyst"
- **Triggers**: "Analyze slow queries", "Explain execution plans"
- **Boundaries**: "Not for schema design"

**Poor:** `description: Helps with debugging`
**Strong:** `description: Database query performance specialist. Use proactively when analyzing slow queries or explaining execution plans. Not for schema design.`

See `references/role-clarity.md` for complete guide with examples.

### 2. Tool Access Strategy

Grant minimum necessary tools:

| Pattern | Tools | Use For |
|---------|-------|---------|
| Read-only | `["Read", "Grep", "Glob"]` | Reviewers, analyzers |
| Generation | `["Read", "Write", "Bash"]` | Creators, scaffolders |
| Modification | `["Read", "Edit", "Bash"]` | Fixers, debuggers |

See `references/tool-patterns.md` for complete patterns and examples.

### 3. Model Selection

| Model | Best For | Cost |
|-------|----------|------|
| `haiku` | Data analysis, validation | ~90% cheaper |
| `sonnet` | Code tasks (recommended default) | Balanced |
| `opus` | Complex reasoning | Highest |
| `inherit` | Match parent (most common) | Varies |

### 4. Permission Modes

- `default` - Standard prompts (testing)
- `acceptEdits` - Auto-accept modifications (trusted agents)
- `dontAsk` - Auto-deny unpermitted (automation)

### 5. Common Patterns

| Pattern | Role | Tools | Model |
|---------|------|-------|-------|
| Reviewer | Code/doc analysis | Read-only | Sonnet |
| Analyzer | Data/log processing | Read+Bash | Haiku |
| Generator | Create artifacts | Read+Write | Sonnet |
| Fixer | Debug/fix issues | Read+Edit+Bash | Sonnet |
| Validator | Check configs | Read+Bash | Haiku |

## Anti-Patterns to Avoid

- Vague descriptions ("Helps with stuff")
- Too many tools (grant only what's needed)
- System prompts >5000 chars
- Overlapping subagents
- No summary output

## Quick Reference

For deeper guidance:
- `references/role-clarity.md` - Writing powerful descriptions
- `references/tool-patterns.md` - Tool access with examples
- `references/parallel-execution.md` - Background/parallel design
- See Implementation skill for technical frontmatter specs
