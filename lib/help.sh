# lib/help.sh
# Comprehensive help screen with all new features

help_screen() {
cat <<EOF
$APP_NAME v$VERSION

A comprehensive, modular optimization toolkit for macOS Sequoia (15.x)
Optimized for Intel Macs, safe on Apple Silicon.

USAGE:
  ./MacTweaks.sh [command] [options]

INTERACTIVE MENU (default):
  Run without arguments → launches full text-based menu

COMMANDS:
  --interactive                 Launch interactive menu (default)
  --apply-profile <name>        Apply profile: max | balanced | battery
  --revert-profile <name>       Revert profile: max | balanced | battery | all
  --module <name> --apply       Apply single module
  --module <name> --revert      Revert single module
  --list-modules                List all available modules
  --report                      Generate immediate BEFORE/AFTER report
  --uninstall                   Remove toolkit state, logs, and post-reboot agent
  --help                        Show this help

PROFILES:
  max       → Most aggressive: disables Spotlight, Siri, analytics, animations,
              iCloud Desktop/Documents, Apple Intelligence, background wakeups,
              and more. Best for maximum speed & lowest thermals.
  balanced  → Recommended daily driver: core optimizations without breaking
              Continuity, iCloud docs, or AirDrop/Handoff.
  battery   → Preserves features, focuses on UI smoothness, low power mode,
              and background reduction.

NEW FEATURES (v2.1+):
  • Apple Intelligence disable (Writing Tools, Image Playground, etc.)
  • Safe system maintenance (DNS flush, log cleanup, periodic scripts)
  • Login Items listing
  • Low Power Mode toggle
  • Dry-run simulation mode
  • Automatic preference backups
  • Compatibility warnings
  • Report export to Desktop

KEY FEATURES:
  • Idempotent & safe: can be re-run without harm
  • Before/After snapshots with CPU, memory, I/O, and thermal data
  • One-shot post-reboot report: automatically runs once after restart
  • Full revert capability (including "all" option)
  • Detailed logging in ~/Library/Application Support/MacTweaks/logs/

NOTES:
  • Requires administrator privileges (sudo password prompt)
  • Restart strongly recommended after apply/revert for full effect
  • Some visual tweaks (transparency/motion) must be set manually in
    System Settings → Accessibility → Display on Sequoia
  • Safe to uninstall anytime — removes only toolkit files, not changes

REPORTING:
  After applying a profile and restarting, a Terminal window opens once
  showing a clean before/after comparison. Use option 4 for instant reports.

SUPPORT:
  Issues? Check the log file in:
  ~/Library/Application Support/MacTweaks/logs/

EOF
read -r -p "Press ENTER to continue…" _ || true
}
