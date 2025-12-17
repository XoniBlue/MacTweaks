###############################################################################
# MacTweaks/lib/snapshots.sh
# System state snapshot collection for before/after comparisons.
#
# DESCRIPTION:
#   Collects comprehensive system state information including Spotlight status,
#   power management settings, CPU usage, memory statistics, disk I/O, and
#   thermal/fan data. Used to generate before/after comparison reports.
#
# FUNCTIONS:
#   snapshot_collect - Capture system state to a timestamped file
#
# OUTPUT FILES:
#   Snapshots are saved to: $STATE_DIR/<tag>_<timestamp>.txt
#   Example: ~/Library/Application Support/MacTweaks/state/before_2024-01-15_10-30-00.txt
#
# DEPENDENCIES:
#   - STATE_DIR from config.sh
#   - run_cmd_limited from utils.sh
#   - System detection variables from detect.sh
###############################################################################

###############################################################################
# snapshot_collect() - Capture comprehensive system state
# Gathers various system metrics and saves them to a timestamped file.
# The resulting file is used for before/after comparisons in reports.
#
# Arguments:
#   $1 (tag)   - Snapshot type identifier: "before", "after", or "report"
#   $2 (stamp) - Timestamp string (from NOW_STAMP) for unique filename
#
# Returns:
#   Prints the path to the created snapshot file
#
# Data Collected:
#   - System info header (OS version, architecture, CPU)
#   - Spotlight indexing status
#   - Power management settings (pmset)
#   - System load and top 15 CPU-consuming processes
#   - Memory statistics (vm_stat)
#   - Disk I/O statistics (iostat)
#   - Thermal and fan data (powermetrics, best-effort)
#
# Notes:
#   - powermetrics requires sudo and may be restricted on some macOS builds
#   - Timeout of 15 seconds prevents hangs on thermal data collection
###############################################################################
snapshot_collect() {
  local tag="$1"  # Snapshot type: before, after, or report
  local stamp="$2"  # Timestamp for filename uniqueness
  local out="$STATE_DIR/${tag}_${stamp}.txt"  # Output file path

  # Collect all data into the output file
  {
    # === HEADER SECTION ===
    # Basic system identification for reference
    echo "# $APP_NAME snapshot: $tag"
    echo "# Timestamp: $stamp"
    echo "# OS: $OS_VERSION ($OS_BUILD)"
    echo "# Arch: $ARCH"
    echo "# CPU: $CPU_BRAND"
    echo "# User: $USER"
    echo

    # === SPOTLIGHT STATUS ===
    # Check if Spotlight indexing is enabled/disabled
    # "Indexing disabled" indicates the spotlight module has been applied
    echo "## Spotlight"
    mdutil -s / 2>/dev/null || true
    echo

    # === POWER MANAGEMENT SETTINGS ===
    # Key pmset values that affect battery life and background activity
    # powernap: Allow wake from sleep for background tasks
    # tcpkeepalive: Maintain network connections during sleep
    # lowpowermode: Battery conservation mode
    echo "## pmset (selected keys)"
    pmset -g 2>/dev/null | egrep "powernap|tcpkeepalive|lowpowermode|standby|hibernatemode|ttyskeepawake|displaysleep|sleep" || true
    echo

    # === CPU LOAD AND TOP PROCESSES ===
    # Current system load average and top CPU consumers
    # Useful for identifying resource-heavy processes
    echo "## Load / top cpu"
    uptime
    echo
    # Sort by CPU usage descending, show top 15 processes
    ps -Ao pcpu,pmem,pid,comm | sort -nr | head -n 15
    echo

    # === MEMORY STATISTICS ===
    # Virtual memory statistics from vm_stat
    # Shows page ins/outs, compressions, and memory pressure
    echo "## Memory (vm_stat excerpt)"
    run_cmd_limited 25 vm_stat
    echo

    # === DISK I/O STATISTICS ===
    # Two samples of disk activity to show I/O patterns
    echo "## Disk I/O (iostat 2 2)"
    run_cmd_limited 50 iostat -c 2 -d 2 2>/dev/null || true
    echo

    # === THERMAL AND FAN DATA ===
    # Uses powermetrics to read SMC (System Management Controller) data
    # This includes CPU/GPU temperatures and fan speeds
    # May be restricted or unavailable on some macOS versions
    echo "## Thermals / Fans (powermetrics, best-effort 8s)"
    echo "(If powermetrics output is restricted on your macOS build, this may be blank.)"

    # Refresh sudo timestamp before running powermetrics
    sudo -v 2>/dev/null || true

    # Try powermetrics with different options for compatibility
    # --samplers smc: Read System Management Controller data
    # -n 1: Take 1 sample
    # -i 8000: 8 second sample interval
    # timeout prevents hangs if powermetrics gets stuck
    timeout 15 sudo powermetrics --samplers smc --show-all -n 1 -i 8000 2>/dev/null \
      || timeout 15 sudo powermetrics --samplers smc -n 1 -i 8000 2>/dev/null \
      || echo "(powermetrics skipped or unavailable)"

    echo
  } > "$out"

  # Return the path to the created snapshot file
  echo "$out"
}
