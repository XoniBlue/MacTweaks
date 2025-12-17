# lib/profiles.sh — Updated with new modules and summary

profile_modules() {
  local profile="$1"
  case "$profile" in
    max)
      echo "spotlight siri analytics ui live text timemachine photos finder icloud visual appnap quicklook pmset airdrop handoff updates shadows appleintelligence maintenance loginitems powermode backup updatecheck exportreport"
      ;;
    balanced)
      echo "spotlight analytics ui text timemachine photos finder visual appnap quicklook pmset shadows appleintelligence maintenance backup updatecheck"
      ;;
    battery)
      echo "ui visual pmset finder quicklook shadows powermode maintenance backup updatecheck"
      ;;
    dryrun)
      echo "dryrun"
      ;;
    stock)
      echo ""
      ;;
    *)
      die "Unknown profile: $profile"
      ;;
  esac
}

apply_profile() {
  local profile="$1"
  info "Applying profile: $profile"
  info "Detected: OS $OS_VERSION ($OS_BUILD) • Arch $ARCH • CPU: $CPU_BRAND"

  local mods
  mods="$(profile_modules "$profile")"

  if [[ "$profile" == "dryrun" ]]; then
    export DRYRUN_PROFILE="$2"  # Pass real profile name if needed
  fi

  if is_apple_silicon; then
    warn "Apple Silicon detected: some changes may have smaller impact."
  else
    info "Intel detected: maximum impact expected."
  fi

  for m in $mods; do
    apply_module "$m"
  done

  restart_ui
  info "Modules applied: $mods"
  ok "Profile '$profile' applied."
}

revert_profile() {
  local profile="$1"
  info "Reverting profile: $profile"
  local mods
  if [[ "$profile" == "all" ]]; then
    mods="${MODULES[*]}"
  else
    mods="$(profile_modules "$profile")"
  fi

  local arr=($mods)
  for (( i=${#arr[@]}-1; i>=0; i-- )); do
    revert_module "${arr[$i]}"
  done

  restart_ui
  ok "Profile '$profile' reverted."
}
