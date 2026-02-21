# Notion MCP Plugin - Developer Guide

## Overview

The Notion MCP plugin is a Claude Code integration that enables secure, OAuth-based read/write access to Notion documents and databases.

**Key Architecture:**
- **OAuth Agent** - Guides users through secure authentication
- **Connection Validator** - Tests and troubleshoots Notion connectivity
- **Notion MCP Server** - Official Notion MCP with stored OAuth token
- **Commands** - User-facing tools for Notion operations
- **Skills** - Learning resources about MCP and Notion

## Component Structure

```
notion-mcp/
├── .claude-plugin/plugin.json          # Plugin manifest
├── commands/                            # 9 user-facing commands
│   ├── setup.md                        # /notion:setup
│   ├── validate.md                     # /notion:validate
│   ├── status.md                       # /notion:status
│   ├── troubleshoot.md                 # /notion:troubleshoot
│   ├── read.md                         # /notion:read
│   ├── write.md                        # /notion:write
│   ├── search.md                       # /notion:search
│   ├── query.md                        # /notion:query
│   └── create.md                       # /notion:create
├── agents/                              # 2 specialized agents
│   ├── oauth-agent.md                  # OAuth setup & storage
│   └── connection-validator-agent.md   # Testing & troubleshooting
├── skills/                              # 3 learning resources
│   ├── notion-mcp-setup/
│   │   └── SKILL.md
│   ├── notion-mcp-tools/
│   │   └── SKILL.md
│   └── mcp-security/
│       └── SKILL.md
├── hooks/
│   └── hooks.json                      # Pre-tool-use validation
├── .mcp.json                           # Notion MCP server config
└── scripts/                            # Utility scripts
    ├── validate-token.sh               # Check OAuth token validity
    └── test-connection.sh              # Test Notion connectivity
```

## Data Flow

### Initial Setup
```
User: /notion:setup
  ↓
oauth-agent
  ├─ Explain OAuth flow
  ├─ Direct to Notion OAuth consent screen
  ├─ Receive and store token in .claude/notion-mcp.local.md
  └─ Run connection validation
  ↓
connection-validator-agent
  ├─ Test token validity
  ├─ Test read access
  ├─ Test write access
  └─ Report status
```

### Tool Usage
```
User: /notion:read [page-id]
  ↓
Pre-tool-use hook validates credentials
  ├─ Check token exists in .claude/notion-mcp.local.md
  ├─ Check token is recent (not expired)
  └─ Block if invalid, suggest /notion:setup
  ↓
Command executes Notion MCP tool
  ├─ Loads OAuth token from local config
  ├─ Calls official Notion MCP server
  ├─ Returns result or helpful error
```

## Credential Storage

OAuth token stored in: `.claude/notion-mcp.local.md`

Format:
```yaml
---
notion_oauth_token: "notion_oauth_..."
workspace_id: "workspace-uuid"
last_validated: "2024-01-29T10:30:00Z"
---

# Notion MCP Configuration

This file contains your Notion OAuth token. Keep it private!
```

**Why `.local.md`:**
- Automatically ignored by git (see .gitignore)
- Uses YAML frontmatter for structured config
- Human-readable for debugging
- Follows Claude Code plugin conventions

## Command Implementation

### Setup Commands

**`/notion:setup`**
- Invokes oauth-agent to guide OAuth flow
- Stores token in recommended location
- Runs validation automatically
- Returns setup status

**`/notion:validate`**
- Calls connection-validator-agent
- Tests read and write access
- Reports detailed status
- Suggests fixes if issues found

**`/notion:status`**
- Shows current configuration
- Indicates if credentials are valid
- Lists workspace ID and last validation time
- Quick health check

**`/notion:troubleshoot`**
- Invokes connection-validator-agent with diagnosis mode
- Tests each component of the connection
- Provides specific error messages
- Suggests remediation steps

### Usage Commands

**`/notion:read`**
- Accepts Notion page URL or ID
- Uses Notion MCP read-page tool
- Returns formatted page content
- Handles errors gracefully

**`/notion:write`**
- Accepts page ID and content
- Uses Notion MCP append-block tool
- Updates or creates content
- Validates before writing

