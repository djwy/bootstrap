#!/bin/bash

brew tap caskroom/homebrew-cask

# essentials
echo "Installing essentials"
brew cask install \
cloud \
bettertouchtool \
seil \
bartender \
dashlane \
vlc \
sublercli \
subler \
spotify \
skype \
music-manager \
google-drive \
flux \
typed \
tunnelblick \
evernote

# gaming
brew cask install \
steam \
teamspeak-client \
dolphin \
desmume

# browsers
brew cask install \
firefox \
google-chrome \
google-chrome-canary \
opera

# development
echo "Installing development tools"
brew cask install \
sublime-text-3 \
iterm2 \
virtualbox \
transmit

brew install \
boot2docker \
docker

echo "Installing libraries"
brew install \
wget \
imagemagick \
jpeg \
libpng \
libtiff \
webp

echo "Installing build tools"
brew install \
pcre \
autoconf \
apple-gcc42 \
ruby-build \
makedepend

echo "Installing languages & databases"
brew install \
go \
rbenv \
watchman \
node \
python3 \
postgresql \
sqlite

npm install -g \
jshint \
stylus \
bower \
ember-cli