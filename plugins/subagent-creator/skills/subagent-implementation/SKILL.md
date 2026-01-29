---
name: Subagent Implementation
description: Technical reference for implementing subagents. Use when asked about frontmatter fields, system prompt structure, or subagent file format. Provides essential specs with references for details.
version: 0.2.0
---

## File Structure

Subagent files are Markdown with YAML frontmatter:

```markdown
---
name: agent-name
description: When to use this agent...
model: inherit
color: blue
tools: ["Read", "Grep"]
---

You are [agent role]...

**Responsibilities:**
1. [Task 1]
2. [Task 2]
```

**Location:** `.claude/agents/` or `.claude-plugin/agents/`
**Naming:** kebab-case, 3-50 chars (e.g., `code-reviewer`)

## Frontmatter Fields

### Required Fields

| Field | Format | Example |
|-------|--------|---------|
| `name` | kebab-case, 3-50 chars | `code-reviewer` |
| `description` | Text with 2-4 examples | See below |
| `model` | `inherit`/`haiku`/`sonnet`/`opus` | `inherit` |
| `color` | `blue`/`cyan`/`green`/`yellow`/`magenta`/`red` | `blue` |

### Description Format

Include 2-4 `<example>` blocks:

```yaml
description: |
  Use when reviewing code for quality. Examples:
  <example>
  Context: User wrote new code
  user: "Review this"
  assistant: "I'll use the code-reviewer"
  <commentary>Code review is core function</commentary>
  </example>
```

### Optional Fields

| Field | Purpose | Example |
|-------|---------|---------|
| `tools` | Restrict tool access | `["Read", "Grep", "Glob"]` |
| `permissionMode` | Permission handling | `acceptEdits` |
| `skills` | Preload skills | `["api-conventions"]` |

**Permission modes:** `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, `plan`

See `references/frontmatter-reference.md` for complete field documentation.

## System Prompt Template

```markdown
You are a [role] specializing in [domain].

**Responsibilities:**
1. [Primary task]
2. [Secondary task]

**Process:**
1. [Step 1]
2. [Step 2]
3. [Verification]

**Output Format:**
[Specify exact output structure]

**Edge Cases:**
- [Case 1]: [How to handle]
```

### Writing Guidelines

**DO:**
- Use second person ("You are...")
- Be specific and concrete
- Define output format clearly
- Keep under 10,000 characters

**DON'T:**
- Use first person ("I am...")
- Be vague
- Skip process steps
- Exceed 10k chars

See `references/system-prompt-patterns.md` for detailed templates.

## Quick Checklists

### Frontmatter
- [ ] name: 3-50 chars, kebab-case
- [ ] description: 2-4 examples
- [ ] model: valid option
- [ ] color: valid option
- [ ] tools: (optional) minimum needed

### System Prompt
- [ ] Clear role statement
- [ ] Numbered responsibilities
- [ ] Step-by-step process
- [ ] Explicit output format
- [ ] Edge cases addressed
- [ ] Under 10k chars

## Testing

1. **Syntax:** Valid YAML frontmatter
2. **Trigger:** Questions activate agent
3. **Behavior:** Matches description
4. **Output:** Follows format

## References

For complete documentation:
- `references/frontmatter-reference.md` - All fields with examples
- `references/system-prompt-patterns.md` - Detailed templates
- `examples/complete-analyzer-example.md` - Working example

For distribution via marketplaces, see the Anthropic docs on [Plugin Marketplaces](https://code.claude.com/docs/en/plugin-marketplaces).
