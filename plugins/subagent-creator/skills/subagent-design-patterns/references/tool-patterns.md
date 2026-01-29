# Tool Access Patterns for Subagents

Understanding which tools to grant a subagent is critical for both security and focus. This document outlines common patterns.

## The Principle: Least Privilege

Grant each subagent only the tools it needs. This:
- Improves security by limiting what the agent can do
- Focuses behavior on the intended task
- Prevents accidental misuse
- Makes permissions easier to reason about

## Standard Tool Sets

### Pattern 1: Read-Only Analysis

**Tools:** `["Read", "Grep", "Glob"]`

**Use for:**
- Code reviewers
- Analyzers and researchers
- Log analyzers
- Documentation reviewers
- Security analyzers

**Capabilities:**
- Read any file
- Search content
- Find files by pattern
- Cannot: modify, write, or execute

**Example system prompt snippet:**
```
You are a code reviewer. Analyze the code for quality, security, and best practices.
You have read-only access. You cannot modify files.
Provide specific, actionable feedback with examples of issues and how to fix them.
```

**When to use:**
- Anything review-oriented
- Analysis that produces recommendations
- Agents that should never modify code

### Pattern 2: Code Generation

**Tools:** `["Read", "Write", "Grep", "Bash"]`

**Use for:**
- Code generators
- Scaffolders
- Documentation generators
- Config file generators
- Test generators

**Capabilities:**
- Read existing files (understand patterns)
- Write new files
- Search for patterns
- Run commands to validate/test
- Cannot: edit existing files

**Example use case:**
```
User: "Generate TypeScript types for our API responses"
Agent: Reads existing API code, understands patterns, writes new type definitions,
       runs tsc to validate
```

**When to use:**
- Creating new artifacts
- Scaffolding boilerplate
- Generating from templates
- Output should be new files

### Pattern 3: Code Modification

**Tools:** `["Read", "Edit", "Grep", "Bash"]`

**Use for:**
- Bug fixers
- Refactorers
- Optimizers
- Auto-formatters
- Upgraders/migrators

**Capabilities:**
- Read existing files
- Edit existing files
- Search patterns
- Run tests/validation
- Cannot: write arbitrary new files

**Example use case:**
```
User: "Fix these TypeScript errors"
Agent: Reads files, identifies errors, edits files to fix them,
       runs tsc to verify fixes
```

**When to use:**
- Modifying existing code
- Bug fixes
- Refactoring
- Improvements to existing files

### Pattern 4: Full Access

**Tools:** Omit field (inherits all) or `["*"]`

**Use for:**
- Complex multi-step workflows
- Rarely used, specific complex tasks
- When you've carefully considered and determined other patterns don't fit

**Capabilities:**
- Everything

**When to use:**
- Genuinely complex workflows requiring multiple tool types
- After careful consideration (default to restricted patterns)

## Combining Tools for Specific Workflows

### Reviewer + Fixer Pattern

**For:** Code quality - review findings, then optionally fix

**Tools:** `["Read", "Edit", "Grep", "Bash"]`

**Workflow:**
1. Read and review files
2. Identify issues
3. Edit files to fix issues
4. Run tests to verify

**Example:**
```
User: "Review and fix code style issues"
Agent: Reads files, identifies style problems, edits to fix,
       runs linter to confirm
```

### Database Query Pattern

**For:** Database analysis and optimization

**Tools:** `["Read", "Bash", "Grep"]`

**Workflow:**
1. Read query files
2. Run queries for analysis
3. Explain findings
4. Suggest optimizations (not execute)

**Example:**
```
User: "Analyze slow queries"
Agent: Reads query files, executes test queries via Bash,
       analyzes results, provides optimization recommendations
```

### API Documentation Pattern

**For:** API docs generation

**Tools:** `["Read", "Write", "Grep"]`

**Workflow:**
1. Read source code/types
2. Extract API information
3. Write documentation
4. No execution needed

**Example:**
```
User: "Generate API documentation from types"
Agent: Reads TypeScript types, generates Markdown docs,
       writes to docs directory
```

## Tool Descriptions

### Read
- **What it does:** Read any file in the codebase
- **Security level:** Safe - read-only
- **Include when:** You need the agent to understand existing code

### Write
- **What it does:** Create new files
- **Security level:** Medium - creates new files, cannot modify existing
- **Include when:** Agent generates new artifacts

### Edit
- **What it does:** Modify existing files
- **Security level:** High - modifies existing code
- **Include when:** Agent needs to fix/refactor existing code

