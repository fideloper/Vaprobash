#!/usr/bin/env bash

# Set the install directory (/usr/local is fine for Ubuntu or Debian)
INSTALL_DIR=/usr/local

# Which version of Node.js do you wish to install?
NODEJS_VERSION=latest
## you can define an older version: NODEJS_VERSION=v0.10.22

# If set to latest, get the current node version from the home page
if [ "$NODEJS_VERSION" == "latest" ]; then
    NODEJS_VERSION=`curl 'nodejs.org' | grep 'Current Version' | awk '{ print $3 }' | awk -F\< '{ print $1 }'`
fi

echo ">>> Installing Node.js $NODEJS_VERSION"

# Current system architecture
PLATFORM=linux
ARCH=x`getconf LONG_BIT`

# Check if the version to be installed isn't already installed
if [[ "`type -p npm`" != "" ]]; then
    if [[ "`node --version`" == "$NODEJS_VERSION" ]]; then
        echo "The correct node version ($NODEJS_VERSION) is already installed"
        exit 1
    fi
fi

# Install Node.js - download binaries and uncompress them in the install dir
sudo curl http://nodejs.org/dist/$NODEJS_VERSION/node-$NODEJS_VERSION-$PLATFORM-$ARCH.tar.gz \
        | sudo tar xzvf - --strip-components=1 -C "$INSTALL_DIR"

# Change where npm global packages location
npm config set prefix ~/npm

# Add new npm global packages location to PATH
printf "\n# Add new npm global packages location to PATH\n%s" 'export PATH=$PATH:~/npm/bin' >> ~/.bash_profile

# Add new npm root to NODE_PATH
printf "\n# Add the new npm root to NODE_PATH\n%s" 'export NODE_PATH=$NODE_PATH:~/npm/lib/node_modules' >> ~/.bash_profile