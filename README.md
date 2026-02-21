# Claude Code Plugin Marketplace

A curated collection of Claude Code plugins for productivity, development tools, and prompt optimization.

**Version:** 1.0.0
**Owner:** Anthropic
**License:** MIT
**Repository:** https://github.com/anthropics/claude-code-plugins

## 📦 Available Plugins

### 1. Marketplace Manager
**Version:** 1.0.0 | **Category:** Development
**Author:** Anthropic

Create, validate, and manage plugins in Claude Code plugin marketplaces. Includes scaffolding, validation, and documentation generation.

**Features:**
- Plugin scaffolding with proper directory structure
- Comprehensive validation for plugins and marketplaces
- Marketplace management and documentation generation
- Quality assurance with expert agents
- Best practices guidance

**Installation:**
```bash
# From marketplace location
/add-to-marketplace ./plugins/marketplace-manager --category development
```

**Quick Start:**
```bash
# Create a new plugin
/create-plugin my-plugin "Plugin description"

# Validate plugin quality
/validate-plugin ./plugins/my-plugin

# Add to marketplace
/add-to-marketplace ./plugins/my-plugin --category development

# Validate entire marketplace
/validate-marketplace . --deep

# Generate documentation
/update-docs
```

**Key Commands:**
- `/create-plugin` - Scaffold new plugins
- `/validate-plugin` - Validate plugin structure and quality
- `/add-to-marketplace` - Add plugins to marketplace
- `/validate-marketplace` - Validate marketplace integrity
- `/list-plugins` - List all marketplace plugins
- `/update-docs` - Update marketplace documentation

**Source:** `./plugins/marketplace-manager`

---

### 2. Day/Week Planner
**Version:** 1.0.0 | **Category:** Productivity
**Author:** Planning Team

Interactive day and week planning with Eisenhower matrix prioritization, time-blocking, and Jira/GitHub integration.

**Features:**
- Eisenhower matrix prioritization (Q1/Q2/Q3/Q4)
- Time-blocking scheduler with energy level matching
- Jira and GitHub integration via MCP servers
- File-based persistence (JSON + Markdown)
- Conversational planning workflows
- Weekly planning with daily themes

**Workflows:**
- **plan-day** - 6-phase daily planning (context → tasks → prioritize → schedule → confirm → save)
- **plan-week** - Weekly planning with daily themes and focus areas
- **add-task** - Quick single-task capture
- **show-schedule** - Display today/week/backlog
- **sync-external** - Sync tasks from Jira/GitHub

**Integrations:**
- Jira (requires `JIRA_URL`, `JIRA_EMAIL`, `JIRA_API_TOKEN`)
- GitHub (requires `GITHUB_TOKEN`)
- Local file system persistence

**Data Storage:**
Plans are stored in `.planning/` directory:
- `current-day.md` - Today's hourly schedule
- `current-week.md` - Weekly overview
- `tasks/backlog.json` - All tasks with metadata
- `history/` - Daily plan snapshots

**Configuration:**
```json
{
  "workday": {
    "start": "09:00",
    "end": "17:00",
    "timezone": "America/New_York"
  },
  "deepWorkBlockMinutes": 90,
  "defaultTaskDuration": 30,
  "bufferBetweenTasks": 10
}
```

**Installation:**
```bash
# Copy plugin to .claude-plugins
cp -r ./plugins/planner ~/.claude-plugins/day-week-planner

# Or use marketplace-manager
/add-to-marketplace ./plugins/planner --category productivity
```

**Quick Start:**
```bash
# Plan your day
/planner:plan-day

# View your schedule
/planner:show-schedule today

# Add a quick task
/planner:add-task "Task title"

# View backlog
/planner:show-schedule backlog

# Sync external tasks
/planner:sync-external jira
```

**Source:** `./plugins/planner`

---

### 3. Prompt Orchestrator
**Version:** 2.0.0 | **Category:** Development
**Author:** Engineering Team

Two-tier prompt orchestration: Haiku for discovery/refinement, Sonnet/Opus for execution. Uncovers real problems through Socratic questioning, refines context, and optimizes prompts before expensive model execution. Saves 60-80% on clarification costs.

**Features:**
- Two-tier model orchestration (Haiku discovery → Sonnet/Opus execution)
- Socratic questioning for problem discovery
- XY-problem detection and clarification
- Context gathering and optimization
- Cost estimation before execution
- Intelligent model selection
- Quality assessment with scoring

