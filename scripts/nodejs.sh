#!/usr/bin/env bash

echo ">>> Adding PPA's and Installing Node.js"

# Add repo for latest Node.js
sudo add-apt-repository -y ppa:chris-lea/node.js

# Update
sudo apt-get update

# Install node.js
sudo apt-get install -y nodejs

# Change where npm global packages location
npm config set prefix ~/npm

# Add new npm global packages location to PATH
printf "\n# Add new npm global packages location to PATH\n%s" 'export PATH=$PATH:~/npm/bin' >> ~/.bash_profile

# Add new npm root to NODE_PATH and reload .bash_profile
printf "\n# Add the new npm root to NODE_PATH\n%s" 'export NODE_PATH=$NODE_PATH:~/npm/lib/node_modules' >> ~/.bash_profile && . ~/.bash_profile