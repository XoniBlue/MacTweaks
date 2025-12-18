#!/bin/zsh
#
# lowpower_on_charge.sh
#
# Enables Low Power Mode when charging
# Disables it when battery reaches 100%
#

set -euo pipefail

# Get battery percentage
BATTERY_PERCENT=$(
  pmset -g batt | grep -o "[0-9]\+%" | tr -d '%'
)

# Detect AC power
if pmset -g batt | grep -q "AC Power"; then
  ON_AC=1
else
  ON_AC=0
fi

# Function to safely run pmset with elevation
run_pmset() {
  if [[ "$EUID" -ne 0 ]]; then
    sudo -n pmset -a lowpowermode "$1" 2>/dev/null || true
  else
    pmset -a lowpowermode "$1"
  fi
}

# Enable Low Power while charging and not full
if [[ "$ON_AC" -eq 1 && "$BATTERY_PERCENT" -lt 100 ]]; then
  run_pmset 1
fi

# Disable Low Power when full
if [[ "$BATTERY_PERCENT" -eq 100 ]]; then
  run_pmset 0
fi
