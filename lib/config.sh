###############################################################################
# MacTweaks/lib/config.sh
# Global constants and directory setup for the MacTweaks toolkit.
#
# DESCRIPTION:
#   Defines all global constants, version information, and directory paths
#   used throughout the toolkit. Also ensures required directories exist.
#
# GLOBALS DEFINED:
#   VERSION      - Toolkit version number
#   APP_NAME     - Human-readable application name
#   APP_ID       - Bundle identifier for LaunchAgent
#   APP_DIR      - Root application data directory
#   STATE_DIR    - Directory for state/snapshot files
#   REPORT_DIR   - Directory for generated reports
#   LOG_DIR      - Directory for log files
#   POST_SCRIPT  - Path to post-reboot script
#   LA_PLIST     - Path to LaunchAgent plist file
#   LOG_FILE     - Path to current day's log file
#
# NOTE: This file must be sourced before any other library files.
###############################################################################

# Application metadata
VERSION="2.0.0"
APP_NAME="Sequoia Performance Toolkit"
APP_ID="com.mactweaks.postreboot"  # Used for LaunchAgent identification

###############################################################################
# DIRECTORY STRUCTURE
# All toolkit data is stored under ~/Library/Application Support/MacTweaks/
#
# MacTweaks/
# ├── state/      - Before/after snapshot files
# ├── reports/    - Generated comparison reports
# ├── logs/       - Daily log files
# ├── backups/    - Preference backups (created by backup module)
# └── post_reboot.sh - One-time post-reboot script
###############################################################################
APP_DIR="$HOME/Library/Application Support/MacTweaks"
STATE_DIR="$APP_DIR/state"       # Stores snapshot files (before_*.txt, after_*.txt)
REPORT_DIR="$APP_DIR/reports"    # Stores comparison reports (report_*.txt)
LOG_DIR="$APP_DIR/logs"          # Stores daily log files
POST_SCRIPT="$APP_DIR/post_reboot.sh"  # Post-reboot script for one-time execution
LA_PLIST="$HOME/Library/LaunchAgents/$APP_ID.plist"  # LaunchAgent for post-reboot

# Ensure all required directories exist
# Uses -p flag to create parent directories if needed and suppress errors if exists
mkdir -p "$STATE_DIR" "$REPORT_DIR" "$LOG_DIR"

# Log file rotates daily - one file per day with date in filename
LOG_FILE="$LOG_DIR/toolkit_$(date '+%Y-%m-%d').log"
