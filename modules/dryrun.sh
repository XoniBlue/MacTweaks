# modules/dryrun.sh
m_dryrun_apply() {
  info "[dryrun] Simulating profile application (no changes made)"
  local mods="$(profile_modules "$DRYRUN_PROFILE")"
  echo "Would apply modules: $mods"
  echo "Use a real profile to apply changes."
}

m_dryrun_revert() {
  true
}
