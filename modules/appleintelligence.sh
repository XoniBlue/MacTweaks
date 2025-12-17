###############################################################################
# MacTweaks/modules/appleintelligence.sh
# Module: Apple Intelligence (AI) features
#
# DESCRIPTION:
#   Disables Apple Intelligence features introduced in macOS Sequoia 15.x.
#   These AI features can consume system resources for on-device processing.
#
# FEATURES DISABLED:
#   - AllowAppleIntelligence: Master switch for AI features
#   - WritingTools: AI-powered text rewriting and summarization
#   - ImagePlayground: AI image generation
#   - Genmoji: AI-generated emoji
#   - AllowedUserAccess: General AI feature access
#
# IMPACT:
#   - Reduces background AI processing
#   - May improve performance on older hardware
#   - Frees up resources used by AI models
#
# PROFILES: max, balanced
#
# NOTE: These settings use "|| true" to silently handle cases where
#       the keys don't exist (older macOS versions without Apple Intelligence).
###############################################################################

# Apply: Disable all Apple Intelligence features
m_appleintelligence_apply() {
  info "[appleintelligence] Disabling Apple Intelligence features"

  # Master switch for Apple Intelligence
  defaults write com.apple.applicationaccess AllowAppleIntelligence -bool false || true

  # User access control for AI features
  defaults write com.apple.IntelligencePlatform.UserAccess AllowedUserAccess -bool false || true

  # Writing Tools (text rewriting, summarization, proofreading)
  defaults write com.apple.IntelligencePlatform.WritingTools UserAccessEnabled -bool false || true

  # Image Playground (AI image generation)
  defaults write com.apple.IntelligencePlatform.ImagePlayground UserAccessEnabled -bool false || true

  # Genmoji (AI-generated emoji)
  defaults write com.apple.IntelligencePlatform.Genmoji UserAccessEnabled -bool false || true
}

# Revert: Re-enable Apple Intelligence features (restore defaults)
m_appleintelligence_revert() {
  info "[appleintelligence] Re-enabling Apple Intelligence features"

  # Remove all overrides to restore default behavior
  defaults_del com.apple.applicationaccess AllowAppleIntelligence
  defaults_del com.apple.IntelligencePlatform.UserAccess AllowedUserAccess
  defaults_del com.apple.IntelligencePlatform.WritingTools UserAccessEnabled
  defaults_del com.apple.IntelligencePlatform.ImagePlayground UserAccessEnabled
  defaults_del com.apple.IntelligencePlatform.Genmoji UserAccessEnabled
}
