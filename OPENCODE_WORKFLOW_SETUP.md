# OpenCode Compound Workflow Setup Guide

This guide walks you through setting up Ryan Carson's compound engineering pattern using OpenCode harness with automated Discord notifications integrated into your ai-eng-system setup.

## Overview

The workflow runs **two automated jobs every night**:

1. **10:30 PM - Compound Review** (`opencode-compound-review.sh`)
   - Reviews threads and commits from the last 24 hours
   - Extracts learnings and patterns
   - Updates `CLAUDE.md` with discovered insights
   - Uses the faster analysis model for synthesis

2. **11:00 PM - Auto-Compound** (`opencode-auto-compound.sh`)
   - Reads the latest learnings from CLAUDE.md
   - Identifies priority items from reports
   - Implements features using OpenCode
   - Creates PRs for review
   - Uses gpt-5.2 (latest OpenAI model) for implementation

Both jobs send status updates to your Discord webhook from your ai-eng setup.

## Prerequisites

- Linux system with systemd (or macOS with launchd)
- OpenCode installed globally: `npm install -g opencode`
- GitHub CLI (`gh`) installed
- Git configured with credentials
- Discord webhook URL from your ai-eng setup
- GitHub personal access token with `repo` scope

## Setup Steps

### 1. Install OpenCode

```bash
npm install -g opencode

# Verify installation
opencode --help
```

### 2. Create Environment Configuration

Copy the sample environment file:

```bash
mkdir -p ~/.config/opencode-compound
cp opencode-workflow/environment.sample ~/.config/opencode-compound/environment.conf
```

Edit `~/.config/opencode-compound/environment.conf` and fill in:

```bash
# Your Discord webhook URL from ai-eng setup
DISCORD_WEBHOOK_URL=https://discordapp.com/api/webhooks/YOUR_ID/YOUR_TOKEN

# GitHub token for PR creation
GITHUB_TOKEN=github_pat_XXXXXXXXXXXXXXX

# Project name (for Discord notifications)
PROJECT_NAME=plugin-marketplace
```

**IMPORTANT:** This file contains secrets. Ensure it's:
- Not world-readable: `chmod 600 ~/.config/opencode-compound/environment.conf`
- Not committed to git
- Backed up securely

### 3. Make Scripts Executable

```bash
chmod +x scripts/opencode-compound-review.sh
chmod +x scripts/opencode-auto-compound.sh
```

### 4. Set Up Systemd Services (Linux)

Copy service files to systemd user directory:

```bash
mkdir -p ~/.config/systemd/user
cp .systemd/opencode-compound-review.service ~/.config/systemd/user/
cp .systemd/opencode-auto-compound.service ~/.config/systemd/user/

# Reload systemd
systemctl --user daemon-reload
```

Enable and start the services:

```bash
# Enable both services to run on schedule
systemctl --user enable opencode-compound-review.service
systemctl --user enable opencode-auto-compound.service

# Start the timer immediately
systemctl --user start opencode-compound-review.service
systemctl --user start opencode-auto-compound.service
```

### 5. Verify Setup

Check if services are registered:

```bash
systemctl --user list-timers | grep opencode
```

Expected output:
```
NEXT                        LEFT          LAST PASSED UNIT
Wed 2026-01-29 22:30:00 UTC 4h 20min left opencode-compound-review.service
Wed 2026-01-29 23:00:00 UTC 4h 50min left opencode-auto-compound.service
```

View logs:

```bash
# View all logs
journalctl --user -u opencode-compound-review.service -f
journalctl --user -u opencode-auto-compound.service -f

# View last 50 lines
journalctl --user -u opencode-compound-review.service -n 50
```

### 6. Test Manually (Before Scheduling)

Test the review script:

```bash
./scripts/opencode-compound-review.sh
```

Test the auto-compound script:

```bash
./scripts/opencode-auto-compound.sh
```

Both should:
- Complete without errors
- Send Discord notifications
- Create appropriate git commits/branches

## Workflow Details

### Compound Review (10:30 PM)

**What it does:**
1. Checks out and pulls latest `main` branch
2. Sends "starting review" notification to Discord
3. Runs OpenCode with prompt to:
   - Load existing CLAUDE.md learnings
   - Review recent commits and threads
   - Extract patterns, gotchas, and insights
   - Update CLAUDE.md with findings
4. Commits and pushes changes to main
5. Sends completion status to Discord

**Output:**
- Updated CLAUDE.md with new learnings
- Git commit with message about learnings
- Discord notification with status

**Model:** Optimized for analysis and synthesis (faster model)

### Auto-Compound (11:00 PM)

**What it does:**
1. Fetches latest code (including fresh CLAUDE.md)
2. Resets hard to origin/main
3. Sends "starting implementation" notification
4. Analyzes priority reports (if they exist)
5. Creates feature branch
6. Runs OpenCode with prompt to:
   - Load project CLAUDE.md context
   - Create PRD for priority item
   - Break down into testable steps
   - Implement following project patterns
   - Add tests
7. Commits changes
8. Creates draft PR
9. Sends completion status to Discord

**Output:**
- Feature branch with implementation
- Draft PR ready for review
- Discord notification with PR URL

**Model:** gpt-5.2 (latest OpenAI model for implementation)

## Discord Notifications

The workflow sends two types of notifications for each job:

