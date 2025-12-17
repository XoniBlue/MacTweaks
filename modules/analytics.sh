# MacTweaks/modules/analytics.sh
# Module: Analytics / Diagnostics

m_analytics_apply() {
  info "[analytics] Disable analytics/diagnostics"
  launchctl_disable_safe system/com.apple.analyticsd
  launchctl_disable_safe system/com.apple.SubmitDiagInfo
  defaults write com.apple.CrashReporter DialogType none
}

m_analytics_revert() {
  info "[analytics] Enable analytics/diagnostics"
  launchctl_enable_safe system/com.apple.analyticsd
  launchctl_enable_safe system/com.apple.SubmitDiagInfo
  defaults write com.apple.CrashReporter DialogType crashreport
}
