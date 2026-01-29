---
name: architecture-patterns
description: Design patterns, structural guidance, and architecture best practices for Claude Code plugins
trigger-phrases:
  - "how to structure a plugin"
  - "plugin architecture patterns"
  - "where should commands go"
  - "when to use agents vs skills"
  - "plugin design best practices"
---

# Plugin Architecture Patterns

This skill provides structural and architectural guidance for designing well-organized, maintainable Claude Code plugins.

## Core Architecture Principles

### 1. Separation of Concerns

**Principle**: Each component type has a specific, non-overlapping purpose.

**Component Responsibilities**:

| Component | Purpose | When to Use |
|-----------|---------|------------|
| **Command** | User-facing workflow | Orchestrate multi-step processes, guide user through phases |
| **Agent** | Complex reasoning | Deep analysis, multiple decision points, specialized expertise |
| **Skill** | Reusable knowledge | Share common knowledge across commands/agents, explain concepts |
| **Hook** | Event automation | React to Claude Code events, background tasks, cleanup |

**Anti-Pattern**:
```
❌ Command that duplicates agent logic
❌ Agent that contains only skill knowledge
❌ Skill referenced by only one command
```

**Pattern**:
```
✅ Command orchestrates workflow, invokes agents for reasoning
✅ Agent has specialized expertise, clear purpose
✅ Skill is reused across multiple commands/agents
✅ Hook automates background tasks
```

### 2. Ownership & Clarity

**Principle**: Clear ownership of each component's behavior.

**Questions to Ask**:
- Does this command own its workflow, or delegate appropriately?
- Does this agent own its analysis process?
- Is this skill reusable or specific to one component?
- Can this hook gracefully fail without breaking main flow?

**Example**:
```
✅ plan-day command → Orchestrates workflow
   ├─ Owns: Phase sequence, user prompts
   ├─ Delegates to: prioritization-agent (complex decisions)
   └─ Uses: eisenhower-prioritization skill (knowledge)

✅ prioritization-agent → Specialized reasoning
   ├─ Owns: Analysis process, quality standards
   └─ Uses: eisenhower-prioritization skill (reference knowledge)

✅ eisenhower-prioritization skill → Reusable knowledge
   ├─ Owned by: Both command and agent
   └─ Describes: Framework, quadrant definitions, when to use
```

## Component Design Patterns

### Pattern 1: Command Workflow

**Structure**:
```
Command
├─ Introduction (set context)
├─ Phase 1 (collect input)
├─ Phase 2 (process/invoke agent)
├─ Phase 3 (confirm/adjust)
├─ Phase 4 (finalize/save)
└─ Next steps (what user can do)
```

**Example**:
```markdown
---
name: plan-day
description: Create a focused daily plan with prioritization and time-blocking
---

I'll help you create your daily plan.

## Phase 1: Collect Tasks
Tell me everything that needs to happen today.

[Invoke prioritization-agent to analyze tasks]

## Phase 2: Prioritize
Based on your tasks, here's what matters most...

[Invoke schedule-builder-agent to create schedule]

## Phase 3: Schedule
Here's your hour-by-hour plan...

Does this plan work for you? You can:
- Adjust any task durations
- Rearrange tasks
- Add buffer time
- Restart from scratch

## Phase 4: Save
Your plan is saved. You can reference it throughout the day.

Next: Use `/planner:show-schedule today` to view your plan
```

### Pattern 2: Agent Specialization

**Structure**:
```
Agent
├─ Specific role + domain
├─ Clear, non-overlapping responsibilities
├─ Step-by-step analysis process
├─ Quality standards (measurable)
├─ Output format (with example)
└─ Edge case handling
```

**Example - Weak**:
```markdown
You are a planning assistant.

Responsibilities:
- Help with planning
- Analyze tasks
- Provide suggestions
```

