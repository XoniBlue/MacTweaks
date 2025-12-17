# MacTweaks/modules/ui.sh
# Module: UI animations / Dock snappiness

m_ui_apply() {
  info "[ui] Reduce animations + Dock delay"
  defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
  defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
  defaults write com.apple.dock expose-animation-duration -float 0.1
  defaults write com.apple.dock autohide-delay -float 0
  defaults write com.apple.dock autohide-time-modifier -float 0.15
}

m_ui_revert() {
  info "[ui] Restore animation defaults"
  defaults_del NSGlobalDomain NSAutomaticWindowAnimationsEnabled
  defaults_del NSGlobalDomain NSWindowResizeTime
  defaults_del com.apple.dock expose-animation-duration
  defaults_del com.apple.dock autohide-delay
  defaults_del com.apple.dock autohide-time-modifier
}
