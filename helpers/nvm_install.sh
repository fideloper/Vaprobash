#!/usr/bin/env bash

NVM_DIR="/home/ubuntu/.nvm"

if ! hash git 2>/dev/null; then
  echo >&2 "!!! You need to install git"
  exit 1
fi

if [ -d "$NVM_DIR" ]; then
  echo ">>> NVM is already installed in $NVM_DIR, trying to update"
  echo -ne "\r=> "
  cd $NVM_DIR && git pull origin master
else
  # Cloning to $NVM_DIR
  git clone https://github.com/creationix/nvm.git $NVM_DIR
  cd $NVM_DIR
  git checkout master
  . nvm.sh
fi

PROFILE="/home/ubuntu/.profile"
BASHRC="/home/ubuntu/.bashrc"

SOURCE_CONTENT='export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion'

echo $SOURCE_CONTENT >> $PROFILE
echo $SOURCE_CONTENT >> $BASHRC

# Re-source .profile if exists
if [ -f ${PROFILE} ]; then
	. ${PROFILE}
fi

# Re-source .bashrc if exists
if [ -f ${BASHRC} ]; then
	. ${BASHRC}
fi