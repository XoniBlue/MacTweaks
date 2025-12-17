# MacTweaks/modules/siri.sh
# Module: Siri / Assistant

m_siri_apply() {
  info "[siri] Disable Siri + assistant daemons"
  defaults write com.apple.assistant.support "Assistant Enabled" -bool false
  defaults write com.apple.Siri StatusMenuVisible -bool false
  launchctl disable user/$(id -u)/com.apple.assistantd 2>/dev/null || true
  launchctl disable user/$(id -u)/com.apple.Siri.agent 2>/dev/null || true
}

m_siri_revert() {
  info "[siri] Enable Siri + assistant daemons"
  defaults write com.apple.assistant.support "Assistant Enabled" -bool true
  defaults write com.apple.Siri StatusMenuVisible -bool true
  launchctl enable user/$(id -u)/com.apple.assistantd 2>/dev/null || true
  launchctl enable user/$(id -u)/com.apple.Siri.agent 2>/dev/null || true
}
