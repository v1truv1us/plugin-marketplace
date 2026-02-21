# Tool Specifications

## API Endpoint Reference

All Notion MCP tools map to Notion API v1 endpoints:
- Base URL: `https://api.notion.com/v1`
- Authentication: Bearer token in Authorization header
- Content-Type: `application/json`

## read_page Specification

**Notion API Endpoint:** `GET /pages/{page_id}/blocks`

**Parameters:**
```json
{
  "page_id": "string (required)",
  "page_size": "integer (optional, 1-100, default 100)"
}
```

**Response:**
```json
{
  "object": "list",
  "results": [
    {
      "object": "block",
      "id": "string",
      "type": "paragraph|heading_1|...",
      "created_time": "2026-01-29T10:30:00.000Z",
      "last_edited_time": "2026-01-29T10:30:00.000Z",
      "created_by": { "object": "user", "id": "..." },
      "last_edited_by": { "object": "user", "id": "..." },
      "[block_type]": { /* block content */ }
    }
  ],
  "next_cursor": "string or null"
}
```

**Block Types Returned:**
- `paragraph` - Text content with formatting
- `heading_1`, `heading_2`, `heading_3` - Headings
- `bulleted_list_item` - List item
- `numbered_list_item` - Numbered item
- `to_do` - Checkbox item
- `code` - Code block
- `quote` - Quote block
- `divider` - Horizontal line
- `image` - Embedded image
- `file` - File attachment
- `child_page` - Sub-page
- `child_database` - Sub-database

**Pagination:**
- Results include `next_cursor` if more blocks exist
- Use cursor to fetch subsequent blocks
- Commands handle pagination automatically

**Error Responses:**
- 404: Page not found
- 403: No permission to read page
- 429: Rate limit exceeded
- 500: Server error

## query_database Specification

**Notion API Endpoint:** `POST /databases/{database_id}/query`

**Request Body:**
```json
{
  "filter": {
    "property": "Status",
    "select": {
      "equals": "Done"
    }
  },
  "sorts": [
    {
      "property": "Created",
      "direction": "descending"
    }
  ],
  "start_cursor": "string (optional)",
  "page_size": "integer (1-100, default 100)"
}
```

**Response:**
```json
{
  "object": "list",
  "results": [
    {
      "object": "page",
      "id": "string",
      "created_time": "2026-01-29T10:30:00.000Z",
      "last_edited_time": "2026-01-29T10:30:00.000Z",
      "created_by": { "object": "user", "id": "..." },
      "parent": { "type": "database_id", "database_id": "..." },
      "archived": false,
      "properties": {
        "Name": { "id": "title", "type": "title", "title": [...] },
        "Status": { "id": "status", "type": "status", "status": {...} },
        // ... other properties
      }
    }
  ],
  "next_cursor": "string or null"
}
```

**Filter Types:**
Each property type supports different filters:

**Text Filter:**
```json
{
  "property": "Title",
  "rich_text": {
    "equals": "value",
    "contains": "substring",
    "starts_with": "prefix",
    "ends_with": "suffix",
    "does_not_equal": "value",
    "does_not_contain": "substring",
    "is_empty": true,
    "is_not_empty": false
  }
}
```

**Number Filter:**
```json
{
  "property": "Count",
  "number": {
    "equals": 5,
    "does_not_equal": 5,
    "greater_than": 5,
    "less_than": 5,
    "greater_than_or_equal_to": 5,
    "less_than_or_equal_to": 5,
    "is_empty": true
  }
}
```

**Checkbox Filter:**
```json
{
  "property": "Complete",
  "checkbox": {
    "equals": true,
    "does_not_equal": false
  }
}
```

**Date Filter:**
```json
{
  "property": "Due Date",
  "date": {
    "equals": "2026-01-29",
    "before": "2026-02-01",
    "after": "2026-01-28",
    "on_or_before": "2026-01-29",
    "on_or_after": "2026-01-29",
    "past_week": {},
    "past_month": {},
    "past_year": {}
  }
}
```

**Select Filter:**
```json
{
  "property": "Status",
  "select": {
    "equals": "Done",
    "does_not_equal": "Done"
  }
}
```

**Relation Filter:**
```json
{
  "property": "Related To",
  "relation": {
    "contains": "page-id",
    "does_not_contain": "page-id"
  }
}
```

**Compound Filter (AND/OR):**
```json
{
  "and": [
    { "property": "Status", "select": { "equals": "Done" } },
    { "property": "Priority", "select": { "equals": "High" } }
  ]
}
```

```json
{
  "or": [
    { "property": "Status", "select": { "equals": "Done" } },
    { "property": "Status", "select": { "equals": "Archived" } }
  ]
}
```

## search Specification

**Notion API Endpoint:** `POST /search`

**Request Body:**
```json
{
  "query": "search text",
  "sort": {
    "direction": "ascending|descending",
    "timestamp": "last_edited_time"
  },
  "filter": {
    "value": "page|database",
    "property": "object"
  },
  "start_cursor": "string (optional)",
  "page_size": "integer (1-100, default 100)"
}
```

**Response:**
```json
{
  "object": "list",
  "results": [
    {
      "object": "page|database",
      "id": "string",
      "created_time": "2026-01-29T10:30:00.000Z",
      "last_edited_time": "2026-01-29T10:30:00.000Z",
      "title": "string",
      "properties": { /* if page */ }
    }
  ],
  "next_cursor": "string or null"
}
```