**Example - Strong**:
```markdown
You are a prioritization specialist using the Eisenhower matrix.

**Your Core Responsibilities:**
1. Classify tasks into Q1/Q2/Q3/Q4 based on urgency and importance
2. Analyze workload distribution to identify overload
3. Suggest daily focus areas respecting capacity constraints
4. Identify tasks that can be deferred or delegated

**Analysis Process:**
1. Parse all task descriptions and deadlines
2. For each task: extract urgency signals (due soon? blocking others?)
3. For each task: extract importance signals (strategic? core responsibility?)
4. Classify into quadrant based on both dimensions
5. Calculate time needed per quadrant
6. Alert if any quadrant is overloaded (Q1 >30%, Q3 >20%)
7. Suggest 3-5 key focus areas for the day

**Quality Standards:**
- Every task placed in exactly one quadrant
- Q1/Q2 placement justified (explain the urgency/importance)
- Time allocations realistic and totaling 100%
- Focus suggestions actionable and achievable
- Alert on overload situations

**Output Format:**
## Prioritization Analysis

**Q1 (Urgent & Important)**: [Time %]
- [Task 1]: [Time estimate]
- [Task 2]: [Time estimate]

**Q2 (Important)**: [Time %]
- [Task 1]: [Time estimate]

**Q3 (Urgent)**: [Time %]
- [Task 1]: [Time estimate]

**Q4 (Neither)**: [Time %]
- [Task 1]: Defer to [date]

**Daily Focus Areas:**
1. [Primary focus]
2. [Secondary focus]
3. [Tertiary focus]

[Alerts if present]
```

### Pattern 3: Skill Organization

**For Simple Skills** (<1000 words):
```
skill-name.md
├─ YAML frontmatter
├─ Core concept (100-150 words)
├─ When to use
├─ Key principles (bullet list)
├─ Common pattern (example)
└─ References to related docs
```

**For Complex Skills** (>1000 words):
```
skill-name/
├─ SKILL.md (core concept + navigation)
└─ references/
    ├─ detailed-guide.md
    ├─ advanced-patterns.md
    ├─ template.md
    └─ examples.md
```

**Example Structure**:
```markdown
---
name: eisenhower-prioritization
description: Framework for classifying tasks by urgency and importance
trigger-phrases:
  - "prioritize my tasks"
  - "what should I do first"
  - "organize my workload"
---

# Eisenhower Matrix

## Core Concept
The Eisenhower matrix classifies tasks into 4 quadrants:
- Q1: Urgent & Important (do immediately)
- Q2: Important (schedule time)
- Q3: Urgent (delegate if possible)
- Q4: Neither (eliminate)

Most productivity comes from Q2, not Q1.

## When to Use
- Overwhelmed by tasks
- Unsure what to prioritize
- Want to focus on important work
- Need to delegate

## Key Principles
- Urgent ≠ Important
- Many things seem urgent but aren't
- Important work is easy to defer
- Best productivity in Q2

## Common Pattern
[Decision tree for classifying tasks]

For more detail, see:
- references/quadrant-definitions.md
- references/classification-process.md
```

### Pattern 4: Hook Event Handling

**Structure**:
```json
{
  "event": "EventName",
  "matcher": {},
  "script": "scripts/handler.sh",
  "timeout": 5,
  "environment": {
    "PLUGIN_ROOT": "${CLAUDE_PLUGIN_ROOT}"
  }
}
```

**Script Pattern**:
```bash
#!/bin/bash

# Portable path using environment variable
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT}"
DATA_DIR="${PLUGIN_ROOT}/.planning"

# Graceful degradation
if [ ! -d "$DATA_DIR" ]; then
  echo "Data directory not initialized, skipping hook"
  exit 0
fi

# Actual logic
# ...

# Exit clearly
exit 0  # Success (hooks shouldn't fail)
```

## Architecture Decision Framework

### Decision 1: Command or Agent?

**Use Command When**:
- Multi-phase user workflow
- Sequential steps (user needs to understand flow)
- Confirmation/correction expected
- Orchestrating multiple capabilities

**Use Agent When**:
- Complex reasoning required
- Multiple decision points
- Specialized expertise needed
- Can operate independently

**Example**:
```
plan-day (Command)
└─ Orchestrates phases
   └─ Delegates prioritization-agent
      └─ Delegates schedule-builder-agent
```

### Decision 2: Skill or Agent?

