# modules/backup.sh
m_backup_apply() {
  local backup_dir="$APP_DIR/backups/$(NOW_STAMP)"
  mkdir -p "$backup_dir"
  info "[backup] Backing up key preferences to $backup_dir"
  defaults export com.apple.finder "$backup_dir/finder.plist" 2>/dev/null || true
  defaults export NSGlobalDomain "$backup_dir/global.plist" 2>/dev/null || true
  defaults export com.apple.dock "$backup_dir/dock.plist" 2>/dev/null || true
  pmset -g > "$backup_dir/pmset.txt"
  ok "Backup saved to $backup_dir"
}

m_backup_revert() {
  info "[backup] No revert needed"
  true
}
