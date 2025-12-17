# modules/appleintelligence.sh
m_appleintelligence_apply() {
  info "[appleintelligence] Disabling Apple Intelligence features"
  defaults write com.apple.applicationaccess AllowAppleIntelligence -bool false || true
  defaults write com.apple.IntelligencePlatform.UserAccess AllowedUserAccess -bool false || true
  defaults write com.apple.IntelligencePlatform.WritingTools UserAccessEnabled -bool false || true
  defaults write com.apple.IntelligencePlatform.ImagePlayground UserAccessEnabled -bool false || true
  defaults write com.apple.IntelligencePlatform.Genmoji UserAccessEnabled -bool false || true
}

m_appleintelligence_revert() {
  info "[appleintelligence] Re-enabling Apple Intelligence features"
  defaults_del com.apple.applicationaccess AllowAppleIntelligence
  defaults_del com.apple.IntelligencePlatform.UserAccess AllowedUserAccess
  defaults_del com.apple.IntelligencePlatform.WritingTools UserAccessEnabled
  defaults_del com.apple.IntelligencePlatform.ImagePlayground UserAccessEnabled
  defaults_del com.apple.IntelligencePlatform.Genmoji UserAccessEnabled
}
