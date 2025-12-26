###############################################################################
# MacTweaks/lib/utils.sh
# General utility functions used throughout the toolkit.
#
# DESCRIPTION:
#   Provides common helper functions for command execution, user interaction,
#   system operations, and module management.
#
# FUNCTIONS:
#   run_cmd_limited   - Execute command with output line limit
#   confirm           - Prompt user for yes/no confirmation
#   restart_ui        - Restart Finder and Dock to apply UI changes
#   pmset_set         - Safely set power management values
#   defaults_del      - Safely delete a defaults key
#   launchctl_disable_safe - Safely disable a launchd service
#   launchctl_enable_safe  - Safely enable a launchd service
#   NOW_STAMP         - Generate timestamp string for filenames
#   run_module_script - Execute a module's installer/uninstaller script
#   list_modules      - Display all available modules
#   apply_module      - Execute a module's apply function
#   revert_module     - Execute a module's revert function
###############################################################################

###############################################################################
# run_cmd_limited() - Execute command with limited output
# Runs a command and captures only the first N lines of output.
# Useful for preventing overly verbose output in snapshots.
#
# Arguments:
#   $1 - Maximum number of lines to capture
#   $@ - Command and arguments to execute
#
# Returns:
#   First N lines of command output
###############################################################################
run_cmd_limited() {
  local max_lines="$1"
  shift
  "$@" | head -n "$max_lines"
}

###############################################################################
# confirm() - Prompt user for confirmation
# Displays a yes/no prompt and returns based on user input.
# Default is "No" if user just presses Enter.
#
# Arguments:
#   $1 - Prompt message to display
#
# Returns:
#   0 (true) if user enters y/Y
#   1 (false) otherwise
###############################################################################
confirm() {
  local prompt="$1"
  read -r -p "$prompt [y/N]: " ans
  [[ "${ans:-}" =~ ^[Yy]$ ]]
}

###############################################################################
# restart_ui() - Restart Finder and Dock
# Kills and automatically restarts Finder and Dock processes.
# Required for many UI-related settings to take effect.
# Note: Both processes auto-restart after being killed.
###############################################################################
restart_ui() {
  info "Restarting Finder & Dock…"
  killall Finder 2>/dev/null || true
  killall Dock 2>/dev/null || true
}

###############################################################################
# pmset_set() - Safely set power management value
# Attempts to set a pmset value, trying -a (all) first, then specific scope.
# Silently ignores errors for compatibility across macOS versions.
#
# Arguments:
#   $1 - Scope (-a for all, -b for battery, -c for charger)
#   $2 - Key name (e.g., powernap, tcpkeepalive)
#   $3 - Value to set
###############################################################################
pmset_set() {
  local scope="$1"; local key="$2"; local value="$3"
  # Try -a (all power sources) first, fall back to specific scope
  sudo pmset -a "$key" "$value" 2>/dev/null || sudo pmset "$scope" "$key" "$value" 2>/dev/null || true
}

###############################################################################
# defaults_del() - Safely delete a defaults key
# Removes a preference key from the specified domain.
# Silently ignores if key doesn't exist.
#
# Arguments:
#   $1 - Preference domain (e.g., com.apple.finder)
#   $2 - Key name to delete
###############################################################################
defaults_del() {
  local domain="$1"; local key="$2"
  defaults delete "$domain" "$key" 2>/dev/null || true
}

###############################################################################
# launchctl_disable_safe() - Safely disable a launchd service
# Disables a system or user service via launchctl.
# Silently ignores errors (service may not exist on all systems).
#
# Arguments:
#   $1 - Service target (e.g., system/com.apple.analyticsd)
###############################################################################
launchctl_disable_safe() {
  local target="$1"
  sudo launchctl disable "$target" 2>/dev/null || true
}

###############################################################################
# launchctl_enable_safe() - Safely enable a launchd service
# Enables a previously disabled system or user service.
# Silently ignores errors.
#
# Arguments:
#   $1 - Service target (e.g., system/com.apple.analyticsd)
###############################################################################
launchctl_enable_safe() {
  local target="$1"
  sudo launchctl enable "$target" 2>/dev/null || true
}

###############################################################################
# NOW_STAMP() - Generate timestamp for filenames
# Creates a timestamp string safe for use in filenames.
#
# Returns:
#   Timestamp in format: YYYY-MM-DD_HH-MM-SS
###############################################################################
NOW_STAMP() { date '+%Y-%m-%d_%H-%M-%S'; }

###############################################################################
# run_module_script() - Execute a module's helper script
# Safely runs a module's install/uninstall script located under modules/<name>/.
# Uses zsh explicitly so scripts do not need the executable bit set.
#
# Arguments:
#   $1 - Module directory name (e.g., lowpower_on_charge)
#   $2 - Script base name without extension (install or uninstall)
###############################################################################
run_module_script() {
  local module="$1"; local action="$2"
  local script="$ROOT_DIR/modules/$module/$action.sh"

  [[ -f "$script" ]] || die "Missing $action script for module '$module': $script"

  zsh "$script"
}

###############################################################################
# list_modules() - Display available modules
# Prints a formatted list of all loaded modules.
# The MODULES array is populated by mac-tweaks.sh during startup.
###############################################################################
list_modules() {
  echo "Available modules:"
  for m in "${MODULES[@]}"; do echo "  - $m"; done
}

###############################################################################
# apply_module() - Execute a module's apply function
# Calls the m_<modulename>_apply function for the specified module.
# Each module defines its own apply function following this naming convention.
#
# Arguments:
#   $1 - Module name (e.g., spotlight, siri)
###############################################################################
apply_module() {
  local m="$1"
  "m_${m}_apply"
}

###############################################################################
# revert_module() - Execute a module's revert function
# Calls the m_<modulename>_revert function for the specified module.
# Restores settings to their default state.
#
# Arguments:
#   $1 - Module name (e.g., spotlight, siri)
###############################################################################
revert_module() {
  local m="$1"
  "m_${m}_revert"
}

###############################################################################
# progress_bar() - Display a simple terminal progress bar
# Shows progress for long-running operations like applying/reverting modules.
#
# Arguments:
#   $1 - Current step (1-based)
#   $2 - Total steps
#   $3 - Label (module name or action)
###############################################################################
progress_bar() {
  local current="$1"
  local total="$2"
  local label="${3:-}"

  [[ "$total" -gt 0 ]] || return 0

  local width=28
  local percent=$((current * 100 / total))
  local filled=$((percent * width / 100))
  local empty=$((width - filled))
  local bar
  bar="$(printf "%${filled}s" "" | tr ' ' '#')"
  bar="$bar$(printf "%${empty}s" "" | tr ' ' '-')"

  printf "\r[%s] %3d%% (%d/%d) %s" "$bar" "$percent" "$current" "$total" "$label"
}

###############################################################################
# progress_done() - Finish a progress bar line
###############################################################################
progress_done() {
  echo
}
