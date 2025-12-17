###############################################################################
# MacTweaks/modules/airdrop.sh
# Module: AirDrop scanning control
#
# DESCRIPTION:
#   Controls AirDrop functionality in Finder. When applied, disables AirDrop
#   to reduce background Bluetooth/WiFi scanning for nearby devices.
#
# IMPACT:
#   - Reduces background network activity
#   - May improve battery life slightly
#   - Prevents receiving files via AirDrop
#
# PROFILES: max
#
# NOTE: AirDrop can still be used from Control Center even when disabled here.
#       This primarily affects Finder sidebar and background discovery.
###############################################################################

# Apply: Disable AirDrop discovery in Finder
# Sets DisableAirDrop=true in com.apple.NetworkBrowser preferences
m_airdrop_apply() {
  info "[airdrop] Disable AirDrop in Finder (reduces background scanning)"
  defaults write com.apple.NetworkBrowser DisableAirDrop -bool true
}

# Revert: Re-enable AirDrop discovery
# Removes the DisableAirDrop key to restore default behavior
m_airdrop_revert() {
  info "[airdrop] Re-enable AirDrop in Finder"
  defaults_del com.apple.NetworkBrowser DisableAirDrop
}
