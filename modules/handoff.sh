# MacTweaks/modules/handoff.sh
# Module: Handoff / Continuity advertising

m_handoff_apply() {
  info "[handoff] Disable Continuity/Handoff advertising/receiving"
  defaults write com.apple.coreservices.useractivityd ActivityAdvertisingAllowed -bool false
  defaults write com.apple.coreservices.useractivityd ActivityReceivingAllowed -bool false
}

m_handoff_revert() {
  info "[handoff] Revert Continuity/Handoff"
  defaults_del com.apple.coreservices.useractivityd ActivityAdvertisingAllowed
  defaults_del com.apple.coreservices.useractivityd ActivityReceivingAllowed
}
