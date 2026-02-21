# OpenCode Compound Workflow - Verification Checklist

Use this checklist to verify your setup is complete and working correctly.

## Pre-Setup Verification

### Prerequisites
- [ ] `opencode` installed: `which opencode`
- [ ] `gh` (GitHub CLI) installed: `which gh`
- [ ] `git` installed: `which git`
- [ ] Discord webhook URL obtained from ai-eng setup
- [ ] GitHub personal access token created with `repo` scope

## Installation Verification

### Scripts Created
- [ ] `scripts/opencode-compound-review.sh` exists and is executable
  ```bash
  [ -x scripts/opencode-compound-review.sh ] && echo "✅ Review script ready"
  ```

- [ ] `scripts/opencode-auto-compound.sh` exists and is executable
  ```bash
  [ -x scripts/opencode-auto-compound.sh ] && echo "✅ Auto-compound script ready"
  ```

### Service Files Created
- [ ] `.systemd/opencode-compound-review.service` exists
  ```bash
  [ -f .systemd/opencode-compound-review.service ] && echo "✅ Review service ready"
  ```

- [ ] `.systemd/opencode-auto-compound.service` exists
  ```bash
  [ -f .systemd/opencode-auto-compound.service ] && echo "✅ Auto-compound service ready"
  ```

### Documentation Created
- [ ] `OPENCODE_WORKFLOW_SETUP.md` exists
- [ ] `OPENCODE_QUICK_START.md` exists
- [ ] `WORKFLOW_VERIFICATION.md` exists (this file)

## Environment Configuration Verification

### Config File Created
- [ ] `~/.config/opencode-compound/environment.conf` exists
  ```bash
  [ -f ~/.config/opencode-compound/environment.conf ] && echo "✅ Config exists"
  ```

### Config Permissions Correct
- [ ] File is only readable by owner (mode 600)
  ```bash
  [ "$(stat -f%A ~/.config/opencode-compound/environment.conf 2>/dev/null || stat -c%a ~/.config/opencode-compound/environment.conf)" = "600" ] && echo "✅ Permissions correct"
  ```

### Config Values Set
- [ ] `DISCORD_WEBHOOK_URL` is populated and valid
  ```bash
  grep "^DISCORD_WEBHOOK_URL=https://discordapp.com" ~/.config/opencode-compound/environment.conf && echo "✅ Discord webhook configured"
  ```

- [ ] `GITHUB_TOKEN` is populated
  ```bash
  grep "^GITHUB_TOKEN=github_pat_" ~/.config/opencode-compound/environment.conf && echo "✅ GitHub token configured"
  ```

- [ ] `PROJECT_NAME` is set
  ```bash
  grep "^PROJECT_NAME=" ~/.config/opencode-compound/environment.conf && echo "✅ Project name set"
  ```

## Systemd Service Verification

### Services Installed in User Directory
- [ ] Review service installed
  ```bash
  [ -f ~/.config/systemd/user/opencode-compound-review.service ] && echo "✅ Review service installed"
  ```

- [ ] Auto-compound service installed
  ```bash
  [ -f ~/.config/systemd/user/opencode-auto-compound.service ] && echo "✅ Auto-compound service installed"
  ```

### Systemd Daemon Reloaded
- [ ] Run: `systemctl --user daemon-reload`
- [ ] Verify: `systemctl --user list-units | grep opencode`

### Services Enabled
- [ ] Review service enabled
  ```bash
  systemctl --user is-enabled opencode-compound-review.service && echo "✅ Review service enabled"
  ```

- [ ] Auto-compound service enabled
  ```bash
  systemctl --user is-enabled opencode-auto-compound.service && echo "✅ Auto-compound service enabled"
  ```

### Services Scheduled
- [ ] Check timer status
  ```bash
  systemctl --user list-timers | grep opencode
  ```
  Expected output shows both services with scheduled times

## Functionality Verification

### Manual Test - Compound Review Script

