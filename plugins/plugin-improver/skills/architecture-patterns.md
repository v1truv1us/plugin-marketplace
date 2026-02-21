---
name: architecture-patterns
description: Design patterns and architecture best practices for Claude Code plugins
trigger-phrases:
  - "how to structure a plugin"
  - "plugin architecture patterns"
  - "when to use agents vs skills"
  - "plugin design best practices"
---

# Plugin Architecture Patterns

Core principles for well-organized, maintainable plugins.

## Separation of Concerns

Each component type has a specific, non-overlapping purpose:

| Component | Purpose | When to Use |
|-----------|---------|------------|
| **Command** | User-facing workflow | Multi-step processes, guide user through phases |
| **Agent** | Complex reasoning | Deep analysis, multiple decisions, specialized expertise |
| **Skill** | Reusable knowledge | Share knowledge across commands/agents, explain concepts |
| **Hook** | Event automation | React to Claude Code events, background tasks |

**Anti-Patterns**:
- ❌ Command that duplicates agent logic
- ❌ Agent that contains only skill knowledge
- ❌ Skill referenced by only one component

**Patterns**:
- ✅ Command orchestrates workflow, invokes agents
- ✅ Agent has specialized expertise
- ✅ Skill is reused across multiple components

## Component Design Patterns

### Command Pattern: Phased Workflow
```
Introduction → Phase 1 → Confirm → Phase 2 → Finalize → Next Steps
```
- Introduction sets context
- Each phase has clear purpose
- Confirmation before continuing
- Next steps reference related commands

### Agent Pattern: Specialization
```
Specific role → Clear responsibilities → Analysis process → Quality standards → Output format
```
- Specific role (not generic "helper")
- 2-5 concrete responsibilities
- Step-by-step analysis process
- Measurable quality standards
- Example output format

### Skill Pattern: Reusable Knowledge
**Simple Skills** (<150 words): Single file with core concept
**Complex Skills** (>150 words): SKILL.md + references/ subdirectory

## Architecture Decision Framework

### Decision 1: Command or Agent?

**Use Command When**:
- Multi-phase user workflow
- Sequential steps needed
- Confirmation/correction expected
- Orchestrating multiple capabilities

**Use Agent When**:
- Complex reasoning required
- Multiple decision points
- Specialized expertise needed
- Can operate independently

### Decision 2: Skill or Agent?

**Use Skill When**:
- Reusable knowledge across components
- Reference material or framework
- "How to" guidance
- <150 words for core explanation

**Use Agent When**:
- Active decision-making
- Complex analysis required
- Multiple process steps
- Reasoning with trade-offs

### Decision 3: Progressive Disclosure

**Use for complex skills** (>150 words):
```
skill-name/
├── SKILL.md        (30-50 lines - core concept only)
└── references/
    ├── detailed-guide.md
    ├── advanced-patterns.md
    └── template.md
```

## Anti-Patterns to Avoid

❌ **Generic roles**: "You are a helpful assistant"
✅ **Specific roles**: "You are a prioritization specialist"

❌ **Unclear ownership**: Agent and command both doing analysis
✅ **Clear ownership**: Command orchestrates, agent analyzes

❌ **Skill used once**: Skill referenced by only one component
✅ **Reusable skill**: Skill referenced by multiple components

❌ **Mixed concerns**: Command contains full analysis logic
✅ **Separated concerns**: Command delegates to agent

## Evaluation Checklist

**Command Design** ✓
- [ ] Clear phases (intro, process, confirmation, completion)
- [ ] User understands each phase
- [ ] Agents/skills properly invoked
- [ ] Adjustment options available
- [ ] Clear next steps

**Agent Design** ✓
- [ ] Specific, non-generic role
- [ ] 2-5 concrete responsibilities
- [ ] Step-by-step analysis process
- [ ] Measurable quality standards
- [ ] Example output format

**Skill Organization** ✓
- [ ] Reusable across 2+ components
- [ ] Clear trigger phrases (3-6)
- [ ] Core concept explained simply
- [ ] Progressive disclosure if complex
- [ ] References included

**Overall Architecture** ✓
- [ ] No overlapping responsibilities
- [ ] Clear ownership of each component
- [ ] Appropriate delegation
- [ ] Consistent patterns throughout
- [ ] Easy to add new components

## For Detailed Patterns

See `references/` for:
- **command-examples.md** - Complete workflow examples
- **agent-templates.md** - System prompt templates
- **skill-organization.md** - Structure patterns for complex skills
- **decision-tree.md** - Component selection flowchart
