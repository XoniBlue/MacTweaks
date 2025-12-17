###############################################################################
# MacTweaks/modules/text.sh
# Module: Text intelligence and autocorrection control
#
# DESCRIPTION:
#   Disables macOS text intelligence features including spell checking,
#   autocorrection, and text completion. These features can interfere with
#   technical writing, code documentation, and specialized terminology.
#
# SETTINGS CHANGED:
#   - NSAllowContinuousSpellChecking: Disable red underlines for spelling
#   - NSAutomaticSpellingCorrectionEnabled: Disable auto-correction
#   - NSAutomaticTextCompletionEnabled: Disable predictive text
#
# IMPACT:
#   - Reduces background processing for text analysis
#   - Eliminates unwanted autocorrection in technical contexts
#   - No interference with code, commands, or specialized terms
#   - Manual spell checking still available in apps
#
# PROFILES: max, balanced
#
# NOTE: Individual apps may have their own spell check settings that
#       override these system-wide preferences.
###############################################################################

# Apply: Disable spell correction and text completion
m_text_apply() {
  info "[text] Disable spell correction + text completion"

  # Disable continuous spell checking (red underlines)
  defaults write NSGlobalDomain NSAllowContinuousSpellChecking -bool false

  # Disable automatic spelling correction
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

  # Disable automatic text completion suggestions
  defaults write NSGlobalDomain NSAutomaticTextCompletionEnabled -bool false
}

# Revert: Restore spell correction and text completion defaults
m_text_revert() {
  info "[text] Restore spell correction + text completion defaults"

  # Remove all text intelligence overrides
  defaults_del NSGlobalDomain NSAllowContinuousSpellChecking
  defaults_del NSGlobalDomain NSAutomaticSpellingCorrectionEnabled
  defaults_del NSGlobalDomain NSAutomaticTextCompletionEnabled
}
