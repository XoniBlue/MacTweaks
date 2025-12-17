###############################################################################
# MacTweaks/modules/finder.sh
# Module: Finder performance and usability tweaks
#
# DESCRIPTION:
#   Optimizes Finder for better performance and usability. Disables animations,
#   prevents .DS_Store file creation on network/USB drives, and enables useful
#   UI elements like path and status bars.
#
# SETTINGS CHANGED:
#   - DisableAllAnimations: Removes window animations for snappier feel
#   - FXEnableExtensionChangeWarning: Disables "change extension?" prompts
#   - ShowPathbar: Shows full path at bottom of Finder windows
#   - ShowStatusBar: Shows item count and available space
#   - DSDontWriteNetworkStores: Prevents .DS_Store on network drives
#   - DSDontWriteUSBStores: Prevents .DS_Store on USB drives
#
# IMPACT:
#   - Faster Finder window operations
#   - Cleaner network/USB drives (no .DS_Store clutter)
#   - Better file navigation with path/status bars
#
# PROFILES: max, balanced, battery
###############################################################################

# Apply: Optimize Finder settings for performance and usability
m_finder_apply() {
  info "[finder] Reduce Finder churn + enable path/status bars"

  # Disable all Finder window animations (opening, closing, resizing)
  defaults write com.apple.finder DisableAllAnimations -bool true

  # Disable "Are you sure you want to change the extension?" warning
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  # Show path bar at bottom of Finder windows (shows full directory path)
  defaults write com.apple.finder ShowPathbar -bool true

  # Show status bar at bottom (shows item count and disk space)
  defaults write com.apple.finder ShowStatusBar -bool true

  # Prevent creation of .DS_Store files on network volumes
  # These hidden files can cause issues on shared drives
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

  # Prevent creation of .DS_Store files on USB drives
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
}

# Revert: Restore Finder to default settings
m_finder_revert() {
  info "[finder] Revert Finder tweaks"

  # Remove all custom Finder settings
  defaults_del com.apple.finder DisableAllAnimations
  defaults_del com.apple.finder FXEnableExtensionChangeWarning
  defaults_del com.apple.finder ShowPathbar
  defaults_del com.apple.finder ShowStatusBar
  defaults_del com.apple.desktopservices DSDontWriteNetworkStores
  defaults_del com.apple.desktopservices DSDontWriteUSBStores
}
