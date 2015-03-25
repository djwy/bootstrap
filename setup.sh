#!/bin/bash

# Install Oh-My-Zsh
$ curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# Install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Move over preferences
cp -R Library ~/Library

# Install a bunch of stuff
./software.sh
./osx.sh
./quick-look.sh

# Remaining setup
mkdir ~/.oh-my-zsh/custom/themes
mv dotfiles/bernardo.zsh-theme ~/.oh-my-zsh/custom/themes
mv dotfiles/* ~/
cp -R sublime/User ~/Library/Application\ Support/Sublime\ Text\ 3/Packages
cp sublime/sublime-text-icon.icns ~/Desktop