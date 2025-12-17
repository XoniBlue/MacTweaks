# MacTweaks/modules/finder.sh
# Module: Finder tweaks

m_finder_apply() {
  info "[finder] Reduce Finder churn + enable path/status bars"
  defaults write com.apple.finder DisableAllAnimations -bool true
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
}

m_finder_revert() {
  info "[finder] Revert Finder tweaks"
  defaults_del com.apple.finder DisableAllAnimations
  defaults_del com.apple.finder FXEnableExtensionChangeWarning
  defaults_del com.apple.finder ShowPathbar
  defaults_del com.apple.finder ShowStatusBar
  defaults_del com.apple.desktopservices DSDontWriteNetworkStores
  defaults_del com.apple.desktopservices DSDontWriteUSBStores
}
