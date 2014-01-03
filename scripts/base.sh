#!/usr/bin/env bash

echo ">>> Installing Base Packages"

# Update
sudo apt-get update

# Install base packages
sudo apt-get install -y vim tmux curl wget build-essential python-software-properties