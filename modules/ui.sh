###############################################################################
# MacTweaks/modules/ui.sh
# Module: UI animations and Dock responsiveness control
#
# DESCRIPTION:
#   Dramatically reduces or eliminates macOS UI animations for a snappier,
#   more responsive desktop experience. Targets window animations, resize
#   operations, and Dock behavior for maximum perceived speed improvement.
#
# SETTINGS CHANGED:
#   - NSAutomaticWindowAnimationsEnabled: Disable window open/close animations
#   - NSWindowResizeTime: Near-instant window resizing (0.001s)
#   - expose-animation-duration: Faster Mission Control/Exposé (0.1s)
#   - autohide-delay: Remove Dock show delay (0s)
#   - autohide-time-modifier: Faster Dock show/hide animation (0.15s)
#
# WHAT THIS AFFECTS:
#   - Window opening and closing animations
#   - Window resize smoothness
#   - Mission Control/Exposé transitions
#   - Dock auto-hide behavior and timing
#   - Overall perceived system responsiveness
#
# IMPACT:
#   - Significant improvement in perceived responsiveness
#   - Instant feedback for window operations
#   - Snappier Dock interactions
#   - Reduced visual polish (more utilitarian feel)
#   - May feel jarring initially for users accustomed to smooth animations
#
# PROFILES: max, balanced, battery
#
# NOTE: This is one of the most immediately noticeable optimizations.
#       The system will feel considerably faster, even though actual
#       performance hasn't changed - you're just waiting less for animations.
#
# COMPATIBILITY: Works on all macOS versions; some values may be ignored
#                on newer versions but are safe to set.
###############################################################################

# Apply: Reduce animations and Dock delay for snappier UI
m_ui_apply() {
  info "[ui] Reduce animations + Dock delay"

  # Disable automatic window animations (opening/closing)
  # Windows appear/disappear instantly instead of animating
  defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

  # Set window resize time to near-instant (0.001 seconds)
  # Default is around 0.2s which feels sluggish
  defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

  # Speed up Mission Control/Exposé animation (0.1s instead of ~0.5s)
  # Makes switching between desktops and viewing all windows much faster
  defaults write com.apple.dock expose-animation-duration -float 0.1

  # Remove Dock auto-hide delay (show immediately on hover)
  # Default delay is ~0.5s which feels unresponsive
  defaults write com.apple.dock autohide-delay -float 0

  # Speed up Dock show/hide animation (0.15s)
  # Default is slower; this makes it feel snappy
  defaults write com.apple.dock autohide-time-modifier -float 0.15
}

# Revert: Restore default animation settings
m_ui_revert() {
  info "[ui] Restore animation defaults"

  # Remove all UI animation overrides to restore macOS defaults
  defaults_del NSGlobalDomain NSAutomaticWindowAnimationsEnabled
  defaults_del NSGlobalDomain NSWindowResizeTime
  defaults_del com.apple.dock expose-animation-duration
  defaults_del com.apple.dock autohide-delay
  defaults_del com.apple.dock autohide-time-modifier
}
