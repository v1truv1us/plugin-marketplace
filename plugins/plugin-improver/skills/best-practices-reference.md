---
name: best-practices-reference
description: Anthropic plugin development standards, conventions, and quality checklist
trigger-phrases:
  - "what are plugin standards"
  - "best practices for plugins"
  - "plugin development guidelines"
  - "anthropic plugin conventions"
---

# Claude Code Plugin Best Practices Reference

This skill provides the authoritative standards for plugin development based on Anthropic documentation and proven patterns.

## Core Standards

### 1. Plugin Manifest (plugin.json)

**Required Fields**:
```json
{
  "name": "kebab-case-name",          // Lowercase, hyphens, matches directory
  "version": "0.0.0",                  // Semantic versioning (major.minor.patch)
  "description": "Short description",  // 50-150 characters, clear purpose
  "author": {
    "name": "Author Name",
    "email": "email@example.com"
  }
}
```

**Recommended Fields**:
- `license`: "MIT" (or your license)
- `keywords`: ["relevant", "terms"] (3-7 items)
- `homepage`: URL to plugin homepage
- `repository`: GitHub repo URL

**Component References**:
```json
{
  "commands": {
    "command-id": "commands/command-name.md"  // Match keys in YAML frontmatter
  },
  "agents": {
    "agent-id": "agents/agent-name.md"
  },
  "skills": {
    "skill-id": "skills/skill-name.md"
  },
  "hooks": {
    "config": "hooks.json",
    "enabled": true
  }
}
```

### 2. Directory Structure

**Standard Layout**:
```
my-plugin/
├── plugin.json                 # Manifest
├── README.md                   # User documentation
├── CLAUDE.md                   # Developer guide
├── commands/                   # Auto-discovered
│   ├── command-1.md
│   └── command-2.md
├── agents/                     # Auto-discovered
│   ├── agent-1.md
│   └── agent-2.md
├── skills/                     # Auto-discovered
│   ├── skill-1.md
│   ├── skill-2/
│   │   ├── SKILL.md
│   │   └── references/         # Detailed docs
│   │       ├── guide-1.md
│   │       └── guide-2.md
├── hooks/                      # If using hooks
│   ├── hooks.json
│   └── scripts/
│       ├── event-handler.sh
│       └── helper.py
├── templates/                  # Optional, reusable templates
│   └── report-template.md
└── .claude-plugin/
    └── plugin.json             # Copy of manifest for local testing
```

### 3. Command Standards

**YAML Frontmatter**:
```yaml
---
name: command-id              # Required, kebab-case, matches plugin.json
description: "1-2 sentence"   # Required, user-facing description
argument-hint: "[optional]"   # If command takes arguments
allowed-tools: [Bash, Read]   # If restricting tool access
---
```

**Content Quality**:
- Clear purpose statement
- Workflow phases (if complex command)
- Examples or use cases
- References to related commands/agents/skills
- Error handling or edge cases

**Example Structure**:
```markdown
---
name: start-planning
description: Begin daily planning with task collection and prioritization
---

I'll help you plan your day. Let me gather today's context and your tasks.

[Workflow with clear phases]

1. **Collect Tasks** - What needs to happen today?
2. **Prioritize** - What matters most?
3. **Schedule** - When will you work on each?
4. **Confirm** - Does this plan feel right?

[Invoke agents or skills as needed]
```

### 4. Agent Standards

**YAML Frontmatter**:
```yaml
---
name: agent-id                           # Required, kebab-case
description: "Agent specialization"      # Required, what it does
when-to-invoke: "Conditions triggering"  # Required, when Claude invokes it
tools: [Bash, Read, Grep]               # Optional, if restricting access
---
```

**System Prompt Template**:
```markdown
You are [role] specializing in [domain].

**Your Core Responsibilities:**
1. [Specific responsibility]
2. [Specific responsibility]
3. [Specific responsibility]

**Analysis Process:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Quality Standards:**
- [Measurable standard]
- [Measurable standard]

**Output Format:**
[Describe expected output structure]

**Edge Cases:**
- [Case]: [How to handle]
```

