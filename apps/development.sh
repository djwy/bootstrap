#!/bin/bash

# Development
brew=(
  # Utils/Build tools
  "coreutils"
  "pcre"
  "autoconf"
  "makedepend"
  "apple-gcc42"
  "automake"
  "xz"
  "wget"
  "watchman"
  "tree"
  # Libraries
  "--with-libtiff --with-little-cms imagemagick"
  "ghostscript"
  "wget"
  "jpeg"
  "libpng"
  "libtiff"
  "webp"
  # Languages
  "go"
  "rust"
  "python3"
  "node"
  "llvm"
  "rbenv"
  "ruby-build"
  # Databases
  "postgresql"
  "sqlite"
  # Fun
  "exercism"
)

cask=(
  # Dev tools
  "atom"
  "sublime-text-3"
  "iterm2"
  "transmit"
  # Browsers
  "firefox"
  "google-chrome"
  "google-chrome-canary"
  "opera"
  "dockertoolbox"
)

npm=(
  "jshint"
  "stylus"
  "bower"
  "ember-cli"
  "grunt"
  "mermaid"
)

apm=(
  "sync-settings"
)
