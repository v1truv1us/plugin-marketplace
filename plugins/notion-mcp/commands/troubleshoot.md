---
name: troubleshoot
description: Run comprehensive diagnostics to identify and resolve Notion MCP issues
entrypoint: connection-validator-agent
---

# Troubleshoot Notion MCP Issues

This command runs comprehensive diagnostics to identify and resolve problems with your Notion MCP connection.

## What This Does

`/notion:troubleshoot` will:

1. **Check Token File** - Verify `.local.md` exists and has correct structure
2. **Validate Token Format** - Ensure token has correct format and isn't corrupted
3. **Test Read Access** - Attempt to read from Notion workspace
4. **Test Write Access** - Attempt to write to Notion workspace
5. **Check Workspace** - Verify workspace still exists and accessible
6. **Report Each Step** - Show detailed results for each test
7. **Provide Solutions** - Specific fix suggestions for any failures

## How to Use

Run the command:
```
/notion:troubleshoot
```

Wait for comprehensive diagnostics. Example output:

**All Tests Pass:**
```
✓ Notion MCP Troubleshooting Report

Step 1: Token File
  ✓ File exists: .claude/notion-mcp.local.md
  ✓ Token present and valid format

Step 2: Token Validation
  ✓ Token starts with "notion_oauth_"
  ✓ Token length correct
  ✓ Workspace ID found

Step 3: Workspace Connection
  ✓ Can reach Notion API
  ✓ Workspace accessible
  ✓ User has access

Step 4: Read Access Test
  ✓ Can read pages
  ✓ Can list databases
  ✓ Read access confirmed

Step 5: Write Access Test
  ✓ Can create pages
  ✓ Can append blocks
  ✓ Write access confirmed

Summary: All tests passed. Notion MCP is fully functional.
```

**Partial Failure Example:**
```
✗ Notion MCP Troubleshooting Report

Step 1: Token File
  ✓ File exists
  ✓ Token present

Step 2: Token Validation
  ✓ Token format valid

Step 3: Workspace Connection
  ✓ Can reach Notion API
  ✗ Workspace not found
  ERROR: Workspace with ID a1b2c3... not found

Step 4: Read Access Test
  ✗ Cannot read pages
  ERROR: Unauthorized (401)

Step 5: Write Access Test
  ✗ Cannot write to pages
  ERROR: Unauthorized (401)

Issues Found:
  1. Workspace may have been deleted
  2. You may have been removed from workspace
  3. Token may be compromised/revoked

Suggestions:
  1. Verify workspace still exists in Notion
  2. Check you have access in workspace settings
  3. Run /notion:setup to authenticate with different workspace
  4. Contact workspace owner if access was removed
```

## Understanding Diagnostic Steps

### Step 1: Token File

Checks if configuration file exists and has correct structure.

**Pass:** File exists with valid YAML frontmatter
**Fail:** File missing or corrupted
- **Solution:** Run `/notion:setup`

### Step 2: Token Validation

Verifies token has correct format.

**Pass:** Token starts with "notion_oauth_" and correct length
**Fail:** Token is malformed, too short, or corrupted
- **Solution:** Run `/notion:setup` to get new token

### Step 3: Workspace Connection

Tests basic connectivity to Notion API.

**Pass:** Can reach Notion servers and find workspace
**Fail:** Cannot reach workspace or workspace doesn't exist
- **Causes:** Workspace deleted, network issue, workspace ID wrong
- **Solution:** Verify workspace exists in Notion, check network

### Step 4: Read Access Test

Attempts to read a list of databases in workspace.

**Pass:** Can access and read workspace content
**Fail:** No permission or token invalid
- **Causes:** Token revoked, workspace access removed, token invalid
- **Solution:** Run `/notion:setup` to re-authenticate

### Step 5: Write Access Test

Attempts to create a test page in workspace.

**Pass:** Can create and write content
**Fail:** Permission denied or workspace is read-only
- **Causes:** Workspace role is read-only, write token scope missing
- **Solution:** Check workspace role, run `/notion:setup` if needed

## Common Issues and Fixes

### Issue: File Not Found

**Symptom:**
```
✗ Step 1: Token File
  ✗ File not found: .claude/notion-mcp.local.md
```

**Cause:** Authentication not yet set up

**Fix:**
```
/notion:setup
```

### Issue: Token Format Invalid

