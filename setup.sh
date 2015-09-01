#!/bin/bash

# Install Oh-My-Zsh
echo "Installing Oh-My-Zsh"
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# Install Homebrew
echo "Installing Homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Move over preferences
echo "Moving over old preferences"
cp -R ./Library/ ~/Library/
mkdir -p ~/.oh-my-zsh/custom/themes
mv dotfiles/bernardo.zsh-theme ~/.oh-my-zsh/custom/themes
cp -R dotfiles/ ~/

# Set a bunch of settings
./osx.sh

echo "Which apps do you want to install?\n[core|work|personal]"
read type
./apps.rb $type

# Remaining setup
echo "Backing up Sublime Packages"
cp -R sublime/User ~/Library/Application\ Support/Sublime\ Text\ 3/Packages
echo "Moving icons to desktop"
mv -R icons ~/Desktop

echo "Done installing, removing self"
rm -rf $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
