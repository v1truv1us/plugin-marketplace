# Complete YAML Frontmatter Reference

## Field Reference

### name (Required)

**Purpose:** Unique identifier for the agent

**Format:**
```yaml
name: agent-name
```

**Rules:**
- 3-50 characters
- Lowercase letters, numbers, hyphens only
- Must start and end with alphanumeric character
- No spaces, underscores, or special characters

**Valid examples:**
```yaml
name: code-reviewer
name: test-generator-v2
name: api-docs-writer
name: security-checker
```

**Invalid examples:**
```yaml
name: code_reviewer        # underscore not allowed
name: -start               # can't start with hyphen
name: end-                 # can't end with hyphen
name: 24                   # too short (< 3 chars)
name: my awesome agent     # spaces not allowed
name: @special-char        # special char not allowed
```

### description (Required)

**Purpose:** Defines when Claude should delegate to this agent

**Format:**
```yaml
description: |
  [Triggering conditions]. Examples:

  <example>
  Context: [Scenario]
  user: "[User's request]"
  assistant: "[How Claude responds]"
  <commentary>
  [Why this agent is appropriate]
  </commentary>
  </example>
```

**Requirements:**
- Include 2-4 concrete examples
- Each example must have: Context, user, assistant, commentary
- Use `<example>` XML tags for structure
- Be specific about triggering conditions

**Minimum length:** 100 characters
**Recommended length:** 300-1000 characters with examples

**Example:**
```yaml
description: |
  Use this agent when testing code and verifying functionality.
  Proactively use after code implementations. Examples:

  <example>
  Context: User just wrote new API endpoint
  user: "Write tests for this endpoint"
  assistant: "I'll use the test-generator to create comprehensive tests"
  <commentary>
  Test generation is the agent's core responsibility
  </commentary>
  </example>

  <example>
  Context: Tests are failing
  user: "Can you debug why these tests fail?"
  assistant: "I'll have the test-generator debug and fix the failing tests"
  <commentary>
  Test debugging is within the generator's scope
  </commentary>
  </example>
```

### model (Required)

**Purpose:** Which AI model the agent uses

**Format:**
```yaml
model: inherit
```

**Valid values:**
- `inherit` - Use same model as parent conversation (recommended)
- `sonnet` - Claude Sonnet (balanced capability/cost)
- `opus` - Claude Opus (most capable, more expensive)
- `haiku` - Claude Haiku (fast, cost-effective)

**Model selection guide:**

| Model | Best For | Speed | Cost | Capability |
|-------|----------|-------|------|------------|
| inherit | Most cases | Variable | Variable | Consistent |
| haiku | Fast analysis, data processing, logs | ⭐⭐⭐ | ⭐ | ⭐⭐ |
| sonnet | Coding tasks, general purpose | ⭐⭐ | ⭐⭐ | ⭐⭐⭐ |
| opus | Complex reasoning, novel problems | ⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |

**Examples:**
```yaml
# Default - matches parent
model: inherit

# Fast analysis agent
model: haiku

# Balanced coding agent
model: sonnet

# Complex reasoning
model: opus
```

### color (Required)

**Purpose:** Visual identifier for the agent in UI

**Format:**
```yaml
color: blue
```

**Valid values:** `blue`, `cyan`, `green`, `yellow`, `magenta`, `red`

**Color selection guide:**

| Color | Use For | Example |
|-------|---------|---------|
| blue | Analysis, review, investigation | code-reviewer, analyzer |
| cyan | Research, exploration, discovery | researcher, explorer |
| green | Success, generation, creation | generator, builder |
| yellow | Caution, validation, checking | validator, checker |
| magenta | Creative, synthesis, design | designer, architect |
| red | Critical, security, errors | security-checker, fixer |

**Examples:**
```yaml
color: blue        # code review agent
color: green       # code generator
color: yellow      # validator
color: red         # security agent
```

### tools (Optional)

**Purpose:** Restrict agent to specific tools

**Format:**
```yaml
tools: ["Read", "Write", "Bash"]
```

**Valid values:**
- `Read` - Read files
- `Write` - Create new files
- `Edit` - Modify existing files
- `Grep` - Search file contents
- `Glob` - Find files by pattern
- `Bash` - Execute shell commands
- `AskUserQuestion` - Ask user for input
- `TodoWrite` - Manage task lists
- `*` - All tools

**Default:** If omitted, agent inherits all parent tools

**Common tool sets:**

```yaml
# Read-only analysis
tools: ["Read", "Grep", "Glob"]

# Code generation
tools: ["Read", "Write", "Bash", "Grep"]

# Code modification
tools: ["Read", "Edit", "Bash", "Grep"]

# Database queries
tools: ["Read", "Bash"]

# Documentation generation
tools: ["Read", "Write"]
```

