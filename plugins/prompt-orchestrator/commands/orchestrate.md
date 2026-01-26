---
name: orchestrate
description: Start the two-tier prompt orchestration workflow
arguments:
  - name: "task"
    description: "Initial task description or problem statement"
    required: false
allowed-tools:
  - Task
  - Read
  - Write
  - Grep
  - Glob
---

# Prompt Orchestration Workflow

You are starting the **Prompt Orchestrator** - a system that separates problem discovery from solution execution to optimize cost and quality.

## How This Works

This workflow runs in **three phases**, each optimized for a specific purpose:

```
PHASE 1: DISCOVERY (Haiku - cheap, iterative)
  ↓
PHASE 2: REFINEMENT (Haiku - context gathering, quality assessment)
  ↓
PHASE 3: EXECUTION (Sonnet/Opus - focused, efficient)
```

### The Insight Behind This

Users often request solution X when they actually need solution Y. The orchestrator discovers Y through careful Socratic questioning BEFORE implementation begins. This saves 60-80% on clarification costs because:

- **Haiku questioning** ($0.05-0.15) discovers root cause
- **Opus wouldn't be asked vague questions** - it gets crystal-clear prompts
- **Result**: 10x cheaper discovery + better execution quality

---

## Your Task

{{ if .task }}
**Initial Problem:** {{ .task }}

The problem-discovery-agent will now examine whether this describes a PROBLEM or a SOLUTION, and ask clarifying questions if needed.
{{ else }}
What problem are you trying to solve? (This can be vague - that's OK, we'll refine it together)
{{ end }}

---

## Process Overview

### Phase 1: Problem Discovery
The agent will:
- Detect if you're asking for solution X when you need Y
- Apply 5 Whys to uncover root causes
- Ask Socratic questions to clarify intent
- Surface hidden assumptions
- Confirm the real problem before proceeding

**Cost:** ~$0.05-0.15 (Haiku iteration is cheap)

### Phase 2: Refinement
The agent will:
- Gather project context (CLAUDE.md, codebase patterns, related issues)
- Break complex problems into actionable subtasks
- Identify constraints and acceptance criteria
- Score prompt quality (0-100 rubric)
- Iterate until quality ≥ 85/100 OR you confirm ready

**Cost:** ~$0.03-0.10 (More Haiku iteration)

### Phase 3: Handoff & Execution
The system will:
- Present optimized prompt for confirmation
- Recommend execution model (Haiku/Sonnet/Opus)
- Estimate execution cost
- Export session state for /clear (context survives)
- Execute with appropriate model
- Deliver complete solution

**Cost:** $0.08-0.50 (Model depends on complexity)

---

## Cost Comparison

**Without Orchestrator (Ask Opus directly):**
- Opus clarifies vague request: -$0.125
- User asks "Can you clarify?": -$0.100
- Back-and-forth 3-4 times: -$0.300+
- **Total clarification cost: $0.525+**

**With Orchestrator:**
- Haiku asks clarifying questions: -$0.050
- Haiku refines prompt to 85/100: -$0.030
- Sonnet executes clear prompt: -$0.180
- **Total cost: $0.260**
- **Savings: 50%+**

---

## What Happens Next

1. **Discovery Agent starts** - You'll have a natural conversation
2. **Be honest about what you don't know** - That's valuable data
3. **The agent asks "why" repeatedly** - This uncovers root causes
4. **Quality gate check** - Is the real problem clear now?
5. **Refinement begins** - Context is gathered and organized
6. **Handoff approval** - You see the optimized prompt before execution
7. **Execute** - Clear, efficient implementation with right model

---

## Tips for Best Results

- **Don't pre-filter your thoughts** - Tell the agent your initial confusion
- **Explain constraints you know** - Technical, timeline, budget, security
- **Share failed approaches** - "We tried X, didn't work because Y"
- **Be specific about users** - "Our on-call engineers" vs "users"
- **Link existing work** - Reference Jira issues, GitHub PRs, docs

Ready? Let's discover the real problem.
