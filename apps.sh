#!/bin/bash

__DIR__=$(cd "$(dirname "$(readlink $0)")" && pwd)

# Prompt install
echo "Which apps do you want to install?"
echo " [1] core (default)"
echo " [2] work"
echo " [3] personal"
read type

# Generate installation list
install_list=(core customization development)
if   [ "$type" -eq "2" ]; then
  install_list+=(work)
elif [ "$type" -eq "3" ]; then
  install_list+=(personal)
else
  install_list=(core)
fi

# Loop installation list
for inst in ${install_list[@]}; do

  echo "Installing $inst..."

  # Clear variables
  bash=()
  brew=()
  cask=()
  store=()
  npm=()
  apm=()

  # Set variables from file
  source "$__DIR__/apps/$inst.sh"

  # Run all bash scripts
  for b in "${bash[@]}"; do
    sh -c "$b"
  done

  # Run all brew installs
  for b in "${brew[@]}"; do
    brew install "$b"
  done

  # Run all cask installs
  for c in "${cask[@]}"; do
    brew cask install "$c"
  done

  # Run all npm installs
  for n in "${npm[@]}"; do
    npm install "$n"
  done

  # Run all apm installs
  for a in "${apm[@]}"; do
    apm install "$a"
  done

  # Output what needs to be installed manually
  if [ -n "$store" ]; then
    printf "\nThe following will have to be installed manually:"
    printf "\n=================================================\n"
    printf "%s\n" "${store[@]}"
  fi
done