### Grep
- **What it does:** Search file contents with regex
- **Security level:** Safe - read-only
- **Include when:** Agent needs to find patterns in code

### Glob
- **What it does:** Find files by name pattern
- **Security level:** Safe - read-only
- **Include when:** Agent needs to discover files

### Bash
- **What it does:** Execute shell commands
- **Security level:** High - can run any command
- **Include when:** Agent needs to run tests, compile, or validate

### AskUserQuestion
- **What it does:** Ask user for input
- **Security level:** Safe - user interaction
- **Include when:** Agent needs clarification
- **Usually included by default**

### TodoWrite
- **What it does:** Create/manage task lists
- **Security level:** Medium
- **Include when:** Agent needs to track complex workflows

## Denying Specific Tools

Use `disallowedTools` to remove inherited tools:

```yaml
tools: ["Read", "Write", "Bash"]
disallowedTools: ["Edit"]
```

This is useful when:
- Inheriting from parent has more access than needed
- Want to restrict without specifying all allowed tools
- Preventing specific dangerous combinations

**Example:**
```
Agent has all tools except Edit (can write new files, cannot modify)
```

## Real-World Examples

### Example 1: Security Code Reviewer

```yaml
tools: ["Read", "Grep", "Glob"]
```

**Why this set:**
- Must read code to review
- Must search for patterns (secrets, vulnerabilities)
- Must find relevant files
- Should NOT modify files (review only)

### Example 2: TypeScript Bug Fixer

```yaml
tools: ["Read", "Edit", "Bash", "Grep"]
```

**Why this set:**
- Must read files to understand types
- Must edit files to fix bugs
- Must run TypeScript compiler to validate
- Must search for related issues

### Example 3: Documentation Generator

```yaml
tools: ["Read", "Write", "Grep"]
```

**Why this set:**
- Must read source files for content
- Must write documentation
- Must search for patterns and examples
- No Edit (new docs only)
- No Bash (no execution needed)

### Example 4: Database Performance Analyzer

```yaml
tools: ["Read", "Bash", "Grep"]
disallowedTools: ["Write", "Edit"]
```

**Why this set:**
- Must read query files
- Must run queries for analysis
- Must search query patterns
- Should NOT modify queries (analysis only)
- Should NOT write files (recommendations only)

## Permission Modes Combined with Tools

Tool access (`tools` field) controls what the agent CAN do.
Permission mode (`permissionMode` field) controls how those tools behave.

**Example:**

```yaml
tools: ["Read", "Edit", "Bash"]
permissionMode: acceptEdits
```

The agent:
- Can read, edit, and run bash
- Auto-accepts file edits (user doesn't approve each one)
- Still respects safety rules

## Anti-Patterns

### ❌ Too Many Tools

```yaml
# All tools - when specific set would be better
tools: ["Read", "Write", "Edit", "Bash", "Grep", "Glob"]
```

**Problem:** Unfocused, more permission than needed

**Solution:** Use minimal set matching the pattern

### ❌ Inconsistent with Role

```yaml
# Reviewer with Write/Edit
tools: ["Read", "Write", "Edit"]
```

**Problem:** Reviewer roles shouldn't modify

**Solution:** For reviewers use `["Read", "Grep", "Glob"]`

### ❌ Forgetting Bash for Validation

```yaml
# Generator without Bash
tools: ["Read", "Write"]
```

**Problem:** Can't validate generated code

**Solution:** Add Bash for testing: `["Read", "Write", "Bash"]`

## Decision Tree

```
Does agent need to understand existing code?
├─ Yes: Include Read
├─ No: Skip Read

Does agent need to create new files?
├─ Yes: Include Write
├─ No: Skip Write

Does agent need to modify existing files?
├─ Yes: Include Edit
├─ No: Skip Edit

Does agent need to search for patterns?
├─ Yes: Include Grep
├─ No: Skip Grep

Does agent need to run commands/tests?
├─ Yes: Include Bash
├─ No: Skip Bash
```

## Testing Your Tool Set

Before finalizing, test:

1. **Can the agent do its job?** Run realistic task
2. **Can it validate its work?** Can it test/verify output?
3. **Are there unused tools?** Remove them
4. **Could it cause problems?** Test edge cases

Example test:
```
Task: "Generate test templates"
Needed: Read (understand patterns), Write (create tests), Bash (validate syntax)
Unnecessary: Edit (we're creating new files)

✅ Correct: ["Read", "Write", "Bash"]
```
