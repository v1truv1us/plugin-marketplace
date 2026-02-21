# OpenCode Compound Workflow - START HERE

You now have a complete, automated nightly workflow set up. Here's what to do next.

## The Vision

Your AI agent will work at night:
- **10:30 PM**: Learn from yesterday's work
- **11:00 PM**: Ship tomorrow's feature

You wake up to finished work, and each day your agent gets smarter.

## What You Have

Complete system ready to go:

```
✅ Two executable scripts (compound review + auto-compound)
✅ Two systemd service files (schedulers for Linux)
✅ Environment configuration template
✅ Comprehensive documentation
✅ Verification checklist
✅ Original article with full concept explanation
```

## Next Steps (Pick Your Path)

### Path A: I Want to Get This Running ASAP ⚡

1. **Read this** (2 min): `OPENCODE_QUICK_START.md`
2. **Follow steps 1-5** in the quick start (3 min)
3. **Test both scripts** (5 min):
   ```bash
   ./scripts/opencode-compound-review.sh
   ./scripts/opencode-auto-compound.sh
   ```
4. **Verify scheduling** (1 min):
   ```bash
   systemctl --user list-timers | grep opencode
   ```
5. **Done!** Services will run tonight at 10:30 PM and 11:00 PM

**Total time: ~15 minutes**

### Path B: I Want to Understand Everything First 📚

1. **Read the article** (10 min): `ryan-carson-article-x.md`
   - Explains the compound engineering concept
   - Shows why this matters
   - Original vision by Ryan Carson

2. **Read the summary** (10 min): `OPENCODE_WORKFLOW_SUMMARY.md`
   - What was built
   - How the system works
   - What to expect

3. **Read the full guide** (20 min): `OPENCODE_WORKFLOW_SETUP.md`
   - Complete setup details
   - All options and customizations
   - Troubleshooting guide

4. **Follow the quick start** (5 min): `OPENCODE_QUICK_START.md`
   - Then proceed with setup

5. **Verify** (10 min): `WORKFLOW_VERIFICATION.md`
   - Use the checklist
   - Ensure everything works

**Total time: ~60 minutes (well worth it)**

### Path C: I Need This Working + Verified ✓

1. **Quick setup** (15 min): Follow `OPENCODE_QUICK_START.md` steps 1-5
2. **Verification** (20 min): Work through `WORKFLOW_VERIFICATION.md`
3. **Test everything** (10 min): Run manual tests from verification
4. **Reference later**: Keep `OPENCODE_WORKFLOW_SETUP.md` handy for customization

**Total time: ~45 minutes**

## File Guide

```
FOR GETTING STARTED:
├─ OPENCODE_README.md              ← Main entry point
├─ OPENCODE_QUICK_START.md         ← 5-min setup (most people start here)
└─ ryan-carson-article-x.md        ← Understand the concept

FOR DETAILED SETUP:
├─ OPENCODE_WORKFLOW_SETUP.md      ← Complete technical guide
├─ OPENCODE_WORKFLOW_SUMMARY.md    ← What was built (overview)
└─ WORKFLOW_VERIFICATION.md        ← Verification checklist

THE SYSTEM ITSELF:
├─ scripts/
│  ├─ opencode-compound-review.sh  ← Runs at 10:30 PM
│  └─ opencode-auto-compound.sh    ← Runs at 11:00 PM
│
├─ .systemd/
│  ├─ opencode-compound-review.service
│  ├─ opencode-auto-compound.service
│  └─ environment.sample
│
└─ opencode-workflow/
   └─ environment.sample           ← Copy to ~/.config/opencode-compound/
```

## What Happens Next

### Before You Do Anything
These files are ready to go:
- ✅ Scripts are executable
- ✅ Service files are created
- ✅ Environment template ready
- ✅ Documentation complete

### When You Follow the Quick Start
1. Create `~/.config/opencode-compound/environment.conf` with your secrets
2. Copy systemd service files to `~/.config/systemd/user/`
3. Run `systemctl --user daemon-reload`
4. Run `systemctl --user enable opencode-*.service`
5. Test manually

