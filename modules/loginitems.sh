###############################################################################
# MacTweaks/modules/loginitems.sh
# Module: Login Items audit
#
# DESCRIPTION:
#   Lists all applications configured to launch at login. This is an
#   informational module that helps identify startup bloat. It does not
#   make changes - users must manually disable items in System Settings.
#
# WHAT ARE LOGIN ITEMS:
#   - Apps that automatically launch when you log in
#   - Can include helper apps, menu bar utilities, sync agents
#   - Each adds to startup time and ongoing resource usage
#
# USAGE:
#   This module displays the list and logs it. User must manually:
#   1. Open System Settings
#   2. Go to General → Login Items
#   3. Disable unwanted items
#
# PROFILES: max
#
# NOTE: This module is read-only and does not modify any settings.
#       It uses AppleScript to query System Events for login items.
###############################################################################

# Apply: Display current Login Items (informational only)
m_loginitems_apply() {
  info "[loginitems] Listing current Login Items"

  # Use AppleScript to get list of all login items
  # Output is logged and displayed to user
  osascript -e 'tell application "System Events" to get name of every login item' | tee -a "$LOG_FILE"

  # Remind user that changes must be made manually
  warn "Open System Settings → General → Login Items to disable unwanted ones"
}

# Revert: No-op (this module doesn't make changes)
m_loginitems_revert() {
  info "[loginitems] No automatic revert"
  true
}
