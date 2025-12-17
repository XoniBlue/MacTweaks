# modules/updatecheck.sh
m_updatecheck_apply() {
  info "[updatecheck] Compatibility check"
  if [[ "$OS_VERSION" == 15.* ]]; then
    info "macOS Sequoia detected — toolkit optimized"
  fi
  if is_intel; then
    info "Intel Mac — maximum performance gains expected"
  else
    warn "Apple Silicon — some tweaks have smaller impact"
  fi
}

m_updatecheck_revert() { true; }