**Sorting Options:**
- `last_edited_time` with `ascending` (oldest first)
- `last_edited_time` with `descending` (newest first)

**Filter Options:**
- `object` filter with value `"page"` (only pages)
- `object` filter with value `"database"` (only databases)
- No filter (both pages and databases)

## append_block Specification

**Notion API Endpoint:** `PATCH /blocks/{page_id}/children`

**Request Body:**
```json
{
  "children": [
    {
      "object": "block",
      "type": "paragraph",
      "paragraph": {
        "rich_text": [
          {
            "type": "text",
            "text": { "content": "Block text" }
          }
        ]
      }
    }
  ]
}
```

**Block Creation Examples:**

**Paragraph:**
```json
{
  "object": "block",
  "type": "paragraph",
  "paragraph": {
    "rich_text": [
      {
        "type": "text",
        "text": { "content": "Paragraph content" }
      }
    ]
  }
}
```

**Heading 1:**
```json
{
  "object": "block",
  "type": "heading_1",
  "heading_1": {
    "rich_text": [
      {
        "type": "text",
        "text": { "content": "Heading text" }
      }
    ]
  }
}
```

**Bulleted List Item:**
```json
{
  "object": "block",
  "type": "bulleted_list_item",
  "bulleted_list_item": {
    "rich_text": [
      {
        "type": "text",
        "text": { "content": "List item" }
      }
    ]
  }
}
```

**Code Block:**
```json
{
  "object": "block",
  "type": "code",
  "code": {
    "rich_text": [
      {
        "type": "text",
        "text": { "content": "code here" }
      }
    ],
    "language": "python"
  }
}
```

**To-Do (Checkbox):**
```json
{
  "object": "block",
  "type": "to_do",
  "to_do": {
    "rich_text": [
      {
        "type": "text",
        "text": { "content": "Task to do" }
      }
    ],
    "checked": false
  }
}
```

**Response:**
```json
{
  "object": "list",
  "results": [
    {
      "object": "block",
      "id": "string",
      "type": "paragraph",
      "created_time": "2026-01-29T10:30:00.000Z"
    }
  ]
}
```

**Limitations:**
- Maximum 100 blocks per request
- Cannot modify existing blocks (only append)
- Cannot delete blocks
- Rich text formatting supported (bold, italic, code, links, etc.)

## create_page Specification

**Notion API Endpoint:** `POST /pages`

**Request Body (Basic):**
```json
{
  "parent": {
    "type": "database_id",
    "database_id": "database-uuid"
  },
  "properties": {
    "title": {
      "title": [
        {
          "type": "text",
          "text": { "content": "Page Title" }
        }
      ]
    }
  }
}
```

**Request Body (With Properties):**
```json
{
  "parent": {
    "type": "database_id",
    "database_id": "database-uuid"
  },
  "properties": {
    "Name": {
      "title": [
        {
          "type": "text",
          "text": { "content": "Page Title" }
        }
      ]
    },
    "Status": {
      "select": {
        "name": "In Progress"
      }
    },
    "Due Date": {
      "date": {
        "start": "2026-02-15"
      }
    }
  }
}
```

**Response:**
```json
{
  "object": "page",
  "id": "string",
  "created_time": "2026-01-29T10:30:00.000Z",
  "last_edited_time": "2026-01-29T10:30:00.000Z",
  "created_by": { "object": "user", "id": "..." },
  "parent": { "type": "database_id", "database_id": "..." },
  "archived": false,
  "properties": { /* as specified */ },
  "url": "https://www.notion.so/..."
}
```

**Property Types:**
All database property types can be set on creation:
- `title` - Text title
- `rich_text` - Long text content
- `number` - Numeric value
- `select` - Single select option
- `multi_select` - Multiple select options
- `date` - Date value
- `checkbox` - Boolean value
- `status` - Status option
- `email` - Email address
- `phone_number` - Phone number
- `url` - URL string

## get_database Specification

**Notion API Endpoint:** `GET /databases/{database_id}`

**Response:**
```json
{
  "object": "database",
  "id": "string",
  "created_time": "2026-01-29T10:30:00.000Z",
  "last_edited_time": "2026-01-29T10:30:00.000Z",
  "title": [
    {
      "type": "text",
      "text": { "content": "Database Name" }
    }
  ],
  "properties": {
    "Name": {
      "id": "title",
      "name": "Name",
      "type": "title",
      "title": {}
    },
    "Status": {
      "id": "status",
      "name": "Status",
      "type": "status",
      "status": {
        "options": [
          {
            "id": "opt-1",
            "name": "Not started",
            "color": "default"
          }
        ]
      }
    }
    // ... other properties
  }
}
```

**Property Type Reference:**

Each property has:
- `id` - Internal property ID
- `name` - Display name
- `type` - Property type
- Type-specific configuration

Supported types:
- `title` - Database title field
- `rich_text` - Long text
- `number` - Numeric values
- `select` - Single select with options
- `multi_select` - Multiple select
- `date` - Date value
- `checkbox` - Boolean
- `status` - Status field with options
- `email` - Email
- `phone_number` - Phone
- `url` - URL
- `formula` - Computed value
- `rollup` - Aggregated value
- `relation` - Link to other databases
- `created_time` - Auto-set creation time
- `created_by` - Auto-set creator
- `last_edited_time` - Auto-set edit time
- `last_edited_by` - Auto-set last editor
