#!/bin/bash
#
# Script: install.sh
#
# Purpose: A simple shell script to initialize a new Fedora installation.
#
# Author: Crawford Long
#

function YNPrompt {

  MESSAGE="This script will set up a computer running fedora\nwith the author's default settings and software."

  printf "$MESSAGE\n"
  read -p "Are you sure you want to proceed? (Y/n)" -n 1 -r
  # echo    # (optional) move to a new line
  if [[ $REPLY =~ [^Yy]$ ]]
  then
      printf "\n\nOk, thanks! Exiting...\n"
      exit 0
  fi
}

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

YNPrompt

SEPARATOR="\n=================================\n"

# Set default scope
printf $SEPARATOR
printf "\e[92;1mSET INSTALLATION SCOPE\e[39;0m\n\n"
if [[ -z "$SCOPE" ]]; then 
  printf "** MESSAGE: You haven't set a SCOPE so the SCOPE has been set to 'personal'\n"
  SCOPE="personal"
fi
# Allowed scopes
if [[ "$SCOPE" != "personal" && "$SCOPE" != "demo" ]]; then
  printf "** ERROR (INVALID SCOPE): Your SCOPE must be set to either 'personal' or 'demo'.\n\n"
  printf "\e[31;1mExiting...\e[39;0m\n\n"
  exit 1
fi

# Install core packages
printf $SEPARATOR
printf "\e[92;1mINSTALL PACKAGES\e[39;0m\n\n"
printf "** ACTION: Install core packages (you may be prompted for authentication)\n"
sudo dnf install ansible neovim zsh flatpak-builder git python3 python3-psutil stow wl-clipboard ripgrep git-crypt alacritty

# Install additional packages, if specified
if [[ -n "$ADDITIONALPACKAGES" ]]; then
  printf "** MESSAGE: You have specified additional packages to install\n"
  printf "** ACTION: Install additional packages\n"
  sudo dnf install $ADDITIONALPACKAGES
fi

# Create directories
printf $SEPARATOR
printf "\e[92;1mSETUP WORKSPACE\e[39;0m\n\n"
printf "** MESSAGE: Setting up '~/Sources'\n"
if [[ -d ~/Sources ]]; then
  printf "** MESSAGE: Sources directory already exists\n"
else
  printf "** ACTION: Create '~/Sources' directory\n"
  mkdir -p $HOME/Sources
fi

# Clone fedoraconfig repository from github
printf "** MESSAGE: Cloning 'fedoraconfig' to ~/Sources from github\n"
if [[ -d ~/Sources/fedoraconfig ]]; then
  printf "** MESSAGE: 'fedoraconfig' exists. You may experience errors if changes are not synchronized.\n" 
else
  printf "** ACTION: Clone $SCOPE repository\n"
  git clone git@github.com:crawfordlong/fedoraconfig.git ~/Sources
fi

pushd $HOME

# Clone dotfiles repository from github
printf "** MESSAGE: Cloning '.dotfiles' repository to ~ from github\n"
if [[ -d ~/.dotfiles ]]; then
  printf "** MESSAGE: '.dotfiles' directory exists. You may experience errors if changes are not synchronized.\n" 
else
  printf "** ACTION: Clone .dotfiles repository\n"
  git clone git@github.com:crawfordlong/.dotfiles.git ~/.dotfiles
fi

pushd .dotfiles
git submodule update --init $SCOPE
git checkout main
if [[ -d ".git-crypt" ]]; then
  git-crypt unlock
fi
popd 

#./install-$SCOPE

popd

printf "\n"