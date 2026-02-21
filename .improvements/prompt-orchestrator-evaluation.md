# Plugin Improvement Report: prompt-orchestrator

## Executive Summary

**Overall Quality Score: 72/100**

**Status: Important Improvements Needed**

The prompt-orchestrator plugin demonstrates a sophisticated approach to prompt optimization with a well-designed three-phase workflow (Discovery, Refinement, Execution). However, significant context management issues severely impact its effectiveness. The plugin suffers from excessive verbosity, poor progressive disclosure, and inefficient token usage - the very problems it aims to solve for users.

**Key Finding:** The plugin's agents contain 15,000+ tokens of system prompts that would be loaded into every agent conversation, creating massive context overhead that contradicts the plugin's cost-optimization mission.

---

## Evaluation Results

### Best Practices Compliance: 68/100

**Strengths:**
- Proper plugin.json manifest structure
- YAML frontmatter correctly used in agents and commands
- Good use of color coding for agents
- Proper hook configuration with hooks.json
- Clear whenToUse descriptions for agents

**Critical Issues:**
- Agent system prompts violate progressive disclosure principles (3,000-6,000 tokens each)
- Template files in state/ directory are overly verbose and prescriptive
- No skills defined despite complex domain knowledge
- Hook prompts lack context management strategy
- Missing proper tool restrictions on agents

### Code Quality: 73/100

**Strengths:**
- Clean Python hook implementations with proper error handling
- Good separation of concerns between agents
- State management architecture is sound
- Hook bypass logic is well-designed
- JSON configuration approach is maintainable

**Issues:**
- Hooks reference prompt templates that don't follow best practices
- No validation of prompt quality before agent invocation
- State templates encourage verbose documentation
- Missing token usage tracking/limits
- No fallback mechanisms for agent failures

### Prompt Quality: 75/100

**Strengths:**
- Agent descriptions clearly state purpose
- whenToUse conditions are specific and actionable
- Command descriptions are clear
- Model selection (Haiku) is appropriate for agents

**Critical Issues:**
- Agent system prompts are encyclopedic rather than task-focused
- No use of skills for reusable prompt patterns
- Extensive examples embedded in prompts (should be in skills)
- Template files create "prompt bloat" in downstream usage
- Hook prompt template lacks quality gate logic

---

## Critical Issues (MUST FIX)

### 1. SEVERE CONTEXT BLOAT - Agent System Prompts

**Issue:** Each agent contains 3,000-6,000 token system prompts with extensive examples, tables, and instructions that load into every conversation.

**Impact:**
- problem-discovery-agent: ~6,000 tokens
- context-gatherer-agent: ~4,500 tokens
- prompt-assessor-agent: ~4,800 tokens
- execution-router-agent: ~5,200 tokens
- **Total: ~20,500 tokens before user even speaks**

This creates exactly the context inefficiency the plugin aims to prevent.

**BEFORE (problem-discovery-agent.md lines 212-221):**
```markdown
## Common XY Problem Patterns You'll Encounter

| Surface Request | 5 Whys Discovery | Root Cause | What Actually Solves It |
|-----------------|------------------|-----------|------------------------|
| "Add loading spinners" | Users complain → app feels slow → 5-8s operations → sequential API calls → no caching | Need caching layer | Query caching + API optimization |
| "Make logout button bigger" | Can't find it → hidden in menu → mobile-first → wrong traffic assumption | Navigation doesn't match actual users | Desktop-optimized navigation |
| "Add email notifications" | Users miss updates → in-app notifications ignored → too many false positives → poor filtering | Notification logic too broad | Smart filtering + user preferences |
```

**AFTER (move to skill file: skills/xy-problem-patterns.md):**
```markdown
---
name: xy-problem-patterns
description: Common XY problem patterns with discovery examples and root cause analysis
---

# XY Problem Pattern Library

## Pattern Recognition Guide

[Full content moved here - only loaded when agent explicitly requests it]
```

**Agent prompt becomes:**
```markdown
# Problem Discovery Agent

You uncover the REAL problem users are trying to solve through Socratic questioning.

## Core Process

1. Listen to the request
2. Ask clarifying questions
3. Apply 5 Whys when detecting solution-focused requests
4. Confirm root cause with user

## Resources Available

- Use skill 'xy-problem-patterns' for common pattern recognition
- Use skill 'questioning-techniques' for effective question templates

Begin with empathy. Ask questions to understand the underlying need.
```

**Token Savings:** ~5,000 tokens per agent conversation

---

### 2. State Template Verbosity

