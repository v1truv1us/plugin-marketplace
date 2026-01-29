---
name: create-subagent
description: Create custom subagents with guided design validation
argument-hint: "[optional: subagent purpose]"
allowed-tools: AskUserQuestion, Write
---

# Create a Custom Subagent

Guide the user through subagent creation by gathering requirements and delegating to the subagent-architect.

## Workflow

### Step 1: Understand the Need

If the user provided a description, use it. Otherwise ask:
> What would you like this subagent to do?

### Step 2: Gather Requirements

Ask these questions in sequence:

1. **Triggers:** "When should Claude delegate to this subagent?"
2. **Responsibilities:** "What are the 2-3 main tasks?"
3. **Tool access:** "Modify files (Edit), create files (Write), run commands (Bash), or read-only?"
4. **Model:** "Fast (Haiku), balanced (Sonnet), capable (Opus), or inherit?"
5. **Constraints:** "Any special requirements?"

Summarize and confirm:
```
Your subagent will:
- Purpose: [Summary]
- Triggers: [When to use]
- Tools: [Access level]
- Model: [Choice]
```

### Step 3: Validate Requirements

Invoke the **subagent-architect** with all gathered requirements. The architect will:
- Check if existing subagents meet the need
- Validate the design completeness
- Recommend model, tools, and permissions
- Generate production-ready implementation

If the architect recommends an existing subagent, guide the user on using it.

### Step 4: Save and Finalize

Present the generated file and offer to save:
- Project-level: `.claude/agents/subagent-name.md`
- User-level: `~/.claude/agents/subagent-name.md`

After saving:
> **Next steps:**
> 1. Your subagent is ready immediately (no restart)
> 2. Test by asking questions that should trigger it
> 3. Edit the file anytime to refine behavior

## Guidelines

- Ask one question at a time
- Summarize before proceeding
- Trust the subagent-architect for design and validation
- Default to project-level storage
- Use kebab-case naming (e.g., `code-reviewer`)

## Handling Issues

**Unclear requirements:** Rephrase and confirm understanding
**Contradictions:** Present options to resolve
**Not suited for subagent:** Suggest alternatives (skill, command, main conversation)
