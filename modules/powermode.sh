###############################################################################
# MacTweaks/modules/powermode.sh
# Module: Low Power Mode control
#
# DESCRIPTION:
#   Enables macOS Low Power Mode when running on battery. This system-wide
#   setting reduces performance to extend battery life.
#
# WHAT LOW POWER MODE DOES:
#   - Reduces CPU/GPU performance
#   - Dims display brightness
#   - Reduces background activity
#   - Pauses automatic downloads
#   - Reduces visual effects
#
# SETTINGS CHANGED:
#   - lowpowermode: Set to 1 (enabled) on battery power (-b)
#
# IMPACT:
#   - Significant battery life improvement
#   - Reduced performance for demanding tasks
#   - Only affects battery operation (not when plugged in)
#
# PROFILES: max, battery
#
# NOTE: This only enables Low Power Mode on battery (-b flag).
#       When plugged in, the Mac runs at full performance.
###############################################################################

# Apply: Enable Low Power Mode when on battery
m_powermode_apply() {
  info "[powermode] Enabling Low Power Mode on battery"

  # Enable low power mode on battery power only
  # -b = battery power source
  # 1 = enabled
  pmset_set -b lowpowermode 1
}

# Revert: Disable Low Power Mode
m_powermode_revert() {
  info "[powermode] Disabling Low Power Mode"

  # Disable low power mode on battery
  # 0 = disabled
  pmset_set -b lowpowermode 0
}
