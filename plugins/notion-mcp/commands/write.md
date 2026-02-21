---
name: write
description: Add or update content in a Notion page
arguments:
  - name: page_url_or_id
    description: URL or ID of the Notion page to update
    required: true
  - name: content
    description: Text content to append to the page
    required: true
entrypoint: bash
---

# Write to a Notion Page

This command appends content to an existing Notion page.

## Basic Usage

```
/notion:write "https://www.notion.so/My-Page-abc123" "This is the content to add"
```

Or with page ID:

```
/notion:write "abc123def456" "Content to add"
```

## What Gets Written

The command:
- Appends blocks to the end of page
- Supports text, headings, lists, code blocks
- Formats content automatically
- Preserves existing content (adds to end)

## Content Formats

The command interprets content automatically:

**Plain Text**
```
/notion:write [page] "Just some text"
→ Added as paragraph block
```

**Multiple Lines**
```
/notion:write [page] "Line 1
Line 2
Line 3"
→ Added as multi-line paragraph
```

**Heading (prefix with #)**
```
/notion:write [page] "## Section Title"
→ Added as Heading 2 block
```

**List Items (prefix with -)**
```
/notion:write [page] "- Item 1
- Item 2
- Item 3"
→ Added as bulleted list
```

**Code (wrap in backticks)**
```
/notion:write [page] "```python
def hello():
    print('world')
```"
→ Added as code block with language detection
```

**Numbered List (prefix with 1.)**
```
/notion:write [page] "1. First
2. Second
3. Third"
→ Added as numbered list
```

## Examples

### Append Simple Note

```
/notion:write "https://www.notion.so/Daily-Log-abc123" "Completed project review meeting"
```

Added to page:
- Text: "Completed project review meeting"

### Append Structured Content

```
/notion:write "project-page-id" "## Status Update

- Q1 progress: 75%
- Q2 planning: In progress
- Blockers: Need designer resources"
```

Added as:
- Heading: "Status Update"
- Bulleted list with 3 items

### Append Code Example

```
/notion:write [page] "```javascript
const greeting = 'Hello from Claude!';
console.log(greeting);
```"
```

Added as code block with JavaScript syntax highlighting.

## Getting Page URLs/IDs

Same as `/notion:read`:
- Use full Notion URL from share button
- Or extract 32-character ID from URL
- Test with `/notion:read` first if unsure

## Common Use Cases

**Add Meeting Notes**
```
/notion:write [meeting-notes-page] "Meeting with team:
- Discussed Q1 goals
- Assigned action items
- Next meeting: Friday"
```

**Log Daily Progress**
```
/notion:write [daily-log] "## 2026-01-29

Completed:
- Reviewed pull requests
- Updated documentation

In Progress:
- Feature implementation
- Testing"
```

**Add Task to Database**
```
/notion:write [task-entry-page] "# Implementation Details

## Acceptance Criteria
- Must support mobile
- Must be accessible
- Performance < 100ms"
```

**Append Raw Data**
```
/notion:write [data-page] "Raw export from 2026-01-29:
[large data block]"
```

## Limitations

**Cannot:**
- Delete existing blocks
- Modify existing blocks (only append)
- Insert in middle (only end)
- Modify page properties (title, status, etc.)

**Can:**
- Append text, headings, lists, code
- Add multiple blocks in one command
- Use formatting and structure

If you need to modify existing content:
1. Read the page: `/notion:read [page]`
2. Copy all content
3. Create new page: `/notion:create [title]`
4. Write all content to new page
5. (Optional) Delete old page in Notion

## Error Handling

**Page Not Found**
```
✗ Page not found: [page-id]
Suggestion: Verify page ID/URL is correct
```

**No Write Permission**
```
✗ Permission denied: Cannot write to page
Suggestion: Check your workspace role or ask admin
```

**Token Invalid**
```
✗ Notion OAuth token not found or expired
Suggestion: Run /notion:setup to authenticate
```

**Content Too Large**
```
✗ Content exceeds maximum block size
Suggestion: Split content into smaller chunks
```

## Tips

**Combine with Read**
```
1. /notion:read [page]
   → Get existing content
2. /notion:write [page] "New content"
   → Add to that page
```

**Create Then Write**
```
1. /notion:create "New Page Title"
   → Create new page
2. /notion:write [new-page] "Initial content"
   → Add content
```

**Template Pattern**
```
1. Create page with title
2. Write structured template
3. Use as template for future content
```

**Batch Content**
```
# Add multiple blocks in one command
/notion:write [page] "## Section 1
Content for section 1

## Section 2
Content for section 2"
```

## Permissions

Requires **write access** to the page:
- Your workspace role (Editor/Owner)
- Page sharing settings (must allow edit)
- Commenter/Viewer roles cannot write

If `/notion:validate` shows write access confirmed, this command will work.

## Performance

- Writing single paragraph: <1 second
- Writing 10 blocks: <2 seconds
- Writing large content: 2-5 seconds
- Safe for regular use

## Learn More

- **notion-mcp-tools** skill - Tool reference
- `/notion:read` command - Read page content
- `/notion:create` command - Create new page
- `/notion:search` command - Find pages
