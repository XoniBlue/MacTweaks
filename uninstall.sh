#!/bin/bash
###############################################################################
# MacTweaks/uninstall.sh
# Complete uninstallation script for MacTweaks toolkit
#
# DESCRIPTION:
#   Removes all MacTweaks files, data, and optionally reverts all settings
#   to stock macOS defaults. Provides interactive confirmation for safety.
#
# USAGE:
#   ./uninstall.sh                    # Interactive uninstallation
#   ./uninstall.sh --full             # Remove everything + revert settings
#   ./uninstall.sh --keep-settings    # Remove files only, keep settings
#   ./uninstall.sh --force            # No confirmation prompts
#
# WHAT IT REMOVES:
#   - Application data directory (~/.mactweaks/)
#   - LaunchAgent (post-reboot automation)
#   - Command symlinks (/usr/local/bin/mactweaks, ~/.local/bin/mactweaks)
#   - Optionally: All applied settings (revert to stock macOS)
#
# WHAT IT KEEPS:
#   - Repository files (this script and source code)
#   - System modifications (unless --full is used)
###############################################################################

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Paths
APP_DIR="$HOME/Library/Application Support/MacTweaks"
LA_PLIST="$HOME/Library/LaunchAgents/com.mactweaks.postreboot.plist"
SYSTEM_BIN="/usr/local/bin/mactweaks"
USER_BIN="$HOME/.local/bin/mactweaks"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_SCRIPT="$SCRIPT_DIR/bin/mac-tweaks.sh"

# Print colored messages
info() { echo -e "${BLUE}ℹ️  $*${NC}"; }
ok() { echo -e "${GREEN}✅ $*${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $*${NC}"; }
err() { echo -e "${RED}❌ $*${NC}"; }
die() { err "$*"; exit 1; }

# Confirmation prompt
confirm() {
  local prompt="$1"
  read -r -p "$prompt [y/N]: " response
  [[ "$response" =~ ^[Yy]$ ]]
}

# Remove application data directory
remove_app_data() {
  if [[ -d "$APP_DIR" ]]; then
    info "Removing application data..."
    rm -rf "$APP_DIR"
    ok "Removed: $APP_DIR"
  else
    info "No application data found (already clean)"
  fi
}

# Remove LaunchAgent
remove_launch_agent() {
  if [[ -f "$LA_PLIST" ]]; then
    info "Removing LaunchAgent..."
    launchctl unload "$LA_PLIST" 2>/dev/null || true
    rm -f "$LA_PLIST"
    ok "Removed: $LA_PLIST"
  else
    info "No LaunchAgent found (already clean)"
  fi
}

# Remove command symlinks
remove_symlinks() {
  local removed=false

  # Remove system-wide installation
  if [[ -L "$SYSTEM_BIN" ]]; then
    info "Removing system-wide command..."
    if sudo rm -f "$SYSTEM_BIN" 2>/dev/null; then
      ok "Removed: $SYSTEM_BIN"
      removed=true
    else
      warn "Could not remove $SYSTEM_BIN (may need manual removal)"
    fi
  fi

  # Remove user installation
  if [[ -L "$USER_BIN" ]]; then
    info "Removing user command..."
    rm -f "$USER_BIN"
    ok "Removed: $USER_BIN"
    removed=true
  fi

  if ! $removed; then
    info "No command symlinks found (already clean)"
  fi
}

# Revert all settings to stock macOS
revert_all_settings() {
  if [[ ! -x "$MAIN_SCRIPT" ]]; then
    warn "Main script not found or not executable"
    warn "Cannot revert settings automatically"
    info "Manual reversion: Open System Settings and restore preferences"
    return
  fi

  info "Reverting all MacTweaks modifications to stock macOS..."
  echo

  # Run the toolkit's revert-all function
  if "$MAIN_SCRIPT" --revert-profile all; then
    ok "All settings reverted to stock macOS defaults"
  else
    warn "Some settings may not have been reverted"
    warn "Check System Settings manually if needed"
  fi
}

