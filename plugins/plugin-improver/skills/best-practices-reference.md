---
name: best-practices-reference
description: Anthropic plugin development standards and conventions
trigger-phrases:
  - "what are plugin standards"
  - "best practices for plugins"
  - "plugin development guidelines"
---

# Plugin Best Practices - Quick Reference

Essential standards for Claude Code plugin development.

## Core Standards at a Glance

**Plugin Manifest (plugin.json)**
- Required: name (kebab-case), version (semver), description (50-150 chars), author
- Recommended: license, keywords, homepage, repository
- Must reference all components (commands, agents, skills, hooks)

**Directory Structure**
```
my-plugin/
├── plugin.json
├── README.md (user guide)
├── CLAUDE.md (developer guide)
├── commands/     (auto-discovered)
├── agents/       (auto-discovered)
├── skills/       (auto-discovered)
└── hooks/        (if used)
```

**Naming Conventions**
- Plugin, commands, agents, skills: kebab-case only
- No camelCase, UPPERCASE, or underscores
- Match file names to YAML frontmatter `name` field

## Component Frontmatter

| Component | Required Fields | Optional |
|-----------|-----------------|----------|
| **Command** | name, description | argument-hint, allowed-tools |
| **Agent** | name, description, when-to-invoke | tools, color, model |
| **Skill** | name, description, trigger-phrases | version, tags |

## Content Quality Basics

**Commands**: Clear workflow with 3-7 numbered phases
**Agents**: Specific role, 2-5 concrete responsibilities, step-by-step process, measurable quality standards
**Skills**: Core concept (100-150 words), trigger phrases, key principles, examples

**Documentation**: README (user-facing), CLAUDE.md (architecture), both present and helpful

## Quality Checklist

- [ ] plugin.json is valid JSON with all required fields
- [ ] All referenced files exist at correct paths
- [ ] All YAML frontmatter is valid
- [ ] No camelCase or UPPERCASE in names
- [ ] Commands have clear workflows
- [ ] Agents have specific roles (not generic)
- [ ] Skills have 3-6 natural trigger phrases
- [ ] README explains how to use
- [ ] CLAUDE.md explains architecture

## Anti-Patterns to Avoid

❌ Generic agent roles ("helpful assistant")
❌ Vague skill trigger phrases ("help", "improve")
❌ Unclear responsibilities (no process steps)
❌ Hardcoded credentials in code
❌ Mixing concerns (agent logic in commands)

## For Detailed Reference

See `references/` for:
- **manifest-guide.md** - Complete plugin.json documentation
- **component-standards.md** - Detailed standards per component
- **quality-checklist.md** - Comprehensive validation checklist
- **validation-rubric.md** - Scoring methodology
- **anti-patterns.md** - Common mistakes and fixes
