# OpenCode Compound Workflow

**Make your AI agent learn and ship while you sleep** ✨

This implements Ryan Carson's compound engineering pattern using OpenCode harness, with automated Discord notifications from your ai-eng setup.

## What This Does

Every night, two jobs run automatically:

- **10:30 PM**: Review yesterday's work, extract learnings, update CLAUDE.md
- **11:00 PM**: Implement the next priority item using the fresh learnings, create a PR

After a week, your agent becomes an expert in your codebase because it reads its own updated instructions before each run.

## Quick Start (5 minutes)

### 1. Create environment config
```bash
mkdir -p ~/.config/opencode-compound
cp opencode-workflow/environment.sample ~/.config/opencode-compound/environment.conf
# Edit with your Discord webhook URL and GitHub token
chmod 600 ~/.config/opencode-compound/environment.conf
```

### 2. Install systemd services
```bash
mkdir -p ~/.config/systemd/user
cp .systemd/opencode-*.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable opencode-*.service
```

### 3. Make scripts executable
```bash
chmod +x scripts/opencode-*.sh
```

### 4. Test manually
```bash
./scripts/opencode-compound-review.sh
./scripts/opencode-auto-compound.sh
```

### 5. Verify it's scheduled
```bash
systemctl --user list-timers | grep opencode
```

**That's it!** Services will run tonight at 10:30 PM and 11:00 PM.

## Documentation

| Document | Purpose |
|----------|---------|
| **OPENCODE_QUICK_START.md** | 5-minute setup guide |
| **OPENCODE_WORKFLOW_SETUP.md** | Complete detailed guide with troubleshooting |
| **OPENCODE_WORKFLOW_SUMMARY.md** | High-level overview of what was built |
| **WORKFLOW_VERIFICATION.md** | Step-by-step verification checklist |
| **ryan-carson-article-x.md** | Original article by Ryan Carson |

## Files Created

### Executable Scripts
- `scripts/opencode-compound-review.sh` - Runs at 10:30 PM
- `scripts/opencode-auto-compound.sh` - Runs at 11:00 PM

### Systemd Services (Linux)
- `.systemd/opencode-compound-review.service` - Scheduler
- `.systemd/opencode-auto-compound.service` - Scheduler

### Configuration
- `opencode-workflow/environment.sample` - Template (copy to ~/.config/opencode-compound/environment.conf)

### Logs (created after first run)
- `logs/opencode-compound-review.log`
- `logs/opencode-auto-compound.log`

## System Requirements

- Linux with systemd (or macOS with launchd)
- OpenCode: `npm install -g opencode`
- GitHub CLI: `gh`
- Git
- Discord webhook URL (from ai-eng setup)
- GitHub personal access token

## How It Works

```
Every 24 Hours:
│
├─ 10:30 PM: Compound Review
│  ├─ Pull latest main
│  ├─ Analyze last 24 hours
│  ├─ Extract patterns & learnings
│  ├─ Update CLAUDE.md
│  ├─ Commit & push
│  └─ Send Discord notification ✅
│
├─ 11:00 PM: Auto-Compound
│  ├─ Fetch code with fresh context
│  ├─ Analyze priority items
│  ├─ Create feature branch
│  ├─ Implement with OpenCode
│  ├─ Create draft PR
│  └─ Send Discord notification ✅
│
└─ Morning: You wake up to
   ├─ Updated CLAUDE.md with learnings
   ├─ Draft PR ready for review
   └─ Logs showing what happened
```

## What You'll See

### First Run (Tonight at 10:30 PM)

Discord messages:
```
🔄 Compound Review Starting
Reviewing threads and compounding learnings into CLAUDE.md
Project: plugin-marketplace
```

Then:
```
✅ Compound Review Complete
Review completed successfully
Project: plugin-marketplace
```

### Then at 11:00 PM

```
🚀 Auto-Compound Starting
Fetching latest code and analyzing priority items
Project: plugin-marketplace
```

Then:
```
✅ Auto-Compound Complete
Implementation completed and PR created
Branch: feature/auto-compound-XXXX
PR: https://github.com/...
```

