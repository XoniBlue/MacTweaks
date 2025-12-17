###############################################################################
# MacTweaks/modules/appnap.sh
# Module: App Nap (global disable)
#
# DESCRIPTION:
#   Disables App Nap, macOS's power-saving feature that throttles background
#   applications. When disabled, apps maintain full performance even when
#   hidden or in the background.
#
# WHAT IS APP NAP:
#   App Nap automatically reduces CPU priority and timer frequency for apps
#   that are not visible, saving power on laptops. However, this can cause
#   delays in background tasks.
#
# IMPACT:
#   - Background apps run at full speed
#   - May increase power consumption
#   - Improves responsiveness of hidden apps
#   - Useful for apps that need constant background processing
#
# PROFILES: max, balanced
#
# NOTE: Individual apps can also have App Nap disabled via Get Info in Finder.
#       This module disables it globally for all applications.
###############################################################################

# Apply: Disable App Nap globally for all applications
# Sets NSAppSleepDisabled=true in NSGlobalDomain
m_appnap_apply() {
  info "[appnap] Disable App Nap"
  defaults write NSGlobalDomain NSAppSleepDisabled -bool true
}

# Revert: Restore App Nap to default behavior
# Removes the override, allowing macOS to manage app sleeping normally
m_appnap_revert() {
  info "[appnap] Restore App Nap default"
  defaults_del NSGlobalDomain NSAppSleepDisabled
}