**Issue:** Templates in state/ directory are 2,500-4,000 tokens of prescriptive structure that encourage over-documentation.

**Impact:** Users who follow these templates will create massive documents that bloat subsequent agent contexts.

**BEFORE (ready-prompt-template.md - 193 lines):**
Full template with 20+ sections including extensive checklists, tables, and boilerplate

**AFTER (condensed to essentials):**
```markdown
# Execution Prompt

**Quality Score:** [0-100] | **Model:** [H/S/O] | **Cost:** [$X.XX]

## Problem & Success
[Clear problem statement]

Success criteria:
- [ ] [Measurable criterion 1]
- [ ] [Measurable criterion 2]

## Context
Tech stack: [Stack]
Patterns: [Key patterns with file refs]
Constraints: [Critical constraints only]

## Scope
Files to modify:
- [ ] /path/file.ts - [Purpose]

Tests needed:
- [ ] /path/test.ts

## Implementation Notes
[Only critical details - no boilerplate]
```

**Token Savings:** ~2,000 tokens per ready prompt

---

### 3. Missing Skills Architecture

**Issue:** Zero skills defined despite rich domain knowledge (XY problems, 5 Whys, quality rubrics, cost estimation).

**Impact:**
- All knowledge embedded in agent prompts
- No reusability across agents
- Violates progressive disclosure
- Makes updates difficult

**AFTER (create skills/):**

```
plugins/prompt-orchestrator/skills/
├── xy-problem-patterns.md        # Common XY patterns with examples
├── five-whys-protocol.md          # 5 Whys methodology
├── quality-rubric.md              # 100-point assessment rubric
├── cost-estimation.md             # Model selection & pricing
├── questioning-techniques.md      # Socratic questioning templates
└── context-gathering-checklist.md # What context to gather
```

Each skill is 500-800 tokens and loaded only when needed.

---

### 4. Hook Prompt Template Issues

**Issue:** hooks/user-prompt-submit.md creates a template-based gate that lacks actual decision logic.

**Impact:** Hook cannot effectively assess prompt quality or make orchestration decisions.

**BEFORE (user-prompt-submit.md lines 6-14):**
```markdown
## Current Context

**User Prompt:** {{prompt}}

**Session State:**
- Active: {{session_state.active}}
- Current Discovery Round: {{session_state.discovery_round}}
- Last Quality Score: {{session_state.quality_score}}
- Orchestration in Progress: {{session_state.orchestration_in_progress}}
```

**AFTER (replace with actual gate logic):**
```markdown
# Orchestration Quality Gate

Evaluate this prompt for orchestration needs:

**Prompt:** {{prompt}}

## Decision Criteria

Score prompt clarity (0-10):
- 8-10: Clear, specific → Execute directly
- 5-7: Moderate → Quick refinement
- 0-4: Vague → Full orchestration

Check for:
- [ ] Specific requirements vs vague goals
- [ ] Technical context provided
- [ ] Measurable success criteria

**Decision:** [Execute / Refine / Orchestrate]
**Reasoning:** [One line explanation]
```

---

## Important Improvements (SHOULD FIX)

### 5. Progressive Disclosure for Agent Instructions

**Issue:** Agents receive all instructions upfront instead of just-in-time guidance.

**Example:** context-gatherer-agent provides extensive "Context Organization Template" (lines 113-158) that's always loaded.

**Improvement:** Move detailed templates to Read-accessible files:

```
plugins/prompt-orchestrator/templates/
├── context-summary.md          # Template loaded when agent needs it
├── discovery-questions.md      # Question templates
└── assessment-format.md        # Assessment output format
```

Agent prompt references: "See templates/context-summary.md for output format"

**Token Savings:** ~1,500 tokens per agent

---

### 6. Reduce Example Verbosity

**Issue:** Agents contain 5-10 detailed examples inline (e.g., problem-discovery-agent lines 53-96).

**Improvement:**
- Keep 1 brief example in agent prompt
- Move remaining examples to skill or template file
- Reference them as "See skill:xy-examples for more patterns"

**Before:** 1,200 tokens of examples in agent
**After:** 200 tokens in agent, 1,000 tokens in skill (loaded only if needed)

---

### 7. Command Prompt Optimization

**Issue:** orchestrate.md contains 127 lines with extensive process description that repeats agent knowledge.

**Improvement:**

**BEFORE (orchestrate.md lines 54-85):**
```markdown
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
```

