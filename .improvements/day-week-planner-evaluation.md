# Plugin Improvement Report: day-week-planner

**Evaluation Date:** 2026-01-29
**Plugin Version:** 1.0.0
**Evaluator:** plugin-improver-coordinator

---

## Executive Summary

**Overall Quality Score: 72/100**

**Status:** Important Improvements Needed

The day-week-planner plugin demonstrates solid architecture and comprehensive planning functionality, but suffers from **critical context management inefficiencies** that undermine its usability. The plugin loads unnecessarily verbose prompts that consume excessive tokens, lacks progressive disclosure patterns, and embeds redundant examples that could be externalized. While the core workflow design is strong, the implementation needs significant optimization to be production-ready.

**Key Strengths:**
- Well-structured multi-phase workflows
- Strong conceptual architecture (Eisenhower matrix + time-blocking)
- Comprehensive MCP integration design
- Excellent documentation in CLAUDE.md

**Critical Issues:**
- Massive context consumption (skills alone total ~350 lines of detailed content loaded per invocation)
- Missing progressive disclosure patterns (no references/ subdirectories)
- Redundant inline examples and formatting templates
- Verbose agent/skill descriptions that could be condensed by 40-60%

---

## Evaluation Results

### Best Practices Compliance: 68/100

**Strengths:**
- ✅ Proper YAML frontmatter in all components
- ✅ Clear naming conventions
- ✅ MCP server configuration follows standards
- ✅ Hook structure is well-designed

**Issues:**
- ❌ **Missing progressive disclosure** - No `references/` subdirectories in skills
- ❌ **Overly verbose frontmatter** - Agent capabilities should be in system prompt, not frontmatter
- ⚠️ Commands embed full workflow instructions (should be concise guidance)
- ⚠️ No separation between "quick reference" vs "detailed guide"

**Evidence:**

*eisenhower-prioritization/SKILL.md* is 99 lines including full output templates, decision criteria, and formatting examples. This entire prompt is loaded into context every time the skill is triggered.

*time-blocking/SKILL.md* is 127 lines including detailed energy tables, scheduling rules, output templates, and customization examples.

Anthropic best practice: Skills should be 30-50 lines of core guidance with references/ for detailed content.

---

### Code Quality: 70/100

**Strengths:**
- ✅ Clean separation of concerns (commands/agents/skills)
- ✅ Consistent data schema design
- ✅ Good error handling patterns described
- ✅ Security-conscious (credentials via env vars)

**Issues:**
- ❌ **No actual implementation** - All components are instructions FOR Claude, not executable code
- ⚠️ Hook scripts referenced but not evaluated (outside scope of this evaluation)
- ⚠️ Potential file I/O bottlenecks mentioned but not addressed
- ⚠️ No validation of JSON schema consistency

**Evidence:**

The plugin is entirely instruction-based. For example, `add-task.md` tells Claude to "Generate task object" and "Append to `.planning/tasks/backlog.json`" but provides no code to do so. This is acceptable for Claude Code plugins but increases cognitive load on the LLM.

---

### Prompt Quality: 78/100

**Strengths:**
- ✅ Clear phase-based workflow structure
- ✅ Good use of specific examples
- ✅ Consistent formatting and structure
- ✅ Well-defined trigger phrases for skills

**Issues:**
- ❌ **Excessive verbosity** - Skills include full markdown templates that should be extracted
- ⚠️ Agent descriptions duplicate skill content (prioritization concepts repeated across agent + skill)
- ⚠️ Output format examples are too detailed (90+ line templates inline)
- ⚠️ Missing concise "TL;DR" summaries at top of long prompts

**Evidence:**

*eisenhower-prioritization/SKILL.md* includes this 45-line output template starting at line 44:

```markdown
## Output Format

```markdown
## Your Prioritized Tasks

### 🔴 Q1: Do First (Urgent + Important)
**Action:** Execute these immediately - typically today

1. **[Task Title]** - Due: [date], Est: [X]min
   - Why urgent: [specific deadline/blocker]
   - Why important: [strategic/business impact]
   - Recommendation: Start first thing (morning)

