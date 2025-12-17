###############################################################################
# MacTweaks/modules/analytics.sh
# Module: Apple Analytics and Diagnostics
#
# DESCRIPTION:
#   Disables Apple's analytics collection and diagnostic reporting services.
#   This reduces background activity and network uploads to Apple servers.
#
# SERVICES DISABLED:
#   - com.apple.analyticsd: Main analytics daemon
#   - com.apple.SubmitDiagInfo: Diagnostic submission service
#   - CrashReporter dialog: Suppresses crash report prompts
#
# IMPACT:
#   - Reduces background CPU and network activity
#   - Improves privacy by limiting data sent to Apple
#   - Crash reports will no longer be sent automatically
#
# PROFILES: max, balanced
#
# NOTE: This does not affect System Settings > Privacy > Analytics toggle.
#       For complete control, also disable analytics in System Settings.
###############################################################################

# Apply: Disable analytics daemons and crash reporter dialog
m_analytics_apply() {
  info "[analytics] Disable analytics/diagnostics"

  # Disable the analytics daemon (collects usage data)
  launchctl_disable_safe system/com.apple.analyticsd

  # Disable diagnostic info submission
  launchctl_disable_safe system/com.apple.SubmitDiagInfo

  # Suppress crash reporter dialog (set to "none" instead of "crashreport")
  defaults write com.apple.CrashReporter DialogType none
}

# Revert: Re-enable analytics services and crash reporter
m_analytics_revert() {
  info "[analytics] Enable analytics/diagnostics"

  # Re-enable analytics daemon
  launchctl_enable_safe system/com.apple.analyticsd

  # Re-enable diagnostic submission
  launchctl_enable_safe system/com.apple.SubmitDiagInfo

  # Restore crash reporter dialog
  defaults write com.apple.CrashReporter DialogType crashreport
}
