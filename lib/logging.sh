###############################################################################
# MacTweaks/lib/logging.sh
# Logging functions for consistent message formatting and file logging.
#
# DESCRIPTION:
#   Provides standardized logging functions with timestamps and emoji prefixes.
#   All messages are written to both stdout (suppressed) and the log file.
#
# FUNCTIONS:
#   log  <message>  - Base logging function with timestamp
#   info <message>  - Informational message (ℹ️)
#   warn <message>  - Warning message (⚠️)
#   ok   <message>  - Success message (✅)
#   err  <message>  - Error message (❌)
#   die  <message>  - Fatal error - logs message and exits with code 1
#
# DEPENDENCIES:
#   Requires LOG_FILE variable from config.sh
###############################################################################

###############################################################################
# log() - Base logging function
# Writes timestamped message to the log file.
# All other logging functions call this.
#
# Arguments:
#   $* - Message text to log
#
# Output:
#   Appends to LOG_FILE with HH:MM:SS timestamp prefix
###############################################################################
log() { printf "%s %s\n" "$(date '+%H:%M:%S')" "$*" | tee -a "$LOG_FILE"; }

###############################################################################
# info() - Log an informational message
# Use for general status updates and progress information.
###############################################################################
info() { log "ℹ️  $*"; }

###############################################################################
# warn() - Log a warning message
# Use for non-fatal issues that the user should be aware of.
###############################################################################
warn() { log "⚠️  $*"; }

###############################################################################
# ok() - Log a success message
# Use to confirm successful completion of operations.
###############################################################################
ok() { log "✅ $*"; }

###############################################################################
# err() - Log an error message
# Use for error conditions (does not exit - use die() for fatal errors).
###############################################################################
err() { log "❌ $*"; }

###############################################################################
# die() - Log a fatal error and exit
# Use when an unrecoverable error occurs and the script must terminate.
#
# Arguments:
#   $* - Error message to log
#
# Exit Code:
#   Always exits with code 1
###############################################################################
die() { err "$*"; exit 1; }
