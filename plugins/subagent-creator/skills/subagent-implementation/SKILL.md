---
name: Subagent Implementation
description: This skill should be used when the user asks to "implement a subagent", "write subagent YAML", "create subagent frontmatter", "what fields go in frontmatter", or discusses system prompt structure and templates for subagents.
version: 0.1.0
---

## Subagent Implementation Essentials

Implementing a subagent requires understanding the file structure, YAML frontmatter fields, and system prompt design. This skill provides the technical foundation for converting a subagent design into a working implementation.

## File Structure

Subagent files are Markdown with YAML frontmatter followed by the system prompt:

```markdown
---
name: agent-name
description: When to use this agent...
model: inherit
color: blue
---

You are [agent role]...

**Your Core Responsibilities:**
1. [Responsibility 1]
2. [Responsibility 2]

[System prompt body continues...]
```

**File location:** `.claude/agents/agent-name.md` or `.claude-plugin/agents/agent-name.md`

**Naming convention:** Use kebab-case, lowercase with hyphens only

### File Creation Workflow

1. Choose agent name (kebab-case, 3-50 chars)
2. Create file at correct location
3. Add YAML frontmatter (see below)
4. Write system prompt in Markdown
5. Save and test (no restart needed)

## YAML Frontmatter Fields

### Required Fields

#### name
- **Purpose:** Unique identifier for the agent
- **Format:** Lowercase letters, numbers, hyphens only
- **Length:** 3-50 characters
- **Pattern:** Must start and end with alphanumeric
- **Examples:** `code-reviewer`, `test-generator`, `api-analyzer`

```yaml
name: code-reviewer
```

#### description
- **Purpose:** Defines when Claude should delegate to this agent
- **Format:** Text with 2-4 `<example>` blocks
- **Length:** 200-1000 characters (with examples)
- **Must include:** Triggering conditions and concrete examples

```yaml
description: |
  Use this agent when reviewing code for quality and security.
  Use proactively after code changes. Examples:

  <example>
  Context: User just wrote new authentication code
  user: "Review this for security issues"
  assistant: "I'll use the code-reviewer to check for vulnerabilities"
  <commentary>
  Security code review is the agent's core function
  </commentary>
  </example>
```

#### model
- **Purpose:** Which AI model the agent uses
- **Options:** `inherit`, `sonnet`, `opus`, `haiku`
- **Default:** `inherit`
- **Recommendation:** Use `inherit` unless specific need

```yaml
model: inherit
```

**Model choice guide:**
- `inherit` - Default, matches parent conversation
- `haiku` - Fast/cheap for analysis, data processing
- `sonnet` - Balanced for most coding tasks
- `opus` - Most capable, use for complex reasoning

#### color
- **Purpose:** Visual identifier in UI
- **Options:** `blue`, `cyan`, `green`, `yellow`, `magenta`, `red`
- **Recommendation:** Use different colors for different agent types

```yaml
color: blue
```

**Color guidelines:**
- Analysis/review: blue, cyan
- Success/generation: green
- Caution/validation: yellow
- Error/critical: red
- Creative/synthesis: magenta

### Optional Fields

#### tools
- **Purpose:** Restrict agent to specific tools
- **Format:** Array of tool names
- **Default:** All tools inherited from parent
- **When to use:** Limit access for security/focus

```yaml
tools: ["Read", "Grep", "Glob"]
```

**Common tool sets:**
- **Read-only:** `["Read", "Grep", "Glob"]`
- **Code generation:** `["Read", "Write", "Bash", "Grep"]`
- **Code modification:** `["Read", "Edit", "Bash", "Grep"]`
- **Database queries:** `["Read", "Bash", "Grep"]`

See the Design Patterns skill for detailed tool patterns.