```bash
# Run the review script
./scripts/opencode-compound-review.sh
```

- [ ] Script completes without errors
- [ ] Script creates/updates `logs/opencode-compound-review.log`
- [ ] Discord notification sent ("Compound Review Starting")
- [ ] CLAUDE.md file exists or was updated
- [ ] Git changes were committed (if any learnings found)
- [ ] Final Discord notification sent with status

### Manual Test - Auto-Compound Script

```bash
# Run the auto-compound script
./scripts/opencode-auto-compound.sh
```

- [ ] Script completes without errors
- [ ] Script creates/updates `logs/opencode-auto-compound.log`
- [ ] Discord notification sent ("Auto-Compound Starting")
- [ ] Feature branch created (`feature/...`)
- [ ] Changes committed to branch
- [ ] Draft PR created (check GitHub)
- [ ] Final Discord notification sent with PR URL

### Discord Notification Verification

- [ ] Starting notification received in Discord
- [ ] Contains project name: "plugin-marketplace"
- [ ] Contains emoji (🔄 or 🚀)
- [ ] Contains timestamp

- [ ] Completion notification received in Discord
- [ ] Shows success (✅) or failure (❌)
- [ ] Contains project name
- [ ] Contains branch name or PR URL

## OpenCode Integration Verification

### OpenCode Available in PATH
```bash
which opencode
opencode --version
```
- [ ] Command found
- [ ] Version displayed

### OpenCode Can Connect to APIs
```bash
opencode --connect
```
- [ ] Can authenticate with model providers
- [ ] No connection errors

## Logging Verification

### Log Files Created
- [ ] `logs/opencode-compound-review.log` created after first run
- [ ] `logs/opencode-auto-compound.log` created after first run

### Log Files Readable
```bash
tail logs/opencode-compound-review.log
tail logs/opencode-auto-compound.log
```
- [ ] Both files contain execution logs
- [ ] Timestamps present
- [ ] Status indicators present

### Systemd Journal Accessible
```bash
journalctl --user -u opencode-compound-review.service -n 10
journalctl --user -u opencode-auto-compound.service -n 10
```
- [ ] Journal entries present for both services
- [ ] Timestamps and messages visible

## Schedule Verification

### Check Scheduled Times
```bash
systemctl --user list-timers | grep opencode
```

Expected output similar to:
```
NEXT                        LEFT          LAST PASSED UNIT
Wed 2026-01-30 22:30:00 UTC 3h 45min left opencode-compound-review.service
Wed 2026-01-30 23:00:00 UTC 4h 15min left opencode-auto-compound.service
```

- [ ] Review service scheduled for 22:30 (10:30 PM)
- [ ] Auto-compound service scheduled for 23:00 (11:00 PM)
- [ ] Both show "NEXT" times in future

### Test Scheduler (Optional - trigger manually)
```bash
# This will run the service immediately
systemctl --user start opencode-compound-review.service

# Check if it ran
journalctl --user -u opencode-compound-review.service -n 20
```
- [ ] Service started successfully
- [ ] Completed or in progress

## Full System Test

### Complete Workflow Test

1. [ ] Run review script manually: `./scripts/opencode-compound-review.sh`
   - Verify completes successfully
   - Check CLAUDE.md was updated
   - Check Discord message received

2. [ ] Run auto-compound manually: `./scripts/opencode-auto-compound.sh`
   - Verify completes successfully
   - Check branch and PR created
   - Check Discord message with PR link

3. [ ] Wait for scheduled time (or manually trigger)
   - Monitor logs for execution
   - Verify Discord notifications
   - Check that work was done (new commits, PRs, etc.)

## Troubleshooting Verification

### If Script Fails

```bash
# Check what's wrong
./scripts/opencode-compound-review.sh

# View detailed output
cat logs/opencode-compound-review.log

# Check systemd journal
journalctl --user -u opencode-compound-review.service --all
```

