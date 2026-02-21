---
name: validate
description: Test Notion OAuth token validity and connection to workspace
entrypoint: connection-validator-agent
---

# Validate Notion Connection

This command tests your Notion OAuth token and verifies read/write access to your workspace.

## What This Does

`/notion:validate` will:

1. **Check Token Exists** - Verify token is stored in `.claude/notion-mcp.local.md`
2. **Test Token Format** - Ensure token has correct structure
3. **Test Read Access** - Verify you can read from Notion
4. **Test Write Access** - Verify you can write to Notion
5. **Update Timestamp** - Record when validation last succeeded
6. **Report Results** - Show detailed status for each test

## How to Use

Run the command:
```
/notion:validate
```

Wait for the validation to complete. You'll see results like:

**All Tests Pass:**
```
✓ Notion MCP is configured correctly
✓ OAuth token is valid
✓ Read access verified (can access pages/databases)
✓ Write access verified (can create/modify content)

Status: Ready to use all commands
```

**Read Works, Write Fails:**
```
✓ Read access verified
✗ Write access denied
  Your account may lack write permissions in this workspace

Suggestion: Check your workspace role or ask admin for write access
```

**No Token Found:**
```
✗ No OAuth token found in .claude/notion-mcp.local.md
  Notion MCP is not set up

Suggestion: Run /notion:setup to authenticate with Notion
```

## When to Validate

Run validation:

**After Initial Setup**
- Right after running `/notion:setup` to confirm success
- Before using any other commands

**Periodically (Monthly)**
- Ensures token is still valid
- Detects early if workspace access changes
- Updates `last_validated` timestamp

**When Commands Fail**
- Diagnoses whether issue is token or permission related
- Distinguishes between read-only vs write access problems
- Provides specific error messages

**After Workspace Changes**
- If your workspace role changed
- If you were added/removed from workspace
- If workspace permissions changed

## Understanding Test Results

### Token Exists Test

Checks if `.claude/notion-mcp.local.md` file exists with token.

**Pass:** File exists and contains `notion_oauth_token` field

**Fail:** File missing or token field empty
- **Solution:** Run `/notion:setup`

### Token Format Test

Verifies token has correct format (starts with `notion_oauth_`).

**Pass:** Token starts with "notion_oauth_" and is 25+ characters

**Fail:** Token is malformed or corrupted
- **Solution:** Run `/notion:setup` to get new token

### Read Access Test

Tests ability to read from Notion workspace.

**Pass:** Can list databases and access pages

**Fail:** Cannot read from workspace
- **Causes:** Token invalid, workspace access removed, OAuth revoked
- **Solution:** Run `/notion:setup` to re-authenticate

### Write Access Test

Tests ability to write to Notion workspace.

**Pass:** Can create pages and modify content

**Fail:** Cannot write to workspace
- **Causes:** Workspace role is read-only, token lacks write scope
- **Solution:** Check workspace role in Notion settings, or run `/notion:setup`

## If Validation Fails

**All Tests Fail (No Token)**
```
/notion:setup
```
Go through OAuth setup to create new token.

**Read Fails, No Other Info**
```
/notion:troubleshoot
```
Get detailed diagnostics about what's wrong.

**Read Pass, Write Fail**
Check your Notion workspace role:
1. Go to Notion → Settings
2. Check your user role (Owner/Editor/Commenter/Viewer)
3. Write requires Editor or Owner role
4. If you're Commenter or Viewer, ask workspace admin to upgrade

**Intermittent Failures**
- Token may have been revoked externally
- Workspace access may have changed
- Run `/notion:troubleshoot` for more info

## Validation Updates Timestamp

After successful validation, the `last_validated` field in `.claude/notion-mcp.local.md` is updated:

```yaml
last_validated: "2026-01-29T10:30:00Z"
```

This timestamp:
- Shows when token was last tested
- Helps track token freshness
- Used by `/notion:status` to report recency

## Next Steps

**If Validation Passes:**
- All Notion MCP commands are ready to use
- Start with `/notion:read` to read a page
- Use `/notion:search` to explore workspace
- See `notion-mcp-tools` skill for complete tool reference

**If Validation Fails:**
- Try `/notion:troubleshoot` for step-by-step diagnostics
- See troubleshooting-setup.md in `notion-mcp-setup` skill
- Check workspace in Notion to verify access

## Security Notes

- Validation never logs or displays your token
- Only tests connectivity, doesn't modify anything
- Safe to run frequently for monitoring
- Helps detect if token was compromised externally

## Learn More

- **notion-mcp-setup** skill - Detailed setup and token management
- **mcp-security** skill - Token security and management
- `/notion:status` command - Quick configuration overview
- `/notion:troubleshoot` command - Detailed diagnostics
