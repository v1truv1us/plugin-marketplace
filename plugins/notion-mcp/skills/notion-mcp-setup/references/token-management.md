# Token Management

## Storage Format

Tokens are stored in `.claude/notion-mcp.local.md` using YAML frontmatter:

```yaml
---
notion_oauth_token: "notion_oauth_1234567890abcdefghijklmnop"
workspace_id: "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
last_validated: "2026-01-29T10:30:00Z"
---

# Notion MCP Configuration

This file contains your Notion OAuth token. Keep it private!
```

### Field Descriptions

**notion_oauth_token** (required)
- The OAuth access token from Notion
- Starts with "notion_oauth_"
- 25+ character alphanumeric string
- Never share or expose this value

**workspace_id** (required)
- UUID of your Notion workspace
- Obtained during OAuth flow
- Used to validate correct workspace

**last_validated** (optional)
- ISO 8601 timestamp of last successful validation
- Updated by `/notion:validate` command
- Used to warn if token hasn't been validated recently

## Token Validation

### What `/notion:validate` Does

```
Check token exists in .claude/notion-mcp.local.md
    ↓
Parse YAML frontmatter
    ↓
Extract notion_oauth_token value
    ↓
Make read request to Notion API (GET /databases)
    ├─ Success: Token is valid for read access
    └─ Failure: Token invalid or expired
    ↓
Make write request to Notion API (POST /pages)
    ├─ Success: Token is valid for write access
    └─ Failure: Token lacks write permissions
    ↓
Update last_validated timestamp
    ↓
Report status
```

### Success Indicators

If validation succeeds:
- "✓ Token is valid and accessible"
- "✓ Read access verified"
- "✓ Write access verified"
- "last_validated" timestamp updated
- All commands will work

### Failure Indicators

If validation fails at read test:
- "✗ Token is invalid or expired"
- Suggests running `/notion:setup` again
- No commands will work

If validation fails at write test:
- "✓ Read access verified"
- "✗ Write access denied"
- Some commands work (read-only)
- Suggests checking Notion OAuth permissions

## When Tokens Become Invalid

### User Revokes Access
User goes to Notion → Settings → Connected apps → Disconnect

**Effect:** Token immediately becomes invalid for all operations

**How plugin detects:** Next command fails with "unauthorized" error

**Recovery:** Run `/notion:setup` to obtain new token

### Workspace Access Removed
User is removed from Notion workspace or workspace is deleted

**Effect:** Token is no longer valid for that workspace

**How plugin detects:** Next command fails with workspace not found error

**Recovery:** Verify workspace still exists, then run `/notion:setup`

### Token Compromised
If `.local.md` file is exposed or leaked

**Effect:** Attackers can use token to access workspace

**Mitigation:**
1. Immediately revoke in Notion settings
2. Run `/notion:setup` to obtain new token
3. Check Notion activity logs for unauthorized access

## Token Security Best Practices

### Storage
- Keep `.claude/notion-mcp.local.md` private
- Never commit to git (protected by `.gitignore`)
- Don't copy token to other machines
- Don't share with others

### Rotation
- No automatic rotation (Notion design)
- Manually revoke in Notion settings if needed
- Create new token via `/notion:setup`

### Monitoring
- Notion shows active connected apps in settings
- Notion activity log shows API access
- Regular `/notion:validate` checks token freshness

### On Machine Changes
When moving to new machine:
- Cannot copy `.local.md` directly (token exposure risk)
- Must run `/notion:setup` on new machine
- This creates new token in new location

## Token Expiration (Not Applicable)

Notion OAuth tokens do NOT expire:
- No TTL or expiration date
- Token remains valid indefinitely
- User revocation is only way to invalidate

This differs from standard OAuth providers (Google, GitHub, etc.) which use refresh tokens.

## What Commands Check Token

Every Notion command validates token before use:

```
User runs /notion:read [page-id]
    ↓
Pre-tool-use hook checks:
    - Token exists in .local.md
    - Token is not empty string
    - Token starts with "notion_oauth_"
    ↓
  ├─ Valid: Proceed to read operation
  └─ Invalid: Block and suggest /notion:setup
```

This prevents wasted time on invalid tokens.

## Debugging Token Issues

### Check Token Exists
```bash
cat .claude/notion-mcp.local.md | head -5
```

Should output YAML with `notion_oauth_token` field.

### Check Token Format
Token should:
- Start with "notion_oauth_"
- Contain 25+ alphanumeric characters
- Have no spaces or special characters

### Check Last Validation
```bash
cat .claude/notion-mcp.local.md | grep last_validated
```

Shows when token was last successfully used.

### Manual Validation
Run `/notion:validate` to test token with Notion API directly.

## Multi-Workspace Support (Future)

Currently, only one token per workspace is supported.

Future enhancement would allow:
- Multiple `.local.md` files for different workspaces
- Token switching via command option
- Workspace selector in setup

This would enable "read from Workspace A, write to Workspace B" workflows.
