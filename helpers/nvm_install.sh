#!/usr/bin/env bash

PROFILE=/home/ubuntu/.profile
BASHRC=/home/ubuntu/.bashrc

NVMSCRIPTURL="https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh"

# The script clones the nvm repository to ~/.nvm and adds the source line to your profile (~/.bash_profile, ~/.zshrc, ~/.profile, or ~/.bashrc).
curl -sL $NVMSCRIPTURL -o install_nvm.sh
bash install_nvm.sh

source $PROFILE && source $BASHRC