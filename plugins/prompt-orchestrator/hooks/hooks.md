# Prompt Orchestrator Hooks

Hooks provide event-driven automation for the orchestration workflow. They manage session lifecycle, quality gates, and state persistence.

## v1 Hook Events

For v1, we focus on essential lifecycle hooks:

### SessionStart
**When:** Plugin workflow begins
**Purpose:** Initialize session state

```yaml
event: SessionStart
trigger: |
  Initialize refinement state:
  - Clear previous session data
  - Create fresh session.md
  - Load CLAUDE.md project context
  - Set iteration counter to 0
action: |
  Create state/session.md with:
  - Session start time
  - Initial problem statement
  - Iteration count: 0
  - Quality scores: []
  - Refinement rounds: []
```

### PostToolUse (Quality Gate Check)
**When:** prompt-assessor-agent completes assessment
**Purpose:** Enforce quality gates before handoff

```yaml
event: PostToolUse
trigger: |
  Agent: prompt-assessor-agent
  Tool: Read or output complete
condition: |
  IF assessment.score >= 85:
    ALLOW handoff phase
  ELSE IF assessment.score >= 70:
    SUGGEST refinement
    ASK: "Would you like to refine further?"
  ELSE:
    BLOCK execution
    SUGGEST: "Return to discovery phase"
    REASON: "Too many critical gaps"
action: |
  Update state/session.md:
  - Record quality score
  - Record critical gaps
  - Record iteration count
  - Suggest next action
```

### PreToolUse (Context Availability Check)
**When:** execution-router-agent starts model selection
**Purpose:** Ensure context was gathered

```yaml
event: PreToolUse
trigger: |
  Agent: execution-router-agent
condition: |
  IF context_gatherer output missing:
    PAUSE and ASK: "Should context-gatherer run first?"
  ELSE:
    PROCEED with routing
action: |
  Validate that context-gatherer.md exists
  Verify essential context gathered:
  - Tech stack
  - Related code references
  - Constraints
```

### Stop (Session End)
**When:** Workflow completes or user stops
**Purpose:** Export final state for /clear persistence

```yaml
event: Stop
trigger: |
  Workflow complete or user interruption
action: |
  1. Export ready-prompt.md with:
     - Optimized prompt
     - Quality score
     - Model recommendation
     - Cost estimate

  2. Update CLAUDE.md pointer:
     Add line: "Current orchestration ready at state/ready-prompt.md"

  3. Create summary in state/session.md:
     - Total iterations
     - Final quality score
     - Execution model selected
     - Cost estimate
```

---

## v1 Limitations (Future Enhancements)

These hooks would be powerful future additions:

### SubagentStop (Track agent completion)
```
Could track when each agent completes and aggregate output
```

### UserPromptSubmit (Validate input quality)
```
Could suggest problem discovery if user input is too vague
```

### SessionEnd (Archive session)
```
Could save session history for learning about what questions worked best
```

---

## Implementation Notes

For v1:
- Keep hooks minimal and focused
- Avoid blocking the user's workflow
- Provide clear guidance when gates activate
- Always allow override options

Example gate message:
```
⚠️ Quality Check

Your prompt scored 72/100 - good, but some gaps remain:

Critical gaps:
- No acceptance criteria defined
- Tech stack not fully specified

Would you like to:
1. Proceed anyway (Sonnet might need clarification)
2. Refine further (answer 2-3 more questions)
3. See detailed feedback (full assessment)

Your choice:
```

---

## State Files Involved

- `state/session.md` - Current session state
- `state/ready-prompt.md` - Final optimized prompt
- `state/discovery-log.md` - Problem discovery history
