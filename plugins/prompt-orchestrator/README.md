# Prompt Orchestrator Plugin

A two-tier prompt orchestration system that separates problem discovery from solution execution, optimizing both cost (60-80% savings) and quality.

## How It Works

The plugin runs a **three-phase workflow** designed to uncover real problems before expensive model execution:

### Phase 1: Discovery (Haiku) 💡
The **problem-discovery-agent** uses Socratic questioning and 5 Whys analysis to uncover what users actually need to solve, not just what they ask for.

**Example:**
- User: "Add loading spinners"
- Agent discovers: "Real problem is slow database queries (no caching)"
- Cost: ~$0.05

### Phase 2: Refinement (Haiku) 🔧
The **context-gatherer-agent** and **prompt-assessor-agent** gather project context, identify patterns, and score prompt quality.

**Process:**
1. Context gathering: Find related code, patterns, constraints
2. Quality assessment: Score 0-100 on specificity, clarity, context, actionability
3. Iteration: Refine until score ≥85/100 or reach quality plateau
- Cost: ~$0.03

### Phase 3: Execution (Sonnet/Opus) ⚡
The **execution-router-agent** selects the optimal model and hands off a crystal-clear prompt.

**Cost comparison:**
- Traditional (ask Opus directly): ~$0.70 (includes clarification back-and-forth)
- Orchestrator: ~$0.26 (50%+ savings)

## Quick Start

### Always-On Mode (Recommended)

The orchestrator can run automatically in the background:

```bash
/orchestrator on
```

Now every prompt will be analyzed and optimized before execution.

### Manual Usage

```bash
/orchestrate "Your problem or feature request here"
```

The plugin will guide you through discovery, refinement, and handoff.

### Skip Discovery (if problem is already clear)

```bash
/orchestrate:skip-to-planning "Crystal-clear problem statement"
```

### Force Discovery (if unsure)

```bash
/orchestrate:discover "Vague problem statement"
```

### Bypass Orchestration

For specific prompts when always-on mode is active:

```bash
!raw "Your clear, specific prompt"
```

## Architecture

```
plugins/prompt-orchestrator/
├── plugin.json                 # Plugin manifest with hooks config
├── hooks.json                  # Hook configuration and settings
├── commands/
│   ├── orchestrate.md          # Manual orchestration
│   └── orchestrator.md         # Always-on control commands
├── agents/
│   ├── problem-discovery-agent.md    # XY problem detection, 5 Whys
│   ├── context-gatherer-agent.md     # Gather code patterns & context
│   ├── prompt-assessor-agent.md      # Quality scoring (0-100)
│   └── execution-router-agent.md     # Model selection & cost estimation
├── hooks/
│   ├── init-session.py         # SessionStart hook implementation
│   ├── gate.py                 # UserPromptSubmit hook implementation
│   ├── user-prompt-submit.md   # Hook prompt template
│   └── hooks.md                # Technical documentation
├── state/
│   ├── session-template.md     # Current session state
│   ├── ready-prompt-template.md # Final optimized prompt
│   └── discovery-log-template.md # Problem discovery history
├── .gitignore                  # Ignore user state files
└── README.md                   # This file
```

## Key Features

### XY Problem Detection
Detects when users are asking for solution X but actually need solution Y:
- "Add loading spinners" → Really need "implement query caching"
- "Make logout button bigger" → Really need "redesign for desktop users"
- "Add email notifications" → Really need "improve notification filtering"

### 5 Whys Protocol
Structured questioning that digs to root causes:
```
Why do users get logged out?
→ Timeout is too short
→ Why so short?
→ Sessions don't auto-extend
→ Why not?
→ Never implemented
→ ROOT: Need auto-extend logic
```

### Cost Optimization
Smart model selection saves money on every task:
- Simple bugs: Haiku ($0.08)
- Standard features: Sonnet ($0.18)
- Complex architecture: Opus ($0.42)

### Quality Assessment
100-point rubric evaluates prompt across 4 dimensions:
1. **Specificity** (25) - Are requirements measurable?
2. **Clarity** (25) - Would 3 devs implement identically?
3. **Context** (25) - Is all necessary background present?
4. **Actionability** (25) - Can we start immediately?

### State Persistence
Session state survives `/clear` so you can:
1. Use `/orchestrate` for discovery & refinement
2. Type `/clear` to wipe the conversation
3. Get a fresh context window with ready-made prompt
4. Execute with full clarity, no noise

## Workflow Example

