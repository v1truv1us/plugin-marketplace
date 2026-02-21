# OAuth Flow Details

## Complete OAuth Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│ User runs: /notion:setup                                    │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────────────────┐
│ oauth-agent explains process and opens browser to:          │
│ https://notion.com/oauth2/authorize?...                     │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────────────────┐
│ User sees Notion consent screen showing:                    │
│ - Claude Code app name                                      │
│ - "read and write to your workspace" permissions            │
│ - "Allow" and "Cancel" buttons                              │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
        ┌──────────────┴──────────────┐
        ↓                             ↓
   [Allow]                        [Cancel]
        ↓                             ↓
    Success                      Setup fails
    (continue)                    (user retries)
        ↓
┌─────────────────────────────────────────────────────────────┐
│ Notion redirects with authorization code in URL:            │
│ http://localhost:3000/callback?code=...&state=...           │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────────────────┐
│ Claude Code exchanges code for OAuth token via Notion API:  │
│ POST /oauth2/token with code + client credentials           │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────────────────┐
│ Notion returns access token:                                │
│ {                                                            │
│   "access_token": "notion_oauth_...",                       │
│   "workspace_id": "...",                                    │
│   "token_type": "bearer"                                    │
│ }                                                            │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────────────────┐
│ oauth-agent stores token in:                                │
│ .claude/notion-mcp.local.md                                 │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────────────────┐
│ connection-validator-agent tests token:                     │
│ - GET /databases (read test)                                │
│ - POST /pages (write test)                                  │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
        ┌──────────────┴──────────────┐
        ↓                             ↓
   Tests pass                     Tests fail
        ↓                             ↓
   Setup complete             Report errors
```

## OAuth Parameters

### Authorization Request
```
GET https://notion.com/oauth2/authorize?
  client_id=YOUR_CLIENT_ID
  redirect_uri=http://localhost:3000/callback
  response_type=code
  owner=user
  scopes=read,write
```

- **client_id**: Claude Code's registered Notion OAuth app ID
- **redirect_uri**: Where Notion sends the authorization code
- **response_type**: Always "code" (authorization code flow)
- **owner**: Always "user" (not workspace)
- **scopes**: "read,write" for Notion workspace access

### Token Response
```json
{
  "access_token": "notion_oauth_...",
  "token_type": "bearer",
  "workspace_id": "workspace-uuid",
  "expires_in": null,
  "duplicate_id": null
}
```

**Important**: Notion OAuth tokens do not expire by default (no `expires_in` value).

## Error Handling During OAuth

### Authorization Canceled
If user clicks "Cancel" on Notion consent screen:
- OAuth flow stops
- No authorization code issued
- User must run `/notion:setup` again

**Recovery**: Simply rerun `/notion:setup`

### Invalid Client Credentials
If Claude Code sends wrong credentials to Notion:
- Notion rejects the request
- error: "invalid_client"

**Cause**: Usually means Claude Code's OAuth app is misconfigured or credentials leaked

### Redirect URI Mismatch
If callback URL doesn't match registered URI:
- Notion rejects the request
- error: "invalid_request"

**Cause**: Usually indicates network/environment configuration issue

### Network Errors
If Notion API is unreachable:
- Request times out
- Token exchange fails

**Recovery**: Wait and retry `/notion:setup`

## Token Lifetime and Validity

### No Expiration
Notion OAuth tokens do not have expiration times. A token remains valid until:
- User manually revokes in Notion settings
- Token is compromised
- Workspace access is removed

### Long-Term Validity
Tokens stored with `last_validated` timestamp help track freshness:
- If token is >30 days old and never validated, warn user
- If token is >90 days old, suggest running `/notion:validate`
- If validation fails, suggest re-running `/notion:setup`

### Manual Revocation
User can revoke token in Notion:
1. Open Notion settings → Connected apps
2. Find "Claude Code" app
3. Click "Disconnect"
4. Token becomes immediately invalid
5. Running any command will fail with "unauthorized"
6. User must run `/notion:setup` again

## OAuth Scopes Explained

### What "read" Scope Allows
- List all pages in workspace
- Read page content and properties
- Query databases
- Search across workspace
- Access file metadata

### What "write" Scope Allows
- Create new pages
- Append blocks to existing pages
- Update page properties
- Create database entries

### What "write" Does NOT Allow
- Delete pages (intentionally restricted)
- Modify database schema
- Change workspace settings
- Manage team permissions

## Security Implications

### Token Exposure Risk
If `.claude/notion-mcp.local.md` is exposed:
- Attacker gains full read/write access to your Notion workspace
- Attacker can read all documents, queries, content
- Attacker can modify or create content

**Mitigation:**
- Keep `.local.md` out of version control (see `.gitignore`)
- Don't share this file
- Use unique workspace tokens if possible (not currently supported)

### OAuth App Registration
Claude Code's OAuth app is registered with Notion under:
- **App ID**: (stored in plugin configuration)
- **Owner**: Anthropic
- **Permissions**: read, write

This is the official Claude Code - Notion integration. Do not use third-party alternatives.

## Token Refresh (Not Applicable)

Notion OAuth does not support token refresh. If token is invalidated:
- No refresh token can be used
- User must re-authenticate via `/notion:setup`
- Full OAuth flow required again

This is by design for security.
