###############################################################################
# MacTweaks/lib/detect.sh
# System detection functions for identifying macOS version and architecture.
#
# DESCRIPTION:
#   Detects and exports system information including architecture, CPU type,
#   and macOS version. Also provides helper functions to check platform.
#
# GLOBALS DEFINED:
#   IS_MACOS    - Boolean flag set to true after need_macos() validation
#   ARCH        - CPU architecture (x86_64 for Intel, arm64 for Apple Silicon)
#   CPU_BRAND   - Full CPU model string (e.g., "Intel Core i7-9750H")
#   OS_VERSION  - macOS version number (e.g., "15.1")
#   OS_BUILD    - macOS build number (e.g., "24B83")
#
# FUNCTIONS:
#   is_intel          - Returns true if running on Intel Mac
#   is_apple_silicon  - Returns true if running on Apple Silicon Mac
#   need_macos        - Validates macOS requirement, exits if not Darwin
###############################################################################

# Flag indicating macOS validation has passed
IS_MACOS=false

# Detect CPU architecture
# x86_64 = Intel Mac, arm64 = Apple Silicon (M1/M2/M3)
ARCH="$(uname -m || true)"

# Get full CPU brand string for display purposes
# Example: "Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz"
CPU_BRAND="$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "unknown")"

# Get macOS version information
# OS_VERSION: e.g., "15.1" for Sequoia
# OS_BUILD: e.g., "24B83" (internal build identifier)
OS_VERSION="$(sw_vers -productVersion 2>/dev/null || echo "unknown")"
OS_BUILD="$(sw_vers -buildVersion 2>/dev/null || echo "unknown")"

###############################################################################
# is_intel() - Check if running on Intel architecture
# Many optimizations have greater impact on Intel Macs.
#
# Returns:
#   0 (true) if architecture is x86_64
#   1 (false) otherwise
###############################################################################
is_intel() { [[ "$ARCH" == "x86_64" ]]; }

###############################################################################
# is_apple_silicon() - Check if running on Apple Silicon
# Some tweaks have reduced impact on Apple Silicon due to hardware differences.
#
# Returns:
#   0 (true) if architecture is arm64
#   1 (false) otherwise
###############################################################################
is_apple_silicon() { [[ "$ARCH" == "arm64" ]]; }

###############################################################################
# need_macos() - Validate macOS requirement
# Ensures the script is running on macOS (Darwin kernel).
# Exits with error if run on Linux or other systems.
#
# Side Effects:
#   Sets IS_MACOS=true on success
#   Calls die() and exits on failure
###############################################################################
need_macos() {
  [[ "$(uname)" == "Darwin" ]] || die "This tool only runs on macOS."
  IS_MACOS=true
}
