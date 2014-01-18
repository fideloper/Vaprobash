#!/usr/bin/env bash

# Check if RVM is installed
RVM -v > /dev/null 2>&1
RVM_IS_INSTALLED=$?

if [[ $RVM_IS_INSTALLED -eq 0 ]]; then
    echo ">>> Updating Ruby Version Manager"
    rvm get stable --ignore-dotfiles
else
    # Install RVM and install Ruby
    if [[ -z $1 || $1 -eq "latest" ]]; then
        echo ">>> Installing Ruby Version Manager and installing latest stable Ruby version"

        # Install RVM and install latest stable Ruby version
        \curl -sSL https://get.rvm.io | bash -s stable --ruby
    else
        echo ">>> Installing Ruby Version Manager and installing Ruby version: $1"

        # Install RVM and install selected Ruby version
        \curl -sSL https://get.rvm.io | bash -s stable --ruby=$1
    fi

    # Reload .bash_profile and/or .zshrc if they exist
    if [[ -f "/home/vagrant/.bash_profile" ]]; then
        . /home/vagrant/.bash_profile
    fi

    if [[ -f "/home/vagrant/.zshrc" ]]; then
        . /home/vagrant/.zshrc
    fi
fi
