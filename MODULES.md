```
# Module Command Reference

This file lists **exactly what system commands** each module executes — for full transparency and trust.

| Module                | Apply Commands                                                                                          | Revert Commands                                                                 |
|-----------------------|---------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| spotlight             | `sudo mdutil -a -i off`<br>`sudo mdutil -a -d`<br>`defaults write com.apple.Spotlight ...`              | `sudo mdutil -a -i on`<br>`defaults delete ...`                                 |
| siri                  | `defaults write com.apple.assistant.support "Assistant Enabled" -bool false`<br>`launchctl disable user/...` | `defaults write ... -bool true`<br>`launchctl enable user/...`                  |
| analytics             | `sudo launchctl disable system/com.apple.analyticsd`<br>`sudo launchctl disable system/com.apple.SubmitDiagInfo` | `sudo launchctl enable ...`                                                     |
| ui                    | Multiple `defaults write` for animations, Dock delays, window resize time                               | `defaults delete` for each key                                                  |
| live                  | `defaults write com.apple.activitytrackingd ActivityTrackingEnabled -bool false`                       | `defaults delete ...`                                                           |
| text                  | Disable spell check, autocorrect, text completion                                                       | `defaults delete`                                                               |
| timemachine           | `sudo tmutil disablelocal`                                                                              | `sudo tmutil enablelocal`                                                       |
| photos                | `sudo launchctl disable system/com.apple.photoanalysisd`<br>`...photolibraryd`                          | `sudo launchctl enable ...`                                                     |
| finder                | Disable animations, hide warnings, show path/status bars, disable .DS_Store on network drives          | `defaults delete`                                                               |
| icloud                | `defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false`<br>`...DisableDesktopAndDocuments` | `defaults delete`                                                               |
| visual                | `defaults write com.apple.universalaccess reduceTransparency/Motion -bool true` || true (Sequoia blocks) | `defaults delete`                                                               |
| appnap                | `defaults write NSGlobalDomain NSAppSleepDisabled -bool true`                                           | `defaults delete`                                                               |
| quicklook             | `qlmanage -r cache`                                                                                     | None (ephemeral)                                                                |
| pmset                 | `pmset -a powernap 0`<br>`pmset -a tcpkeepalive 0`                                                      | `pmset -a powernap 1`<br>`tcpkeepalive 1`                                       |
| airdrop               | `defaults write com.apple.NetworkBrowser DisableAirDrop -bool true`                                     | `defaults delete`                                                               |
| handoff               | Disable ActivityAdvertising/Receiving                                                                   | `defaults delete`                                                               |
| updates               | `sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false`  | `sudo defaults delete ...`                                                      |
| shadows               | `defaults write com.apple.windowserver DisableShadow -bool true`                                        | `defaults delete`                                                               |
| appleintelligence     | `defaults write com.apple.applicationaccess AllowAppleIntelligence -bool false` + related keys || true  | `defaults delete`                                                               |
| maintenance           | `sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder`<br>`sudo periodic daily weekly monthly`<br>log cleanup | None                                                                            |
| loginitems            | `osascript` to list login items                                                                         | None                                                                            |
| powermode             | `pmset -b lowpowermode 1`                                                                               | `pmset -b lowpowermode 0`                                                       |
| backup                | `defaults export` for Finder, Global, Dock → backup folder                                              | None                                                                            |
| updatecheck           | Info messages only                                                                                      | None                                                                            |
| exportreport          | Copies latest report to Desktop                                                                         | None                                                                            |

All commands are guarded with `|| true` where appropriate to prevent script failure on non-critical errors.

This toolkit only modifies user preferences, power settings, and disables background daemons — **no system files are altered**.
```
