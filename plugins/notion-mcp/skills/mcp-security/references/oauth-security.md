# OAuth Security Deep Dive

## OAuth 2.0 Authorization Code Flow

Notion uses the OAuth 2.0 Authorization Code flow, which is the most secure OAuth pattern.

### Why Authorization Code Flow?

Unlike other OAuth flows, Authorization Code does not:
- Send tokens through browser URLs
- Use user passwords
- Require shared secrets between client and user
- Directly expose credentials

Instead, it uses:
- Authorization codes (valid 60 seconds, single-use)
- Secure server-to-server token exchange
- Encrypted HTTPS communication

### Complete Flow Sequence

```
┌─────────────────────────────────────────┐
│ 1. User clicks "Setup" in Claude Code   │
└──────────────┬──────────────────────────┘
               ↓
┌─────────────────────────────────────────┐
│ 2. Claude Code opens Notion OAuth URL   │
│    https://api.notion.com/oauth2/auth?  │
│    client_id=...&redirect_uri=...       │
└──────────────┬──────────────────────────┘
               ↓
┌─────────────────────────────────────────┐
│ 3. User sees Notion's consent screen    │
│    (This is Notion's official server)   │
└──────────────┬──────────────────────────┘
               ↓
        ┌──────┴──────┐
        ↓             ↓
   [Allow]        [Deny]
        ↓             ↓
    Continue      Setup fails
        ↓
┌─────────────────────────────────────────┐
│ 4. Notion redirects with auth code      │
│    http://localhost:3000/callback?      │
│    code=...&state=...                   │
│    (auth code valid only 60 seconds)    │
└──────────────┬──────────────────────────┘
               ↓
┌─────────────────────────────────────────┐
│ 5. Claude Code receives code            │
│    (Server-side, not through browser)   │
└──────────────┬──────────────────────────┘
               ↓
┌─────────────────────────────────────────┐
│ 6. Claude Code exchanges code for token │
│    POST /oauth2/token                   │
│    client_id=...&client_secret=...      │
│    code=...&redirect_uri=...            │
│    (via HTTPS, encrypted)               │
└──────────────┬──────────────────────────┘
               ↓
┌─────────────────────────────────────────┐
│ 7. Notion returns access token          │
│    {"access_token": "notion_oauth_..."}│
│    (via HTTPS, encrypted)               │
└──────────────┬──────────────────────────┘
               ↓
┌─────────────────────────────────────────┐
│ 8. Claude Code stores token locally     │
│    .claude/notion-mcp.local.md          │
│    (Token never exposed in URLs/logs)   │
└─────────────────────────────────────────┘
```

## Security Properties of This Flow

### Authorization Code is Safe if Intercepted

The authorization code:
- Valid for only 60 seconds
- Single-use only (becomes invalid after used)
- Useless without `client_secret` (which only Claude Code has)
- Seeing code in URL is not a security risk

### Token Exchange Uses Client Secret

When exchanging code for token:
- Claude Code authenticates itself with `client_secret`
- Only official Claude Code app knows this secret
- Even if attacker has auth code, they cannot get token
- Exchange happens server-to-server over HTTPS

### Token Never in Browser

Unlike some OAuth implementations:
- Token is not in browser URL
- Token is not exposed in browser history
- Token is not cached by browser
- Token never transmitted through browser

### Token Stored Locally

Token stays on your machine:
- Not sent to Claude Code servers
- Not sent to Anthropic
- Only sent to Notion API when needed
- Encrypted in transit (HTTPS)

## Threat Models and Mitigations

### Threat 1: Token Interception in Transit

**Risk:** Attacker intercepts network traffic and steals token

**Mitigations:**
- All communication is HTTPS (encrypted)
- Token only transmitted when making API calls
- Token never logged or exposed in logs
- Token never appears in URLs
- Tokens have no bearer value in transit (encrypted envelope)

