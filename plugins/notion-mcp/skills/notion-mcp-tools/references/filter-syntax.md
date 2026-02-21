# Advanced Filter Syntax

## Filter Basics

Filters are used with `query_database` to find specific entries. Each filter specifies:
1. Property name
2. Property type
3. Condition operator
4. Value to match

## Filter by Property Type

### Text/Rich Text Filters

Text properties support substring and prefix matching.

**Operators:**
- `equals` - Exact match (case-sensitive)
- `does_not_equal` - Not an exact match
- `contains` - Substring present
- `does_not_contain` - Substring not present
- `starts_with` - Begins with string
- `ends_with` - Ends with string
- `is_empty` - Field is blank
- `is_not_empty` - Field has content

**Example:**
```json
{
  "filter": {
    "property": "Title",
    "rich_text": {
      "contains": "Notion"
    }
  }
}
```

### Number Filters

Numeric properties support comparison operators.

**Operators:**
- `equals` - Exact value
- `does_not_equal` - Not equal
- `greater_than` - >
- `less_than` - <
- `greater_than_or_equal_to` - >=
- `less_than_or_equal_to` - <=
- `is_empty` - No value
- `is_not_empty` - Has value

**Example:**
```json
{
  "filter": {
    "property": "Priority",
    "number": {
      "greater_than": 5
    }
  }
}
```

### Checkbox Filters

Boolean properties for true/false states.

**Operators:**
- `equals` - Match true/false
- `does_not_equal` - Not true/false

**Example:**
```json
{
  "filter": {
    "property": "Complete",
    "checkbox": {
      "equals": true
    }
  }
}
```

### Select Filters

Single-select properties match option names.

**Operators:**
- `equals` - Match option name
- `does_not_equal` - Not option name

**Example:**
```json
{
  "filter": {
    "property": "Status",
    "select": {
      "equals": "In Progress"
    }
  }
}
```

### Multi-Select Filters

Multiple-select properties check if option is present.

**Operators:**
- `contains` - Option is selected
- `does_not_contain` - Option is not selected

**Example:**
```json
{
  "filter": {
    "property": "Tags",
    "multi_select": {
      "contains": "Important"
    }
  }
}
```

### Date Filters

Date properties support range and relative comparisons.

**Operators:**
- `equals` - Exact date
- `before` - Before date
- `after` - After date
- `on_or_before` - <=
- `on_or_after` - >=
- `past_week` - Last 7 days (no value needed)
- `past_month` - Last 30 days
- `past_year` - Last 365 days
- `next_week` - Next 7 days
- `next_month` - Next 30 days
- `next_year` - Next 365 days
- `is_empty` - No date set
- `is_not_empty` - Date is set

**Example:**
```json
{
  "filter": {
    "property": "Due Date",
    "date": {
      "past_week": {}
    }
  }
}
```

**Example with Range:**
```json
{
  "filter": {
    "property": "Due Date",
    "date": {
      "on_or_after": "2026-01-29",
      "on_or_before": "2026-02-15"
    }
  }
}
```

### Status Filters

Status properties match status option names.

**Operators:**
- `equals` - Match status
- `does_not_equal` - Not status

**Example:**
```json
{
  "filter": {
    "property": "Status",
    "status": {
      "equals": "Done"
    }
  }
}
```

### Email/Phone/URL Filters

Email, phone, and URL properties work like text filters.

**Operators:**
- `equals` - Exact match
- `does_not_equal` - Not exact match
- `contains` - Substring present
- `does_not_contain` - Substring not present
- `starts_with` - Begins with
- `ends_with` - Ends with
- `is_empty` - Empty field
- `is_not_empty` - Has value

**Example:**
```json
{
  "filter": {
    "property": "Email",
    "email": {
      "contains": "@example.com"
    }
  }
}
```

### Relation Filters

Relation properties check linked database entries.

**Operators:**
- `contains` - Page is related
- `does_not_contain` - Page is not related

**Example:**
```json
{
  "filter": {
    "property": "Related Project",
    "relation": {
      "contains": "project-page-id"
    }
  }
}
```

### Formula/Rollup Filters

Formula and rollup properties use numeric comparisons.

**Operators:** Same as number filters

## Compound Filters (AND/OR Logic)

Combine multiple filters with AND or OR conditions.

### AND Filter

All conditions must be true.

```json
{
  "filter": {
    "and": [
      {
        "property": "Status",
        "select": {
          "equals": "Done"
        }
      },
      {
        "property": "Due Date",
        "date": {
          "before": "2026-02-01"
        }
      }
    ]
  }
}
```

This finds entries that are BOTH "Done" status AND have due date before Feb 1.

### OR Filter

At least one condition must be true.

