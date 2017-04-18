#!/bin/bash

RUBY_VERSION="2.3.1"

git_tar()
{
  echo "Downloading $1 from github"
  mkdir -p $2
  curl -sL "https://github.com/$1/archive/master.tar.gz" | tar -xz -C $2 --strip-components=1
}

echo "Installing dev tools"
xcode-select --install

echo "Gathering dependencies"
git_tar berfarah/bootstrap $HOME/bootstrap && cd $HOME/bootstrap

echo "Installing Oh-My-Zsh"
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

echo "Installing Homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing homebrew dependencies"
brew bundle

echo "Is this a personal machine?"
read -p "[y/n]" personal
if [ "$personal" == "y" ]; then
  echo "Installing additional applications"
  brew bundle --file=Brewfile.personal
fi

echo "Setting up NPM"
npm install -g eslint yarn

echo "Setting up Ruby"
eval "$(rbenv init -)" 2> /dev/null
git clone git://github.com/tpope/rbenv-ctags.git ~/.rbenv/plugins/rbenv-ctags
rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION
gem install --conservative gem-ctags bundler rubocop

echo "Installing dotfiles"
mkdir -p $HOME/Code
git clone git@github.com:berfarah/dotfiles $HOME/Code/dotfiles && \
  $HOME/Code/dotfiles/link.sh

# =======================================
# Settings
# =======================================
echo "Moving over old preferences"
chmod 0600 ./Library/Preferences/*
cp -R ./Library/ ~/Library/

# Mac app store

# Check for software updates daily instead of weekly
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# Alfred (enable sync)
killall Alfred &> /dev/null
defaults write com.runningwithcrayons.Alfred-Preferences-3.plist syncfolder -string "~/Library/Mobile Documents/com~apple~CloudDocs/Alfred"

# Dash (enable sync)
killall Dash &> /dev/null
defaults write com.kapeli.dashdoc.plist syncFolderPath -string "~/Library/Mobile Documents/com~apple~CloudDocs"
defaults write com.kapeli.dashdoc.plist shouldSyncBookmarks -bool true
defaults write com.kapeli.dashdoc.plist shouldSyncDocsets -bool true
defaults write com.kapeli.dashdoc.plist shouldSyncGeneral -bool true
defaults write com.kapeli.dashdoc.plist shouldSyncView -bool true

# Set a bunch of settings
./macos.sh

echo "Done installing, removing self"
rm -rf $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
