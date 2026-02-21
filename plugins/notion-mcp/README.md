# Notion MCP Plugin

Read and write to Notion documents using the official Notion MCP server with secure OAuth authentication.

## Overview

This plugin enables seamless integration with Notion through Claude Code using the official Notion MCP (Model Context Protocol) server. It guides you through OAuth setup, validates your connection, and provides commands to read, write, search, and query your Notion workspace.

## Features

- **OAuth Authentication**: Secure user-based authentication (no hardcoded tokens)
- **Setup & Validation**: Interactive setup wizard and connection testing
- **Read Operations**: Access Notion pages and databases
- **Write Operations**: Create and update Notion content
- **Search & Query**: Full-text search and structured database queries
- **Security Focus**: Pre-tool validation and credential protection
- **Error Handling**: Helpful error messages and troubleshooting guidance

## Prerequisites

- Claude Code installed and configured
- A Notion workspace (free or paid)
- Ability to complete OAuth flow in browser

## Quick Start

### 1. Setup OAuth Connection

```bash
/notion:setup
```

This interactive command will:
- Guide you through Notion's OAuth flow
- Store your authentication token securely in `.claude/notion-mcp.local.md`
- Validate the connection

### 2. Validate Your Connection

```bash
/notion:validate
```

Tests read and write access to your Notion workspace.

### 3. Check Status

```bash
/notion:status
```

Shows your current Notion connection status and configuration.

### 4. Use Notion Commands

Once configured, use any of these commands:

- **`/notion:read`** - Read a Notion page by URL or ID
- **`/notion:write`** - Write or update content in Notion
- **`/notion:search`** - Full-text search across Notion
- **`/notion:query`** - Query a Notion database with filters
- **`/notion:create`** - Create new Notion pages or entries

## Authentication & Security

This plugin uses **OAuth-based authentication** as recommended by Notion:

- ✅ User-based authorization (not token-based)
- ✅ Secure token storage in local config
- ✅ Pre-tool validation of credentials
- ✅ Clear security warnings

**Important**: The OAuth token is stored in `.claude/notion-mcp.local.md`. Keep this file private and never commit it to version control.

## Configuration

OAuth credentials are stored in:
```
.claude/notion-mcp.local.md
```

This file contains:
- OAuth access token
- Workspace ID
- Last validation timestamp

**Never commit this file to git.** It's automatically added to `.gitignore`.

## Troubleshooting

If you encounter connection issues:

```bash
/notion:troubleshoot
```

This command will:
- Check credential status
- Test connection to Notion
- Diagnose common issues
- Suggest fixes

## Learn More

Use the built-in skills to learn more:

- **Notion MCP Setup** - Understanding OAuth and setup process
- **Notion MCP Tools** - Reference guide to all available tools
- **MCP Security** - Security best practices

## Notion MCP Documentation

For more information about Notion MCP capabilities, see:
[Notion MCP Guide](https://developers.notion.com/guides/mcp/mcp)

## License

MIT
