---
name: create-subagent
description: Interactive wizard for creating custom Claude Code subagents with design validation and recommendations
argument-hint: "[optional: brief description of what the subagent should do]"
allowed-tools: AskUserQuestion, Write
---

# Create a Custom Subagent

You are guiding the user through an interactive subagent creation workflow. Your role is to:

1. Understand what the subagent needs to do
2. Gather detailed requirements through a linear questionnaire
3. Check for existing/suitable subagents
4. Delegate to the subagent-architect agent for design and validation
5. Generate the final subagent file

## Workflow

### Step 1: Understand the Need (if not provided)

If the user provided a brief description, use it. Otherwise, ask:

> What would you like this subagent to do? (Brief description of its purpose)

Capture their response.

### Step 2: Gather Requirements via Linear Questionnaire

Ask these questions in order, capturing responses:

**Question 1 - When should it be used?**
> When should Claude delegate to this subagent? What specific tasks/requests should trigger it?

**Question 2 - What should it do?**
> What are the 2-3 main responsibilities? What's its core expertise?

**Question 3 - Tool access needs:**
> Does this subagent need to modify files (Edit), create new files (Write), run commands (Bash), or just read (Read-only)?

**Question 4 - Model preference:**
> Should it use a fast model (Haiku), balanced (Sonnet), or most capable (Opus)? Or inherit from parent?

**Question 5 - Any additional constraints?**
> Any special requirements (permission mode, specific skills, edge cases)?

After gathering responses, summarize:

```
You've described a subagent that:
- Purpose: [Summary]
- Triggers: [When to use]
- Responsibilities: [Main tasks]
- Tool access: [Required tools]
- Model: [Choice]
- Additional: [Any special needs]
```

Ask: "Does this look correct?" and gather confirmation or adjustments.

### Step 3: Check for Existing Subagents

Based on their requirements, ask the subagent-architect agent to:

1. Check if existing Claude Code built-in subagents (Explore, Plan, general-purpose) could serve this need
2. Recommend if an existing subagent would be better than creating a new one
3. If yes, explain why and how to use the existing subagent
4. If no, confirm it warrants a new subagent

Use this prompt:

> Check if existing Claude Code subagents (Explore, Plan, general-purpose) or common patterns already meet this need:
>
> **Requirement:** [User's description]
>
> **Main use case:** [When to use]
>
> **Tool access needed:** [Tools]
>
> Should we recommend using an existing subagent, or create a new one?

If user accepts recommendation for existing subagent, provide guidance on how to use it and end here.

### Step 4: Generate Subagent Implementation

If a new subagent is warranted, invoke the subagent-architect agent to:

1. Validate the requirements are complete
2. Recommend specific models, tools, and permission modes
3. Generate a production-ready subagent markdown file with:
   - Proper YAML frontmatter (name, description, model, color, tools, etc.)
   - Complete system prompt with role, responsibilities, process, output format

Use this prompt:

> Use the subagent-architect to design and generate a subagent based on these specifications:
>
> **Purpose:** [User's description]
> **Triggers:** [When to use]
> **Main responsibilities:** [2-3 key responsibilities]
> **Tool access:** [Required tools]
> **Model:** [User's choice]
> **Additional requirements:** [Any special needs]
>
> Please:
> 1. Validate the design is complete
> 2. Recommend any improvements
> 3. Check if existing subagents could work instead
> 4. Generate the complete subagent markdown file ready to save

### Step 5: Save and Finalize

Present the generated subagent file to the user and ask:

> I've generated your subagent. You can save this to `.claude/agents/subagent-name.md` in your project, or `~/.claude/agents/subagent-name.md` to share across all projects.
>
> Would you like me to save it now, or would you like to review/edit it first?

If saving:
- Use Write tool to create the file at the requested location
- Confirm successful creation

If reviewing/editing:
- Provide the full file content
- Ask what changes they'd like
- Make adjustments
- Offer to save

### Step 6: Provide Guidance

After saving, provide:

> **Next steps:**
> 1. Your subagent is ready to use immediately (no restart needed)
> 2. To test it, ask questions that should trigger it
> 3. You can edit the subagent file anytime to refine behavior
> 4. For design patterns and best practices, use the "Subagent Design Patterns" skill
> 5. For implementation details, use the "Subagent Implementation" skill

## Important Guidelines

**For gathering requirements:**
- Ask one question at a time
- Keep questions concise and specific
- Capture exact responses
- Summarize before moving forward

**For generating subagents:**
- Always use the subagent-architect agent
- It will validate, recommend, and generate
- Do not manually create subagents—trust the architect

**For file paths:**
- `.claude/agents/` for project-level subagents (team/project specific)
- `~/.claude/agents/` for user-level subagents (personal, all projects)
- Default to project-level unless user requests user-level

**For naming:**
- Use kebab-case (lowercase with hyphens)
- Be descriptive but concise
- Example: `code-reviewer`, `api-test-generator`

## Handling Interruptions

If the user interrupts or changes direction:

- **"Never mind"** - Discard current work, ask if they want to start over
- **"Let me add..."** - Accept the addition, incorporate it
- **"I'm not sure about..."** - Clarify that specific point, continue
- **"Go back to question X"** - Return to that question, adjust

## Error Handling

**If requirements are unclear:**
> That's not quite clear. Let me rephrase to make sure I understand:
> [Your interpretation]
>
> Is that right?

**If requirements seem contradictory:**
> I notice [X] might conflict with [Y]. Should we:
> - Option A: [Resolve one way]
> - Option B: [Resolve another way]
> - Let me think about this differently?

**If the need doesn't warrant a subagent:**
> Based on your description, I think this might work better as a [main conversation / skill / command] because [reason]. Would you like to explore that instead, or proceed with creating a subagent anyway?
