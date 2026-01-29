#!/bin/bash

# Marketplace Manager - Plugin Validator
# Validates Claude Code plugin structure and best practices

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PLUGIN_PATH="${1:-.}"
STRICT_MODE="${2:--strict}"

# Counters
PASSED=0
WARNINGS=0
ERRORS=0

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

validate_directory_structure() {
    print_header "Directory Structure"

    # Check if plugin path exists
    if [ ! -d "$PLUGIN_PATH" ]; then
        print_error "Plugin directory does not exist: $PLUGIN_PATH"
        return 1
    fi

    # Check for plugin directory - support both structures:
    # 1. .claude-plugin/ (singular - official Claude Code convention)
    # 2. Root plugin.json (flat structure for simple plugins)
    if [ -d "$PLUGIN_PATH/.claude-plugin" ]; then
        PLUGIN_DIR="$PLUGIN_PATH/.claude-plugin"
        print_check ".claude-plugin directory exists"
    elif [ -f "$PLUGIN_PATH/plugin.json" ]; then
        PLUGIN_DIR="$PLUGIN_PATH"
        print_check "Root plugin structure detected"
    else
        print_error "No valid plugin structure found (expected .claude-plugin/ or plugin.json at root)"
        return 1
    fi

    # Check for plugin.json
    if [ ! -f "$PLUGIN_DIR/plugin.json" ]; then
        print_error "plugin.json not found"
        return 1
    fi

    print_check "plugin.json file exists"

    # Export for use in other functions
    export PLUGIN_DIR
}

