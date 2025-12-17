###############################################################################
# MacTweaks/modules/icloud.sh
# Module: iCloud Desktop & Documents sync control
#
# DESCRIPTION:
#   Disables iCloud Drive synchronization for Desktop and Documents folders.
#   This is an aggressive optimization that prevents constant background
#   syncing of these commonly-used folders.
#
# SETTINGS CHANGED:
#   - NSDocumentSaveNewDocumentsToCloud: Stop defaulting to iCloud for new docs
#   - DisableDesktopAndDocuments: Disable Desktop/Documents iCloud sync
#
# IMPACT:
#   - Reduces network traffic and disk I/O
#   - Prevents file upload/download activity
#   - Files will no longer sync to iCloud
#   - Desktop/Documents will be local only
#
# PROFILES: max
#
# WARNING: This is an aggressive change. Files previously synced will remain
#          in iCloud but new changes won't sync. Ensure you have local copies
#          of important files before applying.
#
# NOTE: This does not disable iCloud Drive entirely, just Desktop/Documents sync.
#       Other iCloud Drive folders still sync normally.
###############################################################################

# Apply: Disable iCloud Desktop & Documents syncing
m_icloud_apply() {
  info "[icloud] Disable iCloud Desktop & Documents syncing (aggressive)"

  # Stop defaulting to iCloud when saving new documents
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

  # Disable Desktop & Documents folder syncing to iCloud
  defaults write com.apple.iCloudDrive DisableDesktopAndDocuments -bool true
}

# Revert: Re-enable iCloud Desktop & Documents syncing
m_icloud_revert() {
  info "[icloud] Revert iCloud Desktop & Documents behavior"

  # Remove overrides to restore default iCloud save behavior
  defaults_del NSGlobalDomain NSDocumentSaveNewDocumentsToCloud
  defaults_del com.apple.iCloudDrive DisableDesktopAndDocuments
}