**Your part:**
- Use secure network (avoid public WiFi for setup)
- Token only valid for your Notion workspace

### Threat 2: Token Stored on Disk

**Risk:** Attacker gains file system access and steals token

**Mitigations:**
- Token stored in `.local.md` (not world-readable)
- File protected by OS permissions
- File excluded from git (cannot be accidentally pushed)
- File not backed up automatically
- You can manually revoke in Notion settings

**Your part:**
- Keep system secure (full disk encryption)
- Don't share machine with untrusted users
- Periodically check file permissions

### Threat 3: Token Exposed in Logs

**Risk:** Token appears in system logs or debug output

**Mitigations:**
- Plugin never logs token value
- Error messages show error codes, not token
- Debugging commands safe (never expose token)
- Pre-tool-use hook validates without exposing

**Your part:**
- Don't manually paste token in terminal
- Don't log token in scripts
- Use `/notion:validate` (safe) not manual curl (risky)

### Threat 4: Phishing/Social Engineering

**Risk:** Attacker tricks you into giving token or credentials

**Mitigations:**
- OAuth requires you to authenticate with Notion directly
- You see official Notion consent screen (not Claude Code)
- Notion's security protects against phishing
- Claude Code never asks for password

**Your part:**
- Never give token to anyone
- Only authenticate through official Notion site
- Never accept pre-generated tokens
- Be wary of requests for your token

### Threat 5: Compromised Machine

**Risk:** Malware on your machine steals token file

