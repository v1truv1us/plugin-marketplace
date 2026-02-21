---
name: status
description: Show Notion MCP configuration status and token health
entrypoint: bash
---

# Check Notion Configuration Status

This command shows your current Notion MCP configuration and whether everything is ready to use.

## What This Does

`/notion:status` will:

1. **Check Configuration** - Verify `.local.md` file exists
2. **Show Workspace ID** - Display your connected Notion workspace
3. **Show Validation Status** - When token was last validated
4. **Show Token Freshness** - How long since last validation
5. **Provide Quick Assessment** - Whether everything looks good

## How to Use

Run the command:
```
/notion:status
```

You'll see output like:

**Everything Ready:**
```
✓ Notion MCP Configuration Status

Workspace ID: a1b2c3d4-e5f6-7890-abcd-ef1234567890
Last Validated: 2026-01-29 (2 days ago)
Token Status: Valid

Status: Ready to use Notion MCP
```

**Not Set Up Yet:**
```
✗ Notion MCP is not configured

Token File: .claude/notion-mcp.local.md
Status: File not found

Suggestion: Run /notion:setup to authenticate
```

**Token Needs Validation:**
```
⚠ Notion MCP configured but needs validation

Workspace ID: a1b2c3d4-e5f6-7890-abcd-ef1234567890
Last Validated: 2026-01-15 (30 days ago)
Token Status: Unknown (not recently validated)

Suggestion: Run /notion:validate to check token health
```

## Understanding the Output

### Workspace ID

The UUID of your connected Notion workspace. This:
- Helps verify you're connected to the right workspace
- Matches the workspace ID in Notion settings
- Unique to your workspace

### Last Validated

When the token was last tested with `/notion:validate`:
- Recent date (< 7 days) = Good, token recently tested
- Old date (> 30 days) = Consider running `/notion:validate`
- Never = Token not yet validated

### Token Status

Current confidence in token validity:
- **Valid** - Recently validated, should work
- **Unknown** - Not validated recently, may work but untested
- **Invalid** - Known to be expired or revoked
- **Not configured** - No token found

### Suggestions

The command provides specific next steps:
- **No configuration** → Run `/notion:setup`
- **Old validation** → Run `/notion:validate`
- **Invalid token** → Run `/notion:setup`
- **All good** → Start using commands

## When to Check Status

**Quick Health Check:**
Run `/notion:status` anytime to verify configuration without actually connecting to Notion.

**Troubleshooting:**
First step when something fails. Shows if issue is missing/stale token.

**Monitoring:**
Monthly check-in to ensure configuration is still valid.

**Before Important Operations:**
Before reading/writing critical data, verify status is "Ready"

## Quick Assessment Guide

| Workspace ID | Last Validated | Token Status | Assessment |
|---|---|---|---|
| Shown | Recent | Valid | ✓ Ready to use |
| Shown | Old | Unknown | ⚠ Should validate |
| Shown | Never | Unknown | ⚠ Must validate first |
| Missing | - | - | ✗ Not set up |

## If Status Shows Issues

**Not Configured:**
```
/notion:setup
```
Go through OAuth setup to create configuration.

**Token Needs Validation:**
```
/notion:validate
```
Test token and update `last_validated` timestamp.

**Invalid Token:**
```
/notion:setup
```
Get new token via OAuth flow.

**Workspace ID Mismatch:**
- If you switched Notion workspaces, need new token
- Run `/notion:setup` to set up different workspace
- Or check if workspace was deleted/recreated

## Manual Status Check

If command doesn't work, you can check manually:

```bash
# Check if file exists
cat .claude/notion-mcp.local.md | head -10
```

Should show:
```yaml
---
notion_oauth_token: "notion_oauth_..."
workspace_id: "workspace-uuid"
last_validated: "2026-01-29..."
---
```

## Timing and Frequency

**How Often to Run:**
- Anytime you want quick confirmation
- No connection cost (reads local file only)
- Safe to run multiple times
- Good to run monthly for monitoring

**Performance:**
- Instant (reads local file, no network call)
- No delay in getting results
- No impact on system performance

## Difference from /notion:validate

| Feature | status | validate |
|---|---|---|
| Checks file exists | Yes | Yes |
| Tests network connection | No | Yes |
| Tests read access | No | Yes |
| Tests write access | No | Yes |
| Updates last_validated | No | Yes |
| Network required | No | Yes |
| Diagnostic depth | Shallow | Deep |

Use **status** for quick check.
Use **validate** for full connection test.

## Combined Workflow

**Typical monitoring workflow:**

```
# Quick daily check (takes <1 second)
/notion:status

# Weekly full test (takes ~5 seconds)
/notion:validate

# Monthly verify nothing changed
/notion:status
```

## Learn More

- `/notion:setup` - Set up new configuration
- `/notion:validate` - Full connection test
- `/notion:troubleshoot` - Detailed diagnostics
- **notion-mcp-setup** skill - Understanding configuration
- **mcp-security** skill - Token management
