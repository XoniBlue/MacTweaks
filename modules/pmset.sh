# MacTweaks/modules/pmset.sh
# Module: pmset background wakeups (Intel-forward)

m_pmset_apply() {
  info "[pmset] Reduce background wakeups (powernap/tcpkeepalive)"
  pmset_set -a powernap 0
  pmset_set -a tcpkeepalive 0
}

m_pmset_revert() {
  info "[pmset] Restore background wakeups defaults (powernap/tcpkeepalive)"
  pmset_set -a powernap 1
  pmset_set -a tcpkeepalive 1
}
