###############################################################################
# MacTweaks/modules/visual.sh
# Module: Accessibility visual effects control
#
# DESCRIPTION:
#   Reduces visual complexity by enabling accessibility features that minimize
#   transparency, motion effects, and enhance contrast. These settings reduce
#   GPU compositing overhead and make the interface more responsive.
#
# SETTINGS CHANGED:
#   - reduceTransparency: Remove blur and transparency effects
#   - reduceMotion: Minimize parallax and animation effects
#   - enhanceContrast: Increase UI element contrast and borders
#   - AppleReduceDesktopTinting: Disable desktop color tinting
#
# WHAT THIS AFFECTS:
#   - Window transparency and blur effects (Dock, menu bar, etc.)
#   - Parallax effects on wallpaper and UI elements
#   - Animation effects throughout the system
#   - Desktop tinting based on wallpaper colors
#
# IMPACT:
#   - Reduces GPU load, especially on integrated graphics
#   - Improves perceived responsiveness
#   - Better battery life on laptops
#   - Cleaner, more utilitarian appearance
#   - Easier to see for some users
#
# PROFILES: max, balanced, battery
#
# IMPORTANT: On macOS Sequoia (15.x), some accessibility settings may be
#            protected and require manual changes:
#            System Settings → Accessibility → Display → Reduce Motion/Transparency
#
# NOTE: These are accessibility features, so they provide functional benefits
#       beyond just performance. Users with visual sensitivities may prefer
#       these settings even without performance concerns.
###############################################################################

# Apply: Enable accessibility visual reductions
m_visual_apply() {
  info "[visual] Reduce transparency/motion + enhance contrast"

  # Remove transparency and blur effects from windows and UI
  # This has the biggest GPU impact - blur is expensive to compute
  defaults write com.apple.universalaccess reduceTransparency -bool true || true

  # Reduce motion and parallax effects
  # Minimizes animation complexity throughout the system
  defaults write com.apple.universalaccess reduceMotion -bool true || true

  # Enhance contrast for better visibility and clearer UI boundaries
  # Adds stronger borders and reduces subtle color gradients
  defaults write com.apple.universalaccess enhanceContrast -bool true || true

  # Disable desktop tinting (wallpaper color influence on UI)
  defaults write NSGlobalDomain AppleReduceDesktopTinting -bool true

  # Note for Sequoia users
  if [[ "$OS_VERSION" =~ ^15\. ]]; then
    warn "On Sequoia, some settings may require manual System Settings changes"
    warn "Go to: System Settings → Accessibility → Display"
  fi
}

# Revert: Restore default visual effects
m_visual_revert() {
  info "[visual] Revert visual settings to defaults"

  # Remove all visual accessibility overrides
  # This restores macOS's default visual appearance
  defaults_del com.apple.universalaccess reduceTransparency
  defaults_del com.apple.universalaccess reduceMotion
  defaults_del com.apple.universalaccess enhanceContrast
  defaults_del NSGlobalDomain AppleReduceDesktopTinting
}
