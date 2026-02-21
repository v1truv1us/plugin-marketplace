---
name: query
description: Query a Notion database with filters and sorting
arguments:
  - name: database_id
    description: ID or URL of the Notion database to query
    required: true
  - name: filter
    description: Optional filter condition (e.g., 'status equals Done')
    required: false
  - name: sort
    description: Optional sort order (e.g., 'created descending')
    required: false
entrypoint: bash
---

# Query a Notion Database

This command searches a database with optional filters and sorting.

## Basic Usage

```
/notion:query "database-id"
```

Returns all entries in the database.

## With Filters

```
/notion:query "database-id" --filter "status equals Done"
```

Returns only entries matching the filter.

## With Sorting

```
/notion:query "database-id" --sort "due_date ascending"
```

Returns entries sorted by due date (earliest first).

## Getting Database IDs

### From Notion URL

Database URL format:
```
https://www.notion.so/Workspace-Name-[ID]?v=[VIEW-ID]
```

Extract the database ID (32 characters before `?v=`)

### From /notion:search

```
1. /notion:search "database name"
   → Find the database
2. Use URL or extract ID
   → Use with /notion:query
```

### Copy Share Link

1. Open database in Notion
2. Click share button
3. Copy link
4. Extract ID from URL

## Filter Examples

### By Status

```
/notion:query [db-id] --filter "status equals Done"
→ Get all completed items
```

**Status options:** Done, In Progress, Not Started, Archived

### By Date

```
/notion:query [db-id] --filter "due_date before 2026-02-01"
→ Get items due before Feb 1
```

**Date operators:** equals, before, after, on_or_before, on_or_after

### By Text Match

```
/notion:query [db-id] --filter "title contains urgent"
→ Get items with "urgent" in title
```

**Text operators:** equals, contains, starts_with, ends_with

### By Multiple Conditions (AND)

```
/notion:query [db-id] --filter "status equals Done AND due_date before 2026-02-01"
→ Get completed items due before Feb 1
```

### By Multiple Conditions (OR)

```
/notion:query [db-id] --filter "status equals Done OR status equals Archived"
→ Get done or archived items
```

## Sort Examples

### By Date Ascending (Earliest First)

```
/notion:query [db-id] --sort "due_date ascending"
→ Items sorted by due date
```

### By Date Descending (Latest First)

```
/notion:query [db-id] --sort "created_time descending"
→ Newest items first
```

### By Text Alphabetically

```
/notion:query [db-id] --sort "name ascending"
→ Items A-Z by name
```

### By Number (Highest First)

```
/notion:query [db-id] --sort "priority descending"
→ Highest priority items first
```

## Combined Examples

### Find High Priority Done Items

```
/notion:query [db-id] --filter "status equals Done AND priority greater_than 7"
→ Shows completed high-priority items
```

### Find Overdue Incomplete Tasks

```
/notion:query [db-id] --filter "status does_not_equal Done AND due_date before 2026-01-29"
→ Shows incomplete overdue items
```

### Find and Sort by Status

```
/notion:query [db-id] --filter "assigned_to contains me" --sort "due_date ascending"
→ My tasks sorted by due date
```

## Output Format

```
✓ Query Results

Total: 5 items found

1. Design Homepage
   Status: In Progress
   Due: 2026-02-01
   Priority: 8

2. Review Code
   Status: Done
   Due: 2026-01-29
   Priority: 7

... more items ...
```

## Common Use Cases

**Get Assigned Tasks**
```
/notion:query [task-db] --filter "assigned_to equals me"
→ All tasks assigned to me
```

**Find Overdue Items**
```
/notion:query [project-db] --filter "due_date before today"
→ All overdue items
```

**Get This Week's Tasks**
```
/notion:query [task-db] --filter "due_date >= 2026-01-29 AND due_date <= 2026-02-04"
→ Tasks due this week
```

**Find Not Started Items**
```
/notion:query [db-id] --filter "status equals Not Started"
→ Items to start
```

**Get High Priority**
```
/notion:query [db-id] --filter "priority >= 8" --sort "due_date ascending"
→ High priority sorted by due date
```

**Review Recent Changes**
```
/notion:query [db-id] --sort "last_edited descending"
→ Recently modified items first
```

## Limitations

**Filter operators vary by property type:**
- **Text:** equals, contains, starts_with, ends_with
- **Date:** equals, before, after, on_or_before, on_or_after
- **Number:** equals, greater_than, less_than
- **Select:** equals, does_not_equal
- **Checkbox:** equals, does_not_equal

See **notion-mcp-tools** skill for complete filter reference.

## Combining with Other Commands

**Query Then Read**
```
1. /notion:query [db-id] --filter "status equals Done"
   → Get all done items
2. /notion:read [first-result]
   → Read detailed content
```

**Query Then Update**
```
1. /notion:query [db-id] --filter "assigned_to is empty"
   → Get unassigned items
2. /notion:write [item] "Assignment: Sarah"
   → Update with assignment
```

**Query Then Summarize**
```
1. /notion:query [db-id] --filter "status equals Done"
   → Get completed items
2. For each item: /notion:read
   → Read details
3. Summarize findings
```

## Performance

- Fast queries (<3 seconds typical)
- Returns all matching results
- Supports large databases (1000+ entries)
- Efficient sorting and filtering

## Error Handling

**Database Not Found**
```
✗ Database not found: [id]
Suggestion: Verify database ID/URL is correct
```

**Filter Syntax Error**
```
✗ Invalid filter syntax
Suggestion: Check filter format matches property type
```

**Property Doesn't Exist**
```
✗ Property not found: [property-name]
Suggestion: Use get_database to see available properties
```

## Tips

**Start Simple**
```
1. /notion:query [db-id]
   → Get all items
2. Then add filters
   → Narrow down results
```

**Learn Database Structure First**
```
# See what properties are available
/notion:search [database-name]
/notion:read [database-url]
# Then write query based on properties
```

**Use Descriptive Properties**
- Filter by status instead of text
- Filter by date instead of word match
- More reliable and efficient

**Combine Conditions Wisely**
```
✓ Complex: "status equals Done AND due_date before date"
✗ Vague: "contains urgent or priority high"
→ Be specific with filters
```

## Get Help

For detailed filter syntax and property types:
- See **notion-mcp-tools** skill
- Check filter-syntax.md reference
- Try simple query first, then add filters

## Learn More

- **notion-mcp-tools** skill - Complete filter reference
- `/notion:read` command - Read database entries
- `/notion:search` command - Full-text search
- `/notion:write` command - Update entries
