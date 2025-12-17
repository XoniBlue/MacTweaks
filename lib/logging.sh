# MacTweaks/lib/logging.sh
# Logging functions for info, warn, ok, err, etc.

log() { printf "%s %s\n" "$(date '+%H:%M:%S')" "$*" | tee -a "$LOG_FILE" >/dev/null; }
info() { log "ℹ️  $*"; }
warn() { log "⚠️  $*"; }
ok() { log "✅ $*"; }
err() { log "❌ $*"; }

die() { err "$*"; exit 1; }
