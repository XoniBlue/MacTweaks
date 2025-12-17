# MacTweaks Module Reference

This document provides a comprehensive reference for all modules in the MacTweaks toolkit. Each module is designed to optimize specific aspects of macOS performance, privacy, or user experience.

> **Transparency Principle**: Every command executed by this toolkit is documented below. No hidden actions, no system file modifications—just user preferences, power settings, and daemon management.

---

## Table of Contents

- [Performance Modules](#performance-modules)
  - [spotlight](#spotlight---search-indexing--suggestions)
  - [ui](#ui---animations--dock-responsiveness)
  - [finder](#finder---file-browser-optimizations)
  - [quicklook](#quicklook---preview-cache-management)
  - [appnap](#appnap---background-app-throttling)
  - [shadows](#shadows---window-shadow-effects)
  - [visual](#visual---accessibility-visual-effects)
- [Privacy & Telemetry Modules](#privacy--telemetry-modules)
  - [analytics](#analytics---diagnostics--crash-reporting)
  - [siri](#siri---voice-assistant--daemons)
  - [appleintelligence](#appleintelligence---ai-features-macos-15)
  - [live](#live---live-activities-tracking)
- [Cloud & Sync Modules](#cloud--sync-modules)
  - [icloud](#icloud---desktop--documents-sync)
  - [photos](#photos---background-photo-analysis)
  - [handoff](#handoff---continuity-features)
  - [airdrop](#airdrop---wireless-file-sharing)
- [Power Management Modules](#power-management-modules)
  - [pmset](#pmset---background-wake-events)
  - [powermode](#powermode---low-power-mode)
  - [timemachine](#timemachine---local-snapshots)
- [Input & Text Modules](#input--text-modules)
  - [text](#text---autocorrection--spell-check)
- [System Updates Module](#system-updates-module)
  - [updates](#updates---automatic-update-checks)
- [Utility Modules](#utility-modules)
  - [backup](#backup---preference-backup)
  - [loginitems](#loginitems---startup-application-audit)
  - [updatecheck](#updatecheck---compatibility-detection)
  - [exportreport](#exportreport---report-export)
- [Module Categories by Impact](#module-categories-by-impact)
- [Compatibility Notes](#compatibility-notes)

---

## Performance Modules

### spotlight — Search Indexing & Suggestions

**Purpose**: Disables Spotlight's background indexing service, which continuously scans your filesystem and can consume significant CPU and disk I/O.

**Impact**: High on Intel Macs; Moderate on Apple Silicon

**What it does**:
- Stops the `mds` (metadata server) from indexing all volumes
- Disables intelligent suggestions in Spotlight search
- Reduces disk activity and CPU usage during idle

| Action | Commands |
|--------|----------|
| **Apply** | `sudo mdutil -a -i off`<br>`sudo mdutil -a -d`<br>`defaults write com.apple.Spotlight SuggestionsEnabled -bool false`<br>`defaults write com.apple.Spotlight.plist IntelligentSuggestionsEnabled -bool false` |
| **Revert** | `sudo mdutil -a -i on`<br>`defaults delete com.apple.Spotlight SuggestionsEnabled`<br>`defaults delete com.apple.Spotlight.plist IntelligentSuggestionsEnabled` |

**Trade-offs**:
- Spotlight search will be unavailable or limited
- File search requires alternative tools (e.g., `find`, `mdfind` won't work)
- Siri knowledge features may be affected

---

### ui — Animations & Dock Responsiveness

**Purpose**: Eliminates or dramatically reduces macOS UI animations for a snappier desktop experience.

**Impact**: Noticeable on all Macs; Improves perceived responsiveness

**What it does**:
- Disables automatic window animations (open/close)
- Reduces window resize time to near-instant (0.001s)
- Speeds up Mission Control/Exposé animations
- Removes Dock auto-hide delay
- Accelerates Dock show/hide animation

| Action | Commands |
|--------|----------|
| **Apply** | `defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false`<br>`defaults write NSGlobalDomain NSWindowResizeTime -float 0.001`<br>`defaults write com.apple.dock expose-animation-duration -float 0.1`<br>`defaults write com.apple.dock autohide-delay -float 0`<br>`defaults write com.apple.dock autohide-time-modifier -float 0.15` |
| **Revert** | `defaults delete NSGlobalDomain NSAutomaticWindowAnimationsEnabled`<br>`defaults delete NSGlobalDomain NSWindowResizeTime`<br>`defaults delete com.apple.dock expose-animation-duration`<br>`defaults delete com.apple.dock autohide-delay`<br>`defaults delete com.apple.dock autohide-time-modifier` |

**Trade-offs**:
- Loss of visual polish/smoothness
- May feel jarring initially

---

### finder — File Browser Optimizations

**Purpose**: Streamlines Finder behavior by disabling animations, removing unnecessary warnings, and preventing `.DS_Store` file creation on network/USB drives.

**Impact**: Moderate; Improves file browsing experience

**What it does**:
- Disables all Finder animations
- Removes extension change confirmation dialogs
- Enables path bar and status bar (useful additions)
- Prevents `.DS_Store` pollution on network volumes
- Prevents `.DS_Store` creation on USB drives

| Action | Commands |
|--------|----------|
| **Apply** | `defaults write com.apple.finder DisableAllAnimations -bool true`<br>`defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false`<br>`defaults write com.apple.finder ShowPathbar -bool true`<br>`defaults write com.apple.finder ShowStatusBar -bool true`<br>`defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true`<br>`defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true` |
| **Revert** | `defaults delete com.apple.finder DisableAllAnimations`<br>`defaults delete com.apple.finder FXEnableExtensionChangeWarning`<br>`defaults delete com.apple.finder ShowPathbar`<br>`defaults delete com.apple.finder ShowStatusBar`<br>`defaults delete com.apple.desktopservices DSDontWriteNetworkStores`<br>`defaults delete com.apple.desktopservices DSDontWriteUSBStores` |

**Trade-offs**:
- No confirmation when changing file extensions (be careful!)

---

### quicklook — Preview Cache Management

**Purpose**: Clears Quick Look preview caches, which can grow large and cause preview delays.

**Impact**: Low; One-time cleanup action

**What it does**:
- Resets Quick Look generator list
- Clears all cached Quick Look thumbnails and previews

| Action | Commands |
|--------|----------|
| **Apply** | `qlmanage -r`<br>`qlmanage -r cache` |
| **Revert** | None needed (ephemeral action) |

**Trade-offs**:
- First preview of files will be slower as cache rebuilds

---

### appnap — Background App Throttling

**Purpose**: Disables App Nap, Apple's power-saving feature that throttles hidden applications.

**Impact**: Increases power consumption; Prevents app throttling

**What it does**:
- Prevents macOS from putting hidden apps into low-power "nap" mode
- Ensures background apps maintain full performance

| Action | Commands |
|--------|----------|
| **Apply** | `defaults write NSGlobalDomain NSAppSleepDisabled -bool true` |
| **Revert** | `defaults delete NSGlobalDomain NSAppSleepDisabled` |

**Trade-offs**:
- Higher power consumption
- Reduced battery life on laptops
- Background apps continue using full resources

---

### shadows — Window Shadow Effects

**Purpose**: Disables window drop shadows rendered by WindowServer.

**Impact**: Low; Minor GPU/compositing savings

**What it does**:
- Removes shadow effects from all windows
- Reduces WindowServer compositing work

| Action | Commands |
|--------|----------|
| **Apply** | `defaults write com.apple.windowserver DisableShadow -bool true` |
| **Revert** | `defaults delete com.apple.windowserver DisableShadow` |

**Trade-offs**:
- Windows lack visual depth/separation
- UI appears flatter

---

### visual — Accessibility Visual Effects

**Purpose**: Enables accessibility features that reduce visual complexity—reducing transparency, motion, and enhancing contrast.

**Impact**: Moderate; Reduces GPU compositing overhead

**What it does**:
- Enables "Reduce Transparency" (removes blur/transparency effects)
- Enables "Reduce Motion" (minimizes parallax and animation effects)
- Enables "Increase Contrast" (clearer UI boundaries)
- Disables desktop tinting

| Action | Commands |
|--------|----------|
| **Apply** | `defaults write com.apple.universalaccess reduceTransparency -bool true`<br>`defaults write com.apple.universalaccess reduceMotion -bool true`<br>`defaults write com.apple.universalaccess enhanceContrast -bool true`<br>`defaults write NSGlobalDomain AppleReduceDesktopTinting -bool true` |
| **Revert** | `defaults delete com.apple.universalaccess reduceTransparency`<br>`defaults delete com.apple.universalaccess reduceMotion`<br>`defaults delete com.apple.universalaccess enhanceContrast`<br>`defaults delete NSGlobalDomain AppleReduceDesktopTinting` |

**Note**: Some settings may be protected on macOS Sequoia and require manual changes via System Settings → Accessibility.

**Trade-offs**:
- Loss of macOS visual design aesthetics
- Flatter, less visually rich interface

---

## Privacy & Telemetry Modules

### analytics — Diagnostics & Crash Reporting

**Purpose**: Disables Apple's diagnostic data collection and crash report submission services.

**Impact**: Privacy improvement; Minimal performance impact

**What it does**:
- Disables the analytics daemon (`analyticsd`)
- Disables diagnostic submission service
- Suppresses crash reporter dialog popups

| Action | Commands |
|--------|----------|
| **Apply** | `sudo launchctl disable system/com.apple.analyticsd`<br>`sudo launchctl disable system/com.apple.SubmitDiagInfo`<br>`defaults write com.apple.CrashReporter DialogType none` |
| **Revert** | `sudo launchctl enable system/com.apple.analyticsd`<br>`sudo launchctl enable system/com.apple.SubmitDiagInfo`<br>`defaults write com.apple.CrashReporter DialogType crashreport` |

**Trade-offs**:
- Cannot submit crash reports to Apple
- May complicate troubleshooting with Apple Support

---

### siri — Voice Assistant & Daemons

**Purpose**: Completely disables Siri and its supporting background services.

**Impact**: Privacy improvement; Reduces background CPU usage

**What it does**:
- Disables Siri assistant support
- Hides Siri from menu bar
- Stops `assistantd` daemon (user-level)
- Stops `Siri.agent` (user-level)

| Action | Commands |
|--------|----------|
| **Apply** | `defaults write com.apple.assistant.support "Assistant Enabled" -bool false`<br>`defaults write com.apple.Siri StatusMenuVisible -bool false`<br>`launchctl disable user/$(id -u)/com.apple.assistantd`<br>`launchctl disable user/$(id -u)/com.apple.Siri.agent` |
| **Revert** | `defaults write com.apple.assistant.support "Assistant Enabled" -bool true`<br>`defaults write com.apple.Siri StatusMenuVisible -bool true`<br>`launchctl enable user/$(id -u)/com.apple.assistantd`<br>`launchctl enable user/$(id -u)/com.apple.Siri.agent` |

**Trade-offs**:
- No voice assistant functionality
- Siri Shortcuts may not work
- Some system integrations may be affected

---

### appleintelligence — AI Features (macOS 15+)

**Purpose**: Disables Apple Intelligence features introduced in macOS Sequoia, including Writing Tools, Image Playground, and Genmoji.

**Impact**: Privacy improvement; May reduce background processing

**Compatibility**: macOS 15 (Sequoia) and later only

**What it does**:
- Disables Apple Intelligence at the application level
- Blocks Writing Tools integration
- Disables Image Playground features
- Disables Genmoji generation

| Action | Commands |
|--------|----------|
| **Apply** | `defaults write com.apple.applicationaccess AllowAppleIntelligence -bool false`<br>`defaults write com.apple.IntelligencePlatform.UserAccess AllowedUserAccess -bool false`<br>`defaults write com.apple.IntelligencePlatform.WritingTools UserAccessEnabled -bool false`<br>`defaults write com.apple.IntelligencePlatform.ImagePlayground UserAccessEnabled -bool false`<br>`defaults write com.apple.IntelligencePlatform.Genmoji UserAccessEnabled -bool false` |
| **Revert** | `defaults delete com.apple.applicationaccess AllowAppleIntelligence`<br>`defaults delete com.apple.IntelligencePlatform.UserAccess AllowedUserAccess`<br>`defaults delete com.apple.IntelligencePlatform.WritingTools UserAccessEnabled`<br>`defaults delete com.apple.IntelligencePlatform.ImagePlayground UserAccessEnabled`<br>`defaults delete com.apple.IntelligencePlatform.Genmoji UserAccessEnabled` |

**Note**: Commands use `|| true` as these preferences may not exist on all systems.

**Trade-offs**:
- No AI writing assistance
- No AI image generation features
- No custom emoji generation

---

### live — Live Activities Tracking

**Purpose**: Disables Live Activities tracking feature.

**Impact**: Minor privacy/performance improvement

**What it does**:
- Disables the activity tracking daemon's Live Activities feature

| Action | Commands |
|--------|----------|
| **Apply** | `defaults write com.apple.activitytrackingd ActivityTrackingEnabled -bool false` |
| **Revert** | `defaults delete com.apple.activitytrackingd ActivityTrackingEnabled` |

**Trade-offs**:
- Live Activities widgets may not function properly

---

## Cloud & Sync Modules

### icloud — Desktop & Documents Sync

**Purpose**: Prevents iCloud from automatically syncing Desktop and Documents folders, and changes the default save location from iCloud to local storage.

**Impact**: Reduces network activity; Preserves local-first workflow

**What it does**:
- Sets default save location to local disk instead of iCloud
- Disables Desktop & Documents folder sync to iCloud Drive

| Action | Commands |
|--------|----------|
| **Apply** | `defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false`<br>`defaults write com.apple.iCloudDrive DisableDesktopAndDocuments -bool true` |
| **Revert** | `defaults delete NSGlobalDomain NSDocumentSaveNewDocumentsToCloud`<br>`defaults delete com.apple.iCloudDrive DisableDesktopAndDocuments` |

**Trade-offs**:
- Files not automatically backed up to iCloud
- Desktop/Documents won't sync across devices
- Must manually manage iCloud uploads

---

### photos — Background Photo Analysis

**Purpose**: Disables Photos app background services that perform face recognition, scene analysis, and library management.

**Impact**: Significant CPU savings when Photos library is large

**What it does**:
- Disables `photoanalysisd` (face/scene recognition)
- Disables `photolibraryd` (library management daemon)

| Action | Commands |
|--------|----------|
| **Apply** | `sudo launchctl disable system/com.apple.photoanalysisd`<br>`sudo launchctl disable system/com.apple.photolibraryd` |
| **Revert** | `sudo launchctl enable system/com.apple.photoanalysisd`<br>`sudo launchctl enable system/com.apple.photolibraryd` |

**Trade-offs**:
- No automatic face tagging or People album updates
- Photo Memories won't be generated
- Scene/object search may not work

---

### handoff — Continuity Features

**Purpose**: Disables Handoff/Continuity features that advertise and receive activities between Apple devices.

**Impact**: Reduces Bluetooth/network scanning; Minor privacy improvement

**What it does**:
- Stops advertising user activities to nearby devices
- Stops receiving activity handoffs from other devices

| Action | Commands |
|--------|----------|
| **Apply** | `defaults write com.apple.coreservices.useractivityd ActivityAdvertisingAllowed -bool false`<br>`defaults write com.apple.coreservices.useractivityd ActivityReceivingAllowed -bool false` |
| **Revert** | `defaults delete com.apple.coreservices.useractivityd ActivityAdvertisingAllowed`<br>`defaults delete com.apple.coreservices.useractivityd ActivityReceivingAllowed` |

**Trade-offs**:
- Cannot continue tasks started on iPhone/iPad
- Universal Clipboard may not work
- Continuity features disabled

---

### airdrop — Wireless File Sharing

**Purpose**: Disables AirDrop in Finder, reducing background network scanning.

**Impact**: Reduces network daemon activity

**What it does**:
- Disables AirDrop discovery and file receiving

| Action | Commands |
|--------|----------|
| **Apply** | `defaults write com.apple.NetworkBrowser DisableAirDrop -bool true` |
| **Revert** | `defaults delete com.apple.NetworkBrowser DisableAirDrop` |

**Trade-offs**:
- Cannot receive files via AirDrop
- Must manually re-enable for file transfers

---

## Power Management Modules

### pmset — Background Wake Events

**Purpose**: Reduces background wake events that disturb sleep and consume power.

**Impact**: Significant battery life improvement on laptops

**What it does**:
- Disables Power Nap (background tasks during sleep)
- Disables TCP keepalive wake events

| Action | Commands |
|--------|----------|
| **Apply** | `sudo pmset -a powernap 0`<br>`sudo pmset -a tcpkeepalive 0` |
| **Revert** | `sudo pmset -a powernap 1`<br>`sudo pmset -a tcpkeepalive 1` |

**Trade-offs**:
- Email won't sync during sleep
- iCloud won't update during sleep
- May miss time-sensitive notifications until wake

---

### powermode — Low Power Mode

**Purpose**: Enables Low Power Mode when running on battery.

**Impact**: Significant battery extension; Reduced performance

**What it does**:
- Activates macOS Low Power Mode for battery operation

| Action | Commands |
|--------|----------|
| **Apply** | `sudo pmset -b lowpowermode 1` |
| **Revert** | `sudo pmset -b lowpowermode 0` |

**Trade-offs**:
- Reduced CPU/GPU performance
- Display brightness may be limited
- Background refresh reduced

---

### timemachine — Local Snapshots

**Purpose**: Disables Time Machine local snapshots (legacy feature).

**Impact**: Frees disk space; Reduces background I/O

**What it does**:
- Disables local Time Machine snapshots (for Macs without continuous backup drives)

| Action | Commands |
|--------|----------|
| **Apply** | `sudo tmutil disablelocal` |
| **Revert** | `sudo tmutil enablelocal` |

**Note**: This command may have no effect on newer macOS versions where APFS snapshots are managed differently.

**Trade-offs**:
- No local backup snapshots between Time Machine backups
- Reduced recovery options if disk fails

---

## Input & Text Modules

### text — Autocorrection & Spell Check

**Purpose**: Disables macOS text intelligence features that can interfere with typing.

**Impact**: Improves typing experience for technical users

**What it does**:
- Disables continuous spell checking
- Disables automatic spelling correction
- Disables automatic text completion

| Action | Commands |
|--------|----------|
| **Apply** | `defaults write NSGlobalDomain NSAllowContinuousSpellChecking -bool false`<br>`defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false`<br>`defaults write NSGlobalDomain NSAutomaticTextCompletionEnabled -bool false` |
| **Revert** | `defaults delete NSGlobalDomain NSAllowContinuousSpellChecking`<br>`defaults delete NSGlobalDomain NSAutomaticSpellingCorrectionEnabled`<br>`defaults delete NSGlobalDomain NSAutomaticTextCompletionEnabled` |

**Trade-offs**:
- No automatic typo correction
- Manual spell checking required
- May affect writing in non-technical contexts

---

## System Updates Module

### updates — Automatic Update Checks

**Purpose**: Disables automatic checking for macOS and app updates.

**Impact**: Reduces background network activity

**What it does**:
- Prevents automatic update checking (manual check still works)

| Action | Commands |
|--------|----------|
| **Apply** | `sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false` |
| **Revert** | `sudo defaults delete /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled` |

**Trade-offs**:
- Must manually check for updates
- May miss important security updates
- **Recommendation**: Check manually at least weekly

---

## Utility Modules

### backup — Preference Backup

**Purpose**: Creates a timestamped backup of key system preferences before making changes.

**Impact**: None (utility function)

**What it does**:
- Exports Finder preferences
- Exports global (NSGlobalDomain) preferences
- Exports Dock preferences
- Saves current `pmset` power configuration

| Action | Commands |
|--------|----------|
| **Apply** | `defaults export com.apple.finder "$backup_dir/finder.plist"`<br>`defaults export NSGlobalDomain "$backup_dir/global.plist"`<br>`defaults export com.apple.dock "$backup_dir/dock.plist"`<br>`pmset -g > "$backup_dir/pmset.txt"` |
| **Revert** | N/A (creates backup only) |

**Saved to**: `~/.mactweaks/backups/<timestamp>/`

---

### loginitems — Startup Application Audit

**Purpose**: Lists all applications configured to launch at login, helping identify bloat.

**Impact**: Informational only

**What it does**:
- Uses AppleScript to enumerate login items
- Displays list for user review

| Action | Commands |
|--------|----------|
| **Apply** | `osascript -e 'tell application "System Events" to get name of every login item'` |
| **Revert** | N/A (read-only) |

**Follow-up**: Go to **System Settings → General → Login Items** to disable unwanted items.

---

### updatecheck — Compatibility Detection

**Purpose**: Checks system compatibility and reports expected optimization effectiveness.

**Impact**: Informational only

**What it does**:
- Detects macOS version
- Identifies processor type (Intel vs Apple Silicon)
- Provides optimization expectations

| Output | Meaning |
|--------|---------|
| **macOS Sequoia detected** | Toolkit is optimized for this version |
| **Intel Mac** | Maximum performance gains expected |
| **Apple Silicon** | Some tweaks have smaller impact (already optimized) |

---

### exportreport — Report Export

**Purpose**: Copies the most recent MacTweaks report to the Desktop for easy sharing.

**Impact**: None (file copy only)

**What it does**:
- Locates the latest report in the reports directory
- Copies it to Desktop with a timestamped filename

| Action | Commands |
|--------|----------|
| **Apply** | Copies latest `report_*.txt` to `~/Desktop/SequoiaPerf_Report_<timestamp>.txt` |
| **Revert** | N/A |

---

## Module Categories by Impact

### High Impact (Recommended)

| Module | Best For |
|--------|----------|
| `spotlight` | CPU/disk relief when search isn't needed |
| `pmset` | Battery life extension |
| `photos` | Users with large photo libraries |
| `ui` | Perceived responsiveness |
| `visual` | Older Macs / GPU relief |

### Medium Impact

| Module | Best For |
|--------|----------|
| `analytics` | Privacy-conscious users |
| `siri` | Users who don't use Siri |
| `finder` | Heavy file browser users |
| `icloud` | Local-first workflow preference |
| `powermode` | Maximum battery life |

### Low Impact / Situational

| Module | Best For |
|--------|----------|
| `text` | Developers / technical writers |
| `handoff` | Single-device users |
| `airdrop` | Rarely transfer files wirelessly |
| `shadows` | Minimal visual preference |
| `appnap` | Background app reliability |

---

## Compatibility Notes

### macOS Version Support

| Feature | macOS 14 (Sonoma) | macOS 15 (Sequoia) |
|---------|-------------------|---------------------|
| Most modules | ✅ Full support | ✅ Full support |
| `appleintelligence` | ❌ N/A | ✅ Supported |
| `visual` accessibility | ✅ Works | ⚠️ Some settings protected |
| `timemachine` local | ⚠️ May have no effect | ⚠️ May have no effect |

### Processor Architecture

| Module | Intel Mac | Apple Silicon |
|--------|-----------|---------------|
| `spotlight` | High impact | Moderate impact |
| `pmset` | High impact | Moderate impact |
| `visual` | High impact | Low-moderate impact |
| Most others | Normal | Normal |

---

## Safety & Reversibility

All modules in MacTweaks are designed with safety in mind:

1. **No system file modifications** — Only user preferences and daemon states are changed
2. **Full reversibility** — Every `apply` has a corresponding `revert`
3. **Error tolerance** — Commands use `|| true` guards where appropriate
4. **Backup first** — Use the `backup` module before applying changes
5. **Snapshot support** — Works with the built-in snapshot/restore system

---

## Quick Reference Table

| Module | Apply Effect | Reversible | Requires Sudo |
|--------|--------------|------------|---------------|
| `spotlight` | Disable indexing | ✅ Yes | ✅ Yes |
| `siri` | Disable assistant | ✅ Yes | ❌ No |
| `analytics` | Stop telemetry | ✅ Yes | ✅ Yes |
| `ui` | Faster animations | ✅ Yes | ❌ No |
| `live` | Disable Live Activities | ✅ Yes | ❌ No |
| `text` | Disable autocorrect | ✅ Yes | ❌ No |
| `timemachine` | Stop local snapshots | ✅ Yes | ✅ Yes |
| `photos` | Stop photo analysis | ✅ Yes | ✅ Yes |
| `finder` | Optimize Finder | ✅ Yes | ❌ No |
| `icloud` | Disable sync features | ✅ Yes | ❌ No |
| `visual` | Reduce effects | ✅ Yes | ❌ No |
| `appnap` | Disable app throttling | ✅ Yes | ❌ No |
| `quicklook` | Clear caches | ⚪ N/A | ❌ No |
| `pmset` | Reduce wake events | ✅ Yes | ✅ Yes |
| `airdrop` | Disable AirDrop | ✅ Yes | ❌ No |
| `handoff` | Disable Continuity | ✅ Yes | ❌ No |
| `updates` | Stop auto-check | ✅ Yes | ✅ Yes |
| `shadows` | Remove shadows | ✅ Yes | ❌ No |
| `appleintelligence` | Disable AI | ✅ Yes | ❌ No |
| `powermode` | Enable Low Power | ✅ Yes | ✅ Yes |
| `backup` | Backup prefs | ⚪ N/A | ❌ No |
| `loginitems` | List startups | ⚪ N/A | ❌ No |
| `updatecheck` | Check compat | ⚪ N/A | ❌ No |
| `exportreport` | Export report | ⚪ N/A | ❌ No |
