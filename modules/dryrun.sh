###############################################################################
# MacTweaks/modules/dryrun.sh
# Module: Dry-run simulation mode
#
# DESCRIPTION:
#   Simulates profile application without making any actual changes.
#   Shows which modules would be applied for a given profile.
#   Useful for previewing the impact before committing to changes.
#
# USAGE:
#   Called via the "dryrun" profile with DRYRUN_PROFILE environment variable
#   set to the actual profile name to simulate (max, balanced, or battery).
#
# PROFILES: dryrun (special profile)
#
# NOTE: This module reads DRYRUN_PROFILE from the environment, which is
#       set by apply_profile() when profile="dryrun".
###############################################################################

# Apply: Display which modules would be applied (no actual changes)
m_dryrun_apply() {
  info "[dryrun] Simulating profile application (no changes made)"

  # Get the module list for the profile being simulated
  local mods="$(profile_modules "$DRYRUN_PROFILE")"

  # Display what would happen
  echo "Would apply modules: $mods"
  echo "Use a real profile to apply changes."
}

# Revert: No-op (nothing was changed, so nothing to revert)
m_dryrun_revert() {
  true
}