### 🟡 Q2: Schedule (Important, Not Urgent)
...
```

This template should be in `references/output-template.md` and Claude can reference it when needed.

---

## Critical Issues

### 1. Massive Context Consumption in Skills

**Impact:** Skills load 300+ lines of detailed content on every invocation, consuming ~2000+ tokens unnecessarily.

**Problem:**

Current structure:
```
skills/eisenhower-prioritization/SKILL.md (99 lines)
  - Criteria tables (lines 18-33)
  - Process steps (lines 35-42)
  - Full output template (lines 44-90)
  - Tips section (lines 92-99)
```

All of this loads into context when skill is triggered.

**Solution - Progressive Disclosure:**

```
skills/eisenhower-prioritization/
├── SKILL.md (30 lines - CORE ONLY)
└── references/
    ├── classification-criteria.md
    ├── output-template.md
    └── advanced-tips.md
```

**BEFORE (eisenhower-prioritization/SKILL.md):**
```markdown
---
name: eisenhower-prioritization
description: Apply Eisenhower matrix to prioritize tasks. Use when users mention prioritizing, sorting tasks by importance, deciding what to do first, or mention urgent vs important.
allowed-tools: Read, Write, Bash
---

# Eisenhower Matrix Prioritization

## The Four Quadrants

| Quadrant | Urgent | Important | Action |
|----------|--------|-----------|--------|
| **Q1: Do First** | ✓ | ✓ | Execute immediately today |
| **Q2: Schedule** | ✗ | ✓ | Block dedicated deep work time |
| **Q3: Minimize** | ✓ | ✗ | Delegate, batch, or minimize |
| **Q4: Eliminate** | ✗ | ✗ | Remove from list or archive |

## Classification Criteria

### Urgent Indicators
- Due within 24-48 hours
- External deadline is approaching
- Blocking other people's work
- Time-sensitive opportunity or consequence
- Customer or stakeholder impact imminent

### Important Indicators
- Aligns directly with major career/business goals
- High impact on outcomes (avoid catastrophic failure)
- Contributes to long-term strategy
- Cannot be delegated without significant loss
- Core competency or expertise required

## Prioritization Process

1. **Load Tasks** from `.planning/tasks/backlog.json`
2. **Assess Urgency** for each task (due date, dependencies, blockers)
3. **Assess Importance** (goal alignment, impact magnitude, replaceability)
4. **Assign Quadrant** (Q1-Q4) based on both dimensions
5. **Sort Within Quadrants** by estimated effort (quick wins first in Q1)
6. **Present Prioritized List** with clear reasoning for each grouping

## Output Format

```markdown
## Your Prioritized Tasks

### 🔴 Q1: Do First (Urgent + Important)
**Action:** Execute these immediately - typically today

1. **[Task Title]** - Due: [date], Est: [X]min
   - Why urgent: [specific deadline/blocker]
   - Why important: [strategic/business impact]
   - Recommendation: Start first thing (morning)

### 🟡 Q2: Schedule (Important, Not Urgent)
**Action:** Block dedicated time to work on these

1. **[Task Title]** - Recommended block: [time suggestion]
   - Why important: [strategic value]
   - Estimated time: [X hours]
   - Recommendation: Deep work block this week

### 🟠 Q3: Minimize (Urgent, Not Important)
**Action:** Delegate, automate, batch, or minimize

1. **[Task Title]** - Consider: [specific suggestion]
   - Why urgent: [immediate deadline]
   - Why less important: [low impact]
   - Recommendation: Delegate or batch with similar tasks

### ⚪ Q4: Consider Dropping
**Action:** Remove, defer indefinitely, or archive

1. **[Task Title]** - Rationale: [reason to drop]
   - Status: [not aligning with goals / low urgency / can be replaced]
   - Recommendation: Remove from backlog or archive

## Summary
- Q1 estimated time: X hours
- Q2 estimated time: Y hours
- Capacity remaining: Z hours
- Risk: [any concerns about workload/deadlines]

## Next Steps
Would you like to:
1. Adjust any priorities (explain which and why)
2. Create a daily schedule using these priorities
3. Add new tasks that came to mind
```

## Tips for Accurate Prioritization

- **Resist false urgency**: Just because something has a deadline doesn't mean it's important
- **Challenge importance claims**: Would missing this significantly impact your goals?
- **Consider dependencies**: A Q3 task might become Q1 if others depend on it
- **Review regularly**: Priorities shift as new information arrives
- **Be honest about capacity**: Can you realistically do all Q1 tasks today?
```

**AFTER (eisenhower-prioritization/SKILL.md):**
```markdown
---
name: eisenhower-prioritization
description: Apply Eisenhower matrix to prioritize tasks. Use when users mention prioritizing, sorting tasks by importance, deciding what to do first, or mention urgent vs important.
allowed-tools: Read, Write, Bash
---

