#!/usr/bin/env bash

echo ">>> Installing Base Packages"

# Update
sudo apt-get update

# Install base packages
sudo apt-get install -y git-core vim tmux curl wget build-essential python-software-properties
