# MacTweaks/lib/detect.sh
# System detection functions.

IS_MACOS=false
ARCH="$(uname -m || true)"
CPU_BRAND="$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "unknown")"
OS_VERSION="$(sw_vers -productVersion 2>/dev/null || echo "unknown")"
OS_BUILD="$(sw_vers -buildVersion 2>/dev/null || echo "unknown")"

is_intel() { [[ "$ARCH" == "x86_64" ]]; }
is_apple_silicon() { [[ "$ARCH" == "arm64" ]]; }

need_macos() {
  [[ "$(uname)" == "Darwin" ]] || die "This tool only runs on macOS."
  IS_MACOS=true
}
