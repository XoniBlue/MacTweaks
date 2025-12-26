###############################################################################
# MacTweaks/modules/exportreport.sh
# Module: exportreport
#
# DESCRIPTION:
#   Copies the most recent performance report to the user's Desktop for
#   easy access and sharing. The exported file is renamed with a timestamp.
#
# OUTPUT:
#   ~/Desktop/SequoiaPerf_Report_YYYYMMDD_HHMM.txt
#
# PROFILES:
#   - max (as final step)
#
# NOTE:
#   - Only exports the latest report
#   - If no reports exist, a warning is shown
###############################################################################

m_exportreport_apply() {
  info "Applying module: exportreport"

  # Ensure report directory exists
  if [[ ! -d "$REPORT_DIR" ]]; then
    warn "Report directory not found: $REPORT_DIR"
    return 0
  fi

  # Find the most recent report file
  local latest_report
  latest_report="$(ls -t "$REPORT_DIR"/report_*.txt 2>/dev/null | head -n1)"

  if [[ -n "$latest_report" && -f "$latest_report" ]]; then
    local dest="$HOME/Desktop/SequoiaPerf_Report_$(date '+%Y%m%d_%H%M').txt"
    cp "$latest_report" "$dest"
    ok "Report exported to Desktop: $(basename "$dest")"
  else
    warn "No recent report found to export"
  fi
}

m_exportreport_revert() {
  # No-op: exported files are intentionally left on Desktop
  true
}

# Backwards compatibility (legacy function names)
apply_exportreport() { m_exportreport_apply; }
revert_exportreport() { m_exportreport_revert; }
