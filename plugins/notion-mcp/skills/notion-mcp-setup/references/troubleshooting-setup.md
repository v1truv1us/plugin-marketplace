# Troubleshooting Setup Issues

## Common Setup Problems and Solutions

### Problem 1: "OAuth Screen Never Appears"

**Symptoms:**
- Run `/notion:setup`
- Terminal shows instructions but no browser opens
- Manually visiting OAuth URL hangs or shows error

**Possible Causes:**
1. Browser not configured or unavailable
2. Network connectivity issue
3. Notion OAuth server unreachable
4. System clipboard not working (for URL paste)

**Troubleshooting Steps:**

1. Check browser availability
   ```bash
   which firefox   # or chrome, safari, etc.
   ```

2. Test network connectivity to Notion
   ```bash
   ping developers.notion.com
   ```

3. Try manually opening OAuth URL
   - Copy the URL from terminal output
   - Paste into browser address bar
   - If this works, browser auto-open may be disabled

4. Check system clipboard
   - Try copying other text to clipboard
   - If clipboard not working, paste OAuth URL manually

**Solutions:**
- Use different browser (Firefox, Chrome, Safari, Edge)
- Check network/firewall settings
- Disable VPN if using one
- Restart Claude Code and try again

### Problem 2: "Token Stored But Commands Fail"

**Symptoms:**
- `/notion:setup` completes successfully
- `.claude/notion-mcp.local.md` file exists
- Running `/notion:read` or other commands fails

**Possible Causes:**
1. Token corrupted during storage
2. OAuth token revoked in Notion
3. Workspace permissions changed
4. MCP server misconfiguration

**Troubleshooting Steps:**

1. Check token file exists and has content
   ```bash
   cat .claude/notion-mcp.local.md
   ```
   Should show YAML with `notion_oauth_token` field

2. Validate token with Notion
   ```bash
   /notion:validate
   ```
   Tests if token actually works

3. Check Notion workspace access
   - Go to Notion → Settings
   - Confirm you have access to workspace
   - Check if workspace still exists

4. Verify token format
   ```bash
   cat .claude/notion-mcp.local.md | grep notion_oauth_token
   ```
   Should start with "notion_oauth_" with no spaces

**Solutions:**
- If token is malformed, run `/notion:setup` again
- If workspace access is gone, verify workspace exists
- If token is valid, check MCP server configuration
- Run `/notion:troubleshoot` for diagnostic output

### Problem 3: "Permission Denied" Errors

**Symptoms:**
- `/notion:setup` completes successfully
- `/notion:validate` shows token is valid
- Commands return "permission denied" or "unauthorized"

**Possible Causes:**
1. OAuth scopes don't match tool requirements
2. User revoked permissions in Notion
3. Workspace role is read-only
4. Token lacks write permissions

**Troubleshooting Steps:**

1. Check permissions in Notion
   - Go to Notion → Settings → Connected apps
   - Find "Claude Code" in list
   - Verify it shows "read and write" permissions

2. Check user workspace role
   - Go to Notion settings
   - Check if your user role allows writes
   - Admin or Editor role required for write access

3. Run validation to test permissions
   ```bash
   /notion:validate
   ```
   Reports read vs write separately

4. Check specific command error
   - Different commands need different permissions
   - Read commands: need read access only
   - Write commands: need write access

**Solutions:**
- If permissions missing, revoke and re-authorize
  - Settings → Connected apps → Disconnect
  - Run `/notion:setup` again
- If workspace role is read-only, request write access from workspace admin
- Run `/notion:troubleshoot` for detailed permission diagnostics

### Problem 4: "Workspace Not Found" After Setup

**Symptoms:**
- `/notion:setup` succeeds with one workspace
- Later, commands fail with "workspace not found"

**Possible Causes:**
1. User removed from workspace
2. Workspace was deleted
3. Workspace permissions revoked
4. Token belongs to different workspace than attempted

**Troubleshooting Steps:**

