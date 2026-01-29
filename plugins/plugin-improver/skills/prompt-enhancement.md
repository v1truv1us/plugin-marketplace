---
name: prompt-enhancement
description: Techniques for improving clarity, specificity, and effectiveness of plugin prompts
trigger-phrases:
  - "how to improve prompt quality"
  - "enhance system prompts"
  - "improve clarity in prompts"
  - "make prompts more specific"
  - "better trigger phrases"
---

# Prompt Enhancement Techniques

This skill provides concrete techniques for improving the clarity, specificity, and effectiveness of plugin prompts—system prompts for agents, descriptions for skills and commands, and trigger phrases.

## Core Principles

### 1. Specificity Over Generality

**Principle**: More specific prompts produce better results than generic ones.

**Problem Pattern**:
```
"You are an assistant that helps with planning"
```

**Solution Pattern**:
```
"You are a prioritization specialist using the Eisenhower matrix to classify tasks by urgency and importance"
```

**Why**: Specific role definition enables Claude to adopt the right mental model immediately.

### 2. Process Over Outcome

**Principle**: Define the HOW, not just the WHAT.

**Problem Pattern**:
```
"Analyze the plugin for quality"
```

**Solution Pattern**:
```
"Analyze the plugin by:
1. Reading plugin.json structure
2. Reviewing each command for clarity
3. Assessing agent system prompts for completeness
4. Checking skill trigger phrases for discoverability
5. Combining findings into quality scores"
```

**Why**: Explicit processes prevent hallucination and ensure consistent results.

### 3. Examples Over Explanation

**Principle**: Show, don't tell.

**Problem Pattern**:
```
"Provide your recommendations in a clear format"
```

**Solution Pattern**:
```
"Provide output as:

## Quality Assessment

**Overall Score**: 78/100

### Improvements Needed
1. **Trigger Phrases** (Current: "help", "optimize")
   - Better: "prioritize my tasks", "optimize my day"
   - Why: More specific triggers better identify the skill

[More examples...]"
```

**Why**: Examples make expectations concrete and actionable.

### 4. Measurable Standards

**Principle**: Define quality in terms that can be verified.

**Problem Pattern**:
```
"Quality standards: Be clear and helpful"
```

**Solution Pattern**:
```
"Quality standards:
- Trigger phrases are 3-6 words and action-oriented
- Agent descriptions are 1-2 sentences and specific
- System prompts define clear analysis processes
- Command workflows have 3-7 numbered phases
- Skill content is 100-150 words for core concept"
```

**Why**: Measurable standards enable consistent evaluation.

## Specific Improvement Techniques

### Technique 1: Make Trigger Phrases More Specific

**Pattern: Transform Generic → Specific**

```
Generic (Bad):
- "help"
- "improve"
- "optimize"

Specific (Good):
- "prioritize my tasks"
- "optimize my day"
- "organize my workload"

Why:
→ Users naturally phrase these specific requests
→ Claude can better identify when to trigger the skill
→ Reduces false positives (triggering at wrong times)
```

### Technique 2: Define Clear Role, Not Duties

**Pattern: Role + Domain**

```
Weak:
"You are an assistant for task prioritization"

Strong:
"You are a prioritization specialist using the Eisenhower matrix to classify tasks into urgent/important quadrants and analyze workload balance"

Why:
→ Specific role helps Claude adopt correct framework
→ Domain expertise is clear
→ Method (Eisenhower matrix) is explicit
```

### Technique 3: Break Complex Processes into Steps

**Pattern: Sequential Process Definition**

```
Weak:
"Analyze the code for quality issues"

Strong:
"Analyze code quality through these steps:
1. Read the file and understand its purpose
2. Check for error handling patterns
3. Assess context efficiency (token usage)
4. Evaluate code maintainability
5. Compare against Anthropic patterns
6. Generate scores for each dimension
7. Prioritize issues by severity"

Why:
→ Step-by-step prevents skipping important checks
→ Creates consistency across multiple evaluations
→ Easier to verify completeness
```

### Technique 4: Specify Output Structure

**Pattern: Example of Expected Output**

```
Weak:
"Provide recommendations for improvement"

Strong:
"Provide recommendations as:

**[Issue Category]**
1. **Issue**: [Description of the issue]
2. **Current**: [Show current code/text]
3. **Suggested**: [Show improved code/text]
4. **Why**: [Benefit of improvement]

Example:
**Trigger Phrases**
1. **Issue**: Trigger phrases are too generic
2. **Current**: "help", "improve"
3. **Suggested**: "prioritize my tasks", "optimize my day"
4. **Why**: More specific triggers improve discoverability and accuracy"

Why:
→ Concrete structure prevents rambling responses
→ Easier to parse and apply recommendations
→ Consistent format across all recommendations
```

