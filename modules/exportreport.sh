# modules/exportreport.sh
m_exportreport_apply() {
  local latest_report="$(ls -t "$REPORT_DIR"/report_*.txt 2>/dev/null | head -n1)"
  if [[ -n "$latest_report" ]]; then
    cp "$latest_report" ~/Desktop/SequoiaPerf_Report_$(date '+%Y%m%d_%H%M').txt"
    ok "Report exported to Desktop"
  else
    warn "No recent report found"
  fi
}

m_exportreport_revert() { true; }
