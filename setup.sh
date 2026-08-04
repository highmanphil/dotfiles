#!/bin/bash

# check if brew is installed
# if not, install it

if ! command -v brew &> /dev/null
then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

brew bundle --file=~/dotfiles/Brewfile

stow zsh
stow nvim
stow tmux
stow ghostty
stow direnv
