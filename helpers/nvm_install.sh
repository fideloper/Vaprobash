#!/usr/bin/env bash

NVM_DIR="/home/ubuntu/.nvm"

if ! hash git 2>/dev/null; then
  echo >&2 "!!! You need to install git"
  exit 1
fi

if [ -d "$NVM_DIR" ]; then
  echo ">>> NVM is already installed in $NVM_DIR."
  echo -ne "\r=> "
fi

PROFILE="/home/ubuntu/.profile"
BASHRC="/home/ubuntu/.bashrc"

NVMSCRIPTURL="https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh"

# The script clones the nvm repository to ~/.nvm and adds the source line to your profile (~/.bash_profile, ~/.zshrc, ~/.profile, or ~/.bashrc).
curl -o- $NVMSCRIPTURL | bash

# If nvm command still results in 'not found' error
if [ $(command -v nvm) != "nvm" ]; then 
    EXPORT='export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm'
    echo $EXPORT >> $BASHRC
	source $BASHRC
	. $BASHRC
fi