# Eisenhower Matrix Prioritization

Apply the Eisenhower matrix to classify tasks by urgency and importance.

## Core Process

1. **Load tasks** from `.planning/tasks/backlog.json`
2. **Classify each task** into one of four quadrants:
   - **Q1 (Do First)**: Urgent + Important → Execute today
   - **Q2 (Schedule)**: Important, Not Urgent → Block deep work time
   - **Q3 (Minimize)**: Urgent, Not Important → Delegate/batch
   - **Q4 (Eliminate)**: Neither → Remove or archive
3. **Sort within quadrants** by estimated effort (quick wins first)
4. **Present prioritized list** with reasoning for each classification

## Classification Criteria

**Urgent** = Due within 24-48h, blocking others, time-sensitive impact, external deadline
**Important** = Aligns with major goals, high impact, strategic value, cannot be delegated

## Output Structure

Present tasks grouped by quadrant with:
- Task title, due date, estimated time
- Why urgent (if applicable)
- Why important (if applicable)
- Recommended action

Include summary: total time per quadrant, capacity analysis, workload risks.

**For detailed output template:** See `references/output-template.md`
**For classification nuances:** See `references/classification-criteria.md`
**For advanced tips:** See `references/advanced-tips.md`
```

**NEW FILE (eisenhower-prioritization/references/output-template.md):**
```markdown
# Eisenhower Matrix Output Template

Use this template when presenting prioritized tasks:

## Your Prioritized Tasks

### 🔴 Q1: Do First (Urgent + Important)
**Action:** Execute these immediately - typically today

1. **[Task Title]** - Due: [date], Est: [X]min
   - Why urgent: [specific deadline/blocker]
   - Why important: [strategic/business impact]
   - Recommendation: Start first thing (morning)

[Continue for each quadrant...]

## Summary
- Q1 estimated time: X hours
- Q2 estimated time: Y hours
- Capacity remaining: Z hours
- Risk: [any concerns about workload/deadlines]

## Next Steps
Would you like to:
1. Adjust any priorities (explain which and why)
2. Create a daily schedule using these priorities
3. Add new tasks that came to mind
```

**Why this improves quality:**
- Reduces initial context load from ~2000 tokens to ~400 tokens (80% reduction)
- Claude can still access detailed templates when needed via Read tool
- Faster skill invocation and response times
- Clearer separation between "core knowledge" and "reference material"

---

### 2. Redundant Content Across Agent and Skill

**Impact:** Prioritization concepts are duplicated in both `prioritization-agent.md` and `eisenhower-prioritization/SKILL.md`

**Problem:**

Both files describe Eisenhower matrix principles, prioritization criteria, and approach. When agent is invoked, both contexts load redundantly.

**Current Structure:**
```
agents/prioritization-agent.md (41 lines)
  - Eisenhower matrix application (line 12)
  - Time estimation (line 15)
  - Energy level matching (line 17)
  - When to invoke: 5+ tasks (line 29)

skills/eisenhower-prioritization/SKILL.md (99 lines)
  - Eisenhower matrix definition (lines 9-16)
  - Classification criteria (lines 18-33)
  - Prioritization process (lines 35-42)
```

**BEFORE (agents/prioritization-agent.md):**
```markdown
---
name: prioritization-agent
description: Expert in task prioritization using Eisenhower matrix, workload balancing, and realistic time estimation
capabilities: ["priority-assessment", "workload-analysis", "time-estimation"]
---

# Prioritization Agent

Specialized agent for intelligent task prioritization and workload optimization.

## Expertise
- Eisenhower matrix application with nuanced decision-making
- Recognizing hidden urgency and importance signals
- Balancing short-term deliverables with long-term goals
- Realistic time estimation accounting for complexity and dependencies
- Context-switching cost analysis
- Energy level matching (cognitive load vs. time of day)

## Approach
1. Analyze each task holistically (not just deadline)
2. Consider interdependencies between tasks
3. Account for energy fluctuations throughout the day/week
4. Factor in context-switching cognitive overhead
5. Challenge assumptions about urgency vs. actual impact
6. Identify quick wins and momentum builders

