---
name: Subagent Design Patterns
description: This skill should be used when the user asks to "design a subagent", "how to structure a subagent", "what makes a good subagent", or discusses subagent trade-offs and patterns. Includes guidance on when to use subagents vs main conversation, writing effective descriptions, and tool access strategies.
version: 0.1.0
---

## Subagent Design Fundamentals

A subagent is a specialized autonomous AI assistant that operates in its own context window with custom configuration. Unlike the main conversation where Claude helps iteratively, subagents handle specific tasks independently and return results. Understanding when and how to use subagents is critical for building effective AI workflows.

### When to Use Subagents vs. Main Conversation

**Use the main conversation when:**
- Iterating on a solution with back-and-forth refinement
- Multiple phases share significant context (planning → implementation → testing)
- Making quick, targeted changes with frequent user feedback
- Latency is critical (subagents start fresh, may need setup time)

**Use subagents when:**
- The task produces verbose output you don't need in main context (test runs, log analysis, data processing)
- Enforcing specific tool restrictions or permissions is important
- The work is self-contained with a clear summary output
- Preserving main conversation context for other work is valuable
- Running tasks in parallel or background

★ Insight ─────────────────────────────────
**Key trade-off:** Subagents isolate context (preserving main conversation) but start fresh each time. Use them for self-contained tasks that return summaries, not for iterative work requiring frequent refinement.
─────────────────────────────────────────────

### The Core Design Principle: Role Clarity

The most critical aspect of subagent design is having a clear, specific role. A subagent's description determines when Claude delegates work to it.

**Write descriptions with:**
1. **Role statement** - What is the subagent's expertise? ("Database performance analyst", "TypeScript type system expert")
2. **Specific triggers** - What phrases should prompt delegation? ("Analyze slow queries", "Debug type errors")
3. **Boundaries** - What is explicitly out of scope?

**Poor description:**
```
description: Helps with debugging
```
Too vague—Claude won't know when to use it.

**Strong description:**
```
description: Database query performance specialist. Use proactively when analyzing slow queries, explaining execution plans, or optimizing database operations. Focuses specifically on query performance, not schema design.
```
Specific role, concrete triggers, clear boundaries.

### Tool Access Strategy

Subagents inherit all tools by default, but security and focus require limiting access to only what's necessary.

**Read-only analysis:** `tools: ["Read", "Grep", "Glob"]`
- Reviewers, analyzers, researchers
- Cannot modify anything
- Safe, focused analysis

**Code generation:** `tools: ["Read", "Write", "Grep", "Bash"]`
- Generators, refactorers, implementers
- Can read existing code and write new code
- Can run tests/validation via Bash
- Cannot edit (safe for new files)

**Code modification:** `tools: ["Read", "Edit", "Grep", "Bash"]`
- Fixers, optimizers, debuggers
- Can read and modify existing code
- Can run tests
- Higher privilege level

**Full access:** Omit tools field or list all available tools
- Complex multi-step workflows
- Rarely needed—most tasks fit above patterns

★ Insight ─────────────────────────────────
**Least privilege principle:** Restrict each subagent to minimum tools needed. A reviewer doesn't need Write; a generator shouldn't have Edit. This focuses behavior and improves safety.
─────────────────────────────────────────────

### Permission Modes

Permission modes control how subagents handle file operations. Choose based on the subagent's workflow.

**default** - Standard permission checking with prompts
- Safe for general use
- User approves each file operation
- Best for: Agents you're still testing

**acceptEdits** - Auto-accept file modifications
- Subagent can modify files without prompts
- Still respects permission rules
- Best for: Trusted agents doing expected modifications

**dontAsk** - Auto-deny non-allowed operations
- Runs without permission prompts
- Explicitly allowed tools still work normally
- Best for: Background tasks, automation

See the Implementation skill's references for complete permission mode details and use cases.

### Model Selection Strategy

Choose the model that balances capability for the task with cost and latency.

**Haiku** - Fast, cost-effective
- Data analysis, log processing, search/retrieval
- Quick checks and validations
- Background parallel work
- Cost: ~90% cheaper than Sonnet

**Sonnet** - Balanced (recommended default)
- Code analysis and generation
- Complex problem-solving
- General-purpose subagents
- Good quality-to-cost ratio

**Opus** - Most capable, expensive
- Complex reasoning tasks
- Novel problem-solving
- Architecture decisions
- Use when simpler models struggle

**inherit** - Use parent conversation's model
- Ensures consistency
- Recommended for most cases
- Only override when specific need

