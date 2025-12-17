# MacTweaks/lib/config.sh
# Constants and directory setup.

VERSION="2.0.0"
APP_NAME="Sequoia Performance Toolkit"
APP_ID="com.mactweaks.postreboot"

APP_DIR="$HOME/Library/Application Support/MacTweaks"
STATE_DIR="$APP_DIR/state"
REPORT_DIR="$APP_DIR/reports"
LOG_DIR="$APP_DIR/logs"
POST_SCRIPT="$APP_DIR/post_reboot.sh"
LA_PLIST="$HOME/Library/LaunchAgents/$APP_ID.plist"

mkdir -p "$STATE_DIR" "$REPORT_DIR" "$LOG_DIR"

LOG_FILE="$LOG_DIR/toolkit_$(date '+%Y-%m-%d').log"
