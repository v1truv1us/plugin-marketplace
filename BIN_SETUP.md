# Using OpenCode Scripts from Anywhere

The OpenCode compound workflow scripts are now flexible - they can be called from anywhere and automatically detect which project directory to work with.

## Script Locations

The actual scripts are located in:
```
/home/vitruvius/git/plugin-marketplace/scripts/
├── opencode-compound-review.sh
└── opencode-auto-compound.sh
```

Wrapper scripts (for easy access from anywhere):
```
/home/vitruvius/git/plugin-marketplace/bin/
├── opencode-compound-review
└── opencode-auto-compound
```

## Usage Options

### Option 1: Use from Current Directory

If you're already in your project directory:
```bash
cd /home/vitruvius/git/plugin-marketplace
/home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review
/home/vitruvius/git/plugin-marketplace/bin/opencode-auto-compound
```

Or if the scripts are in your PATH:
```bash
opencode-compound-review
opencode-auto-compound
```

### Option 2: Specify Directory Explicitly

Call the script with directory as argument:
```bash
/home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review /path/to/project
/home/vitruvius/git/plugin-marketplace/bin/opencode-auto-compound /home/vitruvius/git/plugin-marketplace
```

### Option 3: Symlink to ~/git/scripts (Recommended)

Create a `scripts` directory in `~/git/` and symlink the wrappers:

```bash
# Create scripts directory
mkdir -p ~/git/scripts

# Create symlinks
ln -s ~/git/plugin-marketplace/bin/opencode-compound-review ~/git/scripts/
ln -s ~/git/plugin-marketplace/bin/opencode-auto-compound ~/git/scripts/

# Add to PATH (in ~/.bashrc or ~/.zshrc)
export PATH="$HOME/git/scripts:$PATH"

# Then use from anywhere
opencode-compound-review /path/to/project
opencode-auto-compound /home/vitruvius/git/plugin-marketplace
```

### Option 4: Create Shell Aliases

Add to your `~/.bashrc` or `~/.zshrc`:
```bash
alias compound-review='/home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review'
alias auto-compound='/home/vitruvius/git/plugin-marketplace/bin/opencode-auto-compound'

# Usage:
# compound-review /path/to/project
# auto-compound /home/vitruvius/git/plugin-marketplace
```

## How Scripts Determine Working Directory

The scripts work in this order:

1. **If directory argument provided:** Uses that directory
   ```bash
   opencode-compound-review /home/vitruvius/git/my-project
   ```

2. **If no argument:** Uses current directory
   ```bash
   cd /home/vitruvius/git/my-project
   opencode-compound-review
   ```

## Configuration Files

The scripts look for environment configuration in this order:

1. `.env.local` in the project directory
2. `~/.config/opencode-compound/environment.conf` (global config)

For the system-wide config, create:
```bash
mkdir -p ~/.config/opencode-compound
cp opencode-workflow/environment.sample ~/.config/opencode-compound/environment.conf
```

## Systemd Service Files

The systemd services are configured to use the wrapper scripts with explicit paths:

```ini
ExecStart=/home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review /home/vitruvius/git/plugin-marketplace
ExecStart=/home/vitruvius/git/plugin-marketplace/bin/opencode-auto-compound /home/vitruvius/git/plugin-marketplace
```

This ensures services work correctly regardless of PATH configuration.

## Testing

Test that scripts work from anywhere:

```bash
# From plugin-marketplace directory
cd /home/vitruvius/git/plugin-marketplace
./bin/opencode-compound-review .  # Current directory
./bin/opencode-compound-review /home/vitruvius/git/plugin-marketplace  # Explicit path

# From anywhere
/home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review /home/vitruvius/git/plugin-marketplace

# With symlinks
ln -s /home/vitruvius/git/plugin-marketplace/bin/opencode-compound-review /tmp/test
/tmp/test /home/vitruvius/git/plugin-marketplace
```

## For Multiple Projects

If you have multiple projects using this workflow:

```bash
# Create separate environment files for each project
mkdir -p /home/vitruvius/git/my-project-1/.env.local
mkdir -p /home/vitruvius/git/my-project-2/.env.local

# Each with their own configuration
echo "DISCORD_WEBHOOK_URL=..." > /home/vitruvius/git/my-project-1/.env.local
echo "DISCORD_WEBHOOK_URL=..." > /home/vitruvius/git/my-project-2/.env.local

# Run for specific project
opencode-compound-review /home/vitruvius/git/my-project-1
opencode-compound-review /home/vitruvius/git/my-project-2
```

Or set `PROJECT_NAME` in each `.env.local`:
```bash
DISCORD_WEBHOOK_URL=https://...
PROJECT_NAME=my-project-1
```

## Architecture

```
User runs script from anywhere
         ↓
wrapper script (bin/opencode-compound-review)
         ↓
determines target directory (from arg or cwd)
         ↓
actual script (scripts/opencode-compound-review.sh)
         ↓
changes to target directory
         ↓
loads .env.local from that directory
         ↓
or falls back to ~/.config/opencode-compound/environment.conf
         ↓
executes in target directory's context
```

## Tips

- **Best for systemd:** Use absolute paths like systemd services do
- **Best for manual runs:** Use symlinks to add to PATH
- **Best for multiple projects:** Use `.env.local` in each project
- **Best for global config:** Use `~/.config/opencode-compound/environment.conf`

---

**Key Insight:**
`★ Insight ─────────────────────────────────────`
By accepting the project directory as an argument, scripts can be stored centrally (in the plugin-marketplace) but used for multiple projects. This is a common pattern for tooling - the script is project-agnostic, and the project context is passed at runtime. This approach also makes systemd services cleaner (explicit paths) while still allowing manual usage flexibility.
`─────────────────────────────────────────────────`
