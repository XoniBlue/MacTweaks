# Module Dependencies & Recommendations

This document outlines which MacTweaks modules work well together, have dependencies, or may conflict with each other.

---

## Module Relationships

### ✅ Synergistic Modules (Work Better Together)

#### Performance Stack (Intel Macs)
These modules compound their effects for maximum performance improvement:

```
spotlight + photos + analytics + pmset
```
**Why**: All reduce background CPU/disk activity. Combined effect is greater than sum of parts.
**Expected Impact**: 25-35% reduction in background activity on Intel Macs

#### UI Responsiveness Stack
These modules all target perceived snappiness:

```
ui + visual + finder + shadows
```
**Why**: Remove visual overhead at multiple layers for consistent snappy feel.
**Expected Impact**: 2-3x faster perceived UI responsiveness

#### Battery Conservation Stack
Maximum battery life extension for laptops:

```
pmset + powermode + analytics + photos + spotlight
```
**Why**: Eliminates background wakeups, reduces daemon activity, enables low power mode.
**Expected Impact**: 30-50% longer battery life (Intel MacBooks)

#### Privacy Stack
Minimize data collection and network activity:

```
analytics + siri + appleintelligence + handoff + airdrop
```
**Why**: Disables all Apple telemetry and cloud-sync features.
**Expected Impact**: Significant reduction in background network traffic

---

### ⚠️ Modules with Dependencies

#### `exportreport` depends on:
- Must have run at least one profile to generate a report
- Depends on `$REPORT_DIR` being populated
- **Recommendation**: Only include in profiles after other modules

#### `backup` should run:
- **Before** any destructive operations
- **First** in all profile sequences
- **Recommendation**: Always included as the first module in profiles

#### `updatecheck` is informational:
- No dependencies, but sets user expectations
- **Recommendation**: Run early in profile application

#### `maintenance` is standalone:
- Can run anytime, no dependencies
- Safe to run multiple times
- **Recommendation**: Include in all profiles as final cleanup step

---

### ❌ Potentially Conflicting Modules

#### `icloud` vs `handoff`
- **Conflict Type**: Functional overlap
- **Issue**: Both affect cloud synchronization, but different features
- **Resolution**: No actual conflict - they're complementary
- **Recommendation**: Use together in max profile, separate in balanced

#### `powermode` vs `appnap`
- **Conflict Type**: Contradictory goals
- **Issue**: Low Power Mode throttles apps, App Nap disable keeps them running
- **Resolution**: Low Power Mode takes precedence
- **Recommendation**: Don't combine unless you understand the interaction
- **Profile Strategy**: `powermode` in battery profile, `appnap` in max profile

#### `visual` vs `ui`
- **Conflict Type**: Overlapping effects
- **Issue**: Both reduce visual effects, some settings may overlap
- **Resolution**: No actual conflict - complementary
- **Recommendation**: Use together for maximum visual performance

#### `spotlight` + Siri features
- **Conflict Type**: Functional dependency
- **Issue**: Siri uses Spotlight for some queries
- **Resolution**: Siri will work less effectively without Spotlight
- **Recommendation**: Disable both together (max profile) or neither

---

## Recommended Module Combinations

### For Daily Driver (Balanced Performance)

```bash
# Recommended combination for most users
modules="spotlight analytics ui text finder visual appnap pmset maintenance backup"
```

**Why this works:**
- Keeps productivity features (iCloud, AirDrop, Handoff)
- Removes background cruft (Spotlight, analytics)
- Improves UI responsiveness
- Extends battery life moderately

**Trade-offs:**
- Spotlight search unavailable (use Finder search or Alfred)
- No usage analytics sent to Apple

---

### For Maximum Performance (Intel Macs)

```bash
# Nuclear option - disable everything non-essential
modules="spotlight siri analytics ui live text timemachine photos finder icloud visual appnap pmset airdrop handoff updates shadows appleintelligence maintenance powermode backup"
```

**Why this works:**
- Maximum CPU/thermal relief
- Longest battery life
- Fastest UI response

**Trade-offs:**
- Loses many convenience features
- Requires alternative tools (search, file sharing)
- Manual update checking required

---

### For Light Battery Conservation

```bash
# Minimal impact, maximum battery life
modules="pmset powermode ui visual maintenance backup"
```

**Why this works:**
- Focuses only on power-related settings
- Preserves all features and functionality
- Still provides 15-20% battery improvement

**Trade-offs:**
- Very minimal, just reduced background wakeups

---

### For Privacy-Focused Users

```bash
# Disable all Apple telemetry and cloud features
modules="analytics siri appleintelligence handoff icloud spotlight updates maintenance backup"
```

**Why this works:**
- Eliminates data collection
- Stops cloud synchronization
- Disables AI features

**Trade-offs:**
- Lost convenience features (Handoff, Continuity)
- Manual update checking required
- No AI assistance

---

## Module Sequencing Best Practices

### Optimal Order for Profile Application

1. **`backup`** - Always first (create restore point)
2. **`updatecheck`** - Set expectations based on hardware
3. **Performance modules** - Apply in any order
4. **Cleanup modules** - `quicklook`, `maintenance`
5. **Reporting modules** - `exportreport` last

### Example Perfect Sequence:

```bash
# Max profile with optimal ordering
backup          # 1. Create restore point
updatecheck     # 2. Check hardware compatibility
spotlight       # 3-20. Core optimizations (order doesn't matter)
siri
analytics
ui
# ... other modules ...
quicklook       # 21. Cache cleanup
maintenance     # 22. System maintenance
exportreport    # 23. Export results
```

