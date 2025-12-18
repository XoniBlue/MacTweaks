###############################################################################
# MacTweaks/modules/lowpower_on_charge.sh
# Module: Low Power Mode while charging
#
# DESCRIPTION:
#   Installs a LaunchAgent that toggles Low Power Mode based on charging state.
#   When plugged into AC and below 100%, Low Power Mode is enabled to reduce
#   thermals; once the battery is full, Low Power Mode is disabled.
#
# ARTIFACTS:
#   - Installs: ~/.mactweaks/lowpower_on_charge.sh
#   - LaunchAgent: ~/Library/LaunchAgents/com.mactweaks.lowpower_on_charge.plist
#
# PROFILES: None by default (run manually via module menu/flag)
###############################################################################

# Apply: Install LaunchAgent to manage Low Power Mode while charging
m_lowpower_on_charge_apply() {
  info "[lowpower_on_charge] Installing LaunchAgent for Low Power on charge"
  run_module_script lowpower_on_charge install
  ok "[lowpower_on_charge] LaunchAgent installed"
}

# Revert: Remove LaunchAgent and restore default power state
m_lowpower_on_charge_revert() {
  info "[lowpower_on_charge] Removing LaunchAgent and disabling Low Power Mode"
  run_module_script lowpower_on_charge uninstall
  ok "[lowpower_on_charge] LaunchAgent removed"
}
