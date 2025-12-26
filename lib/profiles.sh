###############################################################################
# MacTweaks/lib/profiles.sh
# Profile definitions and application/reversion logic.
#
# DESCRIPTION:
#   Defines optimization profiles and provides functions to apply or revert
#   them. Each profile is a curated collection of modules for specific use cases.
#
# PROFILES:
#   max      - Most aggressive optimizations for maximum performance
#   balanced - Recommended daily driver with core optimizations
#   battery  - Focus on power savings while preserving features
#   dryrun   - Simulation mode (no actual changes)
#   stock    - No modules (empty, used for baseline)
#
# FUNCTIONS:
#   profile_modules - Get list of modules for a profile
#   apply_profile   - Apply all modules in a profile
#   revert_profile  - Revert all modules in a profile
###############################################################################

###############################################################################
# profile_modules() - Get the list of modules for a given profile
# Returns a space-separated list of module names for the specified profile.
#
# Arguments:
#   $1 (profile) - Profile name: max, balanced, battery, dryrun, or stock
#
# Returns:
#   Space-separated list of module names
#
# Profile Module Lists:
#   max      - All optimizations including disabling Siri, iCloud, AirDrop, etc.
#   balanced - Core optimizations without breaking Continuity features
#   battery  - Minimal changes focused on power savings
#   dryrun   - Only the dryrun module (simulation)
#   stock    - Empty (no modules)
###############################################################################
profile_modules() {
  local profile="$1"
  case "$profile" in
    # MAX PROFILE: Most aggressive optimizations
    # Disables: Spotlight, Siri, analytics, iCloud Desktop/Documents,
    #           AirDrop, Handoff, Apple Intelligence, and more
    # Best for: Maximum performance, lowest thermals, reduced background activity
    max)
      echo "spotlight siri analytics ui live text timemachine photos finder icloud visual appnap quicklook pmset airdrop handoff updates shadows appleintelligence maintenance loginitems powermode backup updatecheck exportreport"
      ;;

    # BALANCED PROFILE: Recommended daily driver
    # Applies core optimizations without breaking Continuity features
    # Preserves: AirDrop, Handoff, Siri, iCloud Documents
    # Best for: Most users who want better performance without sacrificing features
    balanced)
      echo "spotlight analytics ui text timemachine photos finder visual appnap quicklook pmset shadows appleintelligence maintenance backup updatecheck"
      ;;

    # BATTERY PROFILE: Power-focused optimizations
    # Minimal changes, focuses on UI smoothness and low power mode
    # Best for: Laptop users prioritizing battery life
    battery)
      echo "ui visual pmset finder quicklook shadows powermode maintenance backup updatecheck"
      ;;

    # DRYRUN PROFILE: Simulation mode
    # Only runs the dryrun module which lists what would be changed
    dryrun)
      echo "dryrun"
      ;;

    # STOCK PROFILE: No changes
    # Empty module list for baseline comparisons
    stock)
      echo ""
      ;;

    *)
      die "Unknown profile: $profile"
      ;;
  esac
}

###############################################################################
# apply_profile() - Apply all modules in a profile
# Iterates through the profile's modules and applies each one.
# Shows compatibility warnings for Apple Silicon.
#
# Arguments:
#   $1 (profile) - Profile name to apply
#   $2 (optional) - For dryrun profile, the real profile name to simulate
#
# Side Effects:
#   - Applies all modules in the profile
#   - Restarts Finder and Dock
#   - Logs applied modules
###############################################################################
apply_profile() {
  local profile="$1"
  info "Applying profile: $profile"
  info "Detected: OS $OS_VERSION ($OS_BUILD) • Arch $ARCH • CPU: $CPU_BRAND"

  # Get list of modules for this profile
  local mods
  mods="$(profile_modules "$profile")"

  # For dryrun mode, pass the real profile name to the dryrun module
  if [[ "$profile" == "dryrun" ]]; then
    export DRYRUN_PROFILE="$2"
  fi

  # Show architecture-specific warning
  # Intel Macs benefit more from these optimizations
  if is_apple_silicon; then
    warn "Apple Silicon detected: some changes may have smaller impact."
  else
    info "Intel detected: maximum impact expected."
  fi

  # Apply each module in sequence
  local arr=($mods)
  local total="${#arr[@]}"
  for (( i=0; i<total; i++ )); do
    local m="${arr[$i]}"
    progress_bar "$((i + 1))" "$total" "apply: $m"
    apply_module "$m"
  done
  progress_done

  # Restart UI elements to apply visual changes
  restart_ui

  info "Modules applied: $mods"
  ok "Profile '$profile' applied."
}

###############################################################################
# revert_profile() - Revert all modules in a profile
# Iterates through the profile's modules in reverse order and reverts each.
# The "all" profile reverts every available module.
#
# Arguments:
#   $1 (profile) - Profile name to revert, or "all" for everything
#
# Side Effects:
#   - Reverts all modules in the profile (in reverse order)
#   - Restarts Finder and Dock
#
# Note: Modules are reverted in reverse order to handle any dependencies
###############################################################################
revert_profile() {
  local profile="$1"
  info "Reverting profile: $profile"

  local mods
  # "all" is a special case that reverts every loaded module
  if [[ "$profile" == "all" ]]; then
    mods="${MODULES[*]}"
  else
    mods="$(profile_modules "$profile")"
  fi

  # Convert to array and iterate in reverse order
  # Reverse order ensures proper cleanup of dependent settings
  local arr=($mods)
  local total="${#arr[@]}"
  local step=1
  for (( i=total-1; i>=0; i-- )); do
    local m="${arr[$i]}"
    progress_bar "$step" "$total" "revert: $m"
    revert_module "$m"
    step=$((step + 1))
  done
  progress_done

  # Restart UI elements to apply visual changes
  restart_ui

  ok "Profile '$profile' reverted."
}
