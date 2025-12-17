# MacTweaks/lib/utils.sh
# General utility functions.

run_cmd_limited() {
  # run_cmd_limited <max_lines> <command...>
  local max_lines="$1"
  shift
  "$@" | head -n "$max_lines"
}

confirm() {
  local prompt="$1"
  read -r -p "$prompt [y/N]: " ans
  [[ "${ans:-}" =~ ^[Yy]$ ]]
}

restart_ui() {
  info "Restarting Finder & Dock…"
  killall Finder 2>/dev/null || true
  killall Dock 2>/dev/null || true
}

pmset_set() {
  local scope="$1"; local key="$2"; local value="$3"
  sudo pmset -a "$key" "$value" 2>/dev/null || sudo pmset "$scope" "$key" "$value" 2>/dev/null || true
}

defaults_del() {
  local domain="$1"; local key="$2"
  defaults delete "$domain" "$key" 2>/dev/null || true
}

launchctl_disable_safe() {
  local target="$1"
  sudo launchctl disable "$target" 2>/dev/null || true
}

launchctl_enable_safe() {
  local target="$1"
  sudo launchctl enable "$target" 2>/dev/null || true
}

NOW_STAMP() { date '+%Y-%m-%d_%H-%M-%S'; }

list_modules() {
  echo "Available modules:"
  for m in "${MODULES[@]}"; do echo "  - $m"; done
}

apply_module() {
  local m="$1"
  "m_${m}_apply"
}

revert_module() {
  local m="$1"
  "m_${m}_revert"
}
