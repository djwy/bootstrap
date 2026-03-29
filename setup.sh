#!/bin/bash

RUBY_VERSION="3.3.6"
NODE_VERSION="22.12.0"

git_tar()
{
  echo "Downloading $1 from github"
  mkdir -p $2
  curl -sL "https://github.com/$1/archive/master.tar.gz" | tar -xz -C $2 --strip-components=1
}

echo "Installing dev tools"
xcode-select --install

echo "Gathering dependencies"
git_tar djwy/bootstrap $HOME/bootstrap && cd $HOME/bootstrap

echo "Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Loading Homebrew"
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Installing Homebrew dependencies"
brew bundle

echo "Is this a personal machine?"
read -p "[y/n]" personal
if [ "$personal" == "y" ]; then
  echo "Installing additional applications"
  brew bundle --file=Brewfile.personal
fi

echo "Installing Nerd Font"
brew install font-atkynson-mono-nerd-font

echo "Installing FZF shell extensions"
"$(brew --prefix)/opt/fzf/install"

echo "Setting up Ruby"
mise use --global ruby@$RUBY_VERSION
gem install --conservative bundler pry rubocop

echo "Setting up Node"
mise use --global node@$NODE_VERSION

echo "Setting up Yarn"
mise use --global yarn@latest
yarn global add eslint prettier

echo "Installing dotfiles"
git clone https://github.com/djwy/dotfiles.git $HOME/dev/dotfiles && \
  $HOME/dev/dotfiles/link.sh

# =======================================
# Settings
# =======================================
echo "Move over old preferences?"
read -p "[y/n]" preferences
if [ "$preferences" == "y" ]; then
  echo "Moving over old preferences"
  chmod 0600 ./Library/Preferences/*
  cp -R ./Library/ ~/Library/
fi

# Mac App Store

# Check for software updates daily instead of weekly
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# Alfred (enable sync)
echo "Sync Alfred?"
read -p "[y/n]" syncAlfred
if [ "$syncAlfred" == "y" ]; then
  killall Alfred &> /dev/null
  defaults write com.runningwithcrayons.Alfred-Preferences-3 syncfolder -string "~/Library/Mobile Documents/com~apple~CloudDocs/Alfred"
fi

# Set a bunch of settings
./macos.sh

echo "Done installing, removing self"
rm -rf $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
