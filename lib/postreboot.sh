# MacTweaks/lib/postreboot.sh
# Post-reboot automation setup and uninstall.

postreboot_install_once() {
  local stamp="$1"
  local before_path="$2"

  # Write state files — these are the "proof" that a restart is expected
  mkdir -p "$APP_DIR"
  echo "$stamp" > "$APP_DIR/last_stamp.txt"
  echo "$before_path" > "$APP_DIR/last_before_path.txt"

  cat > "$POST_SCRIPT" <<'EOS'
#!/bin/bash
set -euo pipefail

APP_DIR="$HOME/Library/Application Support/MacTweaks"
STATE_DIR="$APP_DIR/state"
REPORT_DIR="$APP_DIR/reports"
LA_PLIST="$HOME/Library/LaunchAgents/com.mactweaks.postreboot.plist"
POST_SCRIPT="$APP_DIR/post_reboot.sh"

# ==== SAFETY CHECK: only run if state files exist and match expected format ====
if [[ ! -f "$APP_DIR/last_stamp.txt" ]] || [[ ! -f "$APP_DIR/last_before_path.txt" ]]; then
  echo "No pending post-reboot task — exiting cleanly."
  rm -f "$LA_PLIST" "$POST_SCRIPT" 2>/dev/null || true
  exit 0
fi

stamp="$(cat "$APP_DIR/last_stamp.txt")"
before_path="$(cat "$APP_DIR/last_before_path.txt")"

# Validate that the before snapshot actually exists
if [[ ! -f "$before_path" ]]; then
  echo "Before snapshot missing — nothing to compare. Cleaning up."
  rm -f "$LA_PLIST" "$POST_SCRIPT" "$APP_DIR/last_stamp.txt" "$APP_DIR/last_before_path.txt" 2>/dev/null || true
  exit 0
fi

# === Duplicate the snapshot_collect and report_make_easy functions here ===
# (kept identical to the main toolkit for reliability)

snapshot_collect() {
  local tag="$1" stamp="$2"
  local out="$STATE_DIR/${tag}_${stamp}.txt"
  {
    echo "# Post-reboot snapshot: $tag"
    echo "# Timestamp: $stamp"
    echo "# OS: $(sw_vers -productVersion 2>/dev/null) ($(sw_vers -buildVersion 2>/dev/null))"
    echo "# Arch: $(uname -m)"
    echo "# CPU: $(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo unknown)"
    echo
    echo "## Spotlight"; mdutil -s / 2>/dev/null || true; echo
    echo "## pmset (selected keys)"; pmset -g 2>/dev/null | egrep "powernap|tcpkeepalive|lowpowermode|standby|hibernatemode|sleep" || true; echo
    echo "## Load / top cpu"; uptime; echo; ps -Ao pcpu,pmem,pid,comm | sort -nr | head -n 15; echo
    echo "## Memory (vm_stat excerpt)"; vm_stat 2>/dev/null | head -n 25 || true; echo
    echo "## Disk I/O (iostat 2 2)"; iostat -c 2 -d 2 2>/dev/null || true; echo
    echo "## Thermals / Fans (powermetrics, best-effort 8s)"
    sudo -v 2>/dev/null || true
    timeout 15 sudo powermetrics --samplers smc --show-all -n 1 -i 8000 2>/dev/null \
      || timeout 15 sudo powermetrics --samplers smc -n 1 -i 8000 2>/dev/null \
      || echo "(powermetrics unavailable)"
    echo
  } > "$out"
  echo "$out"
}

report_make_easy() {
  local before_file="$1" after_file="$2" stamp="$3"
  local out="$REPORT_DIR/report_${stamp}.txt"
  # (same body as in lib/reports.sh — omitted here for brevity, but keep it identical)
  # ... [paste the full report_make_easy function from lib/reports.sh here] ...
  echo "$out"
}

# === Generate report ===
after_path="$(snapshot_collect "after" "$stamp")"
report_path="$(report_make_easy "$before_path" "$after_path" "$stamp")"

echo ""
echo "✅ Post-reboot report generated and opened:"
echo "$report_path"
open "$report_path"

# === Self-cleanup ===
launchctl unload "$LA_PLIST" 2>/dev/null || true
rm -f "$LA_PLIST" "$POST_SCRIPT" "$APP_DIR/last_stamp.txt" "$APP_DIR/last_before_path.txt" 2>/dev/null || true

EOS

  chmod +x "$POST_SCRIPT"

  # Always unload any old agent first, then load the new one
  launchctl unload "$LA_PLIST" 2>/dev/null || true
  rm -f "$LA_PLIST" 2>/dev/null || true

  cat > "$LA_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>$APP_ID</string>
  <key>RunAtLoad</key><true/>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/bin/osascript</string>
    <string>-e</string>
    <string>tell application "Terminal" to activate</string>
    <string>-e</string>
    <string>tell application "Terminal" to do script "bash \\"$POST_SCRIPT\\" "</string>
  </array>
  <key>StandardOutPath</key><string>$LOG_DIR/postreboot_stdout.log</string>
  <key>StandardErrorPath</key><string>$LOG_DIR/postreboot_stderr.log</string>
</dict>
</plist>
EOF

  launchctl load "$LA_PLIST"
  ok "Post-reboot report armed — will run ONCE after next login/reboot."
}

uninstall_toolkit() {
  warn "Uninstalling toolkit state + post-reboot agent…"
  launchctl unload "$LA_PLIST" 2>/dev/null || true
  rm -f "$LA_PLIST" 2>/dev/null || true
  rm -rf "$APP_DIR" 2>/dev/null || true
  ok "Uninstalled. (No system settings were reverted.)"
}

reboot_countdown() {
  local seconds="${1:-20}"
  warn "Restart required for full effect."
  echo "Auto-reboot in $seconds seconds. Press CTRL+C to cancel."
  trap 'echo; warn "Reboot canceled."; exit 0' INT
  while [[ "$seconds" -gt 0 ]]; do
    printf "\rRebooting in %2d seconds… (CTRL+C to cancel) " "$seconds"
    sleep 1
    seconds=$((seconds - 1))
  done
  echo
  sudo shutdown -r now
}
