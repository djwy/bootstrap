#!/bin/bash

# Prerequisite for all macs
echo "Installing dev tools"
xcode-select --install

# Copying all files needed
git clone --depth 1 https://github.com/berfarah/mac-setup $HOME/mac-setup && cd $HOME/mac-setup

# Install Oh-My-Zsh
echo "Installing Oh-My-Zsh"
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# Install Homebrew
echo "Installing Homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install Powerline fonts
echo "Installing Powerline fonts"
git clone https://github.com/powerline/fonts.git && \
  pushd fonts && \
  /bin/bash install.sh && \
  popd

# Install theming options
echo "Installing base16 kit"
mkdir -p $HOME/.config
git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell
git clone https://github.com/chriskempson/base16-iterm2.git $HOME/.config/base16-iterm2
echo "Follow directions here https://github.com/chriskempson/base16-vim"

# Move over preferences
echo "Moving over old preferences"
chmod 0600 ./Library/Preferences/*
cp -R ./Library/ ~/Library/
cp -R dotfiles/ ~/

# Setting up preferences
git config --global core.excludesfile ~/.gitignore_global

# Set a bunch of settings
./osx.sh

# Install a bunch of apps
./apps.rb

# Remaining setup
echo "Moving icons to desktop"
mv -R icons ~/Desktop

echo "Done installing, removing self"
rm -rf $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
