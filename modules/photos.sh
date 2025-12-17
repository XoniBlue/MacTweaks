###############################################################################
# MacTweaks/modules/photos.sh
# Module: Photos background analysis control
#
# DESCRIPTION:
#   Disables Photos app background analysis daemons. These daemons scan your
#   photo library for faces, objects, scenes, and locations - which can be
#   CPU and battery intensive with large libraries.
#
# DAEMONS DISABLED:
#   - com.apple.photoanalysisd: Analyzes photos for ML features (faces, scenes)
#   - com.apple.photolibraryd: Manages photo library database and sync
#
# IMPACT:
#   - Reduces background CPU usage
#   - May improve battery life significantly
#   - Face recognition won't update for new photos
#   - "Memories" and smart albums won't update
#   - Photo search by content may be less accurate
#
# PROFILES: max, balanced
#
# NOTE: This is a best-effort setting. The daemons may restart when Photos
#       app is opened. Full analysis resumes when reverted.
###############################################################################

# Apply: Disable Photos background analysis daemons
m_photos_apply() {
  info "[photos] Disable photo analysis daemons (best-effort)"

  # Disable the photo analysis daemon (face/object/scene recognition)
  launchctl_disable_safe system/com.apple.photoanalysisd

  # Disable the photo library daemon (database management)
  launchctl_disable_safe system/com.apple.photolibraryd
}

# Revert: Re-enable Photos analysis daemons
m_photos_revert() {
  info "[photos] Enable photo analysis daemons (best-effort)"

  # Re-enable photo analysis
  launchctl_enable_safe system/com.apple.photoanalysisd

  # Re-enable photo library management
  launchctl_enable_safe system/com.apple.photolibraryd
}
