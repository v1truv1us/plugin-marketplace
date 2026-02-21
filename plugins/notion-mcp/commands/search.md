---
name: search
description: Full-text search across your Notion workspace
arguments:
  - name: query
    description: Search text or keywords
    required: true
entrypoint: bash
---

# Search Notion Workspace

This command searches your entire Notion workspace for pages and databases matching your query.

## Basic Usage

```
/notion:search "project status"
```

Returns all pages matching "project status".

## What Gets Searched

Full-text search across:
- Page titles
- Page content (text, headings, lists)
- Database names
- Database entry property values
- All accessible pages in workspace

**Not searched:**
- Database formulas or rollups
- Hidden pages (not shared with you)
- Archived pages (unless you have access)

## Search Examples

### Simple Keyword Search

```
/notion:search "roadmap"
```

Returns:
- All pages with "roadmap" in title
- All pages mentioning "roadmap" in content
- Databases named "roadmap"

### Phrase Search

```
/notion:search "Q1 goals"
```

Returns pages matching both "Q1" and "goals".

### Browse Results

Results show:
- Page title
- Page URL
- Page type (page or database)
- Last edited timestamp
- Relevance ranking

### Find Specific Databases

```
/notion:search "project database"
```

Results include databases matching query.

## Output Format

```
✓ Search Results for "roadmap"

1. 2026 Roadmap
   Type: Page
   URL: https://www.notion.so/2026-Roadmap-abc123
   Last Edited: 2026-01-29
   Relevance: 95%

2. Product Roadmap Template
   Type: Database
   URL: https://www.notion.so/Templates-xyz789
   Last Edited: 2026-01-20
   Relevance: 89%

3. Q1 Goals (Archived)
   Type: Page
   URL: https://www.notion.so/Goals-def456
   Last Edited: 2025-12-15
   Relevance: 72%

Found 3 results
```

## Common Use Cases

**Find by Topic**
```
/notion:search "customer feedback"
→ Find all pages about customer feedback
```

**Find by Project**
```
/notion:search "project codename-xyz"
→ Find all pages mentioning that project
```

**Find by Date**
```
/notion:search "2026-01-29"
→ Find pages mentioning that date
```

**Find by Person**
```
/notion:search "Sarah Chen"
→ Find pages mentioning that person
```

**Find Templates**
```
/notion:search "template"
→ Find all template pages
```

**Find Meeting Notes**
```
/notion:search "meeting notes"
→ Find all meeting documentation
```

## Combining with Other Commands

**Search Then Read**
```
1. /notion:search "product launch"
   → Find pages about launch
2. /notion:read [result-url]
   → Read one of the results
```

**Search Then Analyze**
```
1. /notion:search "customer issues"
   → Find issue pages
2. For each result:
   /notion:read [url]
   → Analyze each issue
```

## Advanced Search Patterns

### Multiple Keywords

```
/notion:search "Q1 2026 goals"
```

Returns pages mentioning any of these terms.

### Negation (Using Syntax)

Search doesn't directly support "NOT" operator, but can:
1. Search for what you want
2. Manually filter results
3. Ignore irrelevant matches

### By Date Reference

```
/notion:search "January 2026"
→ Find pages mentioning that time period
```

## Limitations

**Search Does:**
- Find by title (excellent)
- Find by content (good)
- Find by properties (basic)
- Rank by relevance

**Search Doesn't:**
- Filter by property value (use `/notion:query`)
- Filter by database type
- Filter by workspace section
- Support complex boolean operators

**For filtered searches, use `/notion:query` instead**

## When to Use Search vs Query

| Need | Search | Query |
|------|--------|-------|
| Find by text/content | ✓ Best | Possible |
| Find by property (status, date) | No | ✓ Best |
| Find by title | ✓ Best | Possible |
| Explore workspace | ✓ Best | Limited |
| Structured filtering | No | ✓ Best |

**Search: Good for exploration**
**Query: Good for structured filtering**

## Performance

- Fast searches (<2 seconds)
- Workspace-wide search
- No pagination limits (gets all results)
- Regular search pattern efficient

## Error Handling

**Empty Results**
```
No results found for "xyz123"
Suggestion: Try different keywords or check spelling
```

**No Access to Some Pages**
- Search only returns pages you can access
- Private pages not in workspace don't appear
- Shared pages will appear

**Network Error**
```
✗ Search failed: Connection timeout
Suggestion: Check internet connection and try again
```

## Tips

**Start Simple**
```
/notion:search "team"
→ Get all pages mentioning "team"
→ Refine if too many results
```

**Use Multi-Word Queries**
```
✓ /notion:search "Q1 goals planning"
→ More specific results
✗ /notion:search "goals"
→ Too many results
```

**Combine with Other Commands**
```
1. /notion:search [topic]
   → Find relevant pages
2. /notion:read [best-result]
   → Read the main page
3. /notion:write [page] "Summary: ..."
   → Add summary to page
```

**Explore Before Querying**
```
1. /notion:search "database name"
   → Find the database
2. /notion:query [database-id] --filter "status equals Done"
   → Then query with filters
```

## Learn More

- **notion-mcp-tools** skill - Tool reference
- `/notion:read` command - Read found pages
- `/notion:query` command - Filtered database search
- `/notion:write` command - Update pages