**Capabilities:**
- Problem discovery and analysis
- XY-problem detection
- Context gathering and refinement
- Prompt optimization
- Cost estimation
- Model selection based on complexity
- Quality assessment (scoring)

**Quality Gates:**
- Minimum score for handoff: 85%
- Maximum refinement iterations: 8
- User confirmation required

**Cost Optimization:**
- Prompt caching enabled
- System prompt caching
- Project context caching
- Cost estimation before execution

**Model Strategy:**
- **Discovery/Refinement:** Haiku (fast, cost-effective)
- **Default Execution:** Sonnet (balanced)
- **Complex Tasks:** Opus (highest quality)

**Installation:**
```bash
# Copy plugin to .claude-plugins
cp -r ./plugins/prompt-orchestrator ~/.claude-plugins/

# Or use marketplace-manager
/add-to-marketplace ./plugins/prompt-orchestrator --category development
```

**Benefits:**
- Reduce token usage by 60-80% through better prompts
- Uncover real user needs before complex execution
- Optimize costs with intelligent model selection
- Improve solution quality with refinement loop

**Source:** `./plugins/prompt-orchestrator`

---

## 🚀 Getting Started

### 1. Install the Marketplace Manager
The marketplace-manager plugin is essential for managing your plugin collection:

```bash
# Already installed in .claude-plugins/marketplace-manager
# Ready to use immediately!
```

### 2. Create Your First Plugin

```bash
/create-plugin my-awesome-plugin "A plugin that does awesome things"
```

### 3. Develop Components
Add commands, agents, and skills to your plugin:

```
.claude-plugins/my-awesome-plugin/
├── commands/
│   └── my-command.md
├── agents/
│   └── my-agent.md
├── skills/
│   └── my-skill.md
└── README.md
```

### 4. Validate Your Plugin

```bash
/validate-plugin ./.claude-plugins/my-awesome-plugin
```

### 5. Add to Marketplace

```bash
/add-to-marketplace ./plugins/my-awesome-plugin --category development
```

### 6. Keep Everything in Sync

```bash
/update-docs
/validate-marketplace . --deep
/list-plugins . --format table
```

## 📋 Valid Plugin Categories

| Category | Description |
|----------|-------------|
| **development** | Development tools, linters, formatters, code analysis |
| **productivity** | Workflow tools, automation, task management |
| **integration** | External service connections, API integrations |
| **testing** | Test frameworks, QA tools, testing utilities |
| **documentation** | Doc generation, API documentation, content tools |
| **security** | Security analysis, vulnerability scanning, compliance |
| **devops** | CI/CD, deployment, infrastructure, monitoring |
| **lsp** | Language server integrations |
| **mcp** | Model context protocol servers |

## 📐 Plugin Structure

Each plugin follows a standard structure:

```
my-plugin/
├── .claude-plugin/
│   ├── plugin.json                # Plugin manifest
│   ├── commands/                  # Slash commands
│   ├── agents/                    # AI agents
│   ├── skills/                    # Ambient skills
│   ├── hooks/                     # Event hooks (optional)
│   ├── scripts/                   # Utility scripts (optional)
│   └── README.md                  # Documentation
├── LICENSE                        # License file
└── CLAUDE.md                      # Development guidance
```

## 📝 marketplace.json Schema

The `marketplace.json` file defines the marketplace registry:

```json
{
  "name": "My Plugin Marketplace",
  "version": "1.0.0",
  "description": "Description of marketplace",
  "owner": {
    "name": "Owner Name",
    "email": "owner@example.com"
  },
  "repository": "https://github.com/example/marketplace",
  "license": "MIT",
  "plugins": [
    {
      "name": "my-plugin",
      "source": "./plugins/my-plugin",
      "description": "Plugin description",
      "version": "1.0.0",
      "author": "Author Name",
      "category": "development",
      "keywords": ["tag1", "tag2"]
    }
  ]
}
```

## 🛠 Plugin Development Workflow

### Create Plugin
```bash
/create-plugin my-tool "What it does"
```

### Validate Quality
```bash
/validate-plugin ./plugins/my-tool
```

### Add to Marketplace
```bash
/add-to-marketplace ./plugins/my-tool --category development
```

### Validate Entire Marketplace
```bash
/validate-marketplace . --deep
```

