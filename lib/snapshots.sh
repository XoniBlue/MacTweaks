# MacTweaks/lib/snapshots.sh
# Functions for collecting system snapshots.

snapshot_collect() {
  local tag="$1"  # before|after|report
  local stamp="$2"
  local out="$STATE_DIR/${tag}_${stamp}.txt"

  {
    echo "# $APP_NAME snapshot: $tag"
    echo "# Timestamp: $stamp"
    echo "# OS: $OS_VERSION ($OS_BUILD)"
    echo "# Arch: $ARCH"
    echo "# CPU: $CPU_BRAND"
    echo "# User: $USER"
    echo

    echo "## Spotlight"
    mdutil -s / 2>/dev/null || true
    echo

    echo "## pmset (selected keys)"
    pmset -g 2>/dev/null | egrep "powernap|tcpkeepalive|lowpowermode|standby|hibernatemode|ttyskeepawake|displaysleep|sleep" || true
    echo

    echo "## Load / top cpu"
    uptime
    echo
    ps -Ao pcpu,pmem,pid,comm | sort -nr | head -n 15
    echo

    echo "## Memory (vm_stat excerpt)"
    run_cmd_limited 25 vm_stat
    echo

    echo "## Disk I/O (iostat 2 2)"
    run_cmd_limited 50 iostat -c 2 -d 2 2>/dev/null || true
    echo

    echo "## Thermals / Fans (powermetrics, best-effort 8s)"
    echo "(If powermetrics output is restricted on your macOS build, this may be blank.)"
    sudo -v 2>/dev/null || true
    timeout 15 sudo powermetrics --samplers smc --show-all -n 1 -i 8000 2>/dev/null \
      || timeout 15 sudo powermetrics --samplers smc -n 1 -i 8000 2>/dev/null \
      || echo "(powermetrics skipped or unavailable)"

    echo
  } > "$out"

  echo "$out"
}
