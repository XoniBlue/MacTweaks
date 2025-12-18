#!/bin/bash
###############################################################################
# MacTweaks/install.sh
# Installation script for MacTweaks toolkit
#
# DESCRIPTION:
#   Automates the installation process including permissions, symlinks,
#   and initial setup. Provides options for system-wide or user-only install.
#
# USAGE:
#   ./install.sh                    # Interactive installation
#   ./install.sh --system           # Install system-wide (requires sudo)
#   ./install.sh --user             # Install for current user only
#   ./install.sh --uninstall        # Remove installation
#
# WHAT IT DOES:
#   - Validates macOS environment
#   - Sets correct permissions on scripts
#   - Creates symlink for easy access
#   - Sets up directory structure
#   - Optionally adds to PATH
###############################################################################

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$SCRIPT_DIR/bin"
MAIN_SCRIPT="$BIN_DIR/mac-tweaks.sh"

# Installation paths
SYSTEM_INSTALL_DIR="/usr/local/bin"
USER_INSTALL_DIR="$HOME/.local/bin"

# Print colored messages
info() { echo -e "${BLUE}ℹ️  $*${NC}"; }
ok() { echo -e "${GREEN}✅ $*${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $*${NC}"; }
err() { echo -e "${RED}❌ $*${NC}"; }
die() { err "$*"; exit 1; }

# Check if running on macOS
check_macos() {
  [[ "$(uname)" == "Darwin" ]] || die "This installer only works on macOS."
}

# Validate repository structure
check_structure() {
  info "Validating repository structure..."

  [[ -f "$MAIN_SCRIPT" ]] || die "Main script not found: $MAIN_SCRIPT"
  [[ -d "$SCRIPT_DIR/lib" ]] || die "Library directory not found: $SCRIPT_DIR/lib"
  [[ -d "$SCRIPT_DIR/modules" ]] || die "Modules directory not found: $SCRIPT_DIR/modules"

  ok "Repository structure validated"
}

# Set correct permissions
set_permissions() {
  info "Setting correct permissions..."

  # Make main script executable
  chmod +x "$MAIN_SCRIPT" || die "Failed to set permissions on main script"

  # Make all library files readable
  chmod -R 644 "$SCRIPT_DIR/lib/"*.sh 2>/dev/null || true

  # Make all module files readable
  chmod -R 644 "$SCRIPT_DIR/modules/"*.sh 2>/dev/null || true

  ok "Permissions set correctly"
}

# Install system-wide (requires sudo)
install_system() {
  info "Installing MacTweaks system-wide..."

  # Check if sudo is available
  if ! sudo -v; then
    die "sudo access required for system-wide installation"
  fi

  # Create symlink in /usr/local/bin
  sudo ln -sf "$MAIN_SCRIPT" "$SYSTEM_INSTALL_DIR/mactweaks" || \
    die "Failed to create symlink in $SYSTEM_INSTALL_DIR"

  ok "Installed to: $SYSTEM_INSTALL_DIR/mactweaks"
  ok "You can now run: mactweaks"
}

# Install for current user only
install_user() {
  info "Installing MacTweaks for current user..."

  # Create user bin directory if it doesn't exist
  mkdir -p "$USER_INSTALL_DIR"

  # Create symlink in user's local bin
  ln -sf "$MAIN_SCRIPT" "$USER_INSTALL_DIR/mactweaks" || \
    die "Failed to create symlink in $USER_INSTALL_DIR"

  ok "Installed to: $USER_INSTALL_DIR/mactweaks"

  # Check if user's bin is in PATH
  if [[ ":$PATH:" != *":$USER_INSTALL_DIR:"* ]]; then
    warn "Note: $USER_INSTALL_DIR is not in your PATH"
    info "Add this line to your ~/.zshrc or ~/.bash_profile:"
    echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo
    info "Then run: source ~/.zshrc (or restart your terminal)"
  else
    ok "You can now run: mactweaks"
  fi
}

# Uninstall MacTweaks
uninstall() {
  info "Uninstalling MacTweaks..."

  local uninstalled=false

  # Remove system-wide installation
  if [[ -L "$SYSTEM_INSTALL_DIR/mactweaks" ]]; then
    sudo rm -f "$SYSTEM_INSTALL_DIR/mactweaks"
    ok "Removed system-wide installation"
    uninstalled=true
  fi

  # Remove user installation
  if [[ -L "$USER_INSTALL_DIR/mactweaks" ]]; then
    rm -f "$USER_INSTALL_DIR/mactweaks"
    ok "Removed user installation"
    uninstalled=true
  fi

  if $uninstalled; then
    ok "MacTweaks command uninstalled"
    info "To remove all data, run: mactweaks --uninstall (before removing files)"
    info "Repository files remain at: $SCRIPT_DIR"
  else
    warn "No MacTweaks installation found"
  fi
}

# Interactive installation
interactive_install() {
  echo "╔════════════════════════════════════════════════════════════╗"
  echo "║                                                            ║"
  echo "║              MacTweaks Installation Wizard                ║"
  echo "║                                                            ║"
  echo "╚════════════════════════════════════════════════════════════╝"
  echo

  info "This will install MacTweaks and create a 'mactweaks' command"
  echo
  echo "Installation options:"
  echo "  1) System-wide  (/usr/local/bin) - requires sudo, available to all users"
  echo "  2) User-only    (~/.local/bin)   - no sudo needed, current user only"
  echo "  3) Skip         (manual usage)    - no installation, use ./bin/mac-tweaks.sh"
  echo "  4) Cancel"
  echo

  read -r -p "Select option [1-4]: " choice

  case "$choice" in
    1)
      install_system
      ;;
    2)
      install_user
      ;;
    3)
      ok "Installation skipped"
      info "You can run MacTweaks with: $MAIN_SCRIPT"
      ;;
    4)
      info "Installation canceled"
      exit 0
      ;;
    *)
      err "Invalid choice"
      exit 1
      ;;
  esac
}

# Main installation logic
main() {
  # Check environment
  check_macos
  check_structure
  set_permissions

  # Parse arguments
  case "${1:---interactive}" in
    --system)
      install_system
      ;;
    --user)
      install_user
      ;;
    --uninstall)
      uninstall
      ;;
    --interactive)
      interactive_install
      ;;
    --help|-h)
      cat <<EOF
MacTweaks Installation Script

USAGE:
  ./install.sh [option]

OPTIONS:
  --system        Install system-wide (requires sudo)
  --user          Install for current user only
  --uninstall     Remove installation
  --interactive   Interactive installation wizard (default)
  --help          Show this help

EXAMPLES:
  ./install.sh                  # Interactive wizard
  ./install.sh --system         # Quick system-wide install
  ./install.sh --user           # Quick user install
  ./install.sh --uninstall      # Remove installation

AFTER INSTALLATION:
  Run: mactweaks
  Or:  mactweaks --help

EOF
      ;;
    *)
      die "Unknown option: $1 (use --help)"
      ;;
  esac

  echo
  ok "Installation complete!"
  info "Run 'mactweaks' or 'mactweaks --help' to get started"
}

# Run installer
main "$@"