- [ ] Error message clearly indicates problem
- [ ] Logs contain useful debugging info
- [ ] Journal has additional context

### If Discord Notifications Don't Work

```bash
# Verify webhook URL
source ~/.config/opencode-compound/environment.conf
echo $DISCORD_WEBHOOK_URL

# Test webhook manually
curl -X POST "$DISCORD_WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d '{"content": "Test message from OpenCode workflow"}'
```

- [ ] Webhook URL valid
- [ ] Curl test sends message successfully
- [ ] Message appears in Discord

### If Services Don't Run

```bash
# Check if enabled
systemctl --user is-enabled opencode-compound-review.service

# Check status
systemctl --user status opencode-compound-review.service

# Try running manually
systemctl --user start opencode-compound-review.service

# Check journal
journalctl --user -u opencode-compound-review.service -n 50
```

- [ ] Service is enabled
- [ ] Status shows active or recent execution
- [ ] Journal shows execution attempts

## Success Criteria

✅ **All of the following are true:**

- [ ] Both scripts are executable and in correct location
- [ ] Both systemd service files are in user directory
- [ ] Environment configuration file created with all required values
- [ ] Both services are enabled in systemd
- [ ] Manual test of review script succeeds
- [ ] Manual test of auto-compound script succeeds
- [ ] Discord notifications received for both
- [ ] Services appear in `systemctl --user list-timers`
- [ ] Logs created and contain relevant information
- [ ] No errors in systemd journal

## Sign-Off

- [ ] All verifications complete
- [ ] System is ready for production use
- [ ] Documentation reviewed and understood
- [ ] Emergency contact info handy (for Discord issues, etc.)

---

## Quick Verification Script

Run this to verify everything at once:

```bash
#!/bin/bash
echo "=== OpenCode Compound Workflow Verification ==="
echo ""

echo "✓ Script executable check:"
[ -x scripts/opencode-compound-review.sh ] && echo "  ✅ Review script executable" || echo "  ❌ Review script not executable"
[ -x scripts/opencode-auto-compound.sh ] && echo "  ✅ Auto-compound script executable" || echo "  ❌ Auto-compound script not executable"

echo ""
echo "✓ Service files check:"
[ -f ~/.config/systemd/user/opencode-compound-review.service ] && echo "  ✅ Review service installed" || echo "  ❌ Review service missing"
[ -f ~/.config/systemd/user/opencode-auto-compound.service ] && echo "  ✅ Auto-compound service installed" || echo "  ❌ Auto-compound service missing"

echo ""
echo "✓ Environment configuration check:"
[ -f ~/.config/opencode-compound/environment.conf ] && echo "  ✅ Config file exists" || echo "  ❌ Config file missing"
source ~/.config/opencode-compound/environment.conf 2>/dev/null
[ -n "$DISCORD_WEBHOOK_URL" ] && echo "  ✅ Discord webhook configured" || echo "  ❌ Discord webhook missing"
[ -n "$GITHUB_TOKEN" ] && echo "  ✅ GitHub token configured" || echo "  ❌ GitHub token missing"

echo ""
echo "✓ Tools available:"
which opencode > /dev/null && echo "  ✅ OpenCode installed" || echo "  ❌ OpenCode not found"
which gh > /dev/null && echo "  ✅ GitHub CLI installed" || echo "  ❌ GitHub CLI not found"

echo ""
echo "✓ Services enabled:"
systemctl --user is-enabled opencode-compound-review.service > /dev/null 2>&1 && echo "  ✅ Review service enabled" || echo "  ❌ Review service not enabled"
systemctl --user is-enabled opencode-auto-compound.service > /dev/null 2>&1 && echo "  ✅ Auto-compound service enabled" || echo "  ❌ Auto-compound service not enabled"

echo ""
echo "=== Verification Complete ==="
```

Save as `verify-setup.sh` and run:
```bash
chmod +x verify-setup.sh
./verify-setup.sh
```
