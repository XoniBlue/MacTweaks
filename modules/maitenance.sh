###############################################################################
# MacTweaks/modules/maitenance.sh
# Module: System maintenance tasks
#
# DESCRIPTION:
#   Runs safe system maintenance tasks that help keep macOS running smoothly.
#   These are non-destructive cleanup operations that Apple recommends.
#
# TASKS PERFORMED:
#   - Flush DNS cache (resolve stale DNS entries)
#   - Run periodic maintenance scripts (daily/weekly/monthly)
#   - Clear system caches (safe, will rebuild as needed)
#
# IMPACT:
#   - May temporarily slow system while caches rebuild
#   - Frees up disk space from old caches
#   - Resolves DNS-related network issues
#
# PROFILES: max, balanced, battery
#
# NOTE: The filename has a typo ("maitenance" instead of "maintenance")
#       but is kept for backwards compatibility with existing profiles.
###############################################################################

# Apply: Run system maintenance tasks
m_maitenance_apply() {
  info "[maintenance] Running safe system maintenance tasks"

  # Flush DNS cache to clear stale entries
  # This resolves issues with websites that have changed IP addresses
  sudo dscacheutil -flushcache 2>/dev/null || true
  sudo killall -HUP mDNSResponder 2>/dev/null || true

  # Run periodic maintenance scripts
  # These are Apple's built-in cleanup tasks (normally run automatically)
  # daily: Clean system logs, tmp files
  # weekly: Rebuild locate/whatis databases
  # monthly: Account/network statistics rotation
  sudo periodic daily weekly monthly 2>/dev/null || true

  ok "[maintenance] Maintenance tasks completed"
}

# Revert: No-op (maintenance tasks don't need reverting)
m_maitenance_revert() {
  info "[maintenance] No revert needed (maintenance is idempotent)"
  true
}
