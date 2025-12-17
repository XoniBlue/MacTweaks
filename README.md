# MacTweaks

A comprehensive, modular performance optimization toolkit for macOS — designed especially for Intel Macs running macOS Sequoia and later.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [Interactive Mode](#interactive-mode)
  - [Command Line Interface](#command-line-interface)
  - [Profiles](#profiles)
- [Modules](#modules)
- [Safety & Reverting](#safety--reverting)
- [Before & After Reports](#before--after-reports)
- [Folder Structure](#folder-structure)
- [FAQ](#faq)
- [Future Plans](#future-plans)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

**MacTweaks** is a shell-based toolkit that optimizes macOS performance by disabling unnecessary background services, reducing visual overhead, and tuning system preferences. It's particularly effective on **older Intel Macs** where every bit of CPU and memory matters.

All changes are **fully reversible** — no system files are modified, only user preferences, power settings, and background daemons.

### Why MacTweaks?

- **Breathe new life into aging hardware** — Reduce CPU usage by disabling Spotlight indexing, Siri, analytics, and more
- **Faster UI responsiveness** — Eliminate animation delays, reduce transparency, and streamline Finder
- **Extend battery life** — Smart power management tweaks for portable Macs
- **Full transparency** — Every command is documented in [MODULES.md](MODULES.md)
- **Safe & reversible** — One command reverts everything back to stock macOS

---

## Features

- **Curated Profiles** — Pre-configured optimization bundles (`max`, `balanced`, `battery`)
- **Modular Architecture** — Apply or revert individual tweaks independently
- **Interactive Menu** — User-friendly TUI for those who prefer guided setup
- **Before/After Reports** — Automatic comparison reports showing exactly what changed
- **Automatic Backups** — Preferences are backed up before modifications
- **Intel & Apple Silicon Support** — Optimized for both architectures (Intel sees the biggest gains)
- **Post-Reboot Reporting** — A Terminal window opens after reboot with a clean diff report
- **Dry-Run Mode** — Preview changes without applying them

---

## Requirements

| Requirement | Details |
|-------------|---------|
| **macOS Version** | macOS Sequoia (15.x) or later recommended; compatible with earlier versions |
| **Architecture** | Intel (x86_64) or Apple Silicon (arm64) |
| **Privileges** | Administrator access required for system-level tweaks |
| **Shell** | Bash 3.2+ (ships with macOS) |

---

## Installation

Clone the repository and make the script executable:

```bash
git clone https://github.com/XoniBlue/MacTweaks.git
cd MacTweaks/bin
chmod +x mac-tweaks.sh
./mac-tweaks.sh
```

Enter your password when prompted — the toolkit requires admin rights for certain system modifications.

### One-Liner Installation

```bash
git clone https://github.com/XoniBlue/MacTweaks.git && cd MacTweaks/bin && chmod +x mac-tweaks.sh && ./mac-tweaks.sh
```

---

## Usage

### Interactive Mode

Simply run the script without arguments to launch the interactive menu:

```bash
./mac-tweaks.sh
```

The menu provides guided access to all features:

1. **Apply Profile** — Choose from `max`, `balanced`, or `battery`
2. **Revert Profile** — Undo changes from a specific profile or revert all
3. **Apply Individual Module** — Fine-grained control over specific tweaks
4. **Generate Report Now** — Instant before/after comparison (no reboot required)
5. **List Modules** — View all available optimization modules
6. **Backup Preferences** — Manually backup current settings
7. **Run Maintenance** — Flush caches, run periodic scripts, clean logs
8. **Help** — Display usage information
9. **Uninstall** — Remove toolkit state and launch agents

### Command Line Interface

For scripting and automation, use command-line flags:

```bash
# Display help
./mac-tweaks.sh --help

# Apply a profile
./mac-tweaks.sh --apply-profile max
./mac-tweaks.sh --apply-profile balanced
./mac-tweaks.sh --apply-profile battery

# Revert a specific profile
./mac-tweaks.sh --revert-profile max

# Revert ALL changes (restore stock macOS)
./mac-tweaks.sh --revert-profile all

# Apply/revert a single module
./mac-tweaks.sh --module spotlight --apply
./mac-tweaks.sh --module spotlight --revert

# Generate a report immediately
./mac-tweaks.sh --report

# List all available modules
./mac-tweaks.sh --list-modules

# Uninstall toolkit state
./mac-tweaks.sh --uninstall

# Enable debug output
./mac-tweaks.sh --debug --apply-profile max
```

### Profiles

MacTweaks includes pre-configured profiles for different use cases:

| Profile | Description | Best For |
|---------|-------------|----------|
| **`max`** | Maximum performance — disables everything non-essential | Desktop Intel Macs, older MacBooks plugged in |
| **`balanced`** | Performance gains while preserving iCloud, Continuity, and AirDrop | Daily drivers, mixed use |
| **`battery`** | Conservative tweaks focused on power savings | MacBooks on battery power |
| **`dryrun`** | Preview mode — shows what would change without applying | Testing, learning |
| **`stock`** | No modules applied (used internally for reverting) | Baseline reference |

#### Profile Comparison

| Module | max | balanced | battery |
|--------|:---:|:--------:|:-------:|
| Spotlight | ✓ | ✓ | |
| Siri | ✓ | | |
| Analytics | ✓ | ✓ | |
| UI Animations | ✓ | ✓ | ✓ |
| Live Activities | ✓ | | |
| Text Autocorrect | ✓ | ✓ | |
| Time Machine Local | ✓ | ✓ | |
| Photos Analysis | ✓ | ✓ | |
| Finder Tweaks | ✓ | ✓ | ✓ |
| iCloud Save Default | ✓ | | |
| Visual Effects | ✓ | ✓ | ✓ |
| App Nap | ✓ | ✓ | |
| QuickLook Cache | ✓ | ✓ | ✓ |
| Power Nap / TCP | ✓ | ✓ | ✓ |
| AirDrop | ✓ | | |
| Handoff | ✓ | | |
| Auto Updates | ✓ | | |
| Window Shadows | ✓ | ✓ | ✓ |
| Apple Intelligence | ✓ | ✓ | |
| Maintenance | ✓ | ✓ | ✓ |
| Login Items Audit | ✓ | | |
| Low Power Mode | ✓ | | ✓ |

---

## Modules

MacTweaks is built around independent modules, each handling a specific optimization:

| Module | Description |
|--------|-------------|
| `spotlight` | Disables Spotlight indexing and search suggestions |
| `siri` | Disables Siri and related assistant services |
| `analytics` | Disables Apple analytics and diagnostic reporting |
| `ui` | Removes Dock/window animation delays for snappier feel |
| `live` | Disables Live Activities tracking |
| `text` | Disables spell check, autocorrect, and text completion |
| `timemachine` | Disables local Time Machine snapshots |
| `photos` | Disables Photos face/scene analysis daemon |
| `finder` | Optimizes Finder: faster animations, path bar, no .DS_Store on network |
| `icloud` | Prevents new documents from saving to iCloud by default |
| `visual` | Reduces motion and transparency (manual setting on Sequoia) |
| `appnap` | Disables App Nap for consistent app performance |
| `quicklook` | Clears QuickLook thumbnail cache |
| `pmset` | Disables Power Nap and TCP keepalive for battery savings |
| `airdrop` | Disables AirDrop discovery |
| `handoff` | Disables Handoff/Continuity features |
| `updates` | Disables automatic update checks |
| `shadows` | Disables window drop shadows |
| `appleintelligence` | Disables Apple Intelligence features |
| `maintenance` | Runs system maintenance: flush DNS, periodic scripts, log cleanup |
| `loginitems` | Lists current login items for audit |
| `powermode` | Enables Low Power Mode on battery |
| `backup` | Backs up current Finder, Dock, and Global preferences |
| `updatecheck` | Displays informational update messages |
| `exportreport` | Copies the latest report to Desktop |

For the exact commands each module executes, see **[MODULES.md](MODULES.md)**.

---

## Safety & Reverting

**All changes are fully reversible.** MacTweaks only modifies:
- User preference files (`defaults write`)
- Power management settings (`pmset`)
- Launch daemons/agents (`launchctl`)

No system files are touched. No SIP modifications required.

### How to Revert

**Via Interactive Menu:**
1. Run `./mac-tweaks.sh`
2. Select **2) Revert profile**
3. Choose **4) all** to restore stock settings

**Via Command Line:**
```bash
./mac-tweaks.sh --revert-profile all
```

**Revert a specific profile only:**
```bash
./mac-tweaks.sh --revert-profile max
```

### Uninstalling the Toolkit

To remove MacTweaks state files and launch agents (but not revert settings):

```bash
./mac-tweaks.sh --uninstall
```

Or via Menu → **9) Uninstall toolkit state/agent**

---

## Before & After Reports

MacTweaks automatically captures system state before and after applying changes:

1. **Pre-change snapshot** — Captures current settings
2. **Post-reboot comparison** — A Terminal window opens after restart showing a clean diff
3. **Manual reports** — Generate anytime via Menu → **4** or `--report`

Reports include:
- Active Launch Agents/Daemons
- Spotlight indexing status
- Power management settings
- User defaults changes
- Login items

---

## Folder Structure

```
MacTweaks/
├── bin/
│   └── mac-tweaks.sh          # Main entry point
├── lib/
│   ├── config.sh              # Configuration constants
│   ├── detect.sh              # Hardware/OS detection
│   ├── help.sh                # Help screen text
│   ├── logging.sh             # Colored logging utilities
│   ├── menus.sh               # Interactive menu system
│   ├── postreboot.sh          # Post-reboot report handler
│   ├── profiles.sh            # Profile definitions
│   ├── reports.sh             # Report generation
│   ├── snapshots.sh           # System state snapshots
│   ├── sudo_keepalive.sh      # Sudo session management
│   └── utils.sh               # Shared utilities
├── modules/
│   ├── airdrop.sh             # AirDrop toggle
│   ├── analytics.sh           # Analytics toggle
│   ├── appleintelligence.sh   # Apple Intelligence toggle
│   ├── appnap.sh              # App Nap toggle
│   ├── backup.sh              # Preferences backup
│   ├── customprofile.sh       # Custom profile support
│   ├── dryrun.sh              # Dry-run preview
│   ├── exportreport.sh        # Report export
│   ├── finder.sh              # Finder optimizations
│   ├── handoff.sh             # Handoff toggle
│   ├── icloud.sh              # iCloud defaults
│   ├── live.sh                # Live Activities toggle
│   ├── loginitems.sh          # Login items audit
│   ├── maintenance.sh         # System maintenance
│   ├── photos.sh              # Photos daemon toggle
│   ├── pmset.sh               # Power settings
│   ├── powermode.sh           # Low Power Mode
│   ├── quicklook.sh           # QuickLook cache
│   ├── shadows.sh             # Window shadows
│   ├── siri.sh                # Siri toggle
│   ├── spotlight.sh           # Spotlight toggle
│   ├── text.sh                # Text correction toggle
│   ├── timemachine.sh         # Time Machine local
│   ├── ui.sh                  # UI animations
│   ├── updatecheck.sh         # Update info
│   ├── updates.sh             # Auto-updates toggle
│   └── visual.sh              # Visual effects
├── README.md                   # This documentation
└── MODULES.md                  # Detailed command reference
```

---

## FAQ

### Will this break my Mac?

No. All changes are to user-level preferences and can be fully reverted. System Integrity Protection (SIP) remains enabled.

### Does this work on Apple Silicon?

Yes, but the performance impact is smaller. Apple Silicon Macs are already highly optimized. Intel Macs benefit the most.

### Why can't it set Reduce Motion/Transparency on Sequoia?

macOS Sequoia restricts programmatic access to certain accessibility settings. You'll need to enable these manually:
**System Settings → Accessibility → Display → Reduce Motion / Reduce Transparency**

### Can I create custom profiles?

Not yet in the UI, but you can call individual modules via `--module <name> --apply`. Custom profile support is planned.

### How do I know what changed?

Run `./mac-tweaks.sh --report` or use the automatic post-reboot report that appears in Terminal.

### Is my data safe?

MacTweaks doesn't access, read, or modify your personal data. It only changes system preferences and toggles background services.

---

## Future Plans

- **Platypus .app wrapper** — Double-clickable GUI version
- **Custom user profiles** — Save and load your own module combinations
- **Menu bar monitor** — Real-time system status widget
- **Homebrew installation** — `brew install mactweaks`
- **Profile import/export** — Share configurations between Macs

---

## Contributing

Contributions are welcome! Feel free to:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please ensure your code follows the existing style and includes appropriate documentation.

---

## License

MIT License — feel free to use, modify, and share.

See [LICENSE](LICENSE) for details.

---

<div align="center">

Made with care for older Intel Macs still fighting the good fight in 2025.

**[Report Bug](https://github.com/XoniBlue/MacTweaks/issues)** · **[Request Feature](https://github.com/XoniBlue/MacTweaks/issues)**

</div>
