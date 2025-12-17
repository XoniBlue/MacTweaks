# MacTweaks/modules/airdrop.sh
# Module: AirDrop scanning

m_airdrop_apply() {
  info "[airdrop] Disable AirDrop in Finder (reduces background scanning)"
  defaults write com.apple.NetworkBrowser DisableAirDrop -bool true
}

m_airdrop_revert() {
  info "[airdrop] Re-enable AirDrop in Finder"
  defaults_del com.apple.NetworkBrowser DisableAirDrop
}
