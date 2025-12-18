# MacTweaks Quick Start Guide

Get up and running with MacTweaks in under 60 seconds.

---

## ⚡ 30-Second Install

```bash
# Clone and install
git clone https://github.com/XoniBlue/MacTweaks.git
cd MacTweaks
chmod +x install.sh
./install.sh
```

Follow the interactive prompts or use:
```bash
./install.sh --user    # Current user only (recommended)
./install.sh --system  # System-wide (requires sudo)
```

---

## 🚀 60-Second Optimization

### Option 1: Interactive Menu (Recommended for First-Time Users)

```bash
mactweaks
```

Then:
1. Select **1) Apply profile**
2. Choose **2) balanced** (recommended for daily use)
3. Confirm with `y`
4. Enter password when prompted
5. Allow reboot when prompted

**Done!** You'll see a before/after report after restart.

---

### Option 2: Command Line (For Quick Automation)

```bash
# Most popular choice - balanced profile
mactweaks --apply-profile balanced

# Maximum performance (Intel Macs)
mactweaks --apply-profile max

# Battery conservation (Laptops)
mactweaks --apply-profile battery
```

System will reboot automatically after applying.

---

## 📊 What You Get

### Balanced Profile (Recommended)
- ✅ Faster UI (instant window operations)
- ✅ Better battery life (15-25% improvement)
- ✅ Reduced background activity
- ✅ Keeps AirDrop, Handoff, iCloud
- ✅ No Spotlight search (use Finder or Alfred)

### Max Profile (Intel Macs)
- ✅ Maximum performance (10-30% CPU improvement)
- ✅ Lowest thermals and fan noise
- ✅ Longest battery life
- ❌ Disables Spotlight, Siri, iCloud Desktop sync
- ❌ Requires manual update checks

### Battery Profile (Laptops)
- ✅ Focus on power conservation
- ✅ Keeps all features intact
- ✅ Minimal trade-offs
- ✅ 20-30% better battery life

---

## ❓ Common Questions

### "Is it safe?"
Yes. All changes are:
- User preferences only (no system files modified)
- Fully reversible
- Automatically backed up
- Logged for transparency

### "Can I undo it?"
Absolutely. Run:
```bash
mactweaks --revert-profile all
```

Or use the interactive menu:
```bash
mactweaks
# Select: 2) Revert profile → 4) all
```

### "Will it break anything?"
No, but you'll lose some features:
- **Spotlight search** - Use Finder search or install Alfred/Raycast
- **Some Continuity features** - Depending on profile chosen
- **Auto-updates** - Check manually (max profile only)

### "What if I don't like a specific change?"
Revert individual modules:
```bash
mactweaks --module spotlight --revert
```

---

## 🎯 Quick Scenarios

### "I just want a faster Mac"
```bash
mactweaks --apply-profile balanced
```
Restart when prompted. Done.

### "I need maximum battery life"
```bash
mactweaks --apply-profile battery
```

### "I want everything - maximum performance"
```bash
mactweaks --apply-profile max
```
⚠️ **Warning**: Disables many features. Check [README.md](README.md) first.

### "I want to preview changes first"
```bash
mactweaks
# Select: 7) Dry-run a profile
# Choose your profile to simulate
```

### "I just want to remove animations"
```bash
mactweaks --module ui --apply
```

---

## 🔍 See What Changed

### Generate a report anytime:
```bash
mactweaks --report
```

### After reboot:
A Terminal window opens automatically with the before/after comparison.

### Export report to Desktop:
```bash
mactweaks
# Select: 6) Export latest report to Desktop
```

---

## 🛠️ Troubleshooting

### "Command not found: mactweaks"
You didn't install, just cloned. Either:
```bash
./install.sh              # Install properly
# OR
./bin/mac-tweaks.sh       # Run directly
```

### "How do I check what's currently applied?"
```bash
mactweaks --report
```

### "I want my old settings back"
```bash
mactweaks --revert-profile all
```

### "Spotlight is disabled and I miss it"
```bash
mactweaks --module spotlight --revert
```

---

## 📚 Next Steps

### Learn more about modules:
```bash
mactweaks --list-modules
```

Or read [MODULES.md](MODULES.md) for detailed documentation.

### Customize your own profile:
See [MODULE_DEPENDENCIES.md](MODULE_DEPENDENCIES.md) for recommended combinations.

### Get help:
```bash
mactweaks --help
```

Or read the full [README.md](README.md).

---

## 💡 Pro Tips

### Tip 1: Start Conservative
Begin with `balanced` profile, then customize based on your workflow.

### Tip 2: Use Dry-Run First
Test profiles in simulation mode before applying:
```bash
mactweaks
# Select: 7) Dry-run
```

### Tip 3: One Module at a Time
If unsure, apply modules individually and test:
```bash
mactweaks --module ui --apply
# Test for a day
mactweaks --module spotlight --apply
# Test again
```

### Tip 4: Check Reports Regularly
Generate before/after reports to see actual impact:
```bash
mactweaks --report
```

### Tip 5: Keep Backups
Backups are automatic, but you can create manual ones:
```bash
mactweaks
# Select: 6) Backup preferences
```

---

## 🎉 That's It!

You now know enough to optimize your Mac. For advanced usage, check out:
- [README.md](README.md) - Full documentation
- [MODULES.md](MODULES.md) - Detailed module reference
- [MODULE_DEPENDENCIES.md](MODULE_DEPENDENCIES.md) - Module combinations

---

**Questions?** [Open an issue](https://github.com/XoniBlue/MacTweaks/issues) on GitHub.

**Love MacTweaks?** Give it a ⭐ on [GitHub](https://github.com/XoniBlue/MacTweaks)!