**Use Skill When**:
- Reusable knowledge across components
- Reference material or framework
- "How to" guidance
- Less than 1 page of detailed explanation

**Use Agent When**:
- Active decision-making
- Complex analysis required
- Multiple process steps
- Reasoning with trade-offs

**Example**:
```
✅ eisenhower-prioritization (Skill) → Framework reference
✅ prioritization-agent (Agent) → Analyzes and classifies tasks
✅ Agent uses skill as reference
```

### Decision 3: File Organization

**Flat Structure** (simpler plugins, <10 components):
```
commands/
  - command-1.md
  - command-2.md
agents/
  - agent-1.md
skills/
  - skill-1.md
  - skill-2.md
```

**Nested Structure** (complex plugins, >10 components):
```
commands/
  - primary-command.md
agents/
  - domain-1-agent.md
  - domain-2-agent.md
skills/
  - skill-1/
      SKILL.md
      references/...
  - skill-2.md (simple skill)
hooks/
  - hooks.json
  - scripts/
```

## Common Patterns to Follow

### Pattern: Progressive Disclosure in Skills

**Problem**: Complex skill is overwhelming.

**Solution**: Core concept + references structure.

```
skill-name/
├─ SKILL.md (Main concept, 100-150 words)
└─ references/
    ├─ detailed-guide.md (Full explanation)
    ├─ advanced-patterns.md (For experts)
    └─ template.md (Copy-paste ready)
```

### Pattern: Phased Commands

**Problem**: Long, complex workflows confuse users.

**Solution**: Break into numbered phases with confirmation.

```
Command
├─ Phase 1: Collection (gather input)
├─ Confirm: "Does this look right?"
├─ Phase 2: Processing (invoke agent)
├─ Confirm: "Shall I continue?"
├─ Phase 3: Finalization (save/deliver)
└─ Next: Reference related commands
```

### Pattern: Agent Delegation

**Problem**: Mixing orchestration with reasoning.

**Solution**: Command orchestrates, agent reasons.

```
plan-day command
├─ Introduce workflow
├─ Invoke prioritization-agent
│  └─ Returns prioritized tasks
├─ Invoke schedule-builder-agent
│  └─ Returns scheduled plan
├─ Present results to user
└─ Offer adjustments or save
```

## Anti-Patterns to Avoid

❌ **Generic Agent** - "You are a helpful assistant"
✅ **Specific Agent** - "You are a prioritization specialist"

❌ **Unclear Responsibility** - Agent and command both doing analysis
✅ **Clear Responsibility** - Command orchestrates, agent analyzes

❌ **Skill Used Once** - Skill only referenced by one component
✅ **Reusable Skill** - Skill referenced by multiple components

❌ **Mixed Concerns** - Command contains full analysis logic
✅ **Separated Concerns** - Command delegates to agent

❌ **Vague Hook** - Hook that can fail silently
✅ **Graceful Hook** - Hook fails without blocking main flow

## Evaluation Checklist

**Command Design** ✓
- [ ] Clear phases (introduction, process, confirmation, completion)
- [ ] User understands what's happening at each phase
- [ ] Related agents/skills properly invoked
- [ ] Correction/adjustment options available
- [ ] Clear next steps after completion

**Agent Design** ✓
- [ ] Specific, non-generic role
- [ ] Clear, non-overlapping responsibilities (2-5)
- [ ] Step-by-step analysis process
- [ ] Measurable quality standards
- [ ] Example output format provided
- [ ] when-to-invoke is specific

**Skill Organization** ✓
- [ ] Reusable across 2+ components
- [ ] Clear trigger phrases
- [ ] Core concept explained simply
- [ ] Progressive disclosure if complex
- [ ] References or detailed docs included

**Overall Architecture** ✓
- [ ] No overlapping responsibilities
- [ ] Clear ownership of each component
- [ ] Appropriate level of delegation
- [ ] Consistent patterns throughout
- [ ] Easy to add new components

## References

For more detail, see:
- `references/command-examples.md` - Detailed command examples
- `references/agent-templates.md` - Agent system prompt templates
- `references/skill-organization.md` - Skill structure patterns
