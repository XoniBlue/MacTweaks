#!/bin/zsh
#
# uninstall.sh
# Removes the Low Power on Charge module and restores default power state
#

set -euo pipefail

PLIST="$HOME/Library/LaunchAgents/com.mactweaks.lowpower_on_charge.plist"
SCRIPT="$HOME/.mactweaks/lowpower_on_charge.sh"

# Unload launch agent
launchctl unload "$PLIST" 2>/dev/null || true

# Remove files
rm -f "$PLIST"
rm -f "$SCRIPT"

# Explicitly disable Low Power Mode
pmset -a lowpowermode 0 || true

echo "🧹 Low Power on Charge module removed"
echo "⚡ Low Power Mode set to OFF"
