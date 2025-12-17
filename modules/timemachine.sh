###############################################################################
# MacTweaks/modules/timemachine.sh
# Module: Time Machine local snapshots control
#
# DESCRIPTION:
#   Disables Time Machine local snapshots, which are APFS snapshots stored
#   on the system drive for quick recovery. These snapshots can consume
#   significant disk space and cause background I/O activity.
#
# WHAT ARE LOCAL SNAPSHOTS:
#   - APFS snapshots stored on the system drive
#   - Created hourly when Time Machine backup drive is not connected
#   - Allow quick recovery of recently deleted files
#   - Automatically deleted when disk space is needed
#   - Can accumulate to several GB on laptops
#
# COMMANDS USED:
#   - tmutil disablelocal: Disable local snapshot creation
#   - tmutil enablelocal: Re-enable local snapshot creation
#
# IMPACT:
#   - Frees disk space from accumulated snapshots
#   - Reduces background disk I/O
#   - Eliminates periodic snapshot creation overhead
#   - No quick recovery between Time Machine backups
#
# PROFILES: max, balanced
#
# WARNING: On newer macOS versions with APFS snapshots, this command may
#          have reduced or no effect. APFS manages snapshots differently
#          than older HFS+ Time Machine local snapshots.
#
# NOTE: This does NOT affect regular Time Machine backups to external drives.
#       Only local snapshots stored on the system drive are affected.
###############################################################################

# Apply: Disable Time Machine local snapshots
m_timemachine_apply() {
  info "[timemachine] Disable local snapshots"

  # Disable local snapshot creation
  # This prevents Time Machine from creating hourly APFS snapshots
  sudo tmutil disablelocal 2>/dev/null || true

  # Note: On some macOS versions this may silently fail or have no effect
  warn "Note: Effect may be limited on newer APFS-based macOS versions"
}

# Revert: Re-enable Time Machine local snapshots
m_timemachine_revert() {
  info "[timemachine] Enable local snapshots"

  # Re-enable local snapshot creation
  # Time Machine will resume creating hourly snapshots
  sudo tmutil enablelocal 2>/dev/null || true
}
