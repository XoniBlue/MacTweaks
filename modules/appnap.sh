# MacTweaks/modules/appnap.sh
# Module: App Nap (global)

m_appnap_apply() {
  info "[appnap] Disable App Nap"
  defaults write NSGlobalDomain NSAppSleepDisabled -bool true
}

m_appnap_revert() {
  info "[appnap] Restore App Nap default"
  defaults_del NSGlobalDomain NSAppSleepDisabled
}
