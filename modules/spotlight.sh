###############################################################################
# MacTweaks/modules/spotlight.sh
# Module: Spotlight indexing and suggestions control
#
# DESCRIPTION:
#   Disables Spotlight indexing and search suggestions. Spotlight constantly
#   indexes files in the background, which can cause significant CPU and disk
#   activity, especially on HDDs or after OS updates.
#
# COMMANDS USED:
#   - mdutil -a -i off: Turn off indexing for all volumes
#   - mdutil -a -d: Disable Spotlight entirely for all volumes
#
# SETTINGS CHANGED:
#   - SuggestionsEnabled: Disable Spotlight Suggestions (web results)
#   - IntelligentSuggestionsEnabled: Disable intelligent/personalized suggestions
#
# IMPACT:
#   - Significantly reduces background CPU and disk I/O
#   - Spotlight search won't find newly added files
#   - No web suggestions in Spotlight
#   - Finder search still works but may be slower
#   - Third-party search tools (Alfred, etc.) may be affected
#
# PROFILES: max, balanced
#
# WARNING: This is one of the most impactful optimizations. Spotlight search
#          will not work properly until indexing is re-enabled and completes.
###############################################################################

# Apply: Disable Spotlight indexing and suggestions
m_spotlight_apply() {
  info "[spotlight] Disable indexing + suggestions"

  # Turn off indexing for all mounted volumes
  # -a = all volumes, -i off = indexing off
  sudo mdutil -a -i off 2>/dev/null || true

  # Disable Spotlight metadata store for all volumes
  # This prevents the index from being used or rebuilt
  sudo mdutil -a -d 2>/dev/null || true

  # Disable Spotlight Suggestions (web search results in Spotlight)
  defaults write com.apple.Spotlight SuggestionsEnabled -bool false

  # Disable intelligent/personalized suggestions
  defaults write com.apple.Spotlight.plist IntelligentSuggestionsEnabled -bool false
}

# Revert: Re-enable Spotlight indexing and suggestions
m_spotlight_revert() {
  info "[spotlight] Enable indexing + reset suggestions"

  # Re-enable indexing for all volumes
  # This will trigger a rebuild of the index
  sudo mdutil -a -i on 2>/dev/null || true

  # Remove suggestion overrides to restore defaults
  defaults_del com.apple.Spotlight SuggestionsEnabled
  defaults_del com.apple.Spotlight.plist IntelligentSuggestionsEnabled
}
