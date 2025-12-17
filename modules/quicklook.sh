###############################################################################
# MacTweaks/modules/quicklook.sh
# Module: Quick Look cache management
#
# DESCRIPTION:
#   Clears Quick Look preview caches. These caches store generated thumbnails
#   and previews, which can grow large and occasionally become corrupted.
#
# WHAT IS QUICK LOOK:
#   - Spacebar preview in Finder
#   - Thumbnail generation for files
#   - Preview panel in Finder columns view
#
# COMMANDS USED:
#   - qlmanage -r: Reset Quick Look generators (reloads plugins)
#   - qlmanage -r cache: Clear the thumbnail/preview cache
#
# IMPACT:
#   - Frees disk space from cache files
#   - Fixes broken or corrupted previews
#   - Temporary slowdown as previews regenerate on demand
#
# PROFILES: max, balanced, battery
#
# NOTE: This is an ephemeral operation - caches rebuild automatically.
#       No revert is needed or possible.
###############################################################################

# Apply: Clear Quick Look caches
m_quicklook_apply() {
  info "[quicklook] Clear Quick Look caches"

  # Reset Quick Look generator plugins
  # This reloads all QL plugins and clears their state
  qlmanage -r 2>/dev/null || true

  # Clear the preview/thumbnail cache
  # Cached previews will regenerate when needed
  qlmanage -r cache 2>/dev/null || true
}

# Revert: No-op (caches rebuild automatically)
m_quicklook_revert() {
  info "[quicklook] No revert needed (ephemeral)"
  true
}