### 5. Skill Standards

**YAML Frontmatter**:
```yaml
---
name: skill-id                          # Required, kebab-case
description: "What the skill teaches"   # Required
trigger-phrases:                        # Required, natural language triggers
  - "how users would ask for this"
  - "another natural phrasing"
  - "yet another way to request"
---
```

**Content Structure**:

```markdown
# [Skill Name]

## Core Concept (100-150 words)
Explain the main idea clearly and concisely.

## When to Use
- Scenario 1: Use this skill when...
- Scenario 2: Use this skill when...

## Key Principles
- Principle 1: Explanation
- Principle 2: Explanation

## Common Pattern
[Provide a template or example structure]

## Deeper Dive
For more details, see the references below.

---

See `references/` directory for:
- [guide-1.md] - Detailed explanation with examples
- [guide-2.md] - Advanced patterns
- [template.md] - Copy-paste template
```

### 6. Hook Standards

**hooks.json Structure**:
```json
{
  "hooks": [
    {
      "event": "SessionStart",
      "matcher": {},
      "script": "scripts/session-init.sh",
      "timeout": 5,
      "environment": {
        "PLUGIN_ROOT": "${CLAUDE_PLUGIN_ROOT}"
      }
    }
  ]
}
```

**Script Patterns**:
- Use `${CLAUDE_PLUGIN_ROOT}` for portable paths
- Exit 0 on success, non-zero on failure
- Graceful degradation (hooks shouldn't block main flow)
- Keep scripts focused and maintainable

### 7. Documentation Standards

**README.md** - User-facing
- Installation instructions
- Usage examples
- Configuration options
- Troubleshooting guide

**CLAUDE.md** - Developer guide
- Project overview
- Architecture explanation
- How each component works
- Testing instructions
- File modification guide

## Quality Checklist

**Plugin Structure** ✓
- [ ] plugin.json is valid JSON
- [ ] All fields properly formatted
- [ ] Commands/agents/skills referenced
- [ ] Files at referenced paths exist

**Naming Conventions** ✓
- [ ] Plugin name is kebab-case
- [ ] Component IDs are kebab-case
- [ ] File names are descriptive and kebab-case
- [ ] No camelCase or UPPERCASE in names

**Frontmatter** ✓
- [ ] All YAML frontmatter valid
- [ ] name field present in all components
- [ ] description field concise and clear
- [ ] Agents have when-to-invoke
- [ ] Skills have trigger-phrases

**Content Quality** ✓
- [ ] Commands have clear workflows
- [ ] Agents have system prompts with processes
- [ ] Skills have core concepts and examples
- [ ] Cross-references are correct
- [ ] No broken links or missing files

**Documentation** ✓
- [ ] README.md present and helpful
- [ ] CLAUDE.md explains architecture
- [ ] Examples provided where needed
- [ ] Troubleshooting guidance included

## Anti-Patterns to Avoid

❌ **Generic Agent Roles**
- Don't: "You are a helpful assistant"
- Do: "You are a prioritization specialist using the Eisenhower matrix"

❌ **Vague Trigger Phrases**
- Don't: "help", "improve", "optimize"
- Do: "prioritize my tasks", "optimize my day", "categorize by importance"

❌ **Unclear Responsibilities**
- Don't: "Help with planning tasks"
- Do: "Classify tasks into Q1/Q2/Q3/Q4, analyze workload, suggest focus areas"

❌ **Missing Process Steps**
- Don't: "Analyze the data"
- Do: "1. Load data 2. Parse structure 3. Compare standards 4. Generate report"

❌ **Hardcoded Credentials**
- Don't: Store API keys in code
- Do: Use environment variables only

❌ **Mixing Concerns**
- Don't: Put agent logic in commands
- Do: Agents for reasoning, commands for workflow, skills for knowledge

## References

See `references/` directory for:
- `anthropic-checklist.md` - Complete validation checklist
- `prompt-patterns.md` - Examples of strong system prompts
- `scoring-rubric.md` - Quality scoring methodology
