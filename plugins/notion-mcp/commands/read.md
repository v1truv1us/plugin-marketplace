---
name: read
description: Read content from a Notion page
arguments:
  - name: page_url_or_id
    description: URL or ID of the Notion page to read
    required: true
entrypoint: bash
---

# Read a Notion Page

This command reads the complete content of a Notion page.

## Basic Usage

```
/notion:read "https://www.notion.so/My-Page-abc123"
```

Or using just the page ID:

```
/notion:read "abc123def456"
```

## What Gets Read

The command returns:
- Page title
- All text blocks and formatting
- Lists, headings, code blocks, quotes
- Page properties (if database entry)
- Last edited timestamp
- Creation timestamp

## Examples

### Read by Full URL

```
/notion:read "https://www.notion.so/Project-Plan-a1b2c3d4e5f6"
```

Returns all content from that page.

### Read by Page ID

```
/notion:read "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6"
```

Same result with just the ID.

### Read Specific Database Entry

```
/notion:read "https://www.notion.so/Task-Item-xyz789"
```

If the page is a database entry, also returns:
- All property values
- Status, dates, relations, etc.
- Rich formatted content

## Getting Page URLs and IDs

### From Notion Web

1. Open the page in Notion
2. Click the share icon (top right)
3. Copy the page link
4. Use that URL with `/notion:read`

Or:
1. Look at browser URL: `https://www.notion.so/Page-Title-[ID]`
2. Extract the ID from the URL
3. Use with `/notion:read`

### From `/notion:search`

Use search to find pages, then read them:

```
/notion:search "project status"
→ Returns matching pages with URLs
→ Use URL with /notion:read
```

### From `/notion:query`

Query a database to get pages, then read them:

```
/notion:query [database-id]
→ Returns database entries
→ Use any page URL/ID with /notion:read
```

## Output Format

Page content is returned as structured blocks:

```
Page: "My Project"
Created: 2026-01-15
Last Edited: 2026-01-29

Content:
---
[Heading] Project Overview

[Paragraph] This is the main description of the project...

[Bulleted List]
- Item 1
- Item 2
- Item 3

[Heading 2] Timeline

[Paragraph] Project starts in Q2...

---
```

## Common Use Cases

**Get Page Text for Analysis**
```
/notion:read [page-url]
→ Read all text from page
→ Use for summarization, analysis, extraction
```

**Check Database Entry**
```
/notion:read [entry-url]
→ Read entry with all properties
→ See status, dates, assignments
```

**Review Project Plan**
```
/notion:read "https://www.notion.so/2026-Roadmap-..."
→ Get complete project details
→ See timeline, milestones, current status
```

**Fetch Meeting Notes**
```
/notion:read [meeting-notes-url]
→ Get all notes from meeting
→ Can summarize or extract action items
```

## Large Pages

For pages with many blocks (1000+):
- Reading may take a few seconds
- Content will still be fully returned
- No truncation
- All blocks included

## Error Handling

**Page Not Found**
```
✗ Page not found: [page-id]
Suggestion: Verify page ID/URL is correct
```
Check that the page URL/ID is correct.

**No Permission**
```
✗ Permission denied: Cannot read page
Suggestion: Verify you have read access to this page
```
Check that you have access in Notion workspace.

**Invalid URL/ID Format**
```
✗ Invalid page URL or ID format
Suggestion: Use full URL or 32-character page ID
```
Provide either full Notion URL or page ID.

**Token Invalid**
```
✗ Notion OAuth token not found or expired
Suggestion: Run /notion:setup to authenticate
```
Your token needs to be set up. Run `/notion:setup`

## Tips

**Extract Page ID from URL**
- Notion URL format: `https://www.notion.so/Title-[ID]`
- ID is the 32-character hex string at the end
- Everything before the dash is the title

**Read Frequently**
- No rate limiting for reasonable usage
- Safe to read many pages
- Can read same page multiple times

**Combine with Search**
```
1. /notion:search "keyword"
   → Find pages matching keyword
2. /notion:read [result-url]
   → Read matched page
```

**Combine with Query**
```
1. /notion:query [database-id]
   → Find database entries
2. /notion:read [entry-url]
   → Read specific entry details
```

## Permissions

Requires **read access** to the page:
- Your workspace role (Editor/Owner/Commenter/Viewer)
- Page sharing settings
- Database entry access

If `/notion:validate` shows read access confirmed, this command will work.

## Learn More

- **notion-mcp-tools** skill - Complete tool reference
- `/notion:search` command - Find pages by content
- `/notion:query` command - Find database entries
- `/notion:write` command - Add content to pages
