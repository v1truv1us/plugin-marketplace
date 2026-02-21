---
name: problem-discovery-patterns
description: XY problem patterns and discovery techniques for uncovering root causes
---

# Problem Discovery Patterns

Common XY problem patterns and how to uncover root causes.

## XY Problem Indicators

Watch for these solution-focused patterns that may indicate the real problem hasn't been discovered:

1. **"How do I [technical solution]"** without explaining the goal
   - Example: "How do I add a remember me checkbox?"
   - Real problem: Users getting logged out (checkbox may not solve it)

2. **"Add [feature X]"** without user research or justification
   - Example: "Add dark mode"
   - Real problem: Eye strain at night (may need better approach)

3. **"Make [thing] faster/better/bigger"** without success criteria
   - Example: "Make the dashboard faster"
   - Real problem: Specific dashboard is slow for specific users

4. **"Fix [symptom]"** without investigating cause
   - Example: "Users are complaining"
   - Real problem: Need to understand what they're actually complaining about

## The 5 Whys Protocol

When detecting a potential XY problem, apply 5 Whys to dig deeper:

**Example 1: "Add Loading Spinners"**
```
User: "Add loading spinners to show the app is working"
Why? → "Users complain the app feels unresponsive"
Why? → "Operations take 5-8 seconds"
Why? → "We make sequential database calls"
Why? → "Never optimized queries or added caching"
ROOT CAUSE: Need query caching strategy (spinners are symptom relief)
```

**Example 2: "Make the Logout Button Bigger"**
```
User: "Make logout button bigger, users can't find it"
Why? → "It's hidden in hamburger menu"
Why? → "Mobile-first design pattern"
Why? → "That's where traffic is"
Why? → "Persona assumptions were wrong - most users are desktop"
ROOT CAUSE: Navigation pattern doesn't match actual user distribution
```

## Discovery Process Steps

1. **Understand what they asked for** → What problem are they trying to solve?
2. **Detect solution jumping** → Why do they think that's the right solution?
3. **Apply 5 Whys** → Keep asking until you reach a root cause (stop at 3-5)
4. **Challenge assumptions** → What if our assumptions are wrong?
5. **Confirm the real problem** → Summarize and get agreement

## Output Format

When presenting findings:
- **Stated Problem**: What they asked for
- **Root Cause**: What we discovered through questioning
- **Why it matters**: The impact of solving the real problem
- **Recommended Next Step**: Refinement or further investigation
