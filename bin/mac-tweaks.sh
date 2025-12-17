#!/bin/bash
###############################################################################
# MacTweaks/bin/mac-tweaks.sh
# Main entry point for the Sequoia Performance Toolkit.
#
# DESCRIPTION:
#   This script sets up the environment, sources all necessary libraries and
#   modules, and handles command-line arguments or interactive mode.
#   It provides a comprehensive macOS optimization toolkit for Sequoia (15.x).
#
# USAGE:
#   ./mac-tweaks.sh [command] [options]
#   ./mac-tweaks.sh --help              Show help
#   ./mac-tweaks.sh --interactive       Launch interactive menu (default)
#   ./mac-tweaks.sh --apply-profile <name>   Apply optimization profile
#   ./mac-tweaks.sh --revert-profile <name>  Revert optimization profile
#   ./mac-tweaks.sh --module <name> --apply|--revert  Apply/revert single module
#   ./mac-tweaks.sh --debug             Enable debug mode (set -x)
#
# REQUIREMENTS:
#   - macOS (Darwin)
#   - Administrator privileges (sudo)
#
# EXIT CODES:
#   0 - Success
#   1 - Error (missing requirements, invalid arguments, etc.)
###############################################################################

# Enable strict error handling:
#   -e: Exit immediately if a command exits with non-zero status
#   -u: Treat unset variables as an error
#   -o pipefail: Return value of a pipeline is the status of the last command
#                to exit with a non-zero status
set -euo pipefail

###############################################################################
# PATH RESOLUTION
# Determine the script's actual location, handling symlinks correctly.
# This allows the script to be run from any location or via symlink.
###############################################################################
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"  # Parent of bin/ - the project root

###############################################################################
# LIBRARY SOURCING
# Load all core library files that provide shared functionality.
# Order matters: config.sh and logging.sh must be loaded first as other
# libraries depend on their variables and functions.
###############################################################################
source "$ROOT_DIR/lib/config.sh"        # Global constants and directory setup
source "$ROOT_DIR/lib/logging.sh"       # Logging functions (log, info, warn, ok, err, die)
source "$ROOT_DIR/lib/utils.sh"         # General utility functions
source "$ROOT_DIR/lib/detect.sh"        # System detection (macOS version, architecture)
source "$ROOT_DIR/lib/sudo_keepalive.sh" # Keep sudo session alive during execution
source "$ROOT_DIR/lib/snapshots.sh"     # System state snapshot collection
source "$ROOT_DIR/lib/reports.sh"       # Before/after report generation
source "$ROOT_DIR/lib/postreboot.sh"    # Post-reboot automation setup
source "$ROOT_DIR/lib/help.sh"          # Help screen display
source "$ROOT_DIR/lib/profiles.sh"      # Profile definitions and application logic
source "$ROOT_DIR/lib/menus.sh"         # Interactive menu system

###############################################################################
# MODULE LOADING
# Dynamically source all modules from the modules/ directory.
# Each module provides apply/revert functions for specific optimizations.
###############################################################################
for module_file in "$ROOT_DIR/modules/"*.sh; do
  source "$module_file"
done

# Build the MODULES array containing all available module names.
# This is used for listing modules and for the "revert all" feature.
MODULES=()
for module_file in "$ROOT_DIR/modules/"*.sh; do
  module_name="$(basename "$module_file" .sh)"
  MODULES+=("$module_name")
done

###############################################################################
# ARGUMENT PREPROCESSING
# Handle the --debug flag separately before processing other arguments.
# This allows debug mode to be combined with any other command.
###############################################################################
DEBUG=false
NEW_ARGS=()

# Filter out --debug flag and collect remaining arguments
for arg in "$@"; do
  if [[ "$arg" == "--debug" ]]; then
    DEBUG=true
  else
    NEW_ARGS+=("$arg")
  fi
done

# Reset positional parameters to the filtered argument list
if [[ ${#NEW_ARGS[@]} -eq 0 ]]; then
  set --  # No arguments remaining
else
  set -- "${NEW_ARGS[@]}"
fi

# Enable shell tracing if debug mode is active
if $DEBUG; then
  set -x
  log "Debug mode enabled."
fi

###############################################################################
# MAIN FUNCTION
# Entry point for the toolkit. Validates environment and routes to the
# appropriate handler based on command-line arguments.
###############################################################################
main() {
  # Ensure we're running on macOS
  need_macos

  # Start sudo keepalive to prevent password prompts during execution
  need_sudo_keepalive

  # Route based on the first argument (default to interactive mode)
  case "${1:---interactive}" in

    # Display help information
    --help|-h)
      help_screen
      ;;

    # Launch interactive text-based menu (default behavior)
    --interactive)
      while true; do menu_main; done
      ;;

    # List all available modules
    --list-modules)
      list_modules
      ;;

    # Remove toolkit state, logs, and post-reboot agent
    --uninstall)
      uninstall_toolkit
      ;;

    # Generate a before/after report without making changes
    --report)
      menu_report_now
      ;;

    # Apply an optimization profile (max, balanced, or battery)
    --apply-profile)
      [[ -n "${2:-}" ]] || die "Missing profile name."
      local profile="$2"
      local stamp="$(NOW_STAMP)"

      # Capture system state before changes
      local before_path
      before_path="$(snapshot_collect before "$stamp")"

      # Set up post-reboot report generation
      postreboot_install_once "$stamp" "$before_path"

      # Apply the profile
      apply_profile "$profile"

      # Prompt for reboot (required for full effect)
      reboot_countdown 20
      ;;

    # Revert an optimization profile to defaults
    --revert-profile)
      [[ -n "${2:-}" ]] || die "Missing profile name."
      local profile="$2"
      local stamp="$(NOW_STAMP)"

      # Capture system state before changes
      local before_path
      before_path="$(snapshot_collect before "$stamp")"

      # Set up post-reboot report generation
      postreboot_install_once "$stamp" "$before_path"

      # Revert the profile
      revert_profile "$profile"

      # Prompt for reboot (required for full effect)
      reboot_countdown 20
      ;;

    # Apply or revert a single module
    --module)
      [[ -n "${2:-}" ]] || die "Missing module name."
      local mod="$2"
      local action="${3:-}"
      [[ "$action" == "--apply" || "$action" == "--revert" ]] || die "Use: --module <name> --apply|--revert"

      local stamp="$(NOW_STAMP)"

      # Capture system state before changes
      local before_path
      before_path="$(snapshot_collect before "$stamp")"

      # Set up post-reboot report generation
      postreboot_install_once "$stamp" "$before_path"

      # Apply or revert the module
      if [[ "$action" == "--apply" ]]; then
        apply_module "$mod"
      else
        revert_module "$mod"
      fi

      # Restart Finder and Dock to apply UI changes
      restart_ui

      # Prompt for reboot (required for full effect)
      reboot_countdown 20
      ;;

    # Unknown option - show error
    *)
      die "Unknown option: $1 (use --help)"
      ;;
  esac
}

# Execute main function with all arguments
main "$@"
