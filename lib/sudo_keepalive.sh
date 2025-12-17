# MacTweaks/lib/sudo_keepalive.sh
# Sudo keepalive management.

SUDO_KEEPALIVE_PID=""
need_sudo_keepalive() {
  info "Administrator privileges required."
  echo "👉 You may be prompted for your password."
  sudo -v || die "sudo access required."

  # Keep sudo alive with heartbeat
  (
    while true; do
      sudo -n true || exit
      sleep 45
      echo "… sudo keepalive active"
    done
  ) &
  SUDO_KEEPALIVE_PID=$!
  trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true' EXIT
}
