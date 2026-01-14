#!/bin/bash
#
# uninstall.sh - Remove claude-extended-flags
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

echo ""
echo "=========================================="
echo "  claude-extended-flags Uninstaller"
echo "=========================================="
echo ""

# Remove wrapper
WRAPPER_PATH="${HOME}/.local/bin/claude-wrapper"
if [[ -f "$WRAPPER_PATH" ]]; then
    info "Removing wrapper: $WRAPPER_PATH"
    rm "$WRAPPER_PATH"
    success "Removed wrapper"
else
    info "Wrapper not found at $WRAPPER_PATH (already removed?)"
fi

# Clean up shell configs
for config_file in ~/.zshrc ~/.bashrc ~/.bash_profile ~/.config/fish/config.fish; do
    if [[ -f "$config_file" ]]; then
        if grep -q "claude-extended-flags" "$config_file" 2>/dev/null; then
            info "Cleaning up: $config_file"
            if [[ "$(uname)" == "Darwin" ]]; then
                sed -i '' '/# claude-extended-flags/d' "$config_file"
                sed -i '' '/CLAUDE_REAL_PATH/d' "$config_file"
                sed -i '' '/alias claude=.*claude-wrapper/d' "$config_file"
            else
                sed -i '/# claude-extended-flags/d' "$config_file"
                sed -i '/CLAUDE_REAL_PATH/d' "$config_file"
                sed -i '/alias claude=.*claude-wrapper/d' "$config_file"
            fi
            success "Cleaned $config_file"
        fi
    fi
done

echo ""
echo "=========================================="
echo "  Uninstall Complete!"
echo "=========================================="
echo ""
echo "Open a new terminal or run: source ~/.zshrc"
echo ""
