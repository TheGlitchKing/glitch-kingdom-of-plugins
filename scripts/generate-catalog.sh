#!/usr/bin/env bash

# Catalog Generator Script
# Generates human-readable and machine-readable plugin catalogs

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
CATALOG_DIR="$MARKETPLACE_ROOT/catalog"
CATALOG_INDEX="$CATALOG_DIR/index.md"
CATALOG_JSON="$CATALOG_DIR/plugins.json"
CATALOG_CATEGORY_DIR="$CATALOG_DIR/by-category"

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }

# Check dependencies
check_dependencies() {
    if ! command -v jq &> /dev/null; then
        log_error "jq is required but not installed"
        exit 1
    fi
}

# Generate main catalog index
generate_index() {
    log_info "Generating catalog/index.md..."

    local marketplace_name=$(jq -r '.name' "$MARKETPLACE_JSON")
    local marketplace_version=$(jq -r '.version' "$MARKETPLACE_JSON")
    local marketplace_desc=$(jq -r '.description' "$MARKETPLACE_JSON")
    local plugin_count=$(jq '.plugins | length' "$MARKETPLACE_JSON")

    cat > "$CATALOG_INDEX" << EOF
# Plugin Catalog

**Marketplace**: $marketplace_name v$marketplace_version
**Description**: $marketplace_desc
**Total Plugins**: $plugin_count

---

## All Plugins

EOF

    # Generate plugin entries
    jq -r '.plugins[] | "### \(.displayName)\n\n**ID**: `\(.id)`\n**Type**: \(.type)\n**Version**: \(.version)\n**Status**: \(.status)\n**Category**: \(.category)\n\n\(.description)\n\n**Homepage**: \(.homepage)\n\n**Installation**:\n"' "$MARKETPLACE_JSON" >> "$CATALOG_INDEX"

    # Add installation commands for each plugin
    local plugin_count=$(jq '.plugins | length' "$MARKETPLACE_JSON")
    for ((i=0; i<plugin_count; i++)); do
        local plugin_id=$(jq -r ".plugins[$i].id" "$MARKETPLACE_JSON")
        local methods=$(jq -r ".plugins[$i].installation.methods" "$MARKETPLACE_JSON")
        local method_count=$(echo "$methods" | jq 'length')

        for ((j=0; j<method_count; j++)); do
            local method_type=$(echo "$methods" | jq -r ".[$j].type")
            case "$method_type" in
                "npm")
                    local command=$(echo "$methods" | jq -r ".[$j].command")
                    echo "- **NPM**: \`$command\`" >> "$CATALOG_INDEX"
                    ;;
                "claude-marketplace")
                    local command=$(echo "$methods" | jq -r ".[$j].command")
                    echo "- **Claude**: \`$command\`" >> "$CATALOG_INDEX"
                    ;;
                "npx")
                    local command=$(echo "$methods" | jq -r ".[$j].command")
                    echo "- **NPX**: \`$command\`" >> "$CATALOG_INDEX"
                    ;;
            esac
        done

        echo "" >> "$CATALOG_INDEX"
        echo "**Tags**: $(jq -r ".plugins[$i].tags | join(\", \")" "$MARKETPLACE_JSON")" >> "$CATALOG_INDEX"
        echo "" >> "$CATALOG_INDEX"
        echo "---" >> "$CATALOG_INDEX"
        echo "" >> "$CATALOG_INDEX"
    done

    # Add category index
    cat >> "$CATALOG_INDEX" << EOF

## By Category

EOF

    jq -r '.categories | to_entries[] | "- **[\(.value.name)](./by-category/\(.key).md)**: \(.value.description)"' "$MARKETPLACE_JSON" >> "$CATALOG_INDEX"

    log_success "Generated catalog/index.md"
}

# Generate machine-readable JSON catalog
generate_json() {
    log_info "Generating catalog/plugins.json..."

    jq '{
        marketplace: {
            name: .name,
            version: .version,
            description: .description
        },
        plugins: .plugins | map({
            id,
            name,
            displayName,
            type,
            version,
            description,
            category,
            tags,
            keywords,
            status,
            homepage,
            repository: .repository.url,
            installation: .installation.methods[0]
        }),
        categories: .categories
    }' "$MARKETPLACE_JSON" > "$CATALOG_JSON"

    log_success "Generated catalog/plugins.json"
}

# Generate category pages
generate_category_pages() {
    log_info "Generating category pages..."

    local categories=$(jq -r '.categories | keys[]' "$MARKETPLACE_JSON")

    for category in $categories; do
        local category_name=$(jq -r ".categories.\"$category\".name" "$MARKETPLACE_JSON")
        local category_desc=$(jq -r ".categories.\"$category\".description" "$MARKETPLACE_JSON")
        local category_file="$CATALOG_CATEGORY_DIR/$category.md"

        cat > "$category_file" << EOF
# $category_name

$category_desc

---

EOF

        # Get plugins in this category
        local plugins=$(jq -r ".plugins[] | select(.category == \"$category\") | .id" "$MARKETPLACE_JSON")

        if [ -z "$plugins" ]; then
            echo "No plugins in this category yet." >> "$category_file"
        else
            for plugin_id in $plugins; do
                local plugin=$(jq ".plugins[] | select(.id == \"$plugin_id\")" "$MARKETPLACE_JSON")
                local display_name=$(echo "$plugin" | jq -r '.displayName')
                local description=$(echo "$plugin" | jq -r '.description')
                local version=$(echo "$plugin" | jq -r '.version')
                local status=$(echo "$plugin" | jq -r '.status')
                local homepage=$(echo "$plugin" | jq -r '.homepage')

                cat >> "$category_file" << EOF
## $display_name

**Version**: $version
**Status**: $status

$description

[Homepage]($homepage) | [Marketplace](../../plugins/$plugin_id)

---

EOF
            done
        fi

        log_success "Generated by-category/$category.md"
    done
}

# Main function
main() {
    if [ ! -f "$MARKETPLACE_JSON" ]; then
        log_error "marketplace.json not found at $MARKETPLACE_JSON"
        exit 1
    fi

    check_dependencies

    log_info "Starting catalog generation..."
    echo ""

    # Ensure catalog directories exist
    mkdir -p "$CATALOG_DIR" "$CATALOG_CATEGORY_DIR"

    # Generate catalogs
    generate_index
    generate_json
    generate_category_pages

    echo ""
    log_success "Catalog generation complete!"
    echo ""
    log_info "Generated files:"
    echo "  - catalog/index.md"
    echo "  - catalog/plugins.json"
    echo "  - catalog/by-category/*.md"
}

main "$@"
