#!/usr/bin/env bash

# Marketplace Validation Script
# Validates marketplace.json against schema and checks plugin integrity

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MARKETPLACE_ROOT="$(dirname "$SCRIPT_DIR")"
MARKETPLACE_JSON="$MARKETPLACE_ROOT/marketplace.json"
SCHEMA_JSON="$MARKETPLACE_ROOT/schemas/plugin-schema.json"

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }

# Check for required tools
check_dependencies() {
    local missing_tools=()

    if ! command -v jq &> /dev/null; then
        missing_tools+=("jq")
    fi

    if [ ${#missing_tools[@]} -ne 0 ]; then
        log_error "Missing required tools: ${missing_tools[*]}"
        log_info "Install them first: sudo apt-get install ${missing_tools[*]}"
        exit 1
    fi
}

# Validate JSON syntax
validate_json_syntax() {
    log_info "Validating JSON syntax..."

    if jq empty "$MARKETPLACE_JSON" 2>/dev/null; then
        log_success "marketplace.json has valid JSON syntax"
    else
        log_error "marketplace.json has invalid JSON syntax"
        return 1
    fi

    if jq empty "$SCHEMA_JSON" 2>/dev/null; then
        log_success "plugin-schema.json has valid JSON syntax"
    else
        log_error "plugin-schema.json has invalid JSON syntax"
        return 1
    fi

    return 0
}

# Validate required fields
validate_required_fields() {
    log_info "Validating required fields..."

    local required_root_fields=("name" "version" "description" "owner" "repository" "plugins" "categories")
    local all_valid=true

    for field in "${required_root_fields[@]}"; do
        if jq -e ".$field" "$MARKETPLACE_JSON" &> /dev/null; then
            log_success "Required field present: $field"
        else
            log_error "Missing required field: $field"
            all_valid=false
        fi
    done

    # Validate plugin fields
    local plugin_count=$(jq '.plugins | length' "$MARKETPLACE_JSON")
    log_info "Validating $plugin_count plugins..."

    for ((i=0; i<plugin_count; i++)); do
        local plugin_id=$(jq -r ".plugins[$i].id" "$MARKETPLACE_JSON")
        log_info "Validating plugin: $plugin_id"

        local required_plugin_fields=("id" "name" "displayName" "type" "version" "description" "repository" "installation" "category")
        for field in "${required_plugin_fields[@]}"; do
            if jq -e ".plugins[$i].$field" "$MARKETPLACE_JSON" &> /dev/null; then
                : # Field present
            else
                log_error "  Missing field in plugin $plugin_id: $field"
                all_valid=false
            fi
        done
    done

    [ "$all_valid" = true ]
}

# Validate semantic versions
validate_versions() {
    log_info "Validating version numbers..."

    local marketplace_version=$(jq -r '.version' "$MARKETPLACE_JSON")
    if [[ ! "$marketplace_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?$ ]]; then
        log_error "Invalid marketplace version: $marketplace_version"
        return 1
    fi
    log_success "Marketplace version valid: $marketplace_version"

    local plugin_count=$(jq '.plugins | length' "$MARKETPLACE_JSON")
    local all_valid=true

    for ((i=0; i<plugin_count; i++)); do
        local plugin_id=$(jq -r ".plugins[$i].id" "$MARKETPLACE_JSON")
        local plugin_version=$(jq -r ".plugins[$i].version" "$MARKETPLACE_JSON")

        if [[ ! "$plugin_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?$ ]]; then
            log_error "Invalid version for $plugin_id: $plugin_version"
            all_valid=false
        fi
    done

    [ "$all_valid" = true ]
}

# Validate URLs
validate_urls() {
    log_info "Validating repository URLs..."

    local all_valid=true
    local plugin_count=$(jq '.plugins | length' "$MARKETPLACE_JSON")

    for ((i=0; i<plugin_count; i++)); do
        local plugin_id=$(jq -r ".plugins[$i].id" "$MARKETPLACE_JSON")
        local repo_url=$(jq -r ".plugins[$i].repository.url" "$MARKETPLACE_JSON")

        if [[ "$repo_url" =~ ^https:// ]]; then
            log_success "Valid URL for $plugin_id: $repo_url"
        else
            log_error "Invalid URL for $plugin_id: $repo_url"
            all_valid=false
        fi
    done

    [ "$all_valid" = true ]
}

# Validate category references
validate_categories() {
    log_info "Validating plugin categories..."

    local defined_categories=$(jq -r '.categories | keys[]' "$MARKETPLACE_JSON")
    local all_valid=true
    local plugin_count=$(jq '.plugins | length' "$MARKETPLACE_JSON")

    for ((i=0; i<plugin_count; i++)); do
        local plugin_id=$(jq -r ".plugins[$i].id" "$MARKETPLACE_JSON")
        local plugin_category=$(jq -r ".plugins[$i].category" "$MARKETPLACE_JSON")

        if echo "$defined_categories" | grep -q "^$plugin_category$"; then
            log_success "Valid category for $plugin_id: $plugin_category"
        else
            log_error "Invalid category for $plugin_id: $plugin_category (not defined in categories)"
            all_valid=false
        fi
    done

    [ "$all_valid" = true ]
}

# Validate submodule paths
validate_submodules() {
    log_info "Validating submodule paths..."

    local all_valid=true
    local plugin_count=$(jq '.plugins | length' "$MARKETPLACE_JSON")

    for ((i=0; i<plugin_count; i++)); do
        local plugin_id=$(jq -r ".plugins[$i].id" "$MARKETPLACE_JSON")
        local source_type=$(jq -r ".plugins[$i].source.type" "$MARKETPLACE_JSON")
        local source_path=$(jq -r ".plugins[$i].source.path" "$MARKETPLACE_JSON")

        if [ "$source_type" = "submodule" ]; then
            local full_path="$MARKETPLACE_ROOT/$source_path"
            if [ -d "$full_path" ]; then
                log_success "Submodule path exists for $plugin_id: $source_path"
            else
                log_warning "Submodule path missing for $plugin_id: $source_path (may need initialization)"
                all_valid=false
            fi
        fi
    done

    [ "$all_valid" = true ]
}

# Main validation
main() {
    log_info "Starting marketplace validation..."
    echo ""

    if [ ! -f "$MARKETPLACE_JSON" ]; then
        log_error "marketplace.json not found at $MARKETPLACE_JSON"
        exit 1
    fi

    if [ ! -f "$SCHEMA_JSON" ]; then
        log_error "plugin-schema.json not found at $SCHEMA_JSON"
        exit 1
    fi

    check_dependencies

    local validation_failed=false

    validate_json_syntax || validation_failed=true
    echo ""

    validate_required_fields || validation_failed=true
    echo ""

    validate_versions || validation_failed=true
    echo ""

    validate_urls || validation_failed=true
    echo ""

    validate_categories || validation_failed=true
    echo ""

    validate_submodules || log_warning "Some submodules need initialization"
    echo ""

    if [ "$validation_failed" = true ]; then
        log_error "Validation failed with errors"
        exit 1
    else
        log_success "All validations passed!"
        exit 0
    fi
}

main "$@"
