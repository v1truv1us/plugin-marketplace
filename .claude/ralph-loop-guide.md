# Using Plugin Improver with Ralph Loop

## Overview

Plugin Improver is specifically designed to work with Ralph Loop for **continuous iterative improvement** of your plugins. This guide shows you how to set up and use the system effectively.

## What Ralph Loop Does

Ralph Loop creates self-referential feedback loops where:

1. You provide a task description
2. Claude processes the task
3. Results are saved to files
4. The SAME PROMPT is fed back on exit
5. Each iteration sees and can improve upon previous work

This creates **automatic progression**—each iteration builds on what came before.

## Quick Start

### Basic Command

```bash
/ralph-loop:ralph-loop "iteratively improve all plugins in my marketplace using plugin-improver"
```

This will:
1. Evaluate all plugins with `/improver:improve-plugin`
2. Save evaluation results to `.improvements/`
3. On next iteration, see previous results and continue improving
4. Accumulate improvements over multiple iterations

### With Iteration Limit

```bash
/ralph-loop:ralph-loop "iteratively improve plugins" --max-iterations 5
```

Runs exactly 5 iterations, then stops.

### With Completion Promise

```bash
/ralph-loop:ralph-loop "improve plugins to 85/100 score" --completion-promise "All plugins have overall quality score of 85 or higher"
```

Stops when the completion promise is true.

## Iteration Strategy

### Phase 1: Assessment (Iteration 1-2)

**Goal**: Understand current state and identify priorities

```bash
/ralph-loop:ralph-loop "evaluate all plugins and identify top improvement opportunities"
```

**What happens**:
- All plugins evaluated
- Quality scores documented
- Top issues identified per plugin
- Improvement roadmap created

**Output**: `.improvements/baseline-evaluation.json`

### Phase 2: Targeted Improvements (Iteration 3-6)

**Goal**: Apply high-impact improvements systematically

```bash
/ralph-loop:ralph-loop "focus on critical issues first: improve trigger phrases, clarify agent roles, fix frontmatter"
```

**What happens**:
- Improve trigger phrases across all skills
- Clarify vague agent roles
- Fix any manifest issues
- Re-evaluate to show progress

**Output**: `.improvements/targeted-improvements-log.md`

### Phase 3: Optimization (Iteration 7+)

**Goal**: Refine and polish, handle edge cases

```bash
/ralph-loop:ralph-loop "optimize remaining issues: improve command guidance, enhance documentation, add edge case handling"
```

**What happens**:
- Improve command clarity
- Enhance documentation
- Address edge cases
- Final quality assessment

**Output**: `.improvements/optimization-complete.md`

## File Organization

Ralph Loop creates this structure in `.improvements/`:

```
.improvements/
├── plugin-[name]-evaluation-iter1.json    # Initial evaluation
├── plugin-[name]-evaluation-iter2.json    # After iteration 2
├── plugin-[name]-evaluation-iter3.json    # After iteration 3
├── improvements-applied.log              # What was changed
├── scores-history.json                   # Quality score trend
├── progress-summary.md                   # Overall progress
└── final-report.md                       # When complete
```

## Monitoring Progress

### Check Current Scores

View `.improvements/scores-history.json`:

```json
{
  "planner": [
    { "iteration": 1, "score": 72, "changes": 3 },
    { "iteration": 2, "score": 78, "changes": 5 },
    { "iteration": 3, "score": 83, "changes": 4 }
  ],
  "prompt-orchestrator": [
    { "iteration": 1, "score": 81, "changes": 2 },
    { "iteration": 2, "score": 84, "changes": 3 }
  ]
}
```

### Review Changes Made

Check `.improvements/improvements-applied.log`:

```
[Iter 2] planner: Updated trigger phrases in eisenhower-prioritization skill
[Iter 2] planner: Clarified prioritization-agent role
[Iter 2] planner: Fixed manifest version format
[Iter 3] planner: Enhanced command guidance in plan-day
[Iter 3] planner: Added CLAUDE.md documentation
```

## Real-World Example

### Starting State

```
planner: 72/100 (Important improvements needed)
prompt-orchestrator: 81/100 (Good, optimization recommended)
subagent-creator: 68/100 (Important improvements needed)
Average: 73.7/100
```

### Iteration 1: Assess & Prioritize

