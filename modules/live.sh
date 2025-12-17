# MacTweaks/modules/live.sh
# Module: Live Activities (best-effort)

m_live_apply() {
  info "[live] Disable Live Activities (best-effort)"
  defaults write com.apple.activitytrackingd ActivityTrackingEnabled -bool false
}

m_live_revert() {
  info "[live] Revert Live Activities (best-effort)"
  defaults_del com.apple.activitytrackingd ActivityTrackingEnabled
}
