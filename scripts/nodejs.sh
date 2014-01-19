#!/usr/bin/env bash

echo ">>> Installing Node Version Manager"

# Install NVM
curl https://gist.github.com/Ilyes512/8335484/raw/nvm_install.sh | sh

# Re-source .bash_profile and .zshrc if they exist
if [[ -f "/home/vagrant/.bash_profile" ]]; then
    . /home/vagrant/.bash_profile
fi

if [[ -f "/home/vagrant/.zshrc" ]]; then
    . /home/vagrant/.zshrc
fi

# Find out what nodejs version should be installed
if [[ -z $1 ]]; then
    # Default is set to latest stable version
    NODEJS_VERSION=latest
else
    # Use user's defined nodejs version
    NODEJS_VERSION=$1
fi

# If set to latest, get the current node version from the home page
if [[ $NODEJS_VERSION -eq "latest" ]]; then
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
npm config set prefix /home/vagrant/npm

# Add new npm global packages location to PATH
printf "\n# Add new npm global packages location to PATH\n%s" 'export PATH=$PATH:~/npm/bin' >> /home/vagrant/.bash_profile

# Add new npm root to NODE_PATH
printf "\n# Add the new npm root to NODE_PATH\n%s" 'export NODE_PATH=$NODE_PATH:~/npm/lib/node_modules' >> /home/vagrant/.bash_profile
