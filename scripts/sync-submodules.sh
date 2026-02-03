#!/usr/bin/env bash

# Submodule Sync Script
# Updates all plugin submodules to their latest versions

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MARKETPLACE_ROOT="$(dirname "$SCRIPT_DIR")"

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }

# Parse arguments
DRY_RUN=false
BRANCH="main"

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --branch)
            BRANCH="$2"
            shift 2
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Usage: $0 [--dry-run] [--branch <branch>]"
            exit 1
            ;;
    esac
done

# Main sync function
main() {
    cd "$MARKETPLACE_ROOT"

    log_info "Syncing plugin submodules..."
    if [ "$DRY_RUN" = true ]; then
        log_warning "DRY RUN MODE - No changes will be made"
    fi
    echo ""

    # Initialize submodules if not already done
    if [ ! -f ".gitmodules" ]; then
        log_error "No .gitmodules file found. No submodules to sync."
        exit 1
    fi

    log_info "Initializing submodules..."
    git submodule init

    # Get list of submodules
    local submodules=$(git submodule status | awk '{print $2}')

    if [ -z "$submodules" ]; then
        log_warning "No submodules found"
        exit 0
    fi

    # Update each submodule
    log_info "Updating submodules to latest $BRANCH branch..."
    echo ""

    for submodule in $submodules; do
        log_info "Processing: $submodule"

        if [ -d "$submodule" ]; then
            cd "$submodule"

            # Get current commit
            local old_commit=$(git rev-parse HEAD)
            local old_commit_short=$(git rev-parse --short HEAD)

            if [ "$DRY_RUN" = false ]; then
                # Fetch latest changes
                git fetch origin

                # Check if branch exists
                if git show-ref --verify --quiet "refs/remotes/origin/$BRANCH"; then
                    # Checkout and pull latest
                    git checkout "$BRANCH" 2>/dev/null || git checkout -b "$BRANCH" "origin/$BRANCH"
                    git pull origin "$BRANCH"
                else
                    log_warning "  Branch '$BRANCH' not found, staying on current branch"
                fi
            fi

            # Get new commit
            local new_commit=$(git rev-parse HEAD)
            local new_commit_short=$(git rev-parse --short HEAD)

            if [ "$old_commit" != "$new_commit" ]; then
                log_success "  Updated: $old_commit_short → $new_commit_short"

                # Show commit log
                echo "  Changes:"
                git log --oneline "$old_commit..$new_commit" | head -5 | sed 's/^/    /'
            else
                log_info "  Already up to date: $old_commit_short"
            fi

            cd "$MARKETPLACE_ROOT"
        else
            log_warning "  Submodule directory not found: $submodule"
        fi

        echo ""
    done

    # Check if there are changes to commit
    if git diff --quiet HEAD -- $(git submodule status | awk '{print $2}') 2>/dev/null; then
        log_info "No submodule updates to commit"
    else
        log_success "Submodules have been updated"

        if [ "$DRY_RUN" = false ]; then
            log_info "Changes are staged. Review and commit with:"
            echo "  git status"
            echo "  git diff"
            echo "  git commit -m 'chore: update plugin submodules'"
        else
            log_info "In dry-run mode, no changes were made"
        fi
    fi
}

main "$@"