★ Insight ─────────────────────────────────
**Cost optimization:** A Haiku-based data analysis subagent running in background costs ~1/10 of Sonnet. Use task-appropriate models rather than always defaulting to most capable.
─────────────────────────────────────────────

### Common Subagent Patterns

**The Reviewer** - Analyzes code/docs without modifying
- Role: Expert code/documentation reviewer
- Tools: Read, Grep, Glob (read-only)
- Model: Sonnet (complex analysis)
- Trigger: "Use the code-reviewer to check..."
- Description includes specific review criteria

**The Analyzer** - Processes data and generates insights
- Role: Data analyst, log processor, metrics analyzer
- Tools: Read, Bash, Grep (no file writes)
- Model: Haiku (cost-effective)
- Trigger: "Analyze these logs..." or "Generate report..."
- Proactive for large output tasks

**The Generator** - Creates new code, docs, configs
- Role: Generator for specific artifact types
- Tools: Read, Write, Grep (new files only)
- Model: Sonnet (quality matters)
- Trigger: "Generate a..." or "Create..."
- System prompt includes output format/structure

**The Fixer** - Debugs and fixes issues
- Role: Debugging expert in specific domain
- Tools: Read, Edit, Bash, Grep (modify existing)
- Model: Sonnet (complex reasoning)
- Trigger: "Debug this..." or proactive on errors
- Includes reproduction, diagnosis, verification

**The Validator** - Checks configurations, schemas, compliance
- Role: Validator for specific system
- Tools: Read, Bash, Grep (testing only)
- Model: Haiku (validation is rule-based)
- Trigger: "Validate this..." or "Check..."
- Uses tools for testing/verification, not modification

### Designing for Parallel Execution

Subagents can run in parallel (background execution). Design them with this in mind:

**Self-contained work** - Each subagent should complete its task fully without needing results from others
**Clear output summaries** - Parallel subagents return summaries that synthesize findings
**Minimal dependencies** - Design independent tasks rather than sequential chains

Avoid: Subagents that depend on results from other subagents (use sequential delegation from main conversation instead)

## Advanced Considerations

### Preloading Skills into Subagents

You can inject skill content into a subagent's context at startup. Useful when the subagent needs domain knowledge:

```yaml
skills:
  - api-conventions
  - error-handling-patterns
```

The skill content becomes available to the subagent without runtime loading. This is powerful for domain-specific guidance that shouldn't be rediscovered each time.

### Hooks within Subagents

Subagents can define hooks for conditional validation. Example: allowing only SELECT queries in a read-only database agent.

Reference `references/validation-patterns.md` for detailed hook patterns and use cases.

### Designing for Marketplace Distribution

When designing subagents for distribution via plugin marketplaces:

**Clear Role Definitions** are critical for discoverability:
- Each subagent should have a specific, narrow focus
- Description must include concrete trigger phrases
- Example: "Database query optimizer" not "Helps with databases"

**Reusable Pattern Libraries:**
- If creating multiple related subagents, consider if they should share patterns
- Package common patterns as skills within your plugin
- Document how agents work together

**Versioning Strategy:**
- Use semantic versioning for your plugin
- Update plugin.json version when subagents change
- Document breaking changes in plugin README

**Marketplace Synchronization:**
- When distributing, maintain both marketplace.json and .claude-plugin/marketplace.json
- These files must stay in sync for proper distribution
- See Marketplace Resources section for detailed guidance

For marketplace registration best practices, see:
- **Anthropic Documentation:** [Create and Distribute a Plugin Marketplace](https://code.claude.com/docs/en/plugin-marketplaces#create-and-distribute-a-plugin-marketplace)

## Anti-Patterns to Avoid

❌ **Vague role description** - "Helps with stuff" gives no clear triggers
❌ **Too many tools** - Grant access to all tools when only a few are needed
❌ **Over-complicated prompts** - System prompts >5000 characters lose focus
❌ **Overlapping subagents** - Multiple agents with identical or nearly identical roles
❌ **Forgetting the summary** - Subagent produces output that stays in subagent context; always summarize findings

## Additional Resources

### Reference Files

For deeper guidance, consult:

- **`references/role-clarity.md`** - Writing powerful role descriptions with triggering examples
- **`references/tool-patterns.md`** - Tool access patterns with real examples
- **`references/trade-offs.md`** - Detailed trade-offs: subagents vs skills vs main conversation

### Example Files

Working examples in `examples/`:

- **`example-reviewer.yaml`** - Complete reviewer subagent design
- **`example-analyzer.yaml`** - Data analysis subagent pattern
- **`example-generator.yaml`** - Code generation subagent

Start with examples that match your use case, then customize for your domain.
