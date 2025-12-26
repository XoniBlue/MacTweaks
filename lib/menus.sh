###############################################################################
# MacTweaks/lib/menus.sh
# Interactive text-based menu system for the MacTweaks toolkit.
#
# DESCRIPTION:
#   Provides a user-friendly interactive menu for applying profiles, managing
#   modules, generating reports, and other toolkit operations. This is the
#   default interface when running the toolkit without arguments.
#
# FUNCTIONS:
#   menu_main          - Main menu loop (10 options)
#   menu_apply_profile - Profile application submenu
#   menu_revert_profile - Profile reversion submenu
#   menu_module        - Individual module management
#   menu_report_now    - Generate immediate report
#   menu_export_report - Export report to Desktop
#   menu_dryrun        - Simulation mode submenu
#
# MENU OPTIONS:
#   1) Apply profile       - Choose and apply max/balanced/battery
#   2) Revert profile      - Restore settings to defaults
#   3) Run single module   - Apply/revert individual modules
#   4) Generate report     - Capture current state comparison
#   5) List modules        - Show all available modules
#   6) Export report       - Copy latest report to Desktop
#   7) Dry-run             - Simulate profile (no changes)
#   8) Help                - Show documentation
#   9) Uninstall           - Remove toolkit files
#   10) Quit               - Exit the program
###############################################################################

###############################################################################
# menu_main() - Main interactive menu loop
# Displays the primary menu and routes to appropriate sub-menus.
# Runs in an infinite loop until user selects Quit (option 10).
###############################################################################
menu_main() {
  while true; do
    # Clear screen and show header with system info
    clear
    echo "$APP_NAME v$VERSION"
    echo "OS: $OS_VERSION ($OS_BUILD) • Arch: $ARCH"
    echo "CPU: $CPU_BRAND"
    echo

    # Display menu options
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

    # Get user selection and route to handler
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

###############################################################################
# menu_apply_profile() - Profile application submenu
# Prompts user to select a profile and applies it.
# Workflow:
#   1. User selects profile (max/balanced/battery)
#   2. Confirms action
#   3. Captures "before" snapshot
#   4. Sets up post-reboot report
#   5. Applies profile
#   6. Offers automatic reboot
###############################################################################
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

  # Confirm before making changes
  if ! confirm "Proceed to APPLY profile '$profile'?"; then return; fi

  # Capture system state before changes
  local stamp="$(NOW_STAMP)"
  info "Capturing BEFORE snapshot…"
  local before_path
  before_path="$(snapshot_collect before "$stamp")"
  ok "BEFORE saved: $before_path"

  # Apply the selected profile
  apply_profile "$profile"

  # Reboot is recommended for full effect
  warn "Restart recommended/required for full effect."
  if confirm "Auto-reboot now with countdown?"; then
    postreboot_install_once "$stamp" "$before_path"
    reboot_countdown 20
  fi
}

###############################################################################
# menu_revert_profile() - Profile reversion submenu
# Prompts user to select a profile to revert to defaults.
# The "all" option reverts every module the toolkit can change.
###############################################################################
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

  # Confirm before making changes
  if ! confirm "Proceed to REVERT '$profile'?"; then return; fi

  # Capture system state before changes
  local stamp="$(NOW_STAMP)"
  info "Capturing BEFORE snapshot…"
  local before_path
  before_path="$(snapshot_collect before "$stamp")"
  ok "BEFORE saved: $before_path"

  # Revert the selected profile
  revert_profile "$profile"

  # Reboot is recommended for full effect
  warn "Restart recommended/required for full effect."
  if confirm "Auto-reboot now with countdown?"; then
    postreboot_install_once "$stamp" "$before_path"
    reboot_countdown 20
  fi
}

###############################################################################
# menu_module() - Individual module management
# Allows applying or reverting a single module by name.
# Useful for fine-grained control over specific settings.
###############################################################################
menu_module() {
  echo

  # Show available modules
  list_modules
  echo

  # Get module name from user
  read -r -p "Enter module name: " mod
  [[ -n "${mod:-}" ]] || return

  # Get action (apply or revert)
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

  # Confirm before making changes
  if ! confirm "Proceed to $action module '$mod'?"; then return; fi

  # Capture system state before changes
  local stamp="$(NOW_STAMP)"
  info "Capturing BEFORE snapshot…"
  local before_path
  before_path="$(snapshot_collect before "$stamp")"
  ok "BEFORE saved: $before_path"

  # Execute the requested action
  if [[ "$action" == "apply" ]]; then
    apply_module "$mod"
  else
    revert_module "$mod"
  fi

  # Restart UI to apply changes
  restart_ui

  # Reboot is recommended for full effect
  warn "Restart recommended/required for full effect."
  if confirm "Auto-reboot now with countdown?"; then
    postreboot_install_once "$stamp" "$before_path"
    reboot_countdown 20
  fi
}

###############################################################################
# menu_report_now() - Generate immediate comparison report
# Captures two snapshots in quick succession and generates a report.
# Useful for checking current system state without making changes.
# Note: "Before" and "After" will be nearly identical since no changes made.
###############################################################################
menu_report_now() {
  local stamp="$(NOW_STAMP)"

  # Capture "before" snapshot
  info "Collecting BEFORE snapshot…"
  local before_path
  before_path="$(snapshot_collect before "$stamp")"

  # Capture "after" snapshot (immediately after)
  info "Collecting AFTER snapshot…"
  local after_path
  after_path="$(snapshot_collect after "$stamp")"

  # Generate comparison report
  local report_path
  report_path="$(report_make_easy "$before_path" "$after_path" "$stamp")"
  ok "Report generated: $report_path"

  # Open report in Terminal or default app
  open -a Terminal "$report_path" 2>/dev/null || open "$report_path" 2>/dev/null || true

  read -r -p "Press ENTER…" _ || true
}

###############################################################################
# menu_export_report() - Export latest report to Desktop
# Copies the most recent report file to the user's Desktop for easy access.
###############################################################################
menu_export_report() {
  echo
  info "Exporting latest report to Desktop…"

  # Use the exportreport module to handle the copy
  apply_module exportreport

  read -r -p "Press ENTER to continue…" _ || true
}

###############################################################################
# menu_dryrun() - Simulation mode submenu
# Simulates profile application without making any changes.
# Shows which modules would be applied and their effects.
###############################################################################
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

  # Run simulation - applies "dryrun" profile with real profile as parameter
  info "Simulating application of '$real_profile' profile…"
  apply_profile dryrun "$real_profile"

  read -r -p "Press ENTER to continue…" _ || true
}
