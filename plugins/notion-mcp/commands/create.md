---
name: create
description: Create a new Notion page
arguments:
  - name: title
    description: Title for the new page
    required: true
  - name: parent
    description: Optional parent page ID or database ID
    required: false
entrypoint: bash
---

# Create a New Notion Page

This command creates a new page in your Notion workspace.

## Basic Usage

```
/notion:create "My New Page"
```

Creates a standalone page with the given title.

## Create in Database

```
/notion:create "New Task" --database "database-id"
```

Creates a new entry in the specified database.

## Create as Sub-Page

```
/notion:create "Sub-Page Title" --parent "parent-page-id"
```

Creates a page nested under the specified parent page.

## Getting Database/Parent IDs

### Find Database ID

```
1. /notion:search "database name"
   → Find the database
2. Extract ID from URL
   → Use with --database
```

### Find Parent Page ID

```
1. /notion:search "parent page name"
   → Find parent page
2. Extract ID from URL
   → Use with --parent
```

## Examples

### Create Standalone Page

```
/notion:create "Q1 Planning"
```

Result:
```
✓ Page created successfully

Title: Q1 Planning
URL: https://www.notion.so/Q1-Planning-abc123
ID: abc123def456

Ready to edit!
```

### Create Database Entry

```
/notion:create "Fix login bug" --database "task-database-id"
```

Result:
```
✓ Entry created in database

Title: Fix login bug
Database: Tasks
URL: https://www.notion.so/Fix-login-bug-xyz789
ID: xyz789abc123

Start editing in Notion
```

### Create Sub-Page

```
/notion:create "Implementation Notes" --parent "project-page-id"
```

Result:
```
✓ Sub-page created

Title: Implementation Notes
Parent: Project Page
URL: https://www.notion.so/Implementation-Notes-def456
ID: def456xyz789

Page is nested under parent
```

### Create with Complex Title

```
/notion:create "2026 Q1 Goals & Objectives"
```

Works with special characters in title.

## Common Use Cases

**Create Meeting Notes**
```
/notion:create "Team Standup - 2026-01-29"
```

Then:
```
/notion:write [new-page] "Topics discussed:
- Project status
- Blockers
- Next steps"
```

**Create Task**
```
/notion:create "Implement feature X" --database "tasks-db"
```

Creates new task entry in Tasks database.

**Create Project Page**
```
/notion:create "Project Codename: Alpha"
```

Then:
```
/notion:write [new-page] "## Overview
[Project description]

## Milestones
- Milestone 1
- Milestone 2"
```

**Create Sub-Page Structure**
```
1. /notion:create "Q1 Goals"
2. /notion:create "January" --parent "Q1-goals-id"
3. /notion:create "February" --parent "Q1-goals-id"
4. /notion:create "March" --parent "Q1-goals-id"

Creates hierarchical structure
```

**Create and Populate**
```
1. /notion:create "New Document"
2. /notion:write [new-page] "Initial content..."
3. /notion:write [new-page] "More content..."

Build up page content
```

## Output Information

After creation, you get:

- **Title:** The page title
- **URL:** Full Notion URL (shareable)
- **ID:** Page ID for other commands
- **Parent:** If created as sub-page
- **Database:** If created as entry

Use the URL or ID with other commands:
```
/notion:read [returned-url]
/notion:write [returned-id] "content"
```

## Limitations

**Cannot Create:**
- Archived pages
- Duplicate pages with same ID
- Pages with invalid characters in title

**Can Create:**
- Multiple pages with same title (different IDs)
- Sub-pages at any depth
- Pages in any database
- Pages with rich title formatting

## Database Entry Specifics

When creating database entry with `--database`:

- Creates new entry in database
- Creates with all default properties
- You can set properties after creation via `/notion:write`
- Entry immediately queryable with `/notion:query`

Example:
```
1. /notion:create "New Task" --database [task-db]
2. /notion:query [task-db] --filter "title equals 'New Task'"
   → Entry now found in queries
```

## Page Hierarchy

When creating sub-pages:

```
Parent Page
├── Sub-Page 1
│   └── Sub-Sub-Page 1
└── Sub-Page 2
```

Each can be at different nesting levels:
```
/notion:create "Sub-Sub" --parent "Sub-Page-1"
```

## Error Handling

**Missing Title**
```
✗ Title is required
Suggestion: Provide a page title
```

**Database Not Found**
```
✗ Database not found: [id]
Suggestion: Verify database ID is correct
```

**Invalid Parent**
```
✗ Parent page not found: [id]
Suggestion: Verify parent page ID is correct
```

**No Write Permission**
```
✗ Cannot create page: Permission denied
Suggestion: Check workspace role or database access
```

**Invalid Title Characters**
```
✗ Title contains invalid characters
Suggestion: Use standard characters in title
```

## Tips

**Always Get the URL**
```
Page created successfully
URL: https://www.notion.so/...

Save this URL for later use with /notion:read
```

**Create Then Populate**
```
1. Create page with title
2. Use returned URL with /notion:write to add content
3. Build page structure step by step
```

**Use in Workflows**
```
1. Create new page
2. Write initial content
3. Read back to verify
4. Add more content
5. Share URL
```

**Organize with Hierarchy**
```
Parent: Project X
├── Design
├── Development
└── Testing

Each sub-page organized by area
```

**Batch Creation**
```
Create multiple pages:
/notion:create "Item 1"
/notion:create "Item 2"
/notion:create "Item 3"

Then populate each
```

## Permissions

Requires **write access**:
- Workspace role (Editor/Owner)
- Database access if creating in database
- Parent page access if creating as sub-page

If `/notion:validate` shows write access confirmed, this command works.

## Performance

- Create standalone: <1 second
- Create database entry: <2 seconds
- Create sub-page: <1 second

Safe for batch creation if needed.

## Learn More

- **notion-mcp-tools** skill - Tool reference
- `/notion:read` command - Read pages
- `/notion:write` command - Add content
- `/notion:search` command - Find pages
