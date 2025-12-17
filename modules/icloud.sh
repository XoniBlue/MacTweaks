# MacTweaks/modules/icloud.sh
# Module: iCloud Desktop & Documents (aggressive)

m_icloud_apply() {
  info "[icloud] Disable iCloud Desktop & Documents syncing (aggressive)"
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
  defaults write com.apple.iCloudDrive DisableDesktopAndDocuments -bool true
}

m_icloud_revert() {
  info "[icloud] Revert iCloud Desktop & Documents behavior"
  defaults_del NSGlobalDomain NSDocumentSaveNewDocumentsToCloud
  defaults_del com.apple.iCloudDrive DisableDesktopAndDocuments
}
