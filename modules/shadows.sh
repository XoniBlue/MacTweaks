###############################################################################
# MacTweaks/modules/shadows.sh
# Module: Window shadow effects control
#
# DESCRIPTION:
#   Disables window shadow effects rendered by the WindowServer. Shadows are
#   composited on every window and can consume GPU resources, especially on
#   systems with many overlapping windows.
#
# WHAT ARE WINDOW SHADOWS:
#   - Drop shadows under all windows
#   - Rendered by WindowServer (the macOS display compositor)
#   - Require GPU compositing for transparency effects
#
# IMPACT:
#   - Reduces GPU usage slightly
#   - May improve performance on integrated graphics
#   - Windows appear "flat" without shadows
#   - Purely cosmetic change
#
# PROFILES: max, balanced, battery
#
# NOTE: This is a best-effort setting. Modern macOS may not fully honor
#       this preference. Full shadow control may require additional
#       accessibility settings.
###############################################################################

# Apply: Disable window shadows
m_shadows_apply() {
  info "[shadows] Reduce WindowServer shadow effects (best-effort)"

  # Disable shadow rendering in WindowServer
  defaults write com.apple.windowserver DisableShadow -bool true
}

# Revert: Re-enable window shadows
m_shadows_revert() {
  info "[shadows] Revert shadow effects"

  # Remove override to restore default shadow behavior
  defaults_del com.apple.windowserver DisableShadow
}
