# Plugin Improver - Developer Guide

This guide explains the architecture, design, and development of the Plugin Improver plugin.

## Project Overview

**Plugin Improver** is a meta-plugin that evaluates and improves other plugins through systematic assessment and concrete recommendations. It uses multi-agent specialization to provide comprehensive quality feedback aligned with Anthropic best practices.

### Key Characteristics
- **Meta-Plugin**: Analyzes and improves OTHER plugins (not an end-user plugin)
- **Multi-Agent**: Specialized agents for different evaluation dimensions
- **Evidence-Based**: Every recommendation includes examples and rationale
- **Ralph Loop Ready**: Integrates with continuous improvement workflows
- **Standards Reference**: Enforces Anthropic plugin conventions

## Architecture

### Component Organization

```
.claude-plugin/
├── plugin.json                    # Manifest with all components

commands/
├── improve-plugin.md              # Main entry point for plugin evaluation

agents/                            # Specialized evaluation agents
├── improver-coordinator-agent.md  # Orchestrates workflow
├── best-practices-evaluator-agent.md  # Standards & structure
├── quality-analyzer-agent.md      # Code quality & architecture
└── prompt-optimizer-agent.md      # Clarity & specificity

skills/                            # Reusable knowledge
├── best-practices-reference.md    # Standards checklist
├── prompt-enhancement.md          # Improvement techniques
└── architecture-patterns.md       # Design pattern guidance
```

### Data Flow

```
User: /improver:improve-plugin [plugin-name]
  ↓
improve-plugin command
  ├─ Loads plugin structure and files
  ├─ Invokes improver-coordinator agent
  │  ├─ Launches best-practices-evaluator (parallel)
  │  ├─ Launches quality-analyzer (parallel)
  │  ├─ Launches prompt-optimizer (parallel)
  │  └─ Synthesizes results
  └─ Generates improvement report
```

## Component Details

### Command: improve-plugin

**Purpose**: Entry point for plugin evaluation workflow

**Workflow**:
1. Accepts plugin name as argument
2. Invokes improver-coordinator agent
3. Receives evaluation results
4. Generates formatted report
5. Provides implementation guidance

**Input**: Plugin name (e.g., "planner", "prompt-orchestrator")
**Output**: Comprehensive evaluation report with recommendations

### Agent: improver-coordinator

**Purpose**: Orchestrates multi-agent evaluation and synthesizes results

**Responsibilities**:
1. Load and map plugin structure
2. Route specialized evaluation tasks to appropriate agents
3. Collect evaluation results
4. Calculate overall quality score
5. Prioritize findings by severity
6. Generate comprehensive report

**Process**:
1. Discover plugin components
2. Launch parallel evaluations
3. Collect dimension scores
4. Synthesize into overall score
5. Create prioritized improvement list
6. Format final report

**Output Structure**:
- Summary section with overall score
- Dimension-specific scores
- Critical issues (if any)
- Important improvements (top 5-10)
- Optional enhancements
- Implementation roadmap

### Agent: best-practices-evaluator

**Purpose**: Assess plugin compliance with Anthropic standards

**Evaluation Dimensions**:
1. **Structure** (20 points) - Directory organization
2. **Manifest** (15 points) - plugin.json validity
3. **Commands** (15 points) - YAML & content quality
4. **Agents** (15 points) - Frontmatter & system prompts
5. **Skills** (15 points) - Organization & descriptions
6. **Documentation** (10 points) - README and CLAUDE.md
7. **Naming** (10 points) - Consistency and conventions

**Scoring**: 0-100 scale with detailed breakdown

**Checklist**: Validates all standards from best-practices-reference skill

### Agent: quality-analyzer

**Purpose**: Analyze code quality, architecture, and design patterns

**Evaluation Dimensions**:
1. **Architecture** (25 points) - Component organization
2. **Error Handling** (20 points) - Robustness & validation
3. **Context Efficiency** (15 points) - Token management
4. **Maintainability** (15 points) - Clarity & documentation
5. **Design Patterns** (15 points) - Appropriate use
6. **Performance** (10 points) - Responsiveness & scaling

