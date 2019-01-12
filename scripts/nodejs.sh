#!/usr/bin/env bash

# Test if NodeJS is installed
node -v > /dev/null 2>&1
NODE_IS_INSTALLED=$?

# Contains all arguments that are passed
NODE_ARG=($@)

# Number of arguments that are given
NUMBER_OF_ARG=${#NODE_ARG[@]}

PROFILE=~/.profile
BASHRC=~/.bashrc

# True, if Node is not installed
if [[ $NODE_IS_INSTALLED -ne 0 ]]; then

    echo ">>> Installing latest stable Node LTS - 6.X"
	
    sudo apt-get -f -y upgrade;
    sudo apt-get -f -y dist-upgrade;
	sudo apt-get -y install python-software-properties
	
    # Install NVM
	curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
	sudo apt-get update
	sudo apt-get -y install nodejs npm

    # Re-source user profiles
    # if they exist
    source $PROFILE
	
	# Re-source .bashrc if exists
    source $BASHRC

fi

# Install (optional) Global Node Packages
if [[ ! -z $NODE_PACKAGES ]]; then
    echo ">>> Start installing Global Node Packages"

    npm install -g ${NODE_PACKAGES[@]}
fi
