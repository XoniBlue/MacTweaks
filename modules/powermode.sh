# modules/powermode.sh
m_powermode_apply() {
  info "[powermode] Enabling Low Power Mode on battery"
  pmset_set -b lowpowermode 1
}

m_powermode_revert() {
  info "[powermode] Disabling Low Power Mode"
  pmset_set -b lowpowermode 0
}