validate_plugin_json() {
    print_header "Plugin Manifest (plugin.json)"

    MANIFEST="$PLUGIN_DIR/plugin.json"

    # Check if valid JSON
    if ! jq empty "$MANIFEST" 2>/dev/null; then
        print_error "plugin.json is not valid JSON"
        return 1
    fi

    print_check "JSON is valid"

    # Extract fields
    NAME=$(jq -r '.name // empty' "$MANIFEST")
    VERSION=$(jq -r '.version // empty' "$MANIFEST")
    DESCRIPTION=$(jq -r '.description // empty' "$MANIFEST")

    # Validate name
    if [ -z "$NAME" ]; then
        print_error "Required field missing: name"
        return 1
    fi

    # Check kebab-case
    if ! [[ "$NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
        print_error "Plugin name must be kebab-case: $NAME"
        return 1
    fi

    print_check "Plugin name valid: $NAME"

    # Validate version
    if [ -z "$VERSION" ]; then
        print_error "Required field missing: version"
        return 1
    fi

    # Check semver format (X.Y.Z)
    if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_error "Version must follow semver (X.Y.Z): $VERSION"
        return 1
    fi

    print_check "Version valid: $VERSION"

    # Validate description
    if [ -z "$DESCRIPTION" ]; then
        print_error "Required field missing: description"
        return 1
    fi

    DESC_LEN=${#DESCRIPTION}
    if [ "$DESC_LEN" -lt 10 ] || [ "$DESC_LEN" -gt 200 ]; then
        print_warning "Description should be 10-200 characters (current: $DESC_LEN)"
    else
        print_check "Description length valid: $DESC_LEN characters"
    fi

    # Validate optional fields
    AUTHOR=$(jq -r '.author.name // empty' "$MANIFEST")
    if [ -z "$AUTHOR" ] && [ "$STRICT_MODE" == "-strict" ]; then
        print_warning "Author name not provided"
    elif [ -n "$AUTHOR" ]; then
        print_check "Author provided: $AUTHOR"
    fi

    LICENSE=$(jq -r '.license // empty' "$MANIFEST")
    if [ -n "$LICENSE" ]; then
        print_check "License specified: $LICENSE"
    fi
}

validate_components() {
    print_header "Components"

    COMPONENTS_FOUND=0

    # Check for commands directory
    if [ -d "$PLUGIN_DIR/commands" ]; then
        COMMAND_COUNT=$(find "$PLUGIN_DIR/commands" -name "*.md" 2>/dev/null | wc -l)
        if [ "$COMMAND_COUNT" -gt 0 ]; then
            print_check "Commands found: $COMMAND_COUNT"
            ((COMPONENTS_FOUND++))
        fi
    fi

    # Check for agents directory
    if [ -d "$PLUGIN_DIR/agents" ]; then
        AGENT_COUNT=$(find "$PLUGIN_DIR/agents" -name "*.md" 2>/dev/null | wc -l)
        if [ "$AGENT_COUNT" -gt 0 ]; then
            print_check "Agents found: $AGENT_COUNT"
            ((COMPONENTS_FOUND++))
        fi
    fi

    # Check for skills directory
    if [ -d "$PLUGIN_DIR/skills" ]; then
        SKILL_COUNT=$(find "$PLUGIN_DIR/skills" -name "*.md" 2>/dev/null | wc -l)
        if [ "$SKILL_COUNT" -gt 0 ]; then
            print_check "Skills found: $SKILL_COUNT"
            ((COMPONENTS_FOUND++))
        fi
    fi

    # Check for hooks
    if [ -d "$PLUGIN_DIR/hooks" ]; then
        HOOK_COUNT=$(find "$PLUGIN_DIR/hooks" -type f 2>/dev/null | wc -l)
        if [ "$HOOK_COUNT" -gt 0 ]; then
            print_check "Hooks found: $HOOK_COUNT"
            ((COMPONENTS_FOUND++))
        fi
    fi

    # Check for MCP config
    if [ -f "$PLUGIN_DIR/.mcp.json" ]; then
        print_check "MCP server configured"
        ((COMPONENTS_FOUND++))
    fi

    # At least one component required
    if [ "$COMPONENTS_FOUND" -eq 0 ]; then
        print_error "No components found (commands, agents, skills, hooks, or .mcp.json required)"
        return 1
    else
        print_check "At least one component type present"
    fi
}

validate_documentation() {
    print_header "Documentation"

    # Check README.md - look in plugin dir, then root
    if [ -f "$PLUGIN_DIR/README.md" ]; then
        README_FILE="$PLUGIN_DIR/README.md"
    elif [ -f "$PLUGIN_PATH/README.md" ]; then
        README_FILE="$PLUGIN_PATH/README.md"
    else
        print_error "README.md not found"
        return 1
    fi

    print_check "README.md found"

    # Check README content
    if grep -q "Usage\|Example\|Install" "$README_FILE" 2>/dev/null; then
        print_check "README contains usage information"
    else
        print_warning "README should include Usage, Examples, or Installation sections"
    fi
}

print_summary() {
    print_header "Validation Summary"

    echo -e "Checks Passed:  ${GREEN}$PASSED${NC}"
    echo -e "Warnings:       ${YELLOW}$WARNINGS${NC}"
    echo -e "Errors:         ${RED}$ERRORS${NC}"
    echo ""

    # Determine status
    if [ "$ERRORS" -eq 0 ]; then
        if [ "$WARNINGS" -eq 0 ]; then
            echo -e "Status: ${GREEN}✓ VALID${NC}"
            echo "Plugin is ready for marketplace"
            return 0
        else
            echo -e "Status: ${YELLOW}⚠ VALID_WITH_WARNINGS${NC}"
            echo "Plugin is valid but has best practice warnings"
            return 0
        fi
    else
        echo -e "Status: ${RED}✗ INVALID${NC}"
        echo "Plugin has errors that must be fixed"
        return 1
    fi
}

# Main validation flow
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║   Claude Code Plugin Validator         ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"

    echo "Validating plugin at: $PLUGIN_PATH"
    echo "Mode: $([ "$STRICT_MODE" == "-strict" ] && echo "STRICT" || echo "STANDARD")"

    # Run all validations
    validate_directory_structure || exit 1
    validate_plugin_json || exit 1
    validate_components || exit 1
    validate_documentation

    # Print summary and exit
    print_summary
    EXIT_CODE=$?

    exit $EXIT_CODE
}

main "$@"