```bash
/ralph-loop:ralph-loop "step 1: evaluate all plugins and identify critical issues"
```

**Results**:
- planner: Too generic trigger phrases, agent roles unclear
- prompt-orchestrator: Good architecture, needs better examples
- subagent-creator: Missing documentation, incomplete skill descriptions

**Decision**: Focus planner and subagent-creator first (critical issues)

### Iteration 2: Fix Critical Issues

```bash
/ralph-loop:ralph-loop "step 2: fix critical issues - improve trigger phrases, clarify roles, add documentation"
```

**Changes Made**:
- planner: Updated 12 trigger phrases to be more specific
- planner: Clarified 3 agent roles
- subagent-creator: Created CLAUDE.md
- subagent-creator: Expanded skill descriptions

**Results**:
- planner: 78/100 (+6 points)
- subagent-creator: 75/100 (+7 points)
- Average: 78/100

### Iteration 3: Important Improvements

```bash
/ralph-loop:ralph-loop "step 3: address important improvements - enhance examples, improve clarity, add edge case handling"
```

**Changes Made**:
- planner: Added detailed examples to commands
- planner: Enhanced command phase guidance
- prompt-orchestrator: Added more code examples
- subagent-creator: Improved agent descriptions

**Results**:
- planner: 84/100 (+6 points)
- prompt-orchestrator: 86/100 (+5 points)
- subagent-creator: 81/100 (+6 points)
- Average: 83.7/100

### Iteration 4: Polish & Final Check

```bash
/ralph-loop:ralph-loop "step 4: polish remaining issues and verify all improvements applied"
```

**Results**:
- planner: 87/100
- prompt-orchestrator: 88/100
- subagent-creator: 84/100
- Average: 86.3/100
- Status: Production-ready ✅

## Structuring Your Iterations

### For Multiple Plugins

Break into focused iterations:

```bash
# Iteration 1: Evaluate all
/ralph-loop:ralph-loop "evaluate all plugins"

# Iteration 2: Fix planner
/ralph-loop:ralph-loop "improve planner plugin - critical issues first"

# Iteration 3: Fix subagent-creator
/ralph-loop:ralph-loop "improve subagent-creator plugin - critical issues first"

# Iteration 4: Polish both
/ralph-loop:ralph-loop "polish all plugins - optional enhancements"
```

### For Deep Dive on One Plugin

```bash
# Get detailed evaluation
/ralph-loop:ralph-loop "detailed evaluation of planner plugin"

# Fix best-practices issues
/ralph-loop:ralph-loop "improve planner: focus on best-practices compliance"

# Fix quality issues
/ralph-loop:ralph-loop "improve planner: focus on code quality and architecture"

# Fix prompt issues
/ralph-loop:ralph-loop "improve planner: focus on prompt clarity and specificity"

# Verify all improvements
/ralph-loop:ralph-loop "final review of planner plugin"
```

## Best Practices

### 1. Set Clear Iteration Goals

**Good**:
```
"Fix all critical issues in planner plugin: trigger phrases, agent roles, frontmatter"
```

**Bad**:
```
"Improve plugins"
```

Clear goals = better results and easier progress tracking.

### 2. Review Results Between Iterations

After each iteration:
1. Check `.improvements/improvements-applied.log`
2. Verify changes make sense
3. Review quality score changes
4. Adjust next iteration goal if needed

### 3. Use Focused Iterations

Rather than "improve everything", focus on one dimension per iteration:
- Iteration 1: Best-practices compliance
- Iteration 2: Code quality issues
- Iteration 3: Prompt clarity
- Iteration 4: Polish and refinement

This makes progress visible and easier to verify.

### 4. Track Metrics Over Time

Create `.improvements/scores-summary.csv` to track trends:

```
iteration,plugin,score,change,issues_fixed
1,planner,72,0,0
2,planner,78,6,5
3,planner,84,6,4
4,planner,87,3,2
1,prompt-orchestrator,81,0,0
2,prompt-orchestrator,84,3,2
3,prompt-orchestrator,88,4,3
```

### 5. Celebrate Progress

As scores improve, document what worked:
- Which improvement techniques were most effective
- Which issues were hardest to fix
- What patterns emerged
- How to prevent similar issues in future plugins

## Stopping Conditions

### When to Stop

