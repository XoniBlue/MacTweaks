# modules/loginitems.sh
m_loginitems_apply() {
  info "[loginitems] Listing current Login Items"
  osascript -e 'tell application "System Events" to get name of every login item' | tee -a "$LOG_FILE"
  warn "Open System Settings → General → Login Items to disable unwanted ones"
}

m_loginitems_revert() {
  info "[loginitems] No automatic revert"
  true
}
