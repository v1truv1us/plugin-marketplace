---
name: notion-mcp-tools
description: This skill should be used when the user asks to "what Notion MCP tools are available", "how to use read_page", "Notion MCP tool reference", "when to use query_database", "Notion MCP capabilities", or needs a guide to what operations are possible with Notion MCP. Provides reference to all available tools and when to use each.
version: 0.1.0
---

# Notion MCP Tools Reference

## Available Tools Overview

Notion MCP provides the following tools for reading and writing Notion content:

| Tool | Purpose | Use When |
|------|---------|----------|
| **read_page** | Get full content of a page | Need to read a specific page's text, blocks, metadata |
| **query_database** | Search/filter database entries | Need to find items in a database with conditions |
| **search** | Full-text search workspace | Need to find content across entire workspace |
| **append_block** | Add content to a page | Need to write or update page content |
| **create_page** | Create new page in workspace | Need to add new page to workspace or database |
| **get_database** | Get database structure/schema | Need to understand database properties |

## Quick Reference by Task

### Reading Content

**Task: Read a specific page**
→ Use `read_page`
- Provide: Page ID or URL
- Returns: Full page content, blocks, properties

**Task: Find pages by title or content**
→ Use `search`
- Provide: Search query (text or keywords)
- Returns: Matching pages, relevance ranking

**Task: Get items from database**
→ Use `query_database`
- Provide: Database ID and optional filters
- Returns: Matching entries with properties

**Task: Understand database structure**
→ Use `get_database`
- Provide: Database ID
- Returns: Schema, properties, field types

### Writing Content

**Task: Add text/blocks to existing page**
→ Use `append_block`
- Provide: Page ID and block content
- Returns: Success confirmation

**Task: Create new page**
→ Use `create_page`
- Provide: Title and optional parent page/database
- Returns: New page URL and ID

## Detailed Tool Specifications

### read_page

Read the complete content of a Notion page.

**When to use:**
- Need full page content for analysis or processing
- Want to read specific page details
- Building on existing page content

**Parameters:**
- `page_id` (required): Notion page ID or full URL
- Returns page content, metadata, blocks

**Example:**
```
/notion:read "https://www.notion.so/My-Page-abc123def456"
```

Returns:
- Page title
- All blocks (text, headings, lists, etc.)
- Properties (if database entry)
- Last edited timestamp

**Limitations:**
- Cannot read archived pages
- Requires read access to page
- Large pages (1000+ blocks) may take time

### query_database

Query a Notion database with filters and sorting.

**When to use:**
- Need to find specific database entries
- Want to filter by properties (status, date, etc.)
- Need to sort results
- Building lists or reports

**Parameters:**
- `database_id` (required): Database ID
- `filter` (optional): Filter conditions
- `sorts` (optional): Sort order

**Example:**
```
/notion:query <database-id>
```

With filtering:
```
/notion:query <database-id> --filter "status equals Done"
```

Returns:
- Matching database entries
- Entry properties
- Count of results

**Filter Operators:**
- `equals` - Exact match
- `contains` - Substring match
- `starts_with` - Prefix match
- `greater_than` - Numeric comparison
- `before`, `after` - Date comparison

### search

Full-text search across entire Notion workspace.

**When to use:**
- Don't know which page/database contains content
- Searching by keywords or phrases
- Need to find content by title or text
- Exploring workspace structure

**Parameters:**
- `query` (required): Search text or keywords
- Returns matching pages and databases

**Example:**
```
/notion:search "project status"
```

Returns:
- Pages matching "project status"
- Databases with related content
- Relevance ranking
- Page URLs

**Search Capabilities:**
- Searches page titles
- Searches page text content
- Searches database property values
- Case-insensitive matching

### append_block

Add content (blocks) to a Notion page.

**When to use:**
- Adding text to existing page
- Creating checklist or list items
- Adding images or files
- Appending structured content

**Parameters:**
- `page_id` (required): Page to append to
- `blocks` (required): Content to add

**Example:**
```
/notion:write <page-id> "This is new content"
```

Returns:
- Confirmation of added blocks
- Block IDs of created content
- Updated page structure

**Block Types Supported:**
- Paragraph text
- Headings (H1, H2, H3)
- Bulleted/numbered lists
- Checkboxes
- Code blocks
- Quotes

**Limitations:**
- Can only append (add to end)
- Cannot delete existing blocks
- Cannot modify existing blocks
- Requires write access

### create_page

Create a new Notion page.

**When to use:**
- Adding new items to database
- Creating sub-pages
- Generating content from templates
- Building pages from scratch

**Parameters:**
- `title` (required): Page title
- `parent` (optional): Parent page or database ID
- `properties` (optional): Database properties

**Example:**
```
/notion:create "My New Page"
```

With parent:
```
/notion:create "Task Item" --database <db-id>
```

Returns:
- New page URL
- Page ID
- Confirmation with timestamps

**Database Integration:**
- If parent is database, creates entry
- Can set property values
- Returns with properties set

**Limitations:**
- Cannot create deleted pages
- Cannot create in archived workspace
- Requires write access

### get_database

Retrieve database structure and schema.

**When to use:**
- Understanding database properties
- Planning database queries
- Checking available filter fields
- Validating property types

**Parameters:**
- `database_id` (required): Database ID
- Returns database schema

**Example:**
```
curl -H "Authorization: Bearer TOKEN" \
  https://api.notion.com/v1/databases/<db-id>
```

Returns:
- Database title
- All properties and their types
- Property constraints
- Database configuration

**Property Types Available:**
- Text (short or long)
- Number (integer or decimal)
- Select (single or multiple)
- Date
- Checkbox
- URL
- Email
- Phone
- Status
- Relation to other databases

## Tool Combinations (Workflows)

### Workflow: Read and Analyze Page

1. `read_page` - Get page content
2. Parse content locally
3. Extract insights or data

### Workflow: Query and Modify

1. `query_database` - Find matching entries
2. For each entry:
   - `read_page` - Get full details
   - `append_block` - Add notes or updates

### Workflow: Search and Migrate

1. `search` - Find all pages with keyword
2. For each result:
   - `read_page` - Get content
   - `create_page` - Create in new location
   - `append_block` - Add migrated content

### Workflow: Database Reporting

1. `get_database` - Understand structure
2. `query_database` - Get filtered entries
3. `read_page` - Get details for each entry
4. Process and generate report

## Tool Constraints and Gotchas

### Rate Limiting
Notion API has rate limits:
- Max 3 requests per second per user
- Max 100 requests per 30 seconds
- Commands handle retries automatically

### Large Results
Some operations return large datasets:
- `search` across huge workspace: slow
- `query_database` with many results: paginated
- `read_page` with 1000+ blocks: takes time

### Permission Requirements

| Tool | Read | Write |
|------|------|-------|
| read_page | ✓ | - |
| query_database | ✓ | - |
| search | ✓ | - |
| get_database | ✓ | - |
| append_block | - | ✓ |
| create_page | - | ✓ |

### Page Types

Some pages have restrictions:
- Archived pages: cannot read or write
- Template pages: limited access
- Database views: handled automatically

## Additional Resources

For more details:

- **`references/tool-specifications.md`** - Complete API specifications
- **`references/filter-syntax.md`** - Advanced filtering syntax
- **`references/error-reference.md`** - Error codes and solutions

See the notion-mcp-setup skill to understand OAuth and setup.

See the mcp-security skill for permission and security details.
