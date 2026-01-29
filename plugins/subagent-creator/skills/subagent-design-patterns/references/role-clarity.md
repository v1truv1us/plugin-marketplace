# Writing Clear Subagent Roles and Descriptions

## The Description Field: Your Most Important Design Tool

The `description` field in a subagent's frontmatter is the primary mechanism Claude uses to decide whether to delegate a task. Write clear, specific descriptions with concrete triggering phrases.

## Structure of an Effective Description

```
Use this agent when [specific conditions]. Examples:

<example>
Context: [Scenario description]
user: "[User's request/query]"
assistant: "[How Claude should respond, confirming delegation to subagent]"
<commentary>
[Why this subagent is appropriate for this task]
</commentary>
</example>
```

## Writing Strong Triggers

### Good Trigger Phrases

✅ **Specific and actionable:**
```
"debug TypeScript errors"
"review code for security vulnerabilities"
"analyze SQL query performance"
"generate API documentation"
```

✅ **Domain-specific:**
```
"handle React component refactoring"
"validate Kubernetes manifests"
"optimize MongoDB queries"
"analyze GitHub Actions workflow"
```

✅ **Task-based:**
```
"format and lint code"
"explain an algorithm"
"generate unit tests"
```

### Poor Trigger Phrases

❌ **Too vague:**
```
"help with stuff"
"provide assistance"
"answer questions"
"do something"
```

❌ **Too generic:**
```
"work with code"
"handle issues"
"process data"
```

## Description Examples by Pattern

### Reviewer Pattern

```
Use this agent when reviewing code for quality, security, and best practices.
Proactively use after code changes. Examples:

<example>
Context: User just implemented a new authentication system
user: "Review the authentication code for security issues"
assistant: "I'll use the code-reviewer agent to analyze your authentication implementation for security vulnerabilities and best practices"
<commentary>
The code-reviewer should proactively check for security issues, and this request explicitly asks for review
</commentary>
</example>

<example>
Context: User modified API error handling
user: "Check these error handlers for consistency with our patterns"
assistant: "I'll have the code-reviewer analyze your error handling for consistency and adherence to established patterns"
<commentary>
Code review for consistency is a core reviewer responsibility
</commentary>
</example>
```

### Analyzer Pattern

```
Use this agent when analyzing logs, data, or system output to extract insights.
Use proactively when processing verbose output. Examples:

<example>
Context: User has test failures they want to understand
user: "Analyze these test failures and tell me what's actually broken"
assistant: "I'll use the test-analyzer agent to parse failures and identify root causes"
<commentary>
Extracting patterns and insights from verbose test output is analyzer work
</commentary>
</example>

<example>
Context: Database is slow, user has query logs
user: "Generate a performance report from these logs"
assistant: "I'll use the performance-analyzer to process the logs and generate insights"
<commentary>
Synthesis of data into actionable insights is core analyzer responsibility
</commentary>
</example>
```

### Generator Pattern

```
Use this agent when generating new code, documentation, or configurations.
Examples:

<example>
Context: User needs a new API endpoint
user: "Generate TypeScript types for our user API endpoint"
assistant: "I'll use the type-generator to create well-structured types following our conventions"
<commentary>
Generating new code artifacts is the generator's responsibility
</commentary>
</example>

<example>
Context: User wants test boilerplate
user: "Generate unit test templates for this service"
assistant: "I'll use the test-generator to create comprehensive test templates"
<commentary>
Generating new testing code is appropriate for the generator
</commentary>
</example>
```

### Fixer Pattern

```
Use this agent when debugging issues, fixing bugs, or troubleshooting problems.
Use proactively when encountering errors. Examples:

<example>
Context: TypeScript compilation error appears
user: "Fix these TypeScript errors"
assistant: "I'll use the type-fixer agent to diagnose and correct the type issues"
<commentary>
Debugging and fixing type errors is the fixer's expertise
</commentary>
</example>

<example>
Context: Tests are failing unexpectedly
user: "Debug why the tests are failing and fix them"
assistant: "I'll use the debugger agent to identify and fix the root causes"
<commentary>
Diagnosing and fixing issues is core fixer responsibility
</commentary>
</example>
```

