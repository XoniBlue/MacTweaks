#!/bin/bash
# MacTweaks/bin/MacTweaks.sh
# Main entry point for the Sequoia Performance Toolkit.
# This script sets up the environment, sources all necessary libraries and modules,
# and handles command-line arguments or interactive mode.

set -euo pipefail

# Resolve the script's directory (handles symlinks)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"  # Parent of bin/

# Source core libraries
source "$ROOT_DIR/lib/config.sh"
source "$ROOT_DIR/lib/logging.sh"
source "$ROOT_DIR/lib/utils.sh"
source "$ROOT_DIR/lib/detect.sh"
source "$ROOT_DIR/lib/sudo_keepalive.sh"
source "$ROOT_DIR/lib/snapshots.sh"
source "$ROOT_DIR/lib/reports.sh"
source "$ROOT_DIR/lib/postreboot.sh"
source "$ROOT_DIR/lib/help.sh"
source "$ROOT_DIR/lib/profiles.sh"
source "$ROOT_DIR/lib/menus.sh"

# Source all modules dynamically
for module_file in "$ROOT_DIR/modules/"*.sh; do
  source "$module_file"
done

# Build MODULES array from sourced module files (each defines its own name)
MODULES=()  # Reset if needed
for module_file in "$ROOT_DIR/modules/"*.sh; do
  module_name="$(basename "$module_file" .sh)"
  MODULES+=("$module_name")
done

# --------------------- Debug + argument normalization ---------------------

DEBUG=false
NEW_ARGS=()  # Explicitly initialize as array

for arg in "$@"; do
  if [[ "$arg" == "--debug" ]]; then
    DEBUG=true
  else
    NEW_ARGS+=("$arg")  # Append to array safely
  fi
done

# Re-set positional parameters from the filtered args
if [[ ${#NEW_ARGS[@]} -eq 0 ]]; then
  set --  # Reset to no arguments
else
  set -- "${NEW_ARGS[@]}"
fi

if $DEBUG; then
  set -x
  log "Debug mode enabled."
fi

# Main execution
main() {
  need_macos
  need_sudo_keepalive

  case "${1:---interactive}" in
    --help|-h) help_screen ;;
    --interactive) while true; do menu_main; done ;;
    --list-modules) list_modules ;;
    --uninstall) uninstall_toolkit ;;
    --report)
      menu_report_now
      ;;
    --apply-profile)
      [[ -n "${2:-}" ]] || die "Missing profile name."
      local profile="$2"
      local stamp="$(NOW_STAMP)"
      local before_path
      before_path="$(snapshot_collect before "$stamp")"
      postreboot_install_once "$stamp" "$before_path"
      apply_profile "$profile"
      reboot_countdown 20
      ;;
    --revert-profile)
      [[ -n "${2:-}" ]] || die "Missing profile name."
      local profile="$2"
      local stamp="$(NOW_STAMP)"
      local before_path
      before_path="$(snapshot_collect before "$stamp")"
      postreboot_install_once "$stamp" "$before_path"
      revert_profile "$profile"
      reboot_countdown 20
      ;;
    --module)
      [[ -n "${2:-}" ]] || die "Missing module name."
      local mod="$2"
      local action="${3:-}"
      [[ "$action" == "--apply" || "$action" == "--revert" ]] || die "Use: --module <name> --apply|--revert"
      local stamp="$(NOW_STAMP)"
      local before_path
      before_path="$(snapshot_collect before "$stamp")"
      postreboot_install_once "$stamp" "$before_path"
      if [[ "$action" == "--apply" ]]; then apply_module "$mod"; else revert_module "$mod"; fi
      restart_ui
      reboot_countdown 20
      ;;
    *)
      die "Unknown option: $1 (use --help)"
      ;;
  esac
}

main "$@"