### Technique 5: Add Edge Case Handling

**Pattern: Anticipate and Address Exceptions**

```
Weak:
"Evaluate the plugin quality"

Strong:
"Evaluate the plugin quality, and handle these cases:
- If plugin.json is missing: Note as critical issue
- If commands lack YAML frontmatter: Flag for standards
- If agent 'when-to-invoke' is unclear: Suggest specific conditions
- If skill description is too long: Recommend brevity
- If no README.md: Note as documentation gap"

Why:
→ Prevents agent from getting stuck or confused
→ Ensures consistent handling of unusual cases
→ More robust and reliable evaluation
```

## Common Improvements by Component

### Skill Descriptions

**Before**:
```yaml
name: my-skill
description: Helps with task management
trigger-phrases:
  - "tasks"
  - "help"
```

**After**:
```yaml
name: task-prioritization
description: Classify tasks into urgent/important quadrants using the Eisenhower matrix for strategic focus
trigger-phrases:
  - "prioritize my tasks"
  - "what should I do first"
  - "organize my workload"
  - "which tasks matter most"
```

**Improvements**:
- Description is specific and outcome-focused
- Trigger phrases are natural and action-oriented
- More discoverable when users need this skill

### Agent System Prompts

**Before**:
```markdown
You are a helpful planning agent. Analyze tasks and provide guidance.

Your responsibilities:
- Help with planning
- Analyze tasks
- Provide recommendations
```

**After**:
```markdown
You are a workload analyst specializing in task prioritization and time management.

**Your Core Responsibilities:**
1. Classify tasks into Eisenhower quadrants (Q1: Urgent/Important, Q2: Important, Q3: Urgent, Q4: Neither)
2. Analyze workload distribution across quadrants
3. Suggest daily focus areas based on capacity
4. Identify tasks that can be deferred or delegated

**Analysis Process:**
1. Read all task descriptions and deadlines
2. Extract urgency signals (deadlines approaching? blocking others?)
3. Extract importance signals (strategic? learning opportunity? core responsibility?)
4. Place each task in appropriate quadrant
5. Calculate time allocation across quadrants
6. Identify any overloaded quadrants
7. Suggest daily priorities

**Quality Standards:**
- Each task is placed in exactly one quadrant (no duplicates)
- Rationale is provided for Q1 and Q2 placement
- Time allocations total approximately 100% of available time
- Q1 tasks rarely exceed 30% (unsustainable)
- Q2 tasks are emphasized for long-term success
```

**Improvements**:
- Role is specific (workload analyst, not generic helper)
- Responsibilities are measurable and specific
- Process is step-by-step and repeatable
- Quality standards are concrete and verifiable

### Command Guidance

**Before**:
```markdown
This command helps you plan your day.

Usage: /planner:plan-day

Follow the steps to create your daily plan.
```

**After**:
```markdown
I'll help you create a focused daily plan by collecting your tasks, prioritizing them, and scheduling your time.

**How it works:**
1. **Collect Tasks** - Tell me what needs to happen today
2. **Prioritize** - We'll identify what matters most using the Eisenhower matrix
3. **Schedule** - I'll create an hour-by-hour plan respecting your energy levels
4. **Confirm** - Review the plan and adjust as needed
5. **Save** - Your plan is saved for today's reference

**Time needed**: 10-15 minutes

**You'll need**: List of tasks (can be rough notes)

Let's start by gathering today's tasks...
```

**Improvements**:
- Clear phased workflow with user understanding
- Time estimate set expectations
- Prerequisites are clear
- Friendly, conversational tone

## Evaluation Checklist

**Trigger Phrases** ✓
- [ ] 3-6 words each
- [ ] Natural language (how users would ask)
- [ ] Action-oriented
- [ ] Specific to the skill
- [ ] Not too broad or generic

**Skill Descriptions** ✓
- [ ] 1-2 sentences
- [ ] Outcome-focused (what problem solved)
- [ ] Clear what user gets
- [ ] Specific domain or framework mentioned

**Agent System Prompts** ✓
- [ ] Specific role (not generic "helper")
- [ ] Clear responsibilities (2-5, specific)
- [ ] Step-by-step process
- [ ] Measurable quality standards
- [ ] Example output format
- [ ] Edge case handling

**Command Guidance** ✓
- [ ] Purpose stated upfront
- [ ] Phases numbered and clear
- [ ] Time estimate provided
- [ ] Prerequisites listed
- [ ] Friendly, conversational tone
- [ ] Examples or context given

## References

For detailed examples, see:
- `references/prompt-patterns.md` - Full examples of strong prompts
- `references/before-after-examples.md` - Side-by-side improvements