**AFTER (condensed):**
```markdown
## Process

**Phase 1: Discovery** (Haiku ~$0.05-0.15)
- Uncover root problem through questioning

**Phase 2: Refinement** (Haiku ~$0.03-0.10)
- Gather context, assess quality (target: 85/100)

**Phase 3: Execution** (Model TBD, $0.08-0.50)
- Execute with optimal model

{{ if .task }}
Initial problem: {{ .task }}

The discovery agent will begin.
{{ else }}
What problem are you solving?
{{ end }}
```

**Token Savings:** ~800 tokens per command invocation

---

### 8. Agent Tool Restrictions

**Issue:** Agents have broad tool access without clear restrictions.

**Current:**
```yaml
tools: Read, Grep, Glob
```

**Improvement:** Specify tool purposes and add restrictions:

```yaml
tools:
  allowed:
    - Read     # For reading templates and context files
    - Grep     # For finding patterns in codebase
    - Glob     # For discovering related files
  restricted:
    - Write    # Never write files (read-only agent)
    - Bash     # Never execute commands (safety)
  guidance: |
    Use Read for templates/, Grep for code patterns, Glob for file discovery.
    Never modify files - only gather information.
```

---

### 9. Add Token Tracking and Limits

**Issue:** No tracking of token usage despite plugin's cost-optimization focus.

**Improvement:** Add to session state:

```json
{
  "session_id": "uuid",
  "token_usage": {
    "discovery": 1250,
    "refinement": 850,
    "total": 2100
  },
  "cost_estimate": {
    "so_far": 0.08,
    "limit": 1.00,
    "remaining": 0.92
  }
}
```

Update hooks to track and enforce limits.

---

### 10. README Redundancy

**Issue:** README.md (303 lines) repeats agent knowledge and includes verbose examples.

**Improvement:**
- Keep: Quick start, architecture diagram, key features
- Remove: Detailed phase descriptions (duplicates agent prompts)
- Remove: Extensive workflow examples (move to docs/ or examples/)
- Add: Link to detailed docs if needed

