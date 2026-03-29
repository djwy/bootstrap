#!/bin/bash

# ─── Output helpers ──────────────────────────────────────────────────────────

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

header()  { printf "\n${BOLD}${BLUE}▸ %s${RESET}\n" "$1"; }
success() { printf "  ${GREEN}✓${RESET} %s\n" "$1"; }
info()    { printf "  %s\n" "$1"; }

ask() {
  printf "${YELLOW}  ? %s [y/n] ${RESET}" "$1"
  read -r answer
  [[ "$answer" == "y" ]]
}

# ─── Preamble ────────────────────────────────────────────────────────────────

printf "\n${BOLD}macOS Settings${RESET}\n"

osascript -e 'tell application "System Settings" to quit'

# Ask for admin password upfront and keep sudo alive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ═══════════════════════════════════════════════════════════════════════════════
# Computer name
# ═══════════════════════════════════════════════════════════════════════════════

if ask "Set computer name?"; then
  header "Computer Name"
  printf "  Enter name: "
  read -r compname
  if [ -n "$compname" ]; then
    sudo scutil --set ComputerName "$compname"
    sudo scutil --set LocalHostName "$compname"
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$compname"
    success "Computer name set to $compname"
  else
    info "Skipped (empty name)"
  fi
fi

# ═══════════════════════════════════════════════════════════════════════════════
# General UI/UX
# ═══════════════════════════════════════════════════════════════════════════════

if ask "Apply general UI/UX settings?"; then
  header "General UI/UX"

  # Disable the sound effects on boot
  sudo nvram SystemAudioVolume=" "

  # Dark mode
  defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

  # Show scrollbars when scrolling
  defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

  # Save documents locally by default (not iCloud)
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

  # Auto-quit printer app when done
  defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

  # Remove duplicates in "Open With" menu
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

  # Non-floating Help Viewer
  defaults write com.apple.helpviewer DevMode -bool true

  # Restart on freeze
  systemsetup -setrestartfreeze on

  # Disable smart quotes and dashes (annoying when coding)
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

  success "General UI/UX settings applied"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Input
# ═══════════════════════════════════════════════════════════════════════════════

if ask "Apply keyboard, trackpad, and input settings?"; then
  header "Input"

  # Disable "natural" scrolling
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

  # Better Bluetooth audio quality
  defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

  # Full keyboard access for all controls (Tab in dialogs)
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

  # Ctrl+scroll to zoom
  defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
  defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
  defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

  # Disable press-and-hold, enable key repeat
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
  defaults write NSGlobalDomain KeyRepeat -int 1
  defaults write NSGlobalDomain InitialKeyRepeat -int 10

  # Language and locale
  defaults write NSGlobalDomain AppleLanguages -array "en"
  defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
  defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
  defaults write NSGlobalDomain AppleMetricUnits -bool false

  # Disable auto-correct
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

  success "Input settings applied"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Screen
# ═══════════════════════════════════════════════════════════════════════════════

if ask "Apply screen and screenshot settings?"; then
  header "Screen"

  # Require password immediately after sleep/screensaver
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0

  # Save screenshots to ~/screens as PNG
  mkdir -p "${HOME}/screens"
  defaults write com.apple.screencapture location -string "${HOME}/screens"
  defaults write com.apple.screencapture type -string "png"

  success "Screen settings applied"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Finder
# ═══════════════════════════════════════════════════════════════════════════════

if ask "Apply Finder settings?"; then
  header "Finder"

  # Allow quitting via Cmd+Q
  defaults write com.apple.finder QuitMenuItem -bool true

  # Desktop icons
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

  # Show hidden files, all extensions, status bar, path bar
  defaults write com.apple.finder AppleShowAllFiles -bool true
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.finder ShowPathbar -bool true

  # Folders on top when sorting
  defaults write com.apple.finder _FXSortFoldersFirst -bool true

  # Search current folder by default
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  # No warning on extension change
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  # Spring loading
  defaults write NSGlobalDomain com.apple.springing.enabled -bool true
  defaults write NSGlobalDomain com.apple.springing.delay -float 0

  # No .DS_Store on network/USB
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

  # Auto-open on volume mount
  defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
  defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
  defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

  # No warning before emptying Trash
  defaults write com.apple.finder WarnOnEmptyTrash -bool false

  # Show ~/Library
  chflags nohidden ~/Library

  # Expand File Info panes
  defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

  success "Finder settings applied"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Dock
# ═══════════════════════════════════════════════════════════════════════════════

if ask "Apply Dock settings?"; then
  header "Dock"

  # Icon size and magnification
  defaults write com.apple.dock tilesize -int 48
  defaults write com.apple.dock magnification -bool true
  defaults write com.apple.dock largesize -float 80

  # Behavior
  defaults write com.apple.dock minimize-to-application -bool false
  defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
  defaults write com.apple.dock launchanim -bool true

  # Mission Control
  defaults write com.apple.dock expose-animation-duration -float 0.1
  defaults write com.apple.dock expose-group-by-app -bool false
  defaults write com.apple.dock mru-spaces -bool false

  # Auto-hide with fast animation
  defaults write com.apple.dock autohide-delay -float 0.1
  defaults write com.apple.dock autohide-time-modifier -float 0.3
  defaults write com.apple.dock autohide -bool true

  # Translucent hidden app icons
  defaults write com.apple.dock showhidden -bool true

  # Reset Launchpad
  find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete 2>/dev/null

  success "Dock settings applied"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Terminal & updates
# ═══════════════════════════════════════════════════════════════════════════════

if ask "Apply Terminal and software update settings?"; then
  header "Terminal & Updates"

  # UTF-8 in Terminal.app
  defaults write com.apple.terminal StringEncodings -array 4

  # Daily update checks, auto-download, auto-install security updates
  defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
  defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
  defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
  defaults write com.apple.commerce AutoUpdate -bool true

  success "Terminal and update settings applied"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Restart affected apps
# ═══════════════════════════════════════════════════════════════════════════════

if ask "Restart affected applications (Dock, Finder, etc.)?"; then
  header "Restarting Applications"
  for app in "Dock" "Finder" "SystemUIServer"; do
    killall "${app}" >/dev/null 2>&1
  done
  success "Applications restarted"
fi

printf "\n${BOLD}${GREEN}macOS settings complete.${RESET}\n"
info "Some changes require a logout/restart to take effect."
