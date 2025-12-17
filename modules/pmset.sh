###############################################################################
# MacTweaks/modules/pmset.sh
# Module: Power management background wakeup control
#
# DESCRIPTION:
#   Controls power management settings that cause the Mac to wake from sleep
#   for background tasks. Disabling these reduces phantom battery drain and
#   heat generation during sleep.
#
# SETTINGS CHANGED:
#   - powernap: Power Nap feature (wake for iCloud sync, Time Machine, etc.)
#   - tcpkeepalive: Maintain network connections during sleep
#
# WHAT IS POWER NAP:
#   When enabled, Mac wakes periodically during sleep to:
#   - Check for email
#   - Sync iCloud data
#   - Perform Time Machine backups
#   - Download software updates
#
# WHAT IS TCP KEEPALIVE:
#   Maintains network connections during sleep so the Mac responds to
#   network requests (Find My Mac, remote access, push notifications).
#
# IMPACT:
#   - Significantly reduces sleep battery drain (especially on Intel Macs)
#   - Mac won't sync or backup during sleep
#   - Network connections drop during sleep
#   - Find My Mac may be less responsive
#
# PROFILES: max, balanced, battery
#
# NOTE: This has the biggest impact on Intel Macs. Apple Silicon Macs
#       handle sleep more efficiently, so the benefit is smaller.
###############################################################################

# Apply: Disable background wake features
m_pmset_apply() {
  info "[pmset] Reduce background wakeups (powernap/tcpkeepalive)"

  # Disable Power Nap on all power sources (-a = all)
  # Value 0 = disabled, 1 = enabled
  pmset_set -a powernap 0

  # Disable TCP keepalive during sleep
  pmset_set -a tcpkeepalive 0
}

# Revert: Re-enable background wake features
m_pmset_revert() {
  info "[pmset] Restore background wakeups defaults (powernap/tcpkeepalive)"

  # Re-enable Power Nap
  pmset_set -a powernap 1

  # Re-enable TCP keepalive
  pmset_set -a tcpkeepalive 1
}