### Update Documentation
```bash
/update-docs
```

### List All Plugins
```bash
/list-plugins . --format table
```

## 📚 Naming Conventions

### Plugin Names
- **Format:** kebab-case (lowercase with hyphens)
- **Examples:** `my-plugin`, `awesome-tool`, `code-formatter`
- **Invalid:** `MyPlugin`, `my_plugin`, `MY-PLUGIN`

### Versions
- **Format:** Semantic versioning (X.Y.Z)
- **Examples:** `1.0.0`, `2.5.3`, `0.1.0`
- **Invalid:** `1.0`, `v1.0.0`

### Descriptions
- **Length:** 10-200 characters
- **Style:** Clear, descriptive, actionable
- **Format:** Can be single or brief multi-line

## ✅ Quality Standards

### Structure Validation
- ✓ Plugin directory with standard structure
- ✓ Valid `plugin.json` with required fields
- ✓ At least one component (command, agent, skill, or hook)
- ✓ Proper naming conventions (kebab-case)
- ✓ README.md with clear documentation

### Best Practices
- ✓ Descriptive, unique plugin names
- ✓ Focused component functionality
- ✓ Comprehensive documentation
- ✓ Proper error handling
- ✓ Security considerations addressed
- ✓ No hardcoded secrets

### Documentation
- ✓ Clear usage examples
- ✓ Documented arguments and options
- ✓ Troubleshooting section
- ✓ Installation instructions
- ✓ Contributing guidelines

## 🔍 Validation Commands

### Validate Single Plugin
```bash
/validate-plugin ./plugins/my-plugin
```

**Output Levels:**
- **✓ VALID** - Ready for marketplace
- **⚠ VALID_WITH_WARNINGS** - Valid but has improvements needed
- **✗ INVALID** - Has errors to fix

### Validate Marketplace
```bash
/validate-marketplace . --deep
```

**Checks:**
- marketplace.json schema
- All plugin entries
- Source path existence
- Duplicate detection
- Documentation consistency
- Local plugin structure (with --deep)

## 📖 Marketplace Documentation

### Update Marketplace README
```bash
/update-docs
```

**Generates:**
- Marketplace header with metadata
- Complete plugin table
- Per-plugin detail sections
- Installation instructions
- Contributing guidelines
- Version information

The generated README automatically stays in sync with `marketplace.json`.

## 🔒 Security Checklist

- ✅ Credentials stored in environment variables (never hardcoded)
- ✅ File permissions using `.planning/` or similar (user-writable)
- ✅ Input validation at system boundaries
- ✅ External APIs disabled by default (MCP servers)
- ✅ Code execution through explicit argument passing

## 🐛 Troubleshooting

### Plugin validation fails
- Check naming conventions (kebab-case required)
- Verify `plugin.json` has all required fields
- Ensure at least one component exists
- Run with `/validate-plugin --strict` for detailed feedback

### Marketplace validation fails
- Check `marketplace.json` is valid JSON
- Verify all plugin sources exist and are readable
- Check for duplicate plugin names
- Ensure owner information is complete

### Documentation out of sync
- Run `/update-docs` after making changes
- Verify all plugins are listed in `marketplace.json`
- Check version numbers match between marketplace.json and plugin.json
- Test all links and references

### Source paths not found
- Verify paths are relative and correct
- Check path separators (/ not \)
- Ensure plugin directories exist
- Use absolute paths if relative paths fail

## 📦 Installing Plugins

### From This Marketplace
```bash
# Copy plugin from marketplace to your .claude-plugins
cp -r ./plugins/my-plugin ~/.claude-plugins/my-plugin
```

### From Remote Repository
```bash
# Clone directly into .claude-plugins
cd ~/.claude-plugins
git clone https://github.com/author/my-plugin
```

### Using Marketplace Manager
```bash
# Add existing plugin to marketplace
/add-to-marketplace ./plugins/my-plugin --category development

# Create new plugin from template
/create-plugin new-plugin "Plugin description"
```

## 🤝 Contributing

To contribute a plugin to this marketplace:

1. **Create and test your plugin**
   ```bash
   /create-plugin my-plugin "My plugin description"
   ```

2. **Develop your components**
   - Add commands, agents, and/or skills
   - Write comprehensive documentation
   - Follow naming conventions

3. **Validate your plugin**
   ```bash
   /validate-plugin ./.claude-plugins/my-plugin
   ```