## Invocation
Automatically used when:
- User has more than 5 tasks to prioritize simultaneously
- Complex priority conflicts exist (multiple Q1 tasks)
- Conflicting deadlines across projects
- Workload seems overwhelming (requires load balancing)

## Output
Provides:
- Prioritized task list with clear reasoning
- Suggested focus order for the day/week
- Time budget allocation
- Recommendations for delegation or deferral
- Risk analysis if current workload is unsustainable
```

**AFTER (agents/prioritization-agent.md):**
```markdown
---
name: prioritization-agent
description: Expert in complex task prioritization with workload balancing and realistic time estimation
---

# Prioritization Agent

You are a specialized agent for complex prioritization decisions involving 5+ tasks or conflicting priorities.

## Your Expertise

You excel at:
- **Nuanced Eisenhower classification** - Detecting hidden urgency/importance signals
- **Workload balancing** - Distributing cognitive load across time periods
- **Realistic time estimation** - Accounting for complexity, dependencies, context-switching
- **Strategic thinking** - Balancing short-term deliverables with long-term goals
- **Risk analysis** - Identifying unsustainable workload patterns

## Your Approach

1. Apply the **eisenhower-prioritization** skill to classify tasks
2. Analyze task interdependencies (which tasks block others?)
3. Match cognitive load to energy levels (complex work in high-energy periods)
4. Calculate context-switching costs (minimize task transitions)
5. Challenge false urgency claims (deadline ≠ importance)
6. Identify quick wins and momentum builders
7. Assess capacity realistically (can user do all Q1 tasks today?)

## When to Invoke

Use this agent when:
- 5+ tasks need prioritization simultaneously
- Multiple Q1 (urgent + important) tasks conflict
- Workload appears overwhelming or unsustainable
- Complex deadline conflicts across projects

## Output Format

Provide:
1. Prioritized task list with clear reasoning for each classification
2. Suggested execution order optimized for energy/focus
3. Time budget allocation per quadrant
4. Delegation/deferral recommendations with rationale
5. Risk analysis if workload is unsustainable

**Reference the eisenhower-prioritization skill for core classification - don't duplicate it here.**
```

**Why this improves quality:**
- Eliminates redundancy between agent and skill
- Agent now orchestrates skill rather than duplicating it
- Clearer separation: skill = technique, agent = complex reasoning
- Reduced context when agent invoked

---

### 3. Overly Detailed Command Instructions

**Impact:** Commands like `plan-day.md` are formatted as detailed phase-by-phase specifications when they should be concise workflow guidance.

**Problem:**

Commands are written as if Claude needs step-by-step instructions for every detail. This increases context consumption and makes commands harder to scan.

**BEFORE (commands/plan-day.md):**
```markdown
---
name: plan-day
description: Start an interactive daily planning session with prioritization and scheduling
---

# Daily Planning Command

Begin a comprehensive daily planning workflow:

## Phase 1: Context Gathering
1. Read existing plan from `.planning/current-day.md` (if exists)
2. Load recurring blocks from `.planning/config.json`
3. Check for synced tasks from Jira/GitHub
4. Ask: "What are your top priorities for today?"

## Phase 2: Task Collection
For tasks the user mentions:
- Capture task description
- Ask for estimated duration (suggest based on similar tasks)
- Identify any hard deadlines
- Categorize (work, personal, admin)

## Phase 3: Prioritization
Apply the **eisenhower-prioritization** skill:
- Present tasks grouped by quadrant
- Ask: "Does this priority order look right?"
- Allow adjustments

## Phase 4: Schedule Building
Apply the **time-blocking** skill:
- Generate hour-by-hour schedule
- Respect recurring blocks
- Include breaks and buffers
- Present for review

## Phase 5: Confirmation
"Here's your plan for today:

[Schedule]

Would you like to:
1. ✅ Approve and save
2. ✏️ Make adjustments
3. 🔄 Start over"

## Phase 6: Save
On approval:
- Write to `.planning/current-day.md`
- Update task statuses in `backlog.json`
- Confirm: "Plan saved! You can view it anytime with `/planner:show-schedule`"
```

**AFTER (commands/plan-day.md):**
```markdown
---
name: plan-day
description: Start an interactive daily planning session with prioritization and scheduling
---

# Daily Planning Workflow

Guide the user through a 6-phase planning session:

1. **Context** - Load existing plan, recurring blocks, and synced tasks. Ask: "What are your top priorities for today?"

