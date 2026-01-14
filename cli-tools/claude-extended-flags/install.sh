#!/bin/bash
#
# install.sh - Install claude-wrapper for extended CLI flags
#
# This script:
# 1. Checks dependencies (jq, curl, claude)
# 2. Installs claude-wrapper to ~/.local/bin/
# 3. Adds shell alias so `claude` uses the wrapper
# 4. Configures CLAUDE_REAL_PATH environment variable
#
# v2.0 - API-based implementation (no longer requires expect)
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installation directory
INSTALL_DIR="${HOME}/.local/bin"
WRAPPER_NAME="claude-wrapper"

# ============================================================================
# Helper Functions
# ============================================================================

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# ============================================================================
# Dependency Checks
# ============================================================================

check_jq() {
    info "Checking for 'jq'..."
    if command -v jq &>/dev/null; then
        success "jq is installed: $(command -v jq)"
        return 0
    else
        error "'jq' is not installed."
        echo ""
        if [[ "$(uname)" == "Darwin" ]]; then
            echo "  Install with: brew install jq"
        else
            echo "  Install with: sudo apt install jq  # Debian/Ubuntu"
            echo "            or: sudo yum install jq  # RHEL/CentOS"
        fi
        return 1
    fi
}

check_curl() {
    info "Checking for 'curl'..."
    if command -v curl &>/dev/null; then
        success "curl is installed: $(command -v curl)"
        return 0
    else
        error "'curl' is not installed."
        echo ""
        if [[ "$(uname)" == "Darwin" ]]; then
            echo "  Install with: brew install curl"
        else
            echo "  Install with: sudo apt install curl  # Debian/Ubuntu"
            echo "            or: sudo yum install curl  # RHEL/CentOS"
        fi
        return 1
    fi
}

check_claude() {
    info "Checking for 'claude' CLI..." >&2

    local claude_path=""

    # Check common Claude Code installation locations
    for candidate in "${HOME}/.local/bin/claude" /usr/local/bin/claude /opt/homebrew/bin/claude "${HOME}/.claude/local/bin/claude"; do
        if [[ -x "$candidate" ]]; then
            # Verify it's the real claude (symlink to versions dir or actual binary)
            # and not our wrapper script
            if [[ -L "$candidate" ]] || file "$candidate" 2>/dev/null | grep -q "executable"; then
                # Check it's not our wrapper by looking for our shebang comment
                if ! head -5 "$candidate" 2>/dev/null | grep -q "claude-wrapper"; then
                    claude_path="$candidate"
                    break
                fi
            fi
        fi
    done

    # If not found, search PATH
    if [[ -z "$claude_path" ]] && command -v claude &>/dev/null; then
        local found_path
        found_path="$(command -v claude)"
        if ! head -5 "$found_path" 2>/dev/null | grep -q "claude-wrapper"; then
            claude_path="$found_path"
        fi
    fi

    if [[ -n "$claude_path" ]]; then
        success "claude is installed: $claude_path" >&2
        echo "$claude_path"
        return 0
    else
        error "'claude' CLI is not installed or not in PATH." >&2
        echo "  Install Claude Code from: https://claude.ai/download" >&2
        return 1
    fi
}

check_macos() {
    info "Checking platform..."
    if [[ "$(uname)" != "Darwin" ]]; then
        error "This version of claude-wrapper requires macOS."
        echo ""
        echo "  The wrapper uses macOS Keychain for credential access."
        echo "  Linux/Windows support is planned for a future release."
        return 1
    fi
    success "Platform: macOS"
    return 0
}

# ============================================================================
# Shell Configuration
# ============================================================================

detect_shell_config() {
    local shell_name
    shell_name="$(basename "$SHELL")"

    case "$shell_name" in
        zsh)
            echo "${HOME}/.zshrc"
            ;;
        bash)
            if [[ -f "${HOME}/.bash_profile" ]]; then
                echo "${HOME}/.bash_profile"
            else
                echo "${HOME}/.bashrc"
            fi
            ;;
        fish)
            echo "${HOME}/.config/fish/config.fish"
            ;;
        *)
            # Default to bashrc
            echo "${HOME}/.bashrc"
            ;;
    esac
}

