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
git_tar berfarah/bootstrap $HOME/bootstrap && cd $HOME/bootstrap

echo "Installing Oh-My-Zsh"
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

echo "Installing Homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

mkdir $HOME/Code

echo "Installing dotfiles"
git clone git@github.com:berfarah/dotfiles $HOME/Code/dotfiles && \
  $HOME/Code/dotfiles/link.sh

echo "Moving over old preferences"
chmod 0600 ./Library/Preferences/*
cp -R ./Library/ ~/Library/

# Install a bunch of apps
echo "Installing homebrew dependencies"
brew bundle

echo 'Is this a personal install? [y/n]'
read personal
if [ "$personal" == "y" ]; then
  echo "Installing additional applications"
  brew bundle --file Brewfile.personal
fi

# Set a bunch of settings
./osx.sh

echo "Done installing, removing self"
rm -rf $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