## Boundary Clarification

Use your description to clearly define what is and isn't the agent's responsibility:

```
Use this agent when [core responsibility]. Do NOT use for [explicitly out of scope].

Examples:
<example>...</example>
```

**Example:**

```
Use this agent when optimizing database queries and analyzing query performance.
Do NOT use for schema design or data modeling. Examples:

<example>
Context: Query is slow
user: "Optimize this SELECT query"
assistant: "I'll use the query-optimizer to analyze and improve performance"
<commentary>
Query optimization is in scope
</commentary>
</example>

<example>
Context: User asks about schema
user: "Should we add a new table?"
assistant: "That's a schema design question - I'll handle that in the main conversation"
<commentary>
Schema design is out of scope for the optimizer; it requires broader architectural consideration
</commentary>
</example>
```

## Real-World Example: Complete Description

```yaml
description: |
  Database performance specialist. Use this agent when analyzing slow queries,
  explaining execution plans, or suggesting query optimizations. Do NOT use for
  schema design or data modeling. Examples:

  <example>
  Context: Production query taking 30+ seconds
  user: "Analyze why this query is slow and suggest optimizations"
  assistant: "I'll use the query-optimizer agent to analyze the execution plan and provide specific optimization strategies"
  <commentary>
  Query performance analysis is the optimizer's core responsibility
  </commentary>
  </example>

  <example>
  Context: User comparing two approaches to same query
  user: "Which query approach is more efficient?"
  assistant: "I'll use the query-optimizer to benchmark and explain the performance characteristics of each"
  <commentary>
  Comparing query performance requires specialized optimization expertise
  </commentary>
  </example>

  <example>
  Context: User asks about adding a new table
  user: "Should we add a denormalized table for performance?"
  assistant: "That's a schema design decision requiring broader context. Let me discuss trade-offs here."
  <commentary>
  Schema design is outside the optimizer's scope - it needs architectural consideration beyond query optimization
  </commentary>
  </example>
```

## Testing Your Description

After writing your description:

1. **Share with team** - Does the description make it clear when to use the agent?
2. **Ask example questions** - Would these trigger the agent?
   - If yes, good
   - If no, your description needs refinement
3. **Check boundaries** - Are the "do NOT use for" cases clear?
4. **Verify examples** - Are they realistic and representative?

## Common Description Mistakes

### ❌ Mistake 1: No Examples

```yaml
description: Use this agent when reviewing code
```

**Problem:** No examples, unclear triggers

**Fix:** Add 2-3 examples with context

### ❌ Mistake 2: Too Generic

```yaml
description: Use this agent for general programming help
```

**Problem:** Overlaps with main conversation, unclear boundaries

**Fix:** Be specific: "Use for TypeScript type system issues", not "general programming"

### ❌ Mistake 3: Contradictory Triggers

```yaml
description: Use for code review. Use for writing new code.
```

**Problem:** Conflicting responsibilities

**Fix:** Choose one primary responsibility, create separate agent if needed

### ❌ Mistake 4: Missing Boundaries

```yaml
description: Use for API work
```

**Problem:** Too broad - API designing? API testing? API documentation?

**Fix:** Specify: "Use for testing REST APIs" or "Use for generating API types"

## Proactive vs Reactive Triggers

Include both types in your description:

**Reactive:** User explicitly requests the agent
```
user: "Use the code-reviewer to check this"
```

**Proactive:** Claude decides agent is appropriate without explicit request
```
user: "I just finished this security module, check it"
assistant: "I'll proactively use the code-reviewer agent to check for security issues"
```

Include proactive triggers when:
- The task naturally follows something else
- The agent adds obvious value
- Users would expect it

Use the phrase "Use proactively" in descriptions for common proactive triggers.
