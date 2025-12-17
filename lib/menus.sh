# lib/menus.sh
# Interactive menu functions — fully updated with new features

menu_main() {
  while true; do
    clear
    echo "$APP_NAME v$VERSION"
    echo "OS: $OS_VERSION ($OS_BUILD) • Arch: $ARCH"
    echo "CPU: $CPU_BRAND"
    echo
    echo "1) Apply profile (max / balanced / battery)"
    echo "2) Revert profile (max / balanced / battery / all)"
    echo "3) Run a single module (apply/revert)"
    echo "4) Generate report now (no changes)"
    echo "5) List modules"
    echo "6) Export latest report to Desktop"
    echo "7) Dry-run a profile (simulate only)"
    echo "8) Help"
    echo "9) Uninstall toolkit state/agent"
    echo "10) Quit"
    echo
    read -r -p "Select [1-10]: " sel
    case "$sel" in
      1) menu_apply_profile ;;
      2) menu_revert_profile ;;
      3) menu_module ;;
      4) menu_report_now ;;
      5) list_modules; echo; read -r -p "Press ENTER…" _ ;;
      6) menu_export_report ;;
      7) menu_dryrun ;;
      8) help_screen ;;
      9) uninstall_toolkit; read -r -p "Press ENTER…" _ ;;
      10) echo "Goodbye!"; exit 0 ;;
      *) echo "Invalid selection."; sleep 1 ;;
    esac
  done
}

menu_apply_profile() {
  echo
  echo "Apply which profile?"
  echo "  1) max      (aggressive, fastest — includes Apple Intelligence disable)"
  echo "  2) balanced (recommended daily)"
  echo "  3) battery  (keep features, reduce wakeups/UI cost)"
  echo
  read -r -p "Select [1-3]: " p
  local profile=""
  case "$p" in
    1) profile="max" ;;
    2) profile="balanced" ;;
    3) profile="battery" ;;
    *) echo "Invalid."; sleep 1; return ;;
  esac

  if ! confirm "Proceed to APPLY profile '$profile'?"; then return; fi

  local stamp="$(NOW_STAMP)"
  info "Capturing BEFORE snapshot…"
  local before_path
  before_path="$(snapshot_collect before "$stamp")"
  ok "BEFORE saved: $before_path"

  postreboot_install_once "$stamp" "$before_path"

  apply_profile "$profile"

  warn "Restart recommended/required for full effect."
  if confirm "Auto-reboot now with countdown?"; then reboot_countdown 20; fi
}

menu_revert_profile() {
  echo
  echo "Revert which profile?"
  echo "  1) max"
  echo "  2) balanced"
  echo "  3) battery"
  echo "  4) all (full revert of everything this toolkit can change)"
  echo
  read -r -p "Select [1-4]: " p
  local profile=""
  case "$p" in
    1) profile="max" ;;
    2) profile="balanced" ;;
    3) profile="battery" ;;
    4) profile="all" ;;
    *) echo "Invalid."; sleep 1; return ;;
  esac

  if ! confirm "Proceed to REVERT '$profile'?"; then return; fi

  local stamp="$(NOW_STAMP)"
  info "Capturing BEFORE snapshot…"
  local before_path
  before_path="$(snapshot_collect before "$stamp")"
  ok "BEFORE saved: $before_path"

  postreboot_install_once "$stamp" "$before_path"

  revert_profile "$profile"

  warn "Restart recommended/required for full effect."
  if confirm "Auto-reboot now with countdown?"; then reboot_countdown 20; fi
}

menu_module() {
  echo
  list_modules
  echo
  read -r -p "Enter module name: " mod
  [[ -n "${mod:-}" ]] || return

  echo "Action:"
  echo "  1) apply"
  echo "  2) revert"
  read -r -p "Select [1-2]: " a
  local action=""
  case "$a" in
    1) action="apply" ;;
    2) action="revert" ;;
    *) echo "Invalid."; sleep 1; return ;;
  esac

  if ! confirm "Proceed to $action module '$mod'?"; then return; fi

  local stamp="$(NOW_STAMP)"
  info "Capturing BEFORE snapshot…"
  local before_path
  before_path="$(snapshot_collect before "$stamp")"
  ok "BEFORE saved: $before_path"

  postreboot_install_once "$stamp" "$before_path"

  if [[ "$action" == "apply" ]]; then
    apply_module "$mod"
  else
    revert_module "$mod"
  fi

  restart_ui

  warn "Restart recommended/required for full effect."
  if confirm "Auto-reboot now with countdown?"; then reboot_countdown 20; fi
}

menu_report_now() {
  local stamp="$(NOW_STAMP)"
  info "Collecting BEFORE snapshot…"
  local before_path
  before_path="$(snapshot_collect before "$stamp")"
  info "Collecting AFTER snapshot…"
  local after_path
  after_path="$(snapshot_collect after "$stamp")"
  local report_path
  report_path="$(report_make_easy "$before_path" "$after_path" "$stamp")"
  ok "Report generated: $report_path"
  open -a Terminal "$report_path" 2>/dev/null || open "$report_path" 2>/dev/null || true
  read -r -p "Press ENTER…" _ || true
}

menu_export_report() {
  echo
  info "Exporting latest report to Desktop…"
  apply_module exportreport
  read -r -p "Press ENTER to continue…" _ || true
}

menu_dryrun() {
  echo
  echo "Dry-run which profile? (no changes will be made)"
  echo "  1) max"
  echo "  2) balanced"
  echo "  3) battery"
  echo
  read -r -p "Select [1-3]: " p
  local real_profile=""
  case "$p" in
    1) real_profile="max" ;;
    2) real_profile="balanced" ;;
    3) real_profile="battery" ;;
    *) echo "Invalid."; sleep 1; return ;;
  esac

  info "Simulating application of '$real_profile' profile…"
  apply_profile dryrun "$real_profile"
  read -r -p "Press ENTER to continue…" _ || true
}