# Display what will be removed
show_removal_plan() {
  local revert_settings="$1"

  echo "╔════════════════════════════════════════════════════════════╗"
  echo "║                                                            ║"
  echo "║              MacTweaks Uninstallation Plan                ║"
  echo "║                                                            ║"
  echo "╚════════════════════════════════════════════════════════════╝"
  echo

  echo "The following will be REMOVED:"
  echo

  [[ -d "$APP_DIR" ]] && echo "  📁 Application data: $APP_DIR"
  [[ -f "$LA_PLIST" ]] && echo "  🔧 LaunchAgent: $LA_PLIST"
  [[ -L "$SYSTEM_BIN" ]] && echo "  🔗 System command: $SYSTEM_BIN"
  [[ -L "$USER_BIN" ]] && echo "  🔗 User command: $USER_BIN"

  if $revert_settings; then
    echo "  ⚙️  All system modifications (reverted to stock macOS)"
  fi

  echo
  echo "The following will be KEPT:"
  echo "  📂 Repository files: $SCRIPT_DIR"

  if ! $revert_settings; then
    echo "  ⚙️  System modifications (settings remain as-is)"
  fi

  echo
}

# Interactive uninstallation
interactive_uninstall() {
  echo "╔════════════════════════════════════════════════════════════╗"
  echo "║                                                            ║"
  echo "║           MacTweaks Uninstallation Wizard                 ║"
  echo "║                                                            ║"
  echo "╚════════════════════════════════════════════════════════════╝"
  echo

  info "This will remove MacTweaks from your system"
  echo
  echo "Uninstallation options:"
  echo "  1) Full uninstall    - Remove files + revert all settings to stock"
  echo "  2) Files only        - Remove MacTweaks files, keep current settings"
  echo "  3) Cancel"
  echo

  read -r -p "Select option [1-3]: " choice

  case "$choice" in
    1)
      show_removal_plan true
      if confirm "Proceed with FULL uninstallation?"; then
        revert_all_settings
        remove_launch_agent
        remove_app_data
        remove_symlinks
        ok "Full uninstallation complete"
      else
        info "Uninstallation canceled"
        exit 0
      fi
      ;;
    2)
      show_removal_plan false
      if confirm "Proceed with file removal only?"; then
        remove_launch_agent
        remove_app_data
        remove_symlinks
        ok "Files removed, settings preserved"
      else
        info "Uninstallation canceled"
        exit 0
      fi
      ;;
    3)
      info "Uninstallation canceled"
      exit 0
      ;;
    *)
      err "Invalid choice"
      exit 1
      ;;
  esac
}

# Main uninstallation logic
main() {
  local revert_settings=false
  local force=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --full)
        revert_settings=true
        shift
        ;;
      --keep-settings)
        revert_settings=false
        shift
        ;;
      --force)
        force=true
        shift
        ;;
      --help|-h)
        cat <<EOF
MacTweaks Uninstallation Script

USAGE:
  ./uninstall.sh [option]

OPTIONS:
  --full            Remove everything + revert all settings to stock
  --keep-settings   Remove files only, keep current settings
  --force           Skip confirmation prompts
  --help            Show this help

INTERACTIVE (default):
  Run without arguments for interactive wizard

EXAMPLES:
  ./uninstall.sh                  # Interactive wizard
  ./uninstall.sh --full           # Complete removal + revert
  ./uninstall.sh --keep-settings  # Remove files, keep settings
  ./uninstall.sh --full --force   # No prompts, full removal

WHAT GETS REMOVED:
  - Application data (~/.mactweaks/)
  - LaunchAgent (post-reboot automation)
  - Command symlinks (mactweaks command)
  - Optionally: All applied settings

WHAT STAYS:
  - Repository files (you can delete manually)
  - System modifications (unless --full is used)

EOF
        exit 0
        ;;
      *)
        die "Unknown option: $1 (use --help)"
        ;;
    esac
  done

  # Interactive mode if no arguments
  if [[ "${revert_settings}" == "false" ]] && [[ "${force}" == "false" ]] && [[ $# -eq 0 ]]; then
    interactive_uninstall
  else
    # Non-interactive mode
    if ! $force; then
      show_removal_plan "$revert_settings"
      confirm "Proceed with uninstallation?" || { info "Canceled"; exit 0; }
    fi

    if $revert_settings; then
      revert_all_settings
    fi

    remove_launch_agent
    remove_app_data
    remove_symlinks
    ok "Uninstallation complete"
  fi

  echo
  info "Repository files remain at: $SCRIPT_DIR"
  info "You can safely delete this directory if desired"
  echo
  ok "Thank you for using MacTweaks!"
}

# Run uninstaller
main "$@"
