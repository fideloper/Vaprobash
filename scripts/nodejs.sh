#!/usr/bin/env bash

echo ">>> Installing Node Version Manager"

# Install NVM
curl https://gist.github.com/Ilyes512/8335484/raw/nvm_install.sh | sh

# Reload .bash_profile and/or .zshrc so you don't need to restart the terminal session
. ~/.bash_profile

. ~/.zshrc

# Find out what nodejs version should be installed
if [[ -z "$1" ]]; then
    # Default is set to latest stable version
    NODEJS_VERSION=latest
else
    # Use user's defined nodejs version
    NODEJS_VERSION=$1
fi

# If set to latest, get the current node version from the home page
if [ "$NODEJS_VERSION" == "latest" ]; then
    NODEJS_VERSION=`curl 'nodejs.org' | grep 'Current Version' | awk '{ print $3 }' | awk -F\< '{ print $1 }'`
fi

echo ">>> Installing Node.js version $NODEJS_VERSION"
echo "    This will also be set as the default node version"

# Install Node
nvm install $NODEJS_VERSION

# Set a default node version and start using it
nvm alias default $NODEJS_VERSION

nvm use default

echo ">>> Starting to config Node.js"

# Change where npm global packages location
npm config set prefix ~/npm

# Add new npm global packages location to PATH
printf "\n# Add new npm global packages location to PATH\n%s" 'export PATH=$PATH:~/npm/bin' >> ~/.bash_profile

# Add new npm root to NODE_PATH
printf "\n# Add the new npm root to NODE_PATH\n%s" 'export NODE_PATH=$NODE_PATH:~/npm/lib/node_modules' >> ~/.bash_profile