add_shell_config() {
    local config_file="$1"
    local real_claude_path="$2"
    local wrapper_path="$3"

    info "Configuring shell: $config_file"

    # Create config file if it doesn't exist
    if [[ ! -f "$config_file" ]]; then
        touch "$config_file"
    fi

    # Check if already configured
    if grep -q "CLAUDE_REAL_PATH" "$config_file" 2>/dev/null; then
        warn "Shell config already contains CLAUDE_REAL_PATH. Updating..."
        # Remove old config
        if [[ "$(uname)" == "Darwin" ]]; then
            sed -i '' '/# claude-extended-flags/d' "$config_file"
            sed -i '' '/CLAUDE_REAL_PATH/d' "$config_file"
            sed -i '' '/alias claude=.*claude-wrapper/d' "$config_file"
        else
            sed -i '/# claude-extended-flags/d' "$config_file"
            sed -i '/CLAUDE_REAL_PATH/d' "$config_file"
            sed -i '/alias claude=.*claude-wrapper/d' "$config_file"
        fi
    fi

    # Add new configuration
    local shell_name
    shell_name="$(basename "$SHELL")"

    echo "" >> "$config_file"
    echo "# claude-extended-flags - Added by install.sh" >> "$config_file"

    if [[ "$shell_name" == "fish" ]]; then
        echo "set -gx CLAUDE_REAL_PATH \"$real_claude_path\"" >> "$config_file"
        echo "alias claude \"$wrapper_path\"" >> "$config_file"
    else
        echo "export CLAUDE_REAL_PATH=\"$real_claude_path\"" >> "$config_file"
        echo "alias claude=\"$wrapper_path\"" >> "$config_file"
    fi

    success "Added configuration to $config_file"
}

# ============================================================================
# Installation
# ============================================================================

install_wrapper() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local wrapper_source="$script_dir/claude-wrapper"

    # Check if wrapper source exists
    if [[ ! -f "$wrapper_source" ]]; then
        error "claude-wrapper not found at: $wrapper_source" >&2
        return 1
    fi

    # Create install directory
    if [[ ! -d "$INSTALL_DIR" ]]; then
        info "Creating directory: $INSTALL_DIR" >&2
        mkdir -p "$INSTALL_DIR"
    fi

    # Copy wrapper
    local wrapper_dest="$INSTALL_DIR/$WRAPPER_NAME"
    info "Installing wrapper to: $wrapper_dest" >&2
    cp "$wrapper_source" "$wrapper_dest"
    chmod +x "$wrapper_dest"

    success "Installed claude-wrapper" >&2
    echo "$wrapper_dest"
}

# ============================================================================
# Main
# ============================================================================

main() {
    echo ""
    echo "=========================================="
    echo "  claude-extended-flags Installer v2.0"
    echo "  (API-based - fast & reliable)"
    echo "=========================================="
    echo ""

    # Check dependencies
    local deps_ok=true

    if ! check_macos; then
        deps_ok=false
    fi

    if ! check_jq; then
        deps_ok=false
    fi

    if ! check_curl; then
        deps_ok=false
    fi

    local real_claude_path
    real_claude_path=$(check_claude) || deps_ok=false

    if [[ "$deps_ok" != "true" ]]; then
        echo ""
        error "Please install missing dependencies and run this script again."
        exit 1
    fi

    echo ""

    # Install wrapper
    local wrapper_path
    wrapper_path=$(install_wrapper) || exit 1

    echo ""

    # Configure shell
    local shell_config
    shell_config=$(detect_shell_config)

    add_shell_config "$shell_config" "$real_claude_path" "$wrapper_path"

    echo ""
    echo "=========================================="
    echo "  Installation Complete!"
    echo "=========================================="
    echo ""
    echo "To activate, either:"
    echo "  1. Open a new terminal window"
    echo "  2. Or run: source $shell_config"
    echo ""
    echo "Then try these commands:"
    echo "  claude --usage               # Usage with progress bars"
    echo "  claude --status              # Session info"
    echo "  claude --config              # Configuration"
    echo "  claude --usage --format=json # JSON output for scripting"
    echo ""
    echo "Performance: ~0.3s (vs 3-5s with old expect-based version)"
    echo ""
    echo "All other claude commands work normally:"
    echo "  claude                       # Interactive mode"
    echo "  claude -p \"hello\"            # One-shot prompt"
    echo ""
    echo "For help with extended flags:"
    echo "  claude --help-extended"
    echo ""
}

main "$@"
