
```bash
git clone https://github.com/XoniBlue/MacTweaks.git
cd MacTweaks/bin
chmod +x mac-tweaks.sh
./mac-tweaks.sh
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
./mac-tweaks.sh --apply-profile max

# Revert everything
./mac-tweaks.sh --revert-profile all

# Generate report now
./mac-tweaks.sh --report
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
mac-tweaks/
├── bin/mac-tweaks.sh     ← Main launcher
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
