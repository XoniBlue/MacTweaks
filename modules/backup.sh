###############################################################################
# MacTweaks/modules/backup.sh
# Module: Automatic preference backup
#
# DESCRIPTION:
#   Creates timestamped backups of key system preferences before changes.
#   This allows manual restoration if needed. Backups are stored in the
#   toolkit's data directory.
#
# FILES BACKED UP:
#   - finder.plist: Finder preferences
#   - global.plist: NSGlobalDomain (system-wide defaults)
#   - dock.plist: Dock preferences
#   - pmset.txt: Power management settings
#
# BACKUP LOCATION:
#   ~/Library/Application Support/MacTweaks/backups/<timestamp>/
#
# PROFILES: max, balanced, battery
#
# NOTE: This module only creates backups, it does not restore them.
#       To restore, manually import the .plist files using:
#       defaults import <domain> <backup.plist>
###############################################################################

# Apply: Create backup of key preferences
# Exports current settings to timestamped directory
m_backup_apply() {
  # Create unique backup directory with timestamp
  local backup_dir="$APP_DIR/backups/$(NOW_STAMP)"
  mkdir -p "$backup_dir"

  info "[backup] Backing up key preferences to $backup_dir"

  # Export Finder preferences
  defaults export com.apple.finder "$backup_dir/finder.plist" 2>/dev/null || true

  # Export global domain (system-wide settings)
  defaults export NSGlobalDomain "$backup_dir/global.plist" 2>/dev/null || true

  # Export Dock preferences
  defaults export com.apple.dock "$backup_dir/dock.plist" 2>/dev/null || true

  # Save current power management settings as text
  pmset -g > "$backup_dir/pmset.txt"

  ok "Backup saved to $backup_dir"
}

# Revert: No-op (backups are informational only)
# Restoration must be done manually if needed
m_backup_revert() {
  info "[backup] No revert needed"
  true
}
