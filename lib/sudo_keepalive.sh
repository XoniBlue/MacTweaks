###############################################################################
# MacTweaks/lib/sudo_keepalive.sh
# Sudo session keepalive management.
#
# DESCRIPTION:
#   Manages sudo authentication to prevent repeated password prompts during
#   long-running operations. Starts a background process that periodically
#   refreshes the sudo timestamp, keeping the session active.
#
# GLOBALS DEFINED:
#   SUDO_KEEPALIVE_PID - PID of the background keepalive process
#
# FUNCTIONS:
#   need_sudo_keepalive - Initialize and maintain sudo session
#
# BACKGROUND PROCESS:
#   The keepalive runs in a subshell and:
#   - Executes 'sudo -n true' every 45 seconds
#   - Exits automatically if sudo auth expires
#   - Is killed automatically on script exit via trap
###############################################################################

# PID of the background keepalive process (for cleanup)
SUDO_KEEPALIVE_PID=""

###############################################################################
# need_sudo_keepalive() - Initialize and maintain sudo session
# Prompts for sudo password if needed, then starts a background process
# to keep the sudo timestamp fresh throughout the script's execution.
#
# The background process:
#   - Runs in a subshell to avoid blocking
#   - Refreshes sudo every 45 seconds (default timeout is 5 minutes)
#   - Automatically exits if sudo credentials expire
#   - Is cleaned up via EXIT trap when main script terminates
#
# Side Effects:
#   - Prompts user for password if sudo not cached
#   - Spawns background process
#   - Sets EXIT trap to kill background process
#
# Exit Conditions:
#   Calls die() if user cannot authenticate with sudo
###############################################################################
need_sudo_keepalive() {
  info "Administrator privileges required."
  echo "👉 You may be prompted for your password."

  # Initial sudo authentication - prompts for password if not cached
  sudo -v || die "sudo access required."

  # Start background keepalive process
  # This runs in a subshell and periodically touches the sudo timestamp
  (
    while true; do
      # -n flag means non-interactive (don't prompt for password)
      # If this fails, credentials have expired - exit the loop
      sudo -n true || exit
      sleep 45  # Refresh interval (sudo default timeout is 5 minutes)
      echo "… sudo keepalive active"  # Visual feedback in logs
    done
  ) &

  # Save PID for cleanup
  SUDO_KEEPALIVE_PID=$!

  # Ensure background process is killed when script exits
  # This prevents orphaned processes if script is interrupted
  trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true' EXIT
}
