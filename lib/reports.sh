# MacTweaks/lib/reports.sh
# Functions for generating reports.

report_make_easy() {
  local before_file="$1"
  local after_file="$2"
  local stamp="$3"
  local out="$REPORT_DIR/report_${stamp}.txt"

  pluck() { local pat="$1"; local file="$2"; grep -m 1 -E "$pat" "$file" 2>/dev/null || true; }

  top5() {
    awk '
      /^## Load/ {insec=1; next}
      insec && /^[0-9]/ {print; c++}
      insec && c>=5 {exit}
    ' "$1" 2>/dev/null || true
  }

  fans() { egrep -i "Fan|RPM" "$1" 2>/dev/null | head -n 12 || true; }
  temps(){ egrep -i "temp|temperature|die|cpu" "$1" 2>/dev/null | head -n 12 || true; }

  {
    echo "$APP_NAME — BEFORE vs AFTER"
    echo "Generated: $(date)"
    echo
    echo "System: OS $OS_VERSION ($OS_BUILD) • $ARCH • $CPU_BRAND"
    echo
    echo "BEFORE: $before_file"
    echo "AFTER : $after_file"
    echo

    echo "------------------------------------------"
    echo "🔍 Spotlight"
    echo "------------------------------------------"
    echo "Before: $(pluck 'Indexing' "$before_file" | tr -s ' ')"
    echo "After : $(pluck 'Indexing' "$after_file"  | tr -s ' ')"
    echo

    echo "------------------------------------------"
    echo "⚡ pmset (Power Nap / TCP keepalive / Low Power)"
    echo "------------------------------------------"
    echo "Before:"
    grep -E "powernap|tcpkeepalive|lowpowermode" "$before_file" 2>/dev/null || true
    echo
    echo "After:"
    grep -E "powernap|tcpkeepalive|lowpowermode" "$after_file" 2>/dev/null || true
    echo

    echo "------------------------------------------"
    echo "📈 Top CPU processes (Top 5)"
    echo "------------------------------------------"
    echo "Before:"
    top5 "$before_file"
    echo
    echo "After:"
    top5 "$after_file"
    echo

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

    echo "------------------------------------------"
    echo "✅ Summary"
    echo "------------------------------------------"
    echo "- 'Indexing disabled' after APPLY profiles is expected (reduces background CPU/disk churn)."
    echo "- Fans may spike briefly after applying (metadata teardown), then settle lower at idle."
    echo "- If powermetrics is restricted on your macOS build, thermal lines may be missing."
    echo
    echo "Log file: $LOG_FILE"
  } > "$out"

  echo "$out"
}
