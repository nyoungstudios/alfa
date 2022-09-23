#/bin/bash

# improves performance of macos virtal machine

# disabling spotlight
sudo mdutil -i off -a

# performance mode: https://support.apple.com/en-us/HT202528
sudo nvram boot-args="serverperfmode=1 $(nvram boot-args 2>/dev/null | cut -f 2-)"

# enable multiple sessions
sudo /usr/bin/defaults write .GlobalPreferences MultipleSessionsEnabled -bool TRUE

defaults write "Apple Global Domain" MultipleSessionsEnabled -bool true

# disables updates
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool false
sudo defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false
sudo defaults write com.apple.commerce AutoUpdate -bool false
sudo defaults write com.apple.commerce AutoUpdateRestartRequired -bool false
sudo defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 0
sudo defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 0
sudo defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 0
sudo defaults write com.apple.SoftwareUpdate AutomaticDownload -int 0