**Symptom:**
```
✗ Step 2: Token Validation
  ✗ Token has invalid format
```

**Cause:** Token corrupted or misformatted

**Fix:**
```
/notion:setup
```

### Issue: Workspace Not Found

**Symptom:**
```
✗ Step 3: Workspace Connection
  ✗ Workspace not found: a1b2c3d4...
```

**Causes:**
- Workspace was deleted
- Workspace ID changed
- You were removed from workspace

**Fix:**
1. Check workspace still exists in Notion
2. If yes, verify you have access
3. If you were removed, ask owner to re-add you
4. If workspace is gone, run `/notion:setup` on different workspace

### Issue: Unauthorized (401) Error

**Symptom:**
```
✗ Step 4: Read Access Test
  ✗ Cannot read pages
  ERROR: Unauthorized (401)
```

**Causes:**
- Token was revoked in Notion settings
- Token expired (unlikely but possible)
- Token is corrupted

**Fix:**
```
/notion:setup
```

### Issue: Permission Denied (403) Error

**Symptom:**
```
✓ Step 4: Read Access Test (passes)
✗ Step 5: Write Access Test
  ✗ Cannot write to pages
  ERROR: Permission Denied (403)
```

**Causes:**
- Workspace role is read-only (Viewer or Commenter)
- Write scope not granted in OAuth

**Fix:**
1. Check your workspace role in Notion settings
2. If role is Viewer/Commenter, ask admin to upgrade to Editor
3. Or run `/notion:setup` again to re-grant write permission

### Issue: Network Timeout

**Symptom:**
```
✗ Step 3: Workspace Connection
  ✗ Cannot reach Notion API
  ERROR: Connection timeout
```

**Causes:**
- Network connectivity issue
- Firewall blocking connection
- Notion API temporarily down

**Fix:**
1. Check internet connection
2. Try different network (WiFi vs wired)
3. Check Notion status page: https://status.notion.com
4. Try again in few minutes if Notion has issues

## When to Use Troubleshoot

**Use `/notion:troubleshoot` when:**

1. **Setup Failed**
   - `/notion:setup` didn't complete successfully
   - Token not stored properly

2. **Commands Are Failing**
   - `/notion:read`, `/notion:write`, etc. fail
   - Need to diagnose root cause

3. **Sporadic Failures**
   - Some commands work, others don't
   - Inconsistent errors

4. **After Workspace Changes**
   - Your workspace role changed
   - You switched workspaces
   - Workspace permissions changed

5. **After Suspected Compromise**
   - Token may be compromised
   - Unusual behavior detected
   - Need full security check

## Difference from /notion:validate

| Feature | validate | troubleshoot |
|---|---|---|
| Check token file | Yes | Yes |
| Check token format | No | Yes |
| Test read access | Yes | Yes |
| Test write access | Yes | Yes |
| Check workspace exists | No | Yes |
| Check network connection | Implicit | Explicit |
| Detailed error messages | No | Yes |
| Suggested fixes | Generic | Specific |
| Diagnostic depth | Moderate | Deep |

Use **validate** for quick health check.
Use **troubleshoot** for detailed problem diagnosis.

## Getting More Information

If troubleshooting still doesn't help:

**Check Skills for Details:**
- `notion-mcp-setup` skill - Setup process and OAuth details
- `notion-mcp-tools` skill - Tool reference and usage
- `mcp-security` skill - Security and token management

**Read References:**
- troubleshooting-setup.md - Detailed troubleshooting guide
- oauth-security.md - OAuth flow and security
- token-compromise-guide.md - What to do if compromised

**Manual Debugging:**
```bash
# Check token file manually
cat .claude/notion-mcp.local.md | head -5

# Check file size
wc -c .claude/notion-mcp.local.md
```

## Troubleshooting Workflow

**Recommended approach:**

```
1. Run /notion:status
   → Quick check of configuration

2. If status shows issues:
   /notion:troubleshoot
   → Get detailed diagnostics

3. If troubleshoot reports failures:
   → Check suggested solutions
   → Apply fixes (usually /notion:setup)

4. After fix, validate:
   /notion:validate
   → Confirm fix worked
```

## Learn More

- `/notion:setup` - Set up OAuth connection
- `/notion:validate` - Quick validation test
- `/notion:status` - Configuration status
- **notion-mcp-setup** skill - Setup guidance
- **mcp-security** skill - Security best practices
