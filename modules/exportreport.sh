###############################################################################
# MacTweaks/modules/exportreport.sh
# Module: Export report to Desktop
#
# DESCRIPTION:
#   Copies the most recent performance report to the user's Desktop for
#   easy access and sharing. The exported file is renamed with a timestamp.
#
# OUTPUT:
#   ~/Desktop/SequoiaPerf_Report_YYYYMMDD_HHMM.txt
#
# PROFILES: max (as final step)
#
# NOTE: Only exports the latest report. If no reports exist, shows a warning.
###############################################################################

# Apply: Copy latest report to Desktop with timestamp
m_exportreport_apply() {
  # Find the most recent report file (sorted by modification time)
  local latest_report="$(ls -t "$REPORT_DIR"/report_*.txt 2>/dev/null | head -n1)"

  if [[ -n "$latest_report" ]]; then
    # Copy to Desktop with new timestamped filename
    cp "$latest_report" ~/Desktop/SequoiaPerf_Report_$(date '+%Y%m%d_%H%M').txt"
    ok "Report exported to Desktop"
  else
    warn "No recent report found"
  fi
}

# Revert: No-op (exported file is left on Desktop, user can delete manually)
m_exportreport_revert() { true; }
