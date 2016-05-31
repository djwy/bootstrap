#!/bin/bash

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
mkdir -p ~/.oh-my-zsh/custom/themes
mv dotfiles/bernardo.zsh-theme ~/.oh-my-zsh/custom/themes
cp -R dotfiles/ ~/

# Set a bunch of settings
./osx.sh

echo "Which apps do you want to install?\n[core|work|personal]"
./apps.sh

# Remaining setup
echo "Backing up Sublime Packages"
cp -R sublime/User ~/Library/Application\ Support/Sublime\ Text\ 3/Packages
echo "Moving icons to desktop"
mv -R icons ~/Desktop

echo "Check for your sync settings in Dashlane to get Atom 100% back to before"

echo "Done installing, removing self"
rm -rf $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