**Stop when**:
- All critical issues are fixed
- Important improvements are mostly done
- Average quality score is 85+
- No more improvements being discovered
- Diminishing returns (effort > benefit)

**Don't stop at**:
- First evaluation
- One iteration
- Before critical issues are fixed

### Using Completion Promises

```bash
/ralph-loop:ralph-loop "improve plugins" \
  --completion-promise "All plugins have critical issues fixed and score > 80"
```

The loop will stop ONLY when the promise is true.

⚠️ **Important**: Only output the completion promise when it's **completely and unequivocally true**. Never fake it to escape the loop.

## Troubleshooting

### Loop Not Making Progress

**Check**:
- Are improvements actually being applied to files?
- Are quality scores showing change?
- Is the goal clear enough?

**Fix**:
- Make goal more specific
- Review what changed in previous iteration
- Adjust approach if needed

### Stuck on Same Issues

**Cause**: Same issue being identified but not fixed

**Solution**:
- Explicitly state in next iteration goal: "Fix [specific issue]"
- Provide more detailed guidance on solution
- Ask for concrete before/after examples

### Taking Too Long

**Cause**: Too many iterations needed

**Solution**:
- Use larger iteration chunks (fix more in each iteration)
- Focus on highest-impact issues first
- Set reasonable completion promise

## Example: Full Workflow

```bash
# Step 1: Initial assessment
/ralph-loop:ralph-loop "evaluate all plugins and create baseline report" --max-iterations 1

# Step 2: Fix critical issues
/ralph-loop:ralph-loop "fix critical issues: trigger phrases, agent roles, documentation" --max-iterations 3

# Step 3: Important improvements
/ralph-loop:ralph-loop "apply important improvements: clarity, examples, edge cases" --max-iterations 3

# Step 4: Final polish
/ralph-loop:ralph-loop "final polish: verify quality scores above 85, all improvements applied" --max-iterations 2
```

This structured approach ensures:
- Clear progress tracking
- Focused effort each iteration
- Measurable improvements
- Final quality verification

## Success Metrics

Track these across your Ralph Loop iterations:

| Metric | Target | How to Measure |
|--------|--------|---|
| **Overall Avg Quality** | 85+ | `scores-history.json` |
| **Critical Issues Fixed** | 100% | `improvements-applied.log` |
| **Trigger Phrases** | Specific & natural | Manual review |
| **Agent Roles** | Clear and specific | Manual review |
| **Documentation** | Complete | Check README, CLAUDE.md |
| **Best-Practices Score** | 85+ | Evaluation report |
| **Code Quality Score** | 85+ | Evaluation report |
| **Prompt Quality Score** | 85+ | Evaluation report |

## Next Steps

1. **Start Small**: Evaluate one plugin first
   ```bash
   /improver:improve-plugin planner
   ```

2. **Run Single Iteration**: See initial results
   ```bash
   /ralph-loop:ralph-loop "evaluate planner plugin" --max-iterations 1
   ```

3. **Review Results**: Check `.improvements/` directory

4. **Plan Iterations**: Based on findings, plan your improvement strategy

5. **Run Full Loop**: Execute your iteration plan
   ```bash
   /ralph-loop:ralph-loop "improve plugins to 85/100" --max-iterations 10
   ```

6. **Track Progress**: Monitor scores and improvements

7. **Celebrate Success**: Document what improved and why

---

**With Ralph Loop, your plugins will continuously improve with minimal manual effort—each iteration compounds on the last, creating steady progress toward excellence.**

## Command Reference

```bash
# Evaluate one plugin
/improver:improve-plugin planner

# Single iteration evaluation
/ralph-loop:ralph-loop "evaluate all plugins" --max-iterations 1

# Multi-iteration improvement
/ralph-loop:ralph-loop "improve all plugins" --max-iterations 5

# With completion target
/ralph-loop:ralph-loop "improve plugins to 85+/100" \
  --completion-promise "All plugins score 85 or higher"

# Focused improvement
/ralph-loop:ralph-loop "fix trigger phrases in all plugins" --max-iterations 3

# Progressive approach
/ralph-loop:ralph-loop "step 1: evaluate, step 2: fix critical, step 3: polish"
```

---

**Ready to start?** Use `/improver:improve-plugin` first to understand your current state, then plan your Ralph Loop strategy!
