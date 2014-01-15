#!/usr/bin/env bash

echo ">>> Installing Node Version Manager"

# Install NVM
curl https://gist.github.com/Ilyes512/8335484/raw/nvm_install.sh | sh

# Reload .bash_profile and/or .zshrc so you don't need to restart the terminal session
. ~/.bash_profile

. ~/.zshrc

# Contains all arguments that are passed
NODE_ARG=($@)

# Number of arguments that are given
NUMBER_OF_ARG=${#NODE_ARG[@]}

# Prepare the variables for installing specific Nodejs version and Global Node Packages
if [[ $NUMBER_OF_ARG -gt 1 ]]; then
    # Both Nodejs version and Global Node Packages are given
    NODEJS_VERSION=${NODE_ARG[0]}
    NODE_PACKAGES=${NODE_ARG[@]:1}
elif [[ $NUMBER_OF_ARG -eq 1 ]]; then
    # Only Nodejs version is given
    NODEJS_VERSION=$NODE_ARG
else
    # Default Nodejs version when nothing is given
    NODEJS_VERSION=latest
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

# Change where npm global packages are located
npm config set prefix ~/npm

# Add new NPM Global Packages location to PATH
printf "\n# Add new NPM global packages location to PATH\n%s" 'export PATH=$PATH:~/npm/bin' >> ~/.bash_profile

# Add new NPM root to NODE_PATH
printf "\n# Add the new NPM root to NODE_PATH\n%s" 'export NODE_PATH=$NODE_PATH:~/npm/lib/node_modules' >> ~/.bash_profile

# Install (optional) Global Node Packages
if [[ ! -z "$NODE_PACKAGES" ]]; then
    echo ">>> Start installing Global Node Packages"

    npm install -g ${NODE_PACKAGES[@]}
fi