2. **Task Collection** - For each task mentioned, capture: description, duration estimate, deadline, category (work/personal/admin)

3. **Prioritization** - Apply **eisenhower-prioritization** skill. Present grouped by quadrant. Confirm or allow adjustments.

4. **Schedule Building** - Apply **time-blocking** skill. Generate hour-by-hour schedule respecting recurring blocks. Present for review.

5. **Confirmation** - Present final schedule with options: (1) Approve and save, (2) Make adjustments, (3) Start over

6. **Save** - Write to `.planning/current-day.md`, update task statuses in `backlog.json`, confirm completion

**Key files:**
- Input: `.planning/config.json`, `.planning/tasks/backlog.json`
- Output: `.planning/current-day.md`

**Error handling:** If no tasks provided, suggest syncing external systems or adding tasks first.
```

**Why this improves quality:**
- Reduces command length from 51 lines to 26 lines (49% reduction)
- Easier to scan and understand at a glance
- Maintains all critical information
- Removes conversational fluff ("Begin a comprehensive daily planning workflow")

---

## Important Improvements

### 4. Missing Progressive Disclosure in time-blocking Skill

**Current:** 127-line skill with detailed energy tables, scheduling rules, output templates, and customization examples all inline.

**Recommended Structure:**
```
skills/time-blocking/
├── SKILL.md (40 lines)
└── references/
    ├── energy-mapping.md (energy level tables)
    ├── scheduling-rules.md (detailed principles)
    ├── output-template.md (markdown schedule format)
    └── customization-guide.md (config.json examples)
```

**BEFORE (time-blocking/SKILL.md - excerpt):**
```markdown
## Default Workday Structure (8 hours)

| Time Block | Duration | Type | Energy | Best For |
|------------|----------|------|--------|----------|
| 09:00-10:30 | 90 min | Deep Work Block 1 | 🔋🔋🔋 | Complex/creative tasks |
| 10:30-10:45 | 15 min | Break | ☕ | Reset focus |
| 10:45-12:00 | 75 min | Deep Work Block 2 | 🔋🔋🔋 | Continuation/detail work |
| 12:00-13:00 | 60 min | Lunch | 🍽️ | Recharge |
| 13:00-14:30 | 90 min | Deep Work Block 3 | 🔋🔋 | Q2 tasks, focused work |
| 14:30-14:45 | 15 min | Break | ☕ | Context recovery |
| 14:45-16:00 | 75 min | Collaborative/Admin | 🔋 | Meetings, reviews, collab |
| 16:00-17:00 | 60 min | Admin/Email/Planning | 🔋 | Follow-ups, tomorrow prep |

## Energy Mapping by Time of Day

| Time Window | Energy | Cognitive Load | Best Activities |
|-------------|--------|-----------------|-----------------|
| 9am-12pm | 🔋🔋🔋 Very High | Complex thinking | Q1 tasks, creative work, problem-solving |
| 12pm-2pm | 🔋 Low | Post-lunch dip | Routine, meetings, admin, easy tasks |
| 2pm-4pm | 🔋🔋 Medium | Recovering | Q2 tasks, collab work, reviews |
| 4pm-5pm | 🔋 Low | End-of-day fatigue | Planning, email, low-priority admin |
```

**AFTER (time-blocking/SKILL.md):**
```markdown
---
name: time-blocking
description: Create hour-by-hour schedules with focus blocks and breaks. Use when users want to plan their day, create a schedule, block time, or ask what they should work on.
allowed-tools: Read, Write, Bash
---

# Time-Blocking Skill

Create optimized daily schedules that match task priorities to energy levels.

## Core Principles

1. **Load recurring blocks FIRST** - immovable commitments (meetings, gym, family)
2. **Match tasks to energy levels** - Q1 tasks in morning peak (9am-12pm), routine work in low-energy periods
3. **Protect deep work blocks** - minimum 90min uninterrupted focus time
4. **Include breaks** - 15min between high-focus tasks for context recovery
5. **Add buffers** - 10-15min between task switches
6. **Limit context switches** - max 4-5 per day

## Schedule Generation Process

1. Load config from `.planning/config.json` (workday hours, recurring blocks)
2. Import prioritized tasks (from eisenhower-prioritization skill)
3. Calculate available time slots after removing recurring blocks
4. Assign tasks to slots: Q1 → morning peak, Q2 → afternoon focus, admin → end-of-day
5. Insert breaks between high-focus tasks
6. Add buffer time for transitions
7. Present schedule for confirmation
8. Save to `.planning/current-day.md`

