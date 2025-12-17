# MacTweaks/modules/visual.sh
# Module: Accessibility visuals (reduce transparency/motion/contrast)

m_visual_apply() {
  info "[visual] Reduce transparency/motion + enhance contrast"
  defaults write com.apple.universalaccess reduceTransparency -bool true || true
  defaults write com.apple.universalaccess reduceMotion -bool true || true
  defaults write com.apple.universalaccess enhanceContrast -bool true || true
  defaults write NSGlobalDomain AppleReduceDesktopTinting -bool true
}

m_visual_revert() {
  info "[visual] Revert visual settings"
  defaults_del com.apple.universalaccess reduceTransparency
  defaults_del com.apple.universalaccess reduceMotion
  defaults_del com.apple.universalaccess enhanceContrast
  defaults_del NSGlobalDomain AppleReduceDesktopTinting
}
