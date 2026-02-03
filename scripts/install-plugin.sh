#!/usr/bin/env bash

# Universal Plugin Installer for Glitch Kingdom Marketplace
# Usage: ./install-plugin.sh <plugin-name>

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MARKETPLACE_ROOT="$(dirname "$SCRIPT_DIR")"
MARKETPLACE_JSON="$MARKETPLACE_ROOT/marketplace.json"

# Function to print colored output
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

# Function to check if jq is installed
check_jq() {
    if ! command -v jq &> /dev/null; then
        log_error "jq is required but not installed. Please install jq first."
        log_info "On Ubuntu/Debian: sudo apt-get install jq"
        log_info "On macOS: brew install jq"
        exit 1
    fi
}

# Function to list all available plugins
list_plugins() {
    log_info "Available plugins in Glitch Kingdom Marketplace:"
    echo ""

    jq -r '.plugins[] | "  • \(.displayName) (\(.id))
    Type: \(.type)
    Status: \(.status)
    Description: \(.description)
    "' "$MARKETPLACE_JSON"
}

# Function to get plugin info from marketplace.json
get_plugin_info() {
    local plugin_id="$1"
    jq -r ".plugins[] | select(.id == \"$plugin_id\")" "$MARKETPLACE_JSON"
}

# Function to check requirements
check_requirements() {
    local plugin_info="$1"
    local requirements=$(echo "$plugin_info" | jq -r '.installation.requirements')

    log_info "Checking requirements..."

    # Check Node.js version if required
    if echo "$requirements" | jq -e '.node' &> /dev/null; then
        local node_version=$(echo "$requirements" | jq -r '.node')
        if command -v node &> /dev/null; then
            log_success "Node.js installed: $(node --version)"
        else
            log_error "Node.js $node_version is required but not installed"
            return 1
        fi
    fi

    # Check Claude Code version if required
    if echo "$requirements" | jq -e '."claude-code"' &> /dev/null; then
        local claude_version=$(echo "$requirements" | jq -r '."claude-code"')
        log_info "Claude Code $claude_version is required"
    fi

    # Check bash if required
    if echo "$requirements" | jq -e '.bash' &> /dev/null; then
        if command -v bash &> /dev/null; then
            log_success "Bash is installed"
        else
            log_error "Bash is required but not installed"
            return 1
        fi
    fi

    # Check Python version if required
    if echo "$requirements" | jq -e '.python' &> /dev/null; then
        local python_version=$(echo "$requirements" | jq -r '.python')
        if command -v python3 &> /dev/null; then
            log_success "Python 3 installed: $(python3 --version)"
        else
            log_error "Python $python_version is required but not installed"
            return 1
        fi
    fi

    return 0
}

# Function to show installation instructions
show_install_instructions() {
    local plugin_info="$1"
    local plugin_name=$(echo "$plugin_info" | jq -r '.name')
    local plugin_type=$(echo "$plugin_info" | jq -r '.type')
    local methods=$(echo "$plugin_info" | jq -r '.installation.methods')

    echo ""
    log_info "Installation Options for $plugin_name:"
    echo ""

    local method_count=$(echo "$methods" | jq 'length')
    for ((i=0; i<method_count; i++)); do
        local method=$(echo "$methods" | jq -r ".[$i]")
        local method_type=$(echo "$method" | jq -r '.type')

        case "$method_type" in
            "npm")
                local command=$(echo "$method" | jq -r '.command')
                echo "  [NPM] Install globally:"
                echo "  $ $command"
                echo ""
                ;;
            "npx")
                local command=$(echo "$method" | jq -r '.command')
                echo "  [NPX] Run without installing:"
                echo "  $ $command"
                echo ""
                ;;
            "claude-marketplace")
                local command=$(echo "$method" | jq -r '.command')
                echo "  [Claude Marketplace] Install via Claude Code:"
                echo "  $ $command"
                echo ""
                ;;
            "manual")
                echo "  [Manual] Clone and install:"
                local steps=$(echo "$method" | jq -r '.steps[]')
                echo "$steps" | while IFS= read -r step; do
                    echo "  $ $step"
                done
                echo ""
                ;;
            "github-action")
                local uses=$(echo "$method" | jq -r '.uses')
                echo "  [GitHub Action] Add to your workflow:"
                echo "  uses: $uses"
                echo ""
                ;;
            "included-in")
                local parent=$(echo "$method" | jq -r '.parent')
                local note=$(echo "$method" | jq -r '.note')
                echo "  [Included] $note"
                echo "  Install parent plugin: $parent"
                echo ""
                ;;
        esac
    done

    # Check for dependencies
    local dependencies=$(echo "$plugin_info" | jq -r '.dependencies')
    if [ "$dependencies" != "null" ]; then
        echo ""
        log_info "Dependencies:"

        if echo "$dependencies" | jq -e '.requires' &> /dev/null; then
            log_warning "Required plugins: $(echo "$dependencies" | jq -r '.requires | join(", ")')"
        fi

        if echo "$dependencies" | jq -e '.recommends' &> /dev/null; then
            log_info "Recommended plugins: $(echo "$dependencies" | jq -r '.recommends | join(", ")')"
        fi

        if echo "$dependencies" | jq -e '.includes' &> /dev/null; then
            log_info "Includes: $(echo "$dependencies" | jq -r '.includes | join(", ")')"
        fi
    fi

    # Show optional requirements
    if echo "$plugin_info" | jq -e '.installation.requirements.optional' &> /dev/null; then
        echo ""
        log_info "Optional dependencies:"
        echo "$plugin_info" | jq -r '.installation.requirements.optional | to_entries[] | "  • \(.key): \(.value)"'
    fi
}

# Main function
main() {
    # Check if marketplace.json exists
    if [ ! -f "$MARKETPLACE_JSON" ]; then
        log_error "marketplace.json not found at $MARKETPLACE_JSON"
        exit 1
    fi

    # Check for jq
    check_jq

    # Parse arguments
    if [ $# -eq 0 ]; then
        log_error "Usage: $0 <plugin-name>"
        echo ""
        list_plugins
        exit 1
    fi

    local plugin_id="$1"

    # Special case: list command
    if [ "$plugin_id" == "list" ] || [ "$plugin_id" == "--list" ] || [ "$plugin_id" == "-l" ]; then
        list_plugins
        exit 0
    fi

    # Get plugin info
    log_info "Looking up plugin: $plugin_id"
    local plugin_info=$(get_plugin_info "$plugin_id")

    if [ -z "$plugin_info" ] || [ "$plugin_info" == "null" ]; then
        log_error "Plugin '$plugin_id' not found in marketplace"
        echo ""
        list_plugins
        exit 1
    fi

    local display_name=$(echo "$plugin_info" | jq -r '.displayName')
    local description=$(echo "$plugin_info" | jq -r '.description')
    local status=$(echo "$plugin_info" | jq -r '.status')
    local homepage=$(echo "$plugin_info" | jq -r '.homepage')

    echo ""
    log_success "Found: $display_name"
    echo "  Description: $description"
    echo "  Status: $status"
    echo "  Homepage: $homepage"

    # Check requirements
    if ! check_requirements "$plugin_info"; then
        log_error "Requirements check failed"
        exit 1
    fi

    # Show installation instructions
    show_install_instructions "$plugin_info"

    echo ""
    log_success "Installation instructions displayed above"
    log_info "For more information, visit: $homepage"
}

main "$@"