**Focus Areas**:
- Separation of concerns (command vs. agent vs. skill)
- Error anticipation and handling
- File I/O patterns
- Tool usage efficiency
- Consistent patterns throughout

### Agent: prompt-optimizer

**Purpose**: Evaluate and improve prompt clarity and effectiveness

**Evaluation Dimensions**:
1. **Skill Descriptions** (25 points) - Clarity and triggers
2. **Agent System Prompts** (25 points) - Role and process
3. **Command Guidance** (20 points) - User clarity
4. **Consistency & Tone** (15 points) - Language alignment
5. **Completeness** (15 points) - Accuracy and coverage

**Specific Improvements**:
- Make trigger phrases more specific
- Clarify agent roles and processes
- Define measurable quality standards
- Add before/after examples
- Improve output format clarity

## Skills Design

### Skill: best-practices-reference

**Purpose**: Definitive reference for plugin standards

**Content**:
- Plugin manifest requirements
- Directory structure standards
- Component-specific YAML frontmatter
- Content quality expectations
- Quality checklist
- Anti-patterns to avoid

**Usage**: Referenced by best-practices-evaluator agent

### Skill: prompt-enhancement

**Purpose**: Techniques for improving prompt clarity

**Core Principles**:
1. Specificity over generality
2. Process over outcome
3. Examples over explanation
4. Measurable standards

**Techniques**:
- Making trigger phrases specific
- Defining clear roles
- Breaking processes into steps
- Specifying output structures
- Adding edge case handling

**Usage**: Referenced by prompt-optimizer agent

### Skill: architecture-patterns

**Purpose**: Design patterns and structural guidance

**Content**:
- Separation of concerns
- Component responsibilities
- Command workflow patterns
- Agent specialization patterns
- Skill organization patterns
- Hook patterns
- Anti-patterns to avoid

**Usage**: Referenced by quality-analyzer agent

## Scoring System

### Overall Score Calculation

```
Overall = (
  best_practices * 0.30 +
  quality * 0.35 +
  prompts * 0.35
) * 100
```

### Interpretation

| Score | Status | Meaning |
|-------|--------|---------|
| 0-59 | Critical | Issues block usage |
| 60-74 | Important | Improvements recommended |
| 75-89 | Good | Production-ready, optimize |
| 90-100 | Excellent | High quality, maintain |

### Detailed Scoring

Each agent generates detailed scoring:
- Breakdown by dimension
- Evidence for each score
- Specific issues identified
- Recommendations for improvement

## Development Workflow

### Adding New Evaluation Criteria

1. **Update Agent**:
   - Add new dimension to agent system prompt
   - Define scoring rubric
   - Add checklist items

2. **Update Skill** (if needed):
   - Add reference material if new domain
   - Update best-practices-reference skill

3. **Test**:
   - Run improvement on sample plugin
   - Verify new criteria are evaluated
   - Adjust scoring weights if needed

### Improving Evaluation Accuracy

1. **Refine Agent Prompts**:
   - Make evaluation process more specific
   - Add examples of good/bad implementations
   - Clarify scoring thresholds

2. **Update Skills**:
   - Add new best practices as they emerge
   - Provide more concrete examples
   - Improve guidance clarity

3. **Gather Feedback**:
   - Use Ralph Loop to test iteratively
   - Refine based on actual plugin improvements
   - Track effectiveness of recommendations

## Ralph Loop Integration

### How It Works

1. **Initial Evaluation**: Comprehensive assessment of all plugins
2. **Suggestion Generation**: Concrete improvements with examples
3. **Implementation**: Apply improvements to plugins
4. **Re-evaluation**: Measure quality improvement
5. **Iteration**: Continue cycle until satisfied

### Tracking Progress

Store evaluation results in `.improvements/`:
```
.improvements/
├── plugin-name-evaluation.json  # Structured evaluation data
├── scores.json                  # Score history tracking
└── improvements-applied.log     # What was changed
```

### Building the Loop

```bash
/ralph-loop:ralph-loop "iteratively improve all plugins"
```

