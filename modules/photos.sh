# MacTweaks/modules/photos.sh
# Module: Photos background analysis

m_photos_apply() {
  info "[photos] Disable photo analysis daemons (best-effort)"
  launchctl_disable_safe system/com.apple.photoanalysisd
  launchctl_disable_safe system/com.apple.photolibraryd
}

m_photos_revert() {
  info "[photos] Enable photo analysis daemons (best-effort)"
  launchctl_enable_safe system/com.apple.photoanalysisd
  launchctl_enable_safe system/com.apple.photolibraryd
}