1. Verify workspace still exists
   - Go to notion.com
   - Check if workspace is in list
   - Confirm you have access

2. Check stored workspace ID
   ```bash
   cat .claude/notion-mcp.local.md | grep workspace_id
   ```

3. Compare with actual workspace
   - Go to Notion → Settings
   - Check workspace ID (if visible)
   - Verify it matches stored ID

4. If workspace was deleted or access removed
   - Create/access different workspace
   - Run `/notion:setup` to set up access
   - This creates new token for new workspace

**Solutions:**
- If workspace is gone: move to different workspace and run `/notion:setup`
- If access revoked: ask workspace admin to re-add you
- If token wrong: run `/notion:setup` again to get correct token

### Problem 5: "Token Expired" or "Invalid Token"

**Symptoms:**
- Previously working commands now fail
- Error messages mention "unauthorized", "invalid_grant", or "token_revoked"

**Possible Causes:**
1. User revoked app in Notion settings
2. Workspace access was removed
3. Token has been compromised
4. Unusual: token was invalidated by Notion

**Troubleshooting Steps:**

1. Check if app is still authorized
   - Go to Notion → Settings → Connected apps
   - Look for "Claude Code" in the list
   - If not there, it was disconnected

2. If app not in list:
   - User or admin revoked access
   - Token is permanently invalid
   - Must re-authenticate

3. If app is still listed:
   - Something else caused the error
   - Run `/notion:validate` to get more details
   - Run `/notion:troubleshoot` for diagnostics

4. Check for security breach
   - If suspicious, assume token is compromised
   - Immediately disconnect in Notion settings
   - Run `/notion:setup` to get new token

**Solutions:**
- Run `/notion:setup` to obtain new token
- If setup fails, verify Notion workspace access
- Check Notion activity logs for unauthorized access
- If compromised, change Notion password as precaution

## Validation Test Results Guide

### All Tests Pass
```
✓ Notion MCP is configured correctly
✓ OAuth token is valid
✓ Read access verified (can access pages/databases)
✓ Write access verified (can create/modify content)

Status: Ready to use all commands
```

### Read Test Fails
```
✗ Cannot access Notion workspace
  Token is invalid or expired

Suggestion: Run /notion:setup to authenticate again
```

### Read Passes, Write Fails
```
✓ Read access verified
✗ Write access denied
  Your account may lack write permissions in this workspace

Suggestion: Check your workspace role or ask admin for write access
```

### No Token Found
```
✗ No OAuth token found in .claude/notion-mcp.local.md
  Notion MCP is not set up

Suggestion: Run /notion:setup to authenticate with Notion
```

## When to Use /notion:troubleshoot

Use `/notion:troubleshoot` when:
- Multiple commands are failing
- Error messages are unclear
- Want detailed diagnostic output
- Need step-by-step validation

`/notion:troubleshoot` runs comprehensive checks:
- Token file exists and valid
- Token has correct format
- Workspace ID is accessible
- Read permissions work
- Write permissions work
- Each failure gets specific suggestions

## Advanced Debugging

### Enable Debug Logging
```bash
cc --debug --plugin-dir ./plugins/notion-mcp
```

This shows:
- Token being loaded
- API requests being made
- API responses received
- Detailed error messages

### Check Raw Token Value
```bash
cat .claude/notion-mcp.local.md | grep notion_oauth_token | cut -d' ' -f2
```

Shows the exact token (be careful not to expose it).

### Test with curl (Manual Testing)
```bash
TOKEN=$(grep notion_oauth_token .claude/notion-mcp.local.md | cut -d' ' -f2 | tr -d '"')

# Test read access
curl -H "Authorization: Bearer $TOKEN" https://api.notion.com/v1/databases

# Test write access
curl -X POST -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"properties": {}}' \
  https://api.notion.com/v1/pages
```

This confirms token works at API level.

### Check Recent Validation Status
```bash
cat .claude/notion-mcp.local.md | grep last_validated
```

If very old or never set, run `/notion:validate` to update.
