### 1. Updated README.md (with your requested Intel Mac struggle section)

```markdown
# Sequoia Performance Toolkit

[![macOS](https://img.shields.io/badge/macOS-Sequoia%2015.x-blue)](https://www.apple.com/macos/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/Version-2.1.0-brightgreen)](.)

A **powerful, modular, and safe** optimization toolkit for **macOS Sequoia (15.x)** — created specifically to help older Intel Macs breathe again.

### Why This Toolkit Exists

macOS Sequoia (15.x) introduced beautiful new features — but also heavy background processes like Apple Intelligence, enhanced Spotlight indexing, Live Activities, and more aggressive power management. On **older Intel Macs** (like the 2019 13" MacBook Pro with Core i5 and 8 GB RAM), this often results in:

- High idle CPU usage and fan spin-up
- Noticeable UI lag and slow window resizing
- Reduced battery life
- Thermal throttling during light tasks
- Slower overall responsiveness compared to Ventura or Sonoma

Downgrading is one solution — but many users (including the author) want to stay on Sequoia for security updates and new app compatibility.

**This toolkit is the answer**: a carefully curated set of safe, reversible tweaks that disable the most resource-intensive background features while keeping the system stable and usable.

Tested extensively on a 2019 Intel Core i5 MacBook Pro with 8 GB RAM — delivering cooler temperatures, lower CPU usage, snappier UI, and longer battery life without sacrificing core functionality.

Safe on Apple Silicon too (though gains are smaller).

## Features

- **Three curated profiles**: `max` (aggressive), `balanced` (daily driver), `battery` (power saving)
- **20+ optimization modules** (see full list in [MODULES.md](MODULES.md))
- **Automatic before/after snapshots** with CPU, memory, I/O, and thermal data
- **One-shot post-reboot report** — runs automatically once after restart
- **Dry-run mode** — simulate changes safely
- **Preference backups** before major changes
- **Export reports to Desktop**
- **Full revert capability** (including "revert all")
- **Idempotent & guarded** — safe to re-run
- **Detailed logging**

## Installation

```bash
git clone https://github.com/yourusername/sequoia-perf-toolkit.git
cd sequoia-perf-toolkit/bin
chmod +x sequoia-perf-toolkit.sh
./sequoia-perf-toolkit.sh
```

Enter your password when prompted — the toolkit needs admin rights for some changes.

## Usage

- **Recommended**: Launch the interactive menu (default)
- Apply **`max`** profile for the biggest gains on Intel Macs
- Restart after applying → a Terminal window opens once with a clean **before vs after** report
- Use **`balanced`** for daily use without breaking iCloud/Continuity/AirDrop
- Option 4 → instant report (no reboot needed)

### Command Line Examples

```bash
# Apply max profile
./sequoia-perf-toolkit.sh --apply-profile max

# Revert everything
./sequoia-perf-toolkit.sh --revert-profile all

# Generate report now
./sequoia-perf-toolkit.sh --report
```

## Safety & Reverting

All changes are reversible:
- Menu → 2) Revert profile → 4) all
- Or `--revert-profile all`

Uninstall (removes only toolkit files):
- Menu → 9) Uninstall toolkit state/agent

**Note**: Some accessibility settings (Reduce Motion/Transparency) cannot be set via script on Sequoia — set manually in **System Settings → Accessibility → Display**.

## Detailed Module Commands

See [MODULES.md](MODULES.md) for a full breakdown of **exactly what commands** each module runs.

## Folder Structure

```
sequoia-perf-toolkit/
├── bin/sequoia-perf-toolkit.sh     ← Main launcher
├── lib/                            ← Core functions
├── modules/                        ← Individual tweaks
├── README.md                       ← This file
└── MODULES.md                      ← Detailed command reference
```

## Future Plans

- Platypus .app wrapper (double-clickable GUI)
- Custom user profiles
- Menu bar monitor

## License

MIT License — feel free to use, modify, and share.

---

Made with ❤️ for older Intel Macs still fighting the good fight in 2025.
```
