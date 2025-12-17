###############################################################################
# MacTweaks/modules/updates.sh
# Module: Automatic software update checks control
#
# DESCRIPTION:
#   Disables automatic checking for macOS and app updates. Manual checking
#   through System Settings still works. This reduces background network
#   activity and prevents unwanted notification interruptions.
#
# SETTINGS CHANGED:
#   - AutomaticCheckEnabled: Disables automatic update checks
#
# WHAT THIS AFFECTS:
#   - Background checks for macOS updates
#   - Automatic App Store update notifications
#   - System-initiated update downloads
#
# IMPACT:
#   - Reduces background network activity
#   - Prevents surprise update notifications
#   - User retains full control over update timing
#   - Manual checks still work via System Settings
#
# PROFILES: max
#
# WARNING: Security updates are important. If you disable automatic checks,
#          make sure to manually check for updates regularly:
#          System Settings → General → Software Update
#
# NOTE: This setting is stored in /Library/Preferences (system-wide)
#       and requires sudo to modify.
###############################################################################

# Apply: Disable automatic update checks
m_updates_apply() {
  info "[updates] Disable automatic update checks (manual still works)"

  # Disable automatic update checking system-wide
  # Manual checks via System Settings → Software Update still function
  sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false 2>/dev/null || true

  warn "Remember to check for updates manually at least weekly"
}

# Revert: Re-enable automatic update checks
m_updates_revert() {
  info "[updates] Re-enable automatic update checks"

  # Remove override to restore automatic update checks
  sudo defaults delete /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled 2>/dev/null || true
}
