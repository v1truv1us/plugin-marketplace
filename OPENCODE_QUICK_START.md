# OpenCode Compound Workflow - Quick Start

Get your nightly AI agent loop running in 5 minutes.

## TL;DR Setup

### 1. Prerequisites Check

```bash
# Verify you have these installed
which opencode     # npm install -g opencode
which gh           # GitHub CLI
which git          # Should be installed

# And have these ready
# - Discord webhook URL (from your ai-eng setup)
# - GitHub personal access token
```

### 2. Create Environment File

```bash
mkdir -p ~/.config/opencode-compound
cat > ~/.config/opencode-compound/environment.conf << 'EOF'
DISCORD_WEBHOOK_URL=https://discordapp.com/api/webhooks/YOUR_ID/YOUR_TOKEN
GITHUB_TOKEN=github_pat_XXXXXXXXXXXXXXX
PROJECT_NAME=plugin-marketplace
EOF

chmod 600 ~/.config/opencode-compound/environment.conf
```

### 3. Make Scripts Executable

```bash
cd /home/vitruvius/git/plugin-marketplace
chmod +x scripts/opencode-compound-review.sh
chmod +x scripts/opencode-auto-compound.sh
```

### 4. Install Systemd Services

```bash
mkdir -p ~/.config/systemd/user
cp .systemd/opencode-compound-review.service ~/.config/systemd/user/
cp .systemd/opencode-auto-compound.service ~/.config/systemd/user/

systemctl --user daemon-reload
systemctl --user enable opencode-compound-review.service
systemctl --user enable opencode-auto-compound.service
```

### 5. Test Manually

```bash
# Test review script
./scripts/opencode-compound-review.sh

# Test auto-compound script
./scripts/opencode-auto-compound.sh

# Both should complete successfully and send Discord messages
```

### 6. Verify Scheduling

```bash
systemctl --user list-timers | grep opencode
```

**Done!** Your workflow will run at:
- **10:30 PM** - Review and extract learnings
- **11:00 PM** - Implement next priority and create PR

## What Happens Each Night

### 10:30 PM - Compound Review
1. Pulls latest code
2. Analyzes last 24 hours of work
3. Extracts patterns and learnings
4. Updates CLAUDE.md
5. Pushes to main
6. Sends Discord notification

### 11:00 PM - Auto-Compound
1. Fetches fresh code with new learnings
2. Analyzes priority items from reports
3. Creates feature branch
4. Implements feature with OpenCode
5. Creates draft PR
6. Sends Discord notification with PR link

## Checking Logs

```bash
# View recent logs
journalctl --user -u opencode-compound-review.service -n 50
journalctl --user -u opencode-auto-compound.service -n 50

# Follow logs in real-time
journalctl --user -u opencode-compound-review.service -f
```

Or check the files:
```bash
tail -f logs/opencode-compound-review.log
tail -f logs/opencode-auto-compound.log
```

## Troubleshooting

**Discord notifications not appearing?**
```bash
# Test webhook
curl -X POST "$DISCORD_WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d '{"content": "Test"}'
```

**Services not starting?**
```bash
# Check status
systemctl --user status opencode-compound-review.service
systemctl --user status opencode-auto-compound.service

# Test manually
./scripts/opencode-compound-review.sh
```

**OpenCode not found?**
```bash
npm install -g opencode
```

## Customization

**Change schedule times:** Edit `~/.config/systemd/user/opencode-*.service` and change `OnCalendar` times, then:
```bash
systemctl --user daemon-reload
systemctl --user restart opencode-compound-review.service
systemctl --user restart opencode-auto-compound.service
```

**Change Discord channel:** Update `~/.config/opencode-compound/environment.conf`

**Change model used for analysis:** Edit `scripts/opencode-compound-review.sh` line with `opencode --model`

**Change model used for implementation:** Edit `scripts/opencode-auto-compound.sh` line with `opencode --model`

## Full Documentation

See `OPENCODE_WORKFLOW_SETUP.md` for comprehensive setup, troubleshooting, and advanced configuration.

## Files Created

```
scripts/
├── opencode-compound-review.sh       # Review and extract learnings
└── opencode-auto-compound.sh         # Implement and create PR

.systemd/
├── opencode-compound-review.service  # Systemd service (10:30 PM)
├── opencode-auto-compound.service    # Systemd service (11:00 PM)
└── env.sample                        # Environment config template

opencode-workflow/
└── environment.sample                # Environment config sample

OPENCODE_WORKFLOW_SETUP.md             # Full setup documentation
OPENCODE_QUICK_START.md               # This file

logs/
├── opencode-compound-review.log      # Created automatically
└── opencode-auto-compound.log        # Created automatically
```

## What You'll See

Each morning, you'll find:
- **Updated CLAUDE.md** with yesterday's learnings
- **Draft PR** with implemented feature ready for review
- **Discord messages** showing what happened overnight

After a week:
- CLAUDE.md becomes a knowledge base of patterns
- Each day's implementation improves from previous learnings
- Your agent becomes an expert in your codebase

## Next Steps

1. ✅ Install and test
2. Let it run for a few nights
3. Review the CLAUDE.md updates - are they useful?
4. Review the PRs - are they good quality?
5. Adjust prompts in the scripts if needed
6. Consider extending with Slack, automatic merges, etc.

---

**Based on:** Ryan Carson's compound engineering pattern

**For full details:** See `OPENCODE_WORKFLOW_SETUP.md`