#### permissionMode
- **Purpose:** Control how agent handles permissions
- **Options:** `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, `plan`
- **Default:** `default`
- **Recommendation:** Use `default` unless specific need

```yaml
permissionMode: acceptEdits
```

**Permission mode reference:**
- `default` - Prompt user for each operation
- `acceptEdits` - Auto-accept file edits
- `dontAsk` - Auto-deny unpermitted operations
- `bypassPermissions` - Skip all checks (use with caution)
- `plan` - Read-only exploration mode

#### skills
- **Purpose:** Inject skill content into agent context
- **Format:** Array of skill names
- **When to use:** Preload domain knowledge into agent

```yaml
skills:
  - api-conventions
  - error-handling-patterns
```

The skill content is automatically loaded when the agent starts.

#### hooks
- **Purpose:** Define lifecycle hooks for the agent
- **Format:** Hook configuration
- **When to use:** Add validation before tool use

```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-query.sh"
```

Reference the Subagent Design Patterns skill for validation patterns.

## System Prompt Structure

The Markdown body below frontmatter becomes the system prompt. Structure it for clarity:

### Standard System Prompt Template

```markdown
You are a [role] specializing in [domain].

**Your Core Responsibilities:**
1. [Primary responsibility]
2. [Secondary responsibility]
3. [Additional responsibilities...]

**Analysis Process:**
1. [First step]
2. [Second step]
3. [Verification step]

**Quality Standards:**
- [Standard 1]
- [Standard 2]
- [Standard 3]

**Output Format:**
Provide results as:
- [What to include]
- [How to organize]
- [Any formatting requirements]

**Edge Cases:**
Handle these special situations:
- [Case 1]: [How to handle]
- [Case 2]: [How to handle]
```

### Writing Guidelines

✅ **DO:**
- Use second person ("You are...", "You will...")
- Be specific and concrete
- Provide step-by-step processes
- Define output format clearly
- Include quality standards
- Address edge cases
- Keep under 10,000 characters
- Use imperative for steps ("Analyze", "Check", "Validate")

❌ **DON'T:**
- Use first person ("I am...", "I will...")
- Be vague or generic
- Omit procedural steps
- Leave output ambiguous
- Skip quality guidance
- Ignore error cases
- Write a novel (>10k chars)

### System Prompt Sections

#### Role Statement (1-2 sentences)
Define the agent's expertise and focus:

```
You are a code security reviewer specializing in TypeScript applications.
Focus on identifying vulnerabilities, security best practices, and compliance issues.
```

#### Responsibilities (3-5 bullet points)
What the agent actively does:

```
**Your Core Responsibilities:**
1. Identify security vulnerabilities in code
2. Recommend security best practices
3. Ensure compliance with security standards
4. Explain security implications
5. Provide remediation guidance
```

#### Process (Step-by-step workflow)
How the agent should approach tasks:

```
**Analysis Process:**
1. Understand the code's context and purpose
2. Scan for common vulnerabilities (injection, XSS, auth issues)
3. Review API interactions for security
4. Check credential and secret handling
5. Verify access control and permissions
6. Summarize findings by severity
```

#### Quality Standards (3-5 standards)
What makes the output good:

```
**Quality Standards:**
- Findings are specific with line references
- Explanations are clear and actionable
- Recommendations include implementation examples
- Language is professional and constructive
- Output is well-organized by severity
```

#### Output Format (Explicit structure)
What the final output should look like:

```
**Output Format:**
Provide security review results organized by severity:

**Critical (Must Fix):**
- Issue: [Description]
- Location: [File and line]
- Risk: [Security implications]
- Fix: [How to remediate]

**Warnings (Should Fix):**
- [Same structure...]

**Suggestions (Consider):**
- [Same structure...]

