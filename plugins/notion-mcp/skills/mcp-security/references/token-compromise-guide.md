# Token Compromise Response Guide

## Signs Your Token May Be Compromised

### Technical Signs

1. **Validation Failure After Success**
   ```
   Previously working: /notion:validate → ✓ Success
   Now: /notion:validate → ✗ Token invalid
   ```
   Suggests token was revoked, possibly externally due to detected compromise.

2. **Permission Suddenly Denied**
   ```
   Previously worked: /notion:read [page-id] → Success
   Now: /notion:read [page-id] → 403 Forbidden
   ```
   Could indicate token revoked or workspace access removed.

3. **Unusual Connection Errors**
   ```
   /notion:troubleshoot shows workspace not found
   But workspace still exists in Notion
   ```
   Could indicate token corrupted or workspace permission revoked.

### Content Signs

Check your Notion workspace for unauthorized changes:

1. **Unexpected Page Modifications**
   - Pages edited you didn't modify
   - Edit timestamp from when you weren't using the system
   - Content changed or deleted

2. **New Pages or Databases**
   - Pages created you don't recognize
   - Database entries added without explanation
   - Entries in wrong database

3. **Permission Changes**
   - Workspace members added
   - User roles changed
   - Page sharing changed unexpectedly

4. **Activity Log Evidence**
   - Notion activity log shows unexpected API calls
   - API access from unusual times
   - Pattern of access doesn't match your usage

### Behavioral Signs

1. **System Performance Issues**
   - System sluggish or slow (malware running)
   - Network activity unusual
   - Fan running constantly (computational load)

2. **File System Changes**
   - New files you didn't create
   - Files modified with wrong timestamps
   - Unexpected programs installed

3. **Credential Issues**
   - Unusual password reset emails from Notion
   - Alerts about new device access
   - Failed login notifications

## Immediate Response (Next 5 Minutes)

### Step 1: Revoke Token Immediately

The fastest way to stop any damage:

1. **Open Notion**
   - Go to www.notion.com
   - Login to your account

2. **Navigate to Connected Apps**
   - Click Settings (gear icon)
   - Look for "Integrations" or "Connected Apps"
   - Scroll to find "Claude Code"

3. **Disconnect Claude Code**
   - Click the "Claude Code" app
   - Click "Disconnect" or "Remove"
   - Confirm the disconnection

**Result:** Token becomes invalid immediately. Attacker cannot use it anymore.

**Time to complete:** 30 seconds

### Step 2: Check Recent Activity

While revocation takes effect:

1. **Open Notion Activity Log**
   - Go to Settings → Activity Log
   - Look at recent entries (last 24 hours)

2. **Check for Suspicious Activity**
   - Look for page modifications you didn't make
   - Check for unusual API access patterns
   - Note timestamps and what was changed

3. **Take a Screenshot**
   - Screenshot suspicious activity for records
   - Note specific pages that were modified
   - Document timestamps

**Time to complete:** 2-3 minutes

### Step 3: Emergency System Check

If you suspect machine compromise:

1. **Disconnect from Internet** (if serious)
   - Unplug ethernet or disable WiFi
   - Stops attacker from accessing machine remotely

2. **Save Important Files**
   - Copy critical work to external drive
   - Backup important documents
   - Don't execute anything on machine

3. **Plan Full System Check**
   - Note that you may need OS reinstall
   - Backup data to clean external drive
   - Prepare antivirus/malware tools

**Time to complete:** 5 minutes to disconnect; longer for full check

## Short Term Response (Next Few Hours)

### Step 4: Delete Compromised Token File

The `.local.md` file is now useless:

```bash
# Delete the compromised token file
rm ~/.claude/notion-mcp.local.md

# Or on Windows:
del C:\Users\[username]\.claude\notion-mcp.local.md
```

This removes the compromised token from your system.

**Why:** Even though revoked, the file contains the compromised token value. Delete it.

### Step 5: Review Notion Workspace for Damage

Assess what was changed:

1. **Open Notion Workspace**
   - Review pages for unauthorized changes
   - Check databases for added/modified entries
   - Look for pages that shouldn't be there

2. **Document Damage**
   - List all pages that were modified
   - Note what was changed in each
   - Screenshot if needed for proof

3. **Restore if Possible**
   - Notion has version history on pages
   - Restore pages to previous versions if available
   - Check if trash has deleted pages

### Step 6: Secure Your System

Prevent future compromise:

**Antivirus/Malware Scan:**
```bash
# Install or update antivirus
# Run full system scan
# Quarantine any threats found
```

**Software Updates:**
- Update operating system
- Update all installed software
- Restart after updates

**Remove Suspicious Software:**
- Check installed programs
- Remove anything unfamiliar
- Be especially careful with terminal/CMD tools

### Step 7: Check Other Accounts

If machine is compromised, check all accounts:

1. **Email Accounts**
   - Check recent activity
   - Look for unauthorized logins
   - Check security recovery options

2. **Cloud Accounts**
   - Google Drive, Dropbox, etc.
   - Check recent activity
   - Check connected apps/devices

3. **Banking/Financial Accounts**
   - Check for unauthorized transactions
   - Verify account recovery options
   - Consider fraud alert if needed

4. **Social Media**
   - Check login activity
   - Verify connected devices
   - Check account settings

## Medium Term Response (Within 24 Hours)

### Step 8: Set Up New Token

Once you've confirmed no further compromise:

1. **Run Setup on Clean System**
   - Use freshly updated machine
   - Complete antivirus scan first
   - Disconnect from internet while scanning

2. **Complete OAuth Flow**
   ```bash
   /notion:setup
   ```
   - This creates new token
   - New `.local.md` file
   - New OAuth session with Notion

