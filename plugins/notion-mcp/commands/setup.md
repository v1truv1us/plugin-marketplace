---
name: setup
description: Guide user through Notion OAuth authentication flow and store credentials
entrypoint: oauth-agent
---

# Setup Notion OAuth Authentication

This command guides you through the Notion OAuth authentication process, stores your credentials securely, and validates the connection.

## What This Does

`/notion:setup` will:

1. **Explain OAuth Flow** - Brief overview of what's happening
2. **Open Browser** - Navigate you to Notion's OAuth consent screen
3. **Store Token** - Save your OAuth token in `.claude/notion-mcp.local.md`
4. **Validate Connection** - Test read and write access
5. **Report Status** - Show whether setup succeeded

## How to Use

Run the command:
```
/notion:setup
```

Then:
1. **Approve Access** - Click "Allow" on Notion's consent screen
2. **Wait for Confirmation** - Browser redirects when complete
3. **Check Terminal** - See setup success/failure message

## What Gets Stored

After successful setup, `.claude/notion-mcp.local.md` contains:
- `notion_oauth_token` - Your OAuth access token
- `workspace_id` - Your Notion workspace ID
- `last_validated` - Timestamp of validation

**Note:** This file is in `.gitignore` and should never be committed to version control.

## If Setup Fails

Common issues and solutions:

**Issue: OAuth screen doesn't appear**
- Try different browser
- Check if popups are blocked
- Try `/notion:troubleshoot` for diagnostics

**Issue: Connection validation fails**
- Verify Notion workspace still exists
- Check your account has workspace access
- Run `/notion:troubleshoot` for details

**Issue: Token was stored but commands still fail**
- Run `/notion:validate` to check token
- Run `/notion:troubleshoot` for diagnostics
- May need to run `/notion:setup` again

## Next Steps

After successful setup:

1. **Verify Configuration**
   ```
   /notion:status
   ```
   Shows your configuration and workspace ID

2. **Validate Access**
   ```
   /notion:validate
   ```
   Tests read and write permissions

3. **Learn Available Tools**
   Use the `notion-mcp-tools` skill to understand what you can do

4. **Start Using**
   Use `/notion:read`, `/notion:write`, `/notion:search`, etc.

## Security Notes

- OAuth token is stored locally in `.claude/notion-mcp.local.md`
- This file is protected by `.gitignore` and OS file permissions
- Never share your token or commit the `.local.md` file
- You can revoke access anytime in Notion → Settings → Connected Apps
- See the `mcp-security` skill for detailed security guidance

## Troubleshooting

If you encounter issues:

```
/notion:troubleshoot
```

This command runs comprehensive diagnostics:
- Checks if token exists and is valid
- Tests connection to Notion
- Tests read access
- Tests write access
- Provides specific error messages and fixes

## Learn More

- **notion-mcp-setup** skill - Understanding OAuth and setup process
- **mcp-security** skill - Security best practices and token management