### Starting Notification
```
🔄 Compound Review Starting
Reviewing threads and compounding learnings into CLAUDE.md

Project: plugin-marketplace
```

### Completion Notification
```
✅ Compound Review Complete
Review completed successfully

Project: plugin-marketplace
Timestamp: 2026-01-29T22:35:00Z
```

Or if failed:
```
❌ Compound Review Complete
Review failed (exit code: 1)

Project: plugin-marketplace
Timestamp: 2026-01-29T22:35:00Z
```

## Troubleshooting

### Services Not Running

Check if service is enabled:
```bash
systemctl --user is-enabled opencode-compound-review.service
```

Manually test the service:
```bash
systemctl --user start opencode-compound-review.service
journalctl --user -u opencode-compound-review.service -n 100
```

### Discord Notifications Not Sending

Check webhook URL in `~/.config/opencode-compound/environment.conf`:
```bash
# Test webhook manually
curl -X POST "$DISCORD_WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d '{"content": "Test message"}'
```

### OpenCode Not Found

Ensure OpenCode is in PATH:
```bash
which opencode
# Should output: /usr/local/bin/opencode or similar

# If not, reinstall:
npm install -g opencode
```

### GitHub Token Issues

Verify token has correct scopes:
```bash
gh auth status
```

Required scope: `repo` (full control of private repositories)

Generate new token at: https://github.com/settings/tokens

### Logs Not Appearing

Check systemd journal:
```bash
journalctl --user-unit opencode-compound-review.service --all
```

View log files directly:
```bash
tail -f logs/opencode-compound-review.log
tail -f logs/opencode-auto-compound.log
```

### Service Environment Not Loading

Verify environment file exists and is readable:
```bash
ls -la ~/.config/opencode-compound/environment.conf
# Should show: -rw------- (600)

# Test sourcing the file
source ~/.config/opencode-compound/environment.conf
echo $DISCORD_WEBHOOK_URL
```

## Advanced Configuration

### Changing Schedule Times

Edit service files and change the `OnCalendar` time:

In `~/.config/systemd/user/opencode-compound-review.service`:
```
OnCalendar=*-*-* 22:30:00  # 10:30 PM
```

In `~/.config/systemd/user/opencode-auto-compound.service`:
```
OnCalendar=*-*-* 23:00:00  # 11:00 PM
```

Then reload:
```bash
systemctl --user daemon-reload
systemctl --user restart opencode-compound-review.service
systemctl --user restart opencode-auto-compound.service
```

### Running on macOS

For macOS, use launchd instead of systemd:

1. Create plist files in `~/Library/LaunchAgents/`
2. Use `launchctl load` to register them
3. Use `log stream --predicate 'process == "launchd"'` to view logs

See Ryan Carson's article for example launchd plist files.

### Running on Windows

Use Windows Task Scheduler:

1. Open Task Scheduler
2. Create Basic Task
3. Set trigger to run at specific time
4. Set action to run the bash script
5. Enable history logging

## Going Further

### Slack Integration

Replace Discord webhook URLs with Slack webhook URLs. The JSON format is slightly different:

```bash
curl -X POST "$SLACK_WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d '{"text": "Compound Review Started"}'
```

### Multiple Priority Tracks

Run different compound jobs for different areas:

```bash
# opencode-compound-api.sh - focuses on API implementation
# opencode-compound-ui.sh  - focuses on UI implementation
```

### Automatic PR Merge

Add to auto-compound.sh after PR creation:

```bash
if gh pr checks "$BRANCH_NAME" --check-all; then
  gh pr merge "$BRANCH_NAME" --auto --squash
fi
```

### Weekly Summary

Add a third job at end of week:

```bash
# 9:00 PM Friday
OnCalendar=Fri *-*-* 21:00:00

opencode "Summarize all PRs merged this week and write a changelog"
```

## Understanding the Compound Effect

Every night, the system improves:

- **Monday learnings** → Tuesday's CLAUDE.md → Tuesday implementation benefits from Monday's patterns
- **Tuesday gotchas** → Wednesday's CLAUDE.md → Wednesday avoids Tuesday's mistakes
- **Weekly patterns** → Updated instructions → More efficient implementations

Over time, your agent becomes an expert in your codebase because it's reading its own updated instructions before each run.

## Logs Location

All activity is logged to:

```
logs/opencode-compound-review.log  # Daily at 10:30 PM
logs/opencode-auto-compound.log    # Daily at 11:00 PM
```

Also available in systemd journal:

```bash
journalctl --user -u opencode-compound-review.service
journalctl --user -u opencode-auto-compound.service
```

## Support & Debugging

For issues with:

- **OpenCode**: https://github.com/shroominic/opencode
- **GitHub CLI**: https://cli.github.com/
- **Systemd**: `man systemd.timer`
- **Discord Webhooks**: https://discord.com/developers/docs

## Next Steps

1. Set up environment configuration
2. Test scripts manually
3. Enable systemd services
4. Verify Discord notifications
5. Let it run for a week to see the compound effect
6. Adjust prompts in scripts based on results
7. Extend with custom workflows

---

**Based on:** Ryan Carson's "How to make your agent learn and ship while you sleep"

**Modified for:** OpenCode harness with gpt-5.2 and analysis models

**Integration:** Discord webhook from ai-eng-system setup
