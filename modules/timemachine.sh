# MacTweaks/modules/timemachine.sh
# Module: Time Machine local snapshots

m_timemachine_apply() {
  info "[timemachine] Disable local snapshots"
  sudo tmutil disablelocal 2>/dev/null || true
}

m_timemachine_revert() {
  info "[timemachine] Enable local snapshots"
  sudo tmutil enablelocal 2>/dev/null || true
}