**Guidelines:**
- Include only tools needed for the task
- Use principle of least privilege
- Exclude tools that aren't needed
- Review for safety implications

**Examples:**
```yaml
# Reviewer - read-only
tools: ["Read", "Grep", "Glob"]

# Generator - creates new files
tools: ["Read", "Write", "Bash"]

# Fixer - modifies existing code
tools: ["Read", "Edit", "Bash"]

# Analyzer - processes data
tools: ["Read", "Bash", "Grep"]
```

### permissionMode (Optional)

**Purpose:** Control how agent handles permissions

**Format:**
```yaml
permissionMode: acceptEdits
```

**Valid values:**
- `default` - Standard permission checking with prompts (default)
- `acceptEdits` - Auto-accept file edits
- `dontAsk` - Auto-deny operations not explicitly allowed
- `bypassPermissions` - Skip all permission checks (use with caution)
- `plan` - Read-only exploration mode

**Default:** `default` if omitted

**When to use each:**

| Mode | Use When |
|------|----------|
| default | Testing agent, want user approval |
| acceptEdits | Trusted agent that should auto-fix |
| dontAsk | Background automation, pre-approved |
| bypassPermissions | ⚠️ Carefully controlled scenarios only |
| plan | Research/exploration without modification |

**Examples:**
```yaml
# Standard - ask user
permissionMode: default

# Auto-accept edits
permissionMode: acceptEdits

# Auto-deny unpermitted
permissionMode: dontAsk

# Read-only mode
permissionMode: plan
```

**⚠️ Warning:** `bypassPermissions` skips all permission checks. Use only in carefully controlled scenarios.

### skills (Optional)

**Purpose:** Preload skill content into agent context

**Format:**
```yaml
skills:
  - skill-name-1
  - skill-name-2
```

**When to use:**
- Agent needs domain-specific knowledge
- Want knowledge available without runtime loading
- Multiple related skills provide context

**Default:** If omitted, no skills preloaded

**Examples:**
```yaml
# API developer with conventions and patterns
skills:
  - api-conventions
  - error-handling-patterns
  - typescript-standards

# Database agent with schema knowledge
skills:
  - database-schema
  - query-optimization

# Test generator with testing patterns
skills:
  - testing-patterns
  - assertion-examples
```

**Effect:** Full skill content is injected into agent's context window at startup.

### hooks (Optional)

**Purpose:** Define lifecycle hooks for the agent

**Format:**
```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate.sh"
```

**Hook events:**
- `PreToolUse` - Before tool execution
- `PostToolUse` - After tool execution
- `Stop` - When agent finishes

**When to use:**
- Validate tool input before execution
- Process output after execution
- Cleanup when agent stops
- Conditional validation

**Example - Validate database queries:**
```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-readonly-query.sh"
```

The hook script receives the tool input as JSON and can approve (exit 0) or block (exit 2) execution.

See the Subagent Design Patterns skill for detailed hook patterns.

## Complete Frontmatter Examples

### Minimal Required

```yaml
---
name: simple-agent
description: Use when... Examples: <example>...</example>
model: inherit
color: blue
---
```

### Standard with Tools

```yaml
---
name: code-reviewer
description: Use when reviewing code. Examples: <example>...</example>
model: sonnet
color: blue
tools: ["Read", "Grep", "Glob"]
permissionMode: default
---
```

### Complete with All Options

```yaml
---
name: api-developer
description: Use when implementing APIs. Examples: <example>...</example>
model: sonnet
color: green
tools: ["Read", "Write", "Edit", "Bash", "Grep"]
permissionMode: acceptEdits
skills:
  - api-conventions
  - error-handling
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/lint.sh"
---
```

## Field Validation Checklist

Before finalizing frontmatter:

```
name:
  ☐ 3-50 characters
  ☐ Lowercase letters, numbers, hyphens only
  ☐ Starts with alphanumeric
  ☐ Ends with alphanumeric
  ☐ No spaces or underscores

description:
  ☐ Includes triggering conditions
  ☐ Includes 2-4 <example> blocks
  ☐ Each example has: Context, user, assistant, commentary
  ☐ Specific, not generic
  ☐ 100-1000 characters recommended

model:
  ☐ One of: inherit, sonnet, opus, haiku
  ☐ Appropriate for agent's task

color:
  ☐ One of: blue, cyan, green, yellow, magenta, red
  ☐ Visually distinct from other agents

tools (if specified):
  ☐ Only necessary tools included
  ☐ Consistent with agent role
  ☐ Security reviewed

permissionMode (if specified):
  ☐ Appropriate for use case
  ☐ bypassPermissions only if justified

skills (if specified):
  ☐ All listed skills exist
  ☐ Relevant to agent task

hooks (if specified):
  ☐ Valid event types
  ☐ Script paths exist
  ☐ Proper JSON format
```