## Output Structure

Present hour-by-hour schedule as markdown table with columns: Time | Task | Priority | Duration | Status | Energy

Include summary: deep work hours, meetings/collab time, admin time, breaks, buffer.

**For energy mapping reference:** See `references/energy-mapping.md`
**For detailed scheduling rules:** See `references/scheduling-rules.md`
**For output template:** See `references/output-template.md`
**For customization options:** See `references/customization-guide.md`
```

**Estimated token savings:** ~1500 tokens per skill invocation (70% reduction)

---

### 5. Agent Frontmatter Contains Implementation Details

**Current:** Agents include `capabilities` arrays in frontmatter that should be in system prompt.

**BEFORE (schedule-builder-agent.md):**
```yaml
---
name: schedule-builder-agent
description: Expert in time-blocking, schedule optimization, and daily rhythm design
capabilities: ["schedule-optimization", "time-blocking", "energy-mapping", "break-scheduling"]
---
```

**AFTER:**
```yaml
---
name: schedule-builder-agent
description: Expert in time-blocking, schedule optimization, and daily rhythm design
---
```

**Rationale:** Capabilities should be described in the agent's system prompt, not in metadata. Frontmatter should only contain fields used by Claude Code's plugin system.

---

### 6. Verbose Output Templates in Skills

**Current:** Skills include 40-90 line output templates inline.

**Recommended:** Move all output templates to `references/output-template.md` and reference them.

**Pattern to apply:**

```markdown
## Output Structure

Present results as [brief description of structure].

**For detailed template:** See `references/output-template.md`
```

This applies to:
- `eisenhower-prioritization/SKILL.md` (lines 44-90)
- `time-blocking/SKILL.md` (lines 62-103)
- `external-sync/SKILL.md` (lines 80-106)

**Estimated total token savings:** ~3000 tokens across all three skills

---

### 7. Commands Include Exact Conversational Scripts

**Current:** Commands include exact phrases Claude should say (e.g., "Here's your plan for today:").

**Recommended:** Commands should guide workflow, not script exact dialogue.

**BEFORE (plan-day.md):**
```markdown
## Phase 5: Confirmation
"Here's your plan for today:

[Schedule]

Would you like to:
1. ✅ Approve and save
2. ✏️ Make adjustments
3. 🔄 Start over"
```

**AFTER:**
```markdown
5. **Confirmation** - Present final schedule. Offer options: approve, adjust, or restart.
```

**Rationale:** Claude is conversational by default. Scripting exact phrases adds verbosity without improving quality.

---

### 8. Missing Skill Description Optimization

**Current:** Skill descriptions in frontmatter are verbose and redundant with skill content.

**BEFORE:**
```yaml
description: Create hour-by-hour schedules with focus blocks and breaks. Use when users want to plan their day, create a schedule, block time, or ask what they should work on.
```

**AFTER:**
```yaml
description: Create hour-by-hour schedules with focus blocks and breaks. Use when users mention planning, scheduling, time-blocking, or energy optimization.
```

**Rationale:** Skill descriptions should focus on trigger phrases, not restate functionality already in skill content.

---

### 9. Hook Prompt Could Be More Concise

**Current (hooks.json - Stop event):**
```json
{
  "type": "prompt",
  "prompt": "Before stopping, verify: 1) Is the planning session complete? 2) Has the plan been saved to .planning/? 3) Does the user need any reminders? Respond with {\"decision\": \"approve\"} if complete or {\"decision\": \"block\", \"reason\": \"explanation\"} if work remains.",
  "timeout": 30,
  "description": "Verify planning workflow completion"
}
```

**AFTER:**
```json
{
  "type": "prompt",
  "prompt": "Verify completion: (1) Planning session complete? (2) Plan saved to .planning/? (3) User needs reminders? Return {\"decision\": \"approve\"} if yes, or {\"decision\": \"block\", \"reason\": \"...\"} if no.",
  "timeout": 30,
  "description": "Verify planning workflow completion"
}
```

**Token savings:** ~30 tokens per session end

---

### 10. External-Sync Skill Has Redundant Sections

**Current:** `external-sync/SKILL.md` includes detailed error handling, customization, and best practices sections that could be in references.

**Lines 114-164** (50 lines) cover:
- Error handling scenarios (lines 114-135)
- Customization options (lines 137-156)
- Best practices (lines 158-164)

**Recommended:** Extract to references:
```
skills/external-sync/
├── SKILL.md (50 lines - core workflow only)
└── references/
    ├── error-handling.md
    ├── customization-guide.md
    └── best-practices.md
