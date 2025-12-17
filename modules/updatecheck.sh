###############################################################################
# MacTweaks/modules/updatecheck.sh
# Module: System compatibility and optimization potential check
#
# DESCRIPTION:
#   Informational module that detects system configuration and reports
#   expected optimization effectiveness. Helps users understand what kind
#   of performance improvements to expect based on their hardware.
#
# INFORMATION DISPLAYED:
#   - macOS version compatibility
#   - Processor architecture (Intel vs Apple Silicon)
#   - Expected optimization impact level
#   - System details (OS version, build, CPU)
#
# OPTIMIZATION EXPECTATIONS:
#   Intel Macs:
#   - Maximum impact expected (10-30% performance gain)
#   - Significant thermal improvement
#   - Notable battery life extension on laptops
#   - Most impactful optimizations: Spotlight, pmset, visual effects
#
#   Apple Silicon Macs:
#   - Smaller impact (5-15% gain, already optimized)
#   - Mainly UI responsiveness improvements
#   - Minor thermal/battery gains
#   - Still worthwhile for UI smoothness and privacy features
#
#   macOS Versions:
#   - Sequoia (15.x): Toolkit fully optimized for this version
#   - Sonoma (14.x): Most optimizations compatible
#   - Ventura (13.x): Compatible, some features may not apply
#   - Older: Compatibility may vary
#
# PROFILES: max, balanced, battery (as informational step)
#
# NOTE: This module only displays information - it makes no changes to
#       the system. Used to set user expectations before applying profiles.
###############################################################################

# Apply: Display system compatibility and optimization expectations
m_updatecheck_apply() {
  info "[updatecheck] Compatibility check"

  # Check macOS version and provide version-specific info
  if [[ "$OS_VERSION" =~ ^15\. ]]; then
    ok "macOS Sequoia detected — toolkit fully optimized for this version"
  elif [[ "$OS_VERSION" =~ ^14\. ]]; then
    info "macOS Sonoma detected — most optimizations compatible"
  elif [[ "$OS_VERSION" =~ ^13\. ]]; then
    warn "macOS Ventura detected — some features may not apply"
  else
    warn "Older macOS detected — compatibility may vary"
  fi

  echo

  # Provide architecture-specific expectations
  if is_intel; then
    ok "Intel Mac detected — maximum performance gains expected"
    info "Intel systems benefit most from these optimizations"
    info "Expected impact: 10-30% improvement in CPU/thermal/battery metrics"
    info "Biggest wins: Spotlight disable, pmset tweaks, visual effects reduction"
  else
    info "Apple Silicon detected — optimizations still beneficial"
    warn "Apple Silicon Macs are already highly optimized by hardware"
    info "Expected impact: 5-15% improvement, mainly in UI responsiveness"
    info "Biggest wins: UI animations, visual effects, privacy features"
  fi

  echo

  # Display system details for reference
  info "System Details:"
  info "  OS: macOS $OS_VERSION ($OS_BUILD)"
  info "  Architecture: $ARCH"
  info "  CPU: $CPU_BRAND"
  info "  User: $USER"
}

# Revert: No-op (informational module only)
m_updatecheck_revert() { true; }