The loop will:
1. Evaluate each plugin
2. Suggest improvements
3. Implement changes
4. Re-evaluate
5. Track metrics
6. Continue until quality targets met

## Testing the Plugin

### Manual Testing

```bash
# Test on a sample plugin
/improver:improve-plugin planner

# Verify all agents are invoked
# Check that evaluation produces scores
# Confirm improvement suggestions are specific
# Validate before/after examples are correct
```

### With Ralph Loop

```bash
/ralph-loop:ralph-loop "improve the planner plugin" --max-iterations 3

# Iteration 1: Initial evaluation
# Iteration 2: Apply improvements
# Iteration 3: Verify improvement
```

### Quality Checks

- [ ] Evaluation reports are detailed and specific
- [ ] Improvement suggestions have before/after examples
- [ ] Scores align with actual plugin quality
- [ ] Agents coordinate without duplication
- [ ] Ralph Loop tracks progress correctly

## Key Design Decisions

### Why Multi-Agent?

**Specialization enables**:
- Deep expertise per evaluation domain
- Parallel evaluation for efficiency
- Focused scoring per dimension
- Easier to improve individual agents

**Trade-off**: More complexity vs. better results

### Why Evidence-Based?

**Concrete examples**:
- Show exactly what to fix
- Explain why it matters
- Provide copy-paste solutions
- Build trust in recommendations

### Why Ralph Loop?

**Continuous improvement enables**:
- Iterative enhancement without manual intervention
- Accumulation of improvements over time
- Feedback loops for learning
- Measurable progress tracking

## Performance Considerations

### File I/O
- Evaluators read plugin files once
- Results cached during evaluation
- No redundant file access

### Context Efficiency
- Agent system prompts stay <2000 tokens
- Skill references rather than duplicating
- Focused analysis per agent

### Scalability
- Agents can handle plugins of any size
- Scoring algorithm is O(n) where n = components
- Parallel evaluation of agents

## Security & Safety

- ✅ No modification of plugins (evaluation only)
- ✅ No external API calls required
- ✅ No credential exposure
- ✅ Safe to run on untrusted plugins
- ✅ All recommendations are suggestions (user decides)

## Future Enhancements

### Phase 2: Automated Improvement
- Automatically apply non-controversial fixes
- Track changes in git
- Generate improvement PRs

### Phase 3: Cross-Plugin Analysis
- Identify inconsistencies across plugins
- Suggest shared patterns
- Analyze plugin dependencies

### Phase 4: Community Benchmarks
- Compare against community plugins
- Identify common patterns
- Suggest advanced optimizations

### Phase 5: Custom Rules
- Allow users to define custom evaluation criteria
- Support domain-specific standards
- Extensible evaluation framework

## Integration Points

### With marketplace-manager
- Reuse validation patterns
- Share quality assessment criteria
- Integrate with marketplace distribution

### With subagent-creator
- Reference agent design guidance
- Use best practices for agents
- Suggest improvements based on patterns

### With prompt-orchestrator
- Use multi-tier approach (Haiku for assessment)
- Leverage prompt quality analysis
- Share cost optimization patterns

## Documentation

- **README.md** - User guide and quick start
- **CLAUDE.md** - This developer guide
- **plan.md** - Architecture and design document
- **Skills** - Detailed references for each domain

## Support & Debugging

### Plugin doesn't load
- Check plugin.json is valid JSON
- Verify all component files exist
- Ensure YAML frontmatter is correct

### Evaluation seems inaccurate
- Review agent system prompts
- Check scoring rubrics
- Verify skill references are correct
- Update best-practices-reference if standards changed

### Ralph Loop not completing
- Check max-iterations is set
- Review .improvements/ files for progress
- Ensure plugins are being modified
- Check that improvements are being applied

## Contributing

Improvements to the evaluator are welcome!

1. Test changes with `/improver:improve-plugin planner`
2. Verify improvements make sense
3. Update documentation as needed
4. Use Ralph Loop for iterative refinement

---

**Last Updated**: 2026-01-28
**Version**: 0.1.0
**Status**: Alpha - Ready for testing and feedback
