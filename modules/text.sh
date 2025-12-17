# MacTweaks/modules/text.sh
# Module: Text intelligence / suggestions

m_text_apply() {
  info "[text] Disable spell correction + text completion"
  defaults write NSGlobalDomain NSAllowContinuousSpellChecking -bool false
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticTextCompletionEnabled -bool false
}

m_text_revert() {
  info "[text] Restore spell correction + text completion defaults"
  defaults_del NSGlobalDomain NSAllowContinuousSpellChecking
  defaults_del NSGlobalDomain NSAutomaticSpellingCorrectionEnabled
  defaults_del NSGlobalDomain NSAutomaticTextCompletionEnabled
}
