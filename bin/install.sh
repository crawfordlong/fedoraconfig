#!/bin/bash
#
# Script: install.sh
#
# Purpose: A simple shell script to initialize a new Fedora installation.
#
# Author: Crawford Long
#

# Assign values to variables using arguments
#
# -s: $SCOPE
# -p: $ADDITIONAL PACKAGES
#
while getopts s: option
  do case "${option}" in
    s) SCOPE=${OPTARG};;
    p) ADDITIONALPACKAGES=${OPTARG};;
  esac
done

# Set default scope
if [[ -z "$SCOPE" ]]; then 
  echo "** MESSAGE: You haven't set a SCOPE so the SCOPE has been set to 'personal'"
  SCOPE="personal"
fi
echo "================================="

# Allowed scopes
if [[ "$SCOPE" != "personal" && "$SCOPE" != "demo" ]]; then
  echo "** ERROR: Your SCOPE must be set to either 'personal' or 'demo'. Exiting with error 'INVALID SCOPE'"
  exit 1
fi

# Install core packages
echo "** ACTION: Install core packages (you may be prompted for authentication)"
sudo dnf install ansible neovim zsh flatpak-builder git python3 python3-psutil stow wl-clipboard ripgrep git-crypt alacritty
echo "================================="

# Install additional packages, if specified
if [[ -n "$ADDITIONALPACKAGES" ]]; then
  echo "** MESSAGE: You have specified additional packages to install"
  echo "** ACTION: Install additional packages"
fi
echo "================================="

echo "** ACTION: Create '~/Sources' directory"
mkdir -p $HOME/Sources
echo "** ACTION: Clone $SCOPE repository"
#git clone git@github.com:crawfordlong/fedoraconfig.git