**`/notion:search`**
- Accepts search query
- Uses Notion MCP search tool
- Returns matching pages/databases
- Supports filters

**`/notion:query`**
- Accepts database ID and filter
- Uses Notion MCP query-database tool
- Supports sorting and pagination
- Returns structured results

**`/notion:create`**
- Accepts title and optional parent page ID
- Creates new Notion page
- Returns new page URL
- Optional: specify page properties

## Error Handling Strategy

All commands follow this error handling pattern:

```
Try operation
├─ Success → Return result
└─ Failure
   ├─ Check if credential issue
   │   └─ Suggest: /notion:setup or /notion:troubleshoot
   ├─ Check if permission issue
   │   └─ Suggest: Check OAuth scopes in Notion
   ├─ Check if API error
   │   └─ Show API error + suggest /notion:troubleshoot
   └─ Provide helpful message
```

## Hooks Configuration

**Pre-Tool-Use Hook** validates Notion credentials before any MCP tool execution:

```json
{
  "PreToolUse": [{
    "matcher": ".*notion.*",
    "hooks": [{
      "type": "prompt",
      "prompt": "Check if Notion OAuth token exists and is valid...",
      "timeout": 10
    }]
  }]
}
```

## Skills Design

### 1. Notion MCP Setup (notion-mcp-setup/SKILL.md)
- What is Notion MCP?
- Why OAuth is required
- Step-by-step OAuth flow explanation
- Why full automation isn't supported

### 2. Notion MCP Tools (notion-mcp-tools/SKILL.md)
- Reference guide to all Notion MCP tools
- When to use each tool
- Example usage for common operations
- Links to official Notion API docs

### 3. MCP Security (mcp-security/SKILL.md)
- Why validate before tool use
- Credential storage best practices
- What the pre-tool-use hook does
- When to rotate tokens

## Testing the Plugin

### Manual Testing Checklist

- [ ] `/notion:setup` - OAuth flow and credential storage
- [ ] `/notion:validate` - Connection validation works
- [ ] `/notion:status` - Shows correct status
- [ ] `/notion:read [page-id]` - Can read a page
- [ ] `/notion:write [page-id] [content]` - Can write content
- [ ] `/notion:search [query]` - Can search pages
- [ ] `/notion:query [db-id]` - Can query database
- [ ] `/notion:create [title]` - Can create page
- [ ] `/notion:troubleshoot` - Provides helpful diagnostics
- [ ] Credential validation hook blocks invalid tokens

### Testing with Invalid Credentials

- Remove/corrupt token in `.claude/notion-mcp.local.md`
- Try `/notion:read` → Should be blocked by pre-tool-use hook
- Run `/notion:setup` to restore
- Verify commands work again

## Future Enhancements

1. **Batch Operations** - Update multiple pages at once
2. **Database Management** - Create/modify database structures
3. **Comments** - Read/write Notion comments
4. **Webhooks** - React to Notion changes
5. **Caching** - Cache frequently accessed pages
6. **Multi-Workspace** - Support multiple Notion workspaces

## Debugging

**Enable debug output:**
```bash
cc --debug --plugin-dir ./plugins/notion-mcp
```

**Check credential file:**
```bash
cat .claude/notion-mcp.local.md
```

**Test Notion MCP directly:**
```bash
# See if MCP server is accessible
echo "Testing Notion MCP..."
```

## Security Considerations

1. **OAuth Token Storage**: Never commit `.claude/notion-mcp.local.md`
2. **Pre-Tool Validation**: Always check credentials before tool use
3. **User Interaction**: OAuth requires browser interaction (secure)
4. **Scope Limitations**: MCP server operates with user's Notion permissions
5. **Error Messages**: Don't expose token in error logs

## References

- [Notion MCP Official Guide](https://developers.notion.com/guides/mcp/mcp)
- [Claude Code Plugin Development](https://code.claude.com/docs)
- [OAuth Best Practices](https://oauth.net/2/security/)

---

**Last Updated**: 2026-01-29
**Version**: 0.1.0
**Status**: In Development
