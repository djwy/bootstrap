#!/bin/bash

git_tar()
{
  echo "Downloading $1 from github"
  mkdir -p $2
  curl -sL "https://github.com/$1/archive/master.tar.gz" | tar -xz -C $2 --strip-components=1
}

echo "Installing dev tools"
xcode-select --install

echo "Gathering dependencies"
git_tar berfarah/mac-setup $HOME/mac-setup && cd $HOME/mac-setup

echo "Installing Oh-My-Zsh"
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

echo "Installing Homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Moving over old preferences"
chmod 0600 ./Library/Preferences/*
cp -R ./Library/ ~/Library/
cp -R dotfiles/ ~/

# Install a bunch of apps
./apps.rb

# Set a bunch of settings
./osx.sh

echo "Done installing, removing self"
rm -rf $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