```json
{
  "filter": {
    "or": [
      {
        "property": "Status",
        "select": {
          "equals": "Done"
        }
      },
      {
        "property": "Status",
        "select": {
          "equals": "Archived"
        }
      }
    ]
  }
}
```

This finds entries that are EITHER "Done" OR "Archived".

### Complex Nesting

Combine AND and OR filters.

```json
{
  "filter": {
    "and": [
      {
        "or": [
          {
            "property": "Status",
            "select": {
              "equals": "Done"
            }
          },
          {
            "property": "Status",
            "select": {
              "equals": "Archived"
            }
          }
        ]
      },
      {
        "property": "Priority",
        "number": {
          "greater_than": 5
        }
      }
    ]
  }
}
```

This finds entries that are (Done OR Archived) AND (Priority > 5).

## Filter Examples by Use Case

### Find Incomplete Tasks

```json
{
  "filter": {
    "property": "Status",
    "select": {
      "does_not_equal": "Done"
    }
  }
}
```

### Find Overdue Items

```json
{
  "filter": {
    "and": [
      {
        "property": "Due Date",
        "date": {
          "before": "2026-01-29"
        }
      },
      {
        "property": "Status",
        "select": {
          "does_not_equal": "Done"
        }
      }
    ]
  }
}
```

### Find High Priority Items Due This Month

```json
{
  "filter": {
    "and": [
      {
        "property": "Priority",
        "number": {
          "greater_than_or_equal_to": 8
        }
      },
      {
        "property": "Due Date",
        "date": {
          "on_or_after": "2026-01-01",
          "on_or_before": "2026-01-31"
        }
      }
    ]
  }
}
```

### Find Items With Specific Tag

```json
{
  "filter": {
    "property": "Tags",
    "multi_select": {
      "contains": "Urgent"
    }
  }
}
```

### Find Entries Created Recently

```json
{
  "filter": {
    "property": "Created",
    "created_time": {
      "past_week": {}
    }
  }
}
```

### Find Entries Modified After Date

```json
{
  "filter": {
    "property": "Last Edited",
    "last_edited_time": {
      "on_or_after": "2026-01-15"
    }
  }
}
```

### Find Items Without Assignee

```json
{
  "filter": {
    "property": "Assignee",
    "people": {
      "is_empty": true
    }
  }
}
```

### Find Items in Relation

```json
{
  "filter": {
    "property": "Project",
    "relation": {
      "contains": "specific-project-id"
    }
  }
}
```

## Sorting Results

Results can be sorted by any property.

**Sort Direction:**
- `ascending` - A to Z, oldest to newest
- `descending` - Z to A, newest to oldest

### Sort by Text

```json
{
  "sorts": [
    {
      "property": "Name",
      "direction": "ascending"
    }
  ]
}
```

### Sort by Date (Newest First)

```json
{
  "sorts": [
    {
      "property": "Due Date",
      "direction": "descending"
    }
  ]
}
```

### Multiple Sort Criteria

```json
{
  "sorts": [
    {
      "property": "Priority",
      "direction": "descending"
    },
    {
      "property": "Due Date",
      "direction": "ascending"
    }
  ]
}
```

This sorts by priority (high first), then by due date (earliest first).

### Sort by Timestamp

```json
{
  "sorts": [
    {
      "timestamp": "last_edited_time",
      "direction": "descending"
    }
  ]
}
```

## Common Filter Mistakes

### Mistake 1: Wrong Operator for Property Type

❌ Wrong - Number operator on text property:
```json
{
  "property": "Title",
  "rich_text": {
    "greater_than": 5
  }
}
```

✅ Correct - Use text operator:
```json
{
  "property": "Title",
  "rich_text": {
    "contains": "5"
  }
}
```

### Mistake 2: Forgetting Option Name Exact Match

❌ Wrong - Partial match on select:
```json
{
  "property": "Status",
  "select": {
    "equals": "Done"
  }
}
```
(If option is actually "Completed")

✅ Correct - Use exact option name:
```json
{
  "property": "Status",
  "select": {
    "equals": "Completed"
  }
}
```

### Mistake 3: Case Sensitivity on Text

Text filters are case-sensitive:

❌ Won't match:
```json
{
  "property": "Title",
  "rich_text": {
    "equals": "notion"
  }
}
```

✅ Use correct case:
```json
{
  "property": "Title",
  "rich_text": {
    "equals": "Notion"
  }
}
```

### Mistake 4: Wrong Property Name

❌ Property doesn't exist:
```json
{
  "property": "Project Name",  // Actually called "Project"
  "rich_text": {
    "equals": "Test"
  }
}
```

✅ Use exact property name from database schema:
```json
{
  "property": "Project",
  "rich_text": {
    "equals": "Test"
  }
}
```

Get correct names with `get_database` tool.
