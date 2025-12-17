###############################################################################
# MacTweaks/modules/live.sh
# Module: Live Activities control
#
# DESCRIPTION:
#   Disables Live Activities tracking on macOS. Live Activities are real-time
#   widgets that show ongoing activities (timers, sports scores, deliveries).
#
# WHAT ARE LIVE ACTIVITIES:
#   - Real-time updates on Lock Screen and Dynamic Island (iOS)
#   - Ported to macOS Sequoia for compatible apps
#   - Requires background processing to stay updated
#
# SETTINGS CHANGED:
#   - ActivityTrackingEnabled: Disables activity tracking daemon
#
# IMPACT:
#   - Reduces background processing
#   - Live Activity widgets won't update in real-time
#   - May improve battery life slightly
#
# PROFILES: max
#
# NOTE: This is a best-effort setting. The exact behavior may vary depending
#       on macOS version and which apps use Live Activities.
###############################################################################

# Apply: Disable Live Activities tracking
m_live_apply() {
  info "[live] Disable Live Activities (best-effort)"

  # Disable the activity tracking daemon
  defaults write com.apple.activitytrackingd ActivityTrackingEnabled -bool false
}

# Revert: Re-enable Live Activities
m_live_revert() {
  info "[live] Revert Live Activities (best-effort)"

  # Remove override to restore default Live Activities behavior
  defaults_del com.apple.activitytrackingd ActivityTrackingEnabled
}
