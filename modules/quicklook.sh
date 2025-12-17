# MacTweaks/modules/quicklook.sh
# Module: Quick Look caches

m_quicklook_apply() {
  info "[quicklook] Clear Quick Look caches"
  qlmanage -r 2>/dev/null || true
  qlmanage -r cache 2>/dev/null || true
}

m_quicklook_revert() {
  info "[quicklook] No revert needed (ephemeral)"
  true
}
