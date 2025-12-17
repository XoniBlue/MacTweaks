###############################################################################
# MacTweaks/modules/siri.sh
# Module: Siri and Assistant services control
#
# DESCRIPTION:
#   Disables Siri and related assistant services. These run in the background
#   waiting for voice commands and sync data with Apple servers.
#
# SERVICES DISABLED:
#   - Assistant Enabled: Master Siri switch
#   - StatusMenuVisible: Siri icon in menu bar
#   - com.apple.assistantd: Voice processing daemon
#   - com.apple.Siri.agent: Siri background agent
#
# IMPACT:
#   - Reduces background CPU usage
#   - Stops network sync for Siri data
#   - "Hey Siri" voice activation disabled
#   - Siri icon removed from menu bar
#   - Cannot use Siri voice commands
#
# PROFILES: max
#
# NOTE: Uses user-specific launchctl commands (user/$(id -u)) to disable
#       Siri for the current user only.
###############################################################################

# Apply: Disable Siri and assistant services
m_siri_apply() {
  info "[siri] Disable Siri + assistant daemons"

  # Disable Siri at the application level
  defaults write com.apple.assistant.support "Assistant Enabled" -bool false

  # Hide Siri from menu bar
  defaults write com.apple.Siri StatusMenuVisible -bool false

  # Disable assistant daemon (voice processing)
  # Uses current user ID for user-level service
  launchctl disable user/$(id -u)/com.apple.assistantd 2>/dev/null || true

  # Disable Siri agent
  launchctl disable user/$(id -u)/com.apple.Siri.agent 2>/dev/null || true
}

# Revert: Re-enable Siri and assistant services
m_siri_revert() {
  info "[siri] Enable Siri + assistant daemons"

  # Re-enable Siri
  defaults write com.apple.assistant.support "Assistant Enabled" -bool true

  # Show Siri in menu bar
  defaults write com.apple.Siri StatusMenuVisible -bool true

  # Re-enable assistant daemon
  launchctl enable user/$(id -u)/com.apple.assistantd 2>/dev/null || true

  # Re-enable Siri agent
  launchctl enable user/$(id -u)/com.apple.Siri.agent 2>/dev/null || true
}