3. **Validate New Token**
   ```bash
   /notion:validate
   ```
   - Confirms new token works
   - Tests read/write access
   - Updates last_validated timestamp

### Step 9: Change Notion Password

Recommended additional security:

1. **Open Notion Account Settings**
   - Go to Settings → Your Info
   - Find "Password" section

2. **Change Your Password**
   - Use strong, unique password
   - Don't reuse old password
   - Store in password manager

**Why:** If attacker had access to system, they may have captured keystrokes.

### Step 10: Enable Notion 2FA (Optional)

Additional security layer:

1. **Open Notion Settings**
   - Settings → Your Info → Security

2. **Enable Two-Factor Authentication**
   - Follow Notion's setup process
   - Save backup codes in secure location
   - Authenticator app or SMS

**Why:** Prevents attacker from accessing Notion even if they get password.

## Long Term Measures (Within 1 Week)

### Step 11: Full System Security Audit

Professional assessment if serious:

1. **Malware Removal**
   - If attack detected, consider professional removal
   - May require OS reinstall
   - Backup and restore approach

2. **Software Audit**
   - Remove unused programs
   - Check for backdoors
   - Verify all installations are legitimate

3. **Network Review**
   - Check connected devices
   - Remove unknown devices
   - Change WiFi password

### Step 12: Notion Workspace Review

Comprehensive workspace check:

1. **Check All Shared Pages**
   - Review who has access
   - Remove unexpected shares
   - Audit workspace members

2. **Review Database Structures**
   - Check for new databases
   - Verify database contents
   - Look for hidden data

3. **Check Templates**
   - Verify all templates are yours
   - Remove suspicious templates
   - Check template edit history

4. **Workspace Settings Audit**
   - Review workspace members
   - Check member permissions
   - Verify workspace sharing settings

### Step 13: Document Incident

For your records and insurance/law enforcement if needed:

1. **Create Incident Report**
   - When did you discover compromise?
   - What signs indicated compromise?
   - What was the impact?

2. **List Affected Data**
   - Which pages/databases were accessed?
   - What content was modified?
   - Are there privacy concerns?

3. **Timeline of Events**
   - When did you set up the token?
   - When did you last validate it?
   - When did problems first appear?

4. **Preserve Evidence**
   - Screenshot of activity log
   - File damage documentation
   - System logs from time of incident

## Recovery Checklist

Use this checklist to track your recovery:

- [ ] Token revoked in Notion settings
- [ ] Suspicious activity documented
- [ ] Machine disconnected from internet (if serious)
- [ ] Compromised token file deleted
- [ ] Antivirus/malware scan completed
- [ ] System software updated
- [ ] Suspicious programs removed
- [ ] Other accounts checked for compromise
- [ ] System deemed safe to reconnect
- [ ] New token obtained via `/notion:setup`
- [ ] New token validated via `/notion:validate`
- [ ] Notion password changed
- [ ] Workspace damage assessed and documented
- [ ] Notion pages restored if needed
- [ ] Workspace members reviewed
- [ ] Workspace permissions audited
- [ ] 2FA enabled on Notion (optional)
- [ ] Incident report created

## When to Seek Professional Help

Consider security professionals if:

1. **System Compromise is Suspected**
   - Malware likely present
   - Keystroke logging possible
   - Rootkit or persistent threat

2. **Data Breach Occurred**
   - Sensitive information accessed
   - Personal/financial data compromised
   - Privacy violation risk

3. **You Need Forensic Analysis**
   - Legal case or insurance claim
   - Need to prove what happened
   - Professional documentation needed

4. **Recovery is Complex**
   - Multiple systems compromised
   - Network-wide infection
   - Need professional remediation

**Find Help:**
- Contact local cybersecurity firm
- Ask your IT department (workplace)
- Contact law enforcement if criminal (FBI IC3)
- Consider cyber insurance claim

## Prevention for Future

### Best Practices

1. **Regular Validation**
   ```bash
   # Run monthly
   /notion:validate
   ```

2. **Monitor Activity**
   - Check Notion activity log monthly
   - Look for unexpected API usage
   - Verify all activity is your own

3. **Keep Systems Updated**
   - OS updates within 1 week of release
   - Browser updated automatically
   - Antivirus definitions updated daily

4. **Use Password Manager**
   - Strong, unique Notion password
   - Automatic password management
   - Reduces password reuse risk

5. **Avoid Risky Behaviors**
   - Don't use on public WiFi (for setup)
   - Don't share token with anyone
   - Don't put token in version control
   - Don't click suspicious links

### Regular Review Schedule

**Weekly:**
- Run `/notion:status` to check configuration

**Monthly:**
- Run `/notion:validate` to test token
- Check Notion activity log
- Verify workspace looks normal

**Quarterly:**
- Review Notion connected apps list
- Verify Claude Code is still listed correctly
- Check that no duplicate authorizations exist

**Annually:**
- Full workspace security audit
- Review user permissions
- Update Notion password
- Verify system is secure

## Resources for More Help

**Notion Support:**
- https://www.notion.so/help
- Contact support if workspace was damaged
- File abuse report if suspicious activity

**OAuth/Security Questions:**
- See oauth-security.md for detailed OAuth info
- See workspace-permissions.md for permission model
- See main mcp-security skill for overview

**System Security:**
- Your operating system's security documentation
- Professional cybersecurity firms
- Law enforcement if criminal activity

---

**Remember:** If your token is compromised:

1. **Revoke immediately** (Notion → Settings → Connected Apps)
2. **Check Notion activity** for damage
3. **Secure your system** (antivirus, updates)
4. **Get new token** when system is safe
5. **Monitor going forward** to prevent recurrence

The good news: Notion OAuth tokens can be revoked instantly, limiting damage. Regular validation and monitoring prevent most compromise scenarios.
