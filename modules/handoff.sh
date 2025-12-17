###############################################################################
# MacTweaks/modules/handoff.sh
# Module: Handoff / Continuity feature control
#
# DESCRIPTION:
#   Disables Apple's Handoff and Continuity features, which allow seamless
#   activity transfer between Mac and iOS devices. These features use
#   Bluetooth Low Energy for constant background discovery.
#
# WHAT IS HANDOFF:
#   - Continue tasks started on iPhone/iPad on your Mac (and vice versa)
#   - Universal Clipboard sharing between devices
#   - Continuity Camera, Continuity Sketch, etc.
#
# SETTINGS CHANGED:
#   - ActivityAdvertisingAllowed: Stops Mac from advertising activities
#   - ActivityReceivingAllowed: Stops Mac from receiving activities
#
# IMPACT:
#   - Reduces background Bluetooth/WiFi activity
#   - May improve battery life slightly
#   - Breaks cross-device workflow features
#
# PROFILES: max
#
# NOTE: AirDrop is handled by a separate module (airdrop.sh).
###############################################################################

# Apply: Disable Handoff activity advertising and receiving
m_handoff_apply() {
  info "[handoff] Disable Continuity/Handoff advertising/receiving"

  # Stop advertising activities to other devices
  defaults write com.apple.coreservices.useractivityd ActivityAdvertisingAllowed -bool false

  # Stop receiving activities from other devices
  defaults write com.apple.coreservices.useractivityd ActivityReceivingAllowed -bool false
}

# Revert: Re-enable Handoff features
m_handoff_revert() {
  info "[handoff] Revert Continuity/Handoff"

  # Remove overrides to restore default Handoff behavior
  defaults_del com.apple.coreservices.useractivityd ActivityAdvertisingAllowed
  defaults_del com.apple.coreservices.useractivityd ActivityReceivingAllowed
}
