# MacTweaks/modules/shadows.sh
# Module: WindowServer shadows (best-effort)

m_shadows_apply() {
  info "[shadows] Reduce WindowServer shadow effects (best-effort)"
  defaults write com.apple.windowserver DisableShadow -bool true
}

m_shadows_revert() {
  info "[shadows] Revert shadow effects"
  defaults_del com.apple.windowserver DisableShadow
}