**Mitigations:**
- Token isolated to `.local.md` (easy to revoke)
- You can revoke instantly in Notion settings
- Token is user-specific (other users on machine don't have it)
- Notion activity log shows if token was used

**Your part:**
- Keep machine secure (antivirus, updates)
- Revoke token if machine is compromised
- Monitor Notion activity log
- Don't store backups of `.local.md`

## Token Revocation

### Instant Revocation

You can revoke the token immediately:

1. Open Notion → Settings
2. Find "Connected Apps" or "Integrations"
3. Find "Claude Code"
4. Click "Disconnect"
5. Token becomes invalid instantly (within seconds)

All subsequent API calls fail with 401 Unauthorized.

### How Revocation Works

When you disconnect:
- Notion's auth server is updated
- New API calls fail authentication
- Existing operations continue (if already in progress)
- Token file on your machine remains but is useless

### Revocation Does NOT Delete Local Token

The `.local.md` file still exists after revocation:
- You can delete it manually
- Or leave it (it's just a useless file)
- Running `/notion:setup` creates new token in new file
- Old token is worthless (already revoked)

## Comparison with API Key Approach

### Why Notion Uses OAuth (Not API Keys)

| Aspect | OAuth | API Key |
|--------|-------|---------|
| User approval | Required | Not required |
| Revocation | Instant | Delayed |
| Permission granularity | Scopes (read, write) | All or nothing |
| User accountability | Clear | Unclear |
| Rotation necessity | Optional | Recommended periodically |
| Single-machine binding | Possible | No |

### OAuth Security Advantages

1. **User Explicitly Consents** - You must click "Allow"
2. **Audit Trail** - Notion logs who authorized what
3. **Instant Revocation** - One click to disable access
4. **Scope Limitations** - Can grant read-only or write
5. **Personal Authorization** - Token tied to your account

## Best Practices for Token Management

### DO:

✅ **Do use HTTPS connections**
- Token only transmitted over HTTPS
- Never use HTTP connections

✅ **Do revoke immediately if compromised**
- Go to Notion → Settings → Connected Apps
- Click "Disconnect"
- Token becomes invalid instantly

✅ **Do run `/notion:validate` periodically**
- Verifies token is still working
- Updates last_validated timestamp
- Catches compromises early

✅ **Do monitor Notion activity**
- Check activity logs for unauthorized changes
- Notion shows when token was used
- Alert if activity seems suspicious

✅ **Do keep machine secure**
- Use full disk encryption
- Keep OS and software updated
- Use antivirus/malware protection
- Don't install untrusted software

### DON'T:

❌ **Don't share tokens**
- Never give token to colleagues
- Never put in shared documents
- Never email or message token

❌ **Don't store in insecure locations**
- Not in environment variables (shell history)
- Not in scripts (version control)
- Not in cloud storage (breach exposure)
- Not in email (cached by provider)

❌ **Don't commit to git**
- `.local.md` is in `.gitignore` for a reason
- If accidentally committed, revoke immediately
- Even private repos can be breached
- Push history is permanent

❌ **Don't log token values**
- Never log "Token is: $TOKEN"
- Never paste full token in tickets
- Never screenshot with token visible
- Never paste in unsecured chats

❌ **Don't use on untrusted machines**
- Public computers (libraries, internet cafes)
- Shared machines (without disk encryption)
- Machines with suspected malware
- If used, revoke token afterwards

## Monitoring for Compromise

### Signs Your Token May Be Compromised

1. **Unexpected Notion activity**
   - Pages modified you didn't change
   - New pages created
   - Content deleted

2. **Failed `/notion:validate` after working before**
   - Token was valid, now suddenly isn't
   - Suggests token was revoked externally
   - Could indicate compromise detection

3. **Unusual `/notion:troubleshoot` results**
   - Different errors than before
   - Permission suddenly denied
   - Connection issues that weren't there

### Immediate Response if Compromised

1. **Revoke the token immediately**
   - Notion → Settings → Connected Apps → Disconnect

2. **Check Notion activity log**
   - Go to Notion → Settings → Activity log
   - Look for unexpected changes
   - See if token was used to modify content

3. **Get a new token**
   - Run `/notion:setup`
   - Complete OAuth flow
   - New token is issued

4. **Restore any damaged content** (if needed)
   - Use Notion's version history
   - Restore from backup if available

5. **Change Notion password** (optional)
   - Ensures attacker cannot access Notion directly

6. **Check system security**
   - Scan for malware
   - Update all software
   - Consider password reset if machine is compromised

## Token Expiration (Or Lack Thereof)

### Notion OAuth Tokens Don't Expire

Unlike most OAuth providers (Google, GitHub, etc.):
- Notion tokens have no TTL (time to live)
- No expiration date
- Valid indefinitely until revoked

This is by design:
- Simplifies integration (no refresh token needed)
- Reduces API calls (no refresh mechanism)
- User has full control (can revoke anytime)

### Validation Timestamp Purpose

The `last_validated` field serves as a health check:
- Shows when token was last tested
- Not an expiration date
- Helps identify stale tokens
- Suggests re-validation if very old

## OAuth App Registration Details

Claude Code is registered with Notion as:

**Official Integration**
- Registered with Notion by Anthropic
- Verified and trusted by Notion
- Listed in Notion marketplace
- Has official Notion support

**Not a Third-Party Integration**
- Claude Code is first-party (made by Anthropic)
- Not a marketplace app (which may be risky)
- Not a custom integration (less tested)
- Official and well-tested

**Security Status**
- Regular security reviews
- Follows OAuth best practices
- Complies with Notion security standards
- Transparent about data handling

## Zero-Trust Verification

When authenticating with OAuth:

1. **Verify you're on Notion's site**
   - URL should be `notion.com` or subdomain
   - Check browser address bar
   - Notion uses HTTPS certificate

2. **Verify the consent screen is official**
   - Shows "Notion" as provider
   - Shows what permissions are requested
   - Shows Claude Code as requesting app

3. **Never enter credentials on third-party site**
   - OAuth redirects you to Notion
   - Never enter credentials on Claude Code site
   - Only official Notion gets your credentials

4. **Trust only official Notion integration**
   - Claude Code is official (made by Anthropic)
   - Verify in Notion's app marketplace
   - Don't use unofficial integrations for Notion auth