```

**Token savings:** ~800 tokens per external sync invocation

---

## Optional Enhancements

### 11. Consider Lazy-Loading Configuration

**Enhancement:** Instead of instructing Claude to "Load config from `.planning/config.json`" every time, consider a SessionStart hook that injects config into context once.

**Benefit:** Reduces repetitive file reads during planning workflow.

---

### 12. Add Skill Usage Metrics to CLAUDE.md

**Enhancement:** Track which skills are most frequently invoked and optimize those first.

**Benefit:** Data-driven optimization priorities.

---

### 13. Create Unified Style Guide for Commands

**Enhancement:** All commands currently have slightly different formatting. Standardize to:
```markdown
# [Command Name] Workflow

[1-sentence description]

## Phases

1. **Phase Name** - Brief description of what happens
2. **Phase Name** - Brief description of what happens
...

## Key Files
- Input: [files]
- Output: [files]

## Error Handling
[Brief notes]
```

**Benefit:** Consistent command structure improves maintainability.

---

### 14. Consider Adding Skill Complexity Indicators

**Enhancement:** Add frontmatter field: `complexity: low|medium|high` to help Claude decide when to invoke agents vs. handle directly.

**Example:**
```yaml
---
name: eisenhower-prioritization
description: Apply Eisenhower matrix to prioritize tasks
complexity: medium
suggested-agent: prioritization-agent
suggested-agent-threshold: 5+ tasks
---
```

**Benefit:** Clearer guidance on agent invocation.

---

### 15. Add Quick Reference Cards

**Enhancement:** Create one-page "cheat sheets" for each major workflow:
```
skills/eisenhower-prioritization/references/quick-reference.md
skills/time-blocking/references/quick-reference.md
```

**Benefit:** Claude can quickly reference core concepts without loading full skill.

---

## Implementation Roadmap

### Phase 1: Critical Context Optimization (Priority 1)

**Estimated Impact:** 60-70% token reduction in skill invocations

1. **Create progressive disclosure structure for all skills**
   - Add `references/` directories to all three skills
   - Extract output templates to `references/output-template.md`
   - Extract detailed criteria/rules to separate files
   - Update SKILL.md files to reference external content

   **Files to modify:**
   - `/home/vitruvius/git/plugin-marketplace/plugins/planner/skills/eisenhower-prioritization/SKILL.md`
   - `/home/vitruvius/git/plugin-marketplace/plugins/planner/skills/time-blocking/SKILL.md`
   - `/home/vitruvius/git/plugin-marketplace/plugins/planner/skills/external-sync/SKILL.md`

   **Files to create:**
   - `skills/eisenhower-prioritization/references/output-template.md`
   - `skills/eisenhower-prioritization/references/classification-criteria.md`
   - `skills/eisenhower-prioritization/references/advanced-tips.md`
   - `skills/time-blocking/references/energy-mapping.md`
   - `skills/time-blocking/references/scheduling-rules.md`
   - `skills/time-blocking/references/output-template.md`
   - `skills/time-blocking/references/customization-guide.md`
   - `skills/external-sync/references/error-handling.md`
   - `skills/external-sync/references/customization-guide.md`
   - `skills/external-sync/references/best-practices.md`

2. **Eliminate agent/skill redundancy**
   - Update `agents/prioritization-agent.md` to reference skill rather than duplicate
   - Update `agents/schedule-builder-agent.md` to reference skill rather than duplicate

   **Files to modify:**
   - `/home/vitruvius/git/plugin-marketplace/plugins/planner/agents/prioritization-agent.md`
   - `/home/vitruvius/git/plugin-marketplace/plugins/planner/agents/schedule-builder-agent.md`

3. **Test skill invocations**
   - Verify skills still work with references
   - Confirm Claude can access reference files when needed
   - Measure token reduction

**Testing approach:**
```bash
# Test eisenhower-prioritization skill
/planner:plan-day
# Observe: Does skill still classify correctly? Does Claude reference files when needed?

