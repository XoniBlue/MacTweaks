# MacTweaks/modules/updates.sh
# Module: Software Update auto-check (optional)

m_updates_apply() {
  info "[updates] Disable automatic update checks (manual still works)"
  sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false 2>/dev/null || true
}

m_updates_revert() {
  info "[updates] Re-enable automatic update checks"
  sudo defaults delete /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled 2>/dev/null || true
}
