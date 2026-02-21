# Error Reference

## HTTP Status Codes

### 400 - Bad Request

The request is malformed or parameters are invalid.

**Possible causes:**
- Invalid page ID or database ID format
- Missing required parameter
- Filter syntax error
- Property name doesn't exist in database
- Invalid filter operator for property type

**Solution:**
- Check parameter format (IDs should be 32-character hex strings)
- Verify all required parameters provided
- Validate filter syntax against property type
- Use `get_database` to verify property names
- Refer to filter-syntax.md for correct operators

### 401 - Unauthorized

The OAuth token is invalid or missing.

**Possible causes:**
- Token not in `.claude/notion-mcp.local.md`
- Token is empty or corrupted
- Token was revoked in Notion settings
- Token expired (shouldn't happen, but possible)

**Solution:**
- Run `/notion:setup` to obtain new token
- Run `/notion:validate` to test token validity
- Check `.claude/notion-mcp.local.md` exists and has token
- If token was revoked, re-authorize in Notion

### 403 - Forbidden

You don't have permission to access this resource.

**Possible causes:**
- No read/write access to page or database
- Workspace permissions changed
- OAuth scopes don't include required access
- User role is read-only in workspace

**Solution:**
- Verify you have access in Notion workspace
- Check OAuth app has read/write scopes
- For write operations, verify write access granted
- Ask workspace admin if access was revoked
- Run `/notion:troubleshoot` for permission details

### 404 - Not Found

The resource doesn't exist.

**Possible causes:**
- Page or database ID is wrong
- Resource was deleted
- Resource is in archived state
- Workspace ID doesn't exist

**Solution:**
- Verify page/database ID is correct
- Check resource still exists in Notion
- Check resource is not archived
- If deleted, restore from trash or use different resource
- Use `search` tool to find correct resource ID

### 429 - Rate Limited

You've exceeded Notion API rate limits.

**Possible causes:**
- Making too many requests (>3 per second)
- Exceeded quota (>100 requests per 30 seconds)
- Making large batch operations

**Solution:**
- Wait and retry (plugin handles this automatically)
- Reduce request frequency
- Batch operations more efficiently
- Contact Notion support if legitimate use is rate-limited

### 500 - Server Error

Notion API server error (not your fault).

**Possible causes:**
- Notion server temporarily down
- Notion API experiencing issues
- Network connectivity problem

**Solution:**
- Wait and retry
- Check Notion status page
- Try again in a few minutes
- If persists, contact Notion support

## Notion-Specific Error Responses

### Invalid Grant Error

Response:
```json
{
  "object": "error",
  "status": 400,
  "code": "invalid_grant",
  "message": "Authorization code has expired"
}
```

**Meaning:** OAuth token is invalid or expired.

**Solution:** Run `/notion:setup` to get new token.

### Unsupported Block Type

Response:
```json
{
  "object": "error",
  "status": 400,
  "code": "unsupported_block_type",
  "message": "Block type not supported"
}
```

**Meaning:** Trying to use block type that Notion doesn't support.

**Solution:** Use supported block types: paragraph, heading_1, heading_2, heading_3, bulleted_list_item, numbered_list_item, to_do, code, quote, divider, image, file.

### Validation Failed

Response:
```json
{
  "object": "error",
  "status": 400,
  "code": "validation_error",
  "message": "Body did not pass validation"
}
```

**Meaning:** Request body format is invalid.

**Solution:**
- Check JSON format is valid (use JSON validator)
- Verify all required fields present
- Check field values match expected types
- Refer to tool-specifications.md for correct format

### Invalid Parent Error

Response:
```json
{
  "object": "error",
  "status": 400,
  "code": "invalid_parent",
  "message": "Parent page/database not found"
}
```

**Meaning:** Parent page or database doesn't exist.

**Solution:**
- Verify parent ID is correct
- Check parent resource still exists
- Check you have access to parent
- Use `search` to find correct parent ID

## Claude Code-Specific Errors

### "Token not found in .local.md"

**Meaning:** Pre-tool-use hook blocked operation because token is missing.

**Solution:** Run `/notion:setup` to set up authentication.

### "Token format invalid"

**Meaning:** Token in `.local.md` is malformed or corrupted.

**Solution:**
- Check file manually: `cat .claude/notion-mcp.local.md`
- Token should start with "notion_oauth_"
- If corrupted, run `/notion:setup` to get new token

### "Connection validation failed"

**Meaning:** Connection validator detected an issue during setup.

**Solution:**
- Run `/notion:troubleshoot` for detailed diagnostics
- Check network connectivity to Notion
- Verify workspace still exists
- Check user account permissions

### "Invalid filter syntax"

**Meaning:** Filter parameter has wrong syntax for property type.

**Solution:**
- Check property type using `get_database`
- Review filter-syntax.md for correct operators
- Validate filter JSON format
- Test with simpler filter first

### "Property not found"

**Meaning:** Filter references property that doesn't exist in database.

**Solution:**
- Run `get_database` to see all properties
- Check property name matches exactly (case-sensitive)
- Remove or correct filter property name

## Debugging Error Responses

### Enable Verbose Output
```bash
cc --debug --plugin-dir ./plugins/notion-mcp
```

Shows:
- Full API request being sent
- Full API response received
- Detailed error messages

### Check Notion Status
Go to https://status.notion.com to verify:
- Notion API is operational
- No ongoing incidents
- Maintenance windows

### Test Token Manually
```bash
TOKEN=$(grep notion_oauth_token .claude/notion-mcp.local.md | cut -d' ' -f2 | tr -d '"')

curl -H "Authorization: Bearer $TOKEN" \
  https://api.notion.com/v1/databases
```

If this returns error, token/network issue.

### Validate Request Format
Use JSON validator to check request:
```bash
echo '{"filter": {"property": "Status", ...}}' | jq .
```

If not valid JSON, fix format.

## Common Error Patterns

### Pattern 1: Read Works, Write Fails

**Symptoms:**
- `read_page` succeeds
- `append_block` returns 403

**Cause:** Lack write permissions in workspace.

**Solution:** Check workspace role, ask admin for write access.

### Pattern 2: Specific Database Fails, Others Work

**Symptoms:**
- Can access some databases
- One specific database fails with 404
- `search` finds the database

**Cause:** Database deleted, archived, or access revoked.

**Solution:** Verify database still accessible, try different database.

### Pattern 3: Filter Works, Then Fails

**Symptoms:**
- Same filter works fine
- Later same query returns 400 "validation_error"
- Database schema changed

**Cause:** Database properties changed, old filter references deleted property.

**Solution:** Run `get_database` to verify properties still exist, update filter.

### Pattern 4: Intermittent Rate Limiting

**Symptoms:**
- Commands work fine
- Occasionally hit 429 rate limit
- No change in usage pattern

**Cause:** Other processes also using token, hitting shared quota.

**Solution:**
- Reduce other concurrent usage
- Batch requests more efficiently
- Contact Notion if legitimate use is limited

## Error Recovery Checklist

When you encounter an error:

1. **Note the error code** - What specific error?
2. **Check the cause** - Is it token, permission, or format?
3. **Validate token** - Run `/notion:validate`
4. **Check permissions** - Can you do this in Notion manually?
5. **Review request** - Is request format correct?
6. **Check Notion status** - Is Notion API working?
7. **Get diagnostics** - Run `/notion:troubleshoot`
8. **Retry after fix** - Does error go away?

## Getting Help

If error persists:

1. Run `/notion:troubleshoot` for diagnostic output
2. Check references/tool-specifications.md for correct format
3. Verify you can perform operation manually in Notion
4. Check Notion developer documentation
5. Review error code in this reference

Error should be solvable using these resources.
