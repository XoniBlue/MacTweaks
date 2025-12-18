#!/bin/zsh
#
# install.sh
# Installs the Low Power on Charge module
#

set -euo pipefail

MODULE_DIR="$(cd "$(dirname "$0")" && pwd)"

SCRIPT_SRC="$MODULE_DIR/lowpower_on_charge.sh"
SCRIPT_DST="$HOME/.mactweaks/lowpower_on_charge.sh"

PLIST_SRC="$MODULE_DIR/com.mactweaks.lowpower_on_charge.plist"
PLIST_DST="$HOME/Library/LaunchAgents/com.mactweaks.lowpower_on_charge.plist"

# Ensure destination directory exists
mkdir -p "$HOME/.mactweaks"

# Preflight: ensure ~/.mactweaks is writable
if [[ -d "$HOME/.mactweaks" && ! -w "$HOME/.mactweaks" ]]; then
  echo "❌ $HOME/.mactweaks is not writable by user '$USER'."
  echo "   This usually happens if a previous install was run with sudo."
  echo
  echo "👉 Fix it by running:"
  echo "   sudo chown -R $USER:staff $HOME/.mactweaks"
  echo
  exit 1
fi


# Install script
cp "$SCRIPT_SRC" "$SCRIPT_DST"
chmod +x "$SCRIPT_DST"

# Install launch agent with substituted script path
sed "s|__SCRIPT_PATH__|$SCRIPT_DST|g" "$PLIST_SRC" > "$PLIST_DST"

# Reload launch agent safely
launchctl unload "$PLIST_DST" 2>/dev/null || true
launchctl load "$PLIST_DST"

echo "✅ Low Power on Charge module installed"