# Test time-blocking skill
/planner:plan-day
# Observe: Does schedule generation work? Are energy levels matched correctly?
```

---

### Phase 2: Command Optimization (Priority 2)

**Estimated Impact:** 30-40% reduction in command context consumption

1. **Condense all command files**
   - Remove conversational scripts
   - Convert detailed phase descriptions to concise bullets
   - Remove redundant "Begin a comprehensive..." introductions

   **Files to modify:**
   - `/home/vitruvius/git/plugin-marketplace/plugins/planner/commands/plan-day.md`
   - `/home/vitruvius/git/plugin-marketplace/plugins/planner/commands/plan-week.md`
   - `/home/vitruvius/git/plugin-marketplace/plugins/planner/commands/add-task.md`
   - `/home/vitruvius/git/plugin-marketplace/plugins/planner/commands/show-schedule.md`

2. **Standardize command format**
   - Apply unified structure across all commands
   - Add consistent "Key Files" and "Error Handling" sections

3. **Test command workflows**
   - Run each command end-to-end
   - Verify user experience is unchanged

---

### Phase 3: Polish and Refinement (Priority 3)

**Estimated Impact:** 10-15% additional optimization

1. **Clean up frontmatter**
   - Remove `capabilities` arrays from agents
   - Optimize skill descriptions to focus on trigger phrases

   **Files to modify:**
   - `/home/vitruvius/git/plugin-marketplace/plugins/planner/agents/prioritization-agent.md`
   - `/home/vitruvius/git/plugin-marketplace/plugins/planner/agents/schedule-builder-agent.md`
   - `/home/vitruvius/git/plugin-marketplace/plugins/planner/agents/integration-agent.md`

2. **Optimize hook prompts**
   - Condense Stop event prompt in hooks.json

   **Files to modify:**
   - `/home/vitruvius/git/plugin-marketplace/plugins/planner/hooks/hooks.json`

3. **Add optional enhancements**
   - Consider quick reference cards
   - Consider complexity indicators
   - Consider unified style guide

---

### Phase 4: Validation and Documentation (Priority 4)

1. **Update CLAUDE.md**
   - Document progressive disclosure pattern
   - Add guidelines for maintaining lean prompts
   - Update architecture diagram to show references/ pattern

   **Files to modify:**
   - `/home/vitruvius/git/plugin-marketplace/plugins/planner/CLAUDE.md`

2. **Update README.md**
   - No changes needed (user-facing docs unaffected by context optimization)

3. **Final testing**
   - Full workflow test: plan-day, plan-week, add-task, show-schedule, sync-external
   - Measure token consumption before/after
   - Validate quality of outputs unchanged

---

## Measurement Criteria

### Before Optimization
- **eisenhower-prioritization skill**: ~2000 tokens
- **time-blocking skill**: ~2500 tokens
- **external-sync skill**: ~2000 tokens
- **plan-day command**: ~800 tokens
- **Total typical workflow**: ~7300 tokens

### After Optimization (Target)
- **eisenhower-prioritization skill**: ~400 tokens (80% reduction)
- **time-blocking skill**: ~600 tokens (76% reduction)
- **external-sync skill**: ~700 tokens (65% reduction)
- **plan-day command**: ~400 tokens (50% reduction)
- **Total typical workflow**: ~2100 tokens (71% reduction)

### Success Metrics
- ✅ Overall token reduction: 65-75%
- ✅ Skill invocation speed: 2-3x faster
- ✅ User experience: unchanged or improved
- ✅ Output quality: unchanged
- ✅ All workflows pass end-to-end tests

---

## Conclusion

The day-week-planner plugin has a strong conceptual foundation and well-designed workflows, but suffers from critical context management inefficiencies that prevent it from being production-ready. By implementing progressive disclosure patterns, eliminating redundancy, and condensing verbose instructions, the plugin can achieve a 65-75% reduction in context consumption while maintaining or improving user experience.

**Recommended Action:** Prioritize Phase 1 (Critical Context Optimization) immediately. This will yield the highest impact with minimal risk to functionality.

**Estimated Implementation Time:**
- Phase 1: 4-6 hours
- Phase 2: 2-3 hours
- Phase 3: 1-2 hours
- Phase 4: 1-2 hours
- **Total: 8-13 hours**

**Expected Outcome:** A production-ready plugin that is 65-75% more token-efficient, invokes 2-3x faster, and maintains all existing functionality.

---

**Evaluation Completed:** 2026-01-29
**Next Review:** After Phase 1 implementation
