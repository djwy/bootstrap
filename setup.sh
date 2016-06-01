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

echo "Installing Powerline fonts"
git_tar powerline/fonts && \
  pushd fonts &&           \
  /bin/bash install.sh &&  \
  popd &&                  \
  rm -rf fonts

echo "Installing base16 kit"
git_tar chriskempson/base16-shell $HOME/.config/base16-shell
git_tar chriskempson/base16-iterm2 $HOME/.config/base16-iterm2
echo "Follow directions here https://github.com/chriskempson/base16-vim"

echo "Moving over old preferences"
chmod 0600 ./Library/Preferences/*
cp -R ./Library/ ~/Library/
cp -R dotfiles/ ~/

# Set a bunch of settings
./osx.sh

# Install a bunch of apps
./apps.rb

echo "Done installing, removing self"
rm -rf $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
