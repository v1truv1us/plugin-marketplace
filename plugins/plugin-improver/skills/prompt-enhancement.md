---
name: prompt-enhancement
description: Techniques for improving clarity, specificity, and effectiveness of prompts
trigger-phrases:
  - "how to improve prompt quality"
  - "enhance system prompts"
  - "improve prompt clarity"
  - "better trigger phrases"
---

# Prompt Enhancement Techniques

Core principles for improving prompt quality.

## Four Core Principles

### 1. Specificity Over Generality
**Problem**: "You are an assistant that helps with planning"
**Solution**: "You are a prioritization specialist using the Eisenhower matrix"
**Why**: Specific role definition lets Claude adopt the correct mental model immediately.

### 2. Process Over Outcome
**Problem**: "Analyze the plugin for quality"
**Solution**: "Analyze by: 1) Reading structure, 2) Reviewing components, 3) Assessing prompts, 4) Scoring dimensions"
**Why**: Explicit processes prevent hallucination and ensure consistent results.

### 3. Examples Over Explanation
**Problem**: "Provide recommendations in a clear format"
**Solution**: Provide example output with actual structure and content
**Why**: Examples make expectations concrete and actionable.

### 4. Measurable Standards
**Problem**: "Quality standards: Be clear and helpful"
**Solution**: "Quality standards: Phrases are 3-6 words; descriptions are 1-2 sentences; processes have 3-7 steps"
**Why**: Measurable standards enable consistent evaluation.

## Five Key Techniques

### Technique 1: Specific Trigger Phrases
Transform generic → specific:
- ❌ "help", "improve", "optimize"
- ✅ "prioritize my tasks", "optimize my day", "organize my workload"

### Technique 2: Role + Domain
**Weak**: "You are an assistant for task prioritization"
**Strong**: "You are a prioritization specialist using the Eisenhower matrix"

### Technique 3: Break Into Steps
**Weak**: "Analyze the code for quality"
**Strong**: "Analyze by: 1) Read & understand purpose, 2) Check error handling, 3) Assess context efficiency, 4) Evaluate maintainability, 5) Compare against patterns, 6) Generate scores, 7) Prioritize issues"

### Technique 4: Specify Output Structure
Provide concrete example of expected output format, not just description.

### Technique 5: Add Edge Cases
Anticipate exceptions and define how to handle them (e.g., "If plugin.json is missing...")

## Quick Evaluation Checklist

**Trigger Phrases**
- [ ] 3-6 words each
- [ ] Natural language (how users would ask)
- [ ] Action-oriented
- [ ] Specific to the skill

**Agent System Prompts**
- [ ] Specific role (not generic "helper")
- [ ] 2-5 concrete responsibilities
- [ ] Step-by-step process defined
- [ ] Measurable quality standards
- [ ] Example output format

**Command Guidance**
- [ ] Purpose stated upfront
- [ ] Phases numbered/clear
- [ ] Time estimate provided
- [ ] Prerequisites listed

## For Deeper Guidance

See `references/` for:
- **prompt-patterns.md** - Full examples of strong prompts
- **before-after-examples.md** - Side-by-side improvements
- **trigger-phrase-guide.md** - Expanding natural language triggers
- **edge-case-patterns.md** - Handling exceptions
