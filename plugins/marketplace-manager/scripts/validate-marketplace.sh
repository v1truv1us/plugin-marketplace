#!/bin/bash

# Marketplace Manager - Marketplace Validator
# Validates plugin marketplace structure and all entries

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MARKETPLACE_PATH="${1:-.}"
DEEP_MODE="${2:---deep}"
MARKETPLACE_FILE="$MARKETPLACE_PATH/marketplace.json"

# Counters
PASSED=0
WARNINGS=0
ERRORS=0
PLUGINS_VALIDATED=0

# Functions
print_check() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASSED++))
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
}

print_error() {
    echo -e "${RED}✗${NC} $1"
    ((ERRORS++))
}

print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

validate_marketplace_file() {
    print_header "Marketplace File"

    # Check if marketplace.json exists
    if [ ! -f "$MARKETPLACE_FILE" ]; then
        print_error "marketplace.json not found at $MARKETPLACE_PATH"
        return 1
    fi

    print_check "marketplace.json exists"

    # Check if valid JSON
    if ! jq empty "$MARKETPLACE_FILE" 2>/dev/null; then
        print_error "marketplace.json is not valid JSON"
        return 1
    fi

    print_check "marketplace.json is valid JSON"
}

validate_marketplace_schema() {
    print_header "Marketplace Schema"

    # Extract and validate required fields
    NAME=$(jq -r '.name // empty' "$MARKETPLACE_FILE")
    if [ -z "$NAME" ]; then
        print_error "Required field missing: name"
        return 1
    fi
    print_check "Marketplace name: $NAME"

    OWNER_NAME=$(jq -r '.owner.name // empty' "$MARKETPLACE_FILE")
    if [ -z "$OWNER_NAME" ]; then
        print_error "Required field missing: owner.name"
        return 1
    fi
    print_check "Owner name: $OWNER_NAME"

    OWNER_EMAIL=$(jq -r '.owner.email // empty' "$MARKETPLACE_FILE")
    if [ -z "$OWNER_EMAIL" ]; then
        print_error "Required field missing: owner.email"
        return 1
    fi
    print_check "Owner email: $OWNER_EMAIL"

    # Check plugins array exists
    if ! jq -e '.plugins | type == "array"' "$MARKETPLACE_FILE" >/dev/null 2>&1; then
        print_error "plugins field must be an array"
        return 1
    fi

    PLUGIN_COUNT=$(jq '.plugins | length' "$MARKETPLACE_FILE")
    print_check "Plugins array exists with $PLUGIN_COUNT entries"
}

