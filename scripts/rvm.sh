#!/usr/bin/env bash

# Check if RVM is installed
RVM -v > /dev/null 2>&1
RVM_IS_INSTALLED=$?

# Contains all arguments that are passed
RUBY_ARG=($@)

# Number of arguments that are given
NUMBER_OF_ARG=${#RUBY_ARG[@]}

# Prepare the variables for installing specific Ruby version and Gems
if [[ $NUMBER_OF_ARG -gt 1 ]]; then
    # Both Ruby version and Gems are given
    RUBY_VERSION=${RUBY_ARG[0]} #RUBY_VERSION
    RUBY_GEMS=${RUBY_ARG[@]:1}
elif [[ $NUMBER_OF_ARG -eq 1 ]]; then
    # Only Ruby version is given
    RUBY_VERSION=$RUBY_ARG
else
    # Default Ruby version when nothing is given
    RUBY_VERSION=latest
fi

if [[ $RVM_IS_INSTALLED -eq 0 ]]; then
    echo ">>> Updating Ruby Version Manager"
    rvm get stable --ignore-dotfiles
else
    # Import Michal Papis' key to be able to verify the installation
    echo ">>> Importing rvm public key"
    gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3

    # Install RVM and install Ruby
    if [[ $RUBY_VERSION =~ "latest" ]]; then
        echo ">>> Installing Ruby Version Manager and installing latest stable Ruby version"

        # Install RVM and install latest stable Ruby version
        \curl -sSL https://get.rvm.io | bash -s stable --ruby
    else
        echo ">>> Installing Ruby Version Manager and installing Ruby version: $1"

        # Install RVM and install selected Ruby version
        \curl -sSL https://get.rvm.io | bash -s stable --ruby=$RUBY_VERSION
    fi

    # Re-source RVM
    . /home/vagrant/.rvm/scripts/rvm

    # Re-source .profile if exists
    if [[ -f "/home/vagrant/.profile" ]]; then
        . /home/vagrant/.profile
    fi
fi

# Install (optional) Ruby Gems
if [[ ! -z $RUBY_GEMS ]]; then
    echo ">>> Start installing Ruby Gems"

    gem install ${RUBY_GEMS[@]}
fi
