# OpenCode Scripts Flexibility Update

## What Changed

The OpenCode compound workflow scripts have been updated to work from anywhere in your filesystem and accept project directories as arguments.

### Before
```bash
# Had to be in the plugin-marketplace directory
cd /home/vitruvius/git/plugin-marketplace
./scripts/opencode-compound-review.sh
```

### After
```bash
# Works from anywhere - 4 different ways:

# 1. From current directory
cd /home/vitruvius/git/plugin-marketplace
/home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review

# 2. With explicit directory
/home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review /home/vitruvius/git/plugin-marketplace

# 3. Via symlink from anywhere
ln -s /home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review ~/git/scripts/
opencode-compound-review /home/vitruvius/git/plugin-marketplace

# 4. Via alias
alias compound-review='/home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review'
compound-review /home/vitruvius/git/plugin-marketplace
```

## Architecture

```
File Structure:
┌─ plugin-marketplace/
│  ├─ scripts/                                    (Core logic)
│  │  ├─ opencode-compound-review.sh            (Updated: accepts directory arg)
│  │  └─ opencode-auto-compound.sh              (Updated: accepts directory arg)
│  │
│  ├─ bin/                                       (NEW: Wrapper scripts)
│  │  ├─ opencode-compound-review               (Calls scripts/ with arg)
│  │  └─ opencode-auto-compound                 (Calls scripts/ with arg)
│  │
│  ├─ .systemd/                                 (Updated: uses new paths)
│  │  ├─ opencode-compound-review.service       (Points to bin/ with explicit path)
│  │  └─ opencode-auto-compound.service         (Points to bin/ with explicit path)
│  │
│  └─ BIN_SETUP.md                              (NEW: Setup guide)
```

## Technical Details

### Script Argument Handling

Both scripts now handle working directory like this:

```bash
# If directory argument provided, use it
if [ -n "$1" ]; then
  TARGET_DIR="$1"
else
  # Otherwise use current directory
  TARGET_DIR="."
fi

# Resolve to absolute path
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
  echo "Error: Cannot access directory: $1"
  exit 1
}

# Change to that directory
cd "$TARGET_DIR"
```

### Environment Configuration

Scripts look for config files in order:
1. `.env.local` in the project directory (project-specific)
2. `~/.config/opencode-compound/environment.conf` (global fallback)

This allows both:
- **Per-project configuration** (in `.env.local`)
- **Global configuration** (in `~/.config/opencode-compound/`)

### Systemd Services

Services use explicit paths with directory argument:

```ini
# Old way
ExecStart=/home/vitruvius/git/plugin-marketplace/scripts/opencode-compound-review.sh

# New way
ExecStart=/home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review /home/vitruvius/git/plugin-marketplace
```

Benefits:
- Explicit and clear about which project directory to use
- Works regardless of PATH configuration
- Fails gracefully with error if directory doesn't exist

## Files Created/Modified

### New Files
- **`bin/opencode-compound-review`** - Wrapper script for review workflow
- **`bin/opencode-auto-compound`** - Wrapper script for auto-compound workflow
- **`BIN_SETUP.md`** - Comprehensive setup guide for using scripts from anywhere
- **`SCRIPTS_FLEXIBILITY.md`** - This document

### Modified Files
- **`scripts/opencode-compound-review.sh`** - Now accepts directory argument
- **`scripts/opencode-auto-compound.sh`** - Now accepts directory argument
- **`.systemd/opencode-compound-review.service`** - Updated to use bin/ wrappers
- **`.systemd/opencode-auto-compound.service`** - Updated to use bin/ wrappers

### Unchanged Files
- All documentation files
- Configuration templates
- Everything else in the workflow

## Usage Examples

### For Single Project (Plugin-Marketplace)

```bash
# Simple - from anywhere
/home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review /home/vitruvius/git/plugin-marketplace

# Or with symlink
ln -s /home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review ~/git/scripts/
~/git/scripts/opencode-compound-review /home/vitruvius/git/plugin-marketplace

# Or with alias
echo "alias compound='~/git/plugin-marketplace/bin/opencode-compound-review'" >> ~/.bashrc
compound /home/vitruvius/git/plugin-marketplace
```

