# MacTweaks/modules/spotlight.sh
# Module: Spotlight (indexing + suggestions)

m_spotlight_apply() {
  info "[spotlight] Disable indexing + suggestions"
  sudo mdutil -a -i off 2>/dev/null || true
  sudo mdutil -a -d 2>/dev/null || true
  defaults write com.apple.Spotlight SuggestionsEnabled -bool false
  defaults write com.apple.Spotlight.plist IntelligentSuggestionsEnabled -bool false
}

m_spotlight_revert() {
  info "[spotlight] Enable indexing + reset suggestions"
  sudo mdutil -a -i on 2>/dev/null || true
  defaults_del com.apple.Spotlight SuggestionsEnabled
  defaults_del com.apple.Spotlight.plist IntelligentSuggestionsEnabled
}