### Next Morning

- CLAUDE.md updated with yesterday's learnings
- Draft PR with implemented feature
- Full audit trail in logs

## Monitoring

### Check logs
```bash
tail -f logs/opencode-compound-review.log
tail -f logs/opencode-auto-compound.log
```

### Check systemd journal
```bash
journalctl --user -u opencode-compound-review.service -f
journalctl --user -u opencode-auto-compound.service -f
```

### Check scheduled times
```bash
systemctl --user list-timers | grep opencode
```

## Troubleshooting

### Services not running?
```bash
systemctl --user is-enabled opencode-compound-review.service
systemctl --user status opencode-compound-review.service
```

### Discord notifications not working?
```bash
source ~/.config/opencode-compound/environment.conf
curl -X POST "$DISCORD_WEBHOOK_URL" -H 'Content-Type: application/json' -d '{"content":"Test"}'
```

### OpenCode not found?
```bash
npm install -g opencode
which opencode
```

See **WORKFLOW_VERIFICATION.md** for complete troubleshooting.

## Customization

### Change schedule time
Edit `~/.config/systemd/user/opencode-compound-review.service`:
```
OnCalendar=*-*-* 22:30:00  # Change to your time
```
Then `systemctl --user daemon-reload`

### Change Discord channel
Update `~/.config/opencode-compound/environment.conf` with different webhook URL

### Change models used
Edit scripts and modify the `--model` flag:
- Review script (faster analysis model)
- Auto-compound script (gpt-5.2 for implementation)

## Integration with ai-eng-system

This workflow uses your existing Discord webhook from ai-eng setup. The notifications go to the same Discord channel as other ai-eng automations.

To use a different channel:
1. Create new Discord webhook for that channel
2. Update `~/.config/opencode-compound/environment.conf`
3. Restart service: `systemctl --user restart opencode-*.service`

## Expected Results After One Week

- **Monday:** Initial learnings captured, basic implementations
- **Tuesday:** CLAUDE.md updated with patterns, implementations improve
- **Wednesday:** Agent avoids Tuesday's mistakes, uses Monday's patterns
- **Thursday:** Implementations follow exact project style
- **Friday:** Agent is specialized in your codebase
- **Next Week:** Each day builds on accumulated knowledge

## Architecture

This system combines:
- **OpenCode** - AI coding harness for understanding and implementation
- **gpt-5.2** - Latest OpenAI model for high-quality implementation
- **Analysis models** - Faster models for synthesis and pattern extraction
- **Systemd** - Native Linux scheduler
- **Discord** - Notifications from your ai-eng setup
- **CLAUDE.md** - Persistent knowledge base

## Key Concepts

### Compound Learning
Each day's execution updates CLAUDE.md with patterns discovered. The next day's execution reads this updated context, so improvements compound over time.

### Two Models
- **Review step**: Uses efficient analysis model
- **Implementation step**: Uses gpt-5.2 for highest quality

### Persistent Memory
CLAUDE.md becomes a living knowledge base that grows each night with patterns your agent discovers.

### Automation
Runs completely unattended. You wake up to finished work.

## Getting Started

1. **Read:** `OPENCODE_QUICK_START.md` (5 min)
2. **Setup:** Follow the 5 steps above
3. **Test:** Run scripts manually
4. **Verify:** Check Discord and logs
5. **Enable:** Services are already scheduled
6. **Observe:** Let it run for a week
7. **Refine:** Adjust prompts based on results

## Support

- **Setup questions?** → `OPENCODE_QUICK_START.md`
- **Troubleshooting?** → `WORKFLOW_VERIFICATION.md`
- **Technical details?** → `OPENCODE_WORKFLOW_SETUP.md`
- **Concept questions?** → `ryan-carson-article-x.md`

---

**Based on:** Ryan Carson's "How to make your agent learn and ship while you sleep"

**Status:** Ready to install and enable ✅

**Next:** Read `OPENCODE_QUICK_START.md` to get started