### For Multiple Projects

```bash
# Each project can have its own .env.local
cat > /home/vitruvius/git/project-1/.env.local << EOF
DISCORD_WEBHOOK_URL=https://...
PROJECT_NAME=project-1
GITHUB_TOKEN=...
EOF

cat > /home/vitruvius/git/project-2/.env.local << EOF
DISCORD_WEBHOOK_URL=https://...
PROJECT_NAME=project-2
GITHUB_TOKEN=...
EOF

# Then run for each project
opencode-compound-review /home/vitruvius/git/project-1
opencode-compound-review /home/vitruvius/git/project-2
```

### In Systemd Services

```ini
[Service]
ExecStart=/home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review /home/vitruvius/git/plugin-marketplace

# Or for other projects:
ExecStart=/home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review /home/vitruvius/git/my-other-project
```

## Recommended Setup

### Option 1: Simplest (Current Use)
Keep using as-is with the bin/ wrapper scripts. Just pass the directory:
```bash
/home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review /home/vitruvius/git/plugin-marketplace
```

### Option 2: Symlink + PATH (Recommended)
Add wrappers to ~/git/scripts and add to PATH:

```bash
# Setup
mkdir -p ~/git/scripts
ln -s /home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review ~/git/scripts/
ln -s /home/vitruvius/git/plugin-marketplace/bin/opencode-auto-compound ~/git/scripts/

# Add to ~/.bashrc or ~/.zshrc
export PATH="$HOME/git/scripts:$PATH"

# Usage from anywhere
opencode-compound-review /home/vitruvius/git/plugin-marketplace
opencode-auto-compound /home/vitruvius/git/plugin-marketplace
```

### Option 3: Aliases (Simplest Typing)
Add to ~/.bashrc or ~/.zshrc:

```bash
alias compound='~/git/plugin-marketplace/bin/opencode-compound-review'
alias compound-auto='~/git/plugin-marketplace/bin/opencode-auto-compound'

# Usage
compound /home/vitruvius/git/plugin-marketplace
compound-auto /home/vitruvius/git/plugin-marketplace
```

### Option 4: From Current Directory
Just cd to the project and run without arguments:

```bash
cd /home/vitruvius/git/plugin-marketplace
/home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review
```

## Testing

Verify everything works:

```bash
# Test 1: With explicit directory
/home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review /home/vitruvius/git/plugin-marketplace
# Expected: Error about missing DISCORD_WEBHOOK_URL (correct behavior)

# Test 2: From project directory
cd /home/vitruvius/git/plugin-marketplace
/home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review
# Expected: Same error (script working correctly)

# Test 3: With invalid directory
/home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review /nonexistent
# Expected: "Error: Cannot access directory: /nonexistent"
```

## Backwards Compatibility

The changes are fully backwards compatible:
- Old scripts still exist in `scripts/`
- New wrappers in `bin/` are the recommended way forward
- Systemd services updated to use new wrappers
- Directory argument is optional (defaults to current directory)

## Benefits

1. **Flexibility** - Call scripts from anywhere
2. **Reusability** - Use same scripts for multiple projects
3. **Clean** - Keep scripts in one place, use them everywhere
4. **Safe** - Errors if directory doesn't exist
5. **Explicit** - Systemd services are clear about which directory
6. **Fallback** - Environment config has global fallback option

## Maintenance

The core logic is now:
- **scripts/opencode-*.sh** - Core implementation (accepts directory arg)
- **bin/opencode-*** - Thin wrappers (handles path resolution)
- **.systemd/*.service** - Service definitions (use bin/ wrappers)

Updates to core logic only need to be made in `scripts/` directory.

---

**Key Insight:**
`★ Insight ─────────────────────────────────────`
By separating the wrapper from the core logic, we get flexibility without complexity. The core scripts in `scripts/` remain the source of truth, while `bin/` provides convenient access patterns. This is a common pattern in Unix tooling: think of how `npm`, `yarn`, `python`, etc. can all be run from anywhere but operate on a specified project directory. The wrapper pattern is simple but powerful - it adds no overhead while dramatically improving usability.
`─────────────────────────────────────────────────`
