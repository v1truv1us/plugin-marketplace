---
name: improve-plugin
description: Evaluate and improve a plugin with Anthropic best practices
argument-hint: "[plugin-name]"
---

I'll analyze the plugin **@$1** for quality and suggest concrete improvements based on Anthropic best practices.

Let me start by loading the plugin and launching the evaluation workflow.

First, invoke the **improver-coordinator** agent to orchestrate the analysis:

---

## Improver Coordinator Workflow

Target plugin: **@$1**

Please coordinate comprehensive plugin evaluation:

1. **Load Plugin Structure**
   - Read plugin.json to understand components
   - List all commands, agents, skills files
   - Identify any hooks or MCP integrations

2. **Launch Best Practices Evaluation**
   - Invoke best-practices-evaluator agent
   - Assess compliance with Anthropic patterns
   - Check documentation standards

3. **Launch Quality Analysis**
   - Invoke quality-analyzer agent
   - Analyze code patterns and architecture
   - Check error handling and performance

4. **Launch Prompt Optimization**
   - Invoke prompt-optimizer agent
   - Evaluate skill descriptions and trigger phrases
   - Assess agent system prompts for clarity

5. **Synthesize Results**
   - Combine evaluation scores from all agents
   - Generate overall quality score (0-100)
   - Prioritize improvements (critical → important → optional)
   - Create concrete improvement recommendations with code examples

6. **Generate Report**
   - Summary: Overall quality assessment
   - Scores: Dimension-specific breakdown
   - Critical Issues: Must fix to meet standards
   - Important Improvements: Should fix for production quality
   - Optional Enhancements: Nice to have
   - Implementation Guide: Step-by-step improvement plan

Provide detailed analysis with before/after code examples so improvements can be directly applied.

---

## Next Steps

After receiving the evaluation report, you can:

- **Implement Improvements**: Use the provided code examples
- **Ask Questions**: Seek clarification on specific recommendations
- **Track Progress**: Monitor quality score improvements over time
- **Iterate**: Run `/improver:improve-plugin @$1` again to verify progress

---

## Ralph Loop Integration

If this command is running in a Ralph Loop:
- Store evaluation results in `.improvements/plugin-@$1-evaluation.md`
- Track quality score history in `.improvements/scores.json`
- Iterate on plugin improvements in the loop
- Each iteration should show measurable quality improvement