### Step 1: Start with vague problem
```
User: "The login isn't working right"
```

### Step 2: Discovery phase (Haiku asks questions)
```
Agent: Why do you think login is broken? What symptoms do users report?
User: Users with 2FA keep getting logged out after 15 minutes

Agent: Why 15 minutes? Is that the timeout you set?
User: Yeah, but with 2FA it should auto-extend...

Agent: Have you investigated why it's not auto-extending?
User: No, hadn't looked into that yet
```
**Discovery cost: $0.05** ✓

### Step 3: Refinement phase (context gathering & assessment)
```
Agent: I found your existing OAuth implementation and identified the issue:
- OAuth refresh tokens aren't being stored for 2FA sessions
- Existing pattern in /src/auth/tokens.ts handles regular tokens

Prompt quality assessment:
- Specificity: 22/25 ✓
- Clarity: 24/25 ✓
- Context: 23/25 ✓
- Actionability: 21/25 ✓
- Total: 90/100 ✓ READY FOR EXECUTION
```
**Refinement cost: $0.03** ✓

### Step 4: Model selection & handoff
```
Agent: Ready to execute!

Recommended Model: Sonnet 4.5
- Moderate complexity (multiple systems)
- Clear existing patterns
- No research needed

Cost: $0.18 vs $0.42 for Opus (57% savings)

Your optimized prompt is in state/ready-prompt.md
Type /clear to wipe this conversation, then begin execution.
```

### Step 5: Execution (fresh session)
```
User: /clear

[Conversation cleared, CLAUDE.md points to ready-prompt.md]

User: /execute:ready-prompt

[Sonnet executes with crystal-clear prompt, no ambiguity]
```
**Execution cost: $0.18** ✓

**Total: $0.26 vs $0.70 traditional (63% savings)**

## Quality Gates

The plugin enforces quality before expensive execution:

| Score | Action |
|-------|--------|
| ≥85 | ✓ Ready for execution |
| 70-84 | 🔧 Suggest refinement |
| <70 | 🔴 Return to discovery |

## v2 Scope

This is version 2.0.0, with always-on orchestration:

✅ Problem discovery with XY detection
✅ Prompt quality assessment (0-100 rubric)
✅ Model selection & cost estimation
✅ Context gathering from codebase
✅ State persistence across /clear
✅ Session lifecycle hooks
✅ Always-on orchestration mode
✅ Automatic quality gates
✅ Hook-based integration
✅ Bypass controls (!raw, /orchestrator commands)

Potential future enhancements:
- GitHub/Jira integration
- Automated test generation
- Performance benchmarking
- Budget tracking across sessions
- Team cost analytics

## Tips for Best Results

1. **Don't filter your confusion** - Tell the agent what you don't understand
2. **Share constraints** - Mention deadlines, performance targets, security needs
3. **Reference existing work** - Link to GitHub issues, PRs, or docs
4. **Explain failed approaches** - "We tried X, didn't work because Y"
5. **Be specific about users** - "On-call engineers" vs "users"

## Hooks & Automation

The plugin uses Claude Code hooks for always-on orchestration:

### SessionStart Hook
- Initializes orchestrator state
- Checks if always-on mode is active
- Creates state directory structure

### UserPromptSubmit Hook
- Quality gate enforcement (block execution if score <85)
- Automatic orchestration triggering
- Bypass detection (!raw, commands)
- Session state tracking

### Hook Configuration
```json
{
  "hooks": {
    "SessionStart": "hooks/init-session.py",
    "UserPromptSubmit": "hooks/gate.py"
  }
}
```

See `hooks/hooks.md` for technical details.

## Cost Savings

### Why This Saves Money

Traditional approach:
- User: "The login isn't working" (vague)
- Opus clarifies: "Can you explain?" (-$0.125)
- User: "Users get logged out"
- Opus: "After how long?" (-$0.125)
- [repeat 3-4 times]
- Finally implements solution (-$0.500)
- Total: **~$0.70**

Orchestrator approach:
- Haiku questions: "What's happening?" (-$0.05)
- Haiku refines prompt: Score → 90/100 (-$0.03)
- Sonnet executes clear prompt (-$0.18)
- Total: **~$0.26**
- **Savings: $0.44 (63% reduction)**

At scale (100 tasks/month):
- Traditional: ~$70/month
- Orchestrator: ~$26/month
- **Annual savings: ~$528**

## License

MIT

## Support

For issues or feature requests related to the orchestrator plugin, open an issue in the plugin-marketplace repository.
