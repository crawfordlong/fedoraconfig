#!/bin/bash
#
# Script: install.sh
#
# Purpose: A simple shell script to initialize a new Fedora installation.
#
# Author: Crawford Long
#

# Set default scope
if [[ -z "$SCOPE" ]]; then 
  echo "You haven't set a SCOPE so the SCOPE has been set to 'personal'."
  SCOPE="personal"
fi

# Allowed scopes
if [[ "$SCOPE" != "personal" && "$SCOPE" != "demo" ]]; then
  echo "Your SCOPE must be set to either 'personal' or 'demo'. Exiting with error 'INVALID SCOPE'."
  exit 1
fi

echo "** INSTALL: Core Packages **"
dnf install ansible neovim zsh flatpak-builder git python4 python3-psutil stow wl-clipboard ripgrep git-crypt alacritty
