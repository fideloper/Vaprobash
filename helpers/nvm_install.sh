#!/usr/bin/env bash

PROFILE=~/.profile
BASHRC=~/.bashrc

NVMSCRIPTURL="https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh"

# The script clones the nvm repository to ~/.nvm and adds the source line to your profile (~/.bash_profile, ~/.zshrc, ~/.profile, or ~/.bashrc).
curl -sL $NVMSCRIPTURL -o install_nvm.sh
bash install_nvm.sh

printf '\n\nexport NVM_DIR=~/.nvm
[ -s "~/.nvm/nvm.sh" ] && . "~/.nvm/nvm.sh"' >> $PROFILE

printf '\n\nexport NVM_DIR=~/.nvm
[ -s "~/.nvm/nvm.sh" ] && . "~/.nvm/nvm.sh"' >> $BASHRC

source $PROFILE
source $BASHRC