validate_plugin_entries() {
    print_header "Plugin Entries"

    # Declare array for tracking names
    declare -a PLUGIN_NAMES
    DUPLICATE_COUNT=0

    # Iterate through plugins
    jq -r '.plugins[] | .name' "$MARKETPLACE_FILE" | while read -r PLUGIN_NAME; do
        # Check for duplicates
        if [[ " ${PLUGIN_NAMES[@]} " =~ " ${PLUGIN_NAME} " ]]; then
            print_error "Duplicate plugin name: $PLUGIN_NAME"
            ((DUPLICATE_COUNT++))
        else
            PLUGIN_NAMES+=("$PLUGIN_NAME")
        fi

        # Check kebab-case
        if ! [[ "$PLUGIN_NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
            print_error "Plugin name not in kebab-case: $PLUGIN_NAME"
        fi

        # Get plugin entry
        PLUGIN_ENTRY=$(jq ".plugins[] | select(.name == \"$PLUGIN_NAME\")" "$MARKETPLACE_FILE")

        # Check required fields
        SOURCE=$(echo "$PLUGIN_ENTRY" | jq -r '.source // empty')
        if [ -z "$SOURCE" ]; then
            print_error "Plugin $PLUGIN_NAME missing source field"
        fi

        DESC=$(echo "$PLUGIN_ENTRY" | jq -r '.description // empty')
        if [ -z "$DESC" ]; then
            print_error "Plugin $PLUGIN_NAME missing description field"
        fi

        VERSION=$(echo "$PLUGIN_ENTRY" | jq -r '.version // empty')
        AUTHOR=$(echo "$PLUGIN_ENTRY" | jq -r '.author // empty')
        CATEGORY=$(echo "$PLUGIN_ENTRY" | jq -r '.category // empty')

        # Only print check if all required fields present
        if [ -n "$SOURCE" ] && [ -n "$DESC" ]; then
            print_check "Plugin entry valid: $PLUGIN_NAME"
        fi
    done

    if [ "$DUPLICATE_COUNT" -gt 0 ]; then
        return 1
    fi
}

validate_plugin_sources() {
    print_header "Plugin Sources"

    # Check each plugin's source path
    jq -r '.plugins[] | "\(.name):\(.source)"' "$MARKETPLACE_FILE" | while IFS=: read -r PLUGIN_NAME SOURCE; do
        # Check if source is local path (starts with ./ or /)
        if [[ "$SOURCE" =~ ^\./|^/ ]]; then
            # Construct full path
            if [[ "$SOURCE" =~ ^\. ]]; then
                FULL_PATH="$MARKETPLACE_PATH/$SOURCE"
            else
                FULL_PATH="$SOURCE"
            fi

            # Normalize path
            FULL_PATH=$(cd "$(dirname "$FULL_PATH")" && pwd)/$(basename "$FULL_PATH")

            # Check if path exists
            if [ -d "$FULL_PATH" ]; then
                # Check if plugin.json exists
                if [ -f "$FULL_PATH/.claude-plugins/plugin.json" ]; then
                    print_check "Local plugin source valid: $PLUGIN_NAME → $SOURCE"
                else
                    print_error "Plugin $PLUGIN_NAME source missing plugin.json"
                fi
            else
                print_error "Local source path not found: $SOURCE"
            fi
        else
            # Remote source (GitHub, Git URL, etc)
            print_check "Remote plugin source: $PLUGIN_NAME → $SOURCE"
        fi
    done
}

validate_plugin_structures() {
    print_header "Deep Plugin Validation"

    if [ "$DEEP_MODE" != "--deep" ]; then
        echo "Skipping deep validation (use --deep flag to enable)"
        return 0
    fi

    # Validate each local plugin
    jq -r '.plugins[] | select(.source | test("^\\./|^/")) | "\(.name):\(.source)"' "$MARKETPLACE_FILE" | while IFS=: read -r PLUGIN_NAME SOURCE; do
        # Construct full path
        if [[ "$SOURCE" =~ ^\. ]]; then
            PLUGIN_DIR="$MARKETPLACE_PATH/$SOURCE"
        else
            PLUGIN_DIR="$SOURCE"
        fi

        # Run plugin validation if script exists
        PLUGIN_JSON="$PLUGIN_DIR/.claude-plugins/plugin.json"
        if [ -f "$PLUGIN_JSON" ]; then
            # Extract and validate basic fields
            P_NAME=$(jq -r '.name // empty' "$PLUGIN_JSON")
            P_VERSION=$(jq -r '.version // empty' "$PLUGIN_JSON")

            # Check name matches
            if [ "$P_NAME" != "$PLUGIN_NAME" ]; then
                print_warning "Plugin name mismatch: marketplace=$PLUGIN_NAME, plugin.json=$P_NAME"
            else
                print_check "Plugin validated: $PLUGIN_NAME v$P_VERSION"
                ((PLUGINS_VALIDATED++))
            fi
        fi
    done
}

validate_documentation() {
    print_header "Documentation"

    # Check README.md exists
    if [ -f "$MARKETPLACE_PATH/README.md" ]; then
        print_check "README.md found"

        # Check if README references plugins
        PLUGIN_COUNT=$(jq '.plugins | length' "$MARKETPLACE_FILE")
        README_REFS=$(grep -c "plugin\|Plugin" "$MARKETPLACE_PATH/README.md" || echo "0")

        if [ "$README_REFS" -gt 0 ]; then
            print_check "README contains plugin references"
        else
            print_warning "README may not document all plugins"
        fi
    else
        print_warning "README.md not found in marketplace directory"
    fi
}

print_summary() {
    print_header "Validation Summary"

    echo -e "Checks Passed:     ${GREEN}$PASSED${NC}"
    echo -e "Warnings:          ${YELLOW}$WARNINGS${NC}"
    echo -e "Errors:            ${RED}$ERRORS${NC}"

    if [ "$PLUGINS_VALIDATED" -gt 0 ]; then
        echo -e "Plugins Validated: ${GREEN}$PLUGINS_VALIDATED${NC}"
    fi
    echo ""

    # Get marketplace info
    NAME=$(jq -r '.name' "$MARKETPLACE_FILE")
    OWNER=$(jq -r '.owner.name' "$MARKETPLACE_FILE")
    PLUGIN_COUNT=$(jq '.plugins | length' "$MARKETPLACE_FILE")

    echo "Marketplace: $NAME"
    echo "Owner: $OWNER"
    echo "Plugins: $PLUGIN_COUNT"
    echo ""

    # Determine status
    if [ "$ERRORS" -eq 0 ]; then
        if [ "$WARNINGS" -eq 0 ]; then
            echo -e "Status: ${GREEN}✓ VALID${NC}"
            echo "Marketplace is ready for release"
            return 0
        else
            echo -e "Status: ${YELLOW}⚠ VALID_WITH_WARNINGS${NC}"
            echo "Marketplace is valid but has non-blocking warnings"
            return 0
        fi
    else
        echo -e "Status: ${RED}✗ INVALID${NC}"
        echo "Marketplace has errors that must be fixed"
        return 1
    fi
}

# Main validation flow
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║  Claude Code Marketplace Validator    ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"

    echo "Validating marketplace at: $MARKETPLACE_PATH"
    if [ "$DEEP_MODE" == "--deep" ]; then
        echo "Mode: DEEP (validating all plugins)"
    else
        echo "Mode: STANDARD (marketplace structure only)"
    fi

    # Run all validations
    validate_marketplace_file || exit 1
    validate_marketplace_schema || exit 1
    validate_plugin_entries || exit 1
    validate_plugin_sources
    validate_plugin_structures
    validate_documentation

    # Print summary and exit
    print_summary
    EXIT_CODE=$?

    exit $EXIT_CODE
}

main "$@"
