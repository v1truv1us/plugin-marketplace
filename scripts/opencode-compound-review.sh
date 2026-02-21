#!/bin/bash
# scripts/opencode-compound-review.sh
# Runs BEFORE opencode-auto-compound.sh to update CLAUDE.md with learnings
# Uses OpenCode harness with big-pickle model (OpenCode model, not Python pickle)
#
# Usage:
#   ./scripts/opencode-compound-review.sh              # Uses current directory
#   ./scripts/opencode-compound-review.sh /path/to/repo  # Uses specified directory
#   opencode-compound-review.sh ~/git/my-project       # Works from anywhere

set -e

# Determine working directory
if [ -n "$1" ]; then
  # Directory argument provided
  TARGET_DIR="$1"
else
  # Use current directory
  TARGET_DIR="."
fi

# Resolve to absolute path
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
  echo "Error: Cannot access directory: $1"
  exit 1
}

cd "$TARGET_DIR"

# Load environment from various possible locations
if [ -f .env.local ]; then
  source .env.local
elif [ -f ~/.config/opencode-compound/environment.conf ]; then
  source ~/.config/opencode-compound/environment.conf
fi

# Ensure Discord webhook is set
if [ -z "$DISCORD_WEBHOOK_URL" ]; then
  echo "Error: DISCORD_WEBHOOK_URL not set in .env.local"
  exit 1
fi

PROJECT_NAME="${PROJECT_NAME:-plugin-marketplace}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
LOG_FILE="logs/opencode-compound-review.log"

# Create logs directory if it doesn't exist
mkdir -p logs

{
  echo "=== Compound Review Started: $TIMESTAMP ==="

  # Ensure we're on main and up to date
  git checkout main
  git pull origin main

  # Send notification: starting review
  curl -X POST "$DISCORD_WEBHOOK_URL" \
    -H 'Content-Type: application/json' \
    -d "{
      \"embeds\": [{
        \"title\": \"🔄 Compound Review Starting\",
        \"description\": \"Reviewing threads and compounding learnings into CLAUDE.md\",
        \"color\": 3447003,
        \"timestamp\": \"$(date -Iseconds)\"
      }]
    }" 2>/dev/null || true

  # Run OpenCode to review threads and extract learnings
  # Using big-pickle model for compound analysis
  opencode --model big-pickle --skip-plan "Load any existing learnings from CLAUDE.md. Look through recent threads and commits from the last 24 hours. For any patterns or gotchas discovered, extract the key learnings and update the CLAUDE.md file so we can learn from our work and mistakes. Focus on: naming patterns, common errors, architectural decisions, and implementation insights. Commit your changes with a clear message about what was learned."

  REVIEW_STATUS=$?

  if [ $REVIEW_STATUS -eq 0 ]; then
    git push origin main || true
    STATUS_COLOR=3066993 # Green
    STATUS_EMOJI="✅"
    STATUS_TEXT="Review completed successfully"
  else
    STATUS_COLOR=15158332 # Red
    STATUS_EMOJI="❌"
    STATUS_TEXT="Review failed (exit code: $REVIEW_STATUS)"
  fi

  # Send completion notification
  curl -X POST "$DISCORD_WEBHOOK_URL" \
    -H 'Content-Type: application/json' \
    -d "{
      \"embeds\": [{
        \"title\": \"$STATUS_EMOJI Compound Review Complete\",
        \"description\": \"$STATUS_TEXT\",
        \"color\": $STATUS_COLOR,
        \"fields\": [{
          \"name\": \"Project\",
          \"value\": \"$PROJECT_NAME\",
          \"inline\": true
        }, {
          \"name\": \"Timestamp\",
          \"value\": \"$TIMESTAMP\",
          \"inline\": true
        }],
        \"timestamp\": \"$(date -Iseconds)\"
      }]
    }" 2>/dev/null || true

  echo "=== Compound Review Completed: $TIMESTAMP ==="
  exit $REVIEW_STATUS

} 2>&1 | tee -a "$LOG_FILE"

exit ${PIPESTATUS[0]}