### Tonight at 10:30 PM
✅ Systemd automatically runs compound review
✅ Discord notification sent to your webhook
✅ CLAUDE.md updated with learnings
✅ Changes pushed to main

### Tonight at 11:00 PM
✅ Systemd automatically runs auto-compound
✅ Feature implemented
✅ PR created
✅ Discord notification with PR link

### Tomorrow Morning
You wake up to:
- Updated CLAUDE.md with yesterday's learnings
- Draft PR with implemented feature
- Full logs of what happened

### After One Week
- CLAUDE.md becomes a knowledge base
- Each day's implementation improves
- Agent becomes specialized in your codebase

## The 5-Minute TL;DR

```bash
# 1. Create config
mkdir -p ~/.config/opencode-compound
cp opencode-workflow/environment.sample ~/.config/opencode-compound/environment.conf
# Edit with your webhook URL and GitHub token
chmod 600 ~/.config/opencode-compound/environment.conf

# 2. Install services
mkdir -p ~/.config/systemd/user
cp .systemd/opencode-*.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable opencode-*.service

# 3. Make executable
chmod +x scripts/opencode-*.sh

# 4. Test
./scripts/opencode-compound-review.sh
./scripts/opencode-auto-compound.sh

# 5. Verify scheduled
systemctl --user list-timers | grep opencode
```

Done! Services run tonight automatically.

## Common Questions

**Q: When does it run?**
A: Every day at 10:30 PM (review) and 11:00 PM (implementation)

**Q: What if I want different times?**
A: Edit `~/.config/systemd/user/opencode-*.service` and change `OnCalendar` time

**Q: Can I test it before scheduling?**
A: Yes! Run scripts manually: `./scripts/opencode-compound-review.sh`

**Q: What if something breaks?**
A: Check logs with `tail -f logs/opencode-compound-review.log` or use systemd journal

**Q: Can I disable it?**
A: Yes: `systemctl --user disable opencode-*.service`

**Q: How do I know it's working?**
A: Check Discord for notifications, check `logs/`, run: `systemctl --user list-timers`

**Q: Does it work on macOS?**
A: Use launchd instead of systemd (examples in `ryan-carson-article-x.md`)

**Q: Does it work on Windows?**
A: Use Windows Task Scheduler (examples in full setup guide)

## What to Read First

**Quickest to understand:**
1. This file (you're reading it)
2. `OPENCODE_QUICK_START.md` (follow the setup)
3. Start and let it run

**To understand the concept:**
1. `ryan-carson-article-x.md` (why this matters)
2. `OPENCODE_WORKFLOW_SUMMARY.md` (what was built)
3. `OPENCODE_WORKFLOW_SETUP.md` (all details)

**To get it working + verified:**
1. `OPENCODE_QUICK_START.md` (setup)
2. `WORKFLOW_VERIFICATION.md` (verify)
3. Let it run for a week

## Quick Reference

| Want to... | Read this |
|-----------|-----------|
| Get it running ASAP | OPENCODE_QUICK_START.md |
| Understand the concept | ryan-carson-article-x.md |
| See what was built | OPENCODE_WORKFLOW_SUMMARY.md |
| Troubleshoot issues | WORKFLOW_VERIFICATION.md |
| Full technical guide | OPENCODE_WORKFLOW_SETUP.md |
| General overview | OPENCODE_README.md |

## You're All Set

Everything is ready. The system is:
- ✅ Fully configured
- ✅ Well documented
- ✅ Ready to run
- ✅ Integrated with Discord

Pick a path above and get started. Most people choose **Path A** and have it running in 15 minutes.

---

## Next Action

**Choose one:**

👉 **Path A** (15 min): `OPENCODE_QUICK_START.md` → Get it running tonight

👉 **Path B** (60 min): `ryan-carson-article-x.md` → Understand everything first

👉 **Path C** (45 min): Quick start + verification → Fully verified setup

---

**Questions?** Check the relevant documentation above.

**Ready?** Open `OPENCODE_QUICK_START.md` and follow the 5 steps.

**Have fun!** Your AI agent will ship features while you sleep. 🚀
