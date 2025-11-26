#!/bin/bash
#
# Squads Upgrade Script
#
# Clones the latest squads repo and installs files from GitHub main branch.
#
# Usage (recommended):
#   just squads upgrade
#
# Or directly with curl:
#   curl -fsSL https://raw.githubusercontent.com/neodejack/squads/main/upgrade.sh | bash
#
# Or run locally:
#   ./upgrade.sh
#
# Requirements:
#   - Must be run from root of a squads repository
#   - Requires git to be installed
#   - GitHub repository must be accessible
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# GitHub repository details
GITHUB_REPO="https://github.com/neodejack/squads.git"
GITHUB_BRANCH="main"

# Temporary directory for clone
TEMP_DIR=""

# Cleanup function
cleanup() {
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
}

# Set trap to cleanup on exit
trap cleanup EXIT

# Print colored message
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Check if we're in a squads repo
check_squads_repo() {
    if [ ! -f "squads.just" ]; then
        print_message "$RED" "Error: Not in a squads repository (squads.just not found)"
        print_message "$YELLOW" "Please run this script from the root of a squads-enabled repository"
        exit 1
    fi
}

# Check dependencies
check_dependencies() {
    if ! command -v git &> /dev/null; then
        print_message "$RED" "Error: git is required but not installed"
        exit 1
    fi
}

# Clone repository
clone_repo() {
    print_message "$BLUE" "Cloning latest squads repository..."

    TEMP_DIR=$(mktemp -d)

    if git clone --quiet --depth 1 --branch "$GITHUB_BRANCH" "$GITHUB_REPO" "$TEMP_DIR" 2>/dev/null; then
        print_message "$GREEN" "  ✓ Repository cloned successfully"
    else
        print_message "$RED" "  ✗ Failed to clone repository"
        print_message "$RED" "  Repository: $GITHUB_REPO"
        print_message "$YELLOW" ""
        print_message "$YELLOW" "This could mean:"
        print_message "$YELLOW" "  - The repository is private (requires authentication)"
        print_message "$YELLOW" "  - Network connectivity issues"
        print_message "$YELLOW" "  - The branch '$GITHUB_BRANCH' doesn't exist"
        exit 1
    fi

    echo ""
}

# Discover files to upgrade
discover_files() {
    local files=()

    # Add squads.just
    if [ -f "$TEMP_DIR/squads.just" ]; then
        files+=("squads.just")
    fi

    # Add all files from hacks/squads/
    if [ -d "$TEMP_DIR/hacks/squads" ]; then
        while IFS= read -r -d '' file; do
            # Get relative path from temp directory
            local rel_path="${file#$TEMP_DIR/}"
            files+=("$rel_path")
        done < <(find "$TEMP_DIR/hacks/squads" -type f -print0)
    fi

    # Return the array
    printf '%s\n' "${files[@]}"
}

# Compare and show what will change
show_changes() {
    local new_files=()
    local overwrite_files=()
    local unchanged_files=()

    print_message "$BLUE" "Analyzing changes..."
    echo ""

    # Discover all files from cloned repo
    local all_files=()
    while IFS= read -r file; do
        all_files+=("$file")
    done < <(discover_files)

    for file in "${all_files[@]}"; do
        local temp_file="$TEMP_DIR/$file"

        if [ -f "$file" ]; then
            # File exists, check if it's different
            if ! cmp -s "$temp_file" "$file"; then
                overwrite_files+=("$file")
            else
                unchanged_files+=("$file")
            fi
        else
            # New file
            new_files+=("$file")
        fi
    done

    # Display new files
    if [ ${#new_files[@]} -gt 0 ]; then
        print_message "$GREEN" "Files to be added:"
        for file in "${new_files[@]}"; do
            echo "  + $file"
        done
        echo ""
    fi

    # Display files to be overwritten
    if [ ${#overwrite_files[@]} -gt 0 ]; then
        print_message "$YELLOW" "Files to be overwritten:"
        for file in "${overwrite_files[@]}"; do
            echo "  ~ $file"
        done
        echo ""
    fi

    # Display unchanged files
    if [ ${#unchanged_files[@]} -gt 0 ]; then
        print_message "$BLUE" "Files already up to date:"
        for file in "${unchanged_files[@]}"; do
            echo "  = $file"
        done
        echo ""
    fi

    # Check if there are any changes
    if [ ${#new_files[@]} -eq 0 ] && [ ${#overwrite_files[@]} -eq 0 ]; then
        print_message "$GREEN" "All files are already up to date!"
        exit 0
    fi

    # Store files that need to be copied
    FILES_TO_COPY=("${new_files[@]}" "${overwrite_files[@]}")
}

# Prompt for confirmation
confirm_upgrade() {
    echo -n "Do you want to proceed with the upgrade? (y/N): "
    read -r response

    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_message "$YELLOW" "Upgrade cancelled"
        exit 0
    fi

    echo ""
}

# Install files
install_files() {
    print_message "$BLUE" "Installing files..."

    for file in "${FILES_TO_COPY[@]}"; do
        local temp_file="$TEMP_DIR/$file"
        local dir=$(dirname "$file")

        # Create directory if needed
        if [ "$dir" != "." ]; then
            mkdir -p "$dir"
        fi

        # Copy file
        cp "$temp_file" "$file"

        # Preserve executable permissions
        if [ -x "$temp_file" ]; then
            chmod +x "$file"
        fi

        print_message "$GREEN" "  ✓ Installed: $file"
    done

    echo ""
    print_message "$GREEN" "✓ Upgrade completed successfully!"
}

# Main execution
main() {
    print_message "$BLUE" "Squads Upgrade Script"
    print_message "$BLUE" "===================="
    echo ""

    check_dependencies
    check_squads_repo
    clone_repo
    show_changes
    confirm_upgrade
    install_files
}

# Array to store files that need to be copied
declare -a FILES_TO_COPY

main