4. **Add to marketplace**
   ```bash
   /add-to-marketplace ./plugins/my-plugin --category development
   ```

5. **Validate the complete marketplace**
   ```bash
   /validate-marketplace . --deep
   ```

6. **Submit PR with changes**
   - Include `marketplace.json` updates
   - Include generated documentation updates
   - Include your plugin source code
   - Add any new contributing guidelines

## 🌙 OpenCode Compound Workflow

Automated nightly AI agent loop: learns from your work, updates documentation, and ships features while you sleep.

**Status:** ✅ Ready to install and run

Based on Ryan Carson's compound engineering pattern, adapted for OpenCode harness with integrated Discord notifications.

### What It Does

Every night, two jobs run automatically:

- **10:30 PM** - Compound Review: Review 24-hour work, extract learnings, update CLAUDE.md
- **11:00 PM** - Auto-Compound: Implement next priority, create PR, send Discord notification

After one week, your agent becomes specialized in your codebase.

### Quick Start (5 Minutes)

```bash
# 1. Create config directory
mkdir -p ~/.config/opencode-compound

# 2. Copy environment template
cp opencode-workflow/environment.sample \
   ~/.config/opencode-compound/environment.conf
# Edit with Discord webhook URL and GitHub token

# 3. Secure it
chmod 600 ~/.config/opencode-compound/environment.conf

# 4. Install systemd services
mkdir -p ~/.config/systemd/user
cp .systemd/opencode-*.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable opencode-*.service

# 5. Test manually
./scripts/opencode-compound-review.sh
./scripts/opencode-auto-compound.sh

# 6. Verify scheduling
systemctl --user list-timers | grep opencode
```

### Documentation

- **START_HERE.md** - Entry point with three setup paths (5 min, 45 min, 60 min)
- **OPENCODE_QUICK_START.md** - 5-minute setup guide
- **OPENCODE_README.md** - Main overview and reference
- **OPENCODE_WORKFLOW_SETUP.md** - Complete technical documentation
- **OPENCODE_WORKFLOW_SUMMARY.md** - What was built and how it works
- **WORKFLOW_VERIFICATION.md** - Verification checklist for quality assurance
- **ryan-carson-article-x.md** - Original concept and article

### Files

```
scripts/
├── opencode-compound-review.sh     # Review & extract learnings (10:30 PM)
└── opencode-auto-compound.sh       # Implement features & create PRs (11:00 PM)

.systemd/
├── opencode-compound-review.service
├── opencode-auto-compound.service
└── environment.sample

opencode-workflow/
└── environment.sample              # Copy to ~/.config/opencode-compound/
```

### Features

✅ Integrates with your Discord webhook from ai-eng setup
✅ Uses OpenCode harness with gpt-5.2 for implementation
✅ Uses efficient analysis model for pattern extraction
✅ Automatic systemd scheduling (Linux)
✅ Full error handling and logging
✅ Git-based workflow with PR creation

### Expected Results

**First Night:** CLAUDE.md updated + draft PR with implemented feature

**After One Week:** Agent becomes specialized, implementation quality improves daily

**Ongoing:** Each day benefits from accumulated knowledge

### Installation Paths

Choose what works for you:

- **Path A (15 min):** Just get it running → `OPENCODE_QUICK_START.md`
- **Path B (60 min):** Understand concept first → `ryan-carson-article-x.md`
- **Path C (45 min):** Full verification → Follow A then `WORKFLOW_VERIFICATION.md`

### Next Steps

1. Read: `START_HERE.md`
2. Follow your chosen path
3. Let it run tonight at 10:30 PM and 11:00 PM
4. Check Discord for notifications in the morning

---

## 📄 License

All plugins in this marketplace are licensed under MIT License unless otherwise specified.

## 🆘 Support

For questions, issues, or contributions:

- **Plugin Issues:** Check the individual plugin's documentation
- **Marketplace Issues:** Use the marketplace-manager tools
- **Validation Help:** Run `/validate-marketplace . --deep`
- **Documentation:** Consult skill guides and command help

## 📝 Marketplace Metadata

**Last Updated:** 2025-01-25
**Plugin Count:** 3
**Maintenance Status:** Active

---

**Made with ❤️ by the Claude Code community**

For more information about Claude Code plugins, visit: https://github.com/anthropics/claude-code
