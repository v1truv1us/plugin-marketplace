---
name: notion-mcp-setup
description: This skill should be used when the user asks to "set up Notion MCP", "explain OAuth flow", "understand Notion MCP", "how to authenticate with Notion", or wants to learn about the Notion MCP setup process. Provides understanding of what Notion MCP is and why OAuth-based setup is required.
version: 0.1.0
---

# Notion MCP Setup Guide

## What is Notion MCP?

Notion MCP (Model Context Protocol) is the official integration that connects Claude Code to Notion workspaces. It enables secure, authenticated read and write access to Notion documents and databases through Claude Code commands.

**Why MCP?** Notion doesn't support traditional API tokens for security reasons. Instead, MCP uses **OAuth**, which requires the user to authenticate directly with Notion through their browser. This ensures:
- Your Notion credentials never leave your system
- Only the permissions you explicitly grant are used
- Tokens can be revoked at any time
- Full audit trail in Notion's security settings

## Why OAuth is Required

OAuth is an industry-standard authentication method that requires:

1. **User Approval**: You visit Notion's OAuth consent screen
2. **Permission Delegation**: You explicitly approve what Claude Code can access
3. **Token Issuance**: Notion provides a token valid for your workspace
4. **Secure Storage**: Token stays on your local machine (`.claude/notion-mcp.local.md`)

**Cannot be automated:** Full OAuth setup requires browser interaction. Claude cannot complete the OAuth flow automatically because:
- Notion's OAuth server is external to Claude Code
- User interaction (clicking "Allow") is security-critical
- Manual approval prevents unauthorized access

## The Setup Flow

### Phase 1: Preparation
- Ensure Claude Code is installed and running
- Have a Notion workspace ready (free or paid)
- Browser available for OAuth consent

### Phase 2: OAuth Authorization
Run `/notion:setup` which:
1. Opens Notion's OAuth consent screen in your browser
2. Shows what permissions Claude Code is requesting (read/write access)
3. Asks you to approve the request
4. Redirects to a callback with an authorization code

### Phase 3: Token Storage
- The authorization code is exchanged for an OAuth token
- Token is stored in `.claude/notion-mcp.local.md`
- Storage location is automatically protected (in `.gitignore`)
- Token includes workspace ID and metadata

### Phase 4: Validation
- Connection validator tests read access
- Connection validator tests write access
- If tests pass, setup is complete
- If tests fail, troubleshooting suggestions provided

## Understanding Token Storage

Tokens are stored in `.claude/notion-mcp.local.md` with YAML frontmatter:

```yaml
---
notion_oauth_token: "notion_oauth_xxxx..."
workspace_id: "workspace-uuid"
last_validated: "2026-01-29T10:30:00Z"
---

# Notion MCP Configuration

Your OAuth token is stored securely here.
```

**Why this location:**
- `.local.md` files are ignored by git (see `.gitignore`)
- YAML frontmatter stores structured data
- Human-readable for debugging
- Follows Claude Code plugin conventions

**Security considerations:**
- Never manually edit this file
- Never commit to version control
- Never share the token value
- Regenerate if compromised

## OAuth Scopes and Permissions

Claude Code requests the following Notion permissions:
- **Read**: Access all pages, databases, and content in your workspace
- **Write**: Create and modify pages, add content to databases
- **No delete**: Cannot permanently delete pages (safer)

These match the Notion MCP tool capabilities and cannot be customized during setup.

## Troubleshooting Setup Issues

### Issue: OAuth Screen Never Appears

**Possible causes:**
- Browser popup blocked or not configured
- Notion OAuth endpoint unreachable
- System clipboard/paste not working

**Solutions:**
- Check browser popup settings
- Try different browser if first fails
- Run `/notion:troubleshoot` for diagnostic output

### Issue: Token Stored But Commands Fail

**Possible causes:**
- Token expired (>12 months old)
- Notion workspace access revoked
- MCP server not configured correctly

**Solutions:**
- Run `/notion:validate` to check token status
- Run `/notion:setup` again to get fresh token
- Run `/notion:troubleshoot` for detailed diagnostics

### Issue: "Permission Denied" Errors

**Possible causes:**
- OAuth permissions revoked in Notion settings
- Workspace permissions changed
- OAuth app deauthorized

**Solutions:**
- Open Notion settings → Connected apps
- Revoke the Claude Code authorization
- Run `/notion:setup` again to re-authorize

## Next Steps After Setup

Once setup is complete:

1. **Check status**: Run `/notion:status` to verify configuration
2. **Validate connection**: Run `/notion:validate` to test read/write access
3. **Learn tools**: Study the notion-mcp-tools skill to understand available commands
4. **Start using**: Use `/notion:read`, `/notion:write`, and other commands

## Additional Resources

For more detailed information:

- **`references/oauth-flow-details.md`** - Complete OAuth flow explanation
- **`references/token-management.md`** - How tokens are stored and validated
- **`references/troubleshooting-setup.md`** - Detailed setup troubleshooting guide

See the notion-mcp-tools skill for reference guide to all available commands.

See the mcp-security skill for security best practices.
