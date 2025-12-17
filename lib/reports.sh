###############################################################################
# MacTweaks/lib/reports.sh
# Before/after comparison report generation.
#
# DESCRIPTION:
#   Generates human-readable comparison reports from before/after snapshots.
#   Reports highlight changes in Spotlight status, power management settings,
#   CPU usage, and thermal/fan data.
#
# FUNCTIONS:
#   report_make_easy - Generate comparison report from two snapshot files
#
# OUTPUT FILES:
#   Reports saved to: $REPORT_DIR/report_<timestamp>.txt
#
# HELPER FUNCTIONS (defined inside report_make_easy):
#   pluck  - Extract first line matching pattern from file
#   top5   - Extract top 5 CPU processes from snapshot
#   fans   - Extract fan-related lines from snapshot
#   temps  - Extract temperature-related lines from snapshot
###############################################################################

###############################################################################
# report_make_easy() - Generate before/after comparison report
# Creates a formatted text report comparing two system snapshots.
# Useful for showing the impact of applied optimizations.
#
# Arguments:
#   $1 (before_file) - Path to "before" snapshot file
#   $2 (after_file)  - Path to "after" snapshot file
#   $3 (stamp)       - Timestamp string for report filename
#
# Returns:
#   Prints path to generated report file
#
# Report Sections:
#   - Header with system info and file paths
#   - Spotlight indexing status comparison
#   - Power management settings comparison
#   - Top 5 CPU processes comparison
#   - Thermal/fan data comparison
#   - Summary with interpretation notes
###############################################################################
report_make_easy() {
  local before_file="$1"
  local after_file="$2"
  local stamp="$3"
  local out="$REPORT_DIR/report_${stamp}.txt"

  # --- Helper function: Extract first matching line from file ---
  # Used to pull specific values from snapshot files
  pluck() { local pat="$1"; local file="$2"; grep -m 1 -E "$pat" "$file" 2>/dev/null || true; }

  # --- Helper function: Extract top 5 CPU processes ---
  # Parses the "## Load" section of snapshot files
  # Uses awk to find numeric lines (process data) after the Load header
  top5() {
    awk '
      /^## Load/ {insec=1; next}
      insec && /^[0-9]/ {print; c++}
      insec && c>=5 {exit}
    ' "$1" 2>/dev/null || true
  }

  # --- Helper function: Extract fan data ---
  # Searches for lines containing fan speed or RPM info
  fans() { egrep -i "Fan|RPM" "$1" 2>/dev/null | head -n 12 || true; }

  # --- Helper function: Extract temperature data ---
  # Searches for lines containing temperature readings
  temps(){ egrep -i "temp|temperature|die|cpu" "$1" 2>/dev/null | head -n 12 || true; }

  # Generate the report content
  {
    # === REPORT HEADER ===
    echo "$APP_NAME — BEFORE vs AFTER"
    echo "Generated: $(date)"
    echo
    echo "System: OS $OS_VERSION ($OS_BUILD) • $ARCH • $CPU_BRAND"
    echo
    echo "BEFORE: $before_file"
    echo "AFTER : $after_file"
    echo

    # === SPOTLIGHT COMPARISON ===
    # Shows whether indexing was disabled
    echo "------------------------------------------"
    echo "🔍 Spotlight"
    echo "------------------------------------------"
    echo "Before: $(pluck 'Indexing' "$before_file" | tr -s ' ')"
    echo "After : $(pluck 'Indexing' "$after_file"  | tr -s ' ')"
    echo

    # === POWER MANAGEMENT COMPARISON ===
    # Key pmset values that affect battery and background activity
    echo "------------------------------------------"
    echo "⚡ pmset (Power Nap / TCP keepalive / Low Power)"
    echo "------------------------------------------"
    echo "Before:"
    grep -E "powernap|tcpkeepalive|lowpowermode" "$before_file" 2>/dev/null || true
    echo
    echo "After:"
    grep -E "powernap|tcpkeepalive|lowpowermode" "$after_file" 2>/dev/null || true
    echo

    # === TOP CPU PROCESSES COMPARISON ===
    # Shows top 5 CPU consumers before and after
    echo "------------------------------------------"
    echo "📈 Top CPU processes (Top 5)"
    echo "------------------------------------------"
    echo "Before:"
    top5 "$before_file"
    echo
    echo "After:"
    top5 "$after_file"
    echo

    # === THERMAL/FAN DATA COMPARISON ===
    # Fan speeds and temperatures (may be empty if powermetrics unavailable)
    echo "------------------------------------------"
    echo "🧊 Thermals / Fans (best-effort extract)"
    echo "------------------------------------------"
    echo "Before (fans):"
    fans "$before_file"
    echo
    echo "After (fans):"
    fans "$after_file"
    echo
    echo "Before (temps):"
    temps "$before_file"
    echo
    echo "After (temps):"
    temps "$after_file"
    echo

    # === INTERPRETATION SUMMARY ===
    # Help users understand what the report shows
    echo "------------------------------------------"
    echo "✅ Summary"
    echo "------------------------------------------"
    echo "- 'Indexing disabled' after APPLY profiles is expected (reduces background CPU/disk churn)."
    echo "- Fans may spike briefly after applying (metadata teardown), then settle lower at idle."
    echo "- If powermetrics is restricted on your macOS build, thermal lines may be missing."
    echo
    echo "Log file: $LOG_FILE"
  } > "$out"

  # Return path to generated report
  echo "$out"
}