**Target:** Reduce README to 150 lines focused on "what" and "why", not "how" (that's in agents)

---

## Optional Enhancements

### 11. Quality Scoring Optimization

Create a lightweight scoring algorithm instead of full agent invocation for simple cases:

```python
# In gate.py
def quick_quality_score(prompt):
    """Fast heuristic scoring without agent."""
    score = 50  # baseline

    # Has specific technical terms?
    if any(term in prompt.lower() for term in ['implement', 'add', 'fix', 'update']):
        score += 10

    # Has file references?
    if '/' in prompt or '.ts' in prompt or '.py' in prompt:
        score += 10

    # Has acceptance criteria keywords?
    if any(word in prompt.lower() for word in ['when', 'should', 'must', 'will']):
        score += 10

    # Long enough to be specific?
    if len(prompt.split()) > 20:
        score += 10

    # Too vague?
    if any(word in prompt.lower() for word in ['better', 'faster', 'improve', 'fix']) and len(prompt.split()) < 10:
        score -= 20

    return score
```

Use this for fast triage before invoking prompt-assessor-agent.

---

### 12. Skill-Based Agent Prompts

Refactor agents to be skill-driven:

```markdown
---
name: problem-discovery-agent
model: haiku
description: Detects XY problems and uncovers root causes
tools: Read
skills:
  - xy-problem-patterns
  - five-whys-protocol
  - questioning-techniques
---

# Problem Discovery Agent

You uncover real problems through Socratic questioning.

## Process
1. Listen to request
2. Check skill:xy-problem-patterns for detection
3. Apply skill:five-whys-protocol to dig deeper
4. Use skill:questioning-techniques for effective questions
5. Confirm root cause

Begin with empathy. The user knows their domain better than you.
```

Agent prompt: ~500 tokens instead of 6,000 tokens.

---

### 13. Hooks State Validation

Add validation in hooks to prevent invalid state transitions:

```python
def validate_session_state(session_state):
    """Ensure state is valid before proceeding."""

    # Can't be in progress without being active
    if session_state.get("orchestration_in_progress") and not session_state.get("active"):
        session_state["orchestration_in_progress"] = False

    # Discovery rounds can't be negative
    if session_state.get("discovery_round", 0) < 0:
        session_state["discovery_round"] = 0

    # Quality score must be 0-100
    score = session_state.get("quality_score", 0)
    session_state["quality_score"] = max(0, min(100, score))

    return session_state
```

---

### 14. Cost Comparison Simplification

The README and agents repeatedly show detailed cost breakdowns. Simplify to a reference table:

**Create:** docs/pricing-reference.md

```markdown
# Orchestrator Pricing Reference

## Quick Comparison

| Approach | Discovery | Refinement | Execution | Total |
|----------|-----------|------------|-----------|-------|
| **Orchestrator** | $0.05 | $0.03 | $0.18 | **$0.26** |
| Direct Opus | - | - | $0.70 | **$0.70** |
| **Savings** | | | | **63%** |

## When Each Model Makes Sense

- **Haiku** ($0.08): Simple bugs, <3 files
- **Sonnet** ($0.18): Standard features, <10 files
- **Opus** ($0.42): Architecture, >10 files, research

Reference this doc instead of repeating in every agent/command.
```

---

### 15. Bypass Mechanism Enhancement

The !raw prefix bypass is good but could be clearer:

**Add to README and orchestrator command:**

```markdown
## Bypass Orchestration

When you have a clear, well-formed prompt:

```
!raw Your clear, specific prompt here
```

Or use quality score override:

```
!score:90 Your prompt (claims 90/100 quality, skips assessment)
```

Control orchestration:
- `/orchestrator on` - Enable always-on mode
- `/orchestrator off` - Disable (all prompts bypass)
- `/orchestrator status` - Check current state
```

---

## Implementation Roadmap

### Phase 1: Critical Context Reduction (Priority 1)
**Goal:** Reduce agent prompt sizes by 70%

1. **Create skills/ directory structure**
   - Extract XY patterns to skill
   - Extract 5 Whys protocol to skill
   - Extract quality rubric to skill
   - Extract cost estimation to skill
   - Extract questioning techniques to skill

2. **Refactor agent prompts**
   - problem-discovery-agent.md: 6,000 → 800 tokens
   - context-gatherer-agent.md: 4,500 → 600 tokens
   - prompt-assessor-agent.md: 4,800 → 700 tokens
   - execution-router-agent.md: 5,200 → 600 tokens

3. **Simplify state templates**
   - ready-prompt-template.md: 193 lines → 50 lines
   - session-template.md: 129 lines → 40 lines
   - discovery-log-template.md: 153 lines → 40 lines

**Impact:** ~15,000 token reduction per orchestration workflow

---

### Phase 2: Improve Progressive Disclosure (Priority 2)
**Goal:** Load knowledge only when needed

4. **Move templates to readable files**
   - Create templates/ directory
   - Move detailed formats from agent prompts
   - Update agents to reference templates with Read tool

5. **Optimize command prompts**
   - orchestrate.md: 127 lines → 50 lines
   - Remove process descriptions (agents handle)
   - Focus on user guidance only

6. **Enhance README**
   - Remove verbose examples
   - Remove duplicate content
   - Focus on "what" and "why"
   - Target: 303 lines → 150 lines

---

### Phase 3: Quality & Safety (Priority 3)
**Goal:** Better error handling and validation

7. **Add quick quality scoring**
   - Implement heuristic scoring in gate.py
   - Fast triage before agent invocation
   - Save agent calls for unclear cases

8. **Improve hook prompt template**
   - Replace template-based with logic-based
   - Add actual decision criteria
   - Include reasoning for orchestration decisions

9. **Add tool restrictions**
   - Specify allowed/restricted tools per agent
   - Add guidance for tool usage
   - Prevent unintended side effects

---

### Phase 4: Polish & Enhancement (Priority 4)
**Goal:** Better UX and maintainability

10. **Token tracking**
    - Add usage tracking to session state
    - Enforce cost limits
    - Show running total to users

11. **State validation**
    - Add validation helpers
    - Prevent invalid state transitions
    - Better error messages

12. **Documentation consolidation**
    - Create docs/ directory for detailed guides
    - Reference docs from README
    - Single source of truth for pricing

---

## Testing Recommendations

After implementing improvements:

1. **Context Measurement Test**
   - Run orchestration with original prompts
   - Measure total tokens loaded
   - Compare before/after
   - Target: 70% reduction

2. **Quality Preservation Test**
   - Test problem discovery with 10 sample XY problems
   - Verify agents still detect patterns correctly
   - Ensure no regression in discovery quality

3. **Cost Verification Test**
   - Run full orchestration workflow
   - Measure actual API costs
   - Verify cost claims in README are accurate
   - Update estimates if needed

4. **Bypass Functionality Test**
   - Test !raw bypass
   - Test /orchestrator commands
   - Test followup detection
   - Ensure hooks correctly handle all cases

5. **Progressive Disclosure Test**
   - Trace which files are actually Read during orchestration
   - Verify skills/templates are loaded only when referenced
   - Confirm agents don't request unused knowledge

---

## Dimension Breakdown

### Best Practices Compliance: 68/100

**Scoring:**
- Plugin structure (10/10): Correct manifest, hooks.json, directory layout
- Component naming (10/10): Clear, descriptive names following conventions
- YAML frontmatter (8/10): Correct but missing some agent metadata (skills)
- Progressive disclosure (2/10): CRITICAL FAILURE - all knowledge loaded upfront
- Documentation (8/10): Comprehensive but verbose
- Tool management (5/10): Missing restrictions and guidance
- State management (10/10): Clean architecture with JSON files
- Hook implementation (8/10): Well-structured Python but prompt issues
- Reusability (3/10): No skills, all knowledge embedded in agents
- Maintainability (4/10): Updates require changing massive agent prompts

**Critical gaps:**
- No skills architecture (violates DRY)
- Agent prompts are encyclopedic (violates progressive disclosure)
- Templates encourage over-documentation

---

### Code Quality: 73/100

**Scoring:**
- Python code (15/15): Clean, well-structured, proper error handling
- Hook logic (12/15): Good bypass handling, needs validation
- State persistence (10/10): JSON-based, clear structure
- Error handling (8/10): Basic handling present, could be more robust
- Configuration (10/10): hooks.json provides good separation
- Agent separation (10/10): Clear boundaries, single responsibility
- Token efficiency (3/10): CRITICAL FAILURE - massive token waste
- Modularity (5/10): Monolithic agent prompts, no reusable components

**Critical gaps:**
- No token usage tracking
- No validation of session state
- Agent prompts not modular
- Missing fallback mechanisms

---

### Prompt Quality: 75/100

**Scoring:**
- Agent descriptions (10/10): Clear, specific purpose statements
- whenToUse conditions (10/10): Specific, actionable triggers
- System prompts clarity (8/10): Clear but overly verbose
- Examples quality (8/10): Good examples but too many inline
- Instruction specificity (7/10): Specific but buried in noise
- Command descriptions (10/10): Clear user-facing descriptions
- Model selection (10/10): Appropriate Haiku selection for agents
- Context efficiency (2/10): CRITICAL FAILURE - excessive context
- Prompt reusability (5/10): All prompts are one-time-use
- Tone & voice (5/10): Sometimes too prescriptive

**Critical gaps:**
- 15,000+ token system prompts
- No progressive disclosure
- Examples embedded instead of referenced
- Templates create downstream bloat

---

## Summary of Token Impact

### Current State (Estimated)
- problem-discovery-agent: ~6,000 tokens
- context-gatherer-agent: ~4,500 tokens
- prompt-assessor-agent: ~4,800 tokens
- execution-router-agent: ~5,200 tokens
- orchestrate command: ~2,500 tokens
- Templates used: ~6,000 tokens
- **Total context per full workflow: ~29,000 tokens**

### After Improvements (Target)
- problem-discovery-agent: ~800 tokens (skills loaded as needed)
- context-gatherer-agent: ~600 tokens (templates via Read)
- prompt-assessor-agent: ~700 tokens (rubric in skill)
- execution-router-agent: ~600 tokens (cost table in skill)
- orchestrate command: ~800 tokens
- Skills loaded on demand: ~2,000 tokens (only when accessed)
- **Total context per full workflow: ~5,500 tokens**

### Impact
- **81% token reduction** in base workflow
- **$0.15 savings per orchestration** (at Haiku rates)
- Better aligns with plugin's cost-optimization mission
- Faster agent responses (less to process)
- Easier maintenance (update skills, not massive agent prompts)

---

## Conclusion

The prompt-orchestrator plugin has excellent architecture and a compelling value proposition. However, it suffers from a critical irony: a plugin designed to optimize prompt quality and reduce costs itself uses extremely inefficient, verbose prompts.

**The path forward is clear:**
1. Extract knowledge to skills (reusable, progressive)
2. Simplify agent prompts to process + skill references
3. Reduce template verbosity by 70%
4. Add token tracking to demonstrate savings
5. Implement quick scoring for fast triage

These improvements will make the plugin practice what it preaches: efficient, focused prompts that deliver maximum value with minimum context.

**Recommended Priority:** HIGH - These improvements directly impact the core value proposition.

---

**Report Generated:** 2026-01-29
**Plugin Version:** 2.0.0
**Evaluation Framework:** Anthropic Plugin Best Practices + Context Management Principles
