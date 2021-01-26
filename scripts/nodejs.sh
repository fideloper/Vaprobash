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

    echo ">>> Installing latest stable Node LTS - 10.X"
    
    sudo apt-get -f -y upgrade;
    sudo apt-get -f -y dist-upgrade;
    sudo apt-get -y install python-software-properties
    
    # Install NVM
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
    sudo apt-get update
    sudo apt-get -y install nodejs npm node-gyp
    
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

    # Install (optional) Global Node Packages

    echo ">>> Start installing Global Node Packages"

    sudo npm install -g grunt-cli --force; 
    sudo npm install -g gulp --force; 
    sudo npm install -g bower --force; 
    sudo npm install -g yarn --force; 
    sudo npm install -g gulp-concat-css --force; 
    sudo npm install -g gulp-minify-css --force; 
    sudo npm install -g gulp-clean-css --force; 
    sudo npm install -g gulp-rename --force; 
    sudo npm install -g gulp-ruby-sass --force; 
    sudo npm install -g gulp-sourcemaps --force; 
    sudo npm install -g gulp-uglify --force; 
    sudo npm install -g notify-send --force; 
    sudo npm install -g sw-precache-webpack-plugin --force; 
    sudo npm install -g cross-env --force; 
    sudo npm install -g laravel-mix --force; 
    sudo npm install -g laravel-elixir --force;

    # Re-source user profiles
    # if they exist
    source $PROFILE
    
    # Re-source .bashrc if exists
    source $BASHRC

fi

sudo apt -f -y autoremove --purge