End with a brief security summary and overall risk level.
```

#### Edge Cases (Specific scenarios)
How to handle tricky situations:

```
**Edge Cases:**
- External libraries: Focus on application code, note library risks
- Legacy code: Flag issues but acknowledge constraints
- Third-party APIs: Document security assumptions
- Unclear context: Ask for clarification rather than guessing
```

## Common System Prompt Patterns

See the examples/ directory for working system prompts for:
- Code reviewers
- Test generators
- Documentation writers
- Analyzers and researchers
- Bug fixers

Each example includes the complete system prompt ready to customize.

## Frontmatter Checklist

Before finalizing, verify:

```
✅ name: 3-50 chars, lowercase, hyphens, no spaces
✅ description: Has 2-4 examples with context/user/assistant/<commentary>
✅ model: Set to inherit, haiku, sonnet, or opus
✅ color: One of the 6 color options
✅ tools: (optional) List only necessary tools
✅ permissionMode: (optional) Set appropriate mode
✅ skills: (optional) List preloaded skills
```

## System Prompt Checklist

Before finalizing, verify:

```
✅ Role is clear and specific
✅ Responsibilities are numbered and concrete
✅ Process includes step-by-step workflow
✅ Quality standards are explicit
✅ Output format is detailed and unambiguous
✅ Edge cases are addressed
✅ Total length <10,000 characters
✅ Uses second person throughout
✅ No first person language
```

## Testing Implementation

After creating an agent:

1. **Syntax check** - YAML frontmatter is valid
2. **Trigger test** - Ask questions that should trigger the agent
3. **Functionality test** - Does it behave as described?
4. **Output test** - Does output match specified format?

See references/ and examples/ for complete templates and validation guidance.

## Distributing Subagents via Plugin Marketplaces

When you've created and tested subagents, you can package them in a Claude Code plugin and distribute them via plugin marketplaces.

### Plugin Structure for Subagents

To distribute subagents:

1. **Create a Claude Code plugin** with agents/ directory
2. **Add plugin.json** manifest defining your agents
3. **Register in marketplace.json** for discoverability
4. **Maintain .claude-plugin/marketplace.json** for distribution sync

```
my-subagent-plugin/
├── plugin.json                          # Plugin manifest
├── agents/
│   ├── agent-one.md                    # Your subagents
│   └── agent-two.md
├── .claude-plugin/
│   └── plugin.json                     # Deployment manifest
└── README.md
```

### Marketplace Registration

Plugin marketplaces require synchronization between:
- **marketplace.json** - Primary registry of all plugins
- **.claude-plugin/marketplace.json** - Deployed version for distribution

**Important:** Keep both files in sync. Each marketplace entry must include:
- Plugin name and version
- Source path to agent files
- Clear description of agent capabilities
- Author information

### Resources

For comprehensive guidance on creating and distributing plugins via marketplaces, see:
- **Anthropic Documentation:** [Create and Distribute a Plugin Marketplace](https://code.claude.com/docs/en/plugin-marketplaces#create-and-distribute-a-plugin-marketplace)
- Key topics: marketplace structure, plugin registration, best practices for distribution

### Best Practices

✅ **DO:**
- Keep marketplace registries synchronized
- Include agent purpose in description
- Test agent triggering conditions before distribution
- Document agent capabilities in README
- Version your plugins semantically

❌ **DON'T:**
- Forget to update both marketplace.json files
- Leave agent descriptions vague
- Skip testing before publishing
- Hardcode paths in agent definitions

## Additional Resources

### Reference Files

For deeper guidance, consult:

- **`references/frontmatter-reference.md`** - Complete field documentation
- **`references/system-prompt-patterns.md`** - Detailed pattern templates
- **`references/validation-guide.md`** - Comprehensive validation checklist

### Example Files

Complete working examples in `examples/`:

- **`example-reviewer.yaml`** - Code reviewer agent
- **`example-analyzer.yaml`** - Data analysis agent
- **`example-generator.yaml`** - Code generation agent
- **`example-fixer.yaml`** - Bug fixing agent

Copy these and customize for your use case.

### Templates

Ready-to-use templates in `references/templates/`:

- **`template-reviewer.md`** - Review agent template
- **`template-analyzer.md`** - Analyzer template
- **`template-generator.md`** - Generator template

Each template includes all sections with guidance on what to customize.