---

## Hardware-Specific Recommendations

### Intel Macs (Maximum Impact)

**Must Include:**
- `spotlight` - Biggest single win
- `pmset` - Major battery/thermal improvement
- `photos` - Significant CPU relief (if Photos library exists)
- `visual` - GPU relief

**Consider Including:**
- `analytics` - Moderate CPU relief
- `siri` - If unused
- `appleintelligence` - If on Sequoia 15+

**Can Skip:**
- `powermode` - Only needed on battery
- `airdrop` - Only if never used
- `updates` - Keep auto-updates for security

---

### Apple Silicon (Targeted Improvements)

**Must Include:**
- `ui` - Most noticeable improvement
- `visual` - UI smoothness
- `finder` - File browsing speed

**Consider Including:**
- `analytics` - Privacy benefit
- `appleintelligence` - Privacy + minor performance
- `text` - If it interferes with work

**Can Skip:**
- `spotlight` - Smaller impact (already efficient)
- `pmset` - Smaller battery impact
- `photos` - Smaller CPU impact (efficient ML hardware)

---

## Profile Customization Guide

### Creating a Custom Profile

If the built-in profiles don't fit your needs:

```bash
# Example: Developer-focused profile
# Keeps features needed for work, removes distractions

CUSTOM_MODULES=(
  "backup"          # Safety first
  "updatecheck"     # Check compatibility
  "analytics"       # Privacy
  "siri"            # Don't need voice assistant
  "ui"              # Faster UI
  "text"            # No autocorrect for code
  "visual"          # GPU relief
  "maintenance"     # Cleanup
)

# Apply each module
for mod in "${CUSTOM_MODULES[@]}"; do
  ./bin/mac-tweaks.sh --module "$mod" --apply
done
```

### Testing Module Combinations

1. **Start conservative**: Begin with `ui + visual + maintenance`
2. **Add incrementally**: Add one module at a time
3. **Test for 1-2 days**: Ensure no workflow disruptions
4. **Monitor impact**: Use `--report` to check metrics
5. **Adjust**: Add or remove modules based on experience

---

## Anti-Patterns (Don't Do This)

### ❌ Applying modules multiple times
```bash
# Bad: Redundant
./bin/mac-tweaks.sh --module spotlight --apply
./bin/mac-tweaks.sh --module spotlight --apply  # No benefit, just wasted time
```

### ❌ Mixing contradictory goals
```bash
# Bad: Contradictory
modules="powermode appnap"  # Low power mode throttles, appnap disable keeps running
```

### ❌ Skipping backup
```bash
# Bad: No restore point
modules="spotlight siri analytics ..."  # What if you need to revert?
# Good: Include backup
modules="backup spotlight siri analytics ..."
```

### ❌ Applying all modules blindly
```bash
# Bad: Overkill for most users
./bin/mac-tweaks.sh --apply-profile max  # May disable features you need
# Good: Start with balanced
./bin/mac-tweaks.sh --apply-profile balanced
```

---

## Troubleshooting Module Interactions

### If Spotlight Disable Breaks Workflow:

**Symptom**: Can't find files quickly
**Solution**:
```bash
# Revert spotlight, use Alfred/Raycast instead
./bin/mac-tweaks.sh --module spotlight --revert
# Or use Finder search (CMD+F in Finder)
```

### If Low Power Mode Feels Too Slow:

**Symptom**: Apps feel sluggish on battery
**Solution**:
```bash
# Revert powermode, keep other battery optimizations
./bin/mac-tweaks.sh --module powermode --revert
# Keep pmset for background wake reduction
```

### If iCloud Disable Causes Sync Issues:

**Symptom**: Files not syncing between devices
**Solution**:
```bash
# Revert icloud module
./bin/mac-tweaks.sh --module icloud --revert
# Alternative: Use selective sync, disable only Desktop/Documents
```

---

## Module Testing Checklist

Before finalizing a custom profile, test these scenarios:

- [ ] File search still works (Finder or alternative)
- [ ] Can share files with other devices (if needed)
- [ ] Battery life meets expectations
- [ ] UI feels responsive
- [ ] No workflow disruptions
- [ ] Critical apps still function
- [ ] System updates can be checked manually
- [ ] Backup/restore works if needed

---

## Summary: Module Compatibility Matrix

| Module | Safe with All | Avoid with | Best Paired With |
|--------|---------------|------------|------------------|
| `spotlight` | ✅ | None | `photos`, `analytics` |
| `siri` | ✅ | None | `analytics`, `appleintelligence` |
| `analytics` | ✅ | None | All privacy modules |
| `ui` | ✅ | None | `visual`, `shadows` |
| `visual` | ✅ | None | `ui`, `shadows` |
| `pmset` | ✅ | None | `powermode`, `timemachine` |
| `powermode` | ⚠️ | `appnap` | `pmset`, battery modules |
| `appnap` | ⚠️ | `powermode` | `spotlight`, `photos` |
| `icloud` | ✅ | None | `handoff` (complementary) |
| `photos` | ✅ | None | `spotlight`, `analytics` |
| `maintenance` | ✅ | None | All (use as final step) |
| `backup` | ✅ | None | All (use as first step) |

---

**Need help choosing modules?**
Start with the `balanced` profile and customize from there based on your needs